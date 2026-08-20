local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local ANIMATION_GUI_NAME = "CustomHub_LoadAnimation"

local ORB_COUNT = 7
local ORB_SIZE = 34
local BIG_ORB_SIZE = 72

local ORB_COLOR = Color3.fromRGB(145,80,210)
local ORB_COLOR_DARK = Color3.fromRGB(105,45,170)

local GLOW_COLOR = Color3.fromRGB(255,220,40)
local STAR_COLOR = Color3.fromRGB(255,230,40)

local ORBIT_RADIUS = 105
local ORBIT_SPEED = 0.65

local FLY_TIME = 0.75
local MERGE_TIME = 0.75

local BLINK_COUNT = 7
local BLINK_ON_TIME = 0.2
local BLINK_OFF_TIME = 0.3

local EXPLOSION_TIME = 1.25
local DEBRIS_COUNT = 16

--------------------------------------------------
-- REMOVE OLD ANIMATION
--------------------------------------------------

local oldAnimation = CoreGui:FindFirstChild(
    ANIMATION_GUI_NAME
)

if oldAnimation then
    pcall(function()
        oldAnimation:Destroy()
    end)
end

--------------------------------------------------
-- FIND HUB UI
--------------------------------------------------

local HubUi = CoreGui:FindFirstChild("HubUi")

if not HubUi then
    warn("[CustomHub] HubUi not found")
    return
end

local HubButton = HubUi:FindFirstChild("HubButton")

if not HubButton then
    warn("[CustomHub] HubButton not found")
    return
end

--------------------------------------------------
-- SAVE ORIGINAL HUB BUTTON POSITION
--------------------------------------------------

local OriginalPosition = HubButton.Position
local OriginalSize = HubButton.Size
local OriginalVisible = HubButton.Visible

--------------------------------------------------
-- CREATE ANIMATION GUI
--------------------------------------------------

local AnimationGui = Instance.new("ScreenGui")

AnimationGui.Name = ANIMATION_GUI_NAME
AnimationGui.ResetOnSpawn = false
AnimationGui.IgnoreGuiInset = true
AnimationGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
AnimationGui.DisplayOrder = 999999
AnimationGui.Parent = CoreGui

--------------------------------------------------
-- CAMERA / CENTER
--------------------------------------------------

local function GetCenter()
    local Camera = workspace.CurrentCamera

    if not Camera then
        return Vector2.new(0,0)
    end

    local Size = Camera.ViewportSize

    return Vector2.new(
        Size.X / 2,
        Size.Y / 2
    )
end

--------------------------------------------------
-- CREATE ORB
--------------------------------------------------

