local Commands = {}

-- Access bindable event
local actionbind = game.Players.LocalPlayer:FindFirstChild("GHOSTAction")
if not actionbind then
    warn("GHOST PEPPER: Bindable event not found")
    return
end

-- ServerLock state
local serverLocked = false

-- DeleteTool: Creates a tool for serverside deletion
function Commands.DeleteTool()
    local player = game.Players.LocalPlayer
    local tool = Instance.new("Tool")
    tool.Name = "GHOSTDeleteTool"
    tool.RequiresHandle = false
    tool.Parent = player.Backpack

    local remoteFunc = Instance.new("RemoteFunction")
    remoteFunc.Name = "GHOSTDeleteRemote"
    remoteFunc.Parent = game.ReplicatedStorage

    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        local target = mouse.Target
        if target and (target:IsA("BasePart") or target:IsA("Model")) then
            actionbind:Fire(target)
        end
    end)

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

-- ServerLock: Toggles server lock on/off
function Commands.ServerLock()
    serverLocked = not serverLocked
    if serverLocked then
        game.Players.PlayerAdded:Connect(function(player)
            if player ~= game.Players.LocalPlayer then
                actionbind:Fire(player)
            end
        end)
    end
    return serverLocked
end

-- Leaderstats: Opens a submenu to view player's leaderstats
function Commands.Leaderstats()
    local player = game.Players.LocalPlayer
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    local gui = Instance.new("ScreenGui")
    gui.Name = "GHOST_Leaderstats_UI"
    gui.Parent = game.Players.LocalPlayer.PlayerGui
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 1000000001
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 300)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.75
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local shadow = Instance.new("ImageLabel")
    shadow.SliceCenter = Rect.new(200, 200, 500, 500)
    shadow.SliceScale = 0.095
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageColor3 = Color3.fromRGB(153, 153, 153)
    shadow.Image = "http://www.roblox.com/asset/?id=13960012399"
    shadow.Size = UDim2.new(1, 18, 1, 18)
    shadow.BackgroundTransparency = 1
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Name = "Shadow"
    shadow.Parent = frame

    local shadowGradient = Instance.new("UIGradient")
    shadowGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))}
    shadowGradient.Parent = shadow

    local gloss = Instance.new("ImageLabel")
    gloss.ZIndex = -2147483647
    gloss.BackgroundColor3 = Color3.fromRGB(67, 67, 67)
    gloss.ImageTransparency = 0.1
    gloss.ImageColor3 = Color3.fromRGB(153, 153, 153)
    gloss.Image = "rbxassetid://413422291"
    gloss.Size = UDim2.new(1, 0, 1, 0)
    gloss.BackgroundTransparency = 1
    gloss.AnchorPoint = Vector2.new(0.5, 0.5)
    gloss.Position = UDim2.new(0.50333, 0, 0.5, 0)
    gloss.Name = "Gloss"
    gloss.Parent = frame

    local glossCorner = Instance.new("UICorner")
    glossCorner.CornerRadius = UDim.new(0, 10)
    glossCorner.Parent = gloss

    local glossGradient = Instance.new("UIGradient")
    glossGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))}
    glossGradient.Parent = gloss

    local frameGradient = Instance.new("UIGradient")
    frameGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))}
    frameGradient.Parent = frame

    local title = Instance.new("TextLabel")
    title.TextWrapped = true
    title.TextSize = 14
    title.TextScaled = true
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(0, 165, 0, 33)
    title.Text = "👻 Leaderstats"
    title.Position = UDim2.new(0.22333, 0, 0.02, 0)
    title.Parent = frame

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.BackgroundTransparency = 0.8
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    closeButton.TextSize = 18
    closeButton.Parent = frame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton

    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Active = true
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.Size = UDim2.new(0, 229, 0, 254)
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    scrollingFrame.Position = UDim2.new(0.50458, 0, 0.60286, 0)
    scrollingFrame.ScrollBarThickness = 10
    scrollingFrame.Parent = frame

    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    gridLayout.CellSize = UDim2.new(1, -35, 0, 40)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.CellPadding = UDim2.new(0, 5, 0, 10)
    gridLayout.Parent = scrollingFrame

    for _, stat in ipairs(leaderstats:GetChildren()) do
        if stat:IsA("IntValue") or stat:IsA("NumberValue") or stat:IsA("StringValue") then
            local statLabel = Instance.new("TextLabel")
            statLabel.Text = stat.Name .. ": " .. tostring(stat.Value)
            statLabel.TextSize = 18
            statLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            statLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            statLabel.BackgroundTransparency = 0.8
            statLabel.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            statLabel.Parent = scrollingFrame

            local statCorner = Instance.new("UICorner")
            statCorner.Parent = statLabel

            local statShadow = Instance.new("ImageLabel")
            statShadow.SliceCenter = Rect.new(200, 200, 500, 500)
            statShadow.SliceScale = 0.1
            statShadow.ScaleType = Enum.ScaleType.Slice
            statShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            statShadow.ImageTransparency = 0.5
            statShadow.Image = "http://www.roblox.com/asset/?id=13960012399"
            statShadow.Size = UDim2.new(1, 18, 1, 18)
            statShadow.BackgroundTransparency = 1
            statShadow.AnchorPoint = Vector2.new(0.5, 0.5)
            statShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
            statShadow.Name = "Shadow"
            statShadow.Parent = statLabel

            local statShadowGradient = Instance.new("UIGradient")
            statShadowGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))}
            statShadowGradient.Parent = statShadow

            stat:GetPropertyChangedSignal("Value"):Connect(function()
                statLabel.Text = stat.Name .. ": " .. tostring(stat.Value)
            end)
        end
    end
