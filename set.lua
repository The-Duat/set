local set = {}

local function x(cmd)
    os.execute(cmd)
end

local function raw()
    x("stty raw -echo")
end

local function sane()
    x("stty sane")
end

local arrows = {
    ["\27[A"] = "up",
    ["\27[B"] = "down",
    ["\27[D"] = "left",
    ["\27[C"] = "right"
}
local misc = {
    ["\13"]  = "enter",
    ["\8"]   = "back",
    ["\127"] = "back",
    ["x"]  = "quit"
}
-- Get real-time input of either arrow keys, enter, backspace, or x.
local function getNavKey()
    raw()
    local key = "none"
    while true do
        local c = io.read(1)
        if misc[c] then key = misc[c] break
        else
            c = c .. io.read(2)
            if arrows[c] then key = arrows[c] break end
        end
    end
    sane()
    return key
end



local SCREENS = {} -- Table holding all screens.
local CURRENTSCREEN = "main" -- Currently active screen
local BUTTONSELECT = 1 -- Currently active button on screen
local SCREENHISTORY = {"main"} -- Screen view history

--[=[
    Template screen look and function usage
    screen = {
        ["title"] = "Screen Title",
        ["buttons"] = {
            {"Button Text", function()
                print("the code to be ran when the button is pressed.")
            end}
        }
    }
]=]--

local function drawScreen(id)
    local screen = SCREENS[id]
    x("clear")
    print(screen.title)
    local width = 0
    for _,i in pairs(screen.buttons) do
        if #i[1] > width then
            width = #i[1]
        end
    end
    width = width + 5
    local hyphens = ""
    for i = 0, width, 1 do
        hyphens = hyphens .. "─"
    end
    print("┌" .. hyphens .. "┐")
    local i = 1
    while i <= #screen.buttons do
        local paddingcount = width-4 - #screen.buttons[i][1]
        local padding = ""
        for i = 0, paddingcount, 1 do
            padding = padding .. " "
        end
        if i == BUTTONSELECT then
            print("│  ✩ " .. screen.buttons[i][1] .. padding .. "│")
        else
            print("│    " .. screen.buttons[i][1] .. padding .. "│")
        end
        i = i + 1
    end
    print("└" .. hyphens .. "┘")
    print(" ")
end

local function writeOutput(txt)
    local text = tostring(txt)
    local width = #text + 3
    local hyphens = ""
    for i = 0, width-2, 1 do
        hyphens = hyphens .. "─"
    end
    print("┌" .. hyphens .. "┐")
    print("│ " .. text .. " │")
    print("└" .. hyphens .. "┘")
end



set.write = function(text)
    writeOutput(text)
end

set.makeScreen = function(id, title, buttons)
    local screen = {}
    screen["title"] = title
    screen["buttons"] = buttons
    SCREENS[id] = screen
end

set.setScreen = function(id)
    if SCREENS[id] then
        BUTTONSELECT = 1
        CURRENTSCREEN = id
        drawScreen(id)
        table.insert(SCREENHISTORY, id)
    end
end

set.run = function()
    drawScreen("main")
    while true do
        local key = getNavKey()
        if key == "down" then
            if BUTTONSELECT == #SCREENS[CURRENTSCREEN].buttons then
                BUTTONSELECT = 1
            else
                BUTTONSELECT = BUTTONSELECT + 1
            end
            drawScreen(CURRENTSCREEN)
        elseif key == "up" then
            if BUTTONSELECT == 1 then
                BUTTONSELECT = #SCREENS[CURRENTSCREEN].buttons
            else
                BUTTONSELECT = BUTTONSELECT - 1
            end
            drawScreen(CURRENTSCREEN)
        elseif key == "enter" then
            SCREENS[CURRENTSCREEN]["buttons"][BUTTONSELECT][2]()
        elseif key == "back" then
            if #SCREENHISTORY ~= 1 then
                table.remove(SCREENHISTORY)
                set.setScreen(SCREENHISTORY[#SCREENHISTORY])
            end
        elseif key == "quit" then
            x("clear")
            break
        end
    end
end

return set