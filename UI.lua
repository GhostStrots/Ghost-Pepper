-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local localPlayer = Players.LocalPlayer
local scannerRunning = false

-- Ghost GUI Engine
local GuiEngine = {}
do
    function GuiEngine.new(screenParent)
        local self = {}
        self.ScreenGui = Instance.new("ScreenGui")
        self.ScreenGui.Parent = screenParent or CoreGui
        self.ScreenGui.ResetOnSpawn = false
        self.ScreenGui.Name = "GhostGui"

        function self:createFrame(size, position, color)
            local frame = Instance.new("Frame")
            frame.Size = size
            frame.Position = position
            frame.BackgroundColor3 = color or Color3.new(0.1, 0.2, 0.1) -- Eerie green-gray
            frame.BackgroundTransparency = 0.2
            frame.BorderSizePixel = 0
            frame.Active = true
            frame.Draggable = true
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = frame
            frame.Parent = self.ScreenGui
            return frame
        end

        function self:createButton(parent, position, size, text, color, callback)
            local button = Instance.new("TextButton")
            button.Size = size
            button.Position = position
            button.BackgroundColor3 = color or Color3.new(0.2, 0.3, 0.2)
            button.Text = text
            button.TextColor3 = Color3.new(0.5, 1, 0.5) -- Ghostly green text
            button.TextScaled = true
            button.Font = Enum.Font.GothamBold
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = button
            button.Parent = parent
            if callback then
                button.MouseButton1Click:Connect(callback)
            end
            return button
        end

        function self:createLabel(parent, position, size, text, color)
            local label = Instance.new("TextLabel")
            label.Size = size
            label.Position = position
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = color or Color3.new(0.5, 1, 0.5)
            label.TextScaled = true
            label.Font = Enum.Font.SourceSansBold
            label.Parent = parent
            return label
        end

        return self
    end
end

-- GUI Setup
local gui = GuiEngine.new(CoreGui)
local mainFrame = gui:createFrame(UDim2.new(0, 400, 0, 600), UDim2.new(0.5, -200, 0.5, -300), Color3.new(0.1, 0.2, 0.1))

-- Tabs
local tabButtons = {}
local tabs = {}
local tabContent = Instance.new("Frame")
tabContent.Size = UDim2.new(1, -40, 1, -120)
tabContent.Position = UDim2.new(0, 20, 0, 100)
tabContent.BackgroundTransparency = 1
tabContent.Parent = mainFrame
local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabContent

local function createTab(name)
    local button = gui:createButton(mainFrame, UDim2.new(0, (#tabButtons * 90), 0, 80), UDim2.new(0, 80, 0, 30), name, Color3.new(0.2, 0.3, 0.2), function()
        for _, btn in pairs(tabButtons) do btn.BackgroundColor3 = Color3.new(0.2, 0.3, 0.2) end
        button.BackgroundColor3 = Color3.new(0.3, 0.4, 0.3)
        for _, tab in pairs(tabs) do tab.Visible = false end
        tabs[name].Visible = true
    end)
    table.insert(tabButtons, button)

    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = #tabButtons == 1
    tabFrame.Parent = tabContent
    tabs[name] = tabFrame
    return tabFrame
end

-- Scanner Tab
local scannerTab = createTab("Scanner")
local scanStatus = gui:createLabel(scannerTab, UDim2.new(0.1, 0, 0, 0), UDim2.new(0.8, 0, 0, 50), "Scan Status: Not Running", Color3.new(0.5, 1, 0.5))
gui:createButton(scannerTab, UDim2.new(0.1, 0, 0, 60), UDim2.new(0.8, 0, 0, 40), "Start Scan", Color3.new(0, 0.5, 0), function()
    if not scannerRunning then
        scannerRunning = true
        scanStatus.Text = "Scan Status: Running..."
        local success, result = pcall(function() ReplicatedStorage:WaitForChild("Scanner"):FireServer("start") end)
        if not success then scanStatus.Text = "Scan Status: Error - Check Console" end
    end
end)
gui:createButton(scannerTab, UDim2.new(0.1, 0, 0, 110), UDim2.new(0.8, 0, 0, 40), "Stop Scan", Color3.new(0.5, 0, 0), function()
    if scannerRunning then
        scannerRunning = false
        scanStatus.Text = "Scan Status: Stopped"
        local success, result = pcall(function() ReplicatedStorage:WaitForChild("Scanner"):FireServer("stop") end)
        if not success then scanStatus.Text = "Scan Status: Error - Check Console" end
    end
end)

-- Actions Tab
local actionsTab = createTab("Actions")
gui:createButton(actionsTab, UDim2.new(0.1, 0, 0, 0), UDim2.new(0.8, 0, 0, 40), "Kill Player", Color3.new(0.8, 0, 0), function()
    local success, result = pcall(function() ReplicatedStorage:WaitForChild("Functions"):FireServer("kill", "target") end)
    if not success then warn("Action failed: Kill") end
end)
gui:createButton(actionsTab, UDim2.new(0.1, 0, 0, 50), UDim2.new(0.8, 0, 0, 40), "Kick Player", Color3.new(0, 0, 0.8), function()
    local success, result = pcall(function() ReplicatedStorage:WaitForChild("Functions"):FireServer("kick", "target") end)
    if not success then warn("Action failed: Kick") end
end)
gui:createButton(actionsTab, UDim2.new(0.1, 0, 0, 100), UDim2.new(0.8, 0, 0, 40), "Teleport", Color3.new(0.5, 0, 0.5), function()
    local success, result = pcall(function() ReplicatedStorage:WaitForChild("Functions"):FireServer("teleport", "target") end)
    if not success then warn("Action failed: Teleport") end
end)

-- Settings Tab
local settingsTab = createTab("Settings")
gui:createButton(settingsTab, UDim2.new(0.1, 0, 0, 0), UDim2.new(0.8, 0, 0, 40), "Toggle Serverlock", Color3.new(0.5, 0.5, 0.5), function()
    local success, result = pcall(function() ReplicatedStorage:WaitForChild("Functions"):FireServer("toggleServerlock") end)
    if not success then warn("Action failed: Toggle Serverlock") end
end)

-- Close button
gui:createButton(mainFrame, UDim2.new(1, -60, 0, 10), UDim2.new(0, 50, 0, 50), "X", Color3.new(0.8, 0, 0), function()
    mainFrame.Visible = false
end)

-- Initial setup
localPlayer.CharacterAdded:Connect(function() task.wait(1); mainFrame.Visible = true end)
mainFrame.Visible = true

-- Handle scanner updates
ReplicatedStorage:WaitForChild("ScannerUpdates", 10):Connect(function(status)
    scanStatus.Text = "Scan Status: " .. status
end)
