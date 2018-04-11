local returns = {"\"oi mica\"",10, 43.3, "\"subconciente é demais\""}
local returns_concat = table.concat(returns,", ")
local string_to_load = "return "..returns_concat
print("string_to_load = "..string_to_load)
local loaded = load(string_to_load)
print(loaded())
