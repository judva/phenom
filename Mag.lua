local UIS = game:GetService('UserInputService')
local plr = game.Players.LocalPlayer
local Char = plr.Character or plr.CharacterAded:Wait()
local Key = 'R'
UIS.InputBegan:Connect(function(Input, IsTyping)
if IsTyping then return end
local KeyPressed = Input.KeyCode
if KeyPressed == Enum.KeyCode[Key] then
game.Workspace.Map.Basketball.Handle.CFrame = Game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end
end)
