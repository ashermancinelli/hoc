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

return {
    git_revision = git_revision
}
