local session = {}
session.active = false

local bindable = getgenv().sessionBindable
if not bindable then
    bindable = Instance.new("BindableEvent")
    getgenv().sessionBindable = bindable
end

function session.new()
    bindable:Fire()
    session.active = true
    bindable.Event:Once(function()
        session.active = false
    end)
end

function session.trackConnections()
    local connections = {}

    local metatable = {
        __mode = "k",
        __newindex = function(self, key, value)

            local connection = typeof(key) == "RBXScriptConnection" and key
            or typeof(value) == "RBXScriptConnection" and value
            or nil

            if connection then
                bindable.Event:Once(function()
                    if connection.Connected then
                        connection:Disconnect()
                    end
                    rawset(self, key, nil)
                end)
            end

            rawset(self, key, value)
        end
    }

    return setmetatable(connections, metatable)
end

return session