--==========================================================================================================================
-- BUILDING CLASSES
--==========================================================================================================================
--INSERT INTO Building_YieldFromOtherYield(BuildingType, InYieldType,InYieldValue,OutYieldType,OutYieldValue) VALUES
--('BUILDING_PONTDUGARD', 'YIELD_HEALTH',1, 'YIELD_SCIENCE',1);




---污染减少人口产出
UPDATE Buildings SET FoodKept=-10 WHERE BuildingClass='BUILDINGCLASS_CITY_SIZE_LARGE';
UPDATE Buildings SET FoodKept=-15 WHERE BuildingClass='BUILDINGCLASS_CITY_SIZE_XL';
UPDATE Buildings SET FoodKept=-25 WHERE BuildingClass='BUILDINGCLASS_CITY_SIZE_XXL';
UPDATE Buildings SET FoodKept=-50 WHERE BuildingClass='BUILDINGCLASS_CITY_SIZE_GLOBAL';



---全局专家产出
INSERT INTO Building_SpecialistYieldChanges(BuildingType,	SpecialistType,	YieldType,	  Yield)
SELECT     'BUILDING_COOKED_MEDICINE',	 'SPECIALIST_DOCTOR',	   'YIELD_SCIENCE',1;

----本地人口产出加成
INSERT  INTO Building_YieldChangesPerPop(BuildingType,YieldType,Yield)
VALUES('BUILDING_CITY_SIZE_TOWN', 'YIELD_DISEASE',25),
      ('BUILDING_CITY_SIZE_SMALL', 'YIELD_DISEASE',25),
      ('BUILDING_CITY_SIZE_MEDIUM', 'YIELD_DISEASE',25),
	  ('BUILDING_CITY_SIZE_LARGE', 'YIELD_DISEASE',25),
      ('BUILDING_CITY_SIZE_XL', 'YIELD_DISEASE',25),
	  ('BUILDING_CITY_SIZE_XXL', 'YIELD_DISEASE',50),
	  ('BUILDING_CITY_SIZE_GLOBAL', 'YIELD_DISEASE',50);



---功能性建筑
INSERT INTO BuildingClasses (Type, DefaultBuilding,	Description)
SELECT 'BUILDINGCLASS_LOCAL_HOSPITAL','BUILDING_LOCAL_HOSPITAL','TXT_KEY_BUILDING_LOCAL_HOSPITAL' ;   --医馆

INSERT INTO Buildings (Type, BuildingClass,	Description,Help,Cost,NukeImmune,IconAtlas,PortraitIndex,ConquestProb)
SELECT 'BUILDING_LOCAL_HOSPITAL','BUILDINGCLASS_LOCAL_HOSPITAL','TXT_KEY_BUILDING_LOCAL_HOSPITAL','TXT_KEY_BUILDING_LOCAL_HOSPITAL_HELP',-1,1,'ROBOT_ICON_ATLAS3',221,100 ;			

		
INSERT INTO Building_YieldModifiers (BuildingType, YieldType,Yield)
SELECT 'BUILDING_LOCAL_HOSPITAL','YIELD_SCIENCE',15 ;   --医馆


-----------------------------------------------------------------------------------------------------
--Buildings  建筑类设定
-----------------------------------------------------------------------------------------------------
UPDATE Buildings SET AddsFreshWater = 1 WHERE BuildingClass = 'BUILDINGCLASS_AQUEDUCT';
UPDATE Buildings SET AddsFreshWater = 1 WHERE BuildingClass = 'BUILDINGCLASS_PONTDUGARD';


UPDATE Buildings SET SpecialistType = 'SPECIALIST_DOCTOR',GreatPeopleRateChange = 1  WHERE BuildingClass = 'BUILDINGCLASS_HEALTH_BUREAU';

UPDATE Buildings SET SpecialistType = 'SPECIALIST_DOCTOR', SpecialistCount = 3 , GreatPeopleRateChange = 3  WHERE BuildingClass = 'BUILDINGCLASS_COOKED_MEDICINE';

UPDATE Buildings SET SpecialistType = 'SPECIALIST_DOCTOR', SpecialistCount = 2 , GreatPeopleRateChange = 2  WHERE BuildingClass = 'BUILDINGCLASS_BIOLOGICAL_FACTORIES';

