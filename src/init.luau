--!optimize 2
--!strict

-- Constants -- 
local MANGLED_NAME = "__mangled"

-- Types --
type FunctionName = string

-- Private -- 
--[[
Removes the value of MANGLED_NAME from the provided string.
This function does not test if MANGLED_NAME is a substring.
]]
local function deProtect(protectedString: string): string
    if string.match(protectedString, MANGLED_NAME) then
        return string.sub(protectedString, string.len(MANGLED_NAME) + 1, -1)
    end
    return protectedString
end

--[[
Protects the provided function with MANGLED_NAME
]]
local function protectFunction(class, key: string): (...any) -> (...any)
    return function(_self, ...)
        if class.__mangled__challengeBit then
            return class[MANGLED_NAME .. key](_self, ...)
        else
            warn(`[{script.Name}]: Cannot access protected function`)
        end
    end
end

--[[
Protocol used when calling a function in the protected class.
]]
local function funcitonProtocol(
    class, 
    func: (_self: any, ...any) -> (...any)
): (_self: any, ...any) -> (...any)
    return function(_self, ...)
        class.__mangled__challengBit = true

        -- unprotect non functions
        for key, value in pairs(class) do
            if typeof(value) ~= "function" then
                class[deProtect(key)] = class[key]
            end
        end

        local output = func(_self, ...)

        -- re protect non functions
        for key, value in pairs(class) do
            if typeof(value) ~= "function" then
                class[deProtect(key)] = nil
            end
        end

        class.__mangled__challengBit = false

        return output
    end
end

-- Public --

--[[
Mangles the provided class.
All keys in the class with `__` at the start will be mangled,
and subsequently protected.
]]
local function mangle<A>(class: A & {}): A
    if class == nil then
        error(`[{script.Name}] Must have class (table)`)
    elseif typeof(class) ~= "table" then
        error(`[{script.Name}] class must be of type table`)
    end

    for key, value in pairs(class) do
        if 
            not string.match(key, MANGLED_NAME) and
            string.match(key, "^__") and
            key ~= "__index"
        then

            -- protect "^__" functions
            if typeof(value) == "function" then
                class[MANGLED_NAME .. key] = value
                class[key] = protectFunction(class, key)

                continue
            end

            -- protect "^__" non functions
            if typeof(value) ~= "function" then
                class[MANGLED_NAME .. key] = value
                class[key] = nil

                continue
            end
        -- Potential bug. What about protected functions calling
        -- other protected functions?
        elseif key ~= "New" and typeof(key) == "function" then
            class[key] = funcitonProtocol(class, value)
        end
    end

    return class
end

return mangle