repeat
    task.wait()
until game:IsLoaded()


task.wait(2)



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
-- REMOVE OLD ESP
--------------------------------------------------

if _G.CustomHubESP then

    pcall(function()

        _G.CustomHubESP.Close()

    end)

end



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



    -- remove leftover highlight

    for _, player in ipairs(
        Players:GetPlayers()
    ) do


        local char =
            player.Character


        if char then


            for _, v in ipairs(
                char:GetChildren()
            ) do


                if v:IsA("Highlight")
                and string.find(
                    v.Name,
                    "ESP"
                ) then


                    v:Destroy()


                end


            end


        end


    end



    -- remove leftover gui

    pcall(function()


        for _, v in ipairs(
            game.CoreGui:GetChildren()
        ) do


            if string.find(
                v.Name,
                "ESP_INFO"
            ) then


                v:Destroy()


            end


        end


    end)



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



    local dead =
        false



    local highlight



    local gui





    --------------------------------------------------
    -- DEATH REMOVE
    --------------------------------------------------

    local deathConnection


    deathConnection =
        humanoid.Died:Connect(
            function()


                dead = true



                if highlight then

                    highlight:Destroy()

                end



                if gui then

                    gui:Destroy()

                end


            end
        )



    table.insert(
        Connections,
        deathConnection
    )







    --------------------------------------------------
    -- BODY OUTLINE
    --------------------------------------------------

    highlight =
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



    if player == LocalPlayer then


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





    -- không hiện text bản thân

    if player == LocalPlayer then

        return

    end






    --------------------------------------------------
    -- INFO GUI
    --------------------------------------------------

    gui =
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

    local updateConnection


    updateConnection =
        RunService.RenderStepped:Connect(
            function()


                if not ESPEnabled
                or dead
                or humanoid.Health <= 0
                or not character.Parent then


                    if gui then

                        gui:Destroy()

                    end


                    if highlight then

                        highlight:Destroy()

                    end



                    updateConnection:Disconnect()


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
        updateConnection
    )


end





--------------------------------------------------
-- SETUP PLAYER RESPAWN
--------------------------------------------------

local function SetupPlayer(
    player
)


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




for _, player in ipairs(
    Players:GetPlayers()
) do


    SetupPlayer(
        player
    )


end




Players.PlayerAdded:Connect(
    function(player)


        SetupPlayer(
            player
        )


    end
)





--------------------------------------------------
-- UPDATE ALL ESP
--------------------------------------------------

local function UpdateESP()


    ClearESP()



    ESPEnabled =
        true



    for _, player in ipairs(
        Players:GetPlayers()
    ) do


        CreateESP(
            player
        )


    end


end





--------------------------------------------------
-- PLAYER REMOVE
--------------------------------------------------

Players.PlayerRemoving:Connect(
    function(player)


        for _, obj in pairs(
            ESPObjects
        ) do


            pcall(function()


                if string.find(
                    obj.Name,
                    player.Name
                ) then


                    obj:Destroy()


                end


            end)


        end


    end
)





--------------------------------------------------
-- HUB API
--------------------------------------------------

_G.CustomHubESP = {


    Toggle =
        function(Value)


            if Value then


                UpdateESP()


            else


                ESPEnabled =
                    false


                ClearESP()


            end


        end,



    Close =
        function()


            ESPEnabled =
                false


            ClearESP()


            _G.CustomHubESP =
                nil


        end


}





warn(
    "CustomHub ESP Player Loaded"
)
