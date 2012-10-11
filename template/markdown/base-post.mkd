---
layout: post
title: {{_expr_:substitute(matchstr(expand("%:p:t:r"), '^[0-9-]\+\zs.*'), '[-_]', ' ', 'g')}}
date: {{_expr_:strftime('%Y/%m/%d %H:%M', localtime())}}
---
{{_cursor_}}