UPDATE Buildings SET SpecialistType = 'SPECIALIST_DOCTOR', SpecialistCount = 1 , GreatPeopleRateChange = 1  WHERE BuildingClass = 'BUILDINGCLASS_HERBALIST';
UPDATE Buildings SET SpecialistType = 'SPECIALIST_DOCTOR', SpecialistCount = 3 , GreatPeopleRateChange = 2  WHERE BuildingClass = 'BUILDINGCLASS_LOCAL_HOSPITAL';
UPDATE Buildings SET SpecialistType = 'SPECIALIST_DOCTOR', SpecialistCount = 2 WHERE BuildingClass = 'BUILDINGCLASS_HOSPITAL';
UPDATE Buildings SET SpecialistType = 'SPECIALIST_DOCTOR', SpecialistCount = 2 WHERE BuildingClass = 'BUILDINGCLASS_MEDICAL_LAB';
UPDATE Buildings SET SpecialistType = 'SPECIALIST_DOCTOR', SpecialistCount = 2 WHERE BuildingClass = 'BUILDINGCLASS_NATIONAL_HOSPITAL';   
UPDATE Buildings SET SpecialistType = 'SPECIALIST_DOCTOR', SpecialistCount = 2 WHERE BuildingClass = 'BUILDINGCLASS_MEDICAL_COMPANY';  


INSERT  INTO Building_SpecificGreatPersonRateModifier(BuildingType,SpecialistType,Modifier)VALUES
('BUILDING_HOSPITAL', 'SPECIALIST_DOCTOR',20),
('BUILDING_MEDICAL_LAB', 'SPECIALIST_DOCTOR',20),
('BUILDING_HERBALIST', 'SPECIALIST_DOCTOR',15),
('BUILDING_COOKED_MEDICINE', 'SPECIALIST_DOCTOR',20),
('BUILDING_PRIVATE_PHARMACY', 'SPECIALIST_DOCTOR',20);


INSERT INTO Building_BuildingClassLocalYieldChanges(BuildingType,  BuildingClassType, YieldType, YieldChange )
SELECT     'BUILDING_BIOLOGICAL_FACTORIES',    	  'BUILDINGCLASS_HOSPITAL',	                    'YIELD_HEALTH',	  3 UNION ALL
SELECT     'BUILDING_BIOLOGICAL_FACTORIES',	      'BUILDINGCLASS_BIO_LAB',	                    'YIELD_HEALTH',	  3 UNION ALL

SELECT     'BUILDING_LOCAL_HOSPITAL',	'BUILDINGCLASS_CITY_SIZE_SMALL',	                'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_LOCAL_HOSPITAL',	'BUILDINGCLASS_CITY_SIZE_MEDIUM',	                'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_LOCAL_HOSPITAL',	'BUILDINGCLASS_CITY_SIZE_LARGE',	                'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_LOCAL_HOSPITAL',	'BUILDINGCLASS_CITY_SIZE_XL',	                    'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_LOCAL_HOSPITAL',	'BUILDINGCLASS_CITY_SIZE_XXL',	                    'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_LOCAL_HOSPITAL',	'BUILDINGCLASS_CITY_SIZE_GLOBAL',	                'YIELD_HEALTH',	  3 UNION ALL

SELECT     'BUILDING_HEALTH_BUREAU',	          'BUILDINGCLASS_UNIVERSITY',	   'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_HEALTH_BUREAU',	          'BUILDINGCLASS_WATER_TREATMENT_FACTORY',	   'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_HEALTH_BUREAU',	          'BUILDINGCLASS_SMALL_MARKET',	   'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_HEALTH_BUREAU',	          'BUILDINGCLASS_HOSPITAL',   'YIELD_HEALTH',	  1 ; 

-----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS BuildingClass_HealthYields (BuildingClassType TEXT DEFAULT NULL, Yield INTEGER DEFAULT 0);

