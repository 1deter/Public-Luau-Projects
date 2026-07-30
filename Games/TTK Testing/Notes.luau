-- // No hit
-- local args = {
-- 	"Rattler",
-- 	vector.create(305.0450744628906, -276.59716796875, 160.51736450195312), -- source position
-- 	vector.create(0.998881459236145, -0.04705840349197388, 0.004627371672540903) -- lookangle
-- }
-- game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("WeaponFired"):FireServer(unpack(args))

-- // Hit
-- local args = {
-- 	"Rattler",
-- 	2788446725,
-- 	"LeftLowerArm",
-- 	vector.create(322.0689697265625, -278.9442138671875, 160.64480590820312), -- target position
-- 	vector.create(0.992270827293396, -0.1239028349518776, 0.00683663971722126), -- lookangle
-- 	vector.create(305.0193786621094, -276.8152770996094, 160.52732849121094), -- source position
-- 	7
-- }
-- game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("MercHitClaim"):FireServer(unpack(args))

