local luarpc = require "luarpc"
function corr1()
	print("\t\tcorr1")
end
function corr2()
	
	print("\t\tcorr2")
	corroutine.yield(true)
	print("\t\tcorr2")
end

luarpc.waitIncoming()
