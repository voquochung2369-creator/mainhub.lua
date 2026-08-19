repeat
    task.wait()
until game:IsLoaded()


task.wait(5)



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
-- CLEAR ALL ESP
--------------------------------------------------

local function ClearESP()


    ESPEnabled =
        false



    -- Remove saved objects

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




    -- Disconnect loops

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




    -- Remove Highlight left behind

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





    -- Remove text ESP

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




    local self =
        player == LocalPlayer





    --------------------------------------------------
    -- OUTLINE
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




    if self then


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





    -- Không tạo text cho bản thân

    if self then

        return

    end





    --------------------------------------------------
    -- TEXT INFO
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
        connection
    )


end






--------------------------------------------------
-- UPDATE
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
-- NEW PLAYER
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
-- HUB CONTROL
--------------------------------------------------

_G.CustomHubESP = {


    Toggle =
        function(
            Value
        )


            if Value then


                UpdateESP()


            else


                ClearESP()


            end


        end,



    Close =
        function()


            ClearESP()


            _G.CustomHubESP =
                nil


        end


}





warn(
    "CustomHub ESP Player Loaded"
)
