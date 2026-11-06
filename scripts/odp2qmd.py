#!/usr/bin/env python3
"""
odp2qmd.py — convierte una presentación de LibreOffice / PowerPoint en una
presentación Quarto + reveal.js que se edita en Neovim.

    python3 odp2qmd.py clase.odp            # crea ./clase/clase.qmd
    python3 odp2qmd.py clase.pptx -o dir    # .pptx/.ppt: se pasa antes a .odp
                                            # con LibreOffice (soffice)
    python3 odp2qmd.py clase.odp --fiel     # copia exacta de la composición

Por defecto (modo sencillo) cada diapositiva es markdown normal, sin
posiciones, con el tema de las presentaciones de clase (clase.scss):
    - el título es el "## Título";
    - el texto y las listas, tal cual; los cuadros que estaban uno al lado del
      otro van en columnas; los cuadros con fondo de color, en ::: {.caja},
      {.aviso} o {.gris}; el texto muy grande, en {.grande};
    - las imágenes se ajustan solas ({.r-stretch} o el ancho original); una
      imagen a pantalla completa va de fondo y se ve entera en cualquier
      pantalla;
    - las notas del ponente van en ::: notes.
    Carpeta de salida: <nombre>.qmd, img/, clase.scss y encajar.html (reduce
    la letra de una diapositiva si su contenido no cabe).

Con --fiel se conserva la composición original: cada cuadro queda en su sitio
con {.absolute} y un tema propio sacado del patrón (odp.scss, ajustar.html).
Se parece más al original, pero es más incómodo de editar.

Limitaciones: no se convierten las animaciones, las tablas ni las formas
dibujadas (salvo rectángulos con texto y líneas/flechas); los gráficos y
diagramas incrustados salen solo si el archivo trae su imagen de reserva.
"""

import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile
import xml.etree.ElementTree as ET
from pathlib import Path

NS = {
    "draw": "urn:oasis:names:tc:opendocument:xmlns:drawing:1.0",
    "svg": "urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0",
    "text": "urn:oasis:names:tc:opendocument:xmlns:text:1.0",
    "presentation": "urn:oasis:names:tc:opendocument:xmlns:presentation:1.0",
    "xlink": "http://www.w3.org/1999/xlink",
    "style": "urn:oasis:names:tc:opendocument:xmlns:style:1.0",
    "fo": "urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0",
    "office": "urn:oasis:names:tc:opendocument:xmlns:office:1.0",
    "loext": "urn:org:documentfoundation:names:experimental:office:xmlns:loext:1.0",
}

WIDTH_PX = 1280


def q(name):
    prefix, local = name.split(":")
    return "{%s}%s" % (NS[prefix], local)


def local(tag):
    return tag.split("}", 1)[1] if "}" in tag else tag


def length_cm(value, default=0.0):
    """'2.5cm', '25mm', '1in', '72pt' -> cm"""
    if not value:
        return default
    m = re.match(r"^\s*(-?[\d.]+)\s*(cm|mm|in|pt|px)?\s*$", value)
    if not m:
        return default
    n = float(m.group(1))
    unit = m.group(2) or "cm"
    return {"cm": n, "mm": n / 10, "in": n * 2.54, "pt": n * 2.54 / 72, "px": n * 2.54 / 96}[unit]


def pt(value):
    m = re.match(r"^\s*([\d.]+)\s*pt\s*$", value or "")
    return float(m.group(1)) if m else None


# ---------------------------------------------------------------------------
# Estilos
# ---------------------------------------------------------------------------


class Styles:
    """Estilos (automáticos y con nombre) con herencia por parent-style-name"""

    PROPS = ("graphic-properties", "paragraph-properties", "text-properties")

    def __init__(self):
        self.styles = {}  # (family, name) -> {"parent":..., "props": {...}}
        self.list_styles = {}  # name -> {level: {"bullet":..., ...}}
        self.default = {}  # family -> props

    def load(self, root):
        for st in root.iter(q("style:default-style")):
            fam = st.get(q("style:family"))
            self.default.setdefault(fam, {}).update(self._props(st))

        for st in root.iter(q("style:style")):
            fam = st.get(q("style:family"))
            name = st.get(q("style:name"))
            self.styles[(fam, name)] = {
                "parent": st.get(q("style:parent-style-name")),
                "props": self._props(st),
            }
            # listas definidas dentro de un estilo de presentación (patrón)
            for ls in st.iter(q("text:list-style")):
                self._list_style(ls, name)

        for ls in root.iter(q("text:list-style")):
            self._list_style(ls, ls.get(q("style:name")))

    def _list_style(self, ls, name):
        levels = {}
        for lv in ls:
            n = int(lv.get(q("text:level"), "1"))
            if local(lv.tag) == "list-level-style-bullet":
                levels[n] = {"bullet": lv.get(q("text:bullet-char"), "•")}
            elif local(lv.tag) == "list-level-style-number":
                levels[n] = {"number": lv.get(q("style:num-format"), "1")}
            else:
                levels[n] = {"none": True}
        self.list_styles.setdefault(name, levels)

    def _props(self, st):
        out = {}
        for child in st:
            if local(child.tag) in self.PROPS:
                for k, v in child.attrib.items():
                    out[local(k) if not k.startswith("{%s}" % NS["loext"]) else "lo-" + local(k)] = v
        return out

    def get(self, family, name, key, default=None):
        seen = set()
        while name and (family, name) not in seen:
            seen.add((family, name))
            st = self.styles.get((family, name))
            if not st:
                break
            if key in st["props"]:
                return st["props"][key]
            name = st["parent"]
        return self.default.get(family, {}).get(key, default)


# ---------------------------------------------------------------------------
# Texto -> markdown
# ---------------------------------------------------------------------------

MD_SPECIAL = re.compile(r"([\\`*_\[\]<>$|])")


def esc(text):
    text = MD_SPECIAL.sub(r"\\\1", text)
    return text


class Run:
    def __init__(self, text, bold=False, italic=False, color=None, size=None, href=None, underline=False):
        self.text = text
        self.bold = bold
        self.italic = italic
        self.color = color
        self.size = size
        self.href = href
        self.underline = underline


