
local luarpc = require "luarpc"

myobj1 = { foo = 
             function (a, b, s)
               return a+b, "alo alo"
             end,
          boo = 
             function (n)
               return n
             end
        }
myobj2 = { foo = 
             function (a, b, s)
               return a-b, "tchau"
             end,
          boo = 
             function (n)
               return 1
             end
        }
-- cria servidores:

print("\n#####IN servidor.lua#######")
print("Cria dois servants")

print("\n#####ENDIN servidor.lua#######")
local serv1 = luarpc.createServant (myobj1, "exinterface")
local serv2 = luarpc.createServant (myobj2, "exinterface")
-- usa as infos retornadas em serv1 e serv2 para divulgar contato 
-- (IP e porta) dos servidores
---[=[
 print("Conecte o cliente no IP "..serv1.ip.." e porta: ---------------------------------------- " .. serv1.port)


-- vai para o estado passivo esperar chamadas:

--luarpc.waitIncoming()
print("\n#####IN servidor.lua#######")
print("repetidamente acorda o servant")

repeat
	print("----->acorda servant-------------")
	os.execute("sleep " .. tonumber(1))
	coroutine.resume(luarpc.threads[1])
	counter = counter + 1
until counter > 30

print("\n#####ENDIN servidor.lua#######")
--]=]

