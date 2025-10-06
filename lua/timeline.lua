function draw_timeline(config)
    local start_year = config.start_year
    local end_year = config.end_year
    local events = config.events
    local spans = config.spans or {}
    local scale_factor = config.scale_factor or 1.0
    
    -- Get textwidth from LaTeX and calculate percentage
    local text_width = config.text_width
    if not text_width then
        -- Get \textwidth in points and calculate 80%
        local textwidth_pt = tex.dimen.textwidth / 65536
        text_width = string.format("%.2fpt", textwidth_pt * 0.8)
    end
    
    -- Calculate scale
    local year_range = end_year - start_year
    local height = config.height or tex.dimen.textheight / (40 * 65536) * scale_factor
    local scale = height / year_range
    
    -- Helper to convert year to y-position
    local function year_to_y(year)
        return (year - start_year) * -scale
    end
    
    -- Center the tikzpicture
    tex.sprint("\\begin{center}")
    
    -- Start TikZ picture
    tex.sprint("\\begin{tikzpicture}[")
    tex.sprint("event/.style={circle, draw=red, fill=red!30, minimum size=6pt, inner sep=0pt},")
    tex.sprint("year/.style={font=\\bfseries},")
    tex.sprint(string.format("description/.style={text width=%s, font=\\small, anchor=west}]", text_width))
    
    -- Draw main timeline
    tex.sprint(string.format("\\draw[thick, black] (0,0) -- (0,%f);", -height))
    
    -- Draw spans
    for _, span in ipairs(spans) do
        local y1 = year_to_y(span[1])
        local y2 = year_to_y(span[2])
        tex.sprint(string.format("\\draw[red, line width=3pt, opacity=0.6] (0,%f) -- (0,%f);", y1, y2))
    end
    
    -- Draw year markers
    local marker_interval = config.marker_interval or 5
    for year = start_year, end_year, marker_interval do
        local ypos = year_to_y(year)
        tex.sprint(string.format("\\draw[black] (-0.15,%f) -- (0.15,%f);", ypos, ypos))
        tex.sprint(string.format("\\node[year, left=3mm] at (0,%f) {%d};", ypos, year))
    end
    
    -- Draw events
    for _, event in ipairs(events) do
        local year = event[1]
        local desc = event[2]
        
        -- Check if it's a span (year is a table with two values)
        if type(year) == "table" then
            local year_start = year[1]
            local year_end = year[2]
            local ypos_start = year_to_y(year_start)
            local ypos_end = year_to_y(year_end)
            local ypos_mid = (ypos_start + ypos_end) / 2
            
            -- Draw vertical bar for the span
            tex.sprint(string.format("\\draw[red, line width=2pt] (0,%f) -- (0,%f);", ypos_start, ypos_end))
            -- Draw circles at endpoints
            tex.sprint(string.format("\\node[event] at (0,%f) {};", ypos_start))
            tex.sprint(string.format("\\node[event] at (0,%f) {};", ypos_end))
            -- Label at midpoint
            tex.sprint(string.format("\\node[description] at (0.3,%f) {%d--%d: %s};", ypos_mid, year_start, year_end, desc))
        else
            -- Single year event
            -- local ypos = year_to_y(year)
            -- tex.sprint(string.format("\\node[event] at (0,%f) {};", ypos))
            -- tex.sprint(string.format("\\node[description] at (0.3,%f) {%d: %s};", ypos, year, desc))
            local ypos = year_to_y(year)
            tex.sprint(string.format("\\node[event] at (0,%f) {};", ypos))
            local prefix = ""
            if show_year then prefix = string.format("%d: ", int(year)) end
            local desc_content = string.format("\\node[description] at (0.3,%f) {%s%s};", ypos, prefix, desc)
            tex.sprint(desc_content)
        end
    end
    
    tex.sprint("\\end{tikzpicture}")
    tex.sprint("\\end{center}")
end

return {
    draw_timeline = draw_timeline
}