INSERT INTO BuildingClass_HealthYields (BuildingClassType,	Yield)
SELECT 'BUILDINGCLASS_GARMENT_WORKSHOP',				     -2 UNION ALL   --纺织厂
SELECT 'BUILDINGCLASS_CENTERS',				                 5 UNION ALL   --疾控
SELECT 'BUILDINGCLASS_ORE_REFINERIES',				         -5 UNION ALL   --电冶金
SELECT 'BUILDINGCLASS_COOKED_MEDICINE',				         5 UNION ALL   --熟药所
SELECT 'BUILDINGCLASS_PRIVATE_PHARMACY',				     3 UNION ALL   --私人药店
SELECT 'BUILDINGCLASS_BIOLOGICAL_FACTORIES',				 3 UNION ALL   --生物制剂工厂
SELECT 'BUILDINGCLASS_LOCAL_HOSPITAL',						 4 UNION ALL   --医馆
SELECT 'BUILDINGCLASS_STABLE',								-1 UNION ALL   --马厩
SELECT 'BUILDINGCLASS_STONE_WORKS',							-1 UNION ALL   --石工坊
SELECT 'BUILDINGCLASS_CIRCUS',								-1 UNION ALL   --马戏团
SELECT 'BUILDINGCLASS_FORGE',								-1 UNION ALL   --铁匠铺
SELECT 'BUILDINGCLASS_WORKSHOP',							-1 UNION ALL   --工坊
SELECT 'BUILDINGCLASS_IRONWORKS',							-2 UNION ALL   --钢铁厂
SELECT 'BUILDINGCLASS_COLOSSEUM',							-1 UNION ALL   --竞技场
SELECT 'BUILDINGCLASS_THEATRE',								-1 UNION ALL   --歌剧院
SELECT 'BUILDINGCLASS_HARBOR',								-2 UNION ALL   --海港
SELECT 'BUILDINGCLASS_SEAPORT',								-2 UNION ALL   --港口
SELECT 'BUILDINGCLASS_FACTORY',								-8 UNION ALL   --工厂
SELECT 'BUILDINGCLASS_AIRPORT',								-3 UNION ALL   --机场
SELECT 'BUILDINGCLASS_TOURIST_CENTER',						-3 UNION ALL   --旅游中心
SELECT 'BUILDINGCLASS_GRANARY',								 1 UNION ALL	   --粮仓
SELECT 'BUILDINGCLASS_WINDMILL',							1 UNION ALL	    --风车
SELECT 'BUILDINGCLASS_GARDEN',								1 UNION ALL	    --花园
SELECT 'BUILDINGCLASS_UNIVERSITY',							2 UNION ALL	    --大学
SELECT 'BUILDINGCLASS_RECYCLING_CENTER',					2 UNION ALL	    --回收中心
SELECT 'BUILDINGCLASS_HOSPITAL',							5 UNION ALL	   --医院
SELECT 'BUILDINGCLASS_MEDICAL_LAB',							5 UNION ALL	   --医学实验室
SELECT 'BUILDINGCLASS_WELL',							    1 UNION ALL    --水井
SELECT 'BUILDINGCLASS_HERBALIST',							2 UNION ALL	   --草药铺
SELECT 'BUILDINGCLASS_STEEL_MILL',							-3 UNION ALL	--增值反应堆
SELECT 'BUILDINGCLASS_WATER_TREATMENT_FACTORY',				3 UNION ALL     --污水处理厂
SELECT 'BUILDINGCLASS_COAL_COMPANY',					    -5 UNION ALL    --炼焦厂  
SELECT 'BUILDINGCLASS_OIL_REFINERY',					    -5 UNION ALL    --石油精炼
SELECT 'BUILDINGCLASS_GAS_PLANT',					        -2 UNION ALL    --燃气发电站
SELECT 'BUILDINGCLASS_OIL_PLANT',					        -3 UNION ALL    --燃油发电站
SELECT 'BUILDINGCLASS_COAL_PLANT',					        -5 UNION ALL    --燃煤发电站
SELECT 'BUILDINGCLASS_COAL_PLANT_EXTEND',					-3 UNION ALL    --燃煤扩充发电站
SELECT 'BUILDINGCLASS_TAP_WATER_SUPPLY',					2 UNION ALL     --自来水系统
SELECT 'BUILDINGCLASS_INLAND_CANAL',					    -1 UNION ALL    --内陆运河	
SELECT 'BUILDINGCLASS_NATIONAL_HOSPITAL',					20 UNION ALL    --量子生物学中心	
SELECT 'BUILDINGCLASS_TITANIUM_FACTORY',					-10 UNION ALL    --合金铸造厂
SELECT 'BUILDINGCLASS_BIOFACTORY',					    3 UNION ALL     --生态学工厂
SELECT 'BUILDINGCLASS_CLOACA',					            2 UNION ALL		--下水道
SELECT 'BUILDINGCLASS_BALNEAE',					            1 UNION ALL		--公共浴室
SELECT 'BUILDINGCLASS_ALCHEMIST',					        -1 UNION ALL	--炼金术屋
SELECT 'BUILDINGCLASS_IRON_PROVIDER',					    -1 UNION ALL	--冶铁坊
SELECT 'BUILDINGCLASS_DESERT_TRANSFORMING_BASE',			3 UNION ALL	    --沙漠改造  
SELECT 'BUILDINGCLASS_UNDERGROUND',			                -2 UNION ALL	--地下城市
SELECT 'BUILDINGCLASS_PONTDUGARD',			                3 UNION ALL	    --加尔桥   
SELECT 'BUILDINGCLASS_MEDICAL_COMPANY',						6 UNION ALL     --医药公司
SELECT 'BUILDINGCLASS_MARKOV',						    -10 UNION ALL     --马尔科夫 
SELECT 'BUILDINGCLASS_INDUSTRIAL_ZONE',						-15 UNION ALL     --鲁尔工业区
SELECT 'BUILDINGCLASS_GREAT_LIBRARY',						 3 UNION ALL     --大图
------------------城市规模------------------------------
SELECT 'BUILDINGCLASS_CITY_SIZE_SMALL',					    -3 UNION ALL    --小城市
SELECT 'BUILDINGCLASS_CITY_SIZE_MEDIUM',					-3 UNION ALL	--中城市
SELECT 'BUILDINGCLASS_CITY_SIZE_LARGE',					    -4 UNION ALL	--大城市
SELECT 'BUILDINGCLASS_CITY_SIZE_XL',					    -4 UNION ALL    --特大城市
SELECT 'BUILDINGCLASS_CITY_SIZE_XXL',					    -6 UNION ALL	--巨型城市
SELECT 'BUILDINGCLASS_CITY_SIZE_GLOBAL',					-8 UNION ALL	--大都会
SELECT 'BUILDINGCLASS_LABORATORY',							3;              --实验室