end

-- Strawberry Commands
function Commands.Bald(target)
    local player = game.Players:FindFirstChild(target)
    if target == "all" then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Head") then
                for _, x in pairs(v.Character:GetChildren()) do
                    if x:IsA("Accessory") and x:FindFirstChild("Hair") then
                        actionbind:Fire(x)
                    end
                end
            end
        end
    elseif target == "others" then
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Head") then
                for _, x in pairs(v.Character:GetChildren()) do
                    if x:IsA("Accessory") and x:FindFirstChild("Hair") then
                        actionbind:Fire(x)
                    end
                end
            end
        end
    elseif target == "me" then
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Head") then
            for _, v in pairs(localPlayer.Character:GetChildren()) do
                if v:IsA("Accessory") and v:FindFirstChild("Hair") then
                    actionbind:Fire(v)
                end
            end
        end
    elseif player and player.Character and player.Character:FindFirstChild("Head") then
        for _, v in pairs(player.Character:GetChildren()) do
            if v:IsA("Accessory") and v:FindFirstChild("Hair") then
                actionbind:Fire(v)
            end
        end
    end
end

function Commands.ServerBan(target)
    Commands.KickPlayer(target)
end

function Commands.Blockhead(target)
    local player = game.Players:FindFirstChild(target)
    if target == "all" then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Torso") then
                actionbind:Fire(v.Character.Head)
            end
        end
    elseif target == "others" then
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Torso") then
                actionbind:Fire(v.Character.Head)
            end
        end
    elseif target == "me" then
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Head") and localPlayer.Character:FindFirstChild("Torso") then
            actionbind:Fire(localPlayer.Character.Head)
        end
    elseif player and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Torso") then
        actionbind:Fire(player.Character.Head)
    end
end

function Commands.BreakTerrain()
    if workspace.Terrain then
        actionbind:Fire(workspace.Terrain)
    end
end

function Commands.BreakSpawnlocations()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("SpawnLocation") then
            actionbind:Fire(v)
        end
    end
end

function Commands.Brickify(target)
    local player = game.Players:FindFirstChild(target)
    if target == "all" then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                actionbind:Fire(v.Character.HumanoidRootPart)
            end
        end
    elseif target == "others" then
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= localPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                actionbind:Fire(v.Character.HumanoidRootPart)
            end
        end
    elseif target == "me" then
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            actionbind:Fire(localPlayer.Character.HumanoidRootPart)
        end
    elseif player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        actionbind:Fire(player.Character.HumanoidRootPart)
    end
