-- Searchable keybind cheatsheet — auto-parses ~/.config/aerospace/aerospace.toml
local M = {}

-- Static sections (not derived from aerospace.toml)
local STATIC = {
  {section = "Hammerspoon (Hyper = cmd+alt+ctrl)", keys = {
    {"hyper + E",              "window hint mode (letters on windows)", "vim hint letter jump vimium homerow"},
    {"hyper + /",              "open this cheatsheet",            "help shortcuts cheat keybinds guide list search"},
    {"hyper + R",              "reload Hammerspoon config",       "reload restart refresh hammerspoon"},
    {"hyper + B",              "open Safari",                     "launch open browser safari"},
    {"hyper + C",              "open Visual Studio Code",         "launch open editor vscode code ide"},
    {"hyper + T",              "open Terminal",                   "launch open terminal shell"},
    {"hyper + F",              "open Finder",                     "launch open finder files"},
    {"hyper + M",              "open Mail",                       "launch open mail email"},
    {"hyper + S",              "open Slack",                      "launch open chat slack"},
  }},
  {section = "Nvim — Claude Code", keys = {
    {"Ctrl + ,",               "toggle Claude split pane",        "nvim claude code open close toggle split pane"},
    {"space + c + c",          "toggle Claude",                   "nvim claude toggle"},
    {"space + c + f",          "focus Claude pane",               "nvim claude focus jump"},
    {"space + c + r",          "resume Claude session",           "nvim claude resume"},
    {"space + c + C",          "continue last Claude conv",       "nvim claude continue"},
    {"space + c + b",          "add current buffer as context",   "nvim claude buffer context add"},
    {"space + c + s",          "send visual selection to Claude", "nvim claude selection send context"},
    {"space + c + a",          "accept Claude diff",              "nvim claude accept diff apply"},
    {"space + c + d",          "deny Claude diff",                "nvim claude deny reject diff"},
  }},
  {section = "Nvim — windows", keys = {
    {"Ctrl + h / j / k / l",   "switch split direction",          "nvim window split navigate switch jump pane"},
    {"Ctrl + w then h/j/k/l",  "switch split (fallback)",         "nvim window split navigate switch"},
    {"space + s + v",          "split vertical",                  "nvim vsplit vertical"},
    {"space + s + h",          "split horizontal",                "nvim split horizontal"},
    {"space + s + e",          "equalize split sizes",            "nvim window equal balance size"},
    {"space + s + x",          "close current split",             "nvim window close quit"},
  }},
  {section = "Nvim — file explorer", keys = {
    {"space + e + e",          "toggle nvim-tree explorer",       "nvim tree file explorer toggle sidebar"},
    {"space + e + f",          "find current file in tree",       "nvim tree find reveal"},
    {"space + e + c",          "collapse tree",                   "nvim tree collapse close"},
    {"space + e + r",          "refresh tree",                    "nvim tree refresh reload"},
  }},
  {section = "Nvim — basics", keys = {
    {":w",                     "save file",                       "nvim write save"},
    {":q / ZZ / :wq",          "quit / save+quit",                "nvim quit exit close"},
    {":q!",                    "force quit without save",         "nvim force quit discard"},
    {"u / Ctrl + r",           "undo / redo",                     "nvim undo redo"},
    {"/ + term",               "search forward",                  "nvim search find"},
    {"n / N",                  "next / prev search match",        "nvim search next previous"},
    {"gg / G",                 "top / bottom of file",            "nvim go top bottom"},
    {"dd / yy / p",            "delete / yank / paste line",      "nvim delete yank copy paste"},
    {"gd / K",                 "go to definition / hover docs",   "nvim lsp definition hover"},
    {"space + f + f",          "telescope find files",            "nvim telescope find files fuzzy"},
    {"space + f + g",          "telescope live grep",             "nvim telescope grep search text"},
  }},
  {section = "System", keys = {
    {"alt + /",                "open this cheatsheet",            "help shortcuts cheat keybinds guide search"},
    {"alt + shift + r",        "reload SketchyBar",               "reload refresh bar statusbar menubar"},
    {"alt + shift + c",        "reload AeroSpace config",         "reload refresh aerospace config"},
    {"alt + shift + a",        "reassign windows to rule workspaces", "fix reassign reorganize rules windows"},
  }},
}

