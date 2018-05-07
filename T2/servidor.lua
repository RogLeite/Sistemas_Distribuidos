
local luarpc = require "luarpc"

myobj1 = { foo = 
             function (a, b, s)
               return a+b, "alo alo"
             end,
          boo = 
             function (n)
               return n
             end,
	coo = 
		function(s,c)
			return s, c
		end
        }
myobj2 = { foo = 
             function (a, b, s)
               return a-b, "tchau"
             end,
          boo = 
             function (n)
               return 1
             end,
          coo = 
		function(s,c)
			return s, c
		end

        }

-- vai para o estado passivo esperar chamadas:

local serv1 = luarpc.createServant(myobj1,"exinterface")
--local serv2 = luarpc.createServant(myobj2,"exinterface")
if serv1 then 
	print("Conecte o cliente no IP serv1"..(serv1.ip).." e porta: ---------------------------------------- " ..serv1.port)
else
	print("serv1 é nil!!")
end
--[[
if serv2 then 
	print("Conecte o cliente no IP serv2"..(serv2.ip).." e porta: ---------------------------------------- " ..serv2.port)
else
	print("serv2 é nil!!")
end
--]]
luarpc.waitIncoming()
