local Commands = {}

-- Access bindable event
local actionbind = game.Players.LocalPlayer:FindFirstChild("GHOSTAction")
if not actionbind then
    warn("GHOST PEPPER: Bindable event not found")
    return
end

-- Example command: Delete item
function Commands.DeleteItem(item)
    if actionbind then
        actionbind:Fire(item)
    end
end

-- TODO: Add more commands based on user input
-- e.g., Commands.KickPlayer, Commands.CrashGame

return Commands
