# TODO

# Installation

```bash
git clone https://github.com/feranpre/nvim_hades.git ~/.config/nvim
```

## Packges

```bash
yay -S tree-sitter-cli ueberzugpp pyright conform prettier fzf ripgrep fd 
```

# Code

## Formatters

These are the formatters I use:

- python: black `yay -S python-black`
- JSON: jq `yay -S jq`
- Markdown: prettier `yay -S perttier`

## Linter

### Markdown: vale

Install in the system
`yay -S vale`

Export environment var in `.bashrc` or `.zshrc`. In my case `~/.config/zsh/.zshrc`

Include this:
`export VALE_CONFIG_PATH="$HOME/.config/vale/vale.ini"`

There is **no spaces** on either side of the `=` that's important.

Now create a `vale.ini` file

```bash
StylesPath = styles
MinAlertLevel = suggestion
```

Finally we need the styles, create the `styles` folder inside `~/.config/vale` and
then run `git clone https://github.com/errata-ai/styles /path/to/vale/styles`

## Autocompletion

### [blink](https://github.com/Saghen/blink.cmp)

Autocompletion plugin, this is the replacement of [cmp](https://github.com/hrsh7th/nvim-cmp)

### [otter](https://github.com/jmbuhr/otter.nvim)

Code completion inside other documents, like quarto

## REPL

### [Molten](https://github.com/benlubas/molten-nvim)

Molten allows to work with jupyter notebooks.

The requirements include:

- [image.nvim](https://github.com/3rd/image.nvim)
- I don't use kitty and therefore I need to use the `ueberzug` render backend for images

#### Install procedure

Create the virtual env

```bash
python -m venv ~/venv/python_venv_name
source ~/venv/python_venv_name/bin/activate
```

Now we install dependencies in python

```{bash}
pip install pynvim
pip install jupyter_client
pip install cairosvg
pip install pnglatex
pip install plotly
pip install kaleido
pip install pyperclip

```

Install in python the kernel and create the project name

```{bash}
pip install ipykernel
python -m ipykernel install --user --name project_name
```

## Formatting

### [conform](https://github.com/stevearc/conform.nvim)

Format code files

## comments

### [ts-comments](https://github.com/folke/ts-comments.nvim)

`DISABLED` in favor of [[mini-comment]]
Toggle comments

### [todo-comments](https://github.com/folke/todo-comments.nvim)

Highlight and search for comments like `TODO`, `FIX`, `WARNING`, `HACK` and `NOTE`

## [nvim-lint](https://github.com/mfussenegger/nvim-lint)

Linter plugin

## mini

### [mini-comment](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-comment.md)

Toggle comments

### [mini-ai](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md)

Extend and create `a`/`i` text objects

### [mini-pair](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pairs.md)

Minimal and fast autopairs

### [mini-surround](https://github.com/echasnovski/mini.surround)

Add, delete, replace, find or highlight surrounding (), "", [], ...

tips:

- `vi"` select all text within ""
- `sr"'` get surrounding "" and replace them with '' => `"change quotes"` --> `'change quotes'`
- select a word and `sa"` to surround it with ""

## language

### [quarto](https://github.com/quarto-dev/quarto-nvim)

### [R.nvim](https://github.com/R-nvim/R.nvim)

R support in neovim

### Markdown

#### [bullets](https://github.com/bullets-vim/bullets.vim)

Auto continues the numeric bullets and that kind of stuff

#### [Markpreview](https://github.com/OXY2DEV/markview.nvim)

Preview of markdown documents

# Editor

## [alpha](https://github.com/goolord/alpha-nvim)

Greeter

## colorscheme

file that includes all colorschemes that I've installed

## [harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)

Create a list of files that can be accessed using keybinds or selecting from a list

## [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim)

Indentation guides

## key combinations

### [mini-clue](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-clue.md)

Shows help for keybinds as you use the commands
Replacement for [which-key](https://github.com/folke/which-key.nvim)

`DISABLED`

### [which-key](https://github.com/folke/which-key.nvim)

Shows help for keybinds as you use the commands

## [mini](https://github.com/echasnovski/mini.nvim)

### [mini-animate](https://github.com/echasnovski/mini.animate)

Cursor animations
`DISABLED`

It did some funky things, and got stuck when trying to use `CTRL+f`

### [mini-statusline](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-statusline.md)

## [oil]()

## [snacks]()

This plugin has different modules that can be activated separately

## [telescope]()

## [undotree]()

## [which-key]()