---疾病点数
INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield) 
SELECT	b.Type, 'YIELD_DISEASE', -h.Yield 
FROM Buildings AS b, BuildingClass_HealthYields AS h
WHERE b.BuildingClass = h.BuildingClassType AND h.Yield<0 AND b.Type!='BUILDING_AMERICA_RANCH';

---健康点数
INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield) 
SELECT	b.Type, 'YIELD_HEALTH', h.Yield 
FROM Buildings AS b, BuildingClass_HealthYields AS h
WHERE b.BuildingClass = h.BuildingClassType AND h.Yield>0 ;


---加尔桥
INSERT INTO Building_HealthMods (BuildingType, PlagueMod) 
SELECT 'BUILDING_PONTDUGARD',	15;  



--INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor) 
--SELECT	b.Type, 'FLAVOR_GROWTH', (h.Yield*5)
--FROM Buildings AS b, BuildingClass_HealthYields AS h
--WHERE b.BuildingClass = h.BuildingClassType;



---公共浴室
INSERT  INTO Building_YieldModifiers(BuildingType,YieldType,Yield)
VALUES('BUILDING_BALNEAE', 'YIELD_HEALTH',5);

-----------------------------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS BuildingClass_HealthModifiers (BuildingClassType TEXT DEFAULT NULL, Yield INTEGER DEFAULT 0);
CREATE TABLE IF NOT EXISTS BuildingClass_HealthModifiersGlobal (BuildingClassType TEXT DEFAULT NULL, Yield INTEGER DEFAULT 0);

UPDATE Buildings SET HumanOnly=1 WHERE BuildingClass='BUILDINGCLASS_COAL_COMPANY';
UPDATE Buildings SET HumanOnly=1 WHERE BuildingClass='BUILDINGCLASS_COAL_PLANT_EXTEND';
UPDATE Buildings SET HumanOnly=1 WHERE BuildingClass='BUILDINGCLASS_OIL_PLANT';
UPDATE Buildings SET HumanOnly=1 WHERE BuildingClass='BUILDINGCLASS_GAS_PLANT';

