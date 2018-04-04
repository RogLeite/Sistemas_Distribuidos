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
print("luarpc.threads = "..tostring(luarpc.threads))
luarpc.createServant(myobj1,"exinterface")
print("luarpc.threads = "..tostring(luarpc.threads))
for index,cli in pairs(luarpc.threads) do
	print("\tluarpc.threads["..tostring(index).."] = "..tostring(cli))
end
coroutine.resume(luarpc.threads[1])
for i=1,5000 do i=i end
print("tentei resume a thread")
coroutine.resume(luarpc.threads[1])
print("consegui resume a thread")
print("mas ela aparentemente n sai do accept()!")
