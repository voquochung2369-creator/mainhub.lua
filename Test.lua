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

local Test = nil

for _, tab in ipairs(
    Window.Tabs
) do

    if tab.Name ==
        "Test" then

        Setting =
            tab

        break
    end
end

if not Test then

    warn(
        "Không tìm thấy tab Test"
    )

    return
end

Test:AddButton({
    Name = "Auto Join Marines",
    Click = "Lever",
    Slot = 1,
    Default = false,
    Save = true,
    Callback =
        function(
            Value
        )
                                getgenv().Team = "Marines"
                            if type(fn)
                                ~= "function" then

                                error(
                                    "Auto Join Marines fail"
                                )
                            end

                            return fn()
                        end
                    )

                if not success then

                    warn(
                        "Auto Join Marines error:",
                        result
                    )
                end
            end
        end
})