-- Parse aerospace.toml — extract [mode.main.binding] entries w/ preceding comments as section hints
local function parseAerospace()
  local path = os.getenv("HOME").."/.config/aerospace/aerospace.toml"
  local f = io.open(path, "r")
  if not f then return {} end
  local content = f:read("*a")
  f:close()

  local sections = {}
  local current = nil
  local cur_section = "AeroSpace"
  local in_main = false
  local pending_desc = nil

  for line in content:gmatch("([^\r\n]*)[\r\n]") do
    local hdr = line:match("^%s*%[([^%]]+)%]")
    if hdr then
      in_main = (hdr == "mode.main.binding")
      pending_desc = nil
      if in_main then
        cur_section = "AeroSpace"
        current = { section = cur_section, keys = {} }
        table.insert(sections, current)
      else
        current = nil
      end
    elseif in_main then
      local comment = line:match("^%s*#%s*(.-)%s*$")
      if comment and comment ~= "" and not comment:match("^%-+$") and not comment:match("^See:") and not comment:match("^Possible") and not comment:match("^Fallback") then
        if #comment < 50 and not comment:match("%.") then
          cur_section = "AeroSpace — " .. comment
          current = { section = cur_section, keys = {} }
          table.insert(sections, current)
          pending_desc = nil
        else
          pending_desc = comment
        end
      else
        local key, rhs = line:match("^%s*([%w%-%+]+)%s*=%s*(.+)%s*$")
        if key and rhs and current then
          local desc = pending_desc
          if not desc then
            local clean = rhs
              :gsub("^'(.-)'%s*$", "%1")
              :gsub("^%[(.-)%]%s*$", "%1")
              :gsub("exec%-and%-forget%s+", "run: ")
              :gsub("'", "")
              :gsub("osascript.-keystroke \"(%a)\".-down}", "cmd+%1")
            desc = clean:sub(1, 80)
          end
          local display_key = key:gsub("%-", " + ")
          local keywords = (display_key .. " " .. desc .. " " .. cur_section):lower()
          table.insert(current.keys, {display_key, desc, keywords})
          pending_desc = nil
        end
      end
    end
  end

  -- Remove empty sections
  local result = {}
  for _, s in ipairs(sections) do
    if #s.keys > 0 then table.insert(result, s) end
  end
  return result
end

local function buildChoices()
  local all = {}
  for _, s in ipairs(parseAerospace()) do table.insert(all, s) end
  for _, s in ipairs(STATIC)             do table.insert(all, s) end

  local choices = {}
  for _, sec in ipairs(all) do
    for _, kv in ipairs(sec.keys) do
      local key, desc, kw = kv[1], kv[2], (kv[3] or "")
      table.insert(choices, {
        text = desc,
        subText = key .. "   " .. sec.section .. "   " .. kw,
        search = (desc .. " " .. key .. " " .. sec.section .. " " .. kw):lower(),
      })
    end
  end
  return choices
end

