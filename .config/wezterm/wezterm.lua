local wezterm = require 'wezterm';
local io = require 'io';
local os = require 'os';

-- TODO: add 
-- TODO: some kind of mnemonic icons like this along with title https://gist.github.com/gsuuon/5511f0aa10c10c6cbd762e0b3e596b71#file-wezterm-lua-L103

-- equivalent to POSIX basename(3)
-- given "/foo/bar" returns "bar"
-- given "C:\\foo\\bar" returns "bar"
local function basename(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local MYFONT = "PragmataPro Mono Liga"

local PLATFORM_WINDOWS = wezterm.target_triple == "x86_64-pc-windows-msvc"
local PLATFORM_MACOS = string.find(wezterm.target_triple, "darwin")
local PLATFORM_LINUX = string.find(wezterm.target_triple, "linux")

local SOLID_LEFT_ARROW = utf8.char(0x30ba)
local SOLID_LEFT_MOST = utf8.char(0x2588)
local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

local ADMIN_ICON = utf8.char(0xf49c)
local CMD_ICON = utf8.char(0xe62a)
local PS_ICON = utf8.char(0xe70f)
local TUX_ICON = utf8.char(0xf31a)
local VIM_ICON = utf8.char(0xe62b)
local PAGE_ICON = utf8.char(0xf718)
local HOURGLASS_ICON = utf8.char(0xf252)
local TREE_ICON = utf8.char(0xf160e)
local WINDOW_ICON = utf8.char(0xf10ac)
local HELIX_ICON = utf8.char(0xf0684)
local ADMIN_ICON = utf8.char(0xf0ecd)

print("Trying to print the icon")
print(PS_ICON)

-- if it's stupud and it works.. well it's still stupid admittedly
local SUP_IDX = {"¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "¹⁰",
                "¹¹", "¹²", "¹³", "¹⁴", "¹⁵", "¹⁶", "¹⁷", "¹⁸", "¹⁹", "²⁰"}

local SUB_IDX = {"₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₁₀",
                "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆", "₁₇", "₁₈", "₁₉", "₂₀"}

local window_min = ' 󰖰 '
local window_max = ' 󰖯 '
local window_close = ' 󰅖 '

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    if tab.is_active then
        background = "#fbb829"
        foreground = "#1c1b19"
    else
        background = "#111111"
        foreground = "#abb2b9"
    end

    local pane_title = tab.active_pane.title
    local process_name = tab.active_pane.foreground_process_name
    local tab_title = tab.tab_title
    local exec_name = basename(process_name):gsub("%.exe$", "")
    local title_with_icon

    if tab_title == "" then
        to_display = pane_title
    else
        to_display = tab_title
    end

    -- switch logic
    if #tab.panes > 1 then
        title_with_icon = WINDOW_ICON .. "  " .. to_display
    elseif string.find(pane_title, "admin*") then
        title_with_icon = ADMIN_ICON .. "  " .. to_display
    elseif exec_name == "pwsh" or exec_name == "powershell" then
        title_with_icon = PS_ICON .. "  " .. to_display
    elseif exec_name == "ssh" then
        title_with_icon = TUX_ICON .. "  " .. to_display
    elseif exec_name == "hx" then
        title_with_icon = HELIX_ICON .. "  " .. to_display
     elseif exec_name == "vim" then
        title_with_icon = VIM_ICON .. "  " .. to_display       
     elseif exec_name == "broot" then
        title_with_icon = TREE_ICON .. "  " .. to_display       
    else
        title_with_icon = HOURGLASS_ICON .. "  " .. to_display
    end

    local id = SUB_IDX[tab.tab_index+1]

    local title = " " .. wezterm.truncate_right(title_with_icon, max_width) .. " "

    return {
        {Background = {Color = background}},
        {Foreground = {Color = foreground}},
        {Text = id},
        {Text = title},
    }
end)

wezterm.on("update-status", function(window, pane)
    local icon_test = utf8.char(0xe62b)
    local icon_test = "🤠"

    window:set_left_status(wezterm.format {
        { Background = { Color = '#333333' } },
        { Text = ' ' .. wezterm.pad_right(icon_test, 3) }
    })

    local title = pane:get_title()
    local date = ' ' .. wezterm.strftime('%H:%M %d-%m-%Y') .. ' '

    window:set_right_status(wezterm.format {
        { Background = { Color = '#555555' } },
        { Text = ' ' .. title .. ' ' },
        { Background = { Color = '#333333' } },
        { Text = date },
    })
end)