INSERT INTO BuildingClass_HealthModifiers (BuildingClassType,	Yield)
------------------城市规模------------------------------
SELECT 'BUILDINGCLASS_CITY_SIZE_SMALL',					         -5 UNION ALL    --小城市
SELECT 'BUILDINGCLASS_CITY_SIZE_MEDIUM',					     -10 UNION ALL	--中城市
SELECT 'BUILDINGCLASS_CITY_SIZE_LARGE',					         -10 UNION ALL	--大城市
SELECT 'BUILDINGCLASS_CITY_SIZE_XL',					         -15 UNION ALL    --特大城市
SELECT 'BUILDINGCLASS_CITY_SIZE_XXL',					         -15 UNION ALL	--巨型城市
SELECT 'BUILDINGCLASS_CITY_SIZE_GLOBAL',					     -20 UNION ALL	--大都会

SELECT 'BUILDINGCLASS_BIOLOGICAL_FACTORIES',				     10 UNION ALL   --生物制剂工厂
SELECT 'BUILDINGCLASS_HEALTH_BUREAU',					         10 UNION ALL  --卫生局
SELECT 'BUILDINGCLASS_TAP_WATER_SUPPLY',					     10 UNION ALL  --自来水系统
SELECT 'BUILDINGCLASS_HOSPITAL',								 10 UNION ALL  --医院
SELECT 'BUILDINGCLASS_THEME_PARK',								 10 UNION ALL  ---主题公园
SELECT 'BUILDINGCLASS_ORE_REFINERIES',						    -20 UNION ALL  ---电冶金
SELECT 'BUILDINGCLASS_FACTORY',									-20 UNION ALL  --工厂
SELECT 'BUILDINGCLASS_NUCLEAR_PLANT',							-10 UNION ALL  --核电站
SELECT 'BUILDINGCLASS_MEDICAL_LAB',								 15 UNION ALL   ---医学实验室
SELECT 'BUILDINGCLASS_HYDRO_PLANT',								 10 UNION ALL  --水电站
SELECT 'BUILDINGCLASS_STEEL_MILL',								-10 UNION ALL --增值反应堆
SELECT 'BUILDINGCLASS_WATER_TREATMENT_FACTORY',					 10 UNION ALL --污水处理厂
SELECT 'BUILDINGCLASS_OIL_REFINERY',					        -15 UNION ALL --石油精炼
SELECT 'BUILDINGCLASS_MINING_COMPANY',					        -20 UNION ALL --矿业公司
SELECT 'BUILDINGCLASS_COAL_PLANT',					            -20 UNION ALL --煤炭厂
SELECT 'BUILDINGCLASS_COAL_PLANT_EXTEND',					    -20 UNION ALL --煤焦炭厂
SELECT 'BUILDINGCLASS_COAL_COMPANY',					        -20 UNION ALL --煤焦炭厂
SELECT 'BUILDINGCLASS_GAS_PLANT',					            -10 UNION ALL --燃气厂
SELECT 'BUILDINGCLASS_OIL_PLANT',					            -15  ;        --燃石油厂; 


INSERT INTO BuildingClass_HealthModifiersGlobal (BuildingClassType,	Yield)
SELECT 'BUILDINGCLASS_CENTERS',						             20 UNION ALL  ---疾控
SELECT 'BUILDINGCLASS_COOKED_MEDICINE',						     20 UNION ALL  ---熟药所
SELECT 'BUILDINGCLASS_INDUSTRIAL_ZONE',					        -20 UNION ALL --鲁尔工业区
SELECT 'BUILDINGCLASS_PONTDUGARD',					             20 UNION ALL    --加尔桥
SELECT 'BUILDINGCLASS_NATIONAL_HOSPITAL',					     50 ;   --量子生物学中心



-----------------------------------------------------------------------------------------------------------------------
---疾病点数
-----------------------------------------------------------------------------------------------------------------------
---本地加成
INSERT INTO  Building_YieldModifiers(BuildingType, YieldType, Yield) 
SELECT	b.Type, 'YIELD_DISEASE', -h.Yield 
FROM Buildings AS b,  BuildingClass_HealthModifiers AS h
WHERE b.BuildingClass = h.BuildingClassType AND h.Yield<0 ;

---全局加成
INSERT INTO Building_GlobalYieldModifiers(BuildingType, YieldType, Yield) 
SELECT	b.Type, 'YIELD_DISEASE', -h.Yield 
FROM Buildings AS b,  BuildingClass_HealthModifiersGlobal AS h
WHERE b.BuildingClass = h.BuildingClassType AND h.Yield<0 ;

