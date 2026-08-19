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

    Name =
        "Auto Join Team",

    Click =
        "Scroll",

    Slot =
        1,

    Min =
        0,

    Max =
        1,

    Save =
        true,


    Options = {

        {

            Name =
                "Marines",

            Callback =
                function(
                    Name,
                    Selected
                )

                    getgenv().Team =
                        "Marines"

                end
        },


        {

            Name =
                "Pirates",

            Callback =
                function(
                    Name,
                    Selected
                )

                    getgenv().Team =
                        "Pirates"

                end
        }
    },


    ChildClick =
        "Lever",


    ChildName =
        "Auto Join Team",


    ChildSave =
        true,


    ChildDefault =
        false,


    ChildCallback =
        function(
            Enabled,
            Selected
        )


        if Enabled then

              task.wait(3)
                
            if Selected[1] == "Marines" then


                getgenv().Team =
                    "Marines"


                game:GetService("ReplicatedStorage")
                    .Remotes
                    .CommF_:InvokeServer(
                        "SetTeam",
                        "Marines"
                    )


            elseif Selected[1] == "Pirates" then

                task.wait(3)
                    
                getgenv().Team =
                    "Pirates"


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
