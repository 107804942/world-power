--==========================================================================================================================
-- BUILDING CLASSES
--==========================================================================================================================
--INSERT INTO Building_YieldFromOtherYield(BuildingType, InYieldType,InYieldValue,OutYieldType,OutYieldValue) VALUES
--('BUILDING_PONTDUGARD', 'YIELD_HEALTH',1, 'YIELD_SCIENCE',1);

---ȫ��ר�Ҳ���
INSERT INTO Building_SpecialistYieldChanges(BuildingType,	SpecialistType,	YieldType,	  Yield)
SELECT     'BUILDING_COOKED_MEDICINE',	 'SPECIALIST_DOCTOR',	   'YIELD_SCIENCE',1;

----�����˿ڲ����ӳ�
INSERT  INTO Building_YieldChangesPerPop(BuildingType,YieldType,Yield)
VALUES('BUILDING_CITY_SIZE_TOWN', 'YIELD_DISEASE',25),
      ('BUILDING_CITY_SIZE_SMALL', 'YIELD_DISEASE',25),
      ('BUILDING_CITY_SIZE_MEDIUM', 'YIELD_DISEASE',25),
	  ('BUILDING_CITY_SIZE_LARGE', 'YIELD_DISEASE',25),
      ('BUILDING_CITY_SIZE_XL', 'YIELD_DISEASE',25),
	  ('BUILDING_CITY_SIZE_XXL', 'YIELD_DISEASE',50),
	  ('BUILDING_CITY_SIZE_GLOBAL', 'YIELD_DISEASE',50);



---�����Խ���
INSERT INTO BuildingClasses (Type, DefaultBuilding,	Description)
SELECT 'BUILDINGCLASS_LOCAL_HOSPITAL','BUILDING_LOCAL_HOSPITAL','TXT_KEY_BUILDING_LOCAL_HOSPITAL' ;   --ҽ��

INSERT INTO Buildings (Type, BuildingClass,	Description,Help,Cost,NukeImmune,IconAtlas,PortraitIndex,ConquestProb)
SELECT 'BUILDING_LOCAL_HOSPITAL','BUILDINGCLASS_LOCAL_HOSPITAL','TXT_KEY_BUILDING_LOCAL_HOSPITAL','TXT_KEY_BUILDING_LOCAL_HOSPITAL_HELP',-1,1,'ROBOT_ICON_ATLAS3',221,100 ;			

		
INSERT INTO Building_YieldModifiers (BuildingType, YieldType,Yield)
SELECT 'BUILDING_LOCAL_HOSPITAL','YIELD_SCIENCE',15 ;   --ҽ��


-----------------------------------------------------------------------------------------------------
--Buildings  �������趨
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
SELECT     'BUILDING_HEALTH_BUREAU',	          'BUILDINGCLASS_UNIVERSITY',	   'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_HEALTH_BUREAU',	          'BUILDINGCLASS_WATER_TREATMENT_FACTORY',	   'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_HEALTH_BUREAU',	          'BUILDINGCLASS_SMALL_MARKET',	   'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_HEALTH_BUREAU',	          'BUILDINGCLASS_HOSPITAL',   'YIELD_HEALTH',	  1 ; 

-----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS BuildingClass_HealthYields (BuildingClassType TEXT DEFAULT NULL, Yield INTEGER DEFAULT 0);

INSERT INTO BuildingClass_HealthYields (BuildingClassType,	Yield)
SELECT 'BUILDINGCLASS_GARMENT_WORKSHOP',				     -2 UNION ALL   --��֯��
SELECT 'BUILDINGCLASS_CENTERS',				                 5 UNION ALL   --����
SELECT 'BUILDINGCLASS_ORE_REFINERIES',				         -5 UNION ALL   --��ұ��
SELECT 'BUILDINGCLASS_COOKED_MEDICINE',				         5 UNION ALL   --��ҩ��
SELECT 'BUILDINGCLASS_PRIVATE_PHARMACY',				     3 UNION ALL   --˽��ҩ��
SELECT 'BUILDINGCLASS_BIOLOGICAL_FACTORIES',				 3 UNION ALL   --�����Ƽ�����
SELECT 'BUILDINGCLASS_LOCAL_HOSPITAL',						 4 UNION ALL   --ҽ��
SELECT 'BUILDINGCLASS_STABLE',								-1 UNION ALL   --���
SELECT 'BUILDINGCLASS_STONE_WORKS',							-1 UNION ALL   --ʯ����
SELECT 'BUILDINGCLASS_CIRCUS',								-1 UNION ALL   --��Ϸ��
SELECT 'BUILDINGCLASS_FORGE',								-1 UNION ALL   --������
SELECT 'BUILDINGCLASS_WORKSHOP',							-1 UNION ALL   --����
SELECT 'BUILDINGCLASS_IRONWORKS',							-2 UNION ALL   --������
SELECT 'BUILDINGCLASS_COLOSSEUM',							-1 UNION ALL   --������
SELECT 'BUILDINGCLASS_THEATRE',								-1 UNION ALL   --���Ժ
SELECT 'BUILDINGCLASS_HARBOR',								-2 UNION ALL   --����
SELECT 'BUILDINGCLASS_SEAPORT',								-2 UNION ALL   --�ۿ�
SELECT 'BUILDINGCLASS_FACTORY',								-8 UNION ALL   --����
SELECT 'BUILDINGCLASS_AIRPORT',								-3 UNION ALL   --����
SELECT 'BUILDINGCLASS_TOURIST_CENTER',						-3 UNION ALL   --��������
SELECT 'BUILDINGCLASS_GRANARY',								 1 UNION ALL	   --����
SELECT 'BUILDINGCLASS_WINDMILL',							1 UNION ALL	    --�糵
SELECT 'BUILDINGCLASS_GARDEN',								1 UNION ALL	    --��԰
SELECT 'BUILDINGCLASS_UNIVERSITY',							2 UNION ALL	    --��ѧ
SELECT 'BUILDINGCLASS_RECYCLING_CENTER',					2 UNION ALL	    --��������
SELECT 'BUILDINGCLASS_HOSPITAL',							5 UNION ALL	   --ҽԺ
SELECT 'BUILDINGCLASS_MEDICAL_LAB',							5 UNION ALL	   --ҽѧʵ����
SELECT 'BUILDINGCLASS_WELL',							    1 UNION ALL    --ˮ��
SELECT 'BUILDINGCLASS_HERBALIST',							2 UNION ALL	   --��ҩ��
SELECT 'BUILDINGCLASS_STEEL_MILL',							-3 UNION ALL	--��ֵ��Ӧ��
SELECT 'BUILDINGCLASS_WATER_TREATMENT_FACTORY',				3 UNION ALL     --��ˮ����
SELECT 'BUILDINGCLASS_COAL_COMPANY',					    -5 UNION ALL    --������  
SELECT 'BUILDINGCLASS_OIL_REFINERY',					    -5 UNION ALL    --ʯ�;���
SELECT 'BUILDINGCLASS_GAS_PLANT',					        -2 UNION ALL    --ȼ������վ
SELECT 'BUILDINGCLASS_OIL_PLANT',					        -3 UNION ALL    --ȼ�ͷ���վ
SELECT 'BUILDINGCLASS_COAL_PLANT',					        -5 UNION ALL    --ȼú����վ
SELECT 'BUILDINGCLASS_COAL_PLANT_EXTEND',					-3 UNION ALL    --ȼú���䷢��վ
SELECT 'BUILDINGCLASS_TAP_WATER_SUPPLY',					2 UNION ALL     --����ˮϵͳ
SELECT 'BUILDINGCLASS_INLAND_CANAL',					    -1 UNION ALL    --��½�˺�	
SELECT 'BUILDINGCLASS_NATIONAL_HOSPITAL',					20 UNION ALL    --��������ѧ����
SELECT 'BUILDINGCLASS_GENE_THERAPY',					    4 UNION ALL     --����ʵ����	
SELECT 'BUILDINGCLASS_TITANIUM_FACTORY',					-10 UNION ALL    --�Ͻ����쳧
SELECT 'BUILDINGCLASS_BIOFACTORY',					    3 UNION ALL     --��̬ѧ����
SELECT 'BUILDINGCLASS_CLOACA',					            2 UNION ALL		--��ˮ��
SELECT 'BUILDINGCLASS_BALNEAE',					            1 UNION ALL		--����ԡ��
SELECT 'BUILDINGCLASS_ALCHEMIST',					        -1 UNION ALL	--��������
SELECT 'BUILDINGCLASS_IRON_PROVIDER',					    -1 UNION ALL	--ұ����
SELECT 'BUILDINGCLASS_DESERT_TRANSFORMING_BASE',			3 UNION ALL	    --ɳĮ����  
SELECT 'BUILDINGCLASS_UNDERGROUND',			                -2 UNION ALL	--���³���
SELECT 'BUILDINGCLASS_PONTDUGARD',			                3 UNION ALL	    --�Ӷ���   
SELECT 'BUILDINGCLASS_MEDICAL_COMPANY',						6 UNION ALL     --ҽҩ��˾
SELECT 'BUILDINGCLASS_MARKOV',						    -10 UNION ALL     --����Ʒ� 
SELECT 'BUILDINGCLASS_INDUSTRIAL_ZONE',						-15 UNION ALL     --³����ҵ��
SELECT 'BUILDINGCLASS_GREAT_LIBRARY',						 3 UNION ALL     --��ͼ
------------------���й�ģ------------------------------
SELECT 'BUILDINGCLASS_CITY_SIZE_SMALL',					    -3 UNION ALL    --С����
SELECT 'BUILDINGCLASS_CITY_SIZE_MEDIUM',					-3 UNION ALL	--�г���
SELECT 'BUILDINGCLASS_CITY_SIZE_LARGE',					    -4 UNION ALL	--�����
SELECT 'BUILDINGCLASS_CITY_SIZE_XL',					    -4 UNION ALL    --�ش����
SELECT 'BUILDINGCLASS_CITY_SIZE_XXL',					    -6 UNION ALL	--���ͳ���
SELECT 'BUILDINGCLASS_CITY_SIZE_GLOBAL',					-8 UNION ALL	--�󶼻�
SELECT 'BUILDINGCLASS_LABORATORY',							3;              --ʵ����

