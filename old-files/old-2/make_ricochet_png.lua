
require "gd"

local VERSION = 1.0
local sourceImageFilename = "ricochet.png"

local sourceImage = gd.createFromPng(sourceImageFilename)

if sourceImage == nil then
	print("Unable to open (" .. sourceImageFilename .. ")")
	os.exit()
end

