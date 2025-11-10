--==========================================================================================================================
-- POLICIES
--==========================================================================================================================

--CREATE TABLE IF NOT EXISTS Policy_CityYieldPerXPopChanges (PolicyType TEXT DEFAULT NULL,YieldType TEXT DEFAULT NULL, Yield INTEGER DEFAULT 0);




INSERT INTO Policy_ImprovementYieldChanges (PolicyType,	ImprovementType,YieldType,			Yield)
SELECT 'POLICY_KNOWLEDGE_6','IMPROVEMENT_PLANTATION',	'YIELD_HEALTH',		2 ;

INSERT INTO Policy_YieldChangesNaturalWonder(PolicyType,YieldType,			Yield)
SELECT 'POLICY_KNOWLEDGE_6','YIELD_HEALTH',		2 ;


INSERT INTO Policy_CityYieldChanges (PolicyType,	YieldType,			Yield)
SELECT 'POLICY_REPUBLIC',	'YIELD_HEALTH',		2;

CREATE TABLE IF NOT EXISTS PolicyBranch_Health (PolicyBranchType TEXT DEFAULT NULL, Yield INTEGER DEFAULT 0);

INSERT INTO PolicyBranch_Health (PolicyBranchType,	Yield)
SELECT 'POLICY_BRANCH_EXPLORATION',					-1 UNION ALL	
SELECT 'POLICY_BRANCH_RATIONALISM',					1;

INSERT INTO Policy_YieldModifiers (PolicyType, YieldType, Yield) 
SELECT	Type, 'YIELD_HEALTH', 5 
FROM Policies
WHERE Type LIKE 'POLICY_UNIVERSAL_HEALTHCARE%';

--INSERT INTO Policy_CapitalYieldPerPopChanges (PolicyType,	YieldType,			Yield)
--SELECT 'POLICY_OLIGARCHY',									'YIELD_HEALTH',		20;

INSERT INTO Policy_BuildingClassYieldChanges (PolicyType,	BuildingClassType,			YieldType,			YieldChange)
SELECT 'POLICY_FREE_RELIGION',								'BUILDINGCLASS_SHRINE',	'YIELD_HEALTH',		1	UNION ALL
SELECT 'POLICY_FREE_RELIGION',								'BUILDINGCLASS_TEMPLE',	'YIELD_HEALTH',		1	UNION ALL


SELECT 'POLICY_STATECRAFT',								    'BUILDINGCLASS_LIBRARY',	'YIELD_HEALTH',		1	UNION ALL
SELECT 'POLICY_STATECRAFT',							        'BUILDINGCLASS_UNIVERSITY',	'YIELD_HEALTH',		1	UNION ALL
SELECT 'POLICY_STATECRAFT',							        'BUILDINGCLASS_PUBLIC_SCHOOL',	'YIELD_HEALTH',	1	UNION ALL

SELECT 'POLICY_DISCIPLINE',							        'BUILDINGCLASS_ARMORY',	'YIELD_HEALTH',	1	UNION ALL
SELECT 'POLICY_DISCIPLINE',								    'BUILDINGCLASS_BARRACKS','YIELD_HEALTH',		1;