-----------------------------------------------------------------------------------------------------------------------
---健康点数
-----------------------------------------------------------------------------------------------------------------------
---本地加成
INSERT INTO Building_YieldModifiers(BuildingType, YieldType, Yield) 
SELECT	b.Type, 'YIELD_HEALTH', h.Yield 
FROM Buildings AS b, BuildingClass_HealthModifiers AS h
WHERE b.BuildingClass = h.BuildingClassType AND h.Yield>0 ;

---全局加成
INSERT INTO Building_GlobalYieldModifiers(BuildingType, YieldType, Yield) 
SELECT	b.Type, 'YIELD_HEALTH', h.Yield 
FROM Buildings AS b,  BuildingClass_HealthModifiersGlobal AS h
WHERE b.BuildingClass = h.BuildingClassType AND h.Yield>0 ;
----------------------------------------------------------------------------------------------------------------------

INSERT INTO Building_SpecialistYieldChangesLocal(BuildingType,	SpecialistType,	YieldType,	  Yield)
SELECT     'BUILDING_HEALTH_BUREAU',	          'SPECIALIST_DOCTOR',	   'YIELD_HEALTH',	  1  ;

---建筑与资源产出
INSERT INTO Building_ResourceYieldChanges (BuildingType,	ResourceType,			YieldType,	  Yield)

SELECT     'BUILDING_COOKED_MEDICINE',	          'RESOURCE_SULFUR',	   'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	          'RESOURCE_LAVENDER',	   'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	          'RESOURCE_INCENSE',	   'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	          'RESOURCE_RASPBERRYZ',   'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	          'RESOURCE_TEA',	       'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	          'RESOURCE_SAFFRON',	   'YIELD_HEALTH',	  2 UNION ALL

SELECT     'BUILDING_COOKED_MEDICINE',	          'RESOURCE_SULFUR',	   'YIELD_GOLD',	  2 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	          'RESOURCE_LAVENDER',	   'YIELD_GOLD',	  2 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	          'RESOURCE_INCENSE',	   'YIELD_GOLD',	  2 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	          'RESOURCE_RASPBERRYZ',   'YIELD_GOLD',	  2 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	          'RESOURCE_TEA',	       'YIELD_GOLD',	  2 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	          'RESOURCE_SAFFRON',	   'YIELD_GOLD',	  2 UNION ALL


SELECT     'BUILDING_HERBALIST',	             'RESOURCE_SAFFRON',	   'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_HERBALIST',	             'RESOURCE_LAVENDER',	   'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_HERBALIST',	             'RESOURCE_INCENSE',	   'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_HERBALIST',	             'RESOURCE_SULFUR',	       'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_HERBALIST',	             'RESOURCE_SPICES',	       'YIELD_HEALTH',	  1 UNION ALL
--SELECT    'BUILDING_HERBALIST',	             'RESOURCE_TEA',	       'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_HERBALIST',	             'RESOURCE_SANPEDRO',	   'YIELD_HEALTH',	  1 UNION ALL

SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_COW',	       'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_SHEEP',	       'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_HORSE',	       'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_BISON',	       'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_DEER',	       'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_COW',	       'YIELD_FOOD',	  1 UNION ALL
SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_SHEEP',	       'YIELD_FOOD',	  1 UNION ALL
SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_HORSE',	       'YIELD_FOOD',	  1 UNION ALL
SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_BISON',	       'YIELD_FOOD',	  1 UNION ALL
SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_DEER',	       'YIELD_FOOD',	  1 UNION ALL
SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_COW',	       'YIELD_PRODUCTION',1 UNION ALL
SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_SHEEP',	       'YIELD_PRODUCTION',1 UNION ALL
SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_HORSE',	       'YIELD_PRODUCTION',1 UNION ALL
SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_BISON',	       'YIELD_PRODUCTION',1 UNION ALL
SELECT     'BUILDING_MYCOPROTEIN_VATS',	     'RESOURCE_DEER',	       'YIELD_PRODUCTION',1 UNION ALL
SELECT     'BUILDING_VINYARD',	                 'RESOURCE_RASPBERRYZ',	   'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_VINYARD',	                 'RESOURCE_LAVENDER',	   'YIELD_HEALTH',	  1 ;



---政策与改良设施产出
INSERT INTO Policy_ImprovementYieldChanges(PolicyType,	ImprovementType,		YieldType,	  Yield)
SELECT     'POLICY_INDUSTRY_FINISHER',	             'IMPROVEMENT_QUARRY',	  'YIELD_HEALTH',	  1 ;