end

function Commands.CancelAnimations(target)
    local player = game.Players:FindFirstChild(target)
    if target == "all" then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Humanoid") then
                for _, anim in pairs(v.Character.Humanoid:GetPlayingAnimationTracks()) do
                    actionbind:Fire(anim)
                end
            end
        end
    elseif target == "others" then
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
                for _, anim in pairs(v.Character.Humanoid:GetPlayingAnimationTracks()) do
                    actionbind:Fire(anim)
                end
            end
        end
    elseif target == "me" then
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            for _, anim in pairs(localPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
                actionbind:Fire(anim)
            end
        end
    elseif player and player.Character and player.Character:FindFirstChild("Humanoid") then
        for _, anim in pairs(player.Character.Humanoid:GetPlayingAnimationTracks()) do
            actionbind:Fire(anim)
        end
    end
end

function Commands.CopyUserTool()
    local player = game.Players.LocalPlayer
    local tool = Instance.new("Tool")
    tool.Name = "GHOSTCopyUser"
    tool.RequiresHandle = false
    tool.Parent = player.Backpack

    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        local target = mouse.Target
        if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
            local targetPlayer = game.Players:GetPlayerFromCharacter(target.Parent)
            if targetPlayer then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "GHOST PEPPER",
                    Text = "Copied username: " .. targetPlayer.Name,
                    Duration = 3
                })
                setclipboard(targetPlayer.Name)
            end
        end
    end)
end

function Commands.DexExplorer()
    local explorerGui = Instance.new("ScreenGui")
    explorerGui.Name = "GHOSTExplorer"
    explorerGui.Parent = game.Players.LocalPlayer.PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.Parent = explorerGui

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -10, 1, -40)
    scrollingFrame.Position = UDim2.new(0, 5, 0, 35)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.ScrollBarThickness = 5
    scrollingFrame.Parent = mainFrame

    local backButton = Instance.new("TextButton")
    backButton.Size = UDim2.new(0, 50, 0, 30)
    backButton.Position = UDim2.new(0, 5, 0, 5)
    backButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    backButton.Text = "Back"
    backButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    backButton.Parent = mainFrame

    local currentInstance = game
    local historyStack = {}

    local function clearButtons()
        for _, child in ipairs(scrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
    end

    local function listChildren(parentInstance)
        clearButtons()
        for _, child in ipairs(parentInstance:GetChildren()) do
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -scrollingFrame.ScrollBarThickness - 1, 0, 30)
            button.Position = UDim2.new(0, 5, 0, 0)
            button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            button.BorderSizePixel = 1
            button.BorderColor3 = Color3.new(0.784314, 0.784314, 0.784314)
            button.TextColor3 = Color3.fromRGB(27, 42, 53)
            button.Text = " " .. child.Name .. " (" .. child.ClassName .. ")"
            button.TextXAlignment = Enum.TextXAlignment.Left
            button.Font = Enum.Font.SourceSans
            button.TextSize = 18
            button.Parent = scrollingFrame

            if child.ClassName == "Script" or child.ClassName == "LocalScript" then
                local image = Instance.new("ImageLabel", button)
                image.Size = UDim2.new(0, 15, 0, 15)
                image.Position = UDim2.new(0, 5, 0.2, 2)
                image.BackgroundTransparency = 1
                image.Image = "http://www.roblox.com/asset/?id=4998267428"
                button.Text = "       " .. button.Text
            elseif child.ClassName == "Model" then
                local image = Instance.new("ImageLabel", button)
                image.Size = UDim2.new(0, 15, 0, 15)
                image.Position = UDim2.new(0, 5, 0.2, 2)
                image.BackgroundTransparency = 1
                image.Image = "http://www.roblox.com/asset/?id=18402365961"
                button.Text = "       " .. button.Text
            elseif child.ClassName == "Part" then
                local image = Instance.new("ImageLabel", button)
                image.Size = UDim2.new(0, 15, 0, 15)
                image.Position = UDim2.new(0, 5, 0.2, 2)
                image.BackgroundTransparency = 1
                image.Image = "http://www.roblox.com/asset/?id=7368549141"
                button.Text = "       " .. button.Text
            elseif child.ClassName == "Folder" then
                local image = Instance.new("ImageLabel", button)
                image.Size = UDim2.new(0, 15, 0, 15)
                image.Position = UDim2.new(0, 5, 0.2, 2)
                image.BackgroundTransparency = 1
                image.Image = "http://www.roblox.com/asset/?id=17392072037"
                button.Text = "       " .. button.Text
            elseif child.ClassName == "Humanoid" then
                local image = Instance.new("ImageLabel", button)
                image.Size = UDim2.new(0, 15, 0, 15)
                image.Position = UDim2.new(0, 5, 0.2, 2)
                image.BackgroundTransparency = 1
                image.Image = "http://www.roblox.com/asset/?id=8143940984"
                button.Text = "       " .. button.Text
            end

            button.MouseButton1Click:Connect(function()
                table.insert(historyStack, currentInstance)
                currentInstance = child
                listChildren(child)
                scrollingFrame.CanvasPosition = Vector2.new(0, 0)
            end)
            button.MouseButton2Click:Connect(function()
                actionbind:Fire(child)
                button:Destroy()
            end)
        end
    end

    backButton.MouseButton1Click:Connect(function()
        if #historyStack > 0 then
            currentInstance = table.remove(historyStack)
            listChildren(currentInstance)
            scrollingFrame.CanvasPosition = Vector2.new(0, 0)
        end
    end)

    listChildren(currentInstance)
end

function Commands.Naked(target)
    local player = game.Players:FindFirstChild(target)
    if target == "all" then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Head") then
                for _, x in pairs(v.Character:GetChildren()) do
                    if x:IsA("Shirt") or x:IsA("Pants") or x:IsA("ShirtGraphic") then
                        actionbind:Fire(x)
                    end
                end
            end
        end
    elseif target == "others" then
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Head") then
                for _, x in pairs(v.Character:GetChildren()) do
                    if x:IsA("Shirt") or x:IsA("Pants") or x:IsA("ShirtGraphic") then
                        actionbind:Fire(x)
                    end
                end
            end
        end
    elseif target == "me" then
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Head") then
            for _, v in pairs(localPlayer.Character:GetChildren()) do
                if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
                    actionbind:Fire(v)
                end
            end
        end
    elseif player and player.Character and player.Character:FindFirstChild("Head") then
        for _, v in pairs(player.Character:GetChildren()) do
            if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
                actionbind:Fire(v)
            end
        end
    end
end

function Commands.NoLimbs(target)
    local player = game.Players:FindFirstChild(target)
    if target == "all" then
        for _, v in pairs(game.Players:GetPlayers()) do
            local character = v.Character
            if character and character:FindFirstChild("Head") then
                if character:FindFirstChild("Torso") then
                    local limbs = {"Left Arm", "Left Leg", "Right Arm", "Right Leg"}
                    for _, limb in ipairs(limbs) do
                        local part = character:FindFirstChild(limb)
                        if part then actionbind:Fire(part) end
                    end
                elseif character:FindFirstChild("UpperTorso") then
                    local limbs = {
                        "LeftUpperArm", "LeftLowerArm", "LeftArm",
                        "LeftUpperLeg", "LeftLowerLeg", "LeftLeg",
                        "RightUpperArm", "RightLowerArm", "RightArm",
                        "RightUpperLeg", "RightLowerLeg", "RightLeg"
                    }
                    for _, limb in ipairs(limbs) do
                        local part = character:FindFirstChild(limb)
                        if part then actionbind:Fire(part) end
                    end
                end
            end
        end
    elseif target == "others" then
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= localPlayer then
                local character = v.Character
                if character and character:FindFirstChild("Head") then
                    if character:FindFirstChild("Torso") then
                        local limbs = {"Left Arm", "Left Leg", "Right Arm", "Right Leg"}
                        for _, limb in ipairs(limbs) do
                            local part = character:FindFirstChild(limb)
                            if part then actionbind:Fire(part) end
                        end
                    elseif character:FindFirstChild("UpperTorso") then
                        local limbs = {
                            "LeftUpperArm", "LeftLowerArm", "LeftArm",
                            "LeftUpperLeg", "LeftLowerLeg", "LeftLeg",
                            "RightUpperArm", "RightLowerArm", "RightArm",
                            "RightUpperLeg", "RightLowerLeg", "RightLeg"
                        }
                        for _, limb in ipairs(limbs) do
                            local part = character:FindFirstChild(limb)
                            if part then actionbind:Fire(part) end
                        end
                    end
                end
            end
        end
    elseif target == "me" then
        local localPlayer = game.Players.LocalPlayer
        local character = localPlayer.Character
        if character and character:FindFirstChild("Head") then
            if character:FindFirstChild("Torso") then
                local limbs = {"Left Arm", "Left Leg", "Right Arm", "Right Leg"}
                for _, limb in ipairs(limbs) do
                    local part = character:FindFirstChild(limb)
                    if part then actionbind:Fire(part) end
                end
            elseif character:FindFirstChild("UpperTorso") then
                local limbs = {
                    "LeftUpperArm", "LeftLowerArm", "LeftArm",
                    "LeftUpperLeg", "LeftLowerLeg", "LeftLeg",
                    "RightUpperArm", "RightLowerArm", "RightArm",
                    "RightUpperLeg", "RightLowerLeg", "RightLeg"
                }
                for _, limb in ipairs(limbs) do
                    local part = character:FindFirstChild(limb)
                    if part then actionbind:Fire(part) end
                end
            end
        end
    elseif player and player.Character and player.Character:FindFirstChild("Head") then
        local character = player.Character
        if character:FindFirstChild("Torso") then
            local limbs = {"Left Arm", "Left Leg", "Right Arm", "Right Leg"}
            for _, limb in ipairs(limbs) do
                local part = character:FindFirstChild(limb)
                if part then actionbind:Fire(part) end
            end
        elseif character:FindFirstChild("UpperTorso") then
            local limbs = {
                "LeftUpperArm", "LeftLowerArm", "LeftArm",
                "LeftUpperLeg", "LeftLowerLeg", "LeftLeg",
                "RightUpperArm", "RightLowerArm", "RightArm",
                "RightUpperLeg", "RightLowerLeg", "RightLeg"
            }
            for _, limb in ipairs(limbs) do
                local part = character:FindFirstChild(limb)
                if part then actionbind:Fire(part) end
            end
        end
    end
