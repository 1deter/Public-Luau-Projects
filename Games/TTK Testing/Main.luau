local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local BulletController = require(game:GetService("ReplicatedStorage").Modules.Client.Controllers.BulletController)

local _tick = os.clock()
_G.tick = _tick

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

local function GetClosestHead()
    local ClosestHead = nil
    local ClosestDistance = math.huge
    local TargetHead = nil

    for _, Hitbox in workspace.MercPlayers:GetChildren() do

		if not string.find(Hitbox.Name:lower(), "hitbox") then continue end
		
		local TargetName = string.gsub(Hitbox.Name, "MercHitboxes_", "")
		local TargetPlayer = Players:FindFirstChild(TargetName)

		if not TargetPlayer or not TargetPlayer.Character then continue end -- attempt to index nil with character

		local TargetCharacter = TargetPlayer.Character

		if TargetCharacter.Humanoid.Health <= 0 then continue end
		
		TargetHead = TargetCharacter:FindFirstChild("Head")

        if Hitbox:FindFirstChild("Head") then 
			local Head = Hitbox.Head
            local Distance = (Head.Position - Players.LocalPlayer.Character:GetPivot().Position).Magnitude

            if Distance < ClosestDistance then
                ClosestHead = Head
                ClosestDistance = Distance
            end
        end
    end

    return ClosestHead, TargetHead -- 1st is head from hitbox models, 2nd is head from player.character
end


-- // doesnt work :( maybe look into another function?
-- local hook
-- hook = hookfunction(BulletController._ClaimMercHit, newcclosure(function(...)
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


-- // Networking silent seems to work over function hook silent. i wonder why, probably skill issue on my end
local _, targetHead = GetClosestHead()
print(targetHead:GetFullName(), (targetHead:GetPivot().Position - Players.LocalPlayer.Character:GetPivot().Position).Magnitude)
if not _G.CurrentBullet or _G.CurrentBullet <= BulletController._fireSeq then
    _G.CurrentBullet = BulletController._fireSeq + 1
end
local remote = BulletController._mercHitClaimRemote
remote:FireServer(
	"Rattler",
	Players:GetPlayerFromCharacter(targetHead.Parent).userId,
	"Head",
	targetHead.Position, -- target position
	(targetHead.Position - Players.LocalPlayer.Character:GetPivot().Position).Unit, -- lookangle
	Players.LocalPlayer.Character:GetPivot().Position, -- source position
	_G.CurrentBullet
    )
_G.CurrentBullet += 1

local function FindHighlight(Instance)
	local HighlightExists = false
	for _, child in Instance:GetChildren() do
		if child:IsA("Highlight") then HighlightExists = true;break end
	end
	return HighlightExists
end


-- // Aimbot
-- local Connection
-- Connection = RunService.RenderStepped:Connect(function()
--     local TargetHead = GetClosestHead()

-- 	-- // why does this not work lol
-- 	if not FindHighlight(TargetHead) then
-- 		print("Created highlight for:", TargetHead:GetFullName())
-- 		local Highlight = Instance.new("Highlight")
-- 		-- Highlight.Parent = game:GetService("CoreGui") -- // More stealthy, needs manual cleanup(?) cba to deal with allat rn
-- 		Highlight.Parent = TargetHead
-- 		Highlight.Adornee = TargetHead
-- 	end

-- 	local weapon = nil

--     for _, instance in workspace.Camera:GetChildren() do
--         if instance:IsA("Model") and instance.Name ~= "Headphones" then weapon = instance;break end
--     end

-- 	-- // this won't look pretty but it's "universal" across weapons UPDATE: scratch that for some reason it doesnt work on the pistol anyways..?
-- 	-- for _, part in weapon:GetChildren() do
-- 	-- 	if part:IsA("MeshPart") then
-- 	-- 		part.CFrame = CFrame.lookAt(part.CFrame.Position, TargetHead.Position)
-- 	-- 	end
-- 	-- end

-- 	--// only tested working with default gun
-- 	if weapon and weapon:FindFirstChild("gun") then -- fix edgecase for attempt to index nil with weapon
-- 		local gunMesh = weapon.gun
-- 		gunMesh.CFrame = CFrame.lookAt(gunMesh.CFrame.Position, TargetHead.Position)
-- 	end
-- end)
-- while _G.tick == _tick do task.wait() end
-- Connection:Disconnect()

--[[
// planned features:
custom tracers
aimbot wallcheck
aimbot modes (viewmodel cframe, ...?)
anti-aim (enemy aims at you, they get insta silent aimed)
triggerbot
]]