wezterm.on("rewind-hx", function(window, pane)
    local scrollback = pane:get_lines_as_text(10000)

    -- TODO: is os.tmpname ok on windows??
    local name = os.tmpname()
    local f = io.open(name, "w+")
    f:write(scrollback)
    f:flush()
    f:close()

    window:perform_action(wezterm.action{SpawnCommandInNewWindow={
        args = {"hx", name}
    }}, pane)

    wezterm.sleep_ms(1000)
    os.remove(name)
end)

-- TODO: need better way to fire this logic on new tabs
--wezterm.on("gui-startup", function(cmd)
--    local mux = wezterm.mux
--    local tab, pane, window = mux.spawn_window(cmd or {})
--    local icons = { '🌞', '🍧', '🫠', '🏞️', '📑', '🪁', '🧠', '🦥', '🦉', '📀', '🌮', '🍜', '🧋', '🥝', '🍊', }
--    tab:set_title(' ' .. icons[math.random(#icons)] .. ' ')
--end)

local wezconfig = {
    font = wezterm.font("PragmataPro Mono Liga"),
    --font = wezterm.font("PragmataPro Mono"),
    --font = pg,
    font_size = 12.0,

    initial_cols = 162,
    initial_rows = 90,

    -- TODO: clean this shit up
    font_rules = {
        {intensity = "Bold", font = wezterm.font("PragmataPro Mono Liga", {weight = "Bold"})},
        {italic = true, font = wezterm.font("PragmataPro Mono Liga", {italic = true})},
        {intensity = "Bold", italic = true, font = wezterm.font("PragmataPro Mono Liga", {weight = "Bold", italic = true})},
    },

    tab_max_width = 30,

    -- note that kitty graphics require the use of the "wezterm ssh"
    -- command rather than build in "ssh" due to some weird windows
    -- conhost stuff
    -- (unsure if appliacable to win11)
    enable_kitty_graphics = true,

    launch_menu = {}, -- this needs to be initialized here for some reason

    use_fancy_tab_bar = false,
    hide_tab_bar_if_only_one_tab = false,
    warn_about_missing_glyphs = false,
    adjust_window_size_when_changing_font_size = false,
    check_for_updates = false,

    window_decorations = 'INTEGRATED_BUTTONS|RESIZE', -- integrate title bar into the terminal, ignore OS bar
    integrated_title_button_style = "Gnome", -- change OS buttons for our own style

    tab_bar_style = {
        window_hide = window_min,
        window_hide_hover = window_min,
        window_maximize = window_max,
        window_maximize_hover = window_max,
        window_close = window_close,
        window_close_hover = window_close,
    },

    -- padding inside the terminal, pushes in TUI
--    window_padding = {
--        left = '6px',
--        right = '6px',
--        top = '2px',
--        bottom = 0,
--    },

    visual_bell = {
        fade_in_duration_ms = 75,
        fade_out_duration_ms = 75,
        target = "CursorColor",
    },

    -- for some reason it falls back on my machine to the CPU "Software" renderer
    -- which makes typing on maximized 4k windows slow and outputting lots of text
    -- in tmux windows VERY slow
    front_end = "OpenGL",
    -- TODO: try this eventually?
    -- front_end = "WebGpu"
    -- webgpu_power_preference = "HighPerformance"

    -- tmux like keys for panes
    leader = {key = "s", mods = "CTRL"},
    keys = {
        {key = '"',             mods = "LEADER|SHIFT",  action = wezterm.action{SplitVertical = {domain = "CurrentPaneDomain"}}},
        {key = "%",             mods = "LEADER|SHIFT",  action = wezterm.action{SplitHorizontal = {domain = "CurrentPaneDomain"}}},

        {key = "LeftArrow",     mods = "ALT|SHIFT",           action = wezterm.action{ActivatePaneDirection = "Left"}},
        {key = "RightArrow",    mods = "ALT|SHIFT",           action = wezterm.action{ActivatePaneDirection = "Right"}},
        {key = "DownArrow",     mods = "ALT|SHIFT",           action = wezterm.action{ActivatePaneDirection = "Down"}},
        {key = "UpArrow",       mods = "ALT|SHIFT",           action = wezterm.action{ActivatePaneDirection = "Up"}},

        {key = "z",             mods = "LEADER",        action = "TogglePaneZoomState"},
        {key = "x",             mods = "LEADER",        action = wezterm.action{CloseCurrentPane={confirm = true}}},

        {key = "t",             mods = "CTRL|SHIFT",    action = wezterm.action{SpawnTab = "CurrentPaneDomain"}},
        {key = "w",             mods = "CTRL|SHIFT",    action = wezterm.action{CloseCurrentTab = {confirm = true}}},
        {key = "w",             mods = "CTRL|SHIFT",    action = wezterm.action{CloseCurrentTab = {confirm = true}}},
        {key = "RightArrow",    mods = "CTRL|SHIFT",    action = wezterm.action{ActivateTabRelative = 1}},
        {key = "LeftArrow",     mods = "CTRL|SHIFT",    action = wezterm.action{ActivateTabRelative = -1}},

        {key = "a",             mods = "CTRL|SHIFT",    action = wezterm.action.ShowLauncher},
        {key = "t",             mods = "CMD|SHIFT",     action = wezterm.action.ShowTabNavigator},
        {key = "e",             mods = "CTRL|SHIFT",    action = wezterm.action{EmitEvent="rewind-hx"}}, -- TODO: add the event here

        {key = "R",             mods = "CTRL|SHIFT",    action = wezterm.action.PromptInputLine {
                description = "Enter title",
                action = wezterm.action_callback(function(window, _, line)
                    if line then
                        window:active_tab():set_title(line)
                    end
                end),
            },
        },

        {key = "e",              mods = "CTRL|ALT",     action = wezterm.action{QuickSelectArgs={
            patterns = {
                "http?://\\S+",
                "https?://\\S+"
            },
            action = wezterm.action_callback(function(window, pane)
                local url = window:get_selection_text_for_pane(pane)
                wezterm.open_with(url)
            end)
        }}},
    },

    foreground_text_hsb = {
        hue =           1.0,
        saturation =    1.0,
        brightness =    1.0,
    },

    inactive_pane_hsb = {
        hue =           1.0,
        saturation =    0.5,
        brightness =    0.8,
    },

    -- alacritty-like line spacing, must be in increments of 0.1
    --line_height = 0.9,
    --cell_width = 0.8,

    -- "Hyper"-like colour scheme
    colors = {
        foreground = "#ffffff",
        background = "#000000",

        cursor_bg = "#ffffff",
        cursor_fg = "#f81ce5",
        cursor_border = "#ffffff",

        selection_fg = "#000000",
        selection_bg = "#ffffff",

        scrollbar_thumb = "#222222",

        split = "#444444",

        ansi = {
            "#000000",
            "#fe0100",
            "#33ff00",
            "#feff00",
            "#0066ff",
            "#cc00ff",
            "#00ffff",
            "#d0d0d0",
        },

        brights = {
            "#808080",
            "#fe0100",
            "#33ff00",
            "#feff00",
            "#0066ff",
            "#cc00ff",
            "#00ffff",
            "#ffffff",
        },
    },

    -- big yoshi 8)
    background = {
        {
            source = { Color = "black" },
            height = "100%",
            width = "100%",
            opacity = 1,
        },
        {
            source = { File = wezterm.home_dir .. "/.config/bigyoshi.png" },
            opacity = 0.2,
            hsb = { brightness = 0.1 },
            height = 100,
            width = 100,
            repeat_x = "NoRepeat",
            repeat_y = "NoRepeat",
            vertical_align = "Middle",
            horizontal_align = "Center"
        },
    },
}

-- os specifics
if PLATFORM_WINDOWS then -- windows
    wezconfig.default_prog = {"pwsh"}

    table.insert(wezconfig.launch_menu, {label = "WSL", args = {"wsl.exe"}})

    table.insert(wezconfig.launch_menu, {label = "PowerShell 7", args = {"pwsh.exe"}})
    table.insert(wezconfig.launch_menu, {label = "PowerShell 5", args = {"powershell.exe"}})
elseif PLATFORM_MACOS then -- macOS
    wezconfig.default_prog = {"zsh", "-l"}
    table.insert(wezconfig.launch_menu, {label = "pwsh", args = {"pwsh"}})

    wezconfig.font_size = 13.0
else
    wezconfig.default_prog = {"/bin/bash", "-l"}

    table.insert(wezconfig.launch_menu, {label = "zsh", args = {"zsh", "-l"}})
    table.insert(wezconfig.launch_menu, {label = "bash", args = {"bash", "-l"}})
    table.insert(wezconfig.launch_menu, {label = "PowerShell Core", args = {"pwsh"}})
end

return wezconfig
