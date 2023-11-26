-- local set = dofile("/home/mizosu/Projects/set/set.lua")

local set = require("set")

set.makeScreen(
    "main", -- Screen ID, main is always first and always needed
    "My main screen", -- Screen Title
    { -- buttons
        {"add 1 + 1", function()
            set.write(1 + 1, 1)
        end},
        {"say hi", function()
            set.write("hi", 1)
        end},
	{"say hello", function()
		set.write("hello", 2)
	end},
    {"say dale gribble", function()
        set.write("SAYING G", 1)
		for i = 1, 10, 1 do
            set.write("dale gribble", 2)
        end
	end},
        {"screen 2", function()
            set.setScreen("screen2")
        end}
    }
)
set.makeScreen(
    "screen2", -- Screen ID
    "My second screen", -- Screen Title
    { -- buttons
        {"sub 5 - 3", function()
            set.write(5 - 3, 1)
        end},
        {"say bye", function()
            set.write("bye", 1)
        end}
    }
)

set.run()
