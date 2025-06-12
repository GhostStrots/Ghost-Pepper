local Commands = {}

-- Access bindable event
local actionbind = game.Players.LocalPlayer:FindFirstChild("GHOSTAction")
if not actionbind then
    warn("GHOST PEPPER: Bindable event not found")
    return
end

-- DeleteTool: Creates a tool to delete clicked objects
function Commands.DeleteTool()
    local tool = Instance.new("Tool")
    tool.Name = "GHOSTDeleteTool"
    tool.Parent = game.Players.LocalPlayer.Backpack
    tool.Activated:Connect(function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        if mouse.Target then
            actionbind:Fire(mouse.Target)
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

-- FlyPlayer: Enables flight
function Commands.FlyPlayer()
    local player = game.Players.LocalPlayer
    local bodyvelocity = Instance.new("BodyVelocity")
    bodyvelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyvelocity.Velocity = Vector3.new(0, 0, 0)
    bodyvelocity.Parent = player.Character.HumanoidRootPart
    local bodygyro = Instance.new("BodyGyro")
    bodygyro.MaxTorque = Vector3.new(math.huge, 0, math.huge)
    bodygyro.Parent = player.Character.HumanoidRootPart
    player.Character.Humanoid.PlatformStand = true
    game:GetService("RunService").RenderStepped:Connect(function()
        if player.Character and player.Character.Humanoid then
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
            bodyvelocity.Velocity = move * 50
        end
    end)
end

-- MutePlayer: Mutes a player
function Commands.MutePlayer(target)
    local player = game.Players:FindFirstChild(target)
    if player then
        actionbind:Fire(player.Character.Humanoid)
    end
end

-- TeleportPlayer: Teleports to a player or position
function Commands.TeleportPlayer(target)
    local player = game.Players.LocalPlayer
    if target == "random" then
        local parts = workspace:GetDescendants()
        local randompart = parts[math.random(1, #parts)]
        if randompart:IsA("BasePart") then
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

return Commands
