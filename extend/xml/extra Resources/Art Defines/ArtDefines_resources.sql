-- Insert SQL Rules Here 
-- Ä¾²Ä
INSERT INTO ArtDefine_Landmarks (Era,				State,						Scale,	ImprovementType,							LayoutHandler,			ResourceType,							Model,															TerrainContour) VALUES												
								('Any',				'Any',						1,		'ART_DEF_IMPROVEMENT_NONE',					'SNAPSHOT',				'ART_DEF_RESOURCE_LUMBER',				'Lumbertrees.fxsxml',								1),
								('Ancient',			'Constructed',				0.95,	'ART_DEF_IMPROVEMENT_LUMBERMILL',			'SNAPSHOT',				'ART_DEF_RESOURCE_LUMBER',				'Lumbermill_MID_Lumbertrees.fxsxml',					1),
								('Ancient',			'UnderConstruction',		0.95,	'ART_DEF_IMPROVEMENT_LUMBERMILL',			'SNAPSHOT',				'ART_DEF_RESOURCE_LUMBER',				'Lumbermill_MID_Lumbertrees_HB.fxsxml',				1),
								('Ancient',			'Pillaged',					0.5,	'ART_DEF_IMPROVEMENT_LUMBERMILL',			'SNAPSHOT',				'ART_DEF_RESOURCE_LUMBER',				'Lumbermill_MID_Lumbertrees_PIL.fxsxml',				1);

INSERT INTO ArtDefine_LandmarkTypes (Type,										LandmarkType,	FriendlyName) VALUES								
									('ART_DEF_RESOURCE_LUMBER',					'Resource',		'Lumber');

INSERT INTO ArtDefine_StrategicView (StrategicViewType,				TileType,			Asset) Values
									('ART_DEF_RESOURCE_LUMBER',		'Resource',			'sv_lumber.dds');




-------------------------------------îÑ-------------------------------------------------------
INSERT INTO ArtDefine_StrategicView (StrategicViewType,				TileType,			Asset) Values
                                    ('ART_DEF_RESOURCE_TITANIUM',	'Resource',			'sv_titanium.dds');


				
INSERT INTO ArtDefine_LandmarkTypes (Type,										LandmarkType,	FriendlyName) VALUES
                                     ('ART_DEF_RESOURCE_TITANIUM',				'Resource',		'Titanium'),
	                                 ('ART_DEF_RESOURCE_TITANIUM_HEAVY',		'Resource',		'Titanium Heavy');		
								

INSERT INTO ArtDefine_Landmarks (Era,				State,						Scale,		ImprovementType,							LayoutHandler,			ResourceType,								Model,                                                  TerrainContour) VALUES
								
                                ('Ancient',			'UnderConstruction',		1.1,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',				'hb_med_mine_titanium.fxsxml',						1),
								('Ancient',			'Constructed',				1.1,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',				'med_mine_titanium.fxsxml',						1),
								('Ancient',			'Pillaged',					1.1,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',				'pl_med_mine_titanium.fxsxml',						1),
								('Industrial',		'UnderConstruction',		1.1,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',				'hb_ind_mine_titanium.fxsxml',						1),
								('Industrial',		'Constructed',				1.1,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',				'ind_mine_titanium.fxsxml',						1),
								('Industrial',		'Pillaged',					1.1,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',				'pl_ind_mine_titanium.fxsxml',						1),
								('Any',				'Any',						1.1,		'ART_DEF_IMPROVEMENT_NONE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',				'titanium.fxsxml',									1),
								
								('Ancient',			'UnderConstruction',		1.1,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM_HEAVY',			'hb_med_mine_titanium_heavy.fxsxml',				1),
								('Ancient',			'Constructed',				1.1,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM_HEAVY',			'med_mine_titanium_heavy.fxsxml',					1),
								('Ancient',			'Pillaged',					1.1,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM_HEAVY',			'pl_med_mine_titanium_heavy.fxsxml',				1),
								('Industrial',		'UnderConstruction',		1.1,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM_HEAVY',			'hb_ind_mine_titanium_heavy.fxsxml',				1),
								('Industrial',		'Constructed',				1.1,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM_HEAVY',			'ind_mine_titanium_heavy.fxsxml',					1),
								('Industrial',		'Pillaged',					1.1,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM_HEAVY',			'pl_ind_mine_titanium_heavy.fxsxml',				1),
								('Any',				'Any',						1.1,		'ART_DEF_IMPROVEMENT_NONE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM_HEAVY',			'titanium_heavy.fxsxml',							1);
																									
				
		
-------------------------------------ÏõÊ¯-------------------------------------------------------

INSERT INTO ArtDefine_StrategicView (StrategicViewType,				TileType,			Asset) Values
									('ART_DEF_RESOURCE_TIN',		'Resource',	'sv_new_resource.dds');


INSERT INTO ArtDefine_LandmarkTypes (Type,										LandmarkType,	FriendlyName) VALUES			
									('ART_DEF_RESOURCE_TIN',				'Resource',		'Tin');

INSERT INTO ArtDefine_Landmarks (Era,				State,						Scale,		ImprovementType,							LayoutHandler,			ResourceType,								Model,								TerrainContour) VALUES									
			                    ('Any',				'Any',						1,		'ART_DEF_IMPROVEMENT_NONE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TIN',		                 'Tin.fxsxml',									1),
								('Ancient',			'UnderConstruction',		1,		'ART_DEF_IMPROVEMENT_QUARRY',				'SNAPSHOT',				'ART_DEF_RESOURCE_TIN',		                   'HB_Anc_Tin_Quarry.fxsxml',						1),
								('Ancient',			'Constructed',				1,		'ART_DEF_IMPROVEMENT_QUARRY',				'SNAPSHOT',				'ART_DEF_RESOURCE_TIN',		                   'Anc_Tin_Quarry.fxsxml',							1),
								('Ancient',			'Pillaged',					1,		'ART_DEF_IMPROVEMENT_QUARRY',				'SNAPSHOT',				'ART_DEF_RESOURCE_TIN',		                  'PL_Anc_Tin_Quarry.fxsxml',						1),
								('Industrial',		'UnderConstruction',		1,		'ART_DEF_IMPROVEMENT_QUARRY',				'SNAPSHOT',				'ART_DEF_RESOURCE_TIN',		                      'HB_IND_Tin_Quarry.fxsxml',						1),
								('Industrial',		'Constructed',				1,		'ART_DEF_IMPROVEMENT_QUARRY',				'SNAPSHOT',				'ART_DEF_RESOURCE_TIN',		                     'IND_Tin_Quarry.fxsxml',							1),
								('Industrial',		'Pillaged',					1,		'ART_DEF_IMPROVEMENT_QUARRY',				'SNAPSHOT',				'ART_DEF_RESOURCE_TIN',		                     'PL_IND_Tin_Quarry.fxsxml',						1);



-------------------------------------Áò»Ç-------------------------------------------------------

INSERT INTO ArtDefine_StrategicView (StrategicViewType,				TileType,			Asset) Values
									('ART_DEF_RESOURCE_SULFUR',		'Resource',	'sv_new_resource.dds');


INSERT INTO ArtDefine_LandmarkTypes (Type,										LandmarkType,	FriendlyName) VALUES			
									('ART_DEF_RESOURCE_SULFUR',				'Resource',		'Sulfur');

INSERT INTO ArtDefine_Landmarks (Era,				State,						Scale,		ImprovementType,							LayoutHandler,			ResourceType,								Model,															TerrainContour) VALUES									
			                    ('Any',				'Any',						1,		'ART_DEF_IMPROVEMENT_NONE',					'SNAPSHOT',				'ART_DEF_RESOURCE_SULFUR',		                 'Sulfur.fxsxml',									1),
								('Ancient',			'UnderConstruction',		1,		'ART_DEF_IMPROVEMENT_QUARRY',				'SNAPSHOT',				'ART_DEF_RESOURCE_SULFUR',		                   'HB_Anc_Sulfur_Quarry.fxsxml',						1),
								('Ancient',			'Constructed',				1,		'ART_DEF_IMPROVEMENT_QUARRY',				'SNAPSHOT',				'ART_DEF_RESOURCE_SULFUR',		                   'Anc_Sulfur_Quarry.fxsxml',							1),
								('Ancient',			'Pillaged',					1,		'ART_DEF_IMPROVEMENT_QUARRY',				'SNAPSHOT',				'ART_DEF_RESOURCE_SULFUR',		                  'PL_Anc_Sulfur_Quarry.fxsxml',						1),
								('Industrial',		'UnderConstruction',		1,		'ART_DEF_IMPROVEMENT_QUARRY',				'SNAPSHOT',				'ART_DEF_RESOURCE_SULFUR',		                      'HB_IND_Sulfur_Quarry.fxsxml',						1),
								('Industrial',		'Constructed',				1,		'ART_DEF_IMPROVEMENT_QUARRY',				'SNAPSHOT',				'ART_DEF_RESOURCE_SULFUR',		                     'IND_Sulfur_Quarry.fxsxml',							1),
								('Industrial',		'Pillaged',					1,		'ART_DEF_IMPROVEMENT_QUARRY',				'SNAPSHOT',				'ART_DEF_RESOURCE_SULFUR',		                     'PL_IND_Sulfur_Quarry.fxsxml',						1);





-------------------------------------ÑÇÂé-------------------------------------------------------
INSERT INTO ArtDefine_StrategicView (StrategicViewType,				TileType,			Asset) Values
									('ART_DEF_RESOURCE_FLAX',		'Resource',			'SV_Flax.dds');

INSERT INTO ArtDefine_LandmarkTypes (Type,										LandmarkType,			FriendlyName) VALUES
                                   ('ART_DEF_RESOURCE_RASPBERRY',				'Resource',				'Raspberries'),
									('ART_DEF_RESOURCE_FLAX',					'Resource',				'Flax');





INSERT INTO ArtDefine_Landmarks (Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour, Tech) 
VALUES ('Any','Any','0.9800000190734863','ART_DEF_IMPROVEMENT_NONE','SNAPSHOT','ART_DEF_RESOURCE_RASPBERRY','Resource_Raspberries.fxsxml','1',null);

INSERT INTO ArtDefine_Landmarks (Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour, Tech) 
VALUES ('Ancient','UnderConstruction','0.9599999785423279','ART_DEF_IMPROVEMENT_PLANTATION','SNAPSHOT','ART_DEF_RESOURCE_RASPBERRY','HB_Plantation_MID_Raspberries.fxsxml','1',null);

INSERT INTO ArtDefine_Landmarks (Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour, Tech) 
VALUES ('Ancient','Constructed','0.9599999785423279','ART_DEF_IMPROVEMENT_PLANTATION','SNAPSHOT','ART_DEF_RESOURCE_RASPBERRY','Plantation_MID_Raspberries.fxsxml','1',null);

INSERT INTO ArtDefine_Landmarks (Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour, Tech) 
VALUES ('Ancient','Pillaged','0.9599999785423279','ART_DEF_IMPROVEMENT_PLANTATION','SNAPSHOT','ART_DEF_RESOURCE_RASPBERRY','PL_Plantation_MID_Raspberries.fxsxml','1',null);

INSERT INTO ArtDefine_Landmarks (Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour, Tech) 
VALUES ('Industrial','UnderConstruction','0.9599999785423279','ART_DEF_IMPROVEMENT_PLANTATION','SNAPSHOT','ART_DEF_RESOURCE_RASPBERRY','HB_Plantation_IND_Raspberries.fxsxml','1',null);

INSERT INTO ArtDefine_Landmarks (Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour, Tech) 
VALUES ('Industrial','Constructed','0.9599999785423279','ART_DEF_IMPROVEMENT_PLANTATION','SNAPSHOT','ART_DEF_RESOURCE_RASPBERRY','Plantation_IND_Raspberries.fxsxml','1',null);

INSERT INTO ArtDefine_Landmarks (Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour, Tech) 
VALUES ('Industrial','Pillaged','0.9599999785423279','ART_DEF_IMPROVEMENT_PLANTATION','SNAPSHOT','ART_DEF_RESOURCE_RASPBERRY','PL_Plantation_IND_Raspberries.fxsxml','1',null);




INSERT INTO ArtDefine_Landmarks (Era,				State,						Scale,	ImprovementType,							LayoutHandler,			ResourceType,							Model,													TerrainContour) VALUES								
								('Any',				'Any',						0.875,	'ART_DEF_IMPROVEMENT_NONE',					'SNAPSHOT',				'ART_DEF_RESOURCE_FLAX',				'Resource_Flax.fxsxml',						1),
								('Industrial',		'Constructed',				0.875,	'ART_DEF_IMPROVEMENT_PLANTATION',			'SNAPSHOT',				'ART_DEF_RESOURCE_FLAX',				'Plantation_IND_Flax.fxsxml',					1),
								('Industrial',		'UnderConstruction',		0.875,	'ART_DEF_IMPROVEMENT_PLANTATION',			'SNAPSHOT',				'ART_DEF_RESOURCE_FLAX',				'HB_Plantation_IND_Flax.fxsxml',				1),
								('Industrial',		'Pillaged',					0.875,	'ART_DEF_IMPROVEMENT_PLANTATION',			'SNAPSHOT',				'ART_DEF_RESOURCE_FLAX',				'PL_Plantation_IND_Flax.fxsxml',				1),
								('Ancient',			'Constructed',				0.875,	'ART_DEF_IMPROVEMENT_PLANTATION',			'SNAPSHOT',				'ART_DEF_RESOURCE_FLAX',				'Plantation_MID_Flax.fxsxml',					1),
								('Ancient',			'UnderConstruction',		0.875,	'ART_DEF_IMPROVEMENT_PLANTATION',			'SNAPSHOT',				'ART_DEF_RESOURCE_FLAX',				'HB_Plantation_MID_Flax.fxsxml',				1),
								('Ancient',			'Pillaged',					0.875,	'ART_DEF_IMPROVEMENT_PLANTATION',			'SNAPSHOT',				'ART_DEF_RESOURCE_FLAX',				'PL_Plantation_MID_Flax.fxsxml',				1);
	








	-------------------------------------Þ¹ÒÂ²Ý-------------------------------------------------------
INSERT INTO ArtDefine_StrategicView (StrategicViewType,				TileType,			Asset) Values                                                                                                           
									('ART_DEF_RESOURCE_LAVENDER',	'Resource',			'sv_Lavender.dds');

INSERT INTO ArtDefine_LandmarkTypes (Type,										LandmarkType,			FriendlyName) VALUES                                                                                                           
                                    ('ART_DEF_RESOURCE_RASPBERRY',				'Resource',				'Raspberries'),
									('ART_DEF_RESOURCE_LAVENDER',				'Resource',				'Lavender');


INSERT INTO ArtDefine_Landmarks (Era,				State,						Scale,	ImprovementType,							LayoutHandler,			ResourceType,							Model,													TerrainContour) VALUES                                                                                                   
                                 ('Any',				'Any',				0.875,	'ART_DEF_IMPROVEMENT_NONE',					    'SNAPSHOT',				'ART_DEF_RESOURCE_LAVENDER',			'Resource_Lavender.fxsxml',				1),
								('Industrial',		'Constructed',				0.875,	'ART_DEF_IMPROVEMENT_PLANTATION',			'SNAPSHOT',				'ART_DEF_RESOURCE_LAVENDER',			'Plantation_IND_Lavender.fxsxml',			1),
								('Industrial',		'UnderConstruction',		0.875,	'ART_DEF_IMPROVEMENT_PLANTATION',			'SNAPSHOT',				'ART_DEF_RESOURCE_LAVENDER',			'HB_Plantation_IND_Lavender.fxsxml',		1),
								('Industrial',		'Pillaged',					0.875,	'ART_DEF_IMPROVEMENT_PLANTATION',			'SNAPSHOT',				'ART_DEF_RESOURCE_LAVENDER',			'PL_Plantation_IND_Lavender.fxsxml',		1),
								('Ancient',			'Constructed',				0.875,	'ART_DEF_IMPROVEMENT_PLANTATION',			'SNAPSHOT',				'ART_DEF_RESOURCE_LAVENDER',			'Plantation_MID_Lavender.fxsxml',			1),
								('Ancient',			'UnderConstruction',		0.875,	'ART_DEF_IMPROVEMENT_PLANTATION',			'SNAPSHOT',				'ART_DEF_RESOURCE_LAVENDER',			'HB_Plantation_MID_Lavender.fxsxml',		1),
								('Ancient',			'Pillaged',					0.875,	'ART_DEF_IMPROVEMENT_PLANTATION',			'SNAPSHOT',				'ART_DEF_RESOURCE_LAVENDER',			'PL_Plantation_MID_Lavender.fxsxml',		1);
	

	-------------------------------------´óÂó-------------------------------------------------------
INSERT INTO ArtDefine_StrategicView (StrategicViewType,				TileType,			Asset) Values
('ART_DEF_RESOURCE_BARLEY',		'Resource',			'SV_Barley.dds');

INSERT INTO ArtDefine_LandmarkTypes (Type,										LandmarkType,			FriendlyName) VALUES
('ART_DEF_RESOURCE_BARLEY',					'Resource',				'Barley');

INSERT INTO ArtDefine_Landmarks (Era,				State,						Scale,	ImprovementType,							LayoutHandler,			ResourceType,							Model,													TerrainContour) VALUES								
	                            ('Any',				'Any',						0.825,		'ART_DEF_IMPROVEMENT_NONE',					        'SNAPSHOT',				'ART_DEF_RESOURCE_BARLEY',				'Resource_Barley.fxsxml',				1),
								('Industrial',		'Constructed',				0.825,		'ART_DEF_IMPROVEMENT_PLANTATION',					'SNAPSHOT',				'ART_DEF_RESOURCE_BARLEY',				'Plantation_IND_Barley.fxsxml',			1),
								('Industrial',		'UnderConstruction',		0.825,		'ART_DEF_IMPROVEMENT_PLANTATION',					'SNAPSHOT',				'ART_DEF_RESOURCE_BARLEY',				'HB_Plantation_IND_Barley.fxsxml',		1),
								('Industrial',		'Pillaged',					0.825,		'ART_DEF_IMPROVEMENT_PLANTATION',					'SNAPSHOT',				'ART_DEF_RESOURCE_BARLEY',				'PL_Plantation_IND_Barley.fxsxml',		1),
								('Ancient',			'Constructed',				0.825,		'ART_DEF_IMPROVEMENT_PLANTATION',					'SNAPSHOT',				'ART_DEF_RESOURCE_BARLEY',				'Plantation_MID_Barley.fxsxml',			1),
								('Ancient',			'UnderConstruction',		0.825,		'ART_DEF_IMPROVEMENT_PLANTATION',					'SNAPSHOT',				'ART_DEF_RESOURCE_BARLEY',				'HB_Plantation_MID_Barley.fxsxml',		1),
								('Ancient',			'Pillaged',					0.825,		'ART_DEF_IMPROVEMENT_PLANTATION',					'SNAPSHOT',				'ART_DEF_RESOURCE_BARLEY',				'PL_Plantation_MID_Barley.fxsxml',		1);









INSERT INTO IconTextureAtlases
	(Atlas, IconSize, Filename, IconsPerRow, IconsPerColumn)
VALUES
	('DRUGS_NEW_ATLAS', 256, 'Drugs256.dds', 3, 3),
	('DRUGS_NEW_ATLAS', 128, 'Drugs128.dds', 3, 3),
	('DRUGS_NEW_ATLAS', 80, 'Drugs80.dds', 3, 3),
	('DRUGS_NEW_ATLAS', 64, 'Drugs64.dds', 3, 3),
	('DRUGS_NEW_ATLAS', 48, 'Drugs48.dds', 3, 3),
	('DRUGS_NEW_ATLAS', 45, 'Drugs45.dds', 3, 3);

INSERT INTO IconFontTextures
	(IconFontTexture, IconFontTextureFile)
VALUES
	('ICON_FONT_TEXTURE_DRUGZ', 'Drugs_FontIcons');

INSERT INTO IconFontMapping
	(IconName, IconFontTexture, IconMapping)
VALUES
	('ICON_RES_SANPEDRO', 'ICON_FONT_TEXTURE_DRUGZ', 6),
	('ICON_RES_TEQUILA', 'ICON_FONT_TEXTURE_DRUGZ', 7);

INSERT INTO ArtDefine_Landmarks
	(Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour)
VALUES
	--cactus
	('Any', 'Any', 0.9399999976158142, 'ART_DEF_IMPROVEMENT_NONE', 'SNAPSHOT', 'ART_DEF_RESOURCE_SANPEDRO', 'resource_drug_peyote.fxsxml', 1),
	('Ancient', 'UnderConstruction', 1, 'ART_DEF_IMPROVEMENT_PLANTATION', 'SNAPSHOT', 'ART_DEF_RESOURCE_SANPEDRO', 'hb_plantation_mid_drug_peyote.fxsxml', 1),
	('Industrial', 'UnderConstruction', 1, 'ART_DEF_IMPROVEMENT_PLANTATION', 'SNAPSHOT', 'ART_DEF_RESOURCE_SANPEDRO', 'hb_plantation_ind_drug_peyote.fxsxml', 1),
	('Ancient', 'Constructed', 1, 'ART_DEF_IMPROVEMENT_PLANTATION', 'SNAPSHOT', 'ART_DEF_RESOURCE_SANPEDRO', 'plantation_mid_drug_peyote.fxsxml', 1),
	('Industrial', 'Constructed', 1, 'ART_DEF_IMPROVEMENT_PLANTATION', 'SNAPSHOT', 'ART_DEF_RESOURCE_SANPEDRO', 'plantation_ind_drug_peyote.fxsxml', 1),
	('Ancient', 'Pillaged', 1, 'ART_DEF_IMPROVEMENT_PLANTATION', 'SNAPSHOT', 'ART_DEF_RESOURCE_SANPEDRO', 'pl_plantation_mid_drug_peyote.fxsxml', 1),
	('Industrial', 'Pillaged', 1, 'ART_DEF_IMPROVEMENT_PLANTATION', 'SNAPSHOT', 'ART_DEF_RESOURCE_SANPEDRO', 'pl_plantation_ind_drug_peyote.fxsxml', 1),
	--tequila
	('Any', 'Any', 0.9399999976158142, 'ART_DEF_IMPROVEMENT_NONE', 'SNAPSHOT', 'ART_DEF_RESOURCE_TEQUILA', 'resource_drug_tequila.fxsxml', 1),
	('Ancient', 'UnderConstruction', 1, 'ART_DEF_IMPROVEMENT_PLANTATION', 'SNAPSHOT', 'ART_DEF_RESOURCE_TEQUILA', 'hb_plantation_mid_drug_tequila.fxsxml', 1),
	('Industrial', 'UnderConstruction', 1, 'ART_DEF_IMPROVEMENT_PLANTATION', 'SNAPSHOT', 'ART_DEF_RESOURCE_TEQUILA', 'hb_plantation_ind_drug_tequila.fxsxml', 1),
	('Ancient', 'Constructed', 1, 'ART_DEF_IMPROVEMENT_PLANTATION', 'SNAPSHOT', 'ART_DEF_RESOURCE_TEQUILA', 'plantation_mid_drug_tequila.fxsxml', 1),
	('Industrial', 'Constructed', 1, 'ART_DEF_IMPROVEMENT_PLANTATION', 'SNAPSHOT', 'ART_DEF_RESOURCE_TEQUILA', 'plantation_ind_drug_tequila.fxsxml', 1),
	('Ancient', 'Pillaged', 1, 'ART_DEF_IMPROVEMENT_PLANTATION', 'SNAPSHOT', 'ART_DEF_RESOURCE_TEQUILA', 'pl_plantation_mid_drug_tequila.fxsxml', 1),
	('Industrial', 'Pillaged', 1, 'ART_DEF_IMPROVEMENT_PLANTATION', 'SNAPSHOT', 'ART_DEF_RESOURCE_TEQUILA', 'pl_plantation_ind_drug_tequila.fxsxml', 1);
	



INSERT INTO ArtDefine_LandmarkTypes
	(Type, LandmarkType, FriendlyName)
VALUES
	('ART_DEF_RESOURCE_SANPEDRO', 'Resource', 'San Pedro'),
	('ART_DEF_RESOURCE_TEQUILA', 'Resource', 'Tequila');

INSERT INTO ArtDefine_StrategicView
	(StrategicViewType, TileType, Asset)
VALUES
   ('ART_DEF_RESOURCE_SAFFRON', 'Resource', 'sv_Saffron.dds'),
	('ART_DEF_RESOURCE_SANPEDRO', 'Resource', 'sv_drug_peyote.dds'),
	('ART_DEF_RESOURCE_TEQUILA', 'Resource', 'sv_drug_tequila.dds');



INSERT INTO Resources
	(Type, Happiness, TechReveal,TechCityTrade, Description, Civilopedia, ResourceClassType, ArtDefineTag, AIObjective, PlacementOrder, ConstAppearance, MinAreaSize, MaxLatitude, RandApp1, RandApp2, Player, Flatlands, GroupRange, GroupRand, IconString, PortraitIndex, IconAtlas)
VALUES
	('RESOURCE_SANPEDRO', 2,     null ,		 'TECH_CALENDAR', 'TXT_KEY_RESOURCE_SANPEDRO', 'TXT_KEY_RESOURCE_SANPEDRO_PEDIA', 'RESOURCECLASS_LUXURY', 'ART_DEF_RESOURCE_SANPEDRO', 1, 3, 50, 3, 90, 25, 25, 67, 'true', 3, 15, '[ICON_RES_SANPEDRO]', 5, 'DRUGS_NEW_ATLAS'),
	('RESOURCE_TEQUILA',  2,     null ,	     'TECH_CALENDAR', 'TXT_KEY_RESOURCE_TEQUILA', 'TXT_KEY_RESOURCE_TEQUILA_PEDIA', 'RESOURCECLASS_LUXURY', 'ART_DEF_RESOURCE_TEQUILA', 1, 3, 50, 3, 90, 25, 25, 67, 'true', 3, 15, '[ICON_RES_TEQUILA]', 6, 'DRUGS_NEW_ATLAS');

INSERT INTO Resource_YieldChanges
	(ResourceType, YieldType, Yield)
VALUES
	('RESOURCE_SANPEDRO', 'YIELD_GOLD', 2),
	('RESOURCE_SANPEDRO', 'YIELD_PRODUCTION', 1),
	('RESOURCE_TEQUILA', 'YIELD_FOOD', 1),
	('RESOURCE_TEQUILA', 'YIELD_GOLD', 2);

INSERT INTO Resource_Flavors
	(ResourceType, FlavorType, Flavor)
VALUES
	('RESOURCE_SANPEDRO', 'FLAVOR_HAPPINESS', 10),
	('RESOURCE_TEQUILA', 'FLAVOR_HAPPINESS', 10);

INSERT INTO Resource_TerrainBooleans
	(ResourceType, TerrainType)
VALUES
	('RESOURCE_SANPEDRO', 'TERRAIN_DESERT'),
	('RESOURCE_TEQUILA', 'TERRAIN_DESERT');



INSERT INTO Improvement_ResourceTypes
	(ImprovementType, ResourceType)
VALUES
	('IMPROVEMENT_PLANTATION', 'RESOURCE_SANPEDRO'),
	('IMPROVEMENT_PLANTATION', 'RESOURCE_TEQUILA');

INSERT INTO Improvement_ResourceType_Yields
	(ImprovementType, ResourceType, YieldType, Yield)
VALUES
	('IMPROVEMENT_PLANTATION', 'RESOURCE_SANPEDRO', 'YIELD_GOLD', 2),
	('IMPROVEMENT_PLANTATION', 'RESOURCE_TEQUILA', 'YIELD_PRODUCTION', 1),
	('IMPROVEMENT_PLANTATION', 'RESOURCE_TEQUILA', 'YIELD_GOLD', 1);





--------------------------------------------------------------------------------------------------------------------------		
-- ArtDefine_LandmarkTypes
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO ArtDefine_LandmarkTypes 
		(Type,									LandmarkType,		FriendlyName) 
VALUES	('ART_DEF_RESOURCE_SAFFRON',		'Resource',			'Saffron');	

--------------------------------------------------------------------------------------------------------------------------
-- ArtDefine_Landmarks
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO ArtDefine_Landmarks 
		(Era,			State,					Scale,					ImprovementType,								LayoutHandler,	ResourceType,						Model,										TerrainContour, Tech)
VALUES	('Any',			'Any',					0.9399999976158142,		'ART_DEF_IMPROVEMENT_NONE',						'SNAPSHOT',		'ART_DEF_RESOURCE_SAFFRON',		'Resource_Saffron.fxsxml',					1,				null),
		('Ancient',		'UnderConstruction',	0.9599999785423279,		'ART_DEF_IMPROVEMENT_PLANTATION',				'SNAPSHOT',		'ART_DEF_RESOURCE_SAFFRON',		'HB_Plantation_MID_Saffron.fxsxml',			1,				null),
		('Ancient',		'Constructed',			0.9599999785423279,		'ART_DEF_IMPROVEMENT_PLANTATION',				'SNAPSHOT',		'ART_DEF_RESOURCE_SAFFRON',		'Plantation_MID_Saffron.fxsxml',			1,				null),
		('Ancient',		'Pillaged',				0.9599999785423279,		'ART_DEF_IMPROVEMENT_PLANTATION',				'SNAPSHOT',		'ART_DEF_RESOURCE_SAFFRON',		'PL_Plantation_MID_Saffron.fxsxml',			1,				null),
		('Industrial',	'UnderConstruction',	0.9599999785423279,		'ART_DEF_IMPROVEMENT_PLANTATION',				'SNAPSHOT',		'ART_DEF_RESOURCE_SAFFRON',		'HB_Plantation_IND_Saffron.fxsxml',			1,				null),
		('Industrial',	'Constructed',			0.9599999785423279,		'ART_DEF_IMPROVEMENT_PLANTATION',				'SNAPSHOT',		'ART_DEF_RESOURCE_SAFFRON',		'Plantation_IND_Saffron.fxsxml',			1,				null),
		('Industrial',	'Pillaged',				0.9599999785423279,		'ART_DEF_IMPROVEMENT_PLANTATION',				'SNAPSHOT',		'ART_DEF_RESOURCE_SAFFRON',		'PL_Plantation_IND_Saffron.fxsxml',			1,				null);	































									 	