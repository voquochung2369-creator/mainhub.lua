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

local Setting = nil

for _, tab in ipairs(
    Window.Tabs
) do

    if tab.Name ==
        "Setting" then

        Setting =
            tab

        break
    end
end

if not Setting then

    warn(
        "Không tìm thấy tab Setting"
    )

    return
end

--------------------------------------------------
-- FAST MODE
--------------------------------------------------

Setting:AddButton({

    Name =
        "Fast Mode",

    Click =
        "Button",

    Slot =
        1,

    Callback =
        function()

            local success, result =
                pcall(
                    function()

                        local source =
                            game:HttpGet(
                                "https://raw.githubusercontent.com/voquochung2369-creator/ScriptFastmode/refs/heads/main/Fastmode"
                            )

                        local fn =
                            loadstring(
                                source
                            )

                        if type(fn)
                            ~= "function" then

                            error(
                                "Fast Mode load failed"
                            )
                        end

                        return fn()
                    end
                )

            if not success then

                warn(
                    "Fast Mode error:",
                    result
                )
            end
        end
})

--------------------------------------------------
-- AUTO FAST MODE
--------------------------------------------------

Setting:AddButton({

    Name =
        "Auto Fast Mode",

    Click =
        "Lever",

    Slot =
        2,

    Default =
        false,

    Save =
        true,

    Callback =
        function(
            Value
        )

            if Value then

                local success, result =
                    pcall(
                        function()

                            local source =
                                game:HttpGet(
                                    "https://raw.githubusercontent.com/voquochung2369-creator/ScriptFastmode/refs/heads/main/Fastmode"
                                )

                            local fn =
                                loadstring(
                                    source
                                )

                            if type(fn)
                                ~= "function" then

                                error(
                                    "Auto Fast Mode load failed"
                                )
                            end

                            return fn()
                        end
                    )

                if not success then

                    warn(
                        "Auto Fast Mode error:",
                        result
                    )
                end
            end
        end
})

--------------------------------------------------
-- FRUIT SELECTOR
--------------------------------------------------

Setting:AddButton({

    Name =
        "Fruit Selector",

    Click =
        "Scroll",

    Slot =
        3,

    Min =
        1,

    Max =
        3,

    Save =
        true,

    Classic = {

        "Apple",
        "Orange"
    },

    Options = {

        {
            Name =
                "Apple",

            Callback =
                function(
                    Name,
                    Selected
                )

                    print(
                        "Apple selected"
                    )
                end
        },

        {
            Name =
                "Orange",

            Callback =
                function(
                    Name,
                    Selected
                )

                    print(
                        "Orange selected"
                    )
                end
        },

        {
            Name =
                "Dragon",

            Callback =
                function(
                    Name,
                    Selected
                )

                    print(
                        "Dragon selected"
                    )
                end
        },

        {
            Name =
                "Grape",

            Callback =
                function(
                    Name,
                    Selected
                )

                    print(
                        "Grape selected"
                    )
                end
        },

        {
            Name =
                "Banana",

            Callback =
                function(
                    Name,
                    Selected
                )

                    print(
                        "Banana selected"
                    )
                end
        }
    },

    ChildClick =
        "Button",

    ChildName =
        "Execute Selected",

    Callback =
        function(
            Selected
        )

            print(
                "Selected count:",
                #Selected
            )

            for _, name in ipairs(
                Selected
            ) do

                print(
                    "Execute:",
                    name
                )
            end
        end
})
