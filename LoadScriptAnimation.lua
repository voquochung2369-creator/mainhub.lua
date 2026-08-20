--// LoadScriptAnimation.lua
--// CustomHub - Dragon Ball Style Load Animation
--// 7 Purple Orbs + Gold Glow + Rotation + Flash + Explosion + HubButton Return

local CoreGui=game:GetService("CoreGui")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local ANIMATION_GUI_NAME="CustomHub_LoadAnimation"

local ORB_COUNT=7

local ORB_COLOR=Color3.fromRGB(150,70,255)
local GLOW_COLOR=Color3.fromRGB(255,215,70)

local ORB_SIZE=18
local BIG_ORB_SIZE=52

local FLY_TIME=1.15
local ROTATE_TIME=1.8

local FLASH_COUNT=7
local FLASH_ON=0.2
local FLASH_OFF=0.3

local EXPLOSION_PIECES=18
local EXPLOSION_TIME=1.25

local CENTER_OFFSET=Vector2.new(0,0)

--------------------------------------------------
-- REMOVE OLD ANIMATION
--------------------------------------------------

local oldGui=CoreGui:FindFirstChild(ANIMATION_GUI_NAME)

if oldGui then
    pcall(function()
        oldGui:Destroy()
    end)
end

--------------------------------------------------
-- FIND HUB
--------------------------------------------------

local HubUi=CoreGui:FindFirstChild("HubUi")

if not HubUi then
    warn("[CustomHub] HubUi not found")
    return
end

local HubButton=HubUi:FindFirstChild("HubButton")

if not HubButton then
    warn("[CustomHub] HubButton not found")
    return
end

--------------------------------------------------
-- SAVE ORIGINAL HUB POSITION
--------------------------------------------------

local OriginalPosition=HubButton.Position
local OriginalSize=HubButton.Size
local OriginalVisible=HubButton.Visible
local OriginalParent=HubButton.Parent

--------------------------------------------------
-- GUI
--------------------------------------------------

local AnimationGui=Instance.new("ScreenGui")

AnimationGui.Name=ANIMATION_GUI_NAME
AnimationGui.ResetOnSpawn=false
AnimationGui.IgnoreGuiInset=true
AnimationGui.ZIndexBehavior=Enum.ZIndexBehavior.Global
AnimationGui.DisplayOrder=999999
AnimationGui.Parent=CoreGui

--------------------------------------------------
-- CENTER
--------------------------------------------------

local Camera=workspace.CurrentCamera

if not Camera then
    AnimationGui:Destroy()
    return
end

local Viewport=Camera.ViewportSize

local Center=Vector2.new(
    Viewport.X/2,
    Viewport.Y/2
)+CENTER_OFFSET

--------------------------------------------------
-- HUB CENTER POSITION
--------------------------------------------------

local CenterHubPosition=UDim2.fromOffset(
    Center.X-OriginalSize.X.Offset/2,
    Center.Y-OriginalSize.Y.Offset/2
)

--------------------------------------------------
-- HIDE HUB WITHOUT DESTROYING IT
--------------------------------------------------

HubButton.Visible=false

--------------------------------------------------
-- CREATE ORB
--------------------------------------------------

local function CreateOrb(position)

    local holder=Instance.new("Frame")

    holder.Name="Orb"
    holder.Size=UDim2.fromOffset(ORB_SIZE,ORB_SIZE)
    holder.Position=UDim2.fromOffset(
        position.X-ORB_SIZE/2,
        position.Y-ORB_SIZE/2
    )
    holder.BackgroundTransparency=1
    holder.BorderSizePixel=0
    holder.ZIndex=10
    holder.Parent=AnimationGui

    local glow=Instance.new("Frame")

    glow.Name="Glow"
    glow.Size=UDim2.fromOffset(
        ORB_SIZE+10,
        ORB_SIZE+10
    )
    glow.Position=UDim2.fromOffset(-5,-5)
    glow.BackgroundColor3=GLOW_COLOR
    glow.BackgroundTransparency=0.72
    glow.BorderSizePixel=0
    glow.ZIndex=10
    glow.Parent=holder

    local glowCorner=Instance.new("UICorner")

    glowCorner.CornerRadius=UDim.new(1,0)
    glowCorner.Parent=glow

    local orb=Instance.new("Frame")

    orb.Name="PurpleOrb"
    orb.Size=UDim2.fromScale(1,1)
    orb.BackgroundColor3=ORB_COLOR
    orb.BackgroundTransparency=0
    orb.BorderSizePixel=0
    orb.ZIndex=11
    orb.Parent=holder

    local orbCorner=Instance.new("UICorner")

    orbCorner.CornerRadius=UDim.new(1,0)
    orbCorner.Parent=orb

    local stroke=Instance.new("UIStroke")

    stroke.Name="GoldGlow"
    stroke.Color=GLOW_COLOR
    stroke.Thickness=2
    stroke.Transparency=0.15
    stroke.Parent=orb

    return holder,orb,stroke,glow
end

--------------------------------------------------
-- RANDOM START POSITIONS
--------------------------------------------------

local function RandomPosition()

    local margin=70

    return Vector2.new(
        math.random(
            margin,
            math.max(
                margin,
                math.floor(Viewport.X-margin)
            )
        ),
        math.random(
            margin,
            math.max(
                margin,
                math.floor(Viewport.Y-margin)
            )
        )
    )
end

--------------------------------------------------
-- CREATE 7 ORBS
--------------------------------------------------

local Orbs={}

for i=1,ORB_COUNT do

    local startPosition=RandomPosition()

    local holder,orb,stroke,glow=
        CreateOrb(startPosition)

    table.insert(Orbs,{
        Holder=holder,
        Orb=orb,
        Stroke=stroke,
        Glow=glow,
        StartPosition=startPosition
    })
end

--------------------------------------------------
-- FLY TO CENTER
--------------------------------------------------

for _,data in ipairs(Orbs) do

    local tween=TweenService:Create(
        data.Holder,
        TweenInfo.new(
            FLY_TIME,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        {
            Position=UDim2.fromOffset(
                Center.X-ORB_SIZE/2,
                Center.Y-ORB_SIZE/2
            )
        }
    )

    tween:Play()
end

task.wait(FLY_TIME)

--------------------------------------------------
-- ROTATING FORMATION
--------------------------------------------------

local rotationRunning=true
local rotationStart=os.clock()

local rotationConnection

rotationConnection=RunService.RenderStepped:Connect(
    function()

        if not rotationRunning then
            return
        end

        local elapsed=os.clock()-rotationStart

        local angleSpeed=math.rad(55)

        for index,data in ipairs(Orbs) do

            if data.Holder.Parent then

                local angle=
                    ((index-1)/ORB_COUNT)
                    *math.pi*2
                    +(elapsed*angleSpeed)

                local radius=48

                local x=
                    Center.X
                    +math.cos(angle)*radius
                    -ORB_SIZE/2

                local y=
                    Center.Y
                    +math.sin(angle)*radius
                    -ORB_SIZE/2

                data.Holder.Position=
                    UDim2.fromOffset(
                        x,
                        y
                    )

                data.Holder.Rotation=
                    math.deg(angle)
            end
        end
    end
)

task.wait(ROTATE_TIME)

--------------------------------------------------
-- STOP ROTATION
--------------------------------------------------

rotationRunning=false

if rotationConnection then
    rotationConnection:Disconnect()
    rotationConnection=nil
end

--------------------------------------------------
-- MOVE INTO PERFECT CIRCLE
--------------------------------------------------

local finalRadius=45

for index,data in ipairs(Orbs) do

    local angle=
        ((index-1)/ORB_COUNT)
        *math.pi*2

    local targetX=
        Center.X
        +math.cos(angle)*finalRadius
        -ORB_SIZE/2

    local targetY=
        Center.Y
        +math.sin(angle)*finalRadius
        -ORB_SIZE/2

    local tween=TweenService:Create(
        data.Holder,
        TweenInfo.new(
            0.35,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut
        ),
        {
            Position=UDim2.fromOffset(
                targetX,
                targetY
            )
        }
    )

    tween:Play()
end

task.wait(0.35)

--------------------------------------------------
-- FLASH BORDER 7 TIMES
--------------------------------------------------

for flash=1,FLASH_COUNT do

    for _,data in ipairs(Orbs) do

        data.Stroke.Transparency=0
        data.Stroke.Thickness=4
        data.Glow.BackgroundTransparency=0.35
    end

    task.wait(FLASH_ON)

    for _,data in ipairs(Orbs) do

        data.Stroke.Transparency=0.75
        data.Stroke.Thickness=2
        data.Glow.BackgroundTransparency=0.72
    end

    task.wait(FLASH_OFF)
end

--------------------------------------------------
-- CREATE BIG ORB
--------------------------------------------------

local BigHolder=Instance.new("Frame")

BigHolder.Name="BigOrb"
BigHolder.Size=UDim2.fromOffset(
    BIG_ORB_SIZE,
    BIG_ORB_SIZE
)
BigHolder.Position=UDim2.fromOffset(
    Center.X-BIG_ORB_SIZE/2,
    Center.Y-BIG_ORB_SIZE/2
)
BigHolder.BackgroundTransparency=1
BigHolder.BorderSizePixel=0
BigHolder.ZIndex=20
BigHolder.Parent=AnimationGui

local BigGlow=Instance.new("Frame")

BigGlow.Size=UDim2.fromOffset(
    BIG_ORB_SIZE+22,
    BIG_ORB_SIZE+22
)
BigGlow.Position=UDim2.fromOffset(-11,-11)
BigGlow.BackgroundColor3=GLOW_COLOR
BigGlow.BackgroundTransparency=0.7
BigGlow.BorderSizePixel=0
BigGlow.ZIndex=20
BigGlow.Parent=BigHolder

local BigGlowCorner=Instance.new("UICorner")

BigGlowCorner.CornerRadius=UDim.new(1,0)
BigGlowCorner.Parent=BigGlow

local BigOrb=Instance.new("Frame")

BigOrb.Size=UDim2.fromScale(1,1)
BigOrb.BackgroundColor3=ORB_COLOR
BigOrb.BorderSizePixel=0
BigOrb.ZIndex=21
BigOrb.Parent=BigHolder

local BigCorner=Instance.new("UICorner")

BigCorner.CornerRadius=UDim.new(1,0)
BigCorner.Parent=BigOrb

local BigStroke=Instance.new("UIStroke")

BigStroke.Color=GLOW_COLOR
BigStroke.Thickness=4
BigStroke.Transparency=0
BigStroke.Parent=BigOrb

--------------------------------------------------
-- ORBS GATHER INTO BIG ORB
--------------------------------------------------

for _,data in ipairs(Orbs) do

    local tween=TweenService:Create(
        data.Holder,
        TweenInfo.new(
            0.55,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ),
        {
            Position=UDim2.fromOffset(
                Center.X-ORB_SIZE/2,
                Center.Y-ORB_SIZE/2
            )
        }
    )

    tween:Play()
end

task.wait(0.55)

--------------------------------------------------
-- REMOVE SMALL ORBS
--------------------------------------------------

for _,data in ipairs(Orbs) do

    pcall(function()
        data.Holder:Destroy()
    end)
end

--------------------------------------------------
-- BIG ORB PULSE
--------------------------------------------------

local pulse1=TweenService:Create(
    BigHolder,
    TweenInfo.new(
        0.18,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ),
    {
        Size=UDim2.fromOffset(
            BIG_ORB_SIZE+12,
            BIG_ORB_SIZE+12
        ),
        Position=UDim2.fromOffset(
            Center.X-(BIG_ORB_SIZE+12)/2,
            Center.Y-(BIG_ORB_SIZE+12)/2
        )
    }
)

pulse1:Play()
pulse1.Completed:Wait()

--------------------------------------------------
-- EXPLOSION PIECES
--------------------------------------------------

local Pieces={}

for i=1,EXPLOSION_PIECES do

    local pieceSize=math.random(9,16)

    local piece=Instance.new("Frame")

    piece.Name="ExplosionPiece"

    piece.Size=UDim2.fromOffset(
        pieceSize,
        pieceSize
    )

    piece.Position=UDim2.fromOffset(
        Center.X-pieceSize/2,
        Center.Y-pieceSize/2
    )

    piece.BackgroundColor3=ORB_COLOR
    piece.BorderSizePixel=0
    piece.ZIndex=30
    piece.Parent=AnimationGui

    local corner=Instance.new("UICorner")

    corner.CornerRadius=UDim.new(0.3,0)
    corner.Parent=piece

    local stroke=Instance.new("UIStroke")

    stroke.Color=GLOW_COLOR
    stroke.Thickness=1.5
    stroke.Transparency=0.15
    stroke.Parent=piece

    local angle=
        (math.pi*2)
        *(
            (i-1)/EXPLOSION_PIECES
        )

    local distance=math.random(80,145)

    table.insert(
        Pieces,
        {
            Object=piece,
            X=math.cos(angle)*distance,
            Y=math.sin(angle)*distance
        }
    )
end

--------------------------------------------------
-- BIG ORB DISAPPEARS GENTLY
--------------------------------------------------

local bigFade=TweenService:Create(
    BigHolder,
    TweenInfo.new(
        0.22,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ),
    {
        Size=UDim2.fromOffset(
            10,
            10
        ),
        Position=UDim2.fromOffset(
            Center.X-5,
            Center.Y-5
        )
    }
)

bigFade:Play()

--------------------------------------------------
-- SLOW LIGHT EXPLOSION
--------------------------------------------------

for _,pieceData in ipairs(Pieces) do

    local piece=pieceData.Object

    local targetPosition=UDim2.fromOffset(
        Center.X
        +pieceData.X
        -piece.AbsoluteSize.X/2,

        Center.Y
        +pieceData.Y
        -piece.AbsoluteSize.Y/2
    )

    local tween=TweenService:Create(
        piece,
        TweenInfo.new(
            EXPLOSION_TIME,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            Position=targetPosition,
            BackgroundTransparency=0.15
        }
    )

    tween:Play()
end

task.wait(0.25)

--------------------------------------------------
-- HUB BUTTON APPEARS AT CENTER
--------------------------------------------------

-- QUAN TRỌNG:
-- Không Destroy HubButton.
-- Không thay Parent.
-- Chỉ đổi Position + Visible.

HubButton.Position=CenterHubPosition
HubButton.Visible=true

--------------------------------------------------
-- HUB BUTTON SPAWN EFFECT
--------------------------------------------------

local HubStroke=HubButton:FindFirstChild("HubCircleStroke")

if HubStroke then

    HubStroke.Thickness=4
    HubStroke.Transparency=0

    local strokeTween=TweenService:Create(
        HubStroke,
        TweenInfo.new(
            0.35,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            Thickness=1,
            Transparency=0.45
        }
    )

    strokeTween:Play()
end

--------------------------------------------------
-- HUB BUTTON FLIES BACK
--------------------------------------------------

local returnTween=TweenService:Create(
    HubButton,
    TweenInfo.new(
        1.4,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    ),
    {
        Position=OriginalPosition
    }
)

returnTween:Play()

--------------------------------------------------
-- WAIT FOR RETURN
--------------------------------------------------

returnTween.Completed:Wait()

--------------------------------------------------
-- RESTORE ORIGINAL STATE
--------------------------------------------------

HubButton.Position=OriginalPosition
HubButton.Size=OriginalSize
HubButton.Visible=OriginalVisible

--------------------------------------------------
-- CLEAN EXPLOSION
--------------------------------------------------

for _,pieceData in ipairs(Pieces) do

    local piece=pieceData.Object

    if piece and piece.Parent then

        local fade=TweenService:Create(
            piece,
            TweenInfo.new(
                0.35,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                BackgroundTransparency=1
            }
        )

        fade:Play()
    end
end

task.wait(0.4)

--------------------------------------------------
-- CLEANUP
--------------------------------------------------

pcall(function()
    if BigHolder and BigHolder.Parent then
        BigHolder:Destroy()
    end
end)

for _,pieceData in ipairs(Pieces) do

    pcall(function()

        if pieceData.Object
            and pieceData.Object.Parent then

            pieceData.Object:Destroy()
        end

    end)
end

pcall(function()
    AnimationGui:Destroy()
end)

--------------------------------------------------
-- FINAL SAFETY
--------------------------------------------------

if HubButton
    and HubButton.Parent==OriginalParent then

    HubButton.Position=OriginalPosition
    HubButton.Visible=true
end
