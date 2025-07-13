print("----- Configuring -----")
print("----- Moving fs.lua -----")
os.execute("mv ./fslua/fslua.so ./fslua.so")
local fslua = require("fslua")

if not fslua.exists("./libs") then
	print("----- Adding libs Directory -----")
	local success, attemps = false, 0
	repeat
		success = fslua.writedir("./libs")
		attemps = attemps+1
		if attemps >= 5 and not success then
			print("----- Build Error: Max attemps rechead -----")
			os.exit(1)
		end
	until success
	print("----- libs Directory Added -----")
end

print("----- Building luacurl -----")
fslua.chdir("./luacurl")
os.execute("make")
os.execute("mv ./luacurl.so ../libs/luacurl.so")
fslua.chdir("..")
print("----- luacurl Build Finished -----")
print("----- Moving fs.lua -----")
os.execute("mv ./fslua.so ./libs/fslua.so")
print("----- Configuration done -----")
