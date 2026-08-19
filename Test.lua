local Hub =
    _G.CustomHub

if not Hub then

    warn(
        "CustomHub Main.lua chưa được load"
    )

    return
end

local Window =
    Hub.Window

local Test = Window({
    Name = "Test",
    Slot = 1
})

Test:AddButton({

    Name = "Team",
    Click = "Scroll",

    Save = true,
    Default = false,

    Min = 1,
    Max = 1,

    Options = {
        {
            Name = "Marines",

            Callback = function()

                getgenv().Team = "Marines"

            end
        },

        {
            Name = "Pirates",

            Callback = function()

                getgenv().Team = "Pirates"

            end
        }
    },

    ChildClick = "Lever",

    ChildName = "Auto Select Team",

    ChildSave = true,

    ChildDefault = false,

    ChildCallback = function(enabled, selected)

        if enabled then

            if selected[1] == "Marines" then

                getgenv().Team = "Marines"

            elseif selected[1] == "Pirates" then

                getgenv().Team = "Pirates"

            end

        end

    end
})
