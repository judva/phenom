local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")

local speed = 60
local moving = false
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.W then
        moving = true
    end
end)
UIS.InputEnded:Connect(function(input, isTyping)
    if input.KeyCode == Enum.KeyCode.W then
        moving = false
    end
end)

RunService.Heartbeat:Connect(function(delta)
    if moving then
        hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * speed * delta
    end
end)
