local _tick = os.clock()
_G.tick = _tick
local bc = require(game:GetService("ReplicatedStorage").Modules.Client.Controllers.BulletController)
local players = game:getService("Players")

local function recursion(table, depth, indent)

	if not depth then depth = 0 end
	if not indent then indent = 0
	else indent += 1 end

	local padding = string.rep("    ", indent)

	for i,v in table do

		if typeof(v) == "table" and depth >= 1 then
			warn(padding..i)
			recursion(v, depth - 1, indent)
		else
			print(padding..i,v)
		end

	end

end

print("\n\n")
recursion(bc, 3)

local function getclosesthead()
    local closesthead = nil
    local closestdist = math.huge
    for _, player in players:GetPlayers() do
        if player == players.LocalPlayer or not player.Character then continue end
        if player.Character:FindFirstChild("Head") then 
            local distance = (player.Character.Head.Position - players.LocalPlayer.Character:GetPivot().Position).Magnitude
            if distance < closestdist then
                closesthead = player.Character.Head
                closestdist = distance
            end
        end
    end
    return closesthead
end


-- // doesnt work :(
-- local hook
-- hook = hookfunction(bc._ClaimMercHit, newcclosure(function(...)
--     if _G.tick == _tick then
--         print("\n")
--         local data = {...}
--         for i,v in data do print(i,v) end
--         -- local head = getclosesthead()
--         -- if head then
--         --     data[3] = head
--         --     local headposition = head:GetPivot().Position
--         --     data[4] = headposition
--         --     data[5] = (headposition - data[6]).Unit
--         --     print(head:GetFullName())
--         --     for i,v in data do print(i,v,typeof(v)) end
--         --     return hook(data)
--         -- end
    -- end
--     return hook(...)
-- end))


-- // Networking silent seems to work over function hook silent. i wonder why
-- // Seems to be some range change on how far you can kill a player(?)
local targetHead = getclosesthead()
if not _G.CurrentBullet or _G.CurrentBullet <= bc._fireSeq then
    _G.CurrentBullet = bc._fireSeq + 1
end
local remote = bc._mercHitClaimRemote
remote:FireServer(
	"Rattler",
	players:GetPlayerFromCharacter(targetHead.Parent).userId,
	"Head",
	targetHead.Position, -- target position
	(targetHead.Position - players.LocalPlayer.Character:GetPivot().Position).Unit, -- lookangle
	players.LocalPlayer.Character:GetPivot().Position, -- source position
	_G.CurrentBullet
-- 	162 -- find where the bullet counter is stored
    )
_G.CurrentBullet += 1
    
    
    