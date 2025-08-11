--
-- NEORG
--

local M = {}

function M.load_keys(ev)
  if not IsModuleAvailable("neorg") then
    return nil
  end

  if DEBUG then
    print("neorg - buffer keys loaded")
  end

  local keymap_buffer = require("hades.utils.keys").keymap_buffer
  local key_or_clue_buffer = require("hades.utils.keys").key_or_clue_buffer

  local opts = require("hades.utils.keys").opts
  local orgmod = require("neorg").modules.get_module

  -- GENERAL
  keymap_buffer(ev.buf, "i", "<C-CR>", "<Plug>(neorg.itero.next-iteration)", opts, "next iteration of element (org)")
  keymap_buffer(
    ev.buf,
    "i",
    "<C-d>",
    "<Plug>(neorg.tempus.insert-date.insert-mode)",
    opts,
    "insert link to current date (org)"
  )

  -- NOTES
  key_or_clue_buffer(ev.buf, "n", "<localleader>n", "+[n]otes (org)")
  keymap_buffer(ev.buf, "n", "<localleader>nn", "<Plug>(neorg.dirman.new-note)", opts, "[n]ote [n]ew")
  keymap_buffer(ev.buf, "n", "<localleader>nt", "<CMD>Neorg toc<CR>", opts, "[n]ote [t]able of contents")

  -- HEADINGS
  keymap_buffer(ev.buf, { "n", "i" }, "<C-Tab>", "<Plug>(neorg.promo.promote)", opts, "promote heading (org)")
  keymap_buffer(ev.buf, { "n", "i" }, "<C-S-Tab>", "<Plug>(neorg.promo.demote)", opts, "demote heading (org)")

  -- LISTS
  key_or_clue_buffer(ev.buf, "n", "<localleader>l", "+[l]ists (org)")
  keymap_buffer(ev.buf, "n", "<localleader>li", "<Plug>(neorg.pivot.list.invert)", opts, "[l]ist [i]nvert (order)")
  keymap_buffer(ev.buf, "n", "<localleader>lt", "<Plug>(neorg.pivot.list.toggle)", opts, "[l]ist [t]oggle (un-ordered)")

  -- TODO
  key_or_clue_buffer(ev.buf, "n", "<localleader>t", "+[t]odo (org)")
  keymap_buffer(
    ev.buf,
    "n",
    "<LocalLeader>td",
    "<Plug>(neorg.qol.todo-items.todo.task-done)",
    opts,
    "[t]odo task [d]one"
  )
  keymap_buffer(
    ev.buf,
    "n",
    "<LocalLeader>tu",
    "<Plug>(neorg.qol.todo-items.todo.task-undone)",
    opts,
    "[t]odo task [u]n-done"
  )
  keymap_buffer(
    ev.buf,
    "n",
    "<LocalLeader>tp",
    "<Plug>(neorg.qol.todo-items.todo.task-pending)",
    opts,
    "[t]odo task [p]ending"
  )
  keymap_buffer(
    ev.buf,
    "n",
    "<LocalLeader>th",
    "<Plug>(neorg.qol.todo-items.todo.task-on_hold)",
    opts,
    "[t]odo task [h]old"
  )
  keymap_buffer(
    ev.buf,
    "n",
    "<LocalLeader>tc",
    "<Plug>(neorg.qol.todo-items.todo.task-cancelled)",
    opts,
    "[t]odo task [c]ancelled"
  )
  keymap_buffer(
    ev.buf,
    "n",
    "<LocalLeader>tr",
    "<Plug>(neorg.qol.todo-items.todo.task-recurring)",
    opts,
    "[t]odo task [r]ecurring"
  )
  keymap_buffer(
    ev.buf,
    "n",
    "<LocalLeader>ti",
    "<Plug>(neorg.qol.todo-items.todo.task-important)",
    opts,
    "[t]odo task [i]mportant"
  )
  keymap_buffer(
    ev.buf,
    "n",
    "<LocalLeader>ta",
    "<Plug>(neorg.qol.todo-items.todo.task-ambiguous)",
    opts,
    "[t]odo task [a]mbiguous"
  )

  keymap_buffer(
    ev.buf,
    "n",
    "<C-Space>",
    "<Plug>(neorg.qol.todo-items.todo.task-cycle)",
    opts,
    "TODO task status cycle (neorg)"
  )
  keymap_buffer(
    ev.buf,
    "n",
    "<C-S-Space>",
    "<Plug>(neorg.qol.todo-items.todo.task-cycle-reverse)",
    opts,
    "TODO task status cycle reverse (neor)"
  )
end

function M.general_keys()
  local keymap = require("hades.utils.keys").keymap
  local key_or_clue = require("hades.utils.keys").key_or_clue
  key_or_clue("n", "<leader>o", "+[o]org")
end

return M
