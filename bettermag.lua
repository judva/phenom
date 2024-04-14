game:GetService("UserInputService").InputBegan:connect(onKeyPress)

function onKeyPress(inputObject, gameProcessedEvent)
if gameProcessedEvent then return end
if inputObject.KeyCode == Enum.KeyCode.M then
local Torso = game.Players.LocalPlayer.Character.Torso
for i, v in pairs(workspace:GetDescendants()) do
    if v.Name == "rim" then
        firetouchinterest(Torso, v.Parent,0)
        wait()
        firetouchinterest(Torso, v.Parent,1)

    end

end

end

end

game:GetService("UserInputService").InputBegan:connect(onKeyPress)