INSERT INTO Policy_BuildingClassYieldModifiers (PolicyType,	BuildingClassType,			YieldType,		YieldMod)
SELECT 'POLICY_AI_REDUCE',	                            'BUILDINGCLASS_GAS_PLANT', 'YIELD_DISEASE', -10  UNION ALL
SELECT 'POLICY_AI_REDUCE',	                            'BUILDINGCLASS_COAL_COMPANY', 'YIELD_DISEASE', -10  UNION ALL
SELECT 'POLICY_AI_REDUCE',	                            'BUILDINGCLASS_COAL_PLANT_EXTEND', 'YIELD_DISEASE', -10  UNION ALL
SELECT 'POLICY_AI_REDUCE',	                            'BUILDINGCLASS_COAL_PLANT', 'YIELD_DISEASE', -10  UNION ALL
SELECT 'POLICY_AI_REDUCE',	                            'BUILDINGCLASS_MINING_COMPANY', 'YIELD_DISEASE', -10  UNION ALL
SELECT 'POLICY_AI_REDUCE',	                            'BUILDINGCLASS_OIL_REFINERY', 'YIELD_DISEASE', -10  UNION ALL
SELECT 'POLICY_AI_REDUCE',	                            'BUILDINGCLASS_STEEL_MILL', 'YIELD_DISEASE', -10  UNION ALL
SELECT 'POLICY_AI_REDUCE',	                            'BUILDINGCLASS_NUCLEAR_PLANT', 'YIELD_DISEASE', -10  UNION ALL
SELECT 'POLICY_AI_REDUCE',	                            'BUILDINGCLASS_FACTORY', 'YIELD_DISEASE', -10  UNION ALL
SELECT 'POLICY_AI_REDUCE',	                            'BUILDINGCLASS_ORE_REFINERIES', 'YIELD_DISEASE', -5  ;

--SELECT 'POLICY_STATECRAFT',								'BUILDINGCLASS_LIBRARY',	'YIELD_HEALTH',		1	UNION ALL
--SELECT 'POLICY_MERITOCRACY',							'BUILDINGCLASS_LIBRARY',	'YIELD_HEALTH',		2;



-----------------------------------------------------------------------------------------------------
--Tooltip Addenda
----------------------------------------------------------------------------------------------------- 


UPDATE LocalizedText
SET Text = Text||'[NEWLINE][ICON_BULLET]每座城市+2[ICON_HEALTH]健康度。'
WHERE Tag IN (SELECT Help FROM Policies WHERE Type='POLICY_REPUBLIC');

--UPDATE LocalizedText
	--SET Text = Text||'消除因城市未临近淡水带来的[ICON_HEALTH]健康度惩罚。'
	--WHERE Tag IN (SELECT Help FROM Buildings WHERE AddsFreshWater = 1);


-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
CREATE TABLE Temp (Key text, Value text);

INSERT INTO Temp (Key, Value)
SELECT	p.Help, h.Yield
FROM PolicyBranchTypes AS p, PolicyBranch_Health AS h
WHERE p.Type = h.PolicyBranchType;

UPDATE LocalizedText
	SET Text = Text||'[NEWLINE][NEWLINE]每个已采纳的政策提升[ICON_HEALTH]健康度'||(SELECT Value FROM Temp WHERE Tag = Temp.Key)||'%。'
	WHERE Tag IN (SELECT Key FROM Temp);

DROP TABLE Temp;
-----------------------------------------------------------------------------------------------------
CREATE TABLE Temp (Key text, Value text);

INSERT INTO Temp (Key, Value)
SELECT	p.Help, h.Yield
FROM Policies AS p, Policy_YieldModifiers AS h
WHERE p.Type = h.PolicyType AND h.YieldType = 'YIELD_HEALTH';

UPDATE LocalizedText
	SET Text = Text||'[NEWLINE]+'||(SELECT Value FROM Temp WHERE Tag = Temp.Key)||'%'||'[ICON_HEALTH]健康度。'
	WHERE Tag IN (SELECT Key FROM Temp);

DROP TABLE Temp;
-----------------------------------------------------------------------------------------------------
CREATE TABLE Temp (Key text, Value integer);

INSERT INTO Temp (Key, Value)
SELECT	p.Help, ROUND(100/h.Yield)
FROM Policies AS p, Policy_CapitalYieldPerPopChanges AS h
WHERE p.Type = h.PolicyType AND h.YieldType = 'YIELD_HEALTH';

UPDATE LocalizedText
	SET Text = Text||'[NEWLINE][ICON_CAPITAL]首都每'||(SELECT Value FROM Temp WHERE Tag = Temp.Key)||'[ICON_CITIZEN]市民+1[ICON_HEALTH]健康度。'
	WHERE Tag IN (SELECT Key FROM Temp);

DROP TABLE Temp;
-----------------------------------------------------------------------------------------------------

CREATE TABLE Temp (Key text, Value text, Building text);

