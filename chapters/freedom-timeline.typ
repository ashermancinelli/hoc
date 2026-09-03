#import "../macros.typ": *
#import "../glossaries.typ": *

#figure(
  [#deferred("Generated Lua content", "local start = 1980\n        local _end = 2020\n        timeline.draw_timeline({    start_year = start,\n            end_year = _end,\n            marker_interval = 5,\n            show_year = false,\n            line_always = true,\n            events = {        \n                {1985, \"??? gnu, gcc, stallman\"},\n                {1990, \"??? torvalds, linux\"},\n                {1995, \"??? IBM moves to linux\"},\n                {2004, \"Development on LLVM begins\", delta=0},\n                {2012, \"Compiler Explorer open-sourced by Matt Godbolt\"},\n        },})\n        tex.sprint(string.format(\"\\\", start, _end))")],
  kind: image,
  caption: [Open Source Compiler Development Timeline, //d--%d]
) <fig:oss-timeline>

