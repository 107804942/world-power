--==========================================================================================================================
-- POLICIES
--==========================================================================================================================
INSERT  INTO Policy_YieldModifierFromActiveSpies(PolicyType,YieldType ,Yield)VALUES
('POLICY_KNOWLEDGE_5','YIELD_CRIME',-4);


INSERT INTO Policy_CityYieldChanges (PolicyType,	YieldType,			Yield)
SELECT 'POLICY_INDUSTRY_5',	'YIELD_CRIME',		-2  UNION ALL
SELECT 'POLICY_MERITOCRACY',	'YIELD_CRIME',		-5  UNION ALL
SELECT 'POLICY_LEGALISM',	'YIELD_CRIME',		-5  UNION ALL
SELECT 'POLICY_TRADITION_LOYALTY',	'YIELD_CRIME',		-5;

---首都人口加成
INSERT INTO  Policy_CapitalYieldPerPopChanges(PolicyType,	YieldType,			Yield)
SELECT 'POLICY_MONARCHY',	'YIELD_CRIME',		-34;
------------------------------------------------------------------------------------------------------------------------
-- 建筑种类百分比产出
------------------------------------------------------------------------------------------------------------------------
INSERT INTO Policy_BuildingClassYieldModifiers(PolicyType,	BuildingClassType,YieldType,YieldMod)
SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_SEAPORT','YIELD_CRIME',-5 UNION ALL
SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_SHIPYARD','YIELD_CRIME',-5 UNION ALL
SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_LIGHTHOUSE','YIELD_CRIME',-3 UNION ALL
SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_HARBOR','YIELD_CRIME',-3 UNION ALL
SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_WOOD_DOCK','YIELD_CRIME',-3 UNION ALL

SELECT 'POLICY_DISCIPLINE','BUILDINGCLASS_BARRACKS',		'YIELD_CRIME',		 -2 UNION ALL   --兵营
SELECT 'POLICY_DISCIPLINE','BUILDINGCLASS_ARMORY',		'YIELD_CRIME',		 -2 UNION ALL    --军械所
SELECT 'POLICY_DISCIPLINE','BUILDINGCLASS_CASTLE',		'YIELD_CRIME',		 -2 UNION ALL   --城堡
SELECT 'POLICY_DISCIPLINE','BUILDINGCLASS_ARSENAL',		'YIELD_CRIME',		 -2 UNION ALL   --兵工厂
SELECT 'POLICY_DISCIPLINE','BUILDINGCLASS_MILITARY_BASE',		'YIELD_CRIME',		 -2 UNION ALL   --军事基地

SELECT 'POLICY_TRADITION_LOYALTY','BUILDINGCLASS_JAIL',	'YIELD_CRIME',		-2 UNION ALL    --小城市
SELECT 'POLICY_TRADITION_LOYALTY','BUILDINGCLASS_DUNGEON',	'YIELD_CRIME',		-2 UNION ALL    --小城市
SELECT 'POLICY_TRADITION_LOYALTY','BUILDINGCLASS_COURTHOUSE',	'YIELD_CRIME',		-2 UNION ALL    --小城市
SELECT 'POLICY_TRADITION_LOYALTY','BUILDINGCLASS_CONSTABLE',	'YIELD_CRIME',		-2 UNION ALL    --小城市
SELECT 'POLICY_TRADITION_LOYALTY','BUILDINGCLASS_SHERIFF_OFFICE',	'YIELD_CRIME',		-2 UNION ALL    --小城市
SELECT 'POLICY_TRADITION_LOYALTY','BUILDINGCLASS_POLICE_STATION',	'YIELD_CRIME',		-2 UNION ALL    --小城市
SELECT 'POLICY_TRADITION_LOYALTY','BUILDINGCLASS_PROCURATORATE',	'YIELD_CRIME',		-2 ;   --小城市

------------------------------------------------------------------------------------------------------------------------
-- 建筑种类基础产出
------------------------------------------------------------------------------------------------------------------------
INSERT INTO Policy_BuildingClassYieldChanges(PolicyType,	BuildingClassType, YieldType,YieldChange)
SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_SEAPORT','YIELD_CRIME',-4 UNION ALL
SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_SHIPYARD','YIELD_CRIME',-4 UNION ALL
SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_LIGHTHOUSE','YIELD_CRIME',-4 UNION ALL
SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_HARBOR','YIELD_CRIME',-4 UNION ALL
SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_WOOD_DOCK','YIELD_CRIME',-4 UNION ALL

SELECT 'POLICY_KNOWLEDGE_5', 'BUILDINGCLASS_DUNGEON' ,'YIELD_CRIME',-2 UNION ALL  --情报网络
SELECT 'POLICY_KNOWLEDGE_5', 'BUILDINGCLASS_LOCKUP' ,'YIELD_CRIME',-2 UNION ALL
SELECT 'POLICY_KNOWLEDGE_5', 'BUILDINGCLASS_POLICE_STATION' ,'YIELD_CRIME',-2 UNION ALL

SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_SHRINE',	'YIELD_CRIME',		-1 UNION ALL    ---道德经
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_TEMPLE',	'YIELD_CRIME',		-1 UNION ALL   
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_CATHEDRAL',	'YIELD_CRIME',		-1 UNION ALL    
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_MOSQUE',	'YIELD_CRIME',		-1 UNION ALL    
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_PAGODA',	'YIELD_CRIME',		-1 UNION ALL   
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_MONASTERY',	'YIELD_CRIME',		-1 UNION ALL    
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_INQUISITION',	'YIELD_CRIME',		-1 UNION ALL    


