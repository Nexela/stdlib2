---@diagnostic disable: lowercase-global

std = "lua52+factorio"
quiet = 1
max_cyclomatic_complexity = false
codes = true
max_line_length = 160
max_code_line_length = 160
max_string_line_length = 160
max_comment_line_length = false
ignore = {"212/self"}

---@diagnostic disable-next-line: undefined-global
stds.factorio = {
  -- Set the read only variables
  read_globals = {
    "game",
    "log",
    "serpent",
    "table_size",
    "defines",
    __DebugAdapter = { fields = { "print", "stepIgnoreAll", "stepIgnore", "breakpoint" }, other_fields = true, read_only = false },
    __Profiler = { other_fields = true, read_only = false },
  },
  globals = {
    "__POSITION_DEBUG__"
  },
}

exclude_files = {
  "**/.temp/*",
  "**/spec/*"
}
