local luarpc = require "luarpc"

local myobj1 = { foo = 
             function (a, b, s)
               return a+b, "alo\\n \n alo"
             end,
          boo = 
             function (n)
               return n
             end
        }
local function decode(tipo,valor)
	print("In decode:\n")
	print("valor = "..(valor or "hey, received nil"))
	if tipo == "char" or tipo == "string" then
		--troca thesmile por \n
		valor = "\""..string.gsub(valor,thesmile,"\n").."\""
		print("\ttipo == char ou string, valor decodificado = "..valor)
	elseif tipo == "double" then
		--converte a string para um número
		valor = tonumber(valor)
		print("\ttipo == double, valor decodificado = "..tostring(valor))
	end
	return valor or "\"nil\""
end
print("#####IN test_servant#######")
print("luarpc.threads = "..tostring(luarpc.threads))

print("#####ENDIN test_servant#######")
local info = luarpc.createServant(myobj1,"exinterface")

print("#####IN test_servant#######")
print("luarpc.threads = "..tostring(luarpc.threads))
for index,cli in pairs(luarpc.threads) do
	print("\tluarpc.threads["..tostring(index).."] = "..tostring(cli))
end

print("#####ENDIN test_servant#######")
coroutine.resume(luarpc.threads[1])

print("####IN test_servant#######")
--printa e conecta clients---------
local client = {}

for i=1,1 do
	client[i] = socket.connect(info.ip,info.port)
	print("client = "..tostring(client))
	client[i]:send("foo\n"..i.."\n"..i.."\n".."oi novo\n"..i.."\n")
end
--fim de printa e conecta clients---

print("#####ENDIN test_servant#######")
coroutine.resume(luarpc.threads[1])
print("#####IN test_servant#######")
for i=1,2 do
	print("client = "..tostring(client))
	print("-->client[1]:receive() = "..client[1]:receive())
end

print("#####ENDIN test_servant#######")
