<div align="center">

# mangle
**Narrator: "Was this ever asked for?"**\
*Also Narrator: "I don't think it was."*

[About](#about) |
[Reasoning](#reasoning) |
[Supported Platforms](#supported-platforms) |
[Use](#use)
</div>

## About
`mangle` is a post processing name mangler for `luau`, inspired by Python's [name mangler](https://docs.python.org/3/tutorial/classes.html#private-variables); what makes private variables private in Python.

## Reasoning
In most intro to programming courses, we learn of `public` and `private` classes. These concepts are less about security and more about managing complexity. If a `private` variable causes a bug, the developer only needs to look within the class that its located. 

## Supported Platforms
`mangle` may be posted on [Wally](https://wally.run). We understand the use case is minimal.

## Use
```luau
local mangle = require(--[[path to mangle]])

local someClass = {}
-- "public" variables and functions of someClass
-- "private" varaibles and functions using "__" in the start of their names.

reutrn mangle(someClass)
```

Calling `someClass.__someFunction` or `someClass.__someVariable` directly is not allowed and will fatally `error`. However, a function inside the `someClass` class can still call on `__someFunction` or `__someVariable` without problem.