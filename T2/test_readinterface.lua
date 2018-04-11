local ri = require "readinterface"
local msg = "foo"
print("ri = "..tostring(ri or nil))
t = ri.readinterface("exinterface")
print("t = "..tostring(t or nil))
print("t.methods.foo.resulttype = "..tostring(t.methods.foo.resulttype or nil))
print("t.methods[msg].resulttype = "..tostring(t.methods[msg].resulttype or nil))
for i,n in pairs(t.methods[msg].args) do
	print("\tt.methods[msg].args["..tostring(i).."] = "..tostring(n))
end
for i,n in pairs(t.methods) do
	print("\tt["..tostring(i).."]"..tostring(n))
end
