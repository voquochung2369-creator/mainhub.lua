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

    Name = "ESP Selector",

    Click = "Scroll",

    Slot = 1,

    Min = 0,

    Max = 1,

    Save = true,
        
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

            end
        },

        {
            Name = "NPC",

            Callback = function()
                    
            end
        },

        {
            Name = "Chest",

            Callback = function()
                    
            end
        },

        {
            Name = "Fruit",

            Callback = function()
            end
        }

    },

    ChildClick = "Lever",

    ChildName = "Click to Use ESP",

    ChildDefault = false,

    ChildSave = false,

    ChildCallback = function(Value, Selected)

        if Value then

            if Selected[1] == "Player" then

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

                

        else

            if _G.CustomHubESP then
                _G.CustomHubESP.Toggle(false)
            end


        end

    end

})