---��������
INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield) 
SELECT	b.Type, 'YIELD_DISEASE', -h.Yield 
FROM Buildings AS b, BuildingClass_HealthYields AS h
WHERE b.BuildingClass = h.BuildingClassType AND h.Yield<0 AND b.Type!='BUILDING_AMERICA_RANCH';

---��������
INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield) 
SELECT	b.Type, 'YIELD_HEALTH', h.Yield 
FROM Buildings AS b, BuildingClass_HealthYields AS h
WHERE b.BuildingClass = h.BuildingClassType AND h.Yield>0 ;


---�Ӷ���
INSERT INTO Building_HealthMods (BuildingType, PlagueMod) 
SELECT 'BUILDING_PONTDUGARD',	15;  



--INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor) 
--SELECT	b.Type, 'FLAVOR_GROWTH', (h.Yield*5)
--FROM Buildings AS b, BuildingClass_HealthYields AS h
--WHERE b.BuildingClass = h.BuildingClassType;



---����ԡ��
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
------------------���й�ģ------------------------------
SELECT 'BUILDINGCLASS_CITY_SIZE_SMALL',					         -10 UNION ALL    --С����
SELECT 'BUILDINGCLASS_CITY_SIZE_MEDIUM',					     -10 UNION ALL	--�г���
SELECT 'BUILDINGCLASS_CITY_SIZE_LARGE',					         -10 UNION ALL	--�����
SELECT 'BUILDINGCLASS_CITY_SIZE_XL',					         -15 UNION ALL    --�ش����
SELECT 'BUILDINGCLASS_CITY_SIZE_XXL',					         -20 UNION ALL	--���ͳ���
SELECT 'BUILDINGCLASS_CITY_SIZE_GLOBAL',					     -20 UNION ALL	--�󶼻�

SELECT 'BUILDINGCLASS_BIOLOGICAL_FACTORIES',				     10 UNION ALL   --�����Ƽ�����
SELECT 'BUILDINGCLASS_HEALTH_BUREAU',					         10 UNION ALL  --������
SELECT 'BUILDINGCLASS_TAP_WATER_SUPPLY',					     10 UNION ALL  --����ˮϵͳ
SELECT 'BUILDINGCLASS_HOSPITAL',								 10 UNION ALL  --ҽԺ
SELECT 'BUILDINGCLASS_THEME_PARK',								 10 UNION ALL  ---���⹫԰
SELECT 'BUILDINGCLASS_ORE_REFINERIES',						    -20 UNION ALL  ---��ұ��
SELECT 'BUILDINGCLASS_FACTORY',									-20 UNION ALL  --����
SELECT 'BUILDINGCLASS_NUCLEAR_PLANT',							-10 UNION ALL  --�˵�վ
SELECT 'BUILDINGCLASS_MEDICAL_LAB',								 15 UNION ALL   ---ҽѧʵ����
SELECT 'BUILDINGCLASS_HYDRO_PLANT',								 10 UNION ALL  --ˮ��վ
SELECT 'BUILDINGCLASS_STEEL_MILL',								-10 UNION ALL --��ֵ��Ӧ��
SELECT 'BUILDINGCLASS_WATER_TREATMENT_FACTORY',					 10 UNION ALL --��ˮ����
SELECT 'BUILDINGCLASS_OIL_REFINERY',					        -15 UNION ALL --ʯ�;���
SELECT 'BUILDINGCLASS_MINING_COMPANY',					        -20 UNION ALL --��ҵ��˾
SELECT 'BUILDINGCLASS_COAL_PLANT',					            -20 UNION ALL --ú̿��
SELECT 'BUILDINGCLASS_COAL_PLANT_EXTEND',					    -20 UNION ALL --ú��̿��
SELECT 'BUILDINGCLASS_COAL_COMPANY',					        -20 UNION ALL --ú��̿��
SELECT 'BUILDINGCLASS_GAS_PLANT',					            -10 UNION ALL --ȼ����
SELECT 'BUILDINGCLASS_OIL_PLANT',					            -15  ;        --ȼʯ�ͳ�; 


