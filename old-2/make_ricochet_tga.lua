
-- /// CONSTANTS ///

local VERSION = 1.0
local ERROR_OPEN_FAILED = 110

local sourceFile_name = "ricochet_tga.tga"
local destFile_img_name = "ricochet_tga.rle"
local destFile_pal_name = "ricochet_tga.pal"



-- start

print("Source TGA: " .. sourceFile_name)
print("Output image data: " .. destFile_img_name)
print("Output palette data: " .. destFile_pal_name)



-- open input and output files

sourceFile_handle = io.open(sourceFile_name, "rb")

if sourceFile_handle == nil then
	print("ERROR: could not open source file '" .. sourceFile_name .. "'")
	os.exit(ERROR_OPEN_FAILED)
end

destFile_img_handle = io.open(destFile_img_name, "wb")

if destFile_img_handle == nil then
	print("ERROR: could not open destination file '" .. destFile_img_name .. "'")
	os.exit(ERROR_OPEN_FAILED)
end

destFile_pal_handle = io.open(destFile_pal_name, "wb")

if destFile_pal_handle == nil then
	print("ERROR: could not open destination file '" .. destFile_pal_name .. "'")
	os.exit(ERROR_OPEN_FAILED)
end



-- extract header information

local header = {} -- 18 bytes

local imageIdSize
local colorMapSize

for i=1, 18 do
	header[i] = sourceFile_handle:read(1)
end

imageIdSize = header[1]
	print("imageIdSize = " .. imageIdSize)
	
if header[2] ~= 0 then
	print("ERROR: input file has a color map")
	os.exit()
end

if header[3] ~= 2 then
	print("ERROR: input file is not an uncompressed true-color image")
	os.exit()
end

-- for i=1, #header do
--	destFile_img_handle:write(header[i])
-- end

sourceFile_handle:close()
destFile_img_handle:close()
destFile_pal_handle:close()