local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local ANIMATION_GUI_NAME = "CustomHub_LoadAnimation"

local ORB_COUNT = 7

local ORB_SIZE = 18
local BIG_ORB_SIZE = 46

local ORBIT_RADIUS = 72

local MOVE_TIME = 1.15
local ORBIT_TIME = 2.2

local BLINK_COUNT = 7
local BLINK_ON_TIME = 0.2
local BLINK_OFF_TIME = 0.3

local MERGE_TIME = 0.65

local EXPLOSION_PIECES = 14
local EXPLOSION_DISTANCE = 105
local EXPLOSION_TIME = 1.15

local FAKE_BUTTON_MOVE_TIME = 1.6

local RANDOM_MARGIN = 90

--------------------------------------------------
-- SERVICES / CAMERA
--------------------------------------------------

local Camera = workspace.CurrentCamera

if not Camera then
    repeat
        task.wait()
        Camera = workspace.CurrentCamera
    until Camera
end

--------------------------------------------------
-- FIND HUB
--------------------------------------------------

local HubUi
local HubButton

local function FindHub()

    HubUi = CoreGui:FindFirstChild("HubUi")

    if not HubUi then
        return false
    end

    HubButton =
        HubUi:FindFirstChild("HubButton")

    if not HubButton then
        return false
    end

    return true
end

--------------------------------------------------
-- WAIT FOR HUB
--------------------------------------------------

local HubFound = false

for _ = 1, 100 do

    if FindHub() then
        HubFound = true
        break
    end

    task.wait(0.05)
end

if not HubFound then

    warn(
        "[CustomHub] LoadScriptAnimation: HubUi/HubButton not found."
    )

    return
end

--------------------------------------------------
-- REMOVE OLD ANIMATION ONLY
--------------------------------------------------

local OldAnimation =
    CoreGui:FindFirstChild(
        ANIMATION_GUI_NAME
    )

if OldAnimation then

    pcall(function()
        OldAnimation:Destroy()
    end)

end

--------------------------------------------------
-- SAVE ORIGINAL HUB BUTTON STATE
--------------------------------------------------

local OriginalPosition =
    HubButton.Position

local OriginalSize =
    HubButton.Size

local OriginalParent =
    HubButton.Parent

local OriginalVisible =
    HubButton.Visible

--------------------------------------------------
-- CREATE ANIMATION GUI
--------------------------------------------------

local AnimationGui =
    Instance.new("ScreenGui")

AnimationGui.Name =
    ANIMATION_GUI_NAME

AnimationGui.ResetOnSpawn =
    false

AnimationGui.IgnoreGuiInset =
    true

AnimationGui.ZIndexBehavior =
    Enum.ZIndexBehavior.Global

AnimationGui.DisplayOrder =
    999999

AnimationGui.Parent =
    CoreGui

--------------------------------------------------
-- HUB BUTTON
--------------------------------------------------
-- Hide ONLY the real HubButton.
-- Never destroy it.

HubButton.Visible = false

--------------------------------------------------
-- CAMERA SIZE
--------------------------------------------------

local function GetViewport()

    local CurrentCamera =
        workspace.CurrentCamera

    if CurrentCamera then

        return CurrentCamera.ViewportSize

    end

    return Vector2.new(
        1920,
        1080
    )
end

--------------------------------------------------
-- CENTER
--------------------------------------------------

local function GetCenter()

    local Viewport =
        GetViewport()

    return Vector2.new(
        Viewport.X / 2,
        Viewport.Y / 2
    )
end

--------------------------------------------------
-- RANDOM POSITION
--------------------------------------------------

local function GetRandomPosition()

    local Viewport =
        GetViewport()

    local x =
        math.random(
            RANDOM_MARGIN,
            math.max(
                RANDOM_MARGIN + 1,
                math.floor(
                    Viewport.X
                    - RANDOM_MARGIN
                )
            )
        )

    local y =
        math.random(
            RANDOM_MARGIN,
            math.max(
                RANDOM_MARGIN + 1,
                math.floor(
                    Viewport.Y
                    - RANDOM_MARGIN
                )
            )
        )

    return Vector2.new(
        x,
        y
    )
end

--------------------------------------------------
-- TWEEN
--------------------------------------------------