INSERT INTO BuildingClass_HealthModifiersGlobal (BuildingClassType,	Yield)
SELECT 'BUILDINGCLASS_CENTERS',						             20 UNION ALL  ---����
SELECT 'BUILDINGCLASS_COOKED_MEDICINE',						     20 UNION ALL  ---��ҩ��
SELECT 'BUILDINGCLASS_INDUSTRIAL_ZONE',					        -20 UNION ALL --³����ҵ��
SELECT 'BUILDINGCLASS_PONTDUGARD',					             20 UNION ALL    --�Ӷ���
SELECT 'BUILDINGCLASS_NATIONAL_HOSPITAL',					     50 ;   --��������ѧ����



-----------------------------------------------------------------------------------------------------------------------
---��������
-----------------------------------------------------------------------------------------------------------------------
---���ؼӳ�
INSERT INTO  Building_YieldModifiers(BuildingType, YieldType, Yield) 
SELECT	b.Type, 'YIELD_DISEASE', -h.Yield 
FROM Buildings AS b,  BuildingClass_HealthModifiers AS h
WHERE b.BuildingClass = h.BuildingClassType AND h.Yield<0 ;

---ȫ�ּӳ�
INSERT INTO Building_GlobalYieldModifiers(BuildingType, YieldType, Yield) 
SELECT	b.Type, 'YIELD_DISEASE', -h.Yield 
FROM Buildings AS b,  BuildingClass_HealthModifiersGlobal AS h
WHERE b.BuildingClass = h.BuildingClassType AND h.Yield<0 ;

-----------------------------------------------------------------------------------------------------------------------
---��������
-----------------------------------------------------------------------------------------------------------------------
---���ؼӳ�
INSERT INTO Building_YieldModifiers(BuildingType, YieldType, Yield) 
SELECT	b.Type, 'YIELD_HEALTH', h.Yield 
FROM Buildings AS b, BuildingClass_HealthModifiers AS h
WHERE b.BuildingClass = h.BuildingClassType AND h.Yield>0 ;

---ȫ�ּӳ�
INSERT INTO Building_GlobalYieldModifiers(BuildingType, YieldType, Yield) 
SELECT	b.Type, 'YIELD_HEALTH', h.Yield 
FROM Buildings AS b,  BuildingClass_HealthModifiersGlobal AS h
WHERE b.BuildingClass = h.BuildingClassType AND h.Yield>0 ;
----------------------------------------------------------------------------------------------------------------------

INSERT INTO Building_SpecialistYieldChangesLocal(BuildingType,	SpecialistType,	YieldType,	  Yield)
SELECT     'BUILDING_HEALTH_BUREAU',	          'SPECIALIST_DOCTOR',	   'YIELD_HEALTH',	  1  ;

---��������Դ����
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



---�����������ʩ����
INSERT INTO Policy_ImprovementYieldChanges(PolicyType,	ImprovementType,		YieldType,	  Yield)
SELECT     'POLICY_INDUSTRY_FINISHER',	             'IMPROVEMENT_QUARRY',	  'YIELD_HEALTH',	  1 ;



---�������˿ڲ���
INSERT INTO Building_YieldChangesPerPop(BuildingType,	YieldType,	  Yield)
SELECT     'BUILDING_PRIVATE_PHARMACY',	        	     'YIELD_HEALTH',	  10 UNION ALL
SELECT     'BUILDING_PRIVATE_PHARMACY',	        	     'YIELD_GOLD',	      10 UNION ALL