class Converter:
    def __init__(self, src, outdir, name, faithful=False):
        self.faithful = faithful
        self.src = Path(src)
        self.out = Path(outdir)
        self.name = name
        self.tmp = Path(tempfile.mkdtemp(prefix="odp2qmd-"))
        self.st = Styles()
        self.images = {}  # (href, clip) -> nombre en img/
        self.warnings = []

    # -- utilidades -----------------------------------------------------------

    def px(self, cm):
        return round(cm * self.scale)

    def fpx(self, ptsize):
        """tamaño de letra (pt) -> px en la diapositiva de 1280"""
        return round(ptsize * 2.54 / 72 * self.scale, 1)

    # -- entrada ----------------------------------------------------------------

    def load(self):
        with zipfile.ZipFile(self.src) as z:
            z.extractall(self.tmp)

        self.content = ET.parse(self.tmp / "content.xml").getroot()
        self.styles_root = ET.parse(self.tmp / "styles.xml").getroot()
        self.st.load(self.styles_root)
        self.st.load(self.content)

        # tamaño de página: el del diseño del patrón de la primera diapositiva
        first = next(self.content.iter(q("draw:page")), None)
        master = first.get(q("draw:master-page-name")) if first is not None else None
        layout_name = None
        for mp in self.styles_root.iter(q("style:master-page")):
            if mp.get(q("style:name")) == master:
                layout_name = mp.get(q("style:page-layout-name"))
        layout = None
        for pl in self.styles_root.iter(q("style:page-layout")):
            if layout_name is None or pl.get(q("style:name")) == layout_name:
                layout = pl.find(q("style:page-layout-properties"))
                break
        self.page_w = length_cm(layout.get(q("fo:page-width")) if layout is not None else None, 28)
        self.page_h = length_cm(layout.get(q("fo:page-height")) if layout is not None else None, 15.75)
        self.scale = WIDTH_PX / self.page_w
        self.height_px = round(self.page_h * self.scale)

    # -- patrón ---------------------------------------------------------------

    def master_info(self, master_name):
        info = {"title_box": None, "background": None, "background_src": None, "overlay": None, "background_color": None}
        for mp in self.styles_root.iter(q("style:master-page")):
            if mp.get(q("style:name")) != master_name:
                continue
            for el in mp:
                tag = local(el.tag)
                x = length_cm(el.get(q("svg:x")))
                y = length_cm(el.get(q("svg:y")))
                w = length_cm(el.get(q("svg:width")))
                h = length_cm(el.get(q("svg:height")))
                full = w >= self.page_w * 0.95 and h >= self.page_h * 0.95
                if tag == "frame" and el.get(q("presentation:class")) == "title":
                    info["title_box"] = (x, y, w, h)
                elif tag == "frame" and full:
                    img = el.find(q("draw:image"))
                    if img is not None:
                        info["background_src"] = img.get(q("xlink:href"))
                elif tag in ("custom-shape", "rect") and full:
                    sname = el.get(q("draw:style-name"))
                    if self.st.get("graphic", sname, "fill") == "solid":
                        color = self.st.get("graphic", sname, "fill-color", "#ffffff")
                        op = self.st.get("graphic", sname, "opacity", "100%")
                        info["overlay"] = (color, float(op.rstrip("%")) / 100)
            if not info["background_src"]:
                # fondo de color del patrón
                dp = mp.get(q("draw:style-name"))
                if self.st.get("drawing-page", dp, "fill") == "solid":
                    info["background_color"] = self.st.get("drawing-page", dp, "fill-color")
        if info["background_src"] and self.faithful:
            info["background"] = self.background(info["background_src"], info["overlay"], master_name)
        return info

    def background(self, href, overlay, master):
        """Imagen de fondo del patrón con su velo (p. ej. blanco al 80 %) ya aplicado"""
        src = self.tmp / href
        if not src.exists():
            return None
        (self.out / "img").mkdir(parents=True, exist_ok=True)
        dst = self.out / "img" / ("fondo%s.jpg" % ("" if not self.masters else "_" + re.sub(r"\W+", "", master)))
        size = "%dx%d^" % (WIDTH_PX, self.height_px)
        cmd = ["convert", str(src), "-resize", size, "-gravity", "center", "-extent", "%dx%d" % (WIDTH_PX, self.height_px)]
        if overlay:
            color, alpha = overlay
            cmd += ["(", "-size", "%dx%d" % (WIDTH_PX, self.height_px), "xc:" + color, "-alpha", "set",
                    "-channel", "A", "-evaluate", "set", "%d%%" % round(alpha * 100), "+channel", ")",
                    "-composite"]
        cmd += ["-quality", "85", str(dst)]
        if not shutil.which("convert") or subprocess.run(cmd, capture_output=True).returncode != 0:
            shutil.copyfile(src, dst.with_suffix(src.suffix))
            dst = dst.with_suffix(src.suffix)
            self.warnings.append("sin ImageMagick: el fondo va sin el velo del patrón")
        return "img/" + dst.name

    # -- imágenes ---------------------------------------------------------------

    def image(self, href, clip):
        """Copia la imagen a img/ (recortada si hace falta) y devuelve su ruta"""
        if not href or href.startswith("http"):
            return href
        key = (href, clip or "")
        if key in self.images:
            return self.images[key]

        src = self.tmp / href
        if not src.exists():
            self.warnings.append("imagen no encontrada: " + href)
            return None

        (self.out / "img").mkdir(parents=True, exist_ok=True)
        stem = "img%02d" % (len(self.images) + 1)
        dst = self.out / "img" / (stem + src.suffix.lower())

        crop = self.crop_box(src, clip)
        if crop and shutil.which("convert"):
            w, h, x, y = crop
            subprocess.run(["convert", str(src), "-crop", "%dx%d+%d+%d" % (w, h, x, y), "+repage", str(dst)], check=False)
        if not dst.exists():
            shutil.copyfile(src, dst)

        rel = "img/" + dst.name
        self.images[key] = rel
        return rel

    def crop_box(self, src, clip):
        m = re.match(r"rect\(([^,]+),([^,]+),([^,]+),([^)]+)\)", (clip or "").replace(" ", ""))
        if not m or not shutil.which("identify"):
            return None
        top, right, bottom, left = (length_cm(v) for v in m.groups())
        if max(top, right, bottom, left) <= 0:
            return None
        info = subprocess.run(
            ["identify", "-format", "%w %h %x %y %U\n", str(src) + "[0]"], capture_output=True, text=True
        ).stdout.split()
        if len(info) < 5:
            return None
        wpx, hpx = int(info[0]), int(info[1])
        # sin resolución en el archivo LibreOffice usa 96 ppp
        dpi = 96.0
        if info[4] == "PixelsPerInch":
            dpi = float(info[2])
        elif info[4] == "PixelsPerCentimeter":
            dpi = float(info[2]) * 2.54
        wcm, hcm = wpx / dpi * 2.54, hpx / dpi * 2.54
        x = round(left / wcm * wpx)
        y = round(top / hcm * hpx)
        w = round((wcm - left - right) / wcm * wpx)
        h = round((hcm - top - bottom) / hcm * hpx)
        if w <= 0 or h <= 0:
            return None
        return w, h, x, y

    # -- texto -----------------------------------------------------------------

    def text_props(self, tstyle, base):
        r = dict(base)
        if not tstyle:
            return r
        weight = self.st.get("text", tstyle, "font-weight")
        if weight:
            r["bold"] = weight == "bold" or weight.isdigit() and int(weight) >= 600
        style = self.st.get("text", tstyle, "font-style")
        if style:
            r["italic"] = style == "italic"
        color = self.st.get("text", tstyle, "color")
        if color and self.st.get("text", tstyle, "use-window-font-color") != "true":
            r["color"] = color
        size = pt(self.st.get("text", tstyle, "font-size"))
        if size:
            r["size"] = size
        und = self.st.get("text", tstyle, "text-underline-style")
        if und:
            r["underline"] = und != "none"
        return r

    def runs(self, el, props, href=None):
        out = []
        if el.text:
            out.append(Run(el.text, href=href, **props))
        for ch in el:
            tag = local(ch.tag)
            if tag == "span":
                out += self.runs(ch, self.text_props(ch.get(q("text:style-name")), props), href)
            elif tag == "a":
                out += self.runs(ch, props, ch.get(q("xlink:href")))
            elif tag == "s":
                out.append(Run(" " * int(ch.get(q("text:c"), "1")), href=href, **props))
            elif tag == "tab":
                out.append(Run(" ", href=href, **props))
            elif tag == "line-break":
                out.append(Run("\n", href=href, **props))
            else:
                out += self.runs(ch, props, href)
            if ch.tail:
                out.append(Run(ch.tail, href=href, **props))
        return out

    def md_runs(self, runs, base_size):
        """Lista de Run -> markdown en una línea (con <br> para los saltos)"""
        # juntar trozos con el mismo formato
        merged = []
        for r in runs:
            if r.text == "":
                continue
            key = (r.bold, r.italic, r.color, r.size, r.href, r.underline)
            if merged and merged[-1][0] == key and r.text != "\n" and merged[-1][1] != "\n":
                merged[-1][1] += r.text
            else:
                merged.append([key, r.text])

        out = ""
        links = {}
        for (bold, italic, color, size, href, underline), text in merged:
            if text == "\n":
                out += "<br>"
                continue
            lead = text[: len(text) - len(text.lstrip())]
            trail = text[len(text.rstrip()):]
            core = text.strip()
            if not core:
                out += " " if text else ""
                continue
            s = esc(core)
            if href:
                # un enlace que muestra su propia dirección
                if core == href or core.rstrip("/") == href.rstrip("/"):
                    s = "<" + href + ">"
                else:
                    s = "[" + s + "](" + href + ")"
            css = []
            if color and color.lower() not in ("#000000",) and not href:
                css.append("color: " + color)
            if self.faithful and size and base_size and abs(size - base_size) / base_size > 0.12:
                css.append("font-size: %gpx" % self.fpx(size))
            if underline and not href:
                css.append("text-decoration: underline")
            if italic:
                s = "*" + s + "*"
            if bold:
                s = "**" + s + "**"
            if css:
                s = "[" + s + ']{style="' + "; ".join(css) + '"}'
            out += lead.replace("\n", "") + s + trail.replace("\n", "")
        return re.sub(r"\s{2,}", " ", out).strip()

    def paragraph(self, p, base_props, base_size):
        pstyle = p.get(q("text:style-name"))
        props = self.text_props(pstyle, base_props) if pstyle else dict(base_props)
        # el estilo de párrafo puede tener propiedades de texto (familia paragraph)
        if pstyle:
            for key, attr in (("bold", "font-weight"), ("italic", "font-style"), ("color", "color")):
                v = self.st.get("paragraph", pstyle, attr)
                if v:
                    props[key] = (v == "bold") if key == "bold" else (v == "italic") if key == "italic" else v
            s = pt(self.st.get("paragraph", pstyle, "font-size"))
            if s:
                props["size"] = s
        align = self.st.get("paragraph", pstyle, "text-align") if pstyle else None
        runs = self.runs(p, props)
        sizes = [r.size for r in runs if r.text.strip() and r.size]
        return self.md_runs(runs, base_size), align, sizes, runs

    def blocks(self, el, base_props, base_size, list_style=None, level=0, level_size=None):
        """Elementos de un cuadro de texto -> lista de (nivel, markdown, align, sizes)

        level_size(nivel): en los cuadros de esquema cada nivel tiene su tamaño
        (el del patrón); solo los trozos con otro tamaño lo llevan en línea."""
        out = []
        for ch in el:
            tag = local(ch.tag)
            if tag in ("p", "h"):
                size = level_size(max(level, 1)) if level_size else base_size
                props = dict(base_props, size=size) if level_size else base_props
                md, align, sizes, _ = self.paragraph(ch, props, size)
                out.append({"level": level, "md": md, "align": align, "sizes": sizes, "list": list_style if level else None})
            elif tag == "list":
                ls = ch.get(q("text:style-name")) or list_style
                out += self.blocks(ch, base_props, base_size, ls, level + 1, level_size)
            elif tag in ("list-item", "list-header"):
                out += self.blocks(ch, base_props, base_size, list_style, level, level_size)
        return out

    # -- diapositivas -------------------------------------------------------------

    def frame_style(self, fr):
        """Estilo de un cuadro: (familia, nombre)"""
        if fr.get(q("presentation:style-name")):
            return "presentation", fr.get(q("presentation:style-name"))
        return "graphic", fr.get(q("draw:style-name"))

    def box_css(self, fam, sname, has_text):
        css = []
        fill = self.st.get(fam, sname, "fill")
        if fill == "solid":
            color = self.st.get(fam, sname, "fill-color", "#ffffff")
            op = self.st.get(fam, sname, "opacity")
            if op and op != "100%":
                a = float(op.rstrip("%")) / 100
                r, g, b = (int(color[i : i + 2], 16) for i in (1, 3, 5))
                css.append("background: rgba(%d, %d, %d, %.2f)" % (r, g, b, a))
            else:
                css.append("background: " + color)
        stroke = self.st.get(fam, sname, "stroke")
        if stroke and stroke != "none":
            sw = max(1, self.px(length_cm(self.st.get(fam, sname, "stroke-width"), 0.02)))
            css.append("border: %dpx solid %s" % (sw, self.st.get(fam, sname, "stroke-color", "#000000")))
        if has_text:
            pads = [length_cm(self.st.get(fam, sname, "padding-" + side), d) for side, d in
                    (("top", 0.125), ("right", 0.25), ("bottom", 0.125), ("left", 0.25))]
            css.append("padding: " + " ".join("%dpx" % self.px(p) for p in pads))
            va = self.st.get(fam, sname, "textarea-vertical-align")
            if va in ("middle", "bottom"):
                css.append("display: flex; flex-direction: column; justify-content: " + ("center" if va == "middle" else "flex-end"))
        return css

    def outline_size(self, master, level):
        """Tamaño de letra (pt) del nivel de esquema del patrón"""
        for n in range(max(level, 1), 0, -1):
            s = pt(self.st.get("presentation", "%s-outline%d" % (master, n), "font-size"))
            if s:
                return s
        return 24.0

    def text_box(self, fr, tb, master, cls):
        """Cuadro de texto -> (líneas markdown, tamaño de letra en pt, alineación)"""
        fam, sname = self.frame_style(fr)
        frame_align = self.st.get(fam, sname, "text-align")
        base_size = pt(self.st.get(fam, sname, "font-size"))
        if not base_size:
            base_size = pt(self.st.get("graphic", "standard", "font-size")) or 18.0
        props = {"bold": None, "italic": None, "color": None, "size": base_size, "underline": None}
        w = self.st.get(fam, sname, "font-weight")
        if w:
            props["bold"] = w == "bold"
        c = self.st.get(fam, sname, "color")
        if c and self.st.get(fam, sname, "use-window-font-color") != "true":
            props["color"] = c

        if cls == "outline":
            # cada nivel con el tamaño del patrón: el cuadro lleva el del
            # nivel 1 y el tema reduce los niveles 2 y 3 en la misma proporción
            blocks = self.blocks(tb, props, None, level_size=lambda lv: self.outline_size(master, lv))
            lines, align = self.box_lines(blocks, frame_align)
            return lines, self.outline_size(master, 1), align

        # tamaño dominante del cuadro; los trozos con otro tamaño van en línea
        blocks = self.blocks(tb, props, base_size)
        sizes = {}
        for b in blocks:
            for sz in b["sizes"]:
                sizes[sz] = sizes.get(sz, 0) + 1
        dominant = max(sizes, key=sizes.get) if sizes else base_size
        blocks = self.blocks(tb, dict(props, size=dominant), dominant)
        lines, align = self.box_lines(blocks, frame_align)
        return lines, dominant, align

    def box_lines(self, blocks, frame_align=None):
        """Bloques -> (líneas markdown, alineación común del cuadro)"""
        aligns = {b["align"] or frame_align for b in blocks if b["md"]}
        common_align = aligns.pop() if len(aligns) == 1 else None
        lines = []
        prev_list = False
        for b in blocks:
            md = b["md"]
            align = b["align"] or frame_align
            if b["level"] > 0 and b["list"] is not None:
                lv = self.st.list_styles.get(b["list"], {}).get(b["level"], {})
                if lv.get("none"):
                    if md:
                        lines += [md, ""]
                    prev_list = False
                    continue
                marker = "1." if "number" in lv else "-"
                indent = ("  " if marker == "-" else "   ") * (b["level"] - 1)
                if not prev_list and lines and lines[-1] != "":
                    lines.append("")
                # un elemento vacío se conserva (huecos para completar en clase)
                lines.append(indent + marker + " " + (md or "&nbsp;"))
                prev_list = True
            else:
                if prev_list:
                    lines.append("")
                    prev_list = False
                if not md:
                    if lines and lines[-1] not in ("&nbsp;",):
                        lines += ["&nbsp;", ""]
                    continue
                if align and align != common_align:
                    css_align = {"center": "center", "end": "right", "right": "right", "justify": "justify",
                                 "start": "left", "left": "left"}.get(align)
                    if css_align:
                        md = "[" + md + ']{style="display: block; text-align: ' + css_align + '"}'
                lines += [md, ""]
        while lines and lines[-1] in ("", "&nbsp;"):
            lines.pop()
        while lines and lines[0] in ("", "&nbsp;"):
            lines.pop(0)
        return lines, common_align

    def line_svg(self, el):
        x1, y1 = self.px(length_cm(el.get(q("svg:x1")))), self.px(length_cm(el.get(q("svg:y1"))))
        x2, y2 = self.px(length_cm(el.get(q("svg:x2")))), self.px(length_cm(el.get(q("svg:y2"))))
        sname = el.get(q("draw:style-name"))
        color = self.st.get("graphic", sname, "stroke-color", "#3465a4")
        width = max(2, self.px(length_cm(self.st.get("graphic", sname, "stroke-width"), 0.05)))
        arrow_end = bool(self.st.get("graphic", sname, "marker-end"))
        arrow_start = bool(self.st.get("graphic", sname, "marker-start"))
        pad = 20
        left, top = min(x1, x2) - pad, min(y1, y2) - pad
        w, h = abs(x2 - x1) + 2 * pad, abs(y2 - y1) + 2 * pad
        mid = "m%d" % id(el)
        marker = (
            '<defs><marker id="%s" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="5" markerHeight="5" '
            'orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" fill="%s"/></marker></defs>' % (mid, color)
        )
        attrs = ""
        if arrow_end:
            attrs += ' marker-end="url(#%s)"' % mid
        if arrow_start:
            attrs += ' marker-start="url(#%s)"' % mid
        return (
            '<svg class="linea" style="position: absolute; left: %dpx; top: %dpx" width="%d" height="%d">%s'
            '<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="%s" stroke-width="%d"%s/></svg>'
            % (left, top, w, h, marker if (arrow_end or arrow_start) else "", x1 - left, y1 - top, x2 - left, y2 - top, color, width, attrs)
        )

    def notes(self, page):
        nt = page.find(q("presentation:notes"))
        if nt is None:
            return []
        lines = []
        for fr in nt.iter(q("draw:frame")):
            if fr.get(q("presentation:class")) != "notes":
                continue
            for tb in fr.iter(q("draw:text-box")):
                for b in self.blocks(tb, {"bold": None, "italic": None, "color": None, "size": None, "underline": None}, None):
                    if b["md"]:
                        lines.append(("- " if b["level"] else "") + b["md"])
        return lines

    def find_title(self, page):
        """Cuadro de título de la diapositiva -> (frame, texto, estilo) o None

        Es el primer cuadro "title" que está donde el del patrón (arriba y casi
        a todo lo ancho). El estilo (relleno, letra, posición) sale del propio
        cuadro: en los .pptx convertidos el patrón no lo tiene."""
        master = page.get(q("draw:master-page-name"))
        minfo = self.masters.setdefault(master, self.master_info(master))
        tbox = minfo["title_box"] or (1.4, 0.628, 25.2, 2.63)

        for fr in page:
            if local(fr.tag) != "frame" or fr.get(q("presentation:class")) != "title":
                continue
            x = length_cm(fr.get(q("svg:x")))
            y = length_cm(fr.get(q("svg:y")))
            w = length_cm(fr.get(q("svg:width")))
            h = length_cm(fr.get(q("svg:height")))
            if abs(y - tbox[1]) >= 1.0 or w <= tbox[2] * 0.8:
                continue

            fam, sname = self.frame_style(fr)
            empty = {"bold": None, "italic": None, "color": None, "size": None, "underline": None}
            tb = fr.find(q("draw:text-box"))
            paras = list(tb.iter(q("text:p"))) if tb is not None else []
            runs = [self.runs(p_, empty) for p_ in paras]
            visible = [r for rr in runs for r in rr if r.text.strip()]

            def common(values, default):
                values = [v for v in values if v is not None]
                return max(set(values), key=values.count) if values else default

            size = common([r.size for r in visible], pt(self.st.get(fam, sname, "font-size")) or 40.0)
            bold = common([r.bold for r in visible], self.st.get(fam, sname, "font-weight") == "bold")
            color = common([r.color for r in visible], None)
            if color is None and self.st.get(fam, sname, "use-window-font-color") != "true":
                color = self.st.get(fam, sname, "color")
            align = common([self.st.get("paragraph", p_.get(q("text:style-name")), "text-align") for p_ in paras
                            if p_.get(q("text:style-name"))], self.st.get(fam, sname, "text-align") or "center")
            fill = self.st.get(fam, sname, "fill-color", "#ffffff") if self.st.get(fam, sname, "fill") == "solid" else "transparent"

            # el formato común (negrita, color, tamaño) lo pone la banda del
            # título; en el texto solo queda lo que se sale de lo común
            for r in (r for rr in runs for r in rr):
                if r.bold == bold:
                    r.bold = None
                if r.color == color:
                    r.color = None
                if r.size == size:
                    r.size = None
            text = " ".join(t for t in (self.md_runs(r, size) for r in runs) if t)

            style = (
                round(self.px(x)), round(self.px(y)), round(self.px(w)), round(self.px(h)),
                fill, color or "#000000", self.fpx(size), bool(bold),
                {"end": "right", "start": "left"}.get(align, align),
            )
            return fr, text, style
        return None

    def slide(self, page, index, title, title_class=None):
        master = page.get(q("draw:master-page-name"))
        minfo = self.masters.setdefault(master, self.master_info(master))

        attrs = [title_class] if title_class else []
        body = []

        frames = [el for el in page if local(el.tag) in ("frame", "line", "custom-shape", "rect")]

        for fr in frames:
            if title and fr is title[0]:
                continue
            tag = local(fr.tag)
            if tag == "line":
                body.append(self.line_svg(fr))
                body.append("")
                continue

            x = length_cm(fr.get(q("svg:x")))
            y = length_cm(fr.get(q("svg:y")))
            w = length_cm(fr.get(q("svg:width")))
            h = length_cm(fr.get(q("svg:height")))
            cls = fr.get(q("presentation:class"))
            fam, sname = self.frame_style(fr)
            geo = "left=%d top=%d width=%d height=%d" % (self.px(x), self.px(y), self.px(w), self.px(h))

            img = fr.find(q("draw:image"))
            if tag == "frame" and img is not None and img.get(q("xlink:href")):
                href = img.get(q("xlink:href"))
                if href.startswith("./"):
                    href = href[2:]
                # incrustados (gráficos, OLE): su imagen de reserva
                if not href.startswith("Pictures/"):
                    fallback = [i for i in fr.findall(q("draw:image")) if (i.get(q("xlink:href")) or "").startswith("Pictures/")]
                    if fallback:
                        href = fallback[0].get(q("xlink:href"))
                    else:
                        self.warnings.append("diapositiva %d: objeto incrustado sin imagen (%s)" % (index, href))
                        continue
                path = self.image(href, self.st.get("graphic", sname, "clip"))
                if not path:
                    continue
                full = w >= self.page_w * 0.95 and h >= self.page_h * 0.95
                if full:
                    attrs += ['background-image="%s"' % path, 'background-size="cover"']
                else:
                    body.append("![](%s){.absolute %s}" % (path, geo))
                    body.append("")
                continue

            tb = fr.find(q("draw:text-box")) if tag == "frame" else fr
            if tb is None:
                continue
            lines, size, align = self.text_box(fr, tb, master, cls)
            css = self.box_css(fam, sname, bool(lines))
            if not lines and not any(c.startswith("background") or c.startswith("border") for c in css):
                continue  # marcador vacío
            css.append("font-size: %gpx" % self.fpx(size))
            if align in ("center", "end", "right", "justify"):
                css.append("text-align: " + {"end": "right"}.get(align, align))
            # posición dentro de style: Quarto descarta left/top/... si hay style
            pos = "left: %dpx; top: %dpx; width: %dpx; height: %dpx" % (self.px(x), self.px(y), self.px(w), self.px(h))
            klass = ".absolute .caja" + (" .esquema" if cls == "outline" else "")
            body.append("::: {%s style=\"%s; %s\"}" % (klass, pos, "; ".join(css)))
            body += lines if lines else ["&nbsp;"]
            body.append(":::")
            body.append("")

        if not any(a.startswith("background-") for a in attrs):
            if minfo["background"]:
                attrs.append('background-image="%s"' % minfo["background"])
            elif minfo["background_color"]:
                attrs.append('background-color="%s"' % minfo["background_color"])

        heading = "## " + (title[1] if title and title[1] else "")
        if not title:
            attrs.insert(0, ".sin-titulo")
        if attrs:
            heading += (" " if title and title[1] else "") + "{" + " ".join(attrs) + "}"

        out = [heading, ""] + body
        notes = self.notes(page)
        out += ["::: notes"] + (notes if notes else [""]) + [":::", ""]
        return out

    # -- modo sencillo -----------------------------------------------------------

    # cuadros del tema clase.scss: color de referencia -> clase
    BOX_CLASSES = (("caja", (0xD1, 0xE4, 0xF7)), ("aviso", (0xF0, 0xD4, 0xEE)), ("gris", (0xE6, 0xE8, 0xEB)))

    def box_class(self, color):
        """Color de relleno -> la clase de cuadro del tema que más se le parece"""
        try:
            rgb = tuple(int(color[i : i + 2], 16) for i in (1, 3, 5))
        except (TypeError, ValueError):
            return "caja"
        # gris si no tiene color (r, g y b parecidos)
        if max(rgb) - min(rgb) < 25:
            return "gris"
        return min(self.BOX_CLASSES, key=lambda c: sum((a - b) ** 2 for a, b in zip(rgb, c[1])))[0]

    def elements(self, page, title):
        """Cuadros de texto e imágenes de la diapositiva (sin el título)"""
        master = page.get(q("draw:master-page-name"))
        body_size = self.outline_size(master, 1)
        out = []
        background = None
        for fr in page:
            tag = local(fr.tag)
            if tag not in ("frame", "custom-shape", "rect") or (title and fr is title[0]):
                continue
            x = length_cm(fr.get(q("svg:x")))
            y = length_cm(fr.get(q("svg:y")))
            w = length_cm(fr.get(q("svg:width")))
            h = length_cm(fr.get(q("svg:height")))
            cls = fr.get(q("presentation:class"))
            fam, sname = self.frame_style(fr)

            img = fr.find(q("draw:image"))
            if tag == "frame" and img is not None and img.get(q("xlink:href")):
                href = img.get(q("xlink:href")).lstrip("./")
                if not href.startswith("Pictures/"):
                    fallback = [i for i in fr.findall(q("draw:image")) if (i.get(q("xlink:href")) or "").startswith("Pictures/")]
                    if not fallback:
                        continue
                    href = fallback[0].get(q("xlink:href"))
                path = self.image(href, self.st.get("graphic", sname, "clip"))
                if not path:
                    continue
                if w >= self.page_w * 0.95 and h >= self.page_h * 0.95:
                    background = path
                else:
                    out.append({"kind": "img", "x": x, "y": y, "w": w, "h": h, "path": path})
                continue

            tb = fr.find(q("draw:text-box")) if tag == "frame" else fr
            if tb is None:
                continue
            lines, size, align = self.text_box(fr, tb, master, cls)
            if not lines:
                continue
            classes = []
            if self.st.get(fam, sname, "fill") == "solid":
                classes.append(self.box_class(self.st.get(fam, sname, "fill-color", "#ffffff")))
            words = sum(len(l.split()) for l in lines)
            if cls != "outline" and size and size >= body_size * 1.3 and words <= 25:
                classes.append("grande")
            if align == "center" and not any(l.lstrip().startswith(("- ", "1.")) for l in lines):
                classes.append("centrado")
            out.append({"kind": "text", "x": x, "y": y, "w": w, "h": h, "lines": lines, "classes": classes})
        return out, background

    @staticmethod
    def rows(elements):
        """Agrupa en filas los elementos que están uno al lado del otro"""
        rows = []
        for el in sorted(elements, key=lambda e: (e["y"], e["x"])):
            placed = False
            for row in rows:
                top = min(e["y"] for e in row)
                bottom = max(e["y"] + e["h"] for e in row)
                overlap = min(bottom, el["y"] + el["h"]) - max(top, el["y"])
                side = all(el["x"] >= e["x"] + e["w"] - 0.3 or el["x"] + el["w"] <= e["x"] + 0.3 for e in row)
                if side and overlap > 0.3 * min(el["h"], bottom - top):
                    row.append(el)
                    placed = True
                    break
            if not placed:
                rows.append([el])
        for row in rows:
            row.sort(key=lambda e: e["x"])
        return rows

    def render_element(self, el, stretch=False, alone=False):
        if el["kind"] == "img":
            if stretch:
                return ["![](%s){fig-align=\"center\" .r-stretch}" % el["path"]]
            # sola en su fila: el mismo ancho relativo que en el original
            width = ' width="%d%%"' % min(100, round(el["w"] / self.page_w * 100)) if alone else ""
            return ["![](%s){fig-align=\"center\"%s}" % (el["path"], width)]
        if el["classes"]:
            return ["::: {%s}" % " ".join("." + c for c in el["classes"])] + el["lines"] + [":::"]
        return el["lines"]

    def slide_simple(self, page, index, title, count):
        elements, background = self.elements(page, title)
        attrs = []
        if background:
            attrs += ['background-image="%s"' % background, 'background-size="contain"', 'background-color="black"']

        text = title[1] if title and title[1] else ""
        portada = not text and not background and (index in (1, count)) and elements
        if portada:
            attrs.insert(0, ".portada")
        elif not text:
            attrs.insert(0, ".sin-titulo")

        heading = "## " + text
        if attrs:
            heading += (" " if text else "") + "{" + " ".join(attrs) + "}"
        out = [heading, ""]

        rows = self.rows(elements)
        for r, row in enumerate(rows):
            if portada:
                for el in row:
                    if el["kind"] == "text" and any(c in ("caja", "aviso", "gris") for c in el["classes"]):
                        el["classes"] = ["titulo"]
                    elif el["kind"] == "text":
                        el["classes"] = [c for c in el["classes"] if c != "grande"]
            if len(row) == 1:
                last = r == len(rows) - 1
                out += self.render_element(row[0], stretch=last and row[0]["kind"] == "img", alone=True)
                out.append("")
                continue
            total = sum(e["w"] for e in row) or 1
            out.append(":::: {.columns}")
            out.append("")
            for el in row:
                out.append('::: {.column width="%d%%"}' % max(10, round(el["w"] / total * 100)))
                out += self.render_element(el)
                out.append(":::")
                out.append("")
            out.append("::::")
            out.append("")

        notes = self.notes(page)
        out += ["::: notes"] + (notes if notes else [""]) + [":::", ""]
        return out

    # -- salida ----------------------------------------------------------------

    @staticmethod
    def title_css(style):
        x, y, w, h, fill, color, size, bold, align = style
        just = {"left": "flex-start", "right": "flex-end"}.get(align, "center")
        return (
            "  left: %dpx;\n  top: %dpx;\n  width: %dpx;\n  height: %dpx;\n  background: %s;\n"
            "  color: %s;\n  font-size: %gpx;\n  font-weight: %s;\n  justify-content: %s;\n  text-align: %s;\n"
            % (x, y, w, h, fill, color, size, "bold" if bold else "normal", just, align)
        )

    def theme(self, master, base_title, variants):
        tstyle = master + "-title"
        tcolor = base_title[5]
        font = (self.st.get("presentation", tstyle, "font-family")
                or self.st.get("presentation", master + "-outline1", "font-family") or "Liberation Sans").strip("'")
        outline = [self.outline_size(master, n) for n in (1, 2, 3, 4)]
        extra = "".join(
            "\n.reveal .slides section.%s h2 {\n%s}\n" % (cls, self.title_css(st))
            for st, cls in variants
        )

        bg = ""

        return """/*-- scss:defaults --*/
// Tema generado por odp2qmd.py a partir del patrón de diapositivas.
$font-family-sans-serif: "{font}", "Liberation Sans", Arial, Helvetica, sans-serif;
$presentation-heading-font: $font-family-sans-serif;
$presentation-font-size-root: {s1}px;
$presentation-heading-color: {tcolor};
$body-bg: #ffffff;
$body-color: #000000;
$link-color: #000080;
$presentation-heading-text-transform: none;
$presentation-heading-letter-spacing: normal;

/*-- scss:rules --*/

// Cada cuadro está colocado con .absolute: sin centrado ni márgenes de reveal
.reveal .slides section {{
  padding: 0;
}}

// Título: la banda del patrón
.reveal .slides section h2 {{
  position: absolute;
  margin: 0;
  padding: 0 {tpad}px;
  box-sizing: border-box;
  display: flex;
  align-items: center;
  line-height: 1.1;
  text-transform: none;
{tcss}}}
{extra}
.reveal .slides section.sin-titulo h2,
.reveal .slides section h2:empty {{
  display: none;
}}

// Cuadros de texto (los de la diapositiva original)
.reveal .caja {{
  box-sizing: border-box;
  overflow: visible;
  line-height: 1.15;
}}

.reveal .caja p {{
  margin: 0 0 0.1em;
  line-height: 1.15;
}}

.reveal .caja ul,
.reveal .caja ol {{
  display: block;
  margin: 0 0 0 1.1em;
  padding: 0;
}}

.reveal .caja li {{
  margin: 0.1em 0 0;
  padding-left: 0.2em;
  line-height: 1.15;
}}

// Cuadros de esquema (los del patrón): separación entre puntos como en el original
.reveal .caja.esquema li {{
  margin-top: 0.4em;
}}

.reveal .caja.esquema > ul:first-child > li:first-child {{
  margin-top: 0;
}}

.reveal .caja li > ul,
.reveal .caja li > ol {{
  margin-left: 1.2em;
  font-size: {r2}em;
}}

.reveal .caja li > ul li > ul,
.reveal .caja li > ol li > ol {{
  font-size: {r3}em;
}}

.reveal .caja ul > li::marker {{ content: "● "; font-size: 0.6em; }}
.reveal .caja ul ul > li::marker {{ content: "– "; font-size: 1em; }}
.reveal .caja ul ul ul > li::marker {{ content: "● "; font-size: 0.6em; }}

.reveal .caja a {{
  color: #000080;
  text-decoration: underline;
  word-break: break-all;
}}

.reveal .slides section img {{
  margin: 0;
  max-width: none;
  max-height: none;
  object-fit: fill;
}}

.reveal svg.linea {{
  overflow: visible;
  pointer-events: none;
}}

{bg}""".format(
            font=font,
            s1=round(self.fpx(outline[0])),
            tcolor=tcolor,
            tpad=self.px(0.25), tcss=self.title_css(base_title), extra=extra,
            r2=round(outline[1] / outline[0], 3), r3=round(outline[2] / outline[1], 3),
            bg=bg,
        )

    def run(self):
        self.load()
        self.out.mkdir(parents=True, exist_ok=True)
        self.masters = {}

        pages = list(self.content.iter(q("draw:page")))
        if not pages:
            sys.exit("No hay diapositivas en " + str(self.src))

        # títulos: el estilo más repetido va en el tema; los demás, con una clase
        titles = [self.find_title(page) for page in pages]
        styles = [t[2] for t in titles if t]
        base = max(set(styles), key=styles.count) if styles else \
            (64, 29, 1152, 120, "transparent", "#000000", 64.5, True, "center")
        variants = {}
        for st in styles:
            if st != base and st not in variants:
                variants[st] = "titulo-%d" % (len(variants) + 1)

        masters = [p_.get(q("draw:master-page-name")) for p_ in pages]
        main_master = max(set(masters), key=masters.count)

        templates = Path(__file__).with_name("templates") / "slides"
        title = self.name.replace("_", " ")

        if not self.faithful:
            slides = []
            for i, (page, t) in enumerate(zip(pages, titles), 1):
                slides += self.slide_simple(page, i, t, len(pages))
            for f in ("clase.scss", "encajar.html"):
                if not (self.out / f).exists():
                    shutil.copyfile(templates / f, self.out / f)
            header = """---
# Convertido con nvim_hades/scripts/odp2qmd.py desde {src}
# Cada "##" es una diapositiva. Clases del tema (clase.scss):
#   ::: {{.caja}} / {{.aviso}} / {{.gris}}   cuadros de color
#   ::: {{.grande}}  frase grande · ::: {{.centrado}}  centrado
#   :::: {{.columns}} + ::: {{.column width="50%"}}   columnas
#   . . .   lo que sigue aparece al avanzar · ::: notes  notas (tecla S)
# Neovim: ,qp vista previa · ,qh html · ,qP pdf.
# En el navegador: S = vista del ponente, F = pantalla completa, O = vista general.
pagetitle: "{title}"
format:
  revealjs:
    theme: [default, clase.scss]
    width: 1280
    height: 720
    margin: 0.05
    center: false
    slide-number: c/t
    transition: fade
    transition-speed: fast
    embed-resources: true
    html-math-method: katex
    self-contained-math: true
    include-after-body: encajar.html
    pdf-max-pages-per-slide: 1
---

""".format(src=self.src.name, title=title.replace('"', '\\"'))
            self.write(header, slides)
            return

        slides = []
        for i, (page, title_) in enumerate(zip(pages, titles), 1):
            cls = "." + variants[title_[2]] if title_ and title_[2] in variants else None
            slides += self.slide(page, i, title_, cls)

        theme = self.theme(main_master, base, [(st, cls) for st, cls in variants.items()])
        (self.out / "odp.scss").write_text(theme, encoding="utf-8")
        shutil.copyfile(templates / "ajustar.html", self.out / "ajustar.html")

        header = """---
# Convertido con nvim_hades/scripts/odp2qmd.py desde {src}
# Cada "##" es una diapositiva. Los cuadros van con {{.absolute left= top=
# width= height=}} en píxeles (diapositiva de {w}x{h}).
# Neovim: ,qp vista previa · ,qh html · ,qP pdf.
# En el navegador: S = vista del ponente (notas, reloj, siguiente),
# F = pantalla completa, O = vista general.
pagetitle: "{title}"
lang: en
format:
  revealjs:
    theme: [default, odp.scss]
    width: {w}
    height: {h}
    margin: 0
    center: false
    slide-number: c/t
    transition: none
    controls: true
    embed-resources: true
    include-after-body: ajustar.html
    # al imprimir / exportar a PDF, una página por diapositiva
    pdf-max-pages-per-slide: 1
---

""".format(src=self.src.name, w=WIDTH_PX, h=self.height_px, title=title.replace('"', '\\"'))
        self.write(header, slides)

    def write(self, header, slides):
        qmd = self.out / (self.name + ".qmd")
        text = header + "\n".join(slides).rstrip() + "\n"
        text = re.sub(r"\n{3,}", "\n\n", text)
        qmd.write_text(text, encoding="utf-8")

        shutil.rmtree(self.tmp, ignore_errors=True)
        for w in self.warnings:
            print("aviso:", w, file=sys.stderr)
        print(qmd)


