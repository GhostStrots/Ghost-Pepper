local Commands = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostStrots/Ghost-Pepper/refs/heads/main/GhostFunction.lua"))()
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GHOST_PEPPER_UI"
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 1000000000
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.75
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- UICorner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.SliceCenter = Rect.new(200, 200, 500, 500)
Shadow.SliceScale = 0.095
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageColor3 = Color3.fromRGB(153, 153, 153)
Shadow.Image = "http://www.roblox.com/asset/?id=13960012399"
Shadow.Size = UDim2.new(1, 18, 1, 18)
Shadow.BackgroundTransparency = 1
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Name = "Shadow"
Shadow.Parent = MainFrame

-- Shadow Gradient
local ShadowGradient = Instance.new("UIGradient")
ShadowGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))}
ShadowGradient.Parent = Shadow

-- Gloss
local Gloss = Instance.new("ImageLabel")
Gloss.ZIndex = -2147483647
Gloss.BackgroundColor3 = Color3.fromRGB(67, 67, 67)
Gloss.ImageTransparency = 0.1
Gloss.ImageColor3 = Color3.fromRGB(153, 153, 153)
Gloss.Image = "rbxassetid://413422291"
Gloss.Size = UDim2.new(1, 0, 1, 0)
Gloss.BackgroundTransparency = 1
Gloss.AnchorPoint = Vector2.new(0.5, 0.5)
Gloss.Position = UDim2.new(0.50333, 0, 0.5, 0)
Gloss.Name = "Gloss"
Gloss.Parent = MainFrame

-- Gloss UICorner
local GlossCorner = Instance.new("UICorner")
GlossCorner.CornerRadius = UDim.new(0, 10)
GlossCorner.Parent = Gloss

-- Gloss Gradient
local GlossGradient = Instance.new("UIGradient")
GlossGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))}
GlossGradient.Parent = Gloss

-- Frame Gradient
local FrameGradient = Instance.new("UIGradient")
FrameGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))}
FrameGradient.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.TextWrapped = true
Title.TextSize = 14
Title.TextScaled = true
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0, 165, 0, 33)
Title.Text = "👻 GHOST PEPPER v1.0 (FE)"
Title.Name = "Title"
Title.Position = UDim2.new(0.22333, 0, 0.02, 0)
Title.Parent = MainFrame

-- Username Input
local Username = Instance.new("TextBox")
Username.Name = "Username"
Username.TextSize = 18
Username.TextColor3 = Color3.fromRGB(255, 255, 255)
Username.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Username.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Username.AnchorPoint = Vector2.new(0.5, 0.5)
Username.PlaceholderText = "Username (all, others, me)"
Username.Size = UDim2.new(0, 183, 0, 30)
Username.Position = UDim2.new(0.44667, 0, 0, 60)
Username.Text = ""
Username.BackgroundTransparency = 1
Username.Parent = MainFrame

-- Username Background
local UsernameBG = Instance.new("Frame")
UsernameBG.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UsernameBG.Size = UDim2.new(1, 0, 1, 0)
UsernameBG.Name = "BG"
UsernameBG.BackgroundTransparency = 0.5
UsernameBG.Parent = Username

-- Username Shadow
local UsernameShadow = Instance.new("ImageLabel")
UsernameShadow.SliceCenter = Rect.new(200, 200, 500, 500)
UsernameShadow.SliceScale = 0.1
UsernameShadow.ScaleType = Enum.ScaleType.Slice
UsernameShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
UsernameShadow.ImageTransparency = 0.5
UsernameShadow.Image = "http://www.roblox.com/asset/?id=13960012399"
UsernameShadow.Size = UDim2.new(1, 18, 1, 18)
UsernameShadow.BackgroundTransparency = 1
UsernameShadow.AnchorPoint = Vector2.new(0.5, 0.5)
UsernameShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
UsernameShadow.Name = "Shadow"
UsernameShadow.Parent = UsernameBG

