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

--------------------------------------------------
-- FIND TAB
--------------------------------------------------

local ESP = nil

for _, tab in ipairs(
    Window.Tabs
) do

    if tab.Name ==
        "ESP" then

        ESP =
            tab

        break
    end
end

if not ESP then

    warn(
        "Không tìm thấy tab ESP"
    )

    return
end

--------------------------------------------------
-- PLAYER ESP
--------------------------------------------------

ESP:AddButton({

    Name =
        "Player ESP",

    Click =
        "Lever",

    Slot =
        1,

    Default =
        false,

    Save =
        true,

Callback = function(Value)

    if not _G.CustomHubESP then

        local source =
            game:HttpGet(
            "https://raw.githubusercontent.com/voquochung2369-creator/mainhub.lua/refs/heads/main/HotBar_ESP_Player.lua"
            )

        loadstring(source)()

    end


    if _G.CustomHubESP then

        _G.CustomHubESP.Toggle(Value)

    end

end
})

--------------------------------------------------
-- ESP SELECTOR
--------------------------------------------------

ESP:AddButton({

    Name =
        "ESP Selector",

    Click =
        "Scroll",

    Slot =
        2,

    Min =
        1,

    Max =
        2,

    Save =
        true,

    Classic = {

        "Player"
    },

    Options = {

        {
            Name =
                "Player",

            Callback =
                function()

                    print(
                        "Player option"
                    )
                end
        },

        {
            Name =
                "NPC",

            Callback =
                function()

                    print(
                        "NPC option"
                    )
                end
        },

        {
            Name =
                "Chest",

            Callback =
                function()

                    print(
                        "Chest option"
                    )
                end
        },

        {
            Name =
                "Fruit",

            Callback =
                function()

                    print(
                        "Fruit option"
                    )
                end
        }
    },

    ChildClick =
        "Lever",

    ChildName =
        "Auto Execute",

    ChildDefault =
        false,

    ChildSave =
        true,

    ChildCallback =
        function(
            Value,
            Selected
        )

            if Value then

                print(
                    "Auto Execute ON"
                )

                for _, name in ipairs(
                    Selected
                ) do

                    print(
                        "Auto:",
                        name
                    )
                end

            else

                print(
                    "Auto Execute OFF"
                )
            end
        end
})
