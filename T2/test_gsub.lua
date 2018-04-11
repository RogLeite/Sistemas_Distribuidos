local thesmile = "\\smile\\"
local a = "first par\n\tsecondpar"
local b = string.gsub(a,"\n",thesmile)
local c = string.gsub(b,thesmile,"\n")
print("a = "..a)
print("b = "..b)
print("c = "..c)
