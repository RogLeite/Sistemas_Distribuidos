local t = {}

--print("t = "..tostring(t))
function interface(b)
	t = b
--[[
	print("b = "..tostring(b))
	print("t = "..tostring(t))
--]]
end
---[[
dofile("exinterface")
print("t = "..tostring(t))
--]]
--dofile("interface")
return t
