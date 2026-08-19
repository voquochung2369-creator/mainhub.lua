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

local Bloxfruit = nil

for _, tab in ipairs(
    Window.Tabs
) do

    if tab.Name ==
        "Blox Fruit" then

        Bloxfruit =
            tab

        break
    end
end

if not Bloxfruit then

    warn(
        "Không tìm thấy tab Blox Fruit"
    )

    return
end

--------------------------------------------------
-- REAL KID
--------------------------------------------------

Bloxfruit:AddButton({

    Name =
        "Real Kid",

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
                                "https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"
                            )

                        local fn =
                            loadstring(
                                source
                            )

                        if type(fn)
                            ~= "function" then

                            error(
                                "Real Kid load failed"
                            )
                        end

                        return fn()
                    end
                )

            if not success then

                warn(
                    "Real Kid error:",
                    result
                )
            end
        end
})

--------------------------------------------------
-- ONION
--------------------------------------------------

Bloxfruit:AddButton({

    Name =
        "Onion",

    Click =
        "Button",

    Slot =
        2,

    Callback =
        function()

            local success, result =
                pcall(
                    function()

                        local source =
                            game:HttpGet(
                                "https://api.luarmor.net/files/v4/loaders/cc815ef92aaf3ed41a37aa4d87cd93ff.lua"
                            )

                        local fn =
                            loadstring(
                                source
                            )

                        if type(fn)
                            ~= "function" then

                            error(
                                "Onion load failed"
                            )
                        end

                        return fn()
                    end
                )

            if not success then

                warn(
                    "Onion error:",
                    result
                )
            end
        end
})

--------------------------------------------------
-- HERMANOS
--------------------------------------------------

Bloxfruit:AddButton({

    Name =
        "Hermanos'DEV | PVP",

    Click =
        "Button",

    Slot =
        3,

    Callback =
        function()

            local success, result =
                pcall(
                    function()

                        local source =
                            game:HttpGet(
                                "https://raw.githubusercontent.com/hermanos-dev/hermanos-hub/refs/heads/main/Loader.lua"
                            )

                        local fn =
                            loadstring(
                                source
                            )

                        if type(fn)
                            ~= "function" then

                            error(
                                "Hermanos load failed"
                            )
                        end

                        return fn()
                    end
                )

            if not success then

                warn(
                    "Hermanos error:",
                    result
                )
            end
        end
})

--------------------------------------------------
-- Auto Join Team Marines/Pirates
--------------------------------------------------

Bloxfruit:AddButton({
    Name = "Auto Join Team",
    Click = "Scroll",
    Slot = 4,
    Min = 0,
    Max = 1,
    Save = true,
    Options = {
            {
            Name = "Marines",
            Callback =
                function(Name,Selected)
                    getgenv().Team = "Marines"
                end
        },

        {
            Name = "Pirates",
            Callback =
                function(Name,Selected)
                    getgenv().Team = "Pirates"
                end
        }
    },

    ChildClick = "Lever",
    ChildName = "Auto Join Team",
    ChildSave = true,
    ChildDefault = false,
    ChildCallback = function(
            Enabled,
            Selected
        )

        if Enabled then
              task.wait(2) 
            if Selected[1] == "Marines" then
                getgenv().Team = "Marines"
                game:GetService("ReplicatedStorage")
                    .Remotes
                    .CommF_:InvokeServer(
                        "SetTeam",
                        "Marines"
                    )


            elseif Selected[1] == "Pirates" then
                task.wait(2)
                getgenv().Team = "Pirates"
                game:GetService("ReplicatedStorage")
                    .Remotes
                    .CommF_:InvokeServer(
                        "SetTeam",
                        "Pirates"
                    )
            end
        end
    end
})
