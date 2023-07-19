--==========================================================================================================================
-- FEATURES
--==========================================================================================================================
ALTER TABLE Feature_YieldChanges ADD OnlyAdjacentCity boolean DEFAULT 0;
ALTER TABLE Terrain_Yields       ADD OnlyAdjacentCity boolean DEFAULT 0;


--地貌
INSERT INTO Feature_YieldChanges (FeatureType,		YieldType,				Yield,	OnlyAdjacentCity)
--SELECT 'FEATURE_RETBA',						    'YIELD_HEALTH',			2,		0 UNION ALL	 --瑞特巴
--SELECT 'FEATURE_SALAR_A',						    'YIELD_HEALTH',			2,		0 UNION ALL	 --盐湖
--SELECT 'FEATURE_SALAR_B',						    'YIELD_HEALTH',			2,		0 UNION ALL	 --盐湖 
--SELECT 'FEATURE_CAUSEWAY_A',						'YIELD_HEALTH',		    1,		0 UNION ALL	 --巨人堤 
--SELECT 'FEATURE_CAUSEWAY_B',						'YIELD_HEALTH',		    1,		0 UNION ALL	 --巨人堤   
SELECT 'FEATURE_LAKE_VICTORIA',						'YIELD_HEALTH',			4,		0 UNION ALL	 --维多利亚湖
SELECT 'FEATURE_FOUNTAIN_YOUTH',					'YIELD_HEALTH',			6,		0 UNION ALL	 --青春泉
SELECT 'FEATURE_REEF',								'YIELD_HEALTH',			4,		0 UNION ALL	 --大堡礁
SELECT 'FEATURE_ATOLL',								'YIELD_HEALTH',			1,		0 UNION ALL	 --环礁
SELECT 'FEATURE_OASIS',								'YIELD_HEALTH',			3,		0 UNION ALL	--绿洲
SELECT 'FEATURE_FALLOUT',							'YIELD_DISEASE',		5,		0 UNION ALL	--辐射
SELECT 'FEATURE_FLOOD_PLAINS',						'YIELD_HEALTH',			1,		0 UNION ALL	--泛滥平原
SELECT 'FEATURE_MARSH',								'YIELD_DISEASE',		2,		0 UNION ALL	--沼泽
SELECT 'FEATURE_JUNGLE',							'YIELD_HEALTH',			1,		1 UNION ALL	--丛林
SELECT 'FEATURE_FOREST',							'YIELD_HEALTH',			1,		1;          --森林

--地形
INSERT INTO Terrain_Yields (TerrainType,		YieldType,				Yield,	OnlyAdjacentCity)
SELECT 'TERRAIN_GRASS',						        'YIELD_HEALTH',			0,		0 UNION ALL	 --草原
SELECT 'TERRAIN_PLAINS',						    'YIELD_HEALTH',			0,		0 UNION ALL	 --平原
SELECT 'TERRAIN_DESERT',						    'YIELD_DISEASE',		1,		0 UNION ALL	 --荒漠
SELECT 'TERRAIN_TUNDRA',						    'YIELD_DISEASE',		1,		0 UNION ALL	 --冻土
SELECT 'TERRAIN_SNOW',						        'YIELD_DISEASE',		1,		0 UNION ALL	 --雪原
SELECT 'TERRAIN_COAST',						        'YIELD_HEALTH',			0,		0 UNION ALL	 --海滨
SELECT 'TERRAIN_OCEAN',						        'YIELD_HEALTH',			0,		0 UNION ALL	 --大洋
SELECT 'TERRAIN_MOUNTAIN',						    'YIELD_HEALTH',			0,		0 UNION ALL	 --山脉
SELECT 'TERRAIN_HILL',						        'YIELD_HEALTH',			0,		0 ; 	     --丘陵


--------------------------------------------------------------------------------------------------
--Improvements
--------------------------------------------------------------------------------------------------


INSERT INTO Improvement_AdjacentCityYields(ImprovementType,	YieldType,			Yield)
--SELECT 'IMPROVEMENT_TERRASCAPE',						'YIELD_HEALTH',			-1 UNION ALL
--SELECT 'IMPROVEMENT_MINE',						    'YIELD_HEALTH',			-1 UNION ALL
--SELECT 'IMPROVEMENT_QUARRY',						    'YIELD_HEALTH',			-1 UNION ALL
SELECT 'IMPROVEMENT_FW_INDUSTRIAL_COMPLEX',			'YIELD_DISEASE',			2 ;



--------------------------------------------------------------------------------------------------

 
 --改良设施直接产出
INSERT INTO Improvement_Yields (ImprovementType,	YieldType,				Yield)
SELECT 'IMPROVEMENT_SANATORIUM',					'YIELD_GOLDEN_AGE_POINTS',8 UNION ALL  --疗养院
SELECT 'IMPROVEMENT_SANATORIUM',					'YIELD_HEALTH',			 10 UNION ALL  --疗养院
SELECT 'IMPROVEMENT_TERRASCAPE',					'YIELD_HEALTH',			 1 UNION ALL  --人造绿洲
SELECT 'IMPROVEMENT_FW_ARCOLOGY',					'YIELD_HEALTH',			 3 UNION ALL  --生态城市

SELECT 'IMPROVEMENT_QUARRY',						'YIELD_DISEASE',		1 UNION ALL  --采石场
SELECT 'IMPROVEMENT_FW_GENERATOR',					'YIELD_DISEASE',		3 UNION ALL  --发电机
SELECT 'IMPROVEMENT_FW_INDUSTRIAL_COMPLEX',			'YIELD_DISEASE',	     2 UNION ALL  --工业综合体  
SELECT 'IMPROVEMENT_MANUFACTORY',					'YIELD_DISEASE',		2;


--科技提升改良设施产出
INSERT INTO Improvement_TechYieldChanges (ImprovementType,	TechType,			YieldType,		Yield)
--SELECT 'IMPROVEMENT_SANATORIUM',							'TECH_ELECTRICITY',	'YIELD_HEALTH',	1 UNION ALL 
SELECT 'IMPROVEMENT_CUSTOMS_HOUSE',							'TECH_NAVIGATION',	'YIELD_HEALTH',	1;



--科技提升淡水对改良设施产出
--INSERT INTO Improvement_TechFreshWaterYieldChanges (ImprovementType,	TechType,				YieldType,		Yield)
--SELECT 'IMPROVEMENT_SANATORIUM',					'TECH_COMPUTERS',		'YIELD_HEALTH',	1;   




INSERT INTO Improvement_Flavors (ImprovementType,	FlavorType,				Flavor)
SELECT 'IMPROVEMENT_CUSTOMS_HOUSE',					'FLAVOR_GROWTH',		1 UNION ALL
SELECT 'IMPROVEMENT_ACADEMY',						'FLAVOR_GROWTH',		5 UNION ALL
SELECT 'IMPROVEMENT_SANATORIUM',				    'FLAVOR_TILE_IMPROVEMENT',  175 UNION ALL
SELECT 'IMPROVEMENT_SANATORIUM',					'FLAVOR_GROWTH',		75 ;

UPDATE Resources  
	SET TechCityTrade = 'TECH_AGRICULTURE'
	WHERE Type IN (SELECT ResourceType FROM Improvement_ResourceType_Yields WHERE YieldType = 'YIELD_HEALTH' AND Yield > 0) AND TechCityTrade IS NULL;
