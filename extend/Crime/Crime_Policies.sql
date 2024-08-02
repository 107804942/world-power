--==========================================================================================================================
-- POLICIES
--==========================================================================================================================
INSERT  INTO Policy_YieldModifierFromActiveSpies(PolicyType,YieldType ,Yield)VALUES
('POLICY_KNOWLEDGE_5','YIELD_CRIME',-4);


INSERT INTO Policy_CityYieldChanges (PolicyType,	YieldType,			Yield)
--SELECT 'POLICY_INDUSTRY_5',	'YIELD_CRIME',		-2  UNION ALL
--SELECT 'POLICY_MERITOCRACY',	'YIELD_CRIME',		-5  UNION ALL
SELECT 'POLICY_GRANDEUR',	'YIELD_CRIME',		-2  UNION ALL
SELECT 'POLICY_TRADITION_LOYALTY',	'YIELD_CRIME',		-2;

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
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_NATIONAL_SHRINE',		'YIELD_CRIME',		 -4 UNION ALL    --
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_GRAND_TEMPLE',		'YIELD_CRIME',		 -4 UNION ALL    --
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_HAGIA_SOPHIA',		'YIELD_CRIME',		 -4 UNION ALL   --
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_MOSQUE_OF_DJENNE',		    'YIELD_CRIME',		 -4 UNION ALL   --
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_ANGKOR_WAT',		'YIELD_CRIME',		 -4 UNION ALL   --
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_BOROBUDUR',		'YIELD_CRIME',		 -4 UNION ALL   --
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_NOTRE_DAME',		'YIELD_CRIME',		 -4 UNION ALL   --
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_SISTINE_CHAPEL',		'YIELD_CRIME',		 -4 UNION ALL   --

SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_SHRINE',	'YIELD_CRIME',		-1 UNION ALL    ---道德经
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_TEMPLE',	'YIELD_CRIME',		-1 UNION ALL   
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_CATHEDRAL',	'YIELD_CRIME',		-1 UNION ALL    
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_MOSQUE',	'YIELD_CRIME',		-1 UNION ALL    
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_PAGODA',	'YIELD_CRIME',		-1 UNION ALL   
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_MONASTERY',	'YIELD_CRIME',		-1 UNION ALL    
SELECT 'POLICY_ORGANIZED_RELIGION','BUILDINGCLASS_INQUISITION',	'YIELD_CRIME',		-1 UNION ALL    


SELECT 'POLICY_KNOWLEDGE','BUILDINGCLASS_CITY_SIZE_SMALL',		'YIELD_CRIME',		 -5 UNION ALL    --小城市
SELECT 'POLICY_KNOWLEDGE','BUILDINGCLASS_CITY_SIZE_MEDIUM',		'YIELD_CRIME',		 -5 UNION ALL    --中城市
SELECT 'POLICY_KNOWLEDGE','BUILDINGCLASS_CITY_SIZE_LARGE',		'YIELD_CRIME',		 -5 UNION ALL   --大城市
SELECT 'POLICY_KNOWLEDGE','BUILDINGCLASS_CITY_SIZE_XL',		    'YIELD_CRIME',		 -5 UNION ALL   --特大城市
SELECT 'POLICY_KNOWLEDGE','BUILDINGCLASS_CITY_SIZE_XXL',		'YIELD_CRIME',		 -5 UNION ALL   --巨型城市
SELECT 'POLICY_KNOWLEDGE','BUILDINGCLASS_CITY_SIZE_GLOBAL',		'YIELD_CRIME',		 -5 UNION ALL   --大都会

SELECT 'POLICY_DISCIPLINE','BUILDINGCLASS_BARRACKS',		'YIELD_CRIME',		 -3 UNION ALL   --兵营
SELECT 'POLICY_DISCIPLINE','BUILDINGCLASS_ARMORY',		'YIELD_CRIME',		 -3 UNION ALL    --军械所
SELECT 'POLICY_DISCIPLINE','BUILDINGCLASS_CASTLE',		'YIELD_CRIME',		 -3 UNION ALL   --城堡
SELECT 'POLICY_DISCIPLINE','BUILDINGCLASS_ARSENAL',		'YIELD_CRIME',		 -3 UNION ALL   --兵工厂
SELECT 'POLICY_DISCIPLINE','BUILDINGCLASS_MILITARY_BASE',		'YIELD_CRIME',		 -3 UNION ALL   --军事基地


SELECT 'POLICY_GRANDEUR_1','BUILDINGCLASS_CARAVANSARY',	'YIELD_CRIME',		-3  UNION ALL
SELECT 'POLICY_GRANDEUR_1','BUILDINGCLASS_MARKET',	'YIELD_CRIME',		-3  UNION ALL
SELECT 'POLICY_GRANDEUR_1','BUILDINGCLASS_BANK',	'YIELD_CRIME',		-3  UNION ALL
SELECT 'POLICY_GRANDEUR_1',	'BUILDINGCLASS_STOCK_EXCHANGE','YIELD_CRIME',		-3  UNION ALL
SELECT 'POLICY_GRANDEUR_1','BUILDINGCLASS_FINANCE_COMPANY',	'YIELD_CRIME',	-3 UNION ALL

SELECT 'POLICY_INDUSTRY_5','BUILDINGCLASS_CITY_SIZE_TOWN',	'YIELD_CRIME',		-2  UNION ALL
SELECT 'POLICY_MERITOCRACY','BUILDINGCLASS_CITY_SIZE_TOWN',	'YIELD_CRIME',		-5  UNION ALL
SELECT 'POLICY_LEGALISM',	'BUILDINGCLASS_CITY_SIZE_TOWN','YIELD_CRIME',		-5  UNION ALL
SELECT 'POLICY_TRADITION_LOYALTY','BUILDINGCLASS_CITY_SIZE_TOWN',	'YIELD_CRIME',	-5 UNION ALL

SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_SEAPORT','YIELD_CRIME',-4 UNION ALL
SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_SHIPYARD','YIELD_CRIME',-4 UNION ALL
SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_LIGHTHOUSE','YIELD_CRIME',-4 UNION ALL
SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_HARBOR','YIELD_CRIME',-4 UNION ALL
SELECT 'POLICY_COASTAL_ADMINISTRATION','BUILDINGCLASS_WOOD_DOCK','YIELD_CRIME',-4 UNION ALL

SELECT 'POLICY_KNOWLEDGE_5', 'BUILDINGCLASS_DUNGEON' ,'YIELD_CRIME',-2 UNION ALL  --情报网络
SELECT 'POLICY_KNOWLEDGE_5', 'BUILDINGCLASS_LOCKUP' ,'YIELD_CRIME',-2 UNION ALL
SELECT 'POLICY_KNOWLEDGE_5', 'BUILDINGCLASS_POLICE_STATION' ,'YIELD_CRIME',-2 UNION ALL


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
-- 人口加成
------------------------------------------------------------------------------------------------------------------------
INSERT  INTO Policy_YieldPerPopChanges(PolicyType,YieldType,Yield)VALUES
('POLICY_INDUSTRY', 'YIELD_CRIME',-20),
('POLICY_AI_REDUCE', 'YIELD_CRIME',-50); 

------------------------------------------------------------------------------------------------------------------------
-- 商路加成
------------------------------------------------------------------------------------------------------------------------
INSERT  INTO Policy_TradeRouteYieldChange(PolicyType,DomainType,YieldType,Yield)
SELECT 'POLICY_PROTECTIONISM',	'DOMAIN_LAND', 'YIELD_CRIME',		-3  UNION ALL   
SELECT 'POLICY_PROTECTIONISM',	'DOMAIN_SEA', 'YIELD_CRIME',		-3;    

------------------------------------------------------------------------------------------------------------------------
-- 杰作加成
------------------------------------------------------------------------------------------------------------------------
INSERT  INTO Policy_GreatWorkYieldChanges(PolicyType,YieldType,Yield)
SELECT 'POLICY_KNOWLEDGE_FINISHER',	'YIELD_CRIME',		-1;     --智慧关门


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
	SET Text = Text||'[NEWLINE][ICON_BULLET]所有商路-3[ICON_CRIME]犯罪率。'
	WHERE Tag IN (SELECT Help FROM Policies WHERE Type = 'POLICY_PROTECTIONISM');


UPDATE LocalizedText
	SET Text = Text||'[NEWLINE][ICON_BULLET]全局[ICON_CRIME]犯罪率-10%。'
	WHERE Tag IN (SELECT Help FROM Policies WHERE Type = 'POLICY_RELIGIOUS_POLITICS');

UPDATE LocalizedText
	SET Text = Text||'[NEWLINE][ICON_BULLET]每座城市-5[ICON_CRIME]犯罪率。'
	WHERE Tag IN (SELECT Help FROM Policies WHERE Type = 'POLICY_LEGALISM');


UPDATE LocalizedText
	SET Text = Text||'[NEWLINE][ICON_BULLET]每个兵营、军械所、城堡、兵工厂、军事基地-3[ICON_CRIME]犯罪率。'
	WHERE Tag IN (SELECT Help FROM Policies WHERE Type = 'POLICY_DISCIPLINE');

UPDATE LocalizedText
	SET Text = Text||'[NEWLINE][ICON_BULLET]每座城市-1%[ICON_CRIME]全局犯罪率。'
	WHERE Tag IN (SELECT Help FROM Policies WHERE Type = 'POLICY_REPUBLIC');
-----------------------------------------------------------------------------------------------------

