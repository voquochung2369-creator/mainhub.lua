local Hub = _G.CustomHub

if not Hub then
    warn("CustomHub Main.lua chưa được load")
    return
end

local Window = Hub.Window
local Test = nil
for _, tab in ipairs(Window.Tabs) do

    if tab.Name == "Test" then

        Test = tab

        break
    end
end

if not Test then

    warn("Không tìm thấy tab Test")
    return
end


Test:AddButton({

    Name = "Auto Join Team",
    Click = "Scroll",
    Slot = 1,
    Default = false,
    Min = 0,
    Max = 1,
    Save = true,
Options = {

    {
        Name = "Marines",

        Callback = function()

            getgenv().Team = "Marines"

            game:GetService("ReplicatedStorage")
                .Remotes
                .CommF_:InvokeServer(
                    "SetTeam",
                    "Marines"
                )

        end
    },


    {
        Name = "Pirates",

        Callback = function()

            getgenv().Team = "Pirates"

            game:GetService("ReplicatedStorage")
                .Remotes
                .CommF_:InvokeServer(
                    "SetTeam",
                    "Pirates"
                )

        end
    }
}
end
end
})
