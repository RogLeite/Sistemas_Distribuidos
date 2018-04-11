local object = { foo = 
             function (a, b, s)
               return a+b, "alo alo"
             end,
          boo = 
             function (n)
               return n
             end
        }
local funcname = "foo"
local params = {1,2,"hi"}

--trecho testado--------------------------
local params_concat = table.concat(params,", ")
local l_foo = load("local obj,funcname = ... return {obj[funcname]("..params_concat..")}")
local returns = l_foo(object,funcname)
--------------------------------------------------------

print("l_foo = "..tostring(l_foo))
print("l_foo(object,funcname) = "..tostring(l_foo(object,funcname)))
print("returns = l_foo(object,funcname)")
for i,n in pairs(returns) do
	print("\treturns["..tostring(i).."] = "..tostring(n))
end

--[[
local my_foo = load("local arg = ... return arg.object.foo("..table.concat({1,2,"hi"},", ")..")")
print("my_foo = "..tostring(my_foo))
print("my_foo(_ENV) = "..tostring(my_foo(_ENV)))
--]]
