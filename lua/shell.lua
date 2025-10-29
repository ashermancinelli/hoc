local function ensure(command)
    texio.write_nl("Ensuring command: " .. command)
    local handle = io.popen(command, "r")
    local out = handle:read("*a")
    local ok = handle:close()
    if not ok then
        tex.sprint("Command failed\n")
        return "command failed"
    end
    return out
end

function git_revision()
    local handle = io.popen("git rev-parse --short HEAD 2>/dev/null")
    if not handle then
        return "shell-escape-disabled"
    end

    local result = handle:read("*a")
    handle:close()
    if not result or result == "" then
        return "not-a-git-repo"
    end

    return result:gsub("%s+", "")
end

function dot_to_png(input)
    local png = os.tmpname() .. ".png"
    local cmd = "dot -Tpng " .. input .. " -o " .. png
    texio.write_nl("Running command: " .. cmd)
    local out = ensure(cmd)
    return png
end

return {
    git_revision = git_revision,
    dot_to_png = dot_to_png
}
