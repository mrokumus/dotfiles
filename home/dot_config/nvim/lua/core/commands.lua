vim.api.nvim_create_user_command("Note", function(opts)
  local args = opts.args

  if args == "" then
    print("Usage: Note jw|pw|pd|project <scope> <title>|zk <area> <title>")
    return
  end

  local cmd = "note ensure-path " .. args
  local path = vim.fn.system(cmd):gsub("%s+$", "")

  if vim.v.shell_error ~= 0 then
    print(path)
    return
  end

  vim.cmd("edit " .. vim.fn.fnameescape(path))
end, {
  nargs = "*",
  complete = function(_, line)
    local parts = vim.split(line, "%s+")

    if #parts <= 2 then
      return { "jw", "pw", "pd", "project", "zk" }
    end

    if parts[2] == "project" then
      return {
        "jotform",
        "personal/ganyan-ai",
        "personal/mimosa",
        "personal/the-mortal-world",
        "personal/crowlynx",
      }
    end

    if parts[2] == "zk" then
      return { "development", "ai-ml", "game-dev", "life" }
    end

    return {}
  end,
})
