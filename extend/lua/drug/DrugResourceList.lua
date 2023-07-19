-- Resource Generator V4.0


--------------------------------------------------------------

--include( "DrugSaveUtils" ); MY_MOD_NAME = "世界强权";
include( "Rog_SaveUtils" ); MY_MOD_NAME = "世界强权";
include("DrugResGenerator.lua");

if load(Players[Game.GetActivePlayer()],"Resources_Generation_Completed") ~= nil then
	if load(Players[Game.GetActivePlayer()],"Resources_Generation_Completed") == 1 then
		return;
	end
end

--------------------------------------------------------------
-- To disable the generation of a resource, comment out its line below:
-- To comment a line in Lua, add 2 dashes behind it

OnMapResourceGenerator("RESOURCE_BARLEY", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "TERRAIN_SNOW", "FEATURE_FOREST", "FEATURE_JUNGLE", "FEATURE_MARSH","FEATURE_RETBA",} );--大麦
OnMapResourceGenerator("RESOURCE_SANPEDRO", {"FEATURE_OASIS"});--圣佩德罗
OnMapResourceGenerator("RESOURCE_TEQUILA", {"FEATURE_OASIS"});--龙舌兰酒
OnMapResourceGenerator("RESOURCE_TITANIUM", {"FEATURE_OASIS"});--钛
OnMapResourceGenerator("RESOURCE_FLAX", {"FEATURE_FOREST", "FEATURE_JUNGLE", "FEATURE_OASIS"});--亚麻
OnMapResourceGenerator("RESOURCE_LUMBER", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "TERRAIN_SNOW"} );--木材
OnMapResourceGenerator("RESOURCE_RASPBERRYZ", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "TERRAIN_SNOW"} );--浆果
OnMapResourceGenerator("RESOURCE_SAFFRON", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "FEATURE_OASIS","TERRAIN_SNOW"} );--藏红花
OnMapResourceGenerator("RESOURCE_SULFUR", {"FEATURE_OASIS"});--硫磺
OnMapResourceGenerator("RESOURCE_TIN", {"FEATURE_OASIS"});--硝石
OnMapResourceGenerator("RESOURCE_LAVENDER", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "TERRAIN_SNOW", "FEATURE_FOREST", "FEATURE_JUNGLE", "FEATURE_MARSH"} );--薰衣草




--------------------------------------------------------------

save(Players[Game.GetActivePlayer()],"Resources_Generation_Completed",1);