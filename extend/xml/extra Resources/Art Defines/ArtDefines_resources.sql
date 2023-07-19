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
	                                 ('ART_DEF_RESOURCE_TITANIUM',				'Resource',		'Titanium');		
								

INSERT INTO ArtDefine_Landmarks (Era,				State,						Scale,		ImprovementType,							LayoutHandler,			ResourceType,								Model,                                                  TerrainContour) VALUES
								
                                ('Ancient',			'UnderConstruction',		0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',				'HB_MED_Mine_Titanium.fxsxml',						1),
								('Ancient',			'Constructed',				0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',				'MED_Mine_Titanium.fxsxml',						1),
								('Ancient',			'Pillaged',					0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',				'PL_MED_Mine_Titanium.fxsxml',						1),
								('Industrial',		'UnderConstruction',		0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',				'HB_IND_Mine_Titanium.fxsxml',						1),
								('Industrial',		'Constructed',				0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',				'IND_Mine_Titanium.fxsxml',						1),
								('Industrial',		'Pillaged',					0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',				'PL_IND_Mine_Titanium.fxsxml',						1),
								('Any',				'Any',						0.925,		'ART_DEF_IMPROVEMENT_NONE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',				'Titanium.fxsxml',									1),
								
								('Ancient',			'UnderConstruction',		0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',			'HB_MED_Mine_Titanium_Heavy.fxsxml',				1),
								('Ancient',			'Constructed',				0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',			'MED_Mine_Titanium_Heavy.fxsxml',					1),
								('Ancient',			'Pillaged',					0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',			'PL_MED_Mine_Titanium_Heavy.fxsxml',				1),
								('Industrial',		'UnderConstruction',		0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',			'HB_IND_Mine_Titanium_Heavy.fxsxml',				1),
								('Industrial',		'Constructed',				0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',			'IND_Mine_Titanium_Heavy.fxsxml',					1),
								('Industrial',		'Pillaged',					0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',			'PL_IND_Mine_Titanium_Heavy.fxsxml',				1),
								('Any',				'Any',						0.925,		'ART_DEF_IMPROVEMENT_NONE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',			'Titanium_Heavy.fxsxml',							1),
								
								('Ancient',			'UnderConstruction',		0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',	'HB_MED_Mine_Titanium_Heavy.fxsxml',				1),
								('Ancient',			'Constructed',				0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',	'MED_Mine_Titanium_Heavy.fxsxml',					1),
								('Ancient',			'Pillaged',					0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',	'PL_MED_Mine_Titanium_Heavy.fxsxml',				1),
								('Industrial',		'UnderConstruction',		0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',	'HB_IND_Mine_Titanium_Heavy.fxsxml',				1),
								('Industrial',		'Constructed',				0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',	'IND_Mine_Titanium_Heavy.fxsxml',					1),
								('Industrial',		'Pillaged',					0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',	'PL_IND_Mine_Titanium_Heavy.fxsxml',				1),
								('Any',				'Any',						0.925,		'ART_DEF_IMPROVEMENT_NONE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',	'Titanium_Heavy_marsh.fxsxml',						1),
								
								('Ancient',			'UnderConstruction',		0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',			'HB_MED_Mine_Titanium.fxsxml',						1),
								('Ancient',			'Constructed',				0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',			'MED_Mine_Titanium.fxsxml',						1),
								('Ancient',			'Pillaged',					0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',			'PL_MED_Mine_Titanium.fxsxml',						1),
								('Industrial',		'UnderConstruction',		0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',			'HB_IND_Mine_Titanium.fxsxml',						1),
								('Industrial',		'Constructed',				0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',			'IND_Mine_Titanium.fxsxml',						1),
								('Industrial',		'Pillaged',					0.925,		'ART_DEF_IMPROVEMENT_MINE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',			'PL_IND_Mine_Titanium.fxsxml',						1),
								('Any',				'Any',						0.925,		'ART_DEF_IMPROVEMENT_NONE',					'SNAPSHOT',				'ART_DEF_RESOURCE_TITANIUM',			'Titanium_marsh.fxsxml',							1);
																									
				
		
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





































									 	