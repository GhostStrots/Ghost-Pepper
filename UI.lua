local Commands = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostStrots/Ghost-Pepper/refs/heads/main/GhostFunction.lua"))()
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GHOST_PEPPER_UI"
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 450, 0, 350)
Frame.Position = UDim2.new(0.5, -225, 0.5, -175)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 50, 50)
UIStroke.Thickness = 2
UIStroke.Parent = Frame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "GHOST PEPPER by GHOST"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.TextSize = 16
CloseButton.Parent = TitleBar
CloseButton.MouseButton1Click:Connect(function()
    Frame:TweenPosition(UDim2.new(0.5, -225, 1.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
    wait(0.5)
    ScreenGui:Destroy()
end)

-- Status Bar
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -20, 0, 30)
StatusBar.Position = UDim2.new(0, 10, 0, 50)
StatusBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
StatusBar.Parent = Frame
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -10, 1, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Ready"
StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusText.TextSize = 14
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusBar
local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 5)
StatusCorner.Parent = StatusBar

-- Player Dropdown
local Dropdown = Instance.new("TextButton")
Dropdown.Size = UDim2.new(0.9, 0, 0, 35)
Dropdown.Position = UDim2.new(0.05, 0, 0, 90)
Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Dropdown.Text = "Select Target"
Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
Dropdown.TextSize = 16
Dropdown.Parent = Frame
local DropCorner = Instance.new("UICorner")
DropCorner.CornerRadius = UDim.new(0, 5)
DropCorner.Parent = Dropdown
local DropStroke = Instance.new("UIStroke")
DropStroke.Color = Color3.fromRGB(255, 50, 50)
DropStroke.Thickness = 1
DropStroke.Parent = Dropdown

local DropdownFrame = Instance.new("ScrollingFrame")
DropdownFrame.Size = UDim2.new(0.9, 0, 0, 120)
DropdownFrame.Position = UDim2.new(0.05, 0, 0, 130)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DropdownFrame.BorderSizePixel = 0
DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownFrame.ScrollBarThickness = 5
DropdownFrame.Visible = false
DropdownFrame.Parent = Frame
local DropFrameCorner = Instance.new("UICorner")
DropFrameCorner.CornerRadius = UDim.new(0, 5)
DropFrameCorner.Parent = DropdownFrame

local function updateDropdown()
    DropdownFrame:ClearAllChildren()
    local players = {"all", "others", "random"}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, #players * 30)
    for i, name in ipairs(players) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 25)
        button.Position = UDim2.new(0, 5, 0, (i-1)*30)
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        button.Text = name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Parent = DropdownFrame
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 5)
        btnCorner.Parent = button
        button.MouseButton1Click:Connect(function()
            Dropdown.Text = name
            DropdownFrame.Visible = false
            StatusText.Text = "Selected: "..name
        end)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end)
    end
end
updateDropdown()
game.Players.PlayerAdded:Connect(updateDropdown)
game.Players.PlayerRemoving:Connect(updateDropdown)

Dropdown.MouseButton1Click:Connect(function()
    DropdownFrame.Visible = not DropdownFrame.Visible
    local targetPos = DropdownFrame.Visible and UDim.new(0, 130) or UDim.new(0, 90)
    TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0.05, 0, targetPos)}):Play()
end)

-- Command List
local CommandFrame = Instance.new("ScrollingFrame")
CommandFrame.Size = UDim2.new(0.9, 0, 0, 180)
CommandFrame.Position = UDim2.new(0.05, 0, 0, 150)
CommandFrame.BackgroundTransparency = 1
CommandFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
CommandFrame.ScrollBarThickness = 5
CommandFrame.Parent = Frame

local buttons = {
    {Text = "Equip Delete Tool", Func = function() Commands.DeleteTool() StatusText.Text = "Delete Tool Equipped" end},
    {Text = "Kick Player", Func = function() Commands.KickPlayer(Dropdown.Text) StatusText.Text = "Kicked "..Dropdown.Text end},
    {Text = "Fly", Func = function() Commands.FlyPlayer() StatusText.Text = "Flight Enabled" end},
    {Text = "Mute Player", Func = function() Commands.MutePlayer(Dropdown.Text) StatusText.Text = "Muted "..Dropdown.Text end},
    {Text = "Teleport", Func = function() Commands.TeleportPlayer(Dropdown.Text) StatusText.Text = "Teleported to "..Dropdown.Text end},
    {Text = "Nuke Game", Func = function() Commands.NukeGame() StatusText.Text = "Nuked Game" end}
}

CommandFrame.CanvasSize = UDim2.new(0, 0, 0, #buttons * 45)
for i, btn in ipairs(buttons) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 35)
    button.Position = UDim2.new(0, 5, 0, (i-1)*45)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Text = btn.Text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Parent = CommandFrame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = button
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 50, 50)
    btnStroke.Thickness = 1
    btnStroke.Parent = button
    button.MouseButton1Click:Connect(btn.Func)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 100, 100)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 50, 50)}):Play()
    end)
end

-- Animation on load
Frame.Position = UDim2.new(0.5, -225, 1.5, 0)
Frame:TweenPosition(UDim2.new(0.5, -225, 0.5, -175), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)

-- Draggable
local dragging, dragInput, dragStart, startPos
local function updateInput(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)
