-- Resource Generator V4.0


include("Rog_SaveUtils"); MY_MOD_NAME = "����ǿȨ";
include("DrugResGenerator.lua");

if load(Players[Game.GetActivePlayer()],"Resources_Generation_Completed") ~= nil then
	if load(Players[Game.GetActivePlayer()],"Resources_Generation_Completed") == 1 then
		return;
	end
end

--------------------------------------------------------------
-- To disable the generation of a resource, comment out its line below:
-- To comment a line in Lua, add 2 dashes behind it

OnMapResourceGenerator("RESOURCE_BARLEY", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "TERRAIN_SNOW", "FEATURE_FOREST", "FEATURE_JUNGLE", "FEATURE_MARSH","FEATURE_RETBA",} );--����
OnMapResourceGenerator("RESOURCE_SANPEDRO", {"FEATURE_OASIS"});--ʥ�����
OnMapResourceGenerator("RESOURCE_TEQUILA", {"FEATURE_OASIS"});--��������
OnMapResourceGenerator("RESOURCE_TITANIUM", {"FEATURE_OASIS"});--��
OnMapResourceGenerator("RESOURCE_FLAX", {"FEATURE_FOREST", "FEATURE_JUNGLE", "FEATURE_OASIS"});--����
OnMapResourceGenerator("RESOURCE_LUMBER", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "TERRAIN_SNOW"} );--ľ��
OnMapResourceGenerator("RESOURCE_RASPBERRYZ", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "TERRAIN_SNOW"} );--����
OnMapResourceGenerator("RESOURCE_SAFFRON", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "FEATURE_OASIS","TERRAIN_SNOW"} );--�غ컨
OnMapResourceGenerator("RESOURCE_SULFUR", {"FEATURE_OASIS"});--���
OnMapResourceGenerator("RESOURCE_TIN", {"FEATURE_OASIS"});--��ʯ
OnMapResourceGenerator("RESOURCE_LAVENDER", {"TERRAIN_DESERT", "TERRAIN_TUNDRA", "TERRAIN_SNOW", "FEATURE_FOREST", "FEATURE_JUNGLE", "FEATURE_MARSH"} );--޹�²�




--------------------------------------------------------------

save(Players[Game.GetActivePlayer()],"Resources_Generation_Completed",1);