local luarpc = require "luarpc"

local myobj1 = { foo = 
             function (a, b, s)
               return a+b, "alo alo"
             end,
          boo = 
             function (n)
               return n
             end
        }
print("luarpc.threads = "..tostring(luarpc.threads))
local info = luarpc.createServant(myobj1,"exinterface")
