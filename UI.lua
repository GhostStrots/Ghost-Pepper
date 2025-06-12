local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GHOST_PEPPER_UI"
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "GHOST PEPPER by GHOST"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.BackgroundTransparency = 1
Title.Parent = Frame

-- TODO: Add buttons, scanner status, etc. based on user input