local function CreateOrb()
    local Holder = Instance.new("Frame")

    Holder.Name = "Orb"
    Holder.Size = UDim2.fromOffset(
        ORB_SIZE,
        ORB_SIZE
    )

    Holder.AnchorPoint = Vector2.new(
        0.5,
        0.5
    )

    Holder.BackgroundTransparency = 1
    Holder.BorderSizePixel = 0
    Holder.ZIndex = 20
    Holder.Parent = AnimationGui

    --------------------------------------------------
    -- GLOW
    --------------------------------------------------

    local Glow = Instance.new("Frame")

    Glow.Name = "Glow"
    Glow.Size = UDim2.new(
        1,
        12,
        1,
        12
    )

    Glow.Position = UDim2.fromOffset(
        -6,
        -6
    )

    Glow.BackgroundColor3 = GLOW_COLOR
    Glow.BackgroundTransparency = 0.72
    Glow.BorderSizePixel = 0
    Glow.ZIndex = 19
    Glow.Parent = Holder

    local GlowCorner = Instance.new("UICorner")

    GlowCorner.CornerRadius = UDim.new(
        1,
        0
    )

    GlowCorner.Parent = Glow

    --------------------------------------------------
    -- PURPLE ORB
    --------------------------------------------------

    local Orb = Instance.new("Frame")

    Orb.Name = "PurpleOrb"
    Orb.Size = UDim2.fromScale(
        1,
        1
    )

    Orb.BackgroundColor3 = ORB_COLOR
    Orb.BorderSizePixel = 0
    Orb.ZIndex = 21
    Orb.Parent = Holder

    local OrbCorner = Instance.new("UICorner")

    OrbCorner.CornerRadius = UDim.new(
        1,
        0
    )

    OrbCorner.Parent = Orb

    --------------------------------------------------
    -- DARK INNER CIRCLE
    --------------------------------------------------

    local Inner = Instance.new("Frame")

    Inner.Name = "Inner"
    Inner.Size = UDim2.new(
        0.68,
        0,
        0.68,
        0
    )

    Inner.Position = UDim2.new(
        0.16,
        0,
        0.16,
        0
    )

    Inner.BackgroundColor3 = ORB_COLOR_DARK
    Inner.BackgroundTransparency = 0.12
    Inner.BorderSizePixel = 0
    Inner.ZIndex = 22
    Inner.Parent = Orb

    local InnerCorner = Instance.new("UICorner")

    InnerCorner.CornerRadius = UDim.new(
        1,
        0
    )

    InnerCorner.Parent = Inner

    --------------------------------------------------
    -- YELLOW STAR
    --------------------------------------------------

    local Star = Instance.new("TextLabel")

    Star.Name = "YellowStar"
    Star.Size = UDim2.fromScale(
        1,
        1
    )

    Star.BackgroundTransparency = 1
    Star.Text = "★"
    Star.TextColor3 = STAR_COLOR
    Star.TextStrokeColor3 = Color3.fromRGB(
        255,
        190,
        0
    )

    Star.TextStrokeTransparency = 0.15
    Star.TextScaled = true
    Star.Font = Enum.Font.GothamBold
    Star.ZIndex = 23
    Star.Parent = Holder

    --------------------------------------------------
    -- YELLOW BORDER
    --------------------------------------------------

    local Stroke = Instance.new("UIStroke")

    Stroke.Name = "YellowGlowStroke"
    Stroke.Color = GLOW_COLOR
    Stroke.Thickness = 2
    Stroke.Transparency = 0.15
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Orb

    return {
        Holder = Holder,
        Orb = Orb,
        Glow = Glow,
        Star = Star,
        Stroke = Stroke
    }
end

--------------------------------------------------
-- CREATE 7 ORBS
--------------------------------------------------

local Orbs = {}

for i = 1, ORB_COUNT do
    Orbs[i] = CreateOrb()
end

--------------------------------------------------
-- RANDOM START POSITIONS
--------------------------------------------------

local Camera = workspace.CurrentCamera

local ViewportSize = Camera
    and Camera.ViewportSize
    or Vector2.new(1920,1080)

local function RandomPosition()
    local Margin = 120

    return Vector2.new(
        math.random(
            Margin,
            math.max(
                Margin,
                ViewportSize.X - Margin
            )
        ),
        math.random(
            Margin,
            math.max(
                Margin,
                ViewportSize.Y - Margin
            )
        )
    )
end

for _, OrbData in ipairs(Orbs) do
    local Position = RandomPosition()

    OrbData.Holder.Position = UDim2.fromOffset(
        Position.X,
        Position.Y
    )
end

--------------------------------------------------
-- CENTER
--------------------------------------------------

local Center = GetCenter()

--------------------------------------------------
-- ORBIT POSITIONS
--------------------------------------------------

local OrbitPositions = {}

for i = 1, ORB_COUNT do
    local Angle =
        ((i - 1) / ORB_COUNT)
        * math.pi
        * 2

    OrbitPositions[i] = Vector2.new(
        Center.X
            + math.cos(Angle)
            * ORBIT_RADIUS,

        Center.Y
            + math.sin(Angle)
            * ORBIT_RADIUS
    )
end

--------------------------------------------------
-- FLY TO ORBIT
--------------------------------------------------

for i, OrbData in ipairs(Orbs) do
    local Target = OrbitPositions[i]

    local Tween = TweenService:Create(
        OrbData.Holder,
        TweenInfo.new(
            FLY_TIME,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            Position = UDim2.fromOffset(
                Target.X,
                Target.Y
            )
        }
    )

    Tween:Play()
