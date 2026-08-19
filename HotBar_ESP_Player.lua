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


local ESPFolder =
    Instance.new("Folder")

ESPFolder.Name =
    "CustomHub_PlayerESP"

ESPFolder.Parent =
    workspace



local function ClearESP()

    for _, v in ipairs(
        ESPFolder:GetChildren()
    ) do

        v:Destroy()

    end

end



local function CreateESP(player)

    if player == LocalPlayer then
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


    if not root or not humanoid then
        return
    end



    -- BOX

    local box =
        Instance.new(
            "BoxHandleAdornment"
        )

    box.Name =
        player.Name.."_Box"


    box.Adornee =
        root


    box.Size =
        Vector3.new(
            4,
            6,
            2
        )


    box.Color3 =
        Color3.fromRGB(
            255,
            0,
            255
        )


    box.Transparency =
        0.45


    box.AlwaysOnTop =
        true


    box.ZIndex =
        10


    box.Parent =
        ESPFolder



    -- INFO TEXT

    local gui =
        Instance.new(
            "BillboardGui"
        )


    gui.Name =
        player.Name.."_Info"


    gui.Adornee =
        root


    gui.Size =
        UDim2.new(
            0,
            250,
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
        ESPFolder



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


                    local hp =
                        math.floor(
                            humanoid.Health
                        )


                    local maxHp =
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
                        hp
                        ..
                        "/"
                        ..
                        maxHp
                        ..
                        " Health"

                end

            end
        )

end



local function RefreshESP()

    ClearESP()


    if not ESPEnabled then
        return
    end


    for _, player in ipairs(
        Players:GetPlayers()
    ) do


        if player.Character then

            CreateESP(player)

        end


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

end



Players.PlayerAdded:Connect(
    function(player)

        player.CharacterAdded:Connect(
            function()

                task.wait(1)

                RefreshESP()

            end
        )

    end
)



_G.CustomHubESP = {

    Toggle =
        function(state)

            ESPEnabled =
                state

            RefreshESP()

        end
}
