-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Variables
local localPlayer = Players.LocalPlayer
local serverlockEnabled = false

-- Remote setup
local functionsRemote = Instance.new("RemoteEvent")
functionsRemote.Name = "Functions"
functionsRemote.Parent = ReplicatedStorage

-- Utility functions
local function safeFire(remote, ...)
    if remote then
        pcall(function() remote:FireServer(...) end)
    else
        warn("Ghost: Remote not available!")
    end
end

local function getTarget(input)
    if input == "all" then return Players:GetPlayers()
    elseif input == "others" then return {p for p in Players:GetPlayers() if p ~= localPlayer}
    else return Players:FindFirstChild(input) and {Players:FindFirstChild(input)} or {} end
end

-- Action functions
local function killPlayer(target)
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        target.Character.Humanoid.Health = 0
    end
end

local function kickPlayer(target)
    if target then
        target:Kick("Kicked by Ghost!")
    end
end

local function teleportPlayer(target)
    if target and target.Character then
        local spawnPoints = Workspace:FindFirstChild("SpawnPoints") or {Vector3.new(0, 5, 0)}
        local randomPoint = spawnPoints[math.random(1, #spawnPoints)]
        if typeof(randomPoint) == "Instance" then randomPoint = randomPoint.Position end
        target.Character:MoveTo(randomPoint)
    end
end

local function toggleServerlock()
    serverlockEnabled = not serverlockEnabled
    if serverlockEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer then killPlayer(player) end
        end
    end
end

-- Remote event handler
functionsRemote.OnServerEvent:Connect(function(player, command, arg)
    if player == localPlayer then
        if command == "kill" then
            for _, target in pairs(getTarget(arg or "target")) do killPlayer(target) end
        elseif command == "kick" then
            for _, target in pairs(getTarget(arg or "target")) do kickPlayer(target) end
        elseif command == "teleport" then
            for _, target in pairs(getTarget(arg or "target")) do teleportPlayer(target) end
        elseif command == "toggleServerlock" then
            toggleServerlock()
        end
    end
end)

-- Serverlock handler
Players.PlayerAdded:Connect(function(player)
    if serverlockEnabled and player ~= localPlayer then
        killPlayer(player)
    end
end)