end

task.wait(FLY_TIME + 0.1)

--------------------------------------------------
-- ROTATING ORBIT
--------------------------------------------------

local OrbitRunning = true
local OrbitAngle = 0

local OrbitConnection

OrbitConnection = RunService.RenderStepped:Connect(
    function(DeltaTime)

        if not OrbitRunning then
            return
        end

        OrbitAngle =
            OrbitAngle
            + DeltaTime
            * ORBIT_SPEED

        local CurrentCenter = GetCenter()

        for i, OrbData in ipairs(Orbs) do

            local BaseAngle =
                ((i - 1) / ORB_COUNT)
                * math.pi
                * 2

            local Angle =
                BaseAngle
                + OrbitAngle

            local X =
                CurrentCenter.X
                + math.cos(Angle)
                * ORBIT_RADIUS

            local Y =
                CurrentCenter.Y
                + math.sin(Angle)
                * ORBIT_RADIUS

            OrbData.Holder.Position =
                UDim2.fromOffset(
                    X,
                    Y
                )
        end
    end
)

--------------------------------------------------
-- ROTATE FOR A WHILE
--------------------------------------------------

task.wait(1.2)

--------------------------------------------------
-- STOP ORBIT
--------------------------------------------------

OrbitRunning = false

if OrbitConnection then
    OrbitConnection:Disconnect()
    OrbitConnection = nil
end

--------------------------------------------------
-- GET CURRENT ORBIT POSITIONS
--------------------------------------------------

local CurrentPositions = {}

for i, OrbData in ipairs(Orbs) do
    CurrentPositions[i] =
        Vector2.new(
            OrbData.Holder.AbsolutePosition.X
                + ORB_SIZE / 2,

            OrbData.Holder.AbsolutePosition.Y
                + ORB_SIZE / 2
        )
end

--------------------------------------------------
-- BLINK BORDER 7 TIMES
--------------------------------------------------

for Blink = 1, BLINK_COUNT do

    for _, OrbData in ipairs(Orbs) do
        OrbData.Stroke.Transparency = 0
        OrbData.Glow.BackgroundTransparency = 0.35
    end

    task.wait(BLINK_ON_TIME)

    for _, OrbData in ipairs(Orbs) do
        OrbData.Stroke.Transparency = 0.65
        OrbData.Glow.BackgroundTransparency = 0.8
    end

    task.wait(BLINK_OFF_TIME)
end

--------------------------------------------------
-- RESET GLOW
--------------------------------------------------

for _, OrbData in ipairs(Orbs) do
    OrbData.Stroke.Transparency = 0.1
    OrbData.Glow.BackgroundTransparency = 0.65
end

--------------------------------------------------
-- MERGE TO CENTER
--------------------------------------------------

local MergeCenter = GetCenter()

for _, OrbData in ipairs(Orbs) do

    local Tween = TweenService:Create(
        OrbData.Holder,
        TweenInfo.new(
            MERGE_TIME,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.In
        ),
        {
            Position = UDim2.fromOffset(
                MergeCenter.X,
                MergeCenter.Y
            )
        }
    )

    Tween:Play()
end

task.wait(MERGE_TIME)

--------------------------------------------------
-- HIDE SMALL ORBS
--------------------------------------------------

for _, OrbData in ipairs(Orbs) do
    OrbData.Holder.Visible = false
end

--------------------------------------------------
-- CREATE BIG ORB
--------------------------------------------------

local BigOrb = Instance.new("Frame")

BigOrb.Name = "BigOrb"
BigOrb.Size = UDim2.fromOffset(
    BIG_ORB_SIZE,
    BIG_ORB_SIZE
)

BigOrb.AnchorPoint = Vector2.new(
    0.5,
    0.5
)

BigOrb.Position = UDim2.fromOffset(
    MergeCenter.X,
    MergeCenter.Y
)

