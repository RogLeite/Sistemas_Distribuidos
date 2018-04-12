local thesmile = "\\:-)\\"
local unsmile = "\\%:%-%)\\"
local a = "first par\n\tsecondpar"
print("a = "..a)
local b = string.gsub(a,"\n",thesmile)
print("b = "..b)
local c = string.gsub(b,unsmile,"\n")
print("c = "..c)
