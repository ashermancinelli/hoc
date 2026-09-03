#import "../macros.typ": *
#import "../glossaries.typ": *

#figure(
  [#deferred("Generated Lua content", "local start = 1965\n    local _end = 1980\n    timeline.draw_timeline({    \n        start_year = start,    \n        end_year = _end,    \n        marker_interval = 5,    \n        show_year = false,    \n        line_always = true,    \n        events = {        \n        {1967, \"Aho joins Bell Labs shortly after Ullman\"},        \n        {1972, \"C\"},        \n        {1977, \"Brian Kernighan, AWK\",delta=-.5},        \n        {1977, \"The Dragon Book first published\",delta=.5},        \n        {1979, \"Bjarne, C++\"},    },})\ntex.sprint(string.format(\"\\\", start, _end))")],
  kind: image,
  caption: [TBD, //d--%d]
) <fig:tbd-timeline>