BigOrb.BackgroundColor3 = ORB_COLOR
BigOrb.BorderSizePixel = 0
BigOrb.ZIndex = 30
BigOrb.Parent = AnimationGui

local BigCorner = Instance.new("UICorner")

BigCorner.CornerRadius = UDim.new(
    1,
    0
)

BigCorner.Parent = BigOrb

--------------------------------------------------
-- BIG ORB GLOW
--------------------------------------------------

local BigGlow = Instance.new("Frame")

BigGlow.Size = UDim2.new(
    1,
    22,
    1,
    22
)

BigGlow.Position = UDim2.fromOffset(
    -11,
    -11
)

BigGlow.BackgroundColor3 = GLOW_COLOR
BigGlow.BackgroundTransparency = 0.68
BigGlow.BorderSizePixel = 0
BigGlow.ZIndex = 29
BigGlow.Parent = BigOrb

local BigGlowCorner = Instance.new("UICorner")

BigGlowCorner.CornerRadius = UDim.new(
    1,
    0
)

BigGlowCorner.Parent = BigGlow

--------------------------------------------------
-- BIG ORB INNER
--------------------------------------------------

local BigInner = Instance.new("Frame")

BigInner.Size = UDim2.new(
    0.7,
    0,
    0.7,
    0
)

BigInner.Position = UDim2.new(
    0.15,
    0,
    0.15,
    0
)

BigInner.BackgroundColor3 = ORB_COLOR_DARK
BigInner.BackgroundTransparency = 0.08
BigInner.BorderSizePixel = 0
BigInner.ZIndex = 31
BigInner.Parent = BigOrb

local BigInnerCorner = Instance.new("UICorner")

BigInnerCorner.CornerRadius = UDim.new(
    1,
    0
)

BigInnerCorner.Parent = BigInner

--------------------------------------------------
-- BIG YELLOW STAR
--------------------------------------------------

local BigStar = Instance.new("TextLabel")

BigStar.Size = UDim2.fromScale(
    1,
    1
)

BigStar.BackgroundTransparency = 1
BigStar.Text = "★"
BigStar.TextColor3 = STAR_COLOR
BigStar.TextStrokeColor3 = Color3.fromRGB(
    255,
    190,
    0
)

BigStar.TextStrokeTransparency = 0.1
BigStar.TextScaled = true
BigStar.Font = Enum.Font.GothamBold
BigStar.ZIndex = 32
BigStar.Parent = BigOrb

--------------------------------------------------
-- BIG BORDER
--------------------------------------------------

local BigStroke = Instance.new("UIStroke")

BigStroke.Color = GLOW_COLOR
BigStroke.Thickness = 3
BigStroke.Transparency = 0.05
BigStroke.Parent = BigOrb

--------------------------------------------------
-- SMALL PULSE BEFORE EXPLOSION
--------------------------------------------------

local PulseTween = TweenService:Create(
    BigOrb,
    TweenInfo.new(
        0.35,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ),
    {
        Size = UDim2.fromOffset(
            BIG_ORB_SIZE + 12,
            BIG_ORB_SIZE + 12
        )
    }
)

PulseTween:Play()
PulseTween.Completed:Wait()

--------------------------------------------------
-- CREATE EXPLOSION DEBRIS
--------------------------------------------------

local Debris = {}

for i = 1, DEBRIS_COUNT do

    local Piece = Instance.new("Frame")

    local Size = math.random(
        10,
        20
    )

    Piece.Name = "ExplosionPiece"

    Piece.Size = UDim2.fromOffset(
        Size,
        Size
    )

    Piece.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    Piece.Position =
        UDim2.fromOffset(
            MergeCenter.X,
            MergeCenter.Y
        )

    Piece.BackgroundColor3 =
        ORB_COLOR

    Piece.BorderSizePixel = 0
    Piece.ZIndex = 35
    Piece.Parent = AnimationGui

    local PieceCorner =
        Instance.new("UICorner")

    PieceCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    PieceCorner.Parent =
        Piece

    local PieceStroke =
        Instance.new("UIStroke")

    PieceStroke.Color =
        GLOW_COLOR

    PieceStroke.Thickness = 2
    PieceStroke.Transparency = 0.2
    PieceStroke.Parent = Piece

    table.insert(
        Debris,
        Piece
    )
