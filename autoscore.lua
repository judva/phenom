local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local cam = workspace.CurrentCamera

function findBall()
    return plr.Character:FindFirstChild("Basketball")
end

function dunkBall()
    for i,v in pairs(workspace.Stadium:GetChildren()) do
        if string.find(v.Name, "HitRim") then
            local vec, onScreen = cam:WorldToScreenPoint(v.Position)
            if onScreen and findBall() ~= nil then
                v.Transparency = 1
                v.CanCollide = false
                v.Size = Vector3.new(9e9, 9e9, 9e9)

                task.wait()

                v.Size = Vector3.new(5, 5, 5)
            end
        end
    end
end

plr.Character.Humanoid.Jumping:Connect(function(IsJumping)
if IsJumping then
dunkBall()
end
end)