local function Tween(
    object,
    time,
    properties,
    easingStyle,
    easingDirection
)

    local tweenInfo =
        TweenInfo.new(
            time,
            easingStyle
                or Enum.EasingStyle.Quad,
            easingDirection
                or Enum.EasingDirection.Out
        )

    local tween =
        TweenService:Create(
            object,
            tweenInfo,
            properties
        )

    tween:Play()

    return tween
end

--------------------------------------------------
-- ORB CREATOR
--------------------------------------------------

local function CreateOrb(
    position,
    index
)

    local Orb =
        Instance.new("Frame")

    Orb.Name =
        "Orb_" .. tostring(index)

    Orb.Size =
        UDim2.fromOffset(
            ORB_SIZE,
            ORB_SIZE
        )

    Orb.Position =
        UDim2.fromOffset(
            position.X
                - ORB_SIZE / 2,
            position.Y
                - ORB_SIZE / 2
        )

    Orb.AnchorPoint =
        Vector2.new(
            0,
            0
        )

    Orb.BackgroundColor3 =
        Color3.fromRGB(
            145,
            45,
            210
        )

    Orb.BackgroundTransparency =
        0

    Orb.BorderSizePixel =
        0

    Orb.ZIndex =
        20

    Orb.Parent =
        AnimationGui

    --------------------------------------------------
    -- ROUND
    --------------------------------------------------

    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(
            1,
            0
        )

    Corner.Parent =
        Orb

    --------------------------------------------------
    -- YELLOW GLOW
    --------------------------------------------------

    local Glow =
        Instance.new("UIStroke")

    Glow.Name =
        "YellowGlow"

    Glow.Color =
        Color3.fromRGB(
            255,
            220,
            40
        )

    Glow.Thickness =
        2

    Glow.Transparency =
        0.05

    Glow.Parent =
        Orb

    --------------------------------------------------
    -- SOFT OUTER GLOW
    --------------------------------------------------

    local OuterGlow =
        Instance.new("UIStroke")

    OuterGlow.Name =
        "OuterGlow"

    OuterGlow.Color =
        Color3.fromRGB(
            255,
            210,
            20
        )

    OuterGlow.Thickness =
        4

    OuterGlow.Transparency =
        0.65

    OuterGlow.Parent =
        Orb

    --------------------------------------------------
    -- STAR
    --------------------------------------------------

    local Star =
        Instance.new("TextLabel")

    Star.Name =
        "Star"

    Star.Size =
        UDim2.fromScale(
            1,
            1
        )

    Star.Position =
        UDim2.fromScale(
            0,
            0
        )

    Star.BackgroundTransparency =
        1

    Star.Text =
        "★"

    Star.TextColor3 =
        Color3.fromRGB(
            255,
            225,
            50
        )

    Star.TextStrokeColor3 =
        Color3.fromRGB(
            255,
            190,
            0
        )

    Star.TextStrokeTransparency =
        0.15

    Star.TextSize =
        11

    Star.Font =
        Enum.Font.GothamBold

    Star.ZIndex =
        21

    Star.Parent =
        Orb

    return Orb
end

--------------------------------------------------
-- CREATE 7 ORBS
--------------------------------------------------

local Orbs = {}

for i = 1, ORB_COUNT do

    local Position =
        GetRandomPosition()

    local Orb =
        CreateOrb(
            Position,
            i
        )

    table.insert(
        Orbs,
        Orb
    )
end

--------------------------------------------------
-- MOVE ORBS TO CENTER
--------------------------------------------------

local Center =
    GetCenter()

local FirstCenterPositions = {}

for i, Orb in ipairs(Orbs) do

    local StartPosition =
        Orb.Position

    FirstCenterPositions[i] =
        StartPosition

    local TargetPosition =
        UDim2.fromOffset(
            Center.X
                - ORB_SIZE / 2,
            Center.Y
                - ORB_SIZE / 2
        )

    Tween(
        Orb,
        MOVE_TIME
            + (i * 0.04),
        {
            Position =
                TargetPosition
        },
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.InOut
    )
end

task.wait(
    MOVE_TIME + 0.15
)

