local M = {}
M.t = {}
--print("t = "..tostring(t))
function interface(b)
	M.t = b
--[[
	print("b = "..tostring(b))
	print("t = "..tostring(t))
--]]
end

--[[
dofile("exinterface")
print("t = "..tostring(t))
--]]
--dofile("interface")
function M.readinterface(filename)
	dofile(filename)
end

return M
