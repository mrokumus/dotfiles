vim.api.nvim_create_user_command("Note", function(opts)
  local args = opts.args

  if args == "" then
    print("Usage: Note week | Note zk <title>")
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
      return { "week", "zk" }
    end
    return {}
  end,
})