SELECT     'BUILDING_HOSPITAL',	        	             'YIELD_HEALTH',	  15 UNION ALL
SELECT     'BUILDING_HERBALIST',	        	         'YIELD_HEALTH',	  10 UNION ALL
SELECT     'BUILDING_PONTDUGARD',	                     'YIELD_HEALTH',	  25 ;

---�������������
INSERT INTO Building_RiverPlotYieldChanges(BuildingType,	YieldType,	  Yield)
SELECT     'BUILDING_HANGING_GARDEN',	    'YIELD_HEALTH',	  1  ;



---�������������
INSERT INTO Building_LakePlotYieldChanges(BuildingType,	YieldType,	  Yield)
SELECT     'BUILDING_ZHENGGUOQU',	    'YIELD_HEALTH',	  2  ;


---��������β���
INSERT INTO Building_TerrainYieldChanges (BuildingType,	TerrainType,			YieldType,	  Yield)
SELECT     'BUILDING_COOKED_MEDICINE',	         'TERRAIN_SNOW',	                'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	         'TERRAIN_TUNDRA',	                'YIELD_HEALTH',	  1 UNION ALL

SELECT     'BUILDING_DESERT_TRANSFORMING_BASE',	 'TERRAIN_DESERT',	                'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_PETRA',	                 'TERRAIN_DESERT',	                'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_BIOFACTORY',	         'TERRAIN_TUNDRA',	                'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_BIOFACTORY',	         'TERRAIN_SNOW',	                'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_PONTDUGARD',	             'TERRAIN_PLAINS',	                'YIELD_HEALTH',	  1 ;




---�������ò����
INSERT INTO Building_FeatureYieldChanges (BuildingType,	FeatureType,			YieldType,		Yield)
SELECT     'BUILDING_DESERT_TRANSFORMING_BASE',	'FEATURE_OASIS',	         'YIELD_HEALTH',	  1 ;

--�Ӷ���
INSERT INTO Building_FeatureYieldChanges
		(BuildingType, 			FeatureType, 	YieldType, 		Yield)
SELECT 	'BUILDING_PONTDUGARD', 	Type,		'YIELD_HEALTH', 	1
FROM Features WHERE NaturalWonder = '1' OR PseudoNaturalWonder = '1';



---����������������
INSERT INTO Building_BuildingClassYieldChanges (BuildingType,	BuildingClassType,			YieldType,		YieldChange)
SELECT     'BUILDING_COOKED_MEDICINE',	'BUILDINGCLASS_HERBALIST',	                     'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	'BUILDINGCLASS_VINYARD',	                     'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_COOKED_MEDICINE',	'BUILDINGCLASS_PRIVATE_PHARMACY',	             'YIELD_HEALTH',      1 UNION ALL


SELECT     'BUILDING_BIOLOGICAL_FACTORIES',	'BUILDINGCLASS_HOSPITAL',	                    'YIELD_HEALTH',	  3 UNION ALL
SELECT     'BUILDING_BIOLOGICAL_FACTORIES',	'BUILDINGCLASS_BIO_LAB',	                    'YIELD_HEALTH',	  3 UNION ALL

SELECT     'BUILDING_LOCAL_HOSPITAL',	'BUILDINGCLASS_CITY_SIZE_SMALL',	                'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_LOCAL_HOSPITAL',	'BUILDINGCLASS_CITY_SIZE_MEDIUM',	                'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_LOCAL_HOSPITAL',	'BUILDINGCLASS_CITY_SIZE_LARGE',	                'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_LOCAL_HOSPITAL',	'BUILDINGCLASS_CITY_SIZE_XL',	                    'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_LOCAL_HOSPITAL',	'BUILDINGCLASS_CITY_SIZE_XXL',	                    'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_LOCAL_HOSPITAL',	'BUILDINGCLASS_CITY_SIZE_GLOBAL',	                'YIELD_HEALTH',	  3 UNION ALL

SELECT     'BUILDING_PONTDUGARD',	'BUILDINGCLASS_BALNEAE',	                'YIELD_HEALTH',	  1 UNION ALL
SELECT     'BUILDING_PONTDUGARD',	'BUILDINGCLASS_AQUEDUCT',	                'YIELD_HEALTH',	  3 UNION ALL

SELECT     'BUILDING_NATIONAL_HOSPITAL',	'BUILDINGCLASS_MEDICAL_LAB',	                'YIELD_HEALTH',	  2 UNION ALL
SELECT     'BUILDING_NATIONAL_HOSPITAL',	'BUILDINGCLASS_HOSPITAL',	                    'YIELD_HEALTH',	  1;





