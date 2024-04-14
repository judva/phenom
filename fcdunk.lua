local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera

local Gravity = Vector3.new(0, -Workspace.Gravity, 0)
local Time = 2

local Goals = {} do
    for _, Obj in next, game:GetDescendants() do
        if Obj.Name == "Goal" and Obj:IsA("BasePart") then
            table.insert(Goals, Obj)
        elseif Obj.Name == "Part" and Obj:IsA("BasePart") and Obj.Size == Vector3.new(5, 1, 5) then
            table.insert(Goals, Obj)
        end
    end
end

local GetGoal = function()
    for _, Obj in next, Goals do
        local _, Visible = Camera:WorldToViewportPoint(Obj.Position)
        
        if Visible == true then
            local Parts = Camera:GetPartsObscuringTarget({Obj.Position}, {})
        
            for _, Part in next, Parts do
                if Part.Parent ~= nil and Part.Parent.Name == "Barrier" and Part.Parent:IsA("Model") == true then
                    return
                end
            end
            
            return Obj
        end
    end
end

local AutoScore = function()
    local Goal = GetGoal()
    
    if Goal ~= nil then
        local Root = Player.Character:FindFirstChild("HumanoidRootPart", true)
        local X0 = Root.Position
        local V0 = (Goal.Position - X0 - 0.5 * Gravity * Time * Time) / Time
        
        local Elapsed = 0

        while Elapsed <= Time do
            Root.CFrame = CFrame.new(0.5 * Gravity * Elapsed * Elapsed + V0 * Elapsed + X0, Goal.Position)
            Elapsed = Elapsed + wait()
        end
    end
end

UIS.InputBegan:Connect(function(Key, GPE)
    if GPE == false and Key.KeyCode == Enum.KeyCode.X and Player.Character:FindFirstChild("Basketball") ~= nil then
        AutoScore()
    end
end)