--------------------------------------------------
-- ORBIT
--------------------------------------------------
-- IMPORTANT:
-- The orbs do NOT merge here.
-- They stay separated and rotate
-- around the center.

local OrbitStart =
    os.clock()

local OrbitConnections = {}

while os.clock()
    - OrbitStart
    < ORBIT_TIME do

    local elapsed =
        os.clock()
        - OrbitStart

    local angleOffset =
        elapsed * 1.45

    for i, Orb in ipairs(Orbs) do

        if Orb
            and Orb.Parent then

            local angle =
                angleOffset
                + (
                    (i - 1)
                    * (
                        math.pi * 2
                        / ORB_COUNT
                    )
                )

            local x =
                Center.X
                + math.cos(angle)
                * ORBIT_RADIUS

            local y =
                Center.Y
                + math.sin(angle)
                * ORBIT_RADIUS

            Orb.Position =
                UDim2.fromOffset(
                    x - ORB_SIZE / 2,
                    y - ORB_SIZE / 2
                )

        end
    end

    task.wait()
end

--------------------------------------------------
-- RE-CENTER
--------------------------------------------------

Center =
    GetCenter()

--------------------------------------------------
-- BLINK BORDER 7 TIMES
--------------------------------------------------

for blink = 1, BLINK_COUNT do

    for _, Orb in ipairs(Orbs) do

        local Glow =
            Orb:FindFirstChild(
                "YellowGlow"
            )

        local OuterGlow =
            Orb:FindFirstChild(
                "OuterGlow"
            )

        if Glow then

            Tween(
                Glow,
                BLINK_ON_TIME,
                {
                    Transparency = 0
                },
                Enum.EasingStyle.Linear
            )

        end

        if OuterGlow then

            Tween(
                OuterGlow,
                BLINK_ON_TIME,
                {
                    Transparency = 0.1
                },
                Enum.EasingStyle.Linear
            )

        end
    end

    task.wait(
        BLINK_ON_TIME
    )

    for _, Orb in ipairs(Orbs) do

        local Glow =
            Orb:FindFirstChild(
                "YellowGlow"
            )

        local OuterGlow =
            Orb:FindFirstChild(
                "OuterGlow"
            )

        if Glow then

            Tween(
                Glow,
                BLINK_OFF_TIME,
                {
                    Transparency = 0.35
                },
                Enum.EasingStyle.Linear
            )

        end

        if OuterGlow then

            Tween(
                OuterGlow,
                BLINK_OFF_TIME,
                {
                    Transparency = 0.7
                },
                Enum.EasingStyle.Linear
            )

        end
    end

    task.wait(
        BLINK_OFF_TIME
    )
end

--------------------------------------------------
-- MERGE INTO ONE BIG ORB
--------------------------------------------------

for _, Orb in ipairs(Orbs) do

    if Orb
        and Orb.Parent then

        local Target =
            UDim2.fromOffset(
                Center.X
                    - BIG_ORB_SIZE / 2,
                Center.Y
                    - BIG_ORB_SIZE / 2
            )

        Tween(
            Orb,
            MERGE_TIME,
            {
                Position =
                    Target,

                Size =
                    UDim2.fromOffset(
                        BIG_ORB_SIZE,
                        BIG_ORB_SIZE
                    )
            },
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.In
        )

    end
end

task.wait(
    MERGE_TIME
)

--------------------------------------------------
-- REMOVE 7 ORBS
--------------------------------------------------

for _, Orb in ipairs(Orbs) do

    pcall(function()
        Orb:Destroy()
    end)

end

table.clear(
    Orbs
)

--------------------------------------------------
-- CREATE BIG EXPLOSION CORE
--------------------------------------------------

local ExplosionCore =
    Instance.new("Frame")

ExplosionCore.Name =
    "ExplosionCore"

ExplosionCore.Size =
    UDim2.fromOffset(
        BIG_ORB_SIZE,
        BIG_ORB_SIZE
    )

ExplosionCore.Position =
    UDim2.fromOffset(
        Center.X
            - BIG_ORB_SIZE / 2,
        Center.Y
            - BIG_ORB_SIZE / 2
    )

ExplosionCore.BackgroundColor3 =
    Color3.fromRGB(
        145,
        45,
        210
    )

