local Hub = _G.CustomHub

if not Hub then
    warn("CustomHub Main.lua chưa được load")
    return
end

local Window = Hub.Window

--------------------------------------------------
-- FIND TAB
--------------------------------------------------

local ESP = nil

for _, tab in ipairs(Window.Tabs) do
    if tab.Name == "ESP" then
        ESP = tab
        break
    end
end

if not ESP then
    warn("Không tìm thấy tab ESP")
    return
end

--------------------------------------------------
-- ESP SELECTOR
--------------------------------------------------

ESP:AddButton({

    Name = "ESP LIST",

    Click = "Scroll",

    Slot = 1,

    Min = 0,

    Max = 4,

    Save = true,

    Classic = {
        "Player"
    },

    Options = {

        {
            Name = "Player",

            Callback = function(Name, Selected)

                if not _G.CustomHubESP then

                    local source = game:HttpGet(
                        "https://raw.githubusercontent.com/voquochung2369-creator/mainhub.lua/refs/heads/main/HotBar_ESP_Player.lua"
                    )

                    local fn = loadstring(source)

                    if fn then
                        fn()
                    end
                end

                print("Player ESP Loaded")

            end
        },

        {
            Name = "NPC",

            Callback = function()
                print("NPC ESP Selected")
            end
        },

        {
            Name = "Chest",

            Callback = function()
                print("Chest ESP Selected")
            end
        },

        {
            Name = "Fruit",

            Callback = function()
                print("Fruit ESP Selected")
            end
        }
    },

    ChildClick = "Lever",

    ChildName = "ESP",

    ChildDefault = false,

    ChildSave = false,

    ChildCallback = function(Value, Selected)

        if Value then

            for _, name in ipairs(Selected) do

                if name == "Player" then

                    if not _G.CustomHubESP then

                        local source = game:HttpGet(
                            "https://raw.githubusercontent.com/voquochung2369-creator/mainhub.lua/refs/heads/main/HotBar_ESP_Player.lua"
                        )

                        local fn = loadstring(source)

                        if fn then
                            fn()
                        end
                    end

                    if _G.CustomHubESP then
                        _G.CustomHubESP.Toggle(true)
                    end
                end
            end

            print("Auto Execute ON")

        else

            if _G.CustomHubESP then
                _G.CustomHubESP.Toggle(false)
            end

            print("Auto Execute OFF")

        end
    end
})
