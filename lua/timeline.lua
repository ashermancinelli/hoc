function draw_timeline(config)
    local start_year = config.start_year
    local end_year = config.end_year
    local events = config.events
    local spans = config.spans or {}
    local scale_factor = config.scale_factor or 1.0
    local distance_from_timeline = config.distance_from_timeline or 0.5
    local marker_interval = config.marker_interval or 5
    local line_always = config.line_always or false
    
    -- Get textwidth from LaTeX and calculate percentage
    local text_width = config.text_width
    if not text_width then
        local textwidth_pt = tex.dimen.textwidth / 65536
        text_width = string.format("%.2fpt", textwidth_pt * 0.8)
    end
    
    -- Calculate scale
    local year_range = end_year - start_year
    local height = config.height or tex.dimen.textheight / (30 * 65536) * scale_factor
    local scale = height / year_range
    
    -- Helper to convert year to y-position
    local function year_to_y(year)
        return (year - start_year) * -scale
    end
    
    -- Center the tikzpicture
    tex.sprint("\\begin{center}")
    tex.sprint("\\sffamily")
    
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
    for year = start_year, end_year, marker_interval do
        local ypos = year_to_y(year)
        tex.sprint(string.format("\\draw[black] (-0.15,%f) -- (0.15,%f);", ypos, ypos))
        tex.sprint(string.format("\\node[year, left=3mm] at (0,%f) {%d};", ypos, year))
    end
    
    -- Draw events
    for _, event in ipairs(events) do
        local year = event[1]
        local desc = event[2]
        local position = event.position
        local delta = event.delta

        if event.position ~= nil and even.delta ~= nil then
            error("Event cannot have both 'position' and 'delta' fields.")
        end
        
        local ypos = year_to_y(year)
        
        -- Use custom position if provided, otherwise use year position
        local desc_ypos = position and year_to_y(position) or ypos
        if delta then
            desc_ypos = year_to_y(year + delta)
        end
        
        -- Draw event dot at actual year
        tex.sprint(string.format("\\node[event] at (0,%f) {};", ypos))
        
        -- Draw connecting line if position is different from year
        if position or delta or line_always then
            tex.sprint(string.format("\\draw[red, dashed, thin] (0,%f) -- (%f,%f);", ypos, distance_from_timeline, desc_ypos))
        end
        
        -- Draw description at specified position
        tex.sprint(string.format("\\node[description] at (%f,%f) {%s};", distance_from_timeline, desc_ypos, desc))
    end
    
    tex.sprint("\\end{tikzpicture}")
    tex.sprint("\\end{center}")
    tex.sprint("\\normalfont")
end

return {
    draw_timeline = draw_timeline
}
