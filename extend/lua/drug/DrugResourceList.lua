-- Resource Generator V4.0


include("Rog_SaveUtils"); MY_MOD_NAME = "ÊÀ½çÇ¿È¨";
include("DrugResGenerator.lua");

if load(Players[Game.GetActivePlayer()],"Resources_Generation_Completed") ~= nil then
	if load(Players[Game.GetActivePlayer()],"Resources_Generation_Completed") == 1 then
		return;
	end
end

--------------------------------------------------------------
-- To disable the generation of a resource, comment out its line below:
-- To comment a line in Lua, add 2 dashes behind it

OnMapResourceGenerator("RESOURCE_BARLEY", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "TERRAIN_SNOW", "FEATURE_FOREST", "FEATURE_JUNGLE", "FEATURE_MARSH","FEATURE_RETBA",} );--´óÂó
OnMapResourceGenerator("RESOURCE_SANPEDRO", {"FEATURE_OASIS"});--Ê¥ÅåµÂÂÞ
OnMapResourceGenerator("RESOURCE_TEQUILA", {"FEATURE_OASIS"});--ÁúÉàÀ¼¾Æ
OnMapResourceGenerator("RESOURCE_TITANIUM", {"FEATURE_OASIS"});--îÑ
OnMapResourceGenerator("RESOURCE_FLAX", {"FEATURE_FOREST", "FEATURE_JUNGLE", "FEATURE_OASIS"});--ÑÇÂé
OnMapResourceGenerator("RESOURCE_LUMBER", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "TERRAIN_SNOW"} );--Ä¾²Ä
OnMapResourceGenerator("RESOURCE_RASPBERRYZ", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "TERRAIN_SNOW"} );--½¬¹û
OnMapResourceGenerator("RESOURCE_SAFFRON", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "FEATURE_OASIS","TERRAIN_SNOW"} );--²Øºì»¨
OnMapResourceGenerator("RESOURCE_SULFUR", {"FEATURE_OASIS"});--Áò»Ç
OnMapResourceGenerator("RESOURCE_TIN", {"FEATURE_OASIS"});--ÏõÊ¯
OnMapResourceGenerator("RESOURCE_LAVENDER", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "TERRAIN_SNOW", "FEATURE_FOREST", "FEATURE_JUNGLE", "FEATURE_MARSH"} );--Þ¹ÒÂ²Ý




--------------------------------------------------------------

save(Players[Game.GetActivePlayer()],"Resources_Generation_Completed",1);