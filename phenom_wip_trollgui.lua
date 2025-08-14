--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Toggles
local toggles = {
    ballESP = false,
    autoChase = false,
    hoverBall = false,
    predictionSnap = false,
    cameraFollow = false,
    visualTrail = false,
    ballMagnet = false
}

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = plr:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,300,0,380)
mainFrame.Position = UDim2.new(0,20,0,20)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,15)
UICorner.Parent = mainFrame

local function createButton(name,pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,260,0,40)
    btn.Position = UDim2.new(0,20,0,pos)
    btn.Text = name..": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Parent = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,10)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        btn.Text = name..(toggles[name] and ": ON" or ": OFF")
    end)
end

local features = {"ballESP","autoChase","hoverBall","predictionSnap","cameraFollow","visualTrail","ballMagnet"}
for i,name in ipairs(features) do
    createButton(name,20 + (i-1)*50)
end

-- Helper: find the ball part in workspace or under any character
local function getBallPart()
    local map = Workspace:FindFirstChild("Map")
    if map then
        local ball = map:FindFirstChild("Basketball")
        if ball then
            local handle = ball:FindFirstChild("Handle")
            if handle then
                if handle:IsA("BasePart") then return handle end
                for _, d in ipairs(handle:GetDescendants()) do
                    if d:IsA("BasePart") then return d end
                end
            end
        end
    end
    -- Check all players in case ball is parented under their character
    for _, player in ipairs(Players:GetPlayers()) do
        local c = player.Character
        if c then
            local ball = c:FindFirstChild("Basketball")
            if ball then
                local handle = ball:FindFirstChild("Handle")
                if handle then
                    if handle:IsA("BasePart") then return handle end
                    for _, d in ipairs(handle:GetDescendants()) do
                        if d:IsA("BasePart") then return d end
                    end
                end
            end
        end
    end
    return nil
end

-- Ball ESP
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

-- Auto chase, hover, magnet, prediction, camera follow
RunService.Heartbeat:Connect(function(delta)
    local ball = getBallPart()
    if not ball then return end
    local ballPos = ball.Position

    if toggles.autoChase then
        hrp.CFrame = CFrame.new(ballPos + Vector3.new(0,3,0))
    end

    if toggles.hoverBall then
        ball.CFrame = CFrame.new(hrp.Position + Vector3.new(0,5,0))
    end

    if toggles.predictionSnap then
        local vel = ball.AssemblyLinearVelocity or Vector3.new()
        hrp.CFrame = CFrame.new(ballPos + vel*0.2 + Vector3.new(0,3,0))
    end

    if toggles.ballMagnet then
        ball.CFrame = CFrame.new(hrp.Position + Vector3.new(0,2,0))
    end

    if toggles.cameraFollow then
        local cam = workspace.CurrentCamera
        cam.CFrame = CFrame.new(cam.CFrame.Position,ballPos)
    end
end)

-- Visual Trail
local trail
RunService.Heartbeat:Connect(function()
    local ball = getBallPart()
    if toggles.visualTrail and ball then
        if not trail then
            trail = Instance.new("Trail")
            local attach0 = Instance.new("Attachment",hrp)
            local attach1 = Instance.new("Attachment",ball)
            trail.Attachment0 = attach0
            trail.Attachment1 = attach1
            trail.Color = ColorSequence.new(Color3.fromRGB(0,255,255))
            trail.Lifetime = 0.3
            trail.Parent = hrp
        end
    elseif trail then
        trail:Destroy()
        trail = nil
    end
end)
