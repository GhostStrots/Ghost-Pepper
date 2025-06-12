local Commands = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostStrots/Ghost-Pepper/refs/heads/main/GhostFunction.lua"))()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GHOST_PEPPER_UI"
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "GHOST PEPPER by GHOST"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.BackgroundTransparency = 1
Title.TextSize = 20
Title.Parent = Frame

-- Player selection dropdown
local Dropdown = Instance.new("TextButton")
Dropdown.Size = UDim2.new(0.8, 0, 0, 30)
Dropdown.Position = UDim2.new(0.1, 0, 0.15, 0)
Dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Dropdown.Text = "Select Player"
Dropdown.TextColor3 = Color3.new(1, 1, 1)
Dropdown.Parent = Frame

local DropdownFrame = Instance.new("Frame")
DropdownFrame.Size = UDim2.new(0.8, 0, 0, 100)
DropdownFrame.Position = UDim2.new(0.1, 0, 0.25, 0)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DropdownFrame.Visible = false
DropdownFrame.Parent = Frame

local function updateDropdown()
    DropdownFrame:ClearAllChildren()
    local players = {"all", "others", "random"}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    for i, name in ipairs(players) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 20)
        button.Position = UDim2.new(0, 0, 0, (i-1)*20)
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        button.Text = name
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Parent = DropdownFrame
        button.MouseButton1Click:Connect(function()
            Dropdown.Text = name
            DropdownFrame.Visible = false
        end)
    end
end
updateDropdown()
game.Players.PlayerAdded:Connect(updateDropdown)
game.Players.PlayerRemoving:Connect(updateDropdown)

Dropdown.MouseButton1Click:Connect(function()
    DropdownFrame.Visible = not DropdownFrame.Visible
end)

-- Command buttons
local buttons = {
    {Text = "Equip Delete Tool", Func = Commands.DeleteTool},
    {Text = "Kick Player", Func = function() Commands.KickPlayer(Dropdown.Text) end},
    {Text = "Fly", Func = Commands.FlyPlayer},
    {Text = "Mute Player", Func = function() Commands.MutePlayer(Dropdown.Text) end},
    {Text = "Teleport", Func = function() Commands.TeleportPlayer(Dropdown.Text) end},
    {Text = "Nuke Game", Func = Commands.NukeGame}
}

for i, btn in ipairs(buttons) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0, 30)
    button.Position = UDim2.new(0.1, 0, 0.35 + (i-1)*0.15, 0)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = btn.Text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Parent = Frame
    button.MouseButton1Click:Connect(btn.Func)
end
