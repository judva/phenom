local PlayerService = game:GetService("Players")
local groups = game:GetService("GroupService")
local ID = 11580409
local Event = (game:GetService("ReplicatedStorage")).DefaultChatSystemChatEvents.SayMessageRequest
local groupName = (groups:GetGroupInfoAsync(ID)).Name
_G.AutoReport = false
function FindPlayerHacking()
    local player = nil
    for i, v in pairs(PlayerService:GetChildren()) do
        if v:IsInGroup(ID) then
            player = v.Name
        end
    end
    return player
end
function Report()
    local player = FindPlayerHacking()
    if _G.AutoReport == true then
        PlayerService:ReportAbuse(PlayerService[player], "Cheating/Exploiting", "he is using aimbot")
    end
end
function Confront()
    local player = FindPlayerHacking()
    local confront = {
        "why are you exploiting? " .. player,
        "Loompic " .. player .. " Seriously?",
        "Why use Loompic " .. player .. " Use my silent aims :3",
        "You seem to be lost " .. player .. " Good scripts are located at the channel named beepers",
        "Why are you in the group" .. player .. "?"
    }
    Event:FireServer(confront[math.random(1, #confront)], "All")
    wait(2)
end
Confront()
Report()