SELECT 'POLICY_TRADITION_LOYALTY','BUILDINGCLASS_CARAVANSARY',	'YIELD_CRIME',		-3 UNION ALL    --客栈
SELECT 'POLICY_TRADITION_LOYALTY','BUILDINGCLASS_MARKET',	'YIELD_CRIME',		-3 UNION ALL    --市场
SELECT 'POLICY_TRADITION_LOYALTY','BUILDINGCLASS_BANK',	'YIELD_CRIME',		-3 UNION ALL    --银行
SELECT 'POLICY_TRADITION_LOYALTY','BUILDINGCLASS_STOCK_EXCHANGE',	'YIELD_CRIME',		-3 UNION ALL    --证交所
SELECT 'POLICY_TRADITION_LOYALTY','BUILDINGCLASS_FINANCE_COMPANY',	'YIELD_CRIME',		-3 ;     --金融公司


------------------------------------------------------------------------------------------------------------------------
-- 爱领袖日加成
------------------------------------------------------------------------------------------------------------------------
INSERT  INTO Policy_CityLoveKingDayYieldMod(PolicyType,YieldType,Yield)VALUES
('POLICY_GRANDEUR_4', 'YIELD_CRIME',-25);


------------------------------------------------------------------------------------------------------------------------
-- 全局加成
------------------------------------------------------------------------------------------------------------------------
INSERT INTO Policy_YieldModifiers (PolicyType, YieldType, Yield)
SELECT 'POLICY_AI_REDUCE',	'YIELD_CRIME',		-50  UNION ALL   --ai
SELECT 'POLICY_RELIGIOUS_POLITICS',	'YIELD_CRIME',		-10;     --教法社会

------------------------------------------------------------------------------------------------------------------------
-- 城市数量全局加成
------------------------------------------------------------------------------------------------------------------------
INSERT INTO Policy_CityNumberCityYieldModifier(PolicyType, YieldType, Yield)
SELECT 'POLICY_REPUBLIC',	'YIELD_CRIME',		-1;     --教法社会
-----------------------------------------------------------------------------------------------------
--Tooltip Addenda
----------------------------------------------------------------------------------------------------- 
UPDATE LocalizedText
	SET Text = Text||'[NEWLINE][ICON_BULLET]全局[ICON_CRIME]犯罪率-10%。'
	WHERE Tag IN (SELECT Help FROM Policies WHERE Type = 'POLICY_RELIGIOUS_POLITICS');

UPDATE LocalizedText
	SET Text = Text||'[NEWLINE][ICON_BULLET]每座城市-5[ICON_CRIME]犯罪率。'
	WHERE Tag IN (SELECT Help FROM Policies WHERE Type = 'POLICY_LEGALISM');


UPDATE LocalizedText
	SET Text = Text||'[NEWLINE][ICON_BULLET]每个兵营、军械所、城堡、兵工厂、军事基地-2%[ICON_CRIME]犯罪率。'
	WHERE Tag IN (SELECT Help FROM Policies WHERE Type = 'POLICY_DISCIPLINE');

UPDATE LocalizedText
	SET Text = Text||'[NEWLINE][ICON_BULLET]每座城市-1%[ICON_CRIME]全局犯罪率。'
	WHERE Tag IN (SELECT Help FROM Policies WHERE Type = 'POLICY_REPUBLIC');
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
CREATE TABLE Temp (Key text, Value text);

INSERT INTO Temp (Key, Value)
SELECT	p.Help, h.Yield
FROM PolicyBranchTypes AS p, PolicyBranch_Health AS h
WHERE p.Type = h.PolicyBranchType;

UPDATE Language_zh_CN
	SET Text = Text||'[NEWLINE][NEWLINE]每个已采纳的政策提升[ICON_HEALTH]健康度'||(SELECT Value FROM Temp WHERE Tag = Temp.Key)||'%。'
	WHERE Tag IN (SELECT Key FROM Temp);

DROP TABLE Temp;
-----------------------------------------------------------------------------------------------------
CREATE TABLE Temp (Key text, Value text);

INSERT INTO Temp (Key, Value)
SELECT	p.Help, h.Yield
FROM Policies AS p, Policy_YieldModifiers AS h
WHERE p.Type = h.PolicyType AND h.YieldType = 'YIELD_HEALTH';

UPDATE Language_zh_CN
	SET Text = Text||'[NEWLINE]+'||(SELECT Value FROM Temp WHERE Tag = Temp.Key)||'%'||'[ICON_HEALTH]健康度。'
	WHERE Tag IN (SELECT Key FROM Temp);

DROP TABLE Temp;
-----------------------------------------------------------------------------------------------------
CREATE TABLE Temp (Key text, Value integer);

INSERT INTO Temp (Key, Value)
SELECT	p.Help, ROUND(100/h.Yield)
FROM Policies AS p, Policy_CapitalYieldPerPopChanges AS h
WHERE p.Type = h.PolicyType AND h.YieldType = 'YIELD_HEALTH';

UPDATE Language_zh_CN
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

UPDATE Language_zh_CN
	SET Text = Text||'[NEWLINE]每个'||(SELECT Building FROM Temp WHERE Tag = Temp.Key)||'+'||(SELECT Value FROM Temp WHERE Tag = Temp.Key)||'%'||'[ICON_HEALTH]健康度。'
	WHERE Tag IN (SELECT Key FROM Temp);

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
