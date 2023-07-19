-- Insert SQL Rules Here 
INSERT INTO Resources	(Type,					Description,							Civilopedia,								Help,										ResourceClassType,		ArtDefineTag,						AltArtDefineTag,					ArtDefineTagHeavy,					AltArtDefineTagHeavy,		TechReveal,						PolicyReveal,				TechCityTrade,					TechObsolete,		AIStopTradingEra,	Happiness,	WonderProductionMod,	WonderProductionModObsoleteEra, StartingResourceQuantity,	Normalize,		AITradeModifier,	AIObjective,	PlacementOrder, ConstAppearance,	MinAreaSize,	MinLatitude,	MaxLatitude,	RandApp1,	RandApp2,	RandApp3,	RandApp4,	Player, TilesPer,	MinLandPercent, GroupRange, GroupRand,	ResourceUsage,	PresentOnAllValidPlots, Area,	Hills,	Flatlands,	NoRiverSide,	OnlyMinorCivs,	IconString,						PortraitIndex,	IconAtlas) VALUES
                ('RESOURCE_LAVENDER',	'TXT_KEY_RESOURCE_LAVENDER',			'TXT_KEY_CIV5_RESOURCE_LAVENDER_TEXT',		        null,			'RESOURCECLASS_BONUS',			'ART_DEF_RESOURCE_LAVENDER',		null,								null,								null,					'TECH_NATURAL_MEDICINE',							null,				'TECH_NATURAL_MEDICINE',				null,				null,				0,			0,						null,							0,							0,				0,					0,				4,				50,					3,				0,				90,				25,			25,			0,			0,			0,		5,			0,				0,			0,			0,				0,						0,		1,		1,			0,				0,				'[ICON_RES_LAVENDER]',			13,				'NEW_RESOURCE_ATLAS'),
                ('RESOURCE_TITANIUM',	'TXT_KEY_RESOURCE_TITANIUM',			'TXT_KEY_CIV5_RESOURCE_TITANIUM_TEXT',		'TXT_KEY_RESOURCE_TITANIUM_HELP',			'RESOURCECLASS_MODERN',			'ART_DEF_RESOURCE_TITANIUM',		'ART_DEF_RESOURCE_TITANIUM_MARSH',	'ART_DEF_RESOURCE_TITANIUM_HEAVY',	null,						'TECH_SUBTERRANEAN_EXPLORE',			null,						'TECH_SUBTERRANEAN_EXPLORE',	null,				null,			    0,			0,						null,							0,							0,				20,					0,				4,				50,					3,				0,				90,				25,			25,			0,			0,			0,		5,			0,				0,			0,			1,				0,						0,		1,		1,			0,				0,				'[ICON_RES_TITANIUM]',			60,				'NEW_RESOURCE_ATLAS'),			
				('RESOURCE_FLAX',		'TXT_KEY_RESOURCE_FLAX',				'TXT_KEY_CIV5_RESOURCE_FLAX_TEXT',			         null,				'RESOURCECLASS_BONUS',			'ART_DEF_RESOURCE_FLAX',			null,								null,								null,						null,							null,						null,				null,				null,				0,			0,						null,							0,							0,				0,					0,				4,				50,					3,				0,				90,				25,			25,			0,			0,			0,		5,			0,				0,			0,			0,				0,						0,		1,		1,			0,				0,				'[ICON_RES_FLAX]',				35,				'NEW_RESOURCE_ATLAS'),		
				('RESOURCE_LUMBER',		'TXT_KEY_RESOURCE_OAK',					'TXT_KEY_CIV5_RESOURCE_OAK_TEXT',			'TXT_KEY_RESOURCE_OAK_HELP',				'RESOURCECLASS_MODERN',			'ART_DEF_RESOURCE_LUMBER',			null,					'ART_DEF_RESOURCE_LUMBER',			            null,						null,							null,				        'TECH_WOOD_WORKING',			null,				null,			    0,			0,						null,							0,			                0,				0,					20,				4,				50,					3,				0,				90,				25,			25,			0,			0,			0,		5,			0,				0,			0,			1,				0,						0,		1,	    1,		    0,	            0,	             '[ICON_RES_HARDWOOD]',			18,				'NEW_RESOURCE_ATLAS'),	
				('RESOURCE_RASPBERRYZ', 'TXT_KEY_RESOURCE_RASPBERRYZ',			'TXT_KEY_CIV5_RESOURCE_RASPBERRYZ_TEXT',	       null,			'RESOURCECLASS_LUXURY',         'ART_DEF_RESOURCE_RASPBERRY',       null,								null,								null,                       null,                           null,                        'TECH_CALENDAR',               null,               null,               2,			0,                      null,                           0,							0,	            0,					0,              3,              50,					3,              0,	            90,	            25,			25,			0,			0,			0,		5,			0,				0,			0,			0,				0,                      0,		0,		1,			0,				0,	            '[ICON_FRU_RASPBERRY]',          44,             'NEW_RESOURCE_ATLAS'),

				('RESOURCE_SAFFRON',      'TXT_KEY_RESOURCE_SAFFRON',			'TXT_KEY_CIV5_RESOURCE_SAFFRON_TEXT',	       null,			'RESOURCECLASS_LUXURY',         'ART_DEF_RESOURCE_SAFFRON',       null,								null,								null,                       'TECH_CALENDAR',                           null,                        'TECH_CALENDAR',               null,               null,               4,			0,                      null,                           0,							0,	            0,					0,              3,              50,					3,              0,	            90,	            25,			25,			0,			0,			0,		5,			0,				0,			0,			0,				0,                      0,		0,		1,			0,				0,	            '[ICON_RES_SAFFRON]',          41,             'NEW_RESOURCE_ATLAS'),


				('RESOURCE_TIN',	    'TXT_KEY_RESOURCE_TIN',			        'TXT_KEY_CIV5_RESOURCE_TIN_TEXT',		'TXT_KEY_RESOURCE_TIN_HELP',			'RESOURCECLASS_MODERN',			'ART_DEF_RESOURCE_TIN',		'ART_DEF_RESOURCE_TIN',	'ART_DEF_RESOURCE_TIN',	 null,					'TECH_MINING',			            null,						  'TECH_MINING',		        null,				null,				0,			0,						null,							0,							0,				20,					0,				4,				50,					3,				0,				90,				25,			25,			0,			0,			0,		5,			0,				0,			0,			1,				0,						0,		1,		1,			0,				0,				'[ICON_RES_TNT]',			     6,				'NEW_RESOURCE_ATLAS'),
				('RESOURCE_GUNPOWDER',	'TXT_KEY_RESOURCE_GUNPOWDER',			'TXT_KEY_CIV5_RESOURCE_GUNPOWDER_TEXT',		 null,			'RESOURCECLASS_MODERN',			    null,		                    null,	                            null,	                            null,					'TECH_CHEMISTRY',			        null,						'TECH_CHEMISTRY',		    	null,			  	null,				0,			0,						null,				            0,							0,				20,					0,				4,				50,					3,				0,				90,				25,			25,			0,			0,			0,		5,			0,				0,			0,			1,				0,						0,		1,		1,			0,				0,				'[ICON_RES_GUNPOWDER]',			39,				'NEW_RESOURCE_ATLAS'),
				('RESOURCE_SULFUR',	    'TXT_KEY_RESOURCE_SULFUR',		        'TXT_KEY_RESOURCE_SULFUR_TEXT',			     null,	            'RESOURCECLASS_LUXURY',	            'ART_DEF_RESOURCE_SULFUR',          null,								null, 	    		                null, 	                   'TECH_MINING',                   null,                        'TECH_MINING',                 null,               null,             	3,			0,	                    null,                           0,                          0,	            0,					0,              3,				50,					3,				0,				90,	            25,			25,			0,			0,			0,      5,          0,				0,			0,			0,				0,						0,	    1,		0,			0,				0,				'[ICON_RES_SULFUR]',            2,            'NEW_RESOURCE_ATLAS');


