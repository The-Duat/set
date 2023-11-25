local set = dofile("/home/mizosu/Projects/set/set.lua")

set.makeScreen(
    "main", -- Screen ID, main is always first and always needed
    "My main screen", -- Screen Title
    { -- buttons
        {"add 1 + 1", function()
            set.write(1 + 1)
        end},
        {"say hi", function()
            set.write("hi")
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
            set.write(5 - 3)
        end},
        {"say bye", function()
            set.write("bye")
        end}
    }
)

set.run()