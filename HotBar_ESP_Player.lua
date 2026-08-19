repeat
    task.wait()
until game:IsLoaded()


task.wait(5)



local Players =
    game:GetService("Players")


local RunService =
    game:GetService("RunService")



local LocalPlayer =
    Players.LocalPlayer



local ESPEnabled =
    false



local ESPObjects =
    {}



--------------------------------------------------
-- CLEAR ESP
--------------------------------------------------

local function ClearESP()


    for _, object in ipairs(
        ESPObjects
    ) do


        pcall(function()

            object:Destroy()

        end)

    end


    table.clear(
        ESPObjects
    )

end



--------------------------------------------------
-- CREATE ESP
--------------------------------------------------

local function CreateESP(
    player
)


    if player ==
        LocalPlayer then

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



    --------------------------------------------------
    -- BODY GLOW
    --------------------------------------------------


    local highlight =
        Instance.new(
            "Highlight"
        )


    highlight.Name =
        "ESP_Glow_"
        ..
        player.Name



    highlight.FillColor =
        Color3.fromRGB(
            255,
            0,
            255
        )



    highlight.OutlineColor =
        Color3.fromRGB(
            255,
            255,
            255
        )



    highlight.FillTransparency =
        0.15



    highlight.OutlineTransparency =
        0



    highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop



    highlight.Adornee =
        character



    highlight.Parent =
        character



    table.insert(
        ESPObjects,
        highlight
    )




    --------------------------------------------------
    -- NAME DISTANCE HEALTH
    --------------------------------------------------


    local gui =
        Instance.new(
            "BillboardGui"
        )


    gui.Name =
        "ESP_Info_"
        ..
        player.Name



    gui.Adornee =
        root



    gui.Size =
        UDim2.new(
            0,
            220,
            0,
            90
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



    local text =
        Instance.new(
            "TextLabel"
        )


    text.Size =
        UDim2.new(
            1,
            0,
            1,
            0
        )



    text.BackgroundTransparency =
        1



    text.TextColor3 =
        Color3.fromRGB(
            255,
            0,
            255
        )



    text.TextStrokeColor3 =
        Color3.fromRGB(
            0,
            0,
            0
        )



    text.TextStrokeTransparency =
        0



    text.TextSize =
        16



    text.Font =
        Enum.Font.GothamBold



    text.Parent =
        gui




    --------------------------------------------------
    -- UPDATE TEXT
    --------------------------------------------------


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



                local myCharacter =
                    LocalPlayer.Character



                local myRoot =
                    myCharacter
                    and myCharacter:FindFirstChild(
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



                    local health =
                        math.floor(
                            humanoid.Health
                        )



                    local maxHealth =
                        math.floor(
                            humanoid.MaxHealth
                        )



                    text.Text =
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
                        health
                        ..
                        "/"
                        ..
                        maxHealth
                        ..
                        " Health"


                end


            end
        )

end




--------------------------------------------------
-- UPDATE ALL
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
-- API FOR HUB
--------------------------------------------------

_G.CustomHubESP = {


    Toggle =
        function(
            state
        )


            ESPEnabled =
                state



            if not state then


                ClearESP()


                return

            end



            UpdateESP()



        end

}



warn(
    "CustomHub ESP Player Loaded"
)