INSERT INTO Temp (Key, Value, Building)
SELECT	p.Help, h.YieldMod, h.BuildingClassType
FROM Policies AS p, Policy_BuildingClassYieldModifiers AS h
WHERE p.Type = h.PolicyType AND h.YieldType = 'YIELD_HEALTH';




UPDATE Temp SET Building = (SELECT Description FROM BuildingClasses WHERE Building = Type);
UPDATE Temp SET Building = (SELECT Text FROM Language_zh_CN WHERE Building = Tag);

--UPDATE LocalizedText
--	SET Text = Text||'[NEWLINE]每个'||(SELECT Building FROM Temp WHERE Tag = Temp.Key)||'+'||(SELECT Value FROM Temp WHERE Tag = Temp.Key)||'%'||'[ICON_HEALTH]健康度。'
--	WHERE Tag IN (SELECT Key FROM Temp);

DROP TABLE Temp;

-----------------------------------------------------------------------------------------------------
--Compatibility
----------------------------------------------------------------------------------------------------- 
ALTER TABLE Buildings ADD IsVisible boolean DEFAULT 1;
----------------------------------------------------------------------------------------------------- 
CREATE TRIGGER HealthPlagueMod_01
AFTER INSERT ON Buildings
WHEN 'BUILDINGCLASS_AQUEDUCT' = NEW.BuildingClass
BEGIN
	UPDATE Buildings SET AddsFreshWater = 1
	WHERE NEW.BuildingClass = 'BUILDINGCLASS_AQUEDUCT';
END;
--------------------------------------------------------------------------------------------------
CREATE TRIGGER HealthPlagueMod_02
AFTER INSERT ON Buildings
WHEN 'BUILDINGCLASS_HOSPITAL' = NEW.BuildingClass OR 'BUILDINGCLASS_MEDICAL_LAB' = NEW.BuildingClass
BEGIN
	UPDATE Buildings SET SpecialistType = 'SPECIALIST_DOCTOR', SpecialistCount = 3 
	WHERE NEW.BuildingClass = 'BUILDINGCLASS_HOSPITAL';

	UPDATE Buildings SET SpecialistType = 'SPECIALIST_DOCTOR', SpecialistCount = 3 
	WHERE NEW.BuildingClass = 'BUILDINGCLASS_MEDICAL_LAB';
END;
--------------------------------------------------------------------------------------------------
CREATE TRIGGER HealthPlagueMod_03
AFTER INSERT ON Buildings
WHEN EXISTS (SELECT BuildingClassType FROM BuildingClass_HealthYields WHERE BuildingClassType = NEW.BuildingClass)
BEGIN
	INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield) 
	SELECT	NEW.Type, 'YIELD_HEALTH', h.Yield 
	FROM BuildingClass_HealthYields AS h
	WHERE NEW.BuildingClass = h.BuildingClassType;

	--INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor) 
	--SELECT	NEW.Type, 'FLAVOR_GROWTH', (h.Yield*5)
	--FROM BuildingClass_HealthYields AS h
	--WHERE NEW.BuildingClass = h.BuildingClassType;
END;
--------------------------------------------------------------------------------------------------
CREATE TRIGGER HealthPlagueMod_04
AFTER INSERT ON Buildings
WHEN EXISTS (SELECT BuildingClassType FROM BuildingClass_HealthModifiers WHERE BuildingClassType = NEW.BuildingClass)
BEGIN
	INSERT INTO Building_YieldModifiers (BuildingType, YieldType, Yield) 
	SELECT	NEW.Type, 'YIELD_HEALTH', h.Yield 
	FROM BuildingClass_HealthModifiers AS h
	WHERE NEW.BuildingClass = h.BuildingClassType;

	--INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor) 
	--SELECT	NEW.Type, 'FLAVOR_GROWTH', (h.Yield*3)
	--FROM BuildingClass_HealthModifiers AS h
	--WHERE NEW.BuildingClass = h.BuildingClassType;
END;
-----------------------------------------------------------------------------------------------------