local function escape(s)
  return (s:gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"):gsub('"',"&quot;"))
end

local function buildHTML()
  local rows = {}
  for _, c in ipairs(buildChoices()) do
    local key_part, rest = c.subText:match("^(.-)   (.*)$")
    table.insert(rows, string.format(
      '<div class="row" data-search="%s"><div class="desc">%s</div><div class="meta"><span class="kbd">%s</span></div></div>',
      escape(c.search), escape(c.text), escape(key_part or c.subText)
    ))
  end
  return [[
<!DOCTYPE html><html><head><meta charset="utf-8"><style>
:root { color-scheme: dark; }
* { box-sizing: border-box; margin: 0; padding: 0; }
html, body {
  background: transparent;
  font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", sans-serif;
  color: #cdd6f4;
  -webkit-font-smoothing: antialiased;
  overflow: hidden;
}
.panel {
  height: 100vh;
  background: rgba(30,30,46,0.85);
  backdrop-filter: blur(32px) saturate(1.5);
  -webkit-backdrop-filter: blur(32px) saturate(1.5);
  border: 1px solid rgba(205,214,244,0.08);
  border-radius: 16px;
  display: flex; flex-direction: column; overflow: hidden;
}
.search { padding: 16px 18px 12px; border-bottom: 1px solid rgba(205,214,244,0.06); }
input {
  width: 100%; padding: 6px 4px; font-size: 22px;
  background: transparent; color: #cdd6f4; border: 0; outline: 0;
  caret-color: #89b4fa;
}
input::placeholder { color: #6c7086; }
.list { flex: 1; overflow-y: auto; padding: 6px; }
.list::-webkit-scrollbar { width: 0; }
.row {
  display: flex; justify-content: space-between; align-items: center;
  padding: 10px 14px; border-radius: 10px; gap: 14px;
}
.row.active { background: rgba(137,180,250,0.18); }
.row.hidden { display: none; }
.desc { font-size: 14px; color: #cdd6f4; flex: 1; }
.meta { display: flex; gap: 8px; align-items: center; flex-shrink: 0; }
.kbd {
  font-family: "JetBrains Mono", "SF Mono", ui-monospace, monospace;
  font-size: 11px; color: #bac2de;
  background: rgba(205,214,244,0.08); padding: 3px 8px; border-radius: 5px;
}
.empty { padding: 40px; text-align: center; color: #6c7086; font-size: 13px; }
</style></head><body>
<div class="panel">
  <div class="search"><input id="q" placeholder="Search keybinds…" autofocus></div>
  <div class="list" id="list">]]..table.concat(rows,"\n")..[[<div class="empty" id="empty" style="display:none">No match</div></div>
</div>
<script>
const q = document.getElementById('q');
const rows = [...document.querySelectorAll('.row')];
const empty = document.getElementById('empty');
let active = 0;
function render() {
  const term = q.value.toLowerCase().trim();
  let vcount = 0;
  rows.forEach(r => {
    const match = !term || term.split(/\s+/).every(w => r.dataset.search.includes(w));
    r.classList.toggle('hidden', !match);
    r.classList.remove('active');
    if (match) vcount++;
  });
  empty.style.display = vcount === 0 ? 'block' : 'none';
  const vis = rows.filter(r => !r.classList.contains('hidden'));
  active = 0;
  if (vis[0]) vis[0].classList.add('active');
}
q.addEventListener('input', render);
document.addEventListener('keydown', e => {
  const vis = rows.filter(r => !r.classList.contains('hidden'));
  if (e.key === 'Escape') { window.location = 'hammerspoon://cheatclose'; return; }
  if (e.key === 'ArrowDown') {
    e.preventDefault();
    vis[active] && vis[active].classList.remove('active');
    active = Math.min(active + 1, vis.length - 1);
    vis[active] && (vis[active].classList.add('active'), vis[active].scrollIntoView({block:'nearest'}));
  }
  if (e.key === 'ArrowUp') {
    e.preventDefault();
    vis[active] && vis[active].classList.remove('active');
    active = Math.max(active - 1, 0);
    vis[active] && (vis[active].classList.add('active'), vis[active].scrollIntoView({block:'nearest'}));
  }
});
setTimeout(() => q.focus(), 20);
render();
</script></body></html>
]]
end

local webview = nil

function M.close()
  if webview then webview:delete(); webview = nil end
end

function M.toggle()
  if webview then M.close(); return end
  local screen = hs.screen.mainScreen():frame()
  local w, h = 680, 480
  local rect = {
    x = screen.x + (screen.w - w) / 2,
    y = screen.y + screen.h * 0.22,
    w = w, h = h,
  }
  webview = hs.webview.new(rect, { developerExtrasEnabled = false })
    :windowStyle({"borderless","closable"})
    :closeOnEscape(true)
    :shadow(true)
    :level(hs.drawing.windowLevels.modalPanel)
    :allowTextEntry(true)
    :transparent(true)
    :bringToFront(true)
    :html(buildHTML())
    :show()
  hs.application.get("Hammerspoon"):activate(true)
  hs.timer.doAfter(0.08, function()
    if webview and webview:hswindow() then
      webview:hswindow():becomeMain()
      webview:hswindow():focus()
      webview:hswindow():raise()
    end
  end)
end

hs.urlevent.bind("cheatclose", function() M.close() end)

return M
