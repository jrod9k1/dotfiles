local wezterm = require 'wezterm';

-- equivalent to POSIX basename(3)
-- given "/foo/bar" returns "bar"
-- given "C:\\foo\\bar" returns "bar"
local function basename(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

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

-- if it's stupud and it works.. well it's still stupid admittedly
local SUP_IDX = {"¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "¹⁰",
                "¹¹", "¹²", "¹³", "¹⁴", "¹⁵", "¹⁶", "¹⁷", "¹⁸", "¹⁹", "²⁰"}

local SUB_IDX = {"₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₁₀",
                "₁₁", "₁₂", "₁₃", "₁₄", "₁₅", "₁₆", "₁₇", "₁₈", "₁₉", "₂₀"}

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
    local exec_name = basename(process_name):gsub("%.exe$", "")

    if exec_name == "pwsh" or exec_name == "powershell" then
        title_with_icon = PS_ICON .. " pwsh"
    elseif exec_name == "ssh" then
        title_with_icon = TUX_ICON .. " " .. pane_title
    else
        title_with_icon = HOURGLASS_ICON .. " " .. exec_name
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

local wezconfig = {
    font = wezterm.font("PragmataPro Mono Liga"),
    --font = wezterm.font("PragmataPro Mono"),
    --font = pg,
    font_size = 11.0,

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

    launch_menu = {},
    -- TODO: ???
    -- launch_menu = launch_menu,

    use_fancy_tab_bar = false,
    hide_tab_bar_if_only_one_tab = true,
    warn_about_missing_glyphs = false,
    adjust_window_size_when_changing_font_size = false,
    check_for_updates = false,    

    -- for some reason it falls back on my machine to the CPU "Software" renderer
    -- which makes typing on maximized 4k windows slow and outputting lots of text
    -- in tmux windows VERY slow
    front_end = "OpenGL",

    -- tmux like keys for panes
    leader = {key = "s", mods = "CTRL"},
    keys = {
        {key = '"',             mods = "LEADER|SHIFT",  action = wezterm.action{SplitVertical = {domain = "CurrentPaneDomain"}}},
        {key = "%",             mods = "LEADER|SHIFT",  action = wezterm.action{SplitHorizontal = {domain = "CurrentPaneDomain"}}},

        {key = "LeftArrow",     mods = "ALT",           action = wezterm.action{ActivatePaneDirection = "Left"}},
        {key = "RightArrow",    mods = "ALT",           action = wezterm.action{ActivatePaneDirection = "Right"}},
        {key = "DownArrow",     mods = "ALT",           action = wezterm.action{ActivatePaneDirection = "Down"}},
        {key = "UpArrow",       mods = "ALT",           action = wezterm.action{ActivatePaneDirection = "Up"}},

        {key = "z",             mods = "LEADER",        action = "TogglePaneZoomState"},
        {key = "x",             mods = "LEADER",        action = wezterm.action{CloseCurrentPane={confirm = true}}},

        {key = "t",             mods = "CTRL|SHIFT",    action = wezterm.action{SpawnTab = "CurrentPaneDomain"}},
        {key = "w",             mods = "CTRL|SHIFT",    action = wezterm.action{CloseCurrentTab = {confirm = true}}},
        {key = "RightArrow",    mods = "CTRL|SHIFT",    action = wezterm.action{ActivateTabRelative = 1}},
        {key = "LeftArrow",     mods = "CTRL|SHIFT",    action = wezterm.action{ActivateTabRelative = -1}},
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
    line_height = 0.9,
    cell_width = 0.8,

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
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    wezconfig.default_prog = {"pwsh"}

    table.insert(wezconfig.launch_menu, {label = "Ubuntu", args = {"ubuntu.exe"}})

    table.insert(wezconfig.launch_menu, {label = "PowerShell 7", args = {"pwsh.exe"}})
    table.insert(wezconfig.launch_menu, {label = "PowerShell 5", args = {"powershell.exe"}})
else
    wezconfig.default_prog = {"/bin/bash", "-l"}

    table.insert(wezconfig.launch_menu, {label = "zsh", args = {"zsh", "-l"}})
    table.insert(wezconfig.launch_menu, {label = "bash", args = {"bash", "-l"}})
    table.insert(wezconfig.launch_menu, {label = "PowerShell Core", args = {"pwsh"}})
end

return wezconfig