INSERT INTO Resources	(Type,					Description,							Civilopedia,								Help,										ResourceClassType,				ArtDefineTag,						AltArtDefineTag,					ArtDefineTagHeavy,					AltArtDefineTagHeavy,		TechReveal,						PolicyReveal,				TechCityTrade,					TechObsolete,		AIStopTradingEra,	Happiness,	WonderProductionMod,	WonderProductionModObsoleteEra, StartingResourceQuantity,	Normalize,		AITradeModifier,	AIObjective,	PlacementOrder, ConstAppearance,	MinAreaSize,	MinLatitude,	MaxLatitude,	RandApp1,	RandApp2,	RandApp3,	RandApp4,	Player, TilesPer,	MinLandPercent, GroupRange, GroupRand,	ResourceUsage,	PresentOnAllValidPlots, Area,	Hills,	Flatlands,	NoRiverSide,	OnlyMinorCivs,	IconString,						PortraitIndex,	IconAtlas) VALUES
			('RESOURCE_BARLEY',		'TXT_KEY_RESOURCE_BARLEY',				'TXT_KEY_CIV5_RESOURCE_BARLEY_TEXT',		            null,			'RESOURCECLASS_BONUS',			'ART_DEF_RESOURCE_BARLEY',			null,								null,								null,						null,							null,						'TECH_CALENDAR',				null,				null,				0,			0,						null,							0,							0,				0,					0,				4,				50,					3,				0,				90,				25,			25,			0,			0,			0,		5,			0,				0,			0,			0,				0,						0,		0,		1,			0,				0,				'[ICON_RES_BARLEY]',			4,				'NEW_RESOURCE_ATLAS');