ExplosionCore.BorderSizePixel =
    0

ExplosionCore.ZIndex =
    30

ExplosionCore.Parent =
    AnimationGui

local CoreCorner =
    Instance.new("UICorner")

CoreCorner.CornerRadius =
    UDim.new(
        1,
        0
    )

CoreCorner.Parent =
    ExplosionCore

local CoreStroke =
    Instance.new("UIStroke")

CoreStroke.Color =
    Color3.fromRGB(
        255,
        220,
        40
    )

CoreStroke.Thickness =
    4

CoreStroke.Transparency =
    0

CoreStroke.Parent =
    ExplosionCore

--------------------------------------------------
-- EXPLOSION PIECES
--------------------------------------------------

local ExplosionPieces = {}

for i = 1, EXPLOSION_PIECES do

    local Piece =
        Instance.new("Frame")

    local PieceSize =
        math.random(
            9,
            17
        )

    Piece.Name =
        "ExplosionPiece_"
        .. tostring(i)

    Piece.Size =
        UDim2.fromOffset(
            PieceSize,
            PieceSize
        )

    Piece.Position =
        UDim2.fromOffset(
            Center.X
                - PieceSize / 2,
            Center.Y
                - PieceSize / 2
        )

    Piece.BackgroundColor3 =
        Color3.fromRGB(
            145
                + math.random(
                    0,
                    35
                ),
            40,
            210
        )

    Piece.BorderSizePixel =
        0

    Piece.ZIndex =
        29

    Piece.Parent =
        AnimationGui

    local PieceCorner =
        Instance.new("UICorner")

    PieceCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    PieceCorner.Parent =
        Piece

    local PieceGlow =
        Instance.new("UIStroke")

    PieceGlow.Color =
        Color3.fromRGB(
            255,
            220,
            40
        )

    PieceGlow.Thickness =
        2

    PieceGlow.Transparency =
        0.15

    PieceGlow.Parent =
        Piece

    table.insert(
        ExplosionPieces,
        Piece
    )
end

--------------------------------------------------
-- LIGHT EXPLOSION
--------------------------------------------------

for i, Piece
    in ipairs(
        ExplosionPieces
    ) do

    local Angle =
        (
            math.pi * 2
            / EXPLOSION_PIECES
        )
        * i

    local Distance =
        EXPLOSION_DISTANCE
        * (
            0.72
            + math.random()
            * 0.28
        )

    local TargetX =
        Center.X
        + math.cos(Angle)
        * Distance

    local TargetY =
        Center.Y
        + math.sin(Angle)
        * Distance

    Tween(
        Piece,
        EXPLOSION_TIME,
        {
            Position =
                UDim2.fromOffset(
                    TargetX
                        - Piece.AbsoluteSize.X
                        / 2,
                    TargetY
                        - Piece.AbsoluteSize.Y
                        / 2
                ),

            BackgroundTransparency =
                0.15
        },
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )

end

--------------------------------------------------
-- CORE FLASH
--------------------------------------------------

