--!optimize 2
--!strict

-- Constants -- 

-- Dependencies --

-- Types --
type FunctionName = string

-- Private -- 

-- Public --

---- mangle class ----
-- local mangle = {}
-- mangle.__index = mangle

local function mangle<A>(class: A & {}): A
    for name, _function in pairs(class) do
        if string.match(name, "^__") then
            print("Match!")  
        end
    end

    return class
end

return mangle