-- Username Shadow Gradient
local UsernameShadowGradient = Instance.new("UIGradient")
UsernameShadowGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))}
UsernameShadowGradient.Parent = UsernameShadow

-- Username Background UICorner
local UsernameBGCorner = Instance.new("UICorner")
UsernameBGCorner.CornerRadius = UDim.new(0, 10)
UsernameBGCorner.Parent = UsernameBG

-- Username Background Gradient
local UsernameBGGradient = Instance.new("UIGradient")
UsernameBGGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))}
UsernameBGGradient.Parent = UsernameBG

-- Username Animation
local UsernameAnim = Instance.new("LocalScript")
UsernameAnim.Name = "Anim"
UsernameAnim.Parent = Username
UsernameAnim.Source = [[
local textBox = script.Parent
textBox.Focused:Connect(function()
    textBox:TweenSize(UDim2.new(0, 190, 0, 35), "Out", "Quad", 0.1, true)
end)
textBox.FocusLost:Connect(function()
    textBox:TweenSize(UDim2.new(0, 183, 0, 30), "Out", "Quad", 0.1, true)
end)
]]

-- Scrolling Frame
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Active = true
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.Size = UDim2.new(0, 279, 0, 254)
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
ScrollingFrame.Position = UDim2.new(0.50458, 0, 0.60286, 0)
ScrollingFrame.ScrollBarThickness = 10
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Parent = MainFrame

-- Grid Layout
local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout.CellSize = UDim2.new(1, -35, 0, 40)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellPadding = UDim2.new(0, 5, 0, 10)
UIGradient.Parent = ScrollingFrame

-- SubTitle
local SubTitle = Instance.new("TextLabel")
SubTitle.TextWrapped = true
SubTitle.TextSize = 18
SubTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SubTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
SubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SubTitle.BackgroundTransparency = 1
SubTitle.Size = UDim2.new(0, 165, 0, 17)
SubTitle.Text = ".gg/GHOSTPEPPER"
SubTitle.Name = "SubTitle"
SubTitle.Position = UDim2.new(0.22667, 0, 0.06857, 0)
SubTitle.Parent = ScrollingFrame

-- Commands
local serverLockButton = nil
local buttons = {
    {Text = "Equip Delete Tool", Func = function() Commands.DeleteTool() end},
    {Text = "Kick", Func = function() Commands.KickPlayer(Username.Text) end},
    {Text = "Flight", Func = function() Commands.FlyPlayer() end},
    {Text = "Mute", Func = function() Commands.MutePlayer(Username.Text) end},
    {Text = "Teleport", Func = function() Commands.TeleportPlayer(Username.Text) end},
    {Text = "Nuke Game", Func = function() Commands.NukeGame() end},
    {Text = "Kill", Func = function() Commands.KillPlayer(Username.Text) end},
    {Text = "Server Lock", Func = function()
        local isLocked = Commands.ServerLock()
        serverLockButton.BackgroundColor3 = isLocked and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        serverLockButton.Text = "Server Lock: " .. (isLocked and "On" or "Off")
    end},
    {Text = "Bald", Func = function() Commands.Bald(Username.Text) end},
    {Text = "Server Ban", Func = function() Commands.ServerBan(Username.Text) end},
    {Text = "Blockhead (R6)", Func = function() Commands.Blockhead(Username.Text) end},
    {Text = "Break Terrain", Func = function() Commands.BreakTerrain() end},
    {Text = "Break Spawnlocations", Func = function() Commands.BreakSpawnlocations() end},
    {Text = "Brickify", Func = function() Commands.Brickify(Username.Text) end},
    {Text = "Cancel Animations", Func = function() Commands.CancelAnimations(Username.Text) end},
    {Text = "Copy User Tool", Func = function() Commands.CopyUserTool() end},
    {Text = "Dex Explorer", Func = function() Commands.DexExplorer() end},
    {Text = "Naked", Func = function() Commands.Naked(Username.Text) end},
    {Text = "No Limbs", Func = function() Commands.NoLimbs(Username.Text) end},
    {Text = "Punish", Func = function() Commands.Punish(Username.Text) end},
    {Text = "Ragdoll", Func = function() Commands.Ragdoll(Username.Text) end},
    {Text = "Remove Faces", Func = function() Commands.RemoveFaces(Username.Text) end},
    {Text = "Remove Tools", Func = function() Commands.RemoveTools(Username.Text) end},
    {Text = "Remove Sounds", Func = function() Commands.RemoveSounds() end},
    {Text = "Remove Lighting", Func = function() Commands.RemoveLighting() end},
    {Text = "Remove Player GUI", Func = function() Commands.RemovePlayerGui(Username.Text) end},
    {Text = "Waist", Func = function() Commands.Waist(Username.Text) end}
}

