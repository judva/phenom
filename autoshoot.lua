local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local run_service = game:GetService("RunService")

local function wait_exact(seconds)
    local start = tick()
    while tick() - start < seconds do
        run_service.Heartbeat:Wait()
    end
end

uis.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space then
        wait_exact(0.33)
        pcall(function() mouse1click() end)
    end
end)