end

function Commands.Punish(target)
    local player = game.Players:FindFirstChild(target)
    if target == "all" then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Head") then
                actionbind:Fire(v.Character)
            end
        end
    elseif target == "others" then
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Head") then
                actionbind:Fire(v.Character)
            end
        end
    elseif target == "me" then
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Head") then
            actionbind:Fire(localPlayer.Character)
        end
    elseif player and player.Character and player.Character:FindFirstChild("Head") then
        actionbind:Fire(player.Character)
    end
end

function Commands.Ragdoll(target)
    local player = game.Players:FindFirstChild(target)
    if target == "all" then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                actionbind:Fire(v.Character.HumanoidRootPart)
            end
        end
    elseif target == "others" then
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= localPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                actionbind:Fire(v.Character.HumanoidRootPart)
            end
        end
    elseif target == "me" then
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            actionbind:Fire(localPlayer.Character.HumanoidRootPart)
        end
    elseif player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        actionbind:Fire(player.Character.HumanoidRootPart)
    end
end

function Commands.RemoveFaces(target)
    local player = game.Players:FindFirstChild(target)
    if target == "all" then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Head") then
                for _, x in pairs(v.Character.Head:GetChildren()) do
                    if x:IsA("Decal") then
                        actionbind:Fire(x)
                    end
                end
            end
        end
    elseif target == "others" then
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Head") then
                for _, x in pairs(v.Character.Head:GetChildren()) do
                    if x:IsA("Decal") then
                        actionbind:Fire(x)
                    end
                end
            end
        end
    elseif target == "me" then
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Head") then
            for _, v in pairs(localPlayer.Character.Head:GetChildren()) do
                if v:IsA("Decal") then
                    actionbind:Fire(v)
                end
            end
        end
    elseif player and player.Character and player.Character:FindFirstChild("Head") then
        for _, v in pairs(player.Character:GetChildren()) do
            if v:IsA("Decal") then
                actionbind:Fire(v)
            end
        end
    end
end

function Commands.RemoveTools(target)
    local player = game.Players:FindFirstChild(target)
    if target == "all" then
        for _, v in pairs(game.Players:GetPlayers()) do
            for _, x in pairs(v.Backpack:GetChildren()) do
                actionbind:Fire(x)
            end
            if v.Character then
                for _, x in pairs(v.Character:GetChildren()) do
                    if x:IsA("Tool") then
                        actionbind:Fire(x)
                    end
                end
            end
        end
    elseif target == "others" then
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= localPlayer then
                for _, x in pairs(v.Backpack:GetChildren()) do
                    actionbind:Fire(x)
                end
                if v.Character then
                    for _, x in pairs(v.Character:GetChildren()) do
                        if x:IsA("Tool") then
                            actionbind:Fire(x)
                        end
                    end
                end
            end
        end
    elseif target == "me" then
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(localPlayer.Backpack:GetChildren()) do
            actionbind:Fire(v)
        end
        if localPlayer.Character then
            for _, v in pairs(localPlayer.Character:GetChildren()) do
                if v:IsA("Tool") then
                    actionbind:Fire(v)
                end
            end
        end
    elseif player then
        for _, v in pairs(player.Backpack:GetChildren()) do
            actionbind:Fire(v)
        end
        if player.Character then
            for _, v in pairs(player.Character:GetChildren()) do
                if v:IsA("Tool") then
                    actionbind:Fire(v)
                end
            end
        end
    end
end

function Commands.RemoveSounds()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Sound") then
            actionbind:Fire(v)
        end
    end
end

function Commands.RemoveLighting()
    for _, v in ipairs(game.Lighting:GetDescendants()) do
        actionbind:Fire(v)
    end
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Light") then
            actionbind:Fire(v)
        end
    end
end

function Commands.RemovePlayerGui(target)
    local player = game.Players:FindFirstChild(target)
    if target == "all" then
        for _, v in pairs(game.Players:GetPlayers()) do
            for _, x in pairs(v.PlayerGui:GetChildren()) do
                actionbind:Fire(x)
            end
        end
    elseif target == "others" then
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= localPlayer then
                for _, x in pairs(v.PlayerGui:GetChildren()) do
                    actionbind:Fire(x)
                end
            end
        end
    elseif target == "me" then
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(localPlayer.PlayerGui:GetChildren()) do
            actionbind:Fire(v)
        end
    elseif player then
        for _, v in pairs(player.PlayerGui:GetChildren()) do
            actionbind:Fire(v)
        end
    end
end

function Commands.Waist(target)
    local player = game.Players:FindFirstChild(target)
    if target == "all" then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("UpperTorso") then
                local waist = v.Character.UpperTorso:FindFirstChild("Waist")
                if waist then
                    actionbind:Fire(waist)
                end
            end
        end
    elseif target == "others" then
        local localPlayer = game.Players.LocalPlayer
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= localPlayer and v.Character and v.Character:FindFirstChild("UpperTorso") then
                local waist = v.Character.UpperTorso:FindFirstChild("Waist")
                if waist then
                    actionbind:Fire(waist)
                end
            end
        end
    elseif target == "me" then
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("UpperTorso") then
            local waist = localPlayer.Character.UpperTorso:FindFirstChild("Waist")
            if waist then
                actionbind:Fire(waist)
            end
        end
    elseif player and player.Character and player.Character:FindFirstChild("UpperTorso") then
        local waist = player.Character.UpperTorso:FindFirstChild("Waist")
        if waist then
            actionbind:Fire(waist)
        end
    end
end

return Commands
