local hook = {}

local function recursion(data, depth, indent)
    if not depth then depth = 1 elseif depth < 1 then return end
    if not indent then indent = 0 end

    local padding = depth > 1 and string.rep("  ", indent) or ""

    -- // Maybe tostring key/value pairs before printing?
    for i, v in data do
        if typeof(v) == "table" then
            warn(padding .. i, v)
            recursion(v, depth - 1, indent + 1)
        else
            print(padding .. i, v)
        end
    end
end

function hook.getParams(targetFunction)
    if typeof(targetFunction) ~= "function" then return end

    local oldFunction
    oldFunction = hookfunction(targetFunction, newcclosure(function(...)
        local info = debug.getinfo(oldFunction)
        for i,v in info do print(i,v) end
        print("Target function was called. Printing parameters now:")
        print("\n")
        recursion({...}, 3)
        hookfunction(targetFunction, oldFunction)
        return oldFunction(...)
    end))
end

return hook
