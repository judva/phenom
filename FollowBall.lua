local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")


local function findClosestPlayerWithBasketball()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Basketball") then
            local distance = (otherPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = otherPlayer
            end
        end
    end

    return closestPlayer
end

local function flyToClosestPlayerWithBasketball()
    local closestPlayer = findClosestPlayerWithBasketball()
    if closestPlayer then
        local rootPart = closestPlayer.Character.HumanoidRootPart
        local destination = rootPart.Position
        local direction = (destination - character.HumanoidRootPart.Position).unit
        local flySpeed = 3 
        local tolerance = 5 

        while (destination - character.HumanoidRootPart.Position).Magnitude > tolerance do
            character:SetPrimaryPartCFrame(CFrame.new(character.HumanoidRootPart.Position + direction * flySpeed))
            wait()
        end
    else
        print("No players found with a child named 'Basketball'")
    end
end

flyToClosestPlayerWithBasketball()
