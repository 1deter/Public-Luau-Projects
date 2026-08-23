local Players = cloneref(game:GetService("Players"))

local Player = Players.LocalPlayer

local sessionModule = loadstring(game:HttpGet("http://127.0.0.1:6969/sessionModule.luau"))()

sessionModule.new()

local connections = sessionModule.trackConnections()
local debugclock = os.clock()

task.spawn(function()
    while sessionModule.active do
        print("session is active!", debugclock)
        task.wait(2)
    end
end)

local conn = Player.Character.Humanoid.Animator.AnimationPlayed:Connect(function(animation)
    print("current session:", debugclock, ", new animation played:", animation)
end)
connections[conn] = true