INSERT INTO Resource_FeatureBooleans	(ResourceType,			FeatureType) VALUES
										('RESOURCE_LUMBER',		'FEATURE_FOREST'),
										('RESOURCE_LUMBER',		'FEATURE_JUNGLE');


INSERT INTO Resource_FeatureTerrainBooleans (ResourceType,			TerrainType) VALUES	
										 ('RESOURCE_LUMBER',		'TERRAIN_PLAINS'),
										 ('RESOURCE_LUMBER',		'TERRAIN_GRASS'	),
								         ('RESOURCE_SULFUR',		'TERRAIN_GRASS'),			
								         ('RESOURCE_SULFUR',		'TERRAIN_PLAINS'),		
								         ('RESOURCE_SULFUR',		'TERRAIN_HILL'),		
								         ('RESOURCE_SULFUR',		'TERRAIN_DESERT');


INSERT INTO Resource_Flavors	(ResourceType,			FlavorType,				Flavor) VALUES
                                ('RESOURCE_TITANIUM',	'FLAVOR_SCIENCE',		10),
								('RESOURCE_TITANIUM',	'FLAVOR_DEFENSE',		10),
								('RESOURCE_TITANIUM',	'FLAVOR_OFFENSE',		10),
								('RESOURCE_TITANIUM',	'FLAVOR_PRODUCTION',	10),
								('RESOURCE_TIN',	    'FLAVOR_SCIENCE',		10),
								('RESOURCE_TIN',	    'FLAVOR_DEFENSE',		10),
								('RESOURCE_TIN',	    'FLAVOR_OFFENSE',		10),
								('RESOURCE_TIN',	    'FLAVOR_PRODUCTION',	10),
								('RESOURCE_LAVENDER',	'FLAVOR_GOLD',			10),
								('RESOURCE_LUMBER',	    'FLAVOR_SCIENCE',		10),
								('RESOURCE_LUMBER',	    'FLAVOR_DEFENSE',		10),
								('RESOURCE_LUMBER',	    'FLAVOR_OFFENSE',		10),
								('RESOURCE_LUMBER',	    'FLAVOR_PRODUCTION',	10),

								('RESOURCE_SULFUR',	    'FLAVOR_PRODUCTION',	10),

                                ('RESOURCE_RASPBERRYZ',	'FLAVOR_GROWTH',		10),
								('RESOURCE_SAFFRON',	'FLAVOR_HAPPINESS',		50),
								('RESOURCE_SAFFRON',	'FLAVOR_GROWTH',		50),

								('RESOURCE_BARLEY',  	'FLAVOR_GROWTH',		10),
								('RESOURCE_BARLEY',  	'FLAVOR_GOLD',		    10),
								('RESOURCE_FLAX',	    'FLAVOR_GOLD',			10);
								



