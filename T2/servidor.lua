
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
serv1 = luarpc.createServant (myobj1, "exinterface")
serv2 = luarpc.createServant (myobj2, "exinterface")
-- usa as infos retornadas em serv1 e serv2 para divulgar contato 
-- (IP e porta) dos servidores
 print("Conecte o cliente no IP "..serv1.ip.." e porta: ---------------------------------------- " .. serv1.porta)


-- vai para o estado passivo esperar chamadas:

--luarpc.waitIncoming()

os.execute("sleep " .. tonumber(20))
coroutine.resume(luarpc.threads[1])