def to_odp(src, tmpdir):
    soffice = shutil.which("soffice") or shutil.which("libreoffice")
    if not soffice:
        sys.exit("Para convertir %s hace falta LibreOffice (soffice)" % src.name)
    subprocess.run([soffice, "--headless", "--convert-to", "odp", "--outdir", str(tmpdir), str(src)],
                   check=True, capture_output=True)
    out = Path(tmpdir) / (src.stem + ".odp")
    if not out.exists():
        sys.exit("LibreOffice no pudo convertir " + str(src))
    return out


def main():
    ap = argparse.ArgumentParser(description="Presentación .odp/.pptx -> Quarto reveal.js (.qmd)")
    ap.add_argument("file")
    ap.add_argument("-o", "--outdir", help="carpeta de salida (por defecto ./<nombre>)")
    ap.add_argument("-n", "--name", help="nombre del .qmd (por defecto el del archivo)")
    ap.add_argument("--fiel", action="store_true",
                    help="copiar la composición exacta (cuadros con posición fija) en vez de "
                         "diapositivas sencillas en markdown")
    args = ap.parse_args()

    src = Path(args.file).expanduser().resolve()
    if not src.exists():
        sys.exit("No existe " + str(src))

    name = args.name or re.sub(r"[^\w-]+", "_", src.stem).strip("_") or "presentacion"
    outdir = Path(args.outdir).expanduser() if args.outdir else Path.cwd() / name

    tmp = None
    if src.suffix.lower() != ".odp":
        tmp = tempfile.mkdtemp(prefix="odp2qmd-")
        src_odp = to_odp(src, tmp)
    else:
        src_odp = src

    try:
        Converter(src_odp, outdir, name, faithful=args.fiel).run()
    finally:
        if tmp:
            shutil.rmtree(tmp, ignore_errors=True)


if __name__ == "__main__":
    main()
