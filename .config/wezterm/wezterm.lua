local wezterm = require 'wezterm';

-- TODO: this sucks, probably some better way to do this
local pg = wezterm.font_with_fallback{"PragmataPro Liga", "Consolas"};
local pg_bold = wezterm.font_with_fallback{
    {family = "PragmataPro Liga", weight = "Bold"},
    "Consolas"
};
local pg_italic = wezterm.font_with_fallback{
    {family = "PragmataPro Liga", italic = true},
    "Consolas"
};
local pg_bolditalic = wezterm.font_with_fallback{
    {family = "PragmataPro Liga", weight = "Bold", italic = true},
    "Consolas"
};

local wezconfig = {
    font = wezterm.font("PragmataPro Liga"),
    font = pg,
    font_size = 11.0,
    
    font_rules = {
        {intensity = "Bold", font = pg_bold},
        {italic = true, font = pg_italic},
        {intensity = "Bold", italic = true, font = pg_bolditalic},
    },
    
    enable_kitty_graphics = true,
    --hide_tab_bar_if_only_one_tab = true,

    launch_menu = {},

    -- tmux like keys for pweanes
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
}

-- os specifics
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    wezconfig.default_prog = {"pwsh"}

    table.insert(wezconfig.launch_menu, {label = "PowerShell 7", args = {"pwsh.exe"}})
    table.insert(wezconfig.launch_menu, {label = "PowerShell 5", args = {"powershell.exe"}})
else
    wezconfig.default_prog = {"/bin/bash", "-l"}

    table.insert(wezconfig.launch_menu, {label = "zsh", args = {"zsh", "-l"}})
    table.insert(wezconfig.launch_menu, {label = "bash", args = {"bash", "-l"}})
    table.insert(wezconfig.launch_menu, {label = "PowerShell Core", args = {"pwsh"}})
end

return wezconfig