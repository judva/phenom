--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Toggle table
local toggles = {
    ballESP = false,
    autoChase = false,
    hoverBall = false,
    predictionSnap = false,
    cameraFollow = false,
    visualTrail = false,
    ballMagnet = false
}

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BasketballIDE_GUI"
screenGui.Parent = plr:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,300,0,380)
mainFrame.Position = UDim2.new(0,20,0,20)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0,15)
frameCorner.Parent = mainFrame

-- Font style
local buttonFont = Enum.Font.GothamBold

-- Helper: create buttons
local function createButton(name, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,260,0,40)
    btn.Position = UDim2.new(0,20,0,pos)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = buttonFont
    btn.TextScaled = true
    btn.Text = name..": OFF"
    btn.Parent = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,10)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        btn.Text = name..(toggles[name] and ": ON" or ": OFF")
    end)
end

local startY = 20
local spacing = 50
local features = {"ballESP","autoChase","hoverBall","predictionSnap","cameraFollow","visualTrail","ballMagnet"}
for i,name in ipairs(features) do
    createButton(name,startY + (i-1)*spacing)
end

-- Helper: get first BasePart inside Handle
local function getBallPart()
    local basketball = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Basketball")
    local handle = basketball and basketball:FindFirstChild("Handle")
    if not handle then return nil end
    if handle:IsA("BasePart") then return handle end
    local parts = {}
    for _, d in ipairs(handle:GetDescendants()) do
        if d:IsA("BasePart") then
            table.insert(parts,d)
        end
    end
    table.sort(parts,function(a,b) return a.Size.Magnitude > b.Size.Magnitude end)
    return parts[1]
end

-- Ball ESP (simple highlight)
local highlight
RunService.Heartbeat:Connect(function()
    local ball = getBallPart()
    if toggles.ballESP and ball then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255,0,0)
            highlight.OutlineColor = Color3.fromRGB(255,255,255)
            highlight.Adornee = ball
            highlight.Parent = ball
        else
            highlight.Adornee = ball
        end
    elseif highlight then
        highlight:Destroy()
        highlight = nil
    end
end)

-- Auto Chase + Prediction + Hover + Magnet
RunService.Heartbeat:Connect(function(delta)
    local ball = getBallPart()
    if ball then
        local ballPos = ball.Position

        -- Auto-Chase
        if toggles.autoChase then
            local targetPos = ballPos + Vector3.new(0,3,0)
            hrp.CFrame = CFrame.new(targetPos)
        end

        -- Hover Ball
        if toggles.hoverBall then
            local targetPos = hrp.Position + Vector3.new(0,5,0)
            ball.CFrame = CFrame.new(targetPos)
        end

        -- Prediction Snap
        if toggles.predictionSnap then
            local velocity = ball.AssemblyLinearVelocity or Vector3.new()
            hrp.CFrame = CFrame.new(ballPos + velocity*0.2 + Vector3.new(0,3,0))
        end

        -- Ball Magnet (local visual)
        if toggles.ballMagnet then
            ball.CFrame = CFrame.new(hrp.Position + Vector3.new(0,2,0))
        end
    end

    -- Camera Follow
    if toggles.cameraFollow and ball then
        local cam = workspace.CurrentCamera
        cam.CFrame = CFrame.new(cam.CFrame.Position, ball.Position)
    end
end)

-- Visual Trail
local trail
RunService.Heartbeat:Connect(function()
    local ball = getBallPart()
    if toggles.visualTrail and ball then
        if not trail then
            trail = Instance.new("Trail")
            trail.Attachment0 = Instance.new("Attachment",hrp)
            trail.Attachment1 = Instance.new("Attachment",ball)
            trail.Color = ColorSequence.new(Color3.fromRGB(0,255,255))
            trail.Lifetime = 0.3
            trail.Parent = hrp
        end
    elseif trail then
        trail:Destroy()
        trail = nil
    end
end)
