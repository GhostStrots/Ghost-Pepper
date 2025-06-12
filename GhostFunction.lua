local Commands = {}

-- Access bindable event
local actionbind = game.Players.LocalPlayer:FindFirstChild("GHOSTAction")
if not actionbind then
    warn("GHOST PEPPER: Bindable event not found")
    return
end

-- DeleteTool: Creates a tool for serverside deletion
function Commands.DeleteTool()
    local player = game.Players.LocalPlayer
    local tool = Instance.new("Tool")
    tool.Name = "GHOSTDeleteTool"
    tool.RequiresHandle = false
    tool.Parent = player.Backpack

    -- Create RemoteFunction for serverside deletion
    local remoteFunc = Instance.new("RemoteFunction")
    remoteFunc.Name = "GHOSTDeleteRemote"
    remoteFunc.Parent = game.ReplicatedStorage

    -- Handle tool activation
    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        local target = mouse.Target
        if target and (target:IsA("BasePart") or target:IsA("Model")) then
            -- Fire backdoor remote to delete target
            actionbind:Fire(target)
        end
    end)

    -- Cleanup RemoteFunction when tool is unequipped or destroyed
    tool.Unequipped:Connect(function()
        if remoteFunc then
            remoteFunc:Destroy()
        end
    end)
    tool.Destroying:Connect(function()
        if remoteFunc then
            remoteFunc:Destroy()
        end
    end)
end

-- KickPlayer: Kicks specified player(s)
function Commands.KickPlayer(target)
    if target == "all" then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                actionbind:Fire(player)
            end
        end
    elseif target == "others" then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                actionbind:Fire(player)
            end
        end
    else
        local player = game.Players:FindFirstChild(target)
        if player then
            actionbind:Fire(player)
        end
    end
end

-- FlyPlayer: Full-directional flight
function Commands.FlyPlayer()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local root = character.HumanoidRootPart
    local humanoid = character.Humanoid

    -- Clean up existing flight instances
    for _, obj in ipairs(root:GetChildren()) do
        if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
            obj:Destroy()
        end
    end

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = root

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root

    humanoid.PlatformStand = true
    local speed = 50
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if not character or not humanoid or not root.Parent then
            connection:Disconnect()
            return
        end
        local cam = workspace.CurrentCamera
        local move = Vector3.new()
        if game.UserInputService:IsKeyDown(Enum.KeyCode.W) then
            move = move + cam.CFrame.LookVector
        end
        if game.UserInputService:IsKeyDown(Enum.KeyCode.S) then
            move = move - cam.CFrame.LookVector
        end
        if game.UserInputService:IsKeyDown(Enum.KeyCode.A) then
            move = move - cam.CFrame.RightVector
        end
        if game.UserInputService:IsKeyDown(Enum.KeyCode.D) then
            move = move + cam.CFrame.RightVector
        end
        if game.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            move = move + Vector3.new(0, 1, 0)
        end
        if game.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            move = move - Vector3.new(0, 1, 0)
        end
        bodyVelocity.Velocity = move.Unit * speed
        bodyGyro.CFrame = cam.CFrame
    end)

    -- Clean up on character reset
    humanoid.Died:Connect(function()
        connection:Disconnect()
        humanoid.PlatformStand = false
        bodyVelocity:Destroy()
        bodyGyro:Destroy()
    end)
end

-- MutePlayer: Mutes a player
function Commands.MutePlayer(target)
    local player = game.Players:FindFirstChild(target)
    if player and player.Character then
        actionbind:Fire(player.Character.Humanoid)
    end
end

-- TeleportPlayer: Teleports to a player or position
function Commands.TeleportPlayer(target)
    local player = game.Players.LocalPlayer
    if target == "random" then
        local parts = workspace:GetDescendants()
        local randompart
        for _, part in ipairs(parts) do
            if part:IsA("BasePart") and part ~= player.Character.HumanoidRootPart then
                randompart = part
                break
            end
        end
        if randompart then
            player.Character.HumanoidRootPart.CFrame = randompart.CFrame
        end
    else
        local targetplayer = game.Players:FindFirstChild(target)
        if targetplayer and targetplayer.Character then
            player.Character.HumanoidRootPart.CFrame = targetplayer.Character.HumanoidRootPart.CFrame
        end
    end
end

-- NukeGame: Deletes random parts
function Commands.NukeGame()
    local parts = workspace:GetDescendants()
    for i = 1, math.min(50, #parts) do
        local part = parts[math.random(1, #parts)]
        if part:IsA("BasePart") and part ~= game.Players.LocalPlayer.Character.HumanoidRootPart then
            actionbind:Fire(part)
        end
    end
end

-- KillPlayer: Kills specified player(s)
function Commands.KillPlayer(target)
    if target == "all" then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                actionbind:Fire(player.Character.Humanoid)
            end
        end
    elseif target == "others" then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                actionbind:Fire(player.Character.Humanoid)
            end
        end
    else
        local player = game.Players:FindFirstChild(target)
        if player and player.Character then
            actionbind:Fire(player.Character.Humanoid)
        end
    end
end

-- ServerLock: Prevents new players from joining
function Commands.ServerLock()
    game.Players.PlayerAdded:Connect(function(player)
        if player ~= game.Players.LocalPlayer then
            actionbind:Fire(player)
        end
    end)
end

return Commands