Tween(
    ExplosionCore,
    0.22,
    {
        Size =
            UDim2.fromOffset(
                65,
                65
            ),

        Position =
            UDim2.fromOffset(
                Center.X - 32.5,
                Center.Y - 32.5
            )
    },
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

task.wait(
    0.22
)

Tween(
    ExplosionCore,
    0.45,
    {
        Size =
            UDim2.fromOffset(
                8,
                8
            ),

        Position =
            UDim2.fromOffset(
                Center.X - 4,
                Center.Y - 4
            ),

        BackgroundTransparency =
            1
    },
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.In
)

task.wait(
    EXPLOSION_TIME
)

--------------------------------------------------
-- CLEAN EXPLOSION
--------------------------------------------------

for _, Piece
    in ipairs(
        ExplosionPieces
    ) do

    pcall(function()
        Piece:Destroy()
    end)

end

table.clear(
    ExplosionPieces
)

pcall(function()
    ExplosionCore:Destroy()
end)

--------------------------------------------------
-- CREATE FAKE HUB BUTTON
--------------------------------------------------
-- The real HubButton is STILL hidden.
-- Fake button is used only for animation.

local FakeHubButton =
    Instance.new("TextButton")

FakeHubButton.Name =
    "FakeHubButton"

FakeHubButton.Size =
    OriginalSize

FakeHubButton.AnchorPoint =
    Vector2.new(
        0,
        0
    )

FakeHubButton.Position =
    UDim2.fromOffset(
        Center.X
            - OriginalSize.X.Offset / 2,
        Center.Y
            - OriginalSize.Y.Offset / 2
    )

FakeHubButton.BackgroundColor3 =
    Color3.fromRGB(
        25,
        25,
        25
    )

FakeHubButton.BackgroundTransparency =
    0.18

FakeHubButton.BorderSizePixel =
    0

FakeHubButton.Text =
    "H"

FakeHubButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

FakeHubButton.TextStrokeTransparency =
    1

FakeHubButton.TextSize =
    20

FakeHubButton.Font =
    Enum.Font.GothamBold

FakeHubButton.AutoButtonColor =
    false

FakeHubButton.ZIndex =
    50

FakeHubButton.Parent =
    AnimationGui

--------------------------------------------------
-- FAKE CORNER
--------------------------------------------------

local FakeCorner =
    Instance.new("UICorner")

FakeCorner.CornerRadius =
    UDim.new(
        1,
        0
    )

FakeCorner.Parent =
    FakeHubButton

--------------------------------------------------
-- FAKE STROKE
--------------------------------------------------

local FakeStroke =
    Instance.new("UIStroke")

FakeStroke.Color =
    Color3.fromRGB(
        255,
        255,
        255
    )

FakeStroke.Thickness =
    1

FakeStroke.Transparency =
    0.45

FakeStroke.Parent =
    FakeHubButton

--------------------------------------------------
-- FAKE BUTTON APPEAR
--------------------------------------------------

FakeHubButton.BackgroundTransparency =
    0.18

FakeHubButton.TextTransparency =
    0

FakeStroke.Transparency =
    1

Tween(
    FakeHubButton,
    0.35,
    {
        BackgroundTransparency =
            0.18,

        TextTransparency =
            0
    },
    Enum.EasingStyle.Back,
    Enum.EasingDirection.Out
)

Tween(
    FakeStroke,
    0.35,
    {
        Transparency =
            0.45
    },
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

task.wait(
    0.4
)

--------------------------------------------------
-- GET FINAL ORIGINAL POSITION
--------------------------------------------------
-- Read it again because the real HubButton
-- may have been dragged while animation loaded.

local FinalPosition =
    OriginalPosition

if HubButton
    and HubButton.Parent then

    FinalPosition =
        HubButton.Position
end

--------------------------------------------------
-- FAKE BUTTON MOVE TO REAL POSITION
--------------------------------------------------

local MoveTween =
    Tween(
        FakeHubButton,
        FAKE_BUTTON_MOVE_TIME,
        {
            Position =
                FinalPosition
        },
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )

MoveTween.Completed:Wait()

--------------------------------------------------
-- FINAL REVEAL
--------------------------------------------------
-- VERY IMPORTANT:
-- Fake button disappears.
-- Real HubButton becomes visible.
-- Real HubButton is NEVER destroyed.

if HubButton
    and HubButton.Parent then

    HubButton.Position =
        FinalPosition

    HubButton.Visible =
        true

    HubButton.BackgroundTransparency =
        0.18

    HubButton.TextTransparency =
        0

    HubButton.Size =
        OriginalSize
end

--------------------------------------------------
-- REMOVE FAKE BUTTON
--------------------------------------------------

pcall(function()

    if FakeHubButton
        and FakeHubButton.Parent then

        FakeHubButton:Destroy()

    end

end)

--------------------------------------------------
-- REMOVE ANIMATION GUI
--------------------------------------------------

task.wait(
    0.05
)

pcall(function()

    if AnimationGui
        and AnimationGui.Parent then

        AnimationGui:Destroy()

    end

end)

--------------------------------------------------
-- SAFETY
--------------------------------------------------
-- If the real button somehow became invisible,
-- restore it instead of leaving the user without it.

task.defer(function()

    if HubButton
        and HubButton.Parent then

        HubButton.Position =
            FinalPosition

        HubButton.Visible =
            true

    end

end)
