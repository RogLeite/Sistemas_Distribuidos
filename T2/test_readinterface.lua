local ri = require "readinterface"
print("ri = "..tostring(ri or nil))
ri.readinterface("exinterface")
print("ri.t = "..tostring(ri.t or nil))
print("ri.t.methods.foo.resulttype = "..tostring(ri.t.methods.foo.resulttype or nil))
for i,n in pairs(ri.t.methods) do
	print("ri["..tostring(i).."]"..tostring(n))
end