---建筑与人口产出
INSERT INTO Building_YieldChangesPerPop(BuildingType,	YieldType,	  Yield)
SELECT     'BUILDING_PRIVATE_PHARMACY',	        	     'YIELD_HEALTH',	  10 UNION ALL
SELECT     'BUILDING_PRIVATE_PHARMACY',	        	     'YIELD_GOLD',	      10 UNION ALL

SELECT     'BUILDING_HOSPITAL',	        	             'YIELD_HEALTH',	  15 UNION ALL
SELECT     'BUILDING_HERBALIST',	        	         'YIELD_HEALTH',	  10 UNION ALL
SELECT     'BUILDING_PONTDUGARD',	                     'YIELD_HEALTH',	  25 ;

---建筑与河流产出
INSERT INTO Building_RiverPlotYieldChanges(BuildingType,	YieldType,	  Yield)
SELECT     'BUILDING_HANGING_GARDEN',	    'YIELD_HEALTH',	  1  ;



---建筑与湖泊产出
INSERT INTO Building_LakePlotYieldChanges(BuildingType,	YieldType,	  Yield)
SELECT     'BUILDING_ZHENGGUOQU',	    'YIELD_HEALTH',	  2  ;


---建筑与地形产出
INSERT INTO Building_TerrainYieldChanges (BuildingType,	TerrainType,			YieldType,	  Yield)
SELECT     'BUILDING_COOKED_MEDICINE',	         'TERRAIN_SNOW',	                'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	         'TERRAIN_TUNDRA',	                'YIELD_HEALTH',	  1 UNION ALL

SELECT     'BUILDING_DESERT_TRANSFORMING_BASE',	 'TERRAIN_DESERT',	                'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_PETRA',	                 'TERRAIN_DESERT',	                'YIELD_HEALTH',	  1 UNION ALL
--SELECT     'BUILDING_BIOFACTORY',	         'TERRAIN_TUNDRA',	                'YIELD_HEALTH',	  1 UNION ALL
--SELECT     'BUILDING_BIOFACTORY',	         'TERRAIN_SNOW',	                'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_PONTDUGARD',	             'TERRAIN_PLAINS',	                'YIELD_HEALTH',	  1 ;




---建筑与地貌产出
INSERT INTO Building_FeatureYieldChanges (BuildingType,	FeatureType,			YieldType,		Yield)
SELECT     'BUILDING_DESERT_TRANSFORMING_BASE',	'FEATURE_OASIS',	         'YIELD_HEALTH',	  1 ;

--加尔桥
--INSERT INTO Building_FeatureYieldChanges
		--(BuildingType, 			FeatureType, 	YieldType, 		Yield)
--SELECT 	'BUILDING_PONTDUGARD', 	Type,		'YIELD_HEALTH', 	1
--FROM Features WHERE NaturalWonder = '1' OR PseudoNaturalWonder = '1';



---建筑提升建筑产出
INSERT INTO Building_BuildingClassYieldChanges (BuildingType,	BuildingClassType,			YieldType,		YieldChange)
SELECT     'BUILDING_COOKED_MEDICINE',	'BUILDINGCLASS_HERBALIST',	                     'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	'BUILDINGCLASS_VINYARD',	                     'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	'BUILDINGCLASS_PRIVATE_PHARMACY',	             'YIELD_HEALTH',      1 UNION ALL


--SELECT     'BUILDING_BIOLOGICAL_FACTORIES',	'BUILDINGCLASS_HOSPITAL',	                    'YIELD_HEALTH',	  3 UNION ALL
--SELECT     'BUILDING_BIOLOGICAL_FACTORIES',	'BUILDINGCLASS_BIO_LAB',	                    'YIELD_HEALTH',	  3 UNION ALL

SELECT     'BUILDING_PONTDUGARD',	'BUILDINGCLASS_BALNEAE',	                'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_PONTDUGARD',	'BUILDINGCLASS_AQUEDUCT',	                'YIELD_HEALTH',	  3 UNION ALL

SELECT     'BUILDING_NATIONAL_HOSPITAL',	'BUILDINGCLASS_MEDICAL_LAB',	                'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_NATIONAL_HOSPITAL',	'BUILDINGCLASS_HOSPITAL',	                    'YIELD_HEALTH',	  1;