for i, btn in ipairs(buttons) do
    local button = Instance.new("TextButton")
    button.TextSize = 18
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = btn.Text == "Server Lock" and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 0)
    button.BackgroundTransparency = 0.8
    button.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    button.Text = btn.Text == "Server Lock" and "Server Lock: Off" or btn.Text
    button.Name = btn.Text:gsub(" ", "")
    button.Parent = ScrollingFrame

    if btn.Text == "Server Lock" then
        serverLockButton = button
    end

    local corner = Instance.new("UICorner")
    corner.Parent = button

    local shadow = Instance.new("ImageLabel")
    shadow.SliceCenter = Rect.new(200, 200, 500, 500)
    shadow.SliceScale = 0.1
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.Image = "http://www.roblox.com/asset/?id=13960012399"
    shadow.Size = UDim2.new(1, 18, 1, 18)
    shadow.BackgroundTransparency = 1
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Name = "Shadow"
    shadow.Parent = button

    local shadowGradient = Instance.new("UIGradient")
    shadowGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))}
    shadowGradient.Parent = shadow

    local buttonScript = Instance.new("LocalScript")
    buttonScript.Parent = button
    buttonScript.Source = [[
        local button = script.Parent
        local tweenService = game:GetService("TweenService")
        button.MouseButton1Click:Connect(function()
            button:TweenSize(UDim2.new(1, -40, 0, 35), "Out", "Quad", 0.1, true)
            wait(0.1)
            button:TweenSize(UDim2.new(1, -35, 0, 40), "Out", "Quad", 0.1, true)
        end)
        button.MouseEnter:Connect(function()
            tweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.6}):Play()
        end)
        button.MouseLeave:Connect(function()
            tweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
        end)
    ]]

    button.MouseButton1Click:Connect(btn.Func)
end

-- Command Counter
local MainHandler = Instance.new("LocalScript")
MainHandler.Name = "MainHandler"
MainHandler.Parent = MainFrame
MainHandler.Source = [[
    local commandcount = 0
    for _, v in pairs(script.Parent.ScrollingFrame:GetChildren()) do
        if v:IsA("TextButton") then
            commandcount = commandcount + 1
        end
    end
    script.Parent.ScrollingFrame.SubTitle.Text = script.Parent.ScrollingFrame.SubTitle.Text.." ("..tostring(commandcount).." commands loaded!)"
]]

-- Draggable Frame (Adapted from Strawberry)
local UIDrag = Instance.new("LocalScript")
UIDrag.Name = "UIDrag"
UIDrag.Parent = MainFrame
UIDrag.Source = [[
    local UIS = game:GetService('UserInputService')
    local frame = script.Parent
    local dragToggle = nil
    local dragSpeed = 0.25
    local dragStart = nil
    local startPos = nil

    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        game:GetService('TweenService'):Create(frame, TweenInfo.new(dragSpeed), {Position = position}):Play()
    end

    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragToggle then
                updateInput(input)
            end
        end
    end)
]]

-- Load Animation
MainFrame.Position = UDim2.new(0.5, 0, 1.5, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
