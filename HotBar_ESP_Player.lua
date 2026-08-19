repeat
    task.wait()
until game:IsLoaded()


task.wait(5)



--------------------------------------------------
-- ANTI LOAD DUPLICATE
--------------------------------------------------

if _G.CustomHubESPLoaded then

    warn(
        "ESP Player already loaded"
    )

    return

end


_G.CustomHubESPLoaded = true



--------------------------------------------------
-- SERVICES
--------------------------------------------------

local Players =
    game:GetService("Players")


local RunService =
    game:GetService("RunService")



local LocalPlayer =
    Players.LocalPlayer



--------------------------------------------------
-- VARIABLES
--------------------------------------------------

local ESPEnabled =
    false


local ESPObjects =
    {}


local Connections =
    {}




--------------------------------------------------
-- CLEAR ESP
--------------------------------------------------

local function ClearESP()


    for _, obj in pairs(
        ESPObjects
    ) do


        pcall(function()

            obj:Destroy()

        end)

    end


    table.clear(
        ESPObjects
    )



    for _, con in pairs(
        Connections
    ) do


        pcall(function()

            con:Disconnect()

        end)

    end


    table.clear(
        Connections
    )


end




--------------------------------------------------
-- CREATE ESP
--------------------------------------------------

local function CreateESP(
    player
)


    if not ESPEnabled then
        return
    end



    local character =
        player.Character


    if not character then
        return
    end



    local root =
        character:FindFirstChild(
            "HumanoidRootPart"
        )


    local humanoid =
        character:FindFirstChild(
            "Humanoid"
        )



    if not root
    or not humanoid then

        return

    end



    local IsSelf =
        player == LocalPlayer



    --------------------------------------------------
    -- BODY OUTLINE
    --------------------------------------------------

    local highlight =
        Instance.new(
            "Highlight"
        )


    highlight.Name =
        "ESP_"..player.Name



    highlight.Adornee =
        character



    highlight.FillTransparency =
        1



    highlight.OutlineTransparency =
        0



    highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop



    if IsSelf then


        highlight.OutlineColor =
            Color3.fromRGB(
                170,
                0,
                255
            )


    else


        highlight.OutlineColor =
            Color3.fromRGB(
                255,
                0,
                255
            )


    end



    highlight.Parent =
        character



    table.insert(
        ESPObjects,
        highlight
    )



    --------------------------------------------------
    -- SELF NO TEXT
    --------------------------------------------------

    if IsSelf then

        return

    end




    --------------------------------------------------
    -- INFO GUI
    --------------------------------------------------

    local gui =
        Instance.new(
            "BillboardGui"
        )


    gui.Name =
        "ESP_INFO_"..player.Name



    gui.Adornee =
        root



    gui.Size =
        UDim2.new(
            0,
            220,
            0,
            80
        )



    gui.StudsOffset =
        Vector3.new(
            0,
            4,
            0
        )



    gui.AlwaysOnTop =
        true



    gui.Parent =
        game.CoreGui



    table.insert(
        ESPObjects,
        gui
    )



    local label =
        Instance.new(
            "TextLabel"
        )



    label.Size =
        UDim2.new(
            1,
            0,
            1,
            0
        )



    label.BackgroundTransparency =
        1



    label.TextColor3 =
        Color3.fromRGB(
            255,
            0,
            255
        )



    label.TextStrokeTransparency =
        0



    label.TextSize =
        16



    label.Font =
        Enum.Font.GothamBold



    label.Parent =
        gui





    local connection


    connection =
        RunService.RenderStepped:Connect(
            function()


                if not ESPEnabled then


                    connection:Disconnect()


                    return

                end



                if not character.Parent then


                    connection:Disconnect()


                    return

                end



                local myChar =
                    LocalPlayer.Character



                local myRoot =
                    myChar
                    and myChar:FindFirstChild(
                        "HumanoidRootPart"
                    )



                if myRoot then


                    local distance =
                        math.floor(
                            (
                                myRoot.Position
                                -
                                root.Position
                            ).Magnitude
                        )



                    label.Text =
                        player.Name
                        ..
                        "\n"
                        ..
                        distance
                        ..
                        "m"
                        ..
                        "\n"
                        ..
                        math.floor(
                            humanoid.Health
                        )
                        ..
                        "/"
                        ..
                        math.floor(
                            humanoid.MaxHealth
                        )
                        ..
                        " Health"

                end


            end
        )



    table.insert(
        Connections,
        connection
    )


end





--------------------------------------------------
-- UPDATE ESP
--------------------------------------------------

local function UpdateESP()


    ClearESP()



    if not ESPEnabled then
        return
    end



    for _, player in ipairs(
        Players:GetPlayers()
    ) do


        CreateESP(
            player
        )


    end


end





--------------------------------------------------
-- PLAYER JOIN
--------------------------------------------------

Players.PlayerAdded:Connect(
    function(player)


        player.CharacterAdded:Connect(
            function()


                task.wait(1)


                if ESPEnabled then


                    CreateESP(
                        player
                    )


                end


            end
        )


    end
)





--------------------------------------------------
-- HUB API
--------------------------------------------------

_G.CustomHubESP = {


    Toggle =
        function(
            Value
        )


            ESPEnabled =
                Value



            if Value then


                UpdateESP()


            else


                ClearESP()


            end


        end,



    Close =
        function()


            ESPEnabled =
                false



            ClearESP()



            _G.CustomHubESPLoaded =
                false


        end

}





warn(
    "CustomHub ESP Player Loaded"
)
