
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

print("\n#####IN servidor.lua#######")
print("-->Cria serv1")
print("\n#####ENDIN servidor.lua#######")
local serv1 = luarpc.createServant(myobj1,"exinterface")
--local serv2 = luarpc.createServant(myobj2,"exinterface")
print("\n#####IN servidor.lua#######")
if serv1 then 
	print("Conecte o cliente no IP "..(serv1.ip).." e porta: ---------------------------------------- " ..serv1.port)
else
	print("serv1 é nil!!")
end


print("\n#####ENDIN servidor.lua#######")
luarpc.waitIncoming()