INSERT INTO Resource_QuantityTypes	(ResourceType,			Quantity) VALUES
									('RESOURCE_LUMBER',		'6'),
									('RESOURCE_LUMBER',		'5'),
									('RESOURCE_TIN',		'8'),
									('RESOURCE_TIN',		'7'),
									('RESOURCE_TITANIUM',	'6'),
									('RESOURCE_TITANIUM',	'8');


INSERT INTO Resource_TerrainBooleans	(ResourceType,			TerrainType) VALUES                                                                                                                         ('RESOURCE_RASPBERRYZ',	'TERRAIN_GRASS'	),
                                      	('RESOURCE_TITANIUM',	'TERRAIN_HILL'	),
										('RESOURCE_TITANIUM',	'TERRAIN_TUNDRA'),
										('RESOURCE_TITANIUM',	'TERRAIN_DESERT'),
										('RESOURCE_TITANIUM',	'TERRAIN_PLAINS'),
										('RESOURCE_LAVENDER',	'TERRAIN_PLAINS'),
										('RESOURCE_LAVENDER',	'TERRAIN_GRASS'	),
										('RESOURCE_TIN',	    'TERRAIN_HILL'	),
										('RESOURCE_TIN',	    'TERRAIN_TUNDRA'),
										('RESOURCE_TIN',	    'TERRAIN_DESERT'),
										('RESOURCE_TIN',	    'TERRAIN_PLAINS'),
										('RESOURCE_SULFUR',		'TERRAIN_PLAINS'),
										('RESOURCE_SULFUR',		'TERRAIN_HILL'	),
										('RESOURCE_SULFUR',		'TERRAIN_GRASS' ),
										('RESOURCE_SULFUR',		'TERRAIN_DESERT'),
	
							            ('RESOURCE_BARLEY',	'TERRAIN_PLAINS'),
										--('RESOURCE_SUNFLOWER',	'TERRAIN_GRASS'	),
										 ('RESOURCE_SAFFRON',		'TERRAIN_GRASS'	),								
										('RESOURCE_FLAX',		'TERRAIN_PLAINS');


INSERT INTO Resource_YieldChanges	(ResourceType,			YieldType,				Yield) VALUES
                                     ('RESOURCE_LAVENDER',	'YIELD_GOLD',			1),
                                     ('RESOURCE_TIN',	     'YIELD_PRODUCTION',	1),
									 ('RESOURCE_TIN',	     'YIELD_FOOD',	-2),
									  ('RESOURCE_IRON',	     'YIELD_FOOD',	-1),
									 ('RESOURCE_URANIUM',	     'YIELD_FOOD',	-5),
									 ('RESOURCE_ALUMINUM',	     'YIELD_FOOD',	-3),
									('RESOURCE_COAL',	     'YIELD_FOOD',	-4),
									 ('RESOURCE_OIL',	     'YIELD_FOOD',	-4),
                                    ('RESOURCE_RASPBERRYZ',	'YIELD_GOLD',		1),
									 ('RESOURCE_RASPBERRYZ',	'YIELD_FOOD',		2),
                                      ('RESOURCE_SULFUR',	     'YIELD_PRODUCTION',	2), 
									 ('RESOURCE_BARLEY',	     'YIELD_FOOD',	1), 
									  ('RESOURCE_BARLEY',	     'YIELD_PRODUCTION',	1), 
								     ('RESOURCE_FLAX',	     'YIELD_PRODUCTION',	2),
                                    ('RESOURCE_TITANIUM',	'YIELD_PRODUCTION',		1),
									('RESOURCE_SAFFRON',	     'YIELD_FAITH',	1),
									('RESOURCE_SAFFRON',	     'YIELD_GOLD',	1),
									('RESOURCE_LUMBER',		'YIELD_PRODUCTION',		1);
								
				



