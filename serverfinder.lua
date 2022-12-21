local Webhook = "https://discord.com/api/webhooks/1035540112399933519/9hyBfBhytKF2VQVvgdfTISYIQNmvb6PVz52nd5hVN6cUKrjL5XWlXSoVAqZtKHcEKvfm" -- Input webhook here!

local Script = [[local Webhook = "%s"

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer ~= nil; local LocalPlayer = game:GetService("Players").LocalPlayer
repeat task.wait() until LocalPlayer.Character ~= nil; local Character = LocalPlayer.Character
repeat task.wait() until Character.HumanoidRootPart

local List = game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/1537690962/servers/0?sortOrder=2&excludeFullGames=true&limit=100"))
local JobIds = {}

for _, Game in ipairs(List.data) do
    if Game.id ~= game.JobId then
        if Game.id ~= nil then
            table.insert(JobIds, Game.id)
        end
    end
end

function Log()
    local Data = {
        ["embeds"] = {{
            ["title"] = "Server Finder",
            ["description"] = "Server found!",
            ["color"] = tonumber(0xFFB200),
            ["fields"] = {
                {
                    ["name"] = "`JobId:`",
                    ["value"] = "```JobId: " .. game.JobId .. "```",
                },
                {
                    ["name"] = "`Code:`",
                    ["value"] = "```lua\ngame:GetService(\"TeleportService\"):TeleportToPlaceInstance(" .. game.PlaceId ..", \"" .. game.JobId .. "\", game:GetService(\"Players\").LocalPlayer)```",
                }
            }
        }}
    }

    local Request = (syn and syn.request) or (KRNL_LOADED and (http_request or request))
    
    pcall(function()
        Request({
            Url = Webhook,
            Method = "POST",
            Headers = {
                ["content-type"] = "application/json",
            },
            Body = game:GetService("HttpService"):JSONEncode(Data)
        })
    end)
end

local QueueOnTeleport = (syn and syn.queue_on_teleport) or (KRNL_LOADED and queue_on_teleport)

if game.PlaceVersion ~= 1232 then
    pcall(function()
        QueueOnTeleport(readfile("serverfind.lua"))
    end)
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, JobIds[Random.new():NextInteger(1, #JobIds)], game:GetService("Players").LocalPlayer)
else
    Log()
    pcall(function()
        QueueOnTeleport(readfile("serverfind.lua"))
    end)
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, JobIds[Random.new():NextInteger(1, #JobIds)], game:GetService("Players").LocalPlayer)
end]]

local QueueOnTeleport = (syn and syn.queue_on_teleport) or (KRNL_LOADED and queue_on_teleport)

Script = string.format(Script, Webhook)
writefile("serverfind.lua", Script)
QueueOnTeleport(readfile("serverfind.lua"))
game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