end

--------------------------------------------------
-- EXPLOSION
--------------------------------------------------

BigOrb.Visible = false

for i, Piece in ipairs(Debris) do

    local Angle =
        ((i - 1) / DEBRIS_COUNT)
        * math.pi
        * 2

    local Distance =
        math.random(
            75,
            145
        )

    local EndX =
        MergeCenter.X
        + math.cos(Angle)
        * Distance

    local EndY =
        MergeCenter.Y
        + math.sin(Angle)
        * Distance

    local Tween =
        TweenService:Create(
            Piece,
            TweenInfo.new(
                EXPLOSION_TIME,
                Enum.EasingStyle.Quart,
                Enum.EasingDirection.Out
            ),
            {
                Position =
                    UDim2.fromOffset(
                        EndX,
                        EndY
                    ),

                Rotation =
                    math.random(
                        -180,
                        180
                    ),

                BackgroundTransparency = 1
            }
        )

    Tween:Play()

    task.delay(
        EXPLOSION_TIME * 0.45,
        function()

            local Stroke =
                Piece:FindFirstChildOfClass(
                    "UIStroke"
                )

            if Stroke then

                TweenService:Create(
                    Stroke,
                    TweenInfo.new(
                        EXPLOSION_TIME * 0.55,
                        Enum.EasingStyle.Quad
                    ),
                    {
                        Transparency = 1
                    }
                ):Play()

            end
        end
    )
end

--------------------------------------------------
-- HUB BUTTON
--------------------------------------------------

HubButton.Visible = true
HubButton.Parent = HubUi

HubButton.Size =
    OriginalSize

HubButton.AnchorPoint =
    Vector2.new(
        0.5,
        0.5
    )

HubButton.Position =
    UDim2.fromOffset(
        MergeCenter.X,
        MergeCenter.Y
    )

HubButton.ZIndex = 100

--------------------------------------------------
-- HUB BUTTON APPEAR
--------------------------------------------------

local ButtonScale =
    HubButton:FindFirstChild(
        "AnimationScale"
    )

if ButtonScale then
    ButtonScale:Destroy()
end

ButtonScale =
    Instance.new("UIScale")

ButtonScale.Name =
    "AnimationScale"

ButtonScale.Scale = 0.15
ButtonScale.Parent = HubButton

local AppearTween =
    TweenService:Create(
        ButtonScale,
        TweenInfo.new(
            0.4,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Scale = 1
        }
    )

AppearTween:Play()

AppearTween.Completed:Wait()

--------------------------------------------------
-- MOVE HUBBUTTON BACK
--------------------------------------------------

local TargetPosition =
    OriginalPosition

local StartCenter =
    GetCenter()

local MoveTween =
    TweenService:Create(
        HubButton,
        TweenInfo.new(
            1.4,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            Position = UDim2.new(
                TargetPosition.X.Scale,
                TargetPosition.X.Offset
                    + OriginalSize.X.Offset / 2,

                TargetPosition.Y.Scale,
                TargetPosition.Y.Offset
                    + OriginalSize.Y.Offset / 2
            )
        }
    )

MoveTween:Play()

MoveTween.Completed:Wait()

--------------------------------------------------
-- RESTORE HUB BUTTON
--------------------------------------------------

HubButton.AnchorPoint =
    Vector2.new(
        0,
        0
    )

HubButton.Position =
    OriginalPosition

HubButton.Size =
    OriginalSize

HubButton.Visible =
    OriginalVisible

HubButton.ZIndex =
    1

if ButtonScale then
    ButtonScale:Destroy()
end

--------------------------------------------------
-- CLEANUP
--------------------------------------------------

for _, Piece in ipairs(Debris) do
    if Piece then
        pcall(function()
            Piece:Destroy()
        end)
    end
end

pcall(function()
    AnimationGui:Destroy()
end)
