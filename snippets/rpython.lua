local ls = require('luasnip')
local s = ls.snippet
-- local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
-- local d = ls.dynamic_node
-- local fmt = require('luasnip.extras.fmt').fmt
-- local fmta = require('luasnip.extras.fmt').fmta
-- local rep = require('luasnip.extras').rep

return {
  s({
    trig = 'class',
    desc = 'class definition',
  }, {
    t('class '),
    i(1),
    t({ ':' }),
    t({ '', '' }),
    t({ '\t'''', '' }),
    t({ '\tDescripción de la clase', '' }),
    t({ '\t'''', '' }),
    t({ '\tdef __init__(self,x):' }),
    t({ '', '' }),
    t({ '\t\t'''', '' }),
    t({ '\t\tConstructor', '' }),
    t({ '\t\t'''' }),
    t({ '', '\t\t' }),
    i(2, 'self.x = x'),
    t({ '', '', '\t' }),
    t({ 'def __str__(self):' }),
    t({ '', '' }),
    t({ '\t\t'''', '' }),
    t({ '\t\tClass to string', '' }),
    t({ '\t\t'''' }),
    t({ '', '\t\t' }),
    i(3, 'return f'{self.x}''),
    t({ '', '' }),
  }),
  s({
    trig = 'def class func',
    desc = 'define regular class method',
  }, {
    t({ '', '' }),
    t('def '),
    i(1),
    t('(self, '),
    i(2, 'arg'),
    t('):'),
    t({ '', '\t' }),
    i(3, 'pass'),
    t({ '', '' }),
  }),

  s({
    trig = 'def abstract class func',
    desc = 'define abstract class method',
  }, {
    t({ '', '' }),
    t('def '),
    i(1),
    t('(self, '),
    i(2, 'arg'),
    t('):'),
    t({ '', '' }),
    t('\traise NotImplementedError'),
    t({ '', '' }),
  }),
  s({
    trig = 'try',
    desc = 'try/except',
  }, {
    t({ '', '' }),
    t('try:'),
    t({ '', '\t' }),
    i(1, 'commands'),
    t({ '', '' }),
    t('except '),
    i(2, 'ValueError'),
    t(' as '),
    i(3, 'e'),
    t(':'),
    t({ '', '\t' }),
    i(4, 'print(f'Error:{e}')'),
    t({ '', '' }),
  }),
}
