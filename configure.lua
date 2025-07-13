print("----- Configuring -----")
print("----- Moving fs.lua -----")

os.execute("mv ./fslua/fslua.so ./fslua.so")
local fslua = require("fslua")

print("----- Building luacurl -----")

fslua.chdir("./luacurl")
os.execute("make")
os.execute("mv ./luacurl.so ../luacurl.so")
fslua.chdir("..")

print("----- luacurl Build Finished -----")
print("----- Configuration done -----")
