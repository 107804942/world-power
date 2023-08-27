 -- Insert SQL Rules Here
--where a <> 100; where a != 100;

--<!--   GameEvents.MinorGift.Add(function(iMinor, iMajor, iData2, iData3, iFlags, bOpt1, bOpt2, sType) end) -->
 --<Row Class="3" Name="EVENTS_MINORS_GIFTS" Value="0"/>
 --AND  EXISTS (SELECT * FROM Unit_FreePromotions WHERE (PromotionType ='PROMOTION_GUNPOWDER_INFANTRY_COMBAT' AND UnitType = NEW.Type)))


------------------------------------------------------------------------------------------------------------------------
-- 强权
------------------------------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS 
ROG_GlobalUserSettings (
	Type 				text 			default null,
	Value 				integer 		default 0);


INSERT INTO ROG_GlobalUserSettings
		(Type,				Value)
VALUES	('WORLD_POWER_PATCH',	0); 


UPDATE ROG_GlobalUserSettings
SET Value = 1
WHERE Type IN ('WORLD_POWER_PATCH')
AND EXISTS (SELECT Type FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_KGB');


-----买地
UPDATE Traits SET BuyOwnedTiles = 1 WHERE Type ='TRAIT_RIVER_EXPANSION'; 


-----渔船被掠劫后摧毁
UPDATE Improvements SET DestroyedWhenPillaged = 1 WHERE Type ='IMPROVEMENT_FISHFARM_MOD'; 


--------傀儡健康度加成
UPDATE Defines SET Value =-100 WHERE Name='PUPPET_DISEASE_MODIFIER'; 
UPDATE Defines SET Value = 100 WHERE Name='PUPPET_HEALTH_MODIFIER'; 

---------- 计划
INSERT INTO Project_YieldModifiers(ProjectType,YieldType, Yield)VALUES
('PROJECT_COMMOM_ORGANIZED', 'YIELD_DISEASE',-20),
('PROJECT_COMMOM_ORGANIZED', 'YIELD_SCIENCE',5);

INSERT INTO Project_YieldChanges(ProjectType,YieldType, Yield)VALUES
('PROJECT_COMMOM_ORGANIZED', 'YIELD_DISEASE',-5),
('PROJECT_COMMOM_ORGANIZED', 'YIELD_PRODUCTION',10);


------------------------------------------------------------------------------------------------------------------------
-- 城市攻击距离
------------------------------------------------------------------------------------------------------------------------
UPDATE Technologies     SET BombardIndirect=1   WHERE Type='TECH_ENGINEERING';
UPDATE Buildings        SET BombardRange=2   WHERE BuildingClass='BUILDINGCLASS_WALLS';
UPDATE Buildings        SET BombardRange=3 , BombardIndirect=1  WHERE BuildingClass='BUILDINGCLASS_PALACE';
UPDATE Buildings        SET BombardRange=3   WHERE BuildingClass='BUILDINGCLASS_MILITARY_BASE';
UPDATE Buildings        SET BombardRange=4   WHERE BuildingClass='BUILDINGCLASS_KRAK_DES_CHEVALIERS';
UPDATE Buildings        SET BombardRange=5   WHERE BuildingClass='BUILDINGCLASS_MATRIX';
UPDATE Buildings        SET BombardRange=8   WHERE BuildingClass='BUILDINGCLASS_SPACE_FORTRESS';


INSERT OR REPLACE INTO Defines(Name, Value) SELECT 'MAX_CITY_ATTACK_RANGE', max(BombardRange) FROM Technologies;
INSERT OR REPLACE INTO Defines(Name, Value) SELECT 'MAX_CITY_ATTACK_RANGE', max(BombardRange) FROM Buildings;



------------------------------------------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------------------

INSERT  INTO IconFontMapping(IconName,IconFontTexture,IconMapping)VALUES 
('ICON_CRIME', 'ICON_FONT_TEXTURE_CITY_ICONS',49),
('ICON_SOVEREIGNTY', 'ICON_FONT_TEXTURE_CITY_ICONS',54);

UPDATE Yields SET IconString='[ICON_HEALTH]' ,ImageTexture='YieldAtlas_128_Health.dds' WHERE Type='YIELD_HEALTH';
UPDATE Yields SET IconString='[ICON_GREAT_GENERAL]'  ,ImageTexture='yieldatlas_128_general.dds' WHERE Type='YIELD_GREAT_GENERAL_POINTS';
UPDATE Yields SET IconString='[ICON_GREAT_ADMIRAL]'  ,ImageTexture='yieldatlas_128_admiral.dds' WHERE Type='YIELD_GREAT_ADMIRAL_POINTS';
UPDATE Yields SET IconString='[ICON_DISEASE]',ImageTexture='YieldAtlas_128_Disease.dds' WHERE Type='YIELD_DISEASE';
UPDATE Yields SET IconString='[ICON_CRIME]' WHERE Type='YIELD_CRIME';
UPDATE Yields SET IconString='[ICON_SILVER_FIST]' WHERE Type='YIELD_LOYALTY';
UPDATE Yields SET IconString='[ICON_SOVEREIGNTY]' WHERE Type='YIELD_SOVEREIGNTY';



------------------------------------------------------------------------------------------------------------------------
-- 国家纪念日
------------------------------------------------------------------------------------------------------------------------
INSERT  INTO Policy_CityLoveKingDayYieldMod(PolicyType,YieldType,Yield)VALUES
('POLICY_GRANDEUR_4', 'YIELD_FAITH',25),
('POLICY_GRANDEUR_4', 'YIELD_PRODUCTION',25),
('POLICY_GRANDEUR_4', 'YIELD_SCIENCE',25),
('POLICY_GRANDEUR_4', 'YIELD_GOLD',25);

--情报网络
INSERT  INTO Policy_BuildingClassYieldChanges(PolicyType,BuildingClassType ,YieldType ,YieldChange)VALUES
('POLICY_KNOWLEDGE_5', 'BUILDINGCLASS_DUNGEON' ,'YIELD_SCIENCE',2),
('POLICY_KNOWLEDGE_5', 'BUILDINGCLASS_LOCKUP' ,'YIELD_SCIENCE',2),
('POLICY_KNOWLEDGE_5', 'BUILDINGCLASS_POLICE_STATION' ,'YIELD_SCIENCE',2);


INSERT  INTO Policy_YieldModifierFromActiveSpies(PolicyType,YieldType ,Yield)VALUES
('POLICY_KNOWLEDGE_5','YIELD_SCIENCE',4);

------------------------------------------------------------------------------------------------------------------------
-- 碑铭主义
------------------------------------------------------------------------------------------------------------------------
INSERT  INTO Policy_CityWithWorldWonderYieldModifier(PolicyType,YieldType,Yield)
VALUES ('POLICY_GRANDEUR_5', 'YIELD_GOLD',10),
       ('POLICY_GRANDEUR_5', 'YIELD_CULTURE',10),
       ('POLICY_GRANDEUR_5', 'YIELD_SCIENCE',10);


INSERT  INTO Policy_ResourceYieldChanges(PolicyType,ResourceType,YieldType,Yield)
SELECT 'POLICY_KNOWLEDGE_1' ,Type, 'YIELD_GOLD',1 FROM Resources WHERE ResourceClassType='RESOURCECLASS_LUXURY';
------------------------------------------------------------------------------------------------------------------------
-- 疗养院
------------------------------------------------------------------------------------------------------------------------
UPDATE Improvements SET NearbyFriendHeal=50 WHERE Type='IMPROVEMENT_SANATORIUM';

------------------------------------------------------------------------------------------------------------------------
-- 提供资源
------------------------------------------------------------------------------------------------------------------------
UPDATE Improvements SET ImprovementResource='RESOURCE_MANPOWER',ImprovementResourceQuantity=1 WHERE Type='IMPROVEMENT_MANUFACTORY';

------------------------------------------------------------------------------------------------------------------------
-- 商站新属性
------------------------------------------------------------------------------------------------------------------------
INSERT  INTO Improvement_AdjacentResourceYieldChanges(ImprovementType,ResourceType,YieldType,Yield)
SELECT  'IMPROVEMENT_LATIFUNDIUM', Type, 'YIELD_GOLD' ,1  FROM Resources WHERE ResourceClassType='RESOURCECLASS_LUXURY';

CREATE TRIGGER Improvement_AdjacentResourceYieldChanges_LATIFUNDIUM
AFTER INSERT ON Resources
WHEN NEW.ResourceClassType = 'RESOURCECLASS_LUXURY' 
BEGIN
  INSERT INTO Improvement_AdjacentResourceYieldChanges(ImprovementType,ResourceType,YieldType,Yield)
    VALUES('IMPROVEMENT_LATIFUNDIUM',NEW.Type,'YIELD_GOLD',1);
END;

------------------------------------------------------------------------------------------------------------------------
-- 学院新属性
------------------------------------------------------------------------------------------------------------------------
INSERT  INTO Improvement_AdjacentFeatureYieldChanges(ImprovementType,FeatureType,YieldType,Yield)
SELECT  'IMPROVEMENT_ACADEMY', Type, 'YIELD_SCIENCE' ,5  FROM Features WHERE  NaturalWonder= '1' OR PseudoNaturalWonder = '1';

CREATE TRIGGER Improvement_AdjacentFeatureYieldChangesACADEMY
AFTER INSERT ON Features
WHEN  NEW.NaturalWonder= '1' OR NEW.PseudoNaturalWonder = '1'
BEGIN
  INSERT INTO Improvement_AdjacentFeatureYieldChanges(ImprovementType,FeatureType,YieldType,Yield)
    VALUES('IMPROVEMENT_ACADEMY',NEW.Type,'YIELD_SCIENCE',5);
END;


------------------------------------------------------------------------------------------------------------------------
-- 生态城市新属性
------------------------------------------------------------------------------------------------------------------------
INSERT  INTO Improvement_AdjacentFeatureYieldChanges(ImprovementType,FeatureType,YieldType,Yield)
SELECT 'IMPROVEMENT_FW_ARCOLOGY', p.Type, h.Type, 10
FROM Features AS p, Yields AS h 
WHERE (p.NaturalWonder ='1'OR p.PseudoNaturalWonder = '1') AND (h.Type = 'YIELD_GOLD' OR h.Type = 'YIELD_SCIENCE'OR h.Type = 'YIELD_FOOD');


------------------------------------------------------------------------------------------------------------------------
-- 制造厂新属性
------------------------------------------------------------------------------------------------------------------------
INSERT  INTO Improvement_AdjacentResourceYieldChanges(ImprovementType,ResourceType,YieldType,Yield)
SELECT  'IMPROVEMENT_MANUFACTORY', Type, 'YIELD_PRODUCTION' ,1  FROM Resources WHERE ResourceClassType='RESOURCECLASS_BONUS';

CREATE TRIGGER Improvement_AdjacentResourceYieldChanges_MANUFACTORY
AFTER INSERT ON Resources
WHEN NEW.ResourceClassType = 'RESOURCECLASS_BONUS' 
BEGIN
  INSERT INTO Improvement_AdjacentResourceYieldChanges(ImprovementType,ResourceType,YieldType,Yield)
    VALUES('IMPROVEMENT_MANUFACTORY',NEW.Type,'YIELD_PRODUCTION',1);
END;




------------------------------------------------------------------------------------------------------------------------
-- 绿洲新属性
------------------------------------------------------------------------------------------------------------------------
INSERT  INTO Improvement_AdjacentFeatureYieldChanges(ImprovementType,FeatureType,YieldType,Yield)
SELECT  'IMPROVEMENT_FARM', 'FEATURE_OASIS', 'YIELD_FOOD' ,2;



----宏伟自然奇观健康度产出
INSERT  INTO Policy_YieldChangesNaturalWonder(PolicyType,YieldType,Yield)
VALUES('POLICY_GRANDEUR_5', 'YIELD_HEALTH', 3);




-- Manufactory 
INSERT INTO Improvement_TechYieldChanges (ImprovementType, TechType, YieldType, Yield)
VALUES
    ('IMPROVEMENT_PLANTATION',	   'TECH_IMPERIALISM',      'YIELD_GOLD',       1),
	('IMPROVEMENT_MANUFACTORY',	   'TECH_REFINING',         'YIELD_PRODUCTION', 1),
	--('IMPROVEMENT_CAMP',	       'TECH_NATURAL_HISTORY',  'YIELD_CULTURE',    2),
	('IMPROVEMENT_CUSTOMS_HOUSE',  'TECH_STEAM_POWER',      'YIELD_PRODUCTION', 2);

--UPDATE Improvement_TechYieldChanges SET TechType = 'TECH_REFINING' WHERE ImprovementType = 'IMPROVEMENT_MINE' AND TechType = 'TECH_CHEMISTRY';
--UPDATE Improvement_TechYieldChanges SET TechType = 'TECH_REFINING' WHERE ImprovementType = 'IMPROVEMENT_QUARRY' AND TechType = 'TECH_CHEMISTRY';




DELETE FROM Improvement_TechYieldChanges WHERE ImprovementType = 'IMPROVEMENT_MINE' AND TechType = 'TECH_CHEMISTRY';
DELETE FROM Improvement_TechYieldChanges WHERE ImprovementType = 'IMPROVEMENT_QUARRY' AND TechType = 'TECH_CHEMISTRY';



 -- IconFontTextures
------------------------------------------------------------------------------------------------------------------------	
INSERT INTO IconFontTextures 
		(IconFontTexture, 						IconFontTextureFile)
SELECT	'ICON_FONT_TEXTURE_ARCHIMEDES', 			'Archimedes_22_Fonticons';	
------------------------------------------------------------------------------------------------------------------------
-- IconFontMapping
------------------------------------------------------------------------------------------------------------------------	
INSERT INTO IconFontMapping 
		(IconName, 				IconFontTexture,					IconMapping)
SELECT	'ICON_ARCHIMEDES',		'ICON_FONT_TEXTURE_ARCHIMEDES',		1;

INSERT INTO IconTextureAtlases 
		(Atlas, 					IconSize, 	Filename, 						IconsPerRow, 	IconsPerColumn)
VALUES	('ARCHIMEDES_ATLAS',			32, 		'Archimedes_32.dds',			11, 			2);



 -----------------------------------------------------------------------------------------------------
--Defines
-----------------------------------------------------------------------------------------------------
INSERT INTO Defines (Name,					Value)
SELECT 'GOLD_THRESHOLD_GAMESPEED_QUICK',	1 UNION ALL   --基础阈值
SELECT 'GOLD_THRESHOLD_GAMESPEED_STANDARD',	1.5 UNION ALL  --基础阈值
SELECT 'GOLD_THRESHOLD_GAMESPEED_EPIC',		2.5 UNION ALL  --基础阈值
SELECT 'GOLD_THRESHOLD_GAMESPEED_MARATHON',	5 ;  --基础阈值

 --==========================================================================================================================
-- FASTER ANIMATIONS
--==========================================================================================================================
-- Aircraft Rebase Animations 
UPDATE AnimationPaths SET MissionPath = 0 WHERE Type IN ("ANIMATIONPATH_AIRFADEIN", "ANIMATIONPATH_AIRFADEOUT");
UPDATE MovementRates SET TotalTime = 0.02 WHERE Type = "AIR_REBASE"; -- will be halved in next step

-- Faster Aircraft Animations 
--UPDATE ArtDefine_UnitMemberCombats SET MoveRate = MoveRate * 2 WHERE MoveRate > 0;
--UPDATE ArtDefine_UnitMemberCombats SET TurnRateMin = TurnRateMin * 2 WHERE MoveRate > 0;
--UPDATE ArtDefine_UnitMemberCombats SET TurnRateMax = TurnRateMax * 2 WHERE MoveRate > 0;
--UPDATE ArtDefine_UnitMemberCombats SET TurnFacingRateMin = TurnFacingRateMin * 1.73 WHERE MoveRate > 0;
--UPDATE ArtDefine_UnitMemberCombats SET TurnFacingRateMax = TurnFacingRateMax * 1.73 WHERE MoveRate > 0;
--UPDATE ArtDefine_UnitMemberCombats SET AttackRadius = AttackRadius * 2.45 WHERE MoveRate > 0;

-- Faster Non-Aircraft Animations 
UPDATE MovementRates SET IndividualOffset = IndividualOffset/1.5;		-- delay between part-units from a unit
UPDATE MovementRates SET RowOffset = RowOffset/1.5;					-- delay between rows of part-units from a unit
UPDATE MovementRates SET TotalTime = TotalTime/1.5;					-- the total time a part-unit needs to reach the plot
UPDATE MovementRates SET EaseIn = EaseIn/1.5;		
UPDATE MovementRates SET EaseOut = EaseOut/1.5;		

-- Faster Non-Aircraft Animations 
UPDATE ArtDefine_UnitMemberCombats SET ShortMoveRate = ShortMoveRate * 1.5 WHERE MoveRate IS NULL;
UPDATE ArtDefine_UnitMemberCombats SET TurnRateMin = TurnRateMin * 1.5 WHERE MoveRate IS NULL;
UPDATE ArtDefine_UnitMemberCombats SET TurnRateMax = TurnRateMax * 1.5 WHERE MoveRate IS NULL;
UPDATE ArtDefine_UnitMemberCombats SET TurnFacingRateMin = TurnFacingRateMin * 1.5 WHERE MoveRate IS NULL;
UPDATE ArtDefine_UnitMemberCombats SET TurnFacingRateMax = TurnFacingRateMax * 1.5 WHERE MoveRate IS NULL;

--==========================================================================================================================

 -- 专家提供的伟人诞生速率统一为2
UPDATE Specialists SET GreatPeopleRateChange = 2    WHERE Type != 'SPECIALIST_CITIZEN' AND Type != 'SPECIALIST_DOCTOR' AND Type != 'SPECIALIST_SCIENTIST';
UPDATE Specialists SET GreatPeopleRateChange = 1    WHERE  Type = 'SPECIALIST_SCIENTIST';


------------------------------------------------------------------------------------------------------------------------
-- 解锁专家资源
------------------------------------------------------------------------------------------------------------------------
--INSERT  INTO Specialist_Resources(SpecialistType,ResourceType,Quantity,RequiredTechType)
--VALUES ('SPECIALIST_ENGINEER', 'RESOURCE_ELECTRICITY',1, 'TECH_ENERGY_THEORY');



---专家额外资源
ALTER TABLE Technologies ADD COLUMN 'EngineerResource' INTEGER DEFAULT 0; 

----科学家额外产出
ALTER TABLE Technologies ADD COLUMN 'ExtraScientist' INTEGER DEFAULT 0; 

----文学家额外产出
ALTER TABLE Technologies ADD COLUMN 'ExtraWriter' INTEGER DEFAULT 0; 

----医学家额外产出
ALTER TABLE Technologies ADD COLUMN 'ExtraDoctor' INTEGER DEFAULT 0; 



UPDATE Technologies 
Set EngineerResource = '1'
WHERE EXISTS (SELECT * FROM Specialist_Resources WHERE (RequiredTechType =Technologies.Type  AND SpecialistType='SPECIALIST_ENGINEER')); 


UPDATE Technologies 
Set ExtraScientist = '1'
WHERE EXISTS (SELECT * FROM Tech_SpecialistYieldChanges WHERE (TechType =Technologies.Type  AND SpecialistType='SPECIALIST_SCIENTIST')); 


UPDATE Technologies 
Set ExtraWriter = '1'
WHERE EXISTS (SELECT * FROM Tech_SpecialistYieldChanges WHERE (TechType =Technologies.Type  AND SpecialistType='SPECIALIST_WRITER')); 

UPDATE Technologies 
Set ExtraDoctor = '1'
WHERE EXISTS (SELECT * FROM Tech_SpecialistYieldChanges WHERE (TechType =Technologies.Type  AND SpecialistType='SPECIALIST_DOCTOR')); 





-- Insert SQL Rules Here 
-- Tech Enhancement Icons atlas entries
INSERT INTO IconTextureAtlases(Atlas, IconSize, IconsPerRow, IconsPerColumn, Filename) VALUES
	('TECH_ENH_ICONS_ATLAS', 64, 8, 5, 'TechEnhIcons64.dds'),
	('TECH_ENH_ICONS_ATLAS', 45, 8, 5, 'TechEnhIcons45.dds'),
	('TECH_ENH_ICONS_ATLAS2', 64, 8, 8, 'techEnhIconAtlas64.dds'),
	('TECH_ENH_ICONS_ATLAS2', 45, 8, 8, 'techEnhIconAtlas45.dds');




ALTER TABLE Improvements ADD YieldBoostAtlas TEXT DEFAULT 'GENERIC_FUNC_ATLAS';
ALTER TABLE Improvements ADD YieldBoostIndex INTEGER DEFAULT 0;

ALTER TABLE Routes ADD  MovementBoostAtlas TEXT DEFAULT 'GENERIC_FUNC_ATLAS';
ALTER TABLE Routes ADD MovementBoostIndex INTEGER DEFAULT 0;

ALTER TABLE Domains ADD TradeBoostAtlas TEXT DEFAULT 'GENERIC_FUNC_ATLAS';
ALTER TABLE Domains ADD TradeBoostIndex INTEGER DEFAULT 0;

CREATE TABLE IF NOT EXISTS TechEnhancementIcons(
  Enhancement TEXT NOT NULL UNIQUE,
  Tip TEXT NOT NULL,
  Param INTEGER DEFAULT 0,
  BoostAtlas TEXT DEFAULT 'GENERIC_FUNC_ATLAS',
  BoostIndex INTEGER DEFAULT 0);

-- Embarkation Enhancements
INSERT INTO TechEnhancementIcons(Enhancement, Tip) VALUES
	('AllowsEmbarking', 'TXT_KEY_ALLOWS_EMBARKING'),
	('AllowsDefensiveEmbarking', 'TXT_KEY_ABLTY_DEFENSIVE_EMBARK_STRING'),
	('EmbarkedAllWaterPassage', 'TXT_KEY_ALLOWS_CROSSING_OCEANS'),
	('EmbarkedMoveChange', 'TXT_KEY_FASTER_EMBARKED_MOVEMENT');

-- Agreements Enhancements
INSERT INTO TechEnhancementIcons(Enhancement, Tip) VALUES
	('AllowEmbassyTradingAllowed', 'TXT_KEY_ALLOWS_EMBASSY'),
	('OpenBordersTradingAllowed', 'TXT_KEY_ALLOWS_OPEN_BORDERS'),
	('DefensivePactTradingAllowed', 'TXT_KEY_ALLOWS_DEFENSIVE_PACTS'),
	('ResearchAgreementTradingAllowed', 'TXT_KEY_ALLOWS_RESEARCH_AGREEMENTS'),
	('TradeAgreementTradingAllowed', 'TXT_KEY_ALLOWS_TRADE_AGREEMENTS') -- Unused in base game
;

-- World Congress Enhancements
INSERT INTO TechEnhancementIcons(Enhancement, Tip, Param) VALUES
	('AllowsWorldCongress', 'TXT_KEY_ALLOWS_WORLD_CONGRESS', 0),
	('ExtraVotesPerDiplomat', 'TXT_KEY_EXTRA_VOTES_FROM_DIPLOMATS', 1);

-- Miscellaneous Enhancements
INSERT INTO TechEnhancementIcons(Enhancement, Tip) VALUES
	('BridgeBuilding', 'TXT_KEY_ALLOWS_BRIDGES'),
	('MapVisible', 'TXT_KEY_REVEALS_ENTIRE_MAP'),
	('InternationalTradeRoutesChange', 'TXT_KEY_ADDITIONAL_INTERNATIONAL_TRADE_ROUTE'),
	('InfluenceSpreadModifier', 'TXT_KEY_DOUBLE_TOURISM');

-- Unit Enhancements, both unused in base game
INSERT INTO TechEnhancementIcons(Enhancement, Tip, Param) VALUES
	('UnitFortificationModifier', 'TXT_KEY_UNIT_FORTIFICATION_MOD', 1),
	('UnitBaseHealModifier', 'TXT_KEY_UNIT_BASE_HEAL_MOD', 1);

----城市间接火力
-- City Bombardment Enhancements, both unused in base game
INSERT INTO TechEnhancementIcons(Enhancement, Tip) VALUES
	('BombardIndirect', 'TXT_KEY_CITY_BOMBARDMENT_MOD');



----科学家额外产出
-- 
INSERT INTO TechEnhancementIcons(Enhancement, Tip) VALUES
	('ExtraScientist', 'TXT_KEY_EXTRA_SCIENTIST_YEILD_HELP');

----文学家额外产出
-- 
INSERT INTO TechEnhancementIcons(Enhancement, Tip) VALUES
	('ExtraWriter', 'TXT_KEY_EXTRA_WRITER_YEILD_HELP');

----医学家额外产出
-- 
INSERT INTO TechEnhancementIcons(Enhancement, Tip) VALUES
	('ExtraDoctor', 'TXT_KEY_EXTRA_DOCTOR_YEILD_HELP');

---工程师资源产出
INSERT INTO TechEnhancementIcons(Enhancement, Tip) VALUES
	('EngineerResource', 'TXT_KEY_EXTRA_RESOURCES_VALUE_HELP');

ALTER TABLE Improvements ADD ShowInTechTree INTEGER DEFAULT 1;
UPDATE Improvements    SET  ShowInTechTree=1   WHERE Type='IMPROVEMENT_FISHERY_MOD';
UPDATE Improvements    SET  ShowInTechTree=1   WHERE Type='IMPROVEMENT_FISHFARM_MOD';
UPDATE Improvements    SET  ShowInTechTree=1   WHERE Type='IMPROVEMENT_OFFSHORE_PLATFORM';

UPDATE Improvements    SET  ShowInTechTree=1   WHERE Type='IMPROVEMENT_BE_ACADEMY';
UPDATE Improvements    SET  ShowInTechTree=1   WHERE Type='IMPROVEMENT_TERRASCAPE';
UPDATE Improvements    SET  ShowInTechTree=1   WHERE Type='IMPROVEMENT_FW_GENERATOR';
UPDATE Improvements    SET  ShowInTechTree=1   WHERE Type='IMPROVEMENT_FW_COMM_ARRAY';
UPDATE Improvements    SET  ShowInTechTree=1   WHERE Type='IMPROVEMENT_FW_INDUSTRIAL_COMPLEX';
UPDATE Improvements    SET  ShowInTechTree=1   WHERE Type='IMPROVEMENT_FW_ARCOLOGY';

UPDATE Improvements    SET  ShowInTechTree=1   WHERE Type='IMPROVEMENT_CAIRN';
UPDATE Improvements    SET  ShowInTechTree=1   WHERE Type='IMPROVEMENT_LATIFUNDIUM';
UPDATE Improvements    SET  ShowInTechTree=1   WHERE Type='IMPROVEMENT_SANATORIUM';

-- Improvement Yield Boosts


UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=0  WHERE Type='IMPROVEMENT_FARM';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=1  WHERE Type='IMPROVEMENT_MINE';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=2  WHERE Type='IMPROVEMENT_LUMBERMILL';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=3  WHERE Type='IMPROVEMENT_TRADING_POST';


UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=4  WHERE Type='IMPROVEMENT_PASTURE';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=5  WHERE Type='IMPROVEMENT_CAMP';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=6  WHERE Type='IMPROVEMENT_PLANTATION';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=7  WHERE Type='IMPROVEMENT_FISHING_BOATS';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=8  WHERE Type='IMPROVEMENT_QUARRY';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=9  WHERE Type='IMPROVEMENT_CHATEAU';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=10 WHERE Type='IMPROVEMENT_MOAI';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=11 WHERE Type='IMPROVEMENT_TERRACE_FARM';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=12 WHERE Type='IMPROVEMENT_POLDER';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=13 WHERE Type='IMPROVEMENT_BRAZILWOOD_CAMP';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=14 WHERE Type='IMPROVEMENT_ACADEMY';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=15 WHERE Type='IMPROVEMENT_CUSTOMS_HOUSE';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=16 WHERE Type='IMPROVEMENT_MANUFACTORY';

UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=38  WHERE Type='IMPROVEMENT_KASBAH';

UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=34 WHERE Type='IMPROVEMENT_WELL';

UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=35  WHERE Type='IMPROVEMENT_SANATORIUM';

UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=37  WHERE Type='IMPROVEMENT_LATIFUNDIUM';


UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS2', YieldBoostIndex=28 WHERE Type='IMPROVEMENT_SAND_BASE';

UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS', YieldBoostIndex=36 WHERE Type='IMPROVEMENT_BYZANTIUM_ANGELOKASTRO';

UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS2', YieldBoostIndex=31 WHERE Type='IMPROVEMENT_OFFSHORE_PLATFORM';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS2', YieldBoostIndex=27 WHERE Type='IMPROVEMENT_FISHERY_MOD';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS2', YieldBoostIndex=29 WHERE Type='IMPROVEMENT_FISHFARM_MOD';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS2', YieldBoostIndex=6 WHERE Type='IMPROVEMENT_BE_ACADEMY';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS2', YieldBoostIndex=11 WHERE Type='IMPROVEMENT_TERRASCAPE';
--UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS2', YieldBoostIndex=20 WHERE Type='IMPROVEMENT_FW_GENERATOR';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS2', YieldBoostIndex=0 WHERE Type='IMPROVEMENT_FW_COMM_ARRAY';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS2', YieldBoostIndex=4 WHERE Type='IMPROVEMENT_FW_INDUSTRIAL_COMPLEX';
UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS2', YieldBoostIndex=24 WHERE Type='IMPROVEMENT_FW_ARCOLOGY';

UPDATE Improvements SET YieldBoostAtlas='TECH_ENH_ICONS_ATLAS2', YieldBoostIndex=36 WHERE Type='IMPROVEMENT_HOLY_SITE';

-- Route Movement Boosts
UPDATE Routes SET MovementBoostAtlas='TECH_ENH_ICONS_ATLAS', MovementBoostIndex=17 WHERE Type='ROUTE_ROAD';
UPDATE Routes SET MovementBoostAtlas='TECH_ENH_ICONS_ATLAS', MovementBoostIndex=18 WHERE Type='ROUTE_RAILROAD';

-- Trade Route Distance Boosts
UPDATE Domains SET TradeBoostAtlas='TECH_ENH_ICONS_ATLAS', TradeBoostIndex=19 WHERE Type='DOMAIN_LAND';
UPDATE Domains SET TradeBoostAtlas='TECH_ENH_ICONS_ATLAS', TradeBoostIndex=20 WHERE Type='DOMAIN_SEA';

-- Miscellaneous Enhancements
UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS', BoostIndex=21 WHERE Enhancement='BridgeBuilding';
UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS', BoostIndex=22 WHERE Enhancement='AllowsEmbarking';
UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS', BoostIndex=22 WHERE Enhancement='AllowsDefensiveEmbarking';
UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS', BoostIndex=23 WHERE Enhancement='EmbarkedAllWaterPassage';
UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS', BoostIndex=24 WHERE Enhancement='EmbarkedMoveChange';
UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS', BoostIndex=25 WHERE Enhancement='InternationalTradeRoutesChange';
UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS', BoostIndex=26 WHERE Enhancement='AllowEmbassyTradingAllowed';
UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS', BoostIndex=27 WHERE Enhancement='OpenBordersTradingAllowed';
UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS', BoostIndex=28 WHERE Enhancement='ResearchAgreementTradingAllowed';
UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS', BoostIndex=29 WHERE Enhancement='DefensivePactTradingAllowed';
UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS', BoostIndex=30 WHERE Enhancement='AllowsWorldCongress';
UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS', BoostIndex=31 WHERE Enhancement='ExtraVotesPerDiplomat';
UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS', BoostIndex=32 WHERE Enhancement='InfluenceSpreadModifier';
UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS', BoostIndex=33 WHERE Enhancement='MapVisible';

UPDATE TechEnhancementIcons SET BoostAtlas='SPBalance_ATLAS', BoostIndex=34 WHERE Enhancement='ExtraScientist';  
UPDATE TechEnhancementIcons SET BoostAtlas='SPBalance_ATLAS', BoostIndex=40 WHERE Enhancement='ExtraWriter';  
UPDATE TechEnhancementIcons SET BoostAtlas='ROBOT_ICON_ATLAS4', BoostIndex=41 WHERE Enhancement='ExtraDoctor';  

--UPDATE TechEnhancementIcons SET BoostAtlas='SPBalance_ATLAS', BoostIndex=37 WHERE Enhancement='EngineerResource'; 
UPDATE TechEnhancementIcons SET BoostAtlas='GENERIC_FUNC_ATLAS', BoostIndex=0 WHERE Enhancement='EngineerResource';

--UPDATE TechEnhancementIcons SET BoostAtlas='UNIT_ACTION_ATLAS', BoostIndex=60 WHERE Enhancement='BombardQuickly';  
UPDATE TechEnhancementIcons SET BoostAtlas='UNIT_ACTION_ATLAS', BoostIndex=13 WHERE Enhancement='BombardIndirect';  
---间接火力

UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS2', BoostIndex=33 WHERE Enhancement='UnitFortificationModifier';
--UPDATE TechEnhancementIcons SET BoostAtlas='TECH_ENH_ICONS_ATLAS2', BoostIndex=35 WHERE Enhancement='UnitBaseHealModifier';
UPDATE TechEnhancementIcons SET BoostAtlas='UNIT_ACTION_ATLAS', BoostIndex=3 WHERE Enhancement='UnitBaseHealModifier';


INSERT INTO IconTextureAtlases	(Atlas, IconSize, Filename, IconsPerRow, IconsPerColumn) VALUES
    ('SPY_PROMOTION_ATLAS',	256,'SpyPromotion256.dds','2','1'),
	('SPY_PROMOTION_ATLAS',	64, 'SpyPromotion64.dds','2','1'),
	('SPY_PROMOTION_ATLAS',	45, 'SpyPromotion45.dds','2','1'),
	('SPY_PROMOTION_ATLAS',	32, 'SpyPromotion32.dds','2','1'),


	('promoVP_atlas_00', 256, 'promoVP_00_256.dds', '8', '8'),
	('promoVP_atlas_00', 064, 'promoVP_00_064.dds', '8', '8'),
	('promoVP_atlas_00', 045, 'promoVP_00_045.dds', '8', '8'),
	('promoVP_atlas_00', 032, 'promoVP_00_032.dds', '8', '8'),
	('promoVP_atlas_00', 016, 'promoVP_00_016.dds', '8', '8'),
		
	('promoVP_atlas_01', 256, 'promoVP_01_256.dds', '8', '8'),
	('promoVP_atlas_01', 064, 'promoVP_01_064.dds', '8', '8'),
	('promoVP_atlas_01', 045, 'promoVP_01_045.dds', '8', '8'),
	('promoVP_atlas_01', 032, 'promoVP_01_032.dds', '8', '8'),
	('promoVP_atlas_01', 016, 'promoVP_01_016.dds', '8', '8'),
		
	('promoVP_atlas_02', 256, 'promoVP_02_256.dds', '8', '8'),
	('promoVP_atlas_02', 064, 'promoVP_02_064.dds', '8', '8'),
	('promoVP_atlas_02', 045, 'promoVP_02_045.dds', '8', '8'),
	('promoVP_atlas_02', 032, 'promoVP_02_032.dds', '8', '8'),
	('promoVP_atlas_02', 016, 'promoVP_02_016.dds', '8', '8'),
		
	('promoVP_atlas_03', 256, 'promoVP_03_256.dds', '8', '8'),
	('promoVP_atlas_03', 064, 'promoVP_03_064.dds', '8', '8'),
	('promoVP_atlas_03', 045, 'promoVP_03_045.dds', '8', '8'),
	('promoVP_atlas_03', 032, 'promoVP_03_032.dds', '8', '8'),
	('promoVP_atlas_03', 016, 'promoVP_03_016.dds', '8', '8'),


	('MainRobotPromo_Atlas', 256, 'MianRobotPromotionAtlas256.dds', '8', '8'),
	('MainRobotPromo_Atlas', 064, 'MianRobotPromotionAtlas64.dds', '8', '8'),
	('MainRobotPromo_Atlas', 045, 'MianRobotPromotionAtlas45.dds', '8', '8'),
	('MainRobotPromo_Atlas', 032, 'MianRobotPromotionAtlas32.dds', '8', '8'),

	('robotPromo_Atlas', 256, 'ROBOTPromo_256.dds', '8', '8'),
	('robotPromo_Atlas', 064, 'ROBOTPromo_064.dds', '8', '8'),
	('robotPromo_Atlas', 045, 'ROBOTPromo_045.dds', '8', '8'),
	('robotPromo_Atlas', 032, 'ROBOTPromo_032.dds', '8', '8'),
	('robotPromo_Atlas', 016, 'ROBOTPromo_016.dds', '8', '8'),
	
	('promoMUC_atlas_00', 	256, 	'0_muc_PI_256.dds', '8', '8'),
	('promoMUC_atlas_00', 	064, 	'0_muc_PI_064.dds', '8', '8'),
	('promoMUC_atlas_00', 	045, 	'0_muc_PI_045.dds', '8', '8'),
	('promoMUC_atlas_00', 	032, 	'0_muc_PI_032.dds', '8', '8'),
	('promoMUC_atlas_00', 	016, 	'0_muc_PI_016.dds', '8', '8'),
				
	('promoMUC_atlas_01', 	256, 	'1_muc_PI_256.dds', '8','4'),
	('promoMUC_atlas_01', 	064, 	'1_muc_PI_064.dds', '8', '4'),
	('promoMUC_atlas_01', 	045, 	'1_muc_PI_045.dds', '8', '4'),
	('promoMUC_atlas_01', 	032, 	'1_muc_PI_032.dds', '8', '4'),
	('promoMUC_atlas_01', 	016, 	'1_muc_PI_016.dds', '8', '4');





INSERT INTO ArtDefine_LandmarkTypes 
			(Type, 								LandmarkType,	FriendlyName)
VALUES		('ART_DEF_IMPROVEMENT_KURGAN',	'Improvement', 	'Kurgan');

INSERT INTO ArtDefine_Landmarks 
			(ImprovementType, 						Era,	State,				 Scale, LayoutHandler,	ResourceType,			Model,			TerrainContour)
VALUES		('ART_DEF_IMPROVEMENT_KURGAN',			'Any', 	'UnderConstruction',	 1,	'SNAPSHOT',		'ART_DEF_RESOURCE_ALL', 'Kurgan_HB.fxsxml', 1),
			('ART_DEF_IMPROVEMENT_KURGAN',			'Any', 	'Constructed',			 1,	'SNAPSHOT',		'ART_DEF_RESOURCE_ALL', 'Kurgan_B.fxsxml',  1),
			('ART_DEF_IMPROVEMENT_KURGAN',			'Any', 	'Pillaged',				 1,	'SNAPSHOT',		'ART_DEF_RESOURCE_ALL', 'Kurgan_PL.fxsxml', 1);




--Unit Art Defines
INSERT INTO ArtDefine_UnitInfos (Type, DamageStates, Formation) VALUES ('ART_DEF_UNIT_HUGE_BOMB2', 1, "");
INSERT INTO ArtDefine_UnitInfoMemberInfos (UnitInfoType, UnitMemberInfoType, NumMembers) VALUES ('ART_DEF_UNIT_HUGE_BOMB2', 'ART_DEF_UNIT_MEMBER_HUGE_BOMB2', 1);

--Unit Member Art Defines
INSERT INTO ArtDefine_UnitMemberInfos (Type, Scale, Domain, Model, MaterialTypeTag, MaterialTypeSoundOverrideTag)
VALUES ('ART_DEF_UNIT_MEMBER_HUGE_BOMB2', 0.095, "Air", 'HUGE_BOMB2.fxsxml', "METAL", "METALLRG");

INSERT INTO ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions,					AttackRadius,	MoveRate,	TurnRateMin,	TurnRateMax,	HasRefaceAfterCombat,	AttackAltitude)
VALUES ('ART_DEF_UNIT_MEMBER_HUGE_BOMB2', "Idle Attack Bombard Death Run",			48.0,	1.5,		0.10,			0.25,			0,						160.0);

INSERT INTO ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex,	VisKillStrengthMin,		VisKillStrengthMax, ProjectileSpeed,	WeaponTypeTag,	WeaponTypeSoundOverrideTag)
VALUES ('ART_DEF_UNIT_MEMBER_HUGE_BOMB2',		0,		0,			50.0,					75.0,				1.25,				 "BULLETHC",	"BULLETHC");

INSERT INTO ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index",	SubIndex,	VisKillStrengthMin,		VisKillStrengthMax, ProjectileSpeed,	ProjectileChildEffectScale,	AreaDamageDelay,	WaitForEffectCompletion,	TargetGround,	IsDropped,	WeaponTypeTag,	WeaponTypeSoundOverrideTag )
VALUES ('ART_DEF_UNIT_MEMBER_HUGE_BOMB2',		1,		0,			100.0,					100.0,				1.25,				2,						1,				1,							1,	   1,			"EXPLOSIVE",	"ATOMICBOMB");	
	


--Unit Art Defines
INSERT INTO ArtDefine_UnitInfos (Type, DamageStates, Formation) VALUES ('ART_DEF_UNIT_HUGE_BOMB', 1, "");
INSERT INTO ArtDefine_UnitInfoMemberInfos (UnitInfoType, UnitMemberInfoType, NumMembers) VALUES ('ART_DEF_UNIT_HUGE_BOMB', 'ART_DEF_UNIT_MEMBER_HUGE_BOMB', 1);

--Unit Member Art Defines
INSERT INTO ArtDefine_UnitMemberInfos (Type, Scale, Domain, Model, MaterialTypeTag, MaterialTypeSoundOverrideTag)
VALUES ('ART_DEF_UNIT_MEMBER_HUGE_BOMB', 0.17, "Air", 'HUGE_BOMB.fxsxml', "METAL", "METALLRG");

INSERT INTO ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions,					AttackRadius,	MoveRate,	TurnRateMin,	TurnRateMax,	HasRefaceAfterCombat,	AttackAltitude)
VALUES ('ART_DEF_UNIT_MEMBER_HUGE_BOMB', "Idle Attack Bombard Death Run",			48.0,	1.5,		0.10,			0.25,			0,						160.0);

INSERT INTO ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex,	VisKillStrengthMin,		VisKillStrengthMax, ProjectileSpeed,	WeaponTypeTag,	WeaponTypeSoundOverrideTag)
VALUES ('ART_DEF_UNIT_MEMBER_HUGE_BOMB',		0,		0,			50.0,					75.0,				1.25,				 "BULLETHC",	"BULLETHC");

INSERT INTO ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index",	SubIndex,	VisKillStrengthMin,		VisKillStrengthMax, ProjectileSpeed,	ProjectileChildEffectScale,	AreaDamageDelay,	WaitForEffectCompletion,	TargetGround,	IsDropped,	WeaponTypeTag,	WeaponTypeSoundOverrideTag)
VALUES ('ART_DEF_UNIT_MEMBER_HUGE_BOMB',		1,		0,			100.0,					100.0,				1.25,				2,						1,				1,							1,	   1,			"EXPLOSIVE",	"ATOMICBOMB");	
	







-- ART_DEF_IMPROVEMENT_COASTAL_FORT

INSERT INTO ArtDefine_LandmarkTypes(Type, LandmarkType, FriendlyName)
SELECT 'ART_DEF_IMPROVEMENT_COASTAL_FORT', 'Improvement', 'CoastalFort';

INSERT INTO ArtDefine_Landmarks(Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour)
SELECT 'Any', 'UnderConstruction', 1.0,  'ART_DEF_IMPROVEMENT_COASTAL_FORT', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'HB_Fort_MOD.fxsxml', 1 UNION ALL
SELECT 'Any', 'Constructed',       1.0,  'ART_DEF_IMPROVEMENT_COASTAL_FORT', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'Fort_MOD.fxsxml',    1 UNION ALL
SELECT 'Any', 'Pillaged',          1.0,  'ART_DEF_IMPROVEMENT_COASTAL_FORT', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'PL_Fort_MOD.fxsxml', 1;

INSERT INTO ArtDefine_StrategicView(StrategicViewType, TileType, Asset)
SELECT 'ART_DEF_IMPROVEMENT_COASTAL_FORT', 'Improvement', 'SV_CoastalArt256.dds';

-- ART_DEF_IMPROVEMENT_FIXED_AA_BATTERY

INSERT INTO ArtDefine_LandmarkTypes(Type, LandmarkType, FriendlyName)
SELECT 'ART_DEF_IMPROVEMENT_FIXED_AA_BATTERY', 'Improvement', 'FixedAA';



INSERT INTO ArtDefine_Landmarks(Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour)
SELECT 'Any', 'UnderConstruction', 0.60,  'ART_DEF_IMPROVEMENT_FIXED_AA_BATTERY', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'Bunker_HB.fxsxml', 1 UNION ALL
SELECT 'Any', 'Constructed',       0.60,  'ART_DEF_IMPROVEMENT_FIXED_AA_BATTERY', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'Bunker_B.fxsxml',    1 UNION ALL
SELECT 'Any', 'Pillaged',          0.60,  'ART_DEF_IMPROVEMENT_FIXED_AA_BATTERY', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'Bunker_PL.fxsxml', 1;


INSERT INTO ArtDefine_StrategicView(StrategicViewType, TileType, Asset)
SELECT 'ART_DEF_IMPROVEMENT_FIXED_AA_BATTERY', 'Improvement', 'SV_CoastalArt256.dds';





-- 关联晋升图标

ALTER TABLE UnitPromotions ADD IconString2 text default '[ICON_PROMOTION_NEW_ATTRIBUTES]';

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_0]'        WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  0;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_1]'        WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  1;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_2]'        WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  2;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_3]'        WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  3;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_4]'        WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  4;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_7]'        WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  7;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_8]'        WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  8;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_9]'        WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  9;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_11]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  11;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_12]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  12;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_13]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  13;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_14]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  14;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_15]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  15;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_16]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  16;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_18]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  18;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_19]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  19;

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_22]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  22;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_24]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  24;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_25]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  25;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_26]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  26;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_27]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  27;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_28]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  28;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_29]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  29;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_40]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  40;

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_41]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  41;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_42]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  42;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_43]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  43;

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_44]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  44;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_45]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  45;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_46]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  46;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_47]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  47;

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_49]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  49;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_50]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  50;

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_51]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  51;

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_52]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  52;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_54]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  54;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_61]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  61;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_62]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  62;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MAIN_ROBOT_PROMO_63]'       WHERE IconAtlas = 'MainRobotPromo_Atlas'  AND PortraitIndex =  63;

----------------------------------------- end-----------------------------------------------------

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_37]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 37;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_58]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 58;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_3]'           WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 3;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_4]'           WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 4;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_5]'           WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 5;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_6]'           WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 6;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_7]'           WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 7;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_8]'           WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 8;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_12]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 12;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_13]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 13;

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_14]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 14;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_15]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 15;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_16]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 16;

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_20]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 20;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_24]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 24;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_25]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 25;

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_28]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 28;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_29]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 29;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_30]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 30;

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_32]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 32;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_41]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 41;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_42]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 42;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_49]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 49;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_57]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 57;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_50]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 50;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_51]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 51;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_52]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 52;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_60]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 60;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_62]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 62;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VALERY_ATLAS_63]'          WHERE IconAtlas = 'VALERY_ATLAS'  AND PortraitIndex = 63;
----------------------------------------- end-----------------------------------------------------

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_SMETAL]'                  WHERE IconAtlas = 'CIV_COLOR_ATLAS_FW_PROMOTI'  AND PortraitIndex = 2;

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_PROMOMUC_00_6]'           WHERE IconAtlas = 'promoMUC_atlas_00'  AND PortraitIndex = 6;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_PROMOMUC_00_28]'          WHERE IconAtlas = 'promoMUC_atlas_00'  AND PortraitIndex = 28;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_PROMOMUC_00_37]'          WHERE IconAtlas = 'promoMUC_atlas_00'  AND PortraitIndex = 37;

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_PROMOMUC_01_9]'           WHERE IconAtlas = 'promoMUC_atlas_01'  AND PortraitIndex = 9;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_PROMOMUC_01_2]'           WHERE IconAtlas = 'promoMUC_atlas_01'  AND PortraitIndex = 2;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_PROMOMUC_01_19]'          WHERE IconAtlas = 'promoMUC_atlas_01'  AND PortraitIndex = 19;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_PROMOMUC_01_20]'          WHERE IconAtlas = 'promoMUC_atlas_01'  AND PortraitIndex = 20;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_PROMOMUC_01_23]'          WHERE IconAtlas = 'promoMUC_atlas_01'  AND PortraitIndex = 23;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_PROMOMUC_01_26]'          WHERE IconAtlas = 'promoMUC_atlas_01'  AND PortraitIndex = 26;
----------------------------------------- end-----------------------------------------------------
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MORE_NEW_PROMOS_ATLAS0]'          WHERE IconAtlas = 'MORE_NEW_PROMOS_ATLAS'  AND PortraitIndex = 0;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MORE_NEW_PROMOS_ATLAS1]'          WHERE IconAtlas = 'MORE_NEW_PROMOS_ATLAS'  AND PortraitIndex = 1;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MORE_NEW_PROMOS_ATLAS2]'          WHERE IconAtlas = 'MORE_NEW_PROMOS_ATLAS'  AND PortraitIndex = 2;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MORE_NEW_PROMOS_ATLAS4]'          WHERE IconAtlas = 'MORE_NEW_PROMOS_ATLAS'  AND PortraitIndex = 4;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MORE_NEW_PROMOS_ATLAS5]'          WHERE IconAtlas = 'MORE_NEW_PROMOS_ATLAS'  AND PortraitIndex = 5;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MORE_NEW_PROMOS_ATLAS6]'          WHERE IconAtlas = 'MORE_NEW_PROMOS_ATLAS'  AND PortraitIndex = 6;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MORE_NEW_PROMOS_ATLAS8]'          WHERE IconAtlas = 'MORE_NEW_PROMOS_ATLAS'  AND PortraitIndex = 8;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MORE_NEW_PROMOS_ATLAS10]'          WHERE IconAtlas = 'MORE_NEW_PROMOS_ATLAS'  AND PortraitIndex = 10;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MORE_NEW_PROMOS_ATLAS12]'          WHERE IconAtlas = 'MORE_NEW_PROMOS_ATLAS'  AND PortraitIndex = 12;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MORE_NEW_PROMOS_ATLAS22]'          WHERE IconAtlas = 'MORE_NEW_PROMOS_ATLAS'  AND PortraitIndex = 22;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_MORE_NEW_PROMOS_ATLAS23]'          WHERE IconAtlas = 'MORE_NEW_PROMOS_ATLAS'  AND PortraitIndex = 23;

----------------------------------------- VP0-----------------------------------------------------
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_4]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 4;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_5]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 5;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_6]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 6;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_7]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 7;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_9]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 9;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_11]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex =11 ;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_12]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 12;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_13]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex =13 ;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_14]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 14;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_16]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 16;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_17]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 17;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_18]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex =18 ;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_19]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 19;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_20]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 20;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_21]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 21;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_22]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 22;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_23]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 23;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_24]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 24;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_26]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 26;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_27]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 27;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_36]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 36;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_38]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 38;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_39]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 39;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_40]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 40;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_41]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 41;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_42]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 42;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_43]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 43;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_44]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 44;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_45]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 45;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_46]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 46;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_47]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 47;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_51]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 51;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_53]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 53;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_54]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 54;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_58]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 58;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_59]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 59;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_60]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 60;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_61]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 61;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_62]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 62;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP00_63]'          WHERE IconAtlas = 'promoVP_atlas_00'  AND PortraitIndex = 63;



----------------------------------------- VP1-----------------------------------------------------
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_3]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 3;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_5]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 5;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_7]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 7;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_10]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 10;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_11]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 11;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_12]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 12;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_13]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 13;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_14]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 14;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_15]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 15;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_16]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 16;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_17]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 17;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_18]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 18;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_20]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 20;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_21]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 21;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_22]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 22;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_28]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 28;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_29]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 29;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_30]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 30;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_47]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 47;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_55]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 55;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_56]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 56;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_58]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 58;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_59]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 59;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_61]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 61;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP01_62]'          WHERE IconAtlas = 'promoVP_atlas_01'  AND PortraitIndex = 62;


-----------------------------------------  VP2-----------------------------------------------------
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_0]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 0;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_1]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 1;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_2]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 2;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_3]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 3;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_4]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 4;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_5]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 5;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_6]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 6;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_7]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 7;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_8]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 8;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_9]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 9;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_10]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 10;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_12]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 12;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_15]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 15;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_17]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 17;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_20]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 20;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_21]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 21;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_23]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 23;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_26]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 26;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_31]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 31;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_41]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 41;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_56]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 56;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_57]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 57;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_58]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 58;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_61]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 61;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_62]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 62;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP02_63]'          WHERE IconAtlas = 'promoVP_atlas_02'  AND PortraitIndex = 63;

----------------------------------------- VP3--------------------------------------------
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP03_8]'          WHERE IconAtlas = 'promoVP_atlas_03'  AND PortraitIndex = 8;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP03_9]'          WHERE IconAtlas = 'promoVP_atlas_03'  AND PortraitIndex = 9;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP03_10]'          WHERE IconAtlas = 'promoVP_atlas_03'  AND PortraitIndex = 10;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP03_16]'          WHERE IconAtlas = 'promoVP_atlas_03'  AND PortraitIndex = 16;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP03_18]'          WHERE IconAtlas = 'promoVP_atlas_03'  AND PortraitIndex = 18;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP03_19]'          WHERE IconAtlas = 'promoVP_atlas_03'  AND PortraitIndex = 19;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP03_23]'          WHERE IconAtlas = 'promoVP_atlas_03'  AND PortraitIndex = 23;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP03_34]'          WHERE IconAtlas = 'promoVP_atlas_03'  AND PortraitIndex = 34;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP03_47]'          WHERE IconAtlas = 'promoVP_atlas_03'  AND PortraitIndex = 47;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP03_54]'          WHERE IconAtlas = 'promoVP_atlas_03'  AND PortraitIndex = 54;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP03_55]'          WHERE IconAtlas = 'promoVP_atlas_03'  AND PortraitIndex = 55;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP03_56]'          WHERE IconAtlas = 'promoVP_atlas_03'  AND PortraitIndex = 56;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_VP03_59]'          WHERE IconAtlas = 'promoVP_atlas_03'  AND PortraitIndex = 59;

----------------------------------------- ROBOT PROMO--------------------------------------------
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_ROBOT_PROMO_23]'          WHERE IconAtlas = 'robotPromo_Atlas'  AND PortraitIndex = 23;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_ROBOT_PROMO_25]'          WHERE IconAtlas = 'robotPromo_Atlas'  AND PortraitIndex = 25;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_ROBOT_PROMO_26]'          WHERE IconAtlas = 'robotPromo_Atlas'  AND PortraitIndex = 26;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_ROBOT_PROMO_45]'          WHERE IconAtlas = 'robotPromo_Atlas'  AND PortraitIndex = 45;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_ROBOT_PROMO_46]'          WHERE IconAtlas = 'robotPromo_Atlas'  AND PortraitIndex = 46;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_ROBOT_PROMO_54]'          WHERE IconAtlas = 'robotPromo_Atlas'  AND PortraitIndex = 54;
UPDATE UnitPromotions SET IconString2 = '[ICON_SPY_PROMOTION]'                     WHERE IconAtlas = 'SPY_PROMOTION_ATLAS'AND PortraitIndex = 0;  



----------------------------------------- end-----------------------------------------------------


UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ACCURACY_1]'          WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex =  0;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ACCURACY_2]'          WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex =  1;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ACCURACY_3]'          WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex =  2;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_AMBUSH_1]'            WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex =  3;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_AMBUSH_2]'            WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex =  4;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_AMPHIBIOUS]'          WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex =  5;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_BARRAGE_1]'           WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex =  6;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_BARRAGE_2]'           WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex =  7;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_BARRAGE_3]'           WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex =  8;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_BLITZ]'               WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex =  9;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_BOMBARDMENT_1]'       WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 10;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_BOMBARDMENT_2]'       WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 11;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_BOMBARDMENT_3]'       WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 12;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_HUNTDOWN_1]'          WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 13;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_COVER_1]'             WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 14;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_COVER_2]'             WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 15;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_DOGFIGHTING_1]'       WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 16;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_DOGFIGHTING_2]'       WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 17;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_DOGFIGHTING_3]'       WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 18;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_DRILL_1]'             WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 19;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_DRILL_2]'             WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 20;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_DRILL_3]'             WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 21;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_EMBARKATION]'         WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 22;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_EVASION]'             WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 23;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_FORMATION_1]'         WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 24;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_FORMATION_3]'         WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 25;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_FASTER_HEAL]'         WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 26;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_INTERCEPTION_1]'      WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 27;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_INTERCEPTION_2]'      WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 28;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_INTERCEPTION_3]'      WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 29;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_LOGISTICS]'           WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 30;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_MARCH]'               WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 31;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_MEDIC]'               WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 32;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_MOBILITY]'            WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 33;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_RANGE]'               WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 34;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_INDIRECT_FIRE]'       WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 35;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_REPAIR]'              WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 36;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SCOUTING_1]'          WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 37;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SCOUTING_2]'          WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 38;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SCOUTING_3]'          WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 39;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SIEGE_1]'             WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 40;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SIEGE_2]'             WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 41;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SIEGE_3]'             WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 42;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SENTRY]'              WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 43;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SHOCK_1]'             WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 44;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SHOCK_2]'             WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 45;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SHOCK_3]'             WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 46;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SORTIE_1]'            WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 47;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SUPPLY]'              WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 48;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SURVIVALISM_1]'       WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 49;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SURVIVALISM_2]'       WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 50;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SURVIVALISM_3]'       WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 51;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_TARGETING_1]'         WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 52;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_TARGETING_2]'         WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 53;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_TARGETING_3]'         WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 54;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_VOLLEY]'              WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 55;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_WOODSMAN]'            WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 56;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_NEGATIVE_ATTRIBUTES]' WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 57;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ABILITY]'             WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 58;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ATTRIBUTES]'          WHERE (IconAtlas = 'ABILITY_ATLAS' OR IconAtlas = 'PROMOTION_ATLAS') AND PortraitIndex = 59;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_BOARDING_PARTY_1]'    WHERE IconAtlas = 'EXPANSION_PROMOTION_ATLAS' AND PortraitIndex = 0;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_BOARDING_PARTY_2]'    WHERE IconAtlas = 'EXPANSION_PROMOTION_ATLAS' AND PortraitIndex = 1;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_BOARDING_PARTY_3]'    WHERE IconAtlas = 'EXPANSION_PROMOTION_ATLAS' AND PortraitIndex = 2;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_COASTAL_RAIDER_1]'    WHERE IconAtlas = 'EXPANSION_PROMOTION_ATLAS' AND PortraitIndex = 3;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_COASTAL_RAIDER_2]'    WHERE IconAtlas = 'EXPANSION_PROMOTION_ATLAS' AND PortraitIndex = 4;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_COASTAL_RAIDER_3]'    WHERE IconAtlas = 'EXPANSION_PROMOTION_ATLAS' AND PortraitIndex = 5;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ALTITUDE_TRAINING]'   WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex =  0;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_DESERT_WARRIOR]'      WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex =  1;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_GOLDEN_AGE_POINTS]'   WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex =  2;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_GOODY_HUT_PICKER]'    WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex =  3;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CHARGE_1]'            WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex =  4;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_LIGHTNING_WARFARE]'   WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex =  5;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SAPPER]'              WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex =  6;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_EXTENDED_PARADROP]'   WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex =  7;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_TRADE_MISSION_BONUS]' WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex =  8;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_BUFFALO_CHEST]'       WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex =  9;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_HOMELAND_GUARDIAN]'   WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex = 10;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SELL_EXOTIC_GOODS]'   WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex = 11;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ARMOR_PLATING_1]'     WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex = 12;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ARMOR_PLATING_2]'     WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex = 13;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ARMOR_PLATING_3]'     WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex = 14;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_FLIGHT_DECK_1]'       WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex = 15;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_FLIGHT_DECK_2]'       WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex = 16;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_FLIGHT_DECK_3]'       WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex = 17;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_WOLFPACK_1]'          WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex = 18;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_WOLFPACK_2]'          WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex = 19;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_WOLFPACK_3]'          WHERE IconAtlas = 'EXPANSION2_PROMOTION_ATLAS' AND PortraitIndex = 20;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_AMBITION]'            WHERE IconAtlas = 'KRIS_SWORDSMAN_PROMOTION_ATLAS' AND PortraitIndex = 0;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ENEMY_BLADE]'         WHERE IconAtlas = 'KRIS_SWORDSMAN_PROMOTION_ATLAS' AND PortraitIndex = 1;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_EVIL_SPIRITS]'        WHERE IconAtlas = 'KRIS_SWORDSMAN_PROMOTION_ATLAS' AND PortraitIndex = 2;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_HEROISM]'             WHERE IconAtlas = 'KRIS_SWORDSMAN_PROMOTION_ATLAS' AND PortraitIndex = 3;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_INVULNERABIILITY]'    WHERE IconAtlas = 'KRIS_SWORDSMAN_PROMOTION_ATLAS' AND PortraitIndex = 4;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_MYSTIC_BLADE]'        WHERE IconAtlas = 'KRIS_SWORDSMAN_PROMOTION_ATLAS' AND PortraitIndex = 5;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_RECRUITMENT]'         WHERE IconAtlas = 'KRIS_SWORDSMAN_PROMOTION_ATLAS' AND PortraitIndex = 6;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_RESTLESSNESS]'        WHERE IconAtlas = 'KRIS_SWORDSMAN_PROMOTION_ATLAS' AND PortraitIndex = 7;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SNEAK_ATTACK]'        WHERE IconAtlas = 'KRIS_SWORDSMAN_PROMOTION_ATLAS' AND PortraitIndex = 8;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_AMPHIBIOUS]'          WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex =  0;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SIEGE_3]'             WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex =  1;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SHOCK_1]'             WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex =  2;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_DRILL_1]'             WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex =  3;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_AMMUNITION_SUPPLY]'   WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex =  4;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_VOLLEY]'              WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex =  5;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_COMBAT_REDUCE]'       WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex =  6;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_PARADROP_PILLAGE]'    WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex =  7;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_FREE_2]'              WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex =  8;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_PARADROP_MOBILITY]'   WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex =  9;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_FREE_1]'              WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 10;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_HOMELAND_GUARDIAN]'   WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 11;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_EMBARKATION]'         WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 12;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_LOGISTICS]'           WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 13;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_OUTFLANK]'            WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 14;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_MEDIC]'               WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 15;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_MOBILITY]'            WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 16;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SIGEL]'               WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 17;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SCOUTING_1]'          WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 18;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_GREEN]'               WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 19;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_HUGER]'               WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 20;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SICKLES]'             WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 21;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_HOWARD]'              WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 22;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_MOBILITY_REDUCE]'     WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 23;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SIGHT_REDUCE]'        WHERE (IconAtlas = 'CIVIL_WAR_UNION_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_CONFED_PROMOTION_ATLAS' OR IconAtlas = 'CIVIL_WAR_PROMOTION_ATLAS') AND PortraitIndex = 24;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_EVASION_I]'           WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex =  0;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_EMP_ATTACK]'          WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex =  1;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_COVER_3]'             WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex =  2;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SORTIE_2]'            WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex =  3;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_MISSILE_CARRIER]'     WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex =  4;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CHARGE_NEW_1]'        WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex =  5;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CHARGE_NEW_2]'        WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex =  6;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CHARGE_NEW_3]'        WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex =  7;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SUNDER_1]'            WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex =  8;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SUNDER_2]'            WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex =  9;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SUNDER_3]'            WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 10;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_HUNTDOWN_NEW_1]'      WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 11;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_HUNTDOWN_NEW_2]'      WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 12;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_HUNTDOWN_NEW_3]'      WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 13;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CQB_COMBAT_1]'        WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 14;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CQB_COMBAT_2]'        WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 15;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_RANGE_REDUCE]'        WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 16;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_PENETRATION]'         WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 17;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_COMBAT_REDUCE]'       WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 18;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_MORAL_WEAKEN]'        WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 19;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_MOVEMENT_LOST]'       WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 20;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_MOBILITY_REDUCE]'     WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 21;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_FIGHTER_SIEGE_1]'     WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 22;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_FIGHTER_SIEGE_2]'     WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 23;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_LOSE_SUPPLY]'         WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 24;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CARRIER_SUPPLY_2]'    WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 25;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CARRIER_SUPPLY_3]'    WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 26;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CARGO_I]'             WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 27;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CARGO_II]'            WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 28;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CARGO_IV]'            WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 29;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CARGO_VI]'            WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 30;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CARGO_IX]'            WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 31;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ELITE]'               WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 32;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CAN_MOVE_AFTER]'      WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 33;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_OUTFLANK]'            WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 34;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_PARADROP]'            WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 35;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_FIRESUPPORT_1]'       WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 36;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_FIRESUPPORT_2]'       WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 37;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_COLLATERAL_DAMAGE_1]' WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 38;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CLUSTER_ROCKET_II]'   WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 39;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_INFANTRY_COMBAT]'     WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 40;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_GUNPOWDER_INFANTRY]'  WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 41;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ANTI_MOUNTED]'        WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 42;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ANTI_TANK]'           WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 43;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ARCHERY_COMBAT]'      WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 44;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CITY_SIEGE]'          WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 45;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SPLASH_DAMAGE]'       WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 46;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SPECIAL_FORCES]'      WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 47;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_MILITIA_COMBAT]'      WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 48;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_KNIGHT_COMBAT]'       WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 49;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_TANK_COMBAT]'         WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 50;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_HITANDRUN]'           WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 51;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_HELI_ATTACK]'         WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 52;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_NAVALMELEE_COMBAT]'   WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 53;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_NAVAL_HIT_AND_RUN]'   WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 54;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_NAVAL_CAPITAL_SHIP]'  WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 55;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SUBMARINE_COMBAT]'    WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 56;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CARRIER_UNIT]'        WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 57;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ANTI_AIR_II]'         WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 58;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_AIR_ATTACK]'          WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 59;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_STRATEGIC_BOMBER]'    WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 60;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CARRIER_FIGHTER]'     WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 61;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_NAVAL_RANGED_SHIP]'   WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 62;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ANTI_AIR_III]'        WHERE IconAtlas = 'SP_PROMOTION_ATLAS' AND PortraitIndex = 63;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_FORMATION_2]'         WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex =  0;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_AMBUSH_3]'            WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex =  1;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_COVER_3]'             WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex =  2;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SORTIE_2]'            WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex =  3;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_RANGE]'               WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex =  4;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_REPAIR_II]'           WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex =  5;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SUNDER_1]'            WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex =  6;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SUNDER_2]'            WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex =  7;
UPDATE UnitPromotions SET IconString2 = '[PROMOTION_CHARGE_1]'                     WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex =  8;
UPDATE UnitPromotions SET IconString2 = '[PROMOTION_CHARGE_2]'                     WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex =  9;
UPDATE UnitPromotions SET IconString2 = '[PROMOTION_CHARGE_3]'                     WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex = 10;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_HUNTDOWN_2]'          WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex = 11;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_HUNTDOWN_3]'          WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex = 12;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_COLLATERAL_DAMAGE_1]' WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex = 13;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_COLLATERAL_DAMAGE_2]' WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex = 14;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_COLLATERAL_DAMAGE_3]' WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex = 15;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_RANGE_REDUCE]'        WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex = 16;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_CAN_MOVE_AFTER]'      WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex = 17;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_ELITE]'               WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex = 18;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_SPACE_ELEVATOR]'      WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex = 19;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_GROUP]'               WHERE (IconAtlas = 'SP_PROMOTION_OLD_ATLAS' OR IconAtlas = 'SPPROMOTION_ATLAS') AND PortraitIndex = 20;
UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_NEW_GROUP]'               WHERE IconAtlas = 'GROUP_PROMOTION_ATLAS';

UPDATE UnitPromotions SET IconString2 = '[ICON_PROMOTION_SP10_' || CAST(PortraitIndex+1 AS TEXT)|| ']' WHERE IconAtlas = 'SP10_PROMOTION_ATLAS';

--角斗士
INSERT INTO ArtDefine_UnitInfos (Type,DamageStates,Formation) VALUES ('ART_DEF_UNIT_GLADIATOR', 1, "DefaultMelee");	

INSERT INTO ArtDefine_UnitInfoMemberInfos VALUES ('ART_DEF_UNIT_GLADIATOR', 'ART_DEF_UNIT_MEMBER_GLADIATOR_1', "3");
INSERT INTO ArtDefine_UnitInfoMemberInfos VALUES ('ART_DEF_UNIT_GLADIATOR', 'ART_DEF_UNIT_MEMBER_GLADIATOR_2', "3");
INSERT INTO ArtDefine_UnitInfoMemberInfos VALUES ('ART_DEF_UNIT_GLADIATOR', 'ART_DEF_UNIT_MEMBER_GLADIATOR_3', "3");
INSERT INTO ArtDefine_UnitInfoMemberInfos VALUES ('ART_DEF_UNIT_GLADIATOR', 'ART_DEF_UNIT_MEMBER_GLADIATOR_4', "3");
-- ==================================================================================================================================================================
-- Unit Member Infos

INSERT INTO ArtDefine_UnitMemberInfos (Type,					Scale,	 ZOffset, Domain, Model,									MaterialTypeTag, MaterialTypeSoundOverrideTag)
	SELECT	('ART_DEF_UNIT_MEMBER_GLADIATOR_1'),	'0.145', ZOffset, Domain, ('Myrmillo.fxsxml'),	MaterialTypeTag, MaterialTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberInfos WHERE (Type = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberInfos (Type,					Scale,	 ZOffset, Domain, Model,									MaterialTypeTag, MaterialTypeSoundOverrideTag)
	SELECT	('ART_DEF_UNIT_MEMBER_GLADIATOR_2'),	'0.145', ZOffset, Domain, ('Samnite.fxsxml'), MaterialTypeTag, MaterialTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberInfos WHERE (Type = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberInfos (Type,					Scale,	 ZOffset, Domain, Model,									MaterialTypeTag, MaterialTypeSoundOverrideTag)
	SELECT	('ART_DEF_UNIT_MEMBER_GLADIATOR_3'),	'0.145', ZOffset, Domain, ('Secutor2.fxsxml'), MaterialTypeTag, MaterialTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberInfos WHERE (Type = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberInfos (Type,					Scale,	 ZOffset, Domain, Model,									MaterialTypeTag, MaterialTypeSoundOverrideTag)
	SELECT	('ART_DEF_UNIT_MEMBER_GLADIATOR_4'),	'0.145', ZOffset, Domain, ('Velite.fxsxml'), MaterialTypeTag, MaterialTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberInfos WHERE (Type = 'ART_DEF_UNIT_MEMBER_SPEARMAN');




INSERT INTO ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
	SELECT	('ART_DEF_UNIT_MEMBER_GLADIATOR_1'), EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation
	FROM ArtDefine_UnitMemberCombats WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
	SELECT	('ART_DEF_UNIT_MEMBER_GLADIATOR_2'), EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation
	FROM ArtDefine_UnitMemberCombats WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
	SELECT	('ART_DEF_UNIT_MEMBER_GLADIATOR_3'), EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation
	FROM ArtDefine_UnitMemberCombats WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
	SELECT	('ART_DEF_UNIT_MEMBER_GLADIATOR_4'), EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation
	FROM ArtDefine_UnitMemberCombats WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_SPEARMAN');



INSERT INTO ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
	SELECT ('ART_DEF_UNIT_MEMBER_GLADIATOR_1'), "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberCombatWeapons WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
	SELECT ('ART_DEF_UNIT_MEMBER_GLADIATOR_2'), "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberCombatWeapons WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
	SELECT ('ART_DEF_UNIT_MEMBER_GLADIATOR_3'), "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberCombatWeapons WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
	SELECT ('ART_DEF_UNIT_MEMBER_GLADIATOR_4'), "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberCombatWeapons WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_SPEARMAN');





--长剑

INSERT INTO ArtDefine_UnitInfos (Type,DamageStates,Formation) VALUES ('ART_DEF_UNIT_EXOTIC_UNIT_CONDOTTIERI', 1, "DefaultMelee");	

INSERT INTO ArtDefine_UnitInfoMemberInfos VALUES ('ART_DEF_UNIT_EXOTIC_UNIT_CONDOTTIERI', 'ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_1', "2");
INSERT INTO ArtDefine_UnitInfoMemberInfos VALUES ('ART_DEF_UNIT_EXOTIC_UNIT_CONDOTTIERI', 'ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_2', "2");
INSERT INTO ArtDefine_UnitInfoMemberInfos VALUES ('ART_DEF_UNIT_EXOTIC_UNIT_CONDOTTIERI', 'ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_3', "2");
INSERT INTO ArtDefine_UnitInfoMemberInfos VALUES ('ART_DEF_UNIT_EXOTIC_UNIT_CONDOTTIERI', 'ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_4', "2");


-- ==================================================================================================================================================================
-- Unit Member Infos

INSERT INTO ArtDefine_UnitMemberInfos (Type,					Scale,	 ZOffset, Domain, Model,									MaterialTypeTag, MaterialTypeSoundOverrideTag)
	SELECT	('ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_1'),	'0.145', ZOffset, Domain, ('SMAN_EU_Condittieri_Milan.fxsxml'),	MaterialTypeTag, MaterialTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberInfos WHERE (Type = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberInfos (Type,					Scale,	 ZOffset, Domain, Model,									MaterialTypeTag, MaterialTypeSoundOverrideTag)
	SELECT	('ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_2'),	'0.145', ZOffset, Domain, ('SMAN_EU_Condittieri_Ragusa.fxsxml'), MaterialTypeTag, MaterialTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberInfos WHERE (Type = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberInfos (Type,					Scale,	 ZOffset, Domain, Model,									MaterialTypeTag, MaterialTypeSoundOverrideTag)
	SELECT	('ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_3'),	'0.145', ZOffset, Domain, ('SMAN_EU_Condittieri_Venice.fxsxml'), MaterialTypeTag, MaterialTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberInfos WHERE (Type = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberInfos (Type,					Scale,  ZOffset, Domain, Model,								MaterialTypeTag, MaterialTypeSoundOverrideTag)
	SELECT	('ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_4'), '0.145', ZOffset, Domain, ('SMAN_EU_Condittieri_HRE.fxsxml'), MaterialTypeTag, MaterialTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberInfos WHERE (Type = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');



INSERT INTO ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
	SELECT	('ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_1'), EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation
	FROM ArtDefine_UnitMemberCombats WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
	SELECT	('ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_2'), EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation
	FROM ArtDefine_UnitMemberCombats WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
	SELECT	('ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_3'), EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation
	FROM ArtDefine_UnitMemberCombats WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
	SELECT	('ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_4'), EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation
	FROM ArtDefine_UnitMemberCombats WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');




INSERT INTO ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
	SELECT ('ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_1'), "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberCombatWeapons WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
	SELECT ('ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_2'), "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberCombatWeapons WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
	SELECT ('ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_3'), "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberCombatWeapons WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');

INSERT INTO ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
	SELECT ('ART_DEF_UNIT_MEMBER_EXOTIC_UNIT_CONDOTTIERI_4'), "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag
	FROM ArtDefine_UnitMemberCombatWeapons WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN');










-- Napoleonic Limbered Art
INSERT INTO ArtDefine_UnitInfos(Type, DamageStates, Formation)
  VALUES ('ART_DEF_UNIT_HORSE_ARTILLERY', 1, 'ChariotElephant');
INSERT INTO ArtDefine_UnitInfoMemberInfos(UnitInfoType, UnitMemberInfoType, NumMembers)
  VALUES ('ART_DEF_UNIT_HORSE_ARTILLERY', 'ART_DEF_UNIT_MEMBER_HORSE_ARTILLERY', 2);
INSERT INTO ArtDefine_UnitMemberInfos(Type, Scale, Model, MaterialTypeTag, MaterialTypeSoundOverrideTag)
  VALUES ('ART_DEF_UNIT_MEMBER_HORSE_ARTILLERY', 0.119999995231628, 'horseartillery.fxsxml', 'CLOTH', 'WOODSM');
INSERT INTO ArtDefine_UnitMemberCombats(UnitMemberType, EnableActions, ShortMoveRadius, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasStationaryMelee, HasRefaceAfterCombat, ReformBeforeCombat, OnlyTurnInMovementActions)
  VALUES ('ART_DEF_UNIT_MEMBER_HORSE_ARTILLERY', 'Idle Attack RunCharge AttackCity Bombard Death BombardDefend Run Fortify CombatReady Walk', 24.0, 0.349999994039536, 0.5, 0.75, 15.0, 20.0, 12.0, 1, 1, 1, 1, 1, 1);
INSERT INTO ArtDefine_UnitMemberCombatWeapons(UnitMemberType, "Index", SubIndex, WeaponTypeTag, WeaponTypeSoundOverrideTag)
  VALUES ('ART_DEF_UNIT_MEMBER_HORSE_ARTILLERY', 0, 0, 'METAL', 'SWORD');
INSERT INTO ArtDefine_UnitMemberCombatWeapons(UnitMemberType, "Index", SubIndex, VisKillStrengthMin, VisKillStrengthMax, WeaponTypeTag, MissTargetSlopRadius)
  VALUES ('ART_DEF_UNIT_MEMBER_HORSE_ARTILLERY', 1, 0, 10.0, 20.0, 'FLAMING_ARROW', 10.0);


-- Napoleonic Cannon Art
INSERT INTO ArtDefine_UnitInfos(Type, DamageStates, Formation)
  VALUES ('ART_DEF_UNIT_RHA_CANNON', 1, 'TwoBigGuns');
INSERT INTO ArtDefine_UnitInfoMemberInfos(UnitInfoType, UnitMemberInfoType, NumMembers)
  VALUES ('ART_DEF_UNIT_RHA_CANNON', 'ART_DEF_UNIT_MEMBER_RHA_CANNON', 2);
INSERT INTO ArtDefine_UnitMemberInfos(Type, Scale, Model, MaterialTypeTag, MaterialTypeSoundOverrideTag)
  VALUES ('ART_DEF_UNIT_MEMBER_RHA_CANNON', 0.109999997317791, 'RHA_Cannon.fxsxml', 'WOOD', 'WOODSM');
INSERT INTO ArtDefine_UnitMemberCombats(UnitMemberType, EnableActions, HasShortRangedAttack, HasLongRangedAttack, HasStationaryMelee, HasRefaceAfterCombat, ReformBeforeCombat)
  VALUES ('ART_DEF_UNIT_MEMBER_RHA_CANNON', 'Idle Attack RunCharge AttackCity Bombard Death BombardDefend Run Fortify CombatReady', 1, 1, 1, 1, 1);
INSERT INTO ArtDefine_UnitMemberCombatWeapons(UnitMemberType, "Index", SubIndex, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, HitEffect, WeaponTypeTag, WeaponTypeSoundOverrideTag)
  VALUES ('ART_DEF_UNIT_MEMBER_RHA_CANNON', 0, 0, 25.0, 50.0, 5.0, 'ART_DEF_VEFFECT_CANNON_IMPACT_$(TERRAIN)', 'EXPLOSIVE', 'EXPLOSION6POUND');


--==========================================================================================================================
-- 镰刀战车
--==========================================================================================================================
 INSERT INTO ArtDefine_UnitInfos(Type, DamageStates, Formation)
  VALUES ('ART_DEF_UNIT_SICKLE_CHARIOT', 1, 'TwoBigGuns');
INSERT INTO ArtDefine_UnitInfoMemberInfos(UnitInfoType, UnitMemberInfoType, NumMembers)
  VALUES ('ART_DEF_UNIT_SICKLE_CHARIOT', 'ART_DEF_UNIT_MEMBER_SICKLE_CHARIOT', 2);
INSERT INTO ArtDefine_UnitMemberInfos(Type, Scale, Model, MaterialTypeTag, MaterialTypeSoundOverrideTag)
  VALUES ('ART_DEF_UNIT_MEMBER_SICKLE_CHARIOT', 0.144999995827675, 'Chariot_Persia.fxsxml', 'CLOTH', 'WOODSM');
INSERT INTO ArtDefine_UnitMemberCombats(UnitMemberType, EnableActions, ShortMoveRadius, ShortMoveRate, TargetHeight, HasRefaceAfterCombat)
  VALUES ('ART_DEF_UNIT_MEMBER_SICKLE_CHARIOT', 'Idle Attack RunCharge AttackCity Bombard Death BombardDefend Run Fortify CombatReady Walk AttackCharge', 12.0, 0.349999994039536, 8.0, 1);
INSERT INTO ArtDefine_UnitMemberCombatWeapons(UnitMemberType, "Index", SubIndex, WeaponTypeTag, WeaponTypeSoundOverrideTag)
  VALUES ('ART_DEF_UNIT_MEMBER_SICKLE_CHARIOT', 0, 0, 'METAL', 'SWORD');
INSERT INTO ArtDefine_UnitMemberCombatWeapons(UnitMemberType, "Index", SubIndex, VisKillStrengthMin, VisKillStrengthMax, WeaponTypeTag, MissTargetSlopRadius)
  VALUES ('ART_DEF_UNIT_MEMBER_SICKLE_CHARIOT', 1, 0, 10.0, 20.0, 'FLAMING_ARROW', 10.0);

--==========================================================================================================================
-- 投石
--==========================================================================================================================
INSERT INTO ArtDefine_UnitInfos 
			(Type,						DamageStates,	Formation)
SELECT		'ART_DEF_UNIT_BLIALI', 	DamageStates, 	Formation
FROM ArtDefine_UnitInfos WHERE Type = 'ART_DEF_UNIT_U_INCAN_SLINGER';

INSERT INTO ArtDefine_UnitInfoMemberInfos 	
			(UnitInfoType,				UnitMemberInfoType,					NumMembers)
SELECT		'ART_DEF_UNIT_BLIALI', 	'ART_DEF_UNIT_MEMBER_BLIALI',	NumMembers
FROM ArtDefine_UnitInfoMemberInfos WHERE UnitInfoType = 'ART_DEF_UNIT_U_INCAN_SLINGER';

INSERT INTO ArtDefine_UnitMemberCombats 
			(UnitMemberType,					EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
SELECT		'ART_DEF_UNIT_MEMBER_BLIALI',	EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation
FROM ArtDefine_UnitMemberCombats WHERE UnitMemberType = 'ART_DEF_UNIT_MEMBER_U_INCAN_SLINGER';

INSERT INTO ArtDefine_UnitMemberCombatWeapons	
			(UnitMemberType,					"Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
SELECT		'ART_DEF_UNIT_MEMBER_BLIALI',	"Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag
FROM ArtDefine_UnitMemberCombatWeapons WHERE UnitMemberType = 'ART_DEF_UNIT_MEMBER_U_INCAN_SLINGER';

INSERT INTO ArtDefine_UnitMemberInfos 	
		(Type, 								Scale, ZOffset, Domain, Model, 						MaterialTypeTag, MaterialTypeSoundOverrideTag)
SELECT	'ART_DEF_UNIT_MEMBER_BLIALI',	Scale, ZOffset, Domain, 'hebrew_slinger.fxsxml',	MaterialTypeTag, MaterialTypeSoundOverrideTag
FROM ArtDefine_UnitMemberInfos WHERE Type = 'ART_DEF_UNIT_MEMBER_U_INCAN_SLINGER';



--==========================================================================================================================
-- 蠕虫
--==========================================================================================================================
INSERT INTO ArtDefine_UnitInfos (Type,		DamageStates,	Formation)
SELECT	'ART_DEF_UNIT_SPORE_LAUNCHER',	1,				'UnFormed';

INSERT INTO ArtDefine_UnitInfoMemberInfos (UnitInfoType,	UnitMemberInfoType,							NumMembers)
SELECT	'ART_DEF_UNIT_SPORE_LAUNCHER',					'ART_DEF_UNIT_MEMBER_SPORE_LAUNCHER',	1;

INSERT INTO ArtDefine_UnitMemberCombats (UnitMemberType,	EnableActions,	DisableActions,	MoveRadius,	ShortMoveRadius,	ChargeRadius,	AttackRadius,	RangedAttackRadius,	MoveRate,	ShortMoveRate,	TurnRateMin,	TurnRateMax,	TurnFacingRateMin,	TurnFacingRateMax,	RollRateMin,	RollRateMax,	PitchRateMin,	PitchRateMax,	LOSRadiusScale,	TargetRadius,	TargetHeight,	HasShortRangedAttack,	HasLongRangedAttack,	HasLeftRightAttack,	HasStationaryMelee,	HasStationaryRangedAttack,	HasRefaceAfterCombat,	ReformBeforeCombat,	HasIndependentWeaponFacing,	HasOpponentTracking,	HasCollisionAttack,	AttackAltitude,	AltitudeDecelerationDistance,	OnlyTurnInMovementActions,	RushAttackFormation)
SELECT	('ART_DEF_UNIT_MEMBER_SPORE_LAUNCHER'),			EnableActions,	DisableActions,	MoveRadius,	ShortMoveRadius,	ChargeRadius,	AttackRadius,	RangedAttackRadius,	MoveRate,	ShortMoveRate,	TurnRateMin,	TurnRateMax,	TurnFacingRateMin,	TurnFacingRateMax,	RollRateMin,	RollRateMax,	PitchRateMin,	PitchRateMax,	LOSRadiusScale,	TargetRadius,	TargetHeight,	HasShortRangedAttack,	HasLongRangedAttack,	HasLeftRightAttack,	HasStationaryMelee,	HasStationaryRangedAttack,	HasRefaceAfterCombat,	ReformBeforeCombat,	HasIndependentWeaponFacing,	HasOpponentTracking,	HasCollisionAttack,	AttackAltitude,	AltitudeDecelerationDistance,	OnlyTurnInMovementActions,	RushAttackFormation
FROM ArtDefine_UnitMemberCombats		WHERE UnitMemberType = 'ART_DEF_UNIT_MEMBER_SCOUT';

INSERT INTO ArtDefine_UnitMemberCombatWeapons ('UnitMemberType',	'Index', 'SubIndex', 'ID', 'VisKillStrengthMin', 'VisKillStrengthMax', 'ProjectileSpeed', 'ProjectileTurnRateMin', 'ProjectileTurnRateMax', 'HitEffect', 'HitEffectScale', 'HitRadius', 'ProjectileChildEffectScale', 'AreaDamageDelay', 'ContinuousFire', 'WaitForEffectCompletion', 'TargetGround', 'IsDropped', 'WeaponTypeTag', 'WeaponTypeSoundOverrideTag')
SELECT ('ART_DEF_UNIT_MEMBER_SPORE_LAUNCHER'),					"Index", "SubIndex", "ID", "VisKillStrengthMin", "VisKillStrengthMax", "ProjectileSpeed", "ProjectileTurnRateMin", "ProjectileTurnRateMax", "HitEffect", "HitEffectScale", "HitRadius", "ProjectileChildEffectScale", "AreaDamageDelay", "ContinuousFire", "WaitForEffectCompletion", "TargetGround", "IsDropped", "WeaponTypeTag", "WeaponTypeSoundOverrideTag"
FROM ArtDefine_UnitMemberCombatWeapons	WHERE (UnitMemberType = 'ART_DEF_UNIT_MEMBER_SCOUT');

INSERT INTO ArtDefine_UnitMemberInfos (Type,		Scale,		ZOffset,	Domain,		Model,					MaterialTypeTag,	 MaterialTypeSoundOverrideTag)
SELECT	('ART_DEF_UNIT_MEMBER_SPORE_LAUNCHER'),	'2.60',		ZOffset,	Domain,		('Sandworm.fxsxml'),	MaterialTypeTag,	 MaterialTypeSoundOverrideTag
FROM ArtDefine_UnitMemberInfos			WHERE Type = 'ART_DEF_UNIT_MEMBER_SCOUT';

--==========================================================================================================================
-- 防沙工程
--==========================================================================================================================
INSERT INTO ArtDefine_StrategicView 
		(StrategicViewType, 				TileType,		Asset)
VALUES	('ART_DEF_IMPROVEMENT_YERBAMATE',	'Improvement',	'SV_Improvement_Yerbamate.dds');
		
INSERT INTO ArtDefine_LandmarkTypes
		(Type,								LandmarkType,	FriendlyName)
VALUES	('ART_DEF_IMPROVEMENT_YERBAMATE',	'Improvement',	'Yerbamate Plantation');

INSERT INTO ArtDefine_Landmarks
		(Era,	State,					Scale,	ImprovementType,					LayoutHandler,	ResourceType,			Model,					TerrainContour)
VALUES	('Any',	'UnderConstruction',	0.001,	'ART_DEF_IMPROVEMENT_YERBAMATE',	'SNAPSHOT',		'ART_DEF_RESOURCE_ALL',	'yerbamate_hb.fxsxml',	1),
		('Any',	'Constructed',			0.001,	'ART_DEF_IMPROVEMENT_YERBAMATE',	'SNAPSHOT',		'ART_DEF_RESOURCE_ALL',	'yerbamate.fxsxml',		1),
		('Any',	'Pillaged',				0.001,	'ART_DEF_IMPROVEMENT_YERBAMATE',	'SNAPSHOT',		'ART_DEF_RESOURCE_ALL',	'yerbamate_pl.fxsxml',	1);



--==========================================================================================================================
-- 新农场
--==========================================================================================================================
INSERT INTO ArtDefine_LandmarkTypes(Type, LandmarkType, FriendlyName)
SELECT 'ART_DEF_IMPROVEMENT_KIBBUTZ', 'Improvement', 'KIBBUTZ';


INSERT INTO ArtDefine_Landmarks(Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour)
SELECT 'Any', 'UnderConstruction', 0.8,  'ART_DEF_IMPROVEMENT_KIBBUTZ', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'kibbutz_hb.fxsxml', 1 UNION ALL
SELECT 'Any', 'Constructed', 0.8,  'ART_DEF_IMPROVEMENT_KIBBUTZ', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'kibbutz.fxsxml', 1 UNION ALL
SELECT 'Any', 'Pillaged', 0.6,  'ART_DEF_IMPROVEMENT_KIBBUTZ', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'kibbutz_pl.fxsxml', 1;


INSERT INTO ArtDefine_StrategicView(StrategicViewType, TileType, Asset)
SELECT 'ART_DEF_IMPROVEMENT_KIBBUTZ', 'Improvement', 'sv_KIBBUTZ.dds';


--==========================================================================================================================
-- Embassy
--==========================================================================================================================
INSERT INTO ArtDefine_LandmarkTypes(Type, LandmarkType, FriendlyName)
SELECT 'ART_DEF_IMPROVEMENT_EMBASSY', 'Improvement', 'EMBASSY';

INSERT INTO ArtDefine_Landmarks(Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour)
SELECT 'Any', 'UnderConstruction', 1.45,  'ART_DEF_IMPROVEMENT_EMBASSY', 'RANDOM', 'ART_DEF_RESOURCE_ALL', 'Embassy.fxsxml', 1 UNION ALL
SELECT 'Any', 'Constructed', 1.45,  'ART_DEF_IMPROVEMENT_EMBASSY', 'RANDOM', 'ART_DEF_RESOURCE_ALL', 'Embassy.fxsxml', 1 UNION ALL
SELECT 'Any', 'Pillaged', 1.45,  'ART_DEF_IMPROVEMENT_EMBASSY', 'RANDOM', 'ART_DEF_RESOURCE_ALL', 'Embassy.fxsxml', 1;
--==========================================================================================================================

--==========================================================================================================================
-- 新村落
--==========================================================================================================================
INSERT INTO ArtDefine_LandmarkTypes 
			(Type, 								LandmarkType,	FriendlyName)
VALUES		('ART_DEF_IMPROVEMENT_MBANZA',	'Improvement', 	'MBANZA');

INSERT INTO ArtDefine_Landmarks 
			(ImprovementType, 						Era,	State,				 Scale, LayoutHandler,	ResourceType,			Model,			TerrainContour)
VALUES		('ART_DEF_IMPROVEMENT_MBANZA',			'Any', 	'UnderConstruction',	1,	'SNAPSHOT',		'ART_DEF_RESOURCE_ALL', 'Mbanza_HB.fxsxml', 1),
			('ART_DEF_IMPROVEMENT_MBANZA',			'Any', 	'Constructed',			 1,	'SNAPSHOT',		'ART_DEF_RESOURCE_ALL', 'Mbanza_B.fxsxml',  1),
			('ART_DEF_IMPROVEMENT_MBANZA',			'Any', 	'Pillaged',				 1,	'SNAPSHOT',		'ART_DEF_RESOURCE_ALL', 'Mbanza_PL.fxsxml', 1);




INSERT OR REPLACE INTO Plot_AdjacentFeatureYieldChanges 
		(FeatureType,				PlotType,			YieldType,			Yield,	IgnoreNaturalWonderPlots)
VALUES	('FEATURE_LAKE_VICTORIA',	'PLOT_LAND',		'YIELD_FOOD',			1,		0),
        ('FEATURE_LAKE_VICTORIA',	'PLOT_HILLS',		'YIELD_FOOD',			1,		0),
		('FEATURE_LAKE_VICTORIA',	'PLOT_MOUNTAIN',	'YIELD_FOOD',			1,		0),

        ('FEATURE_EL_DORADO',		'PLOT_LAND',		'YIELD_GOLD',			1,		0),
		('FEATURE_EL_DORADO',	    'PLOT_HILLS',		'YIELD_GOLD',			1,		0),
		('FEATURE_EL_DORADO',	    'PLOT_MOUNTAIN',	'YIELD_GOLD',			1,		0),
		('FEATURE_EL_DORADO',		'PLOT_LAND',		'YIELD_CULTURE',		1,		0),
		('FEATURE_EL_DORADO',	    'PLOT_HILLS',		'YIELD_CULTURE',		1,		0),
		('FEATURE_EL_DORADO',	    'PLOT_MOUNTAIN',	'YIELD_CULTURE',		1,		0),

		('FEATURE_POTOSI',		    'PLOT_LAND',		'YIELD_GOLD',			1,		0),
		('FEATURE_POTOSI',	        'PLOT_HILLS',		'YIELD_GOLD',		    1,		0),
		('FEATURE_POTOSI',	        'PLOT_MOUNTAIN',	'YIELD_GOLD',		    1,		0),

		('FEATURE_SOLOMONS_MINES',	'PLOT_LAND',	    'YIELD_PRODUCTION',		1,		0),
		('FEATURE_SOLOMONS_MINES',	'PLOT_HILLS',		'YIELD_PRODUCTION',		1,		0),
		('FEATURE_SOLOMONS_MINES',	'PLOT_MOUNTAIN',	'YIELD_PRODUCTION',		1,		0),

		('FEATURE_MT_SINAI',		'PLOT_LAND',		'YIELD_FAITH',		    1,		0),
		('FEATURE_MT_SINAI',	    'PLOT_HILLS',		'YIELD_FAITH',		    1,		0),
		('FEATURE_MT_SINAI',	    'PLOT_MOUNTAIN',	'YIELD_FAITH',		    1,		0),

		('FEATURE_CRATER',		    'PLOT_LAND',		'YIELD_SCIENCE',		2,		0),
		('FEATURE_CRATER',	        'PLOT_HILLS',		'YIELD_SCIENCE',		2,		0),
		('FEATURE_CRATER',	        'PLOT_MOUNTAIN',	'YIELD_SCIENCE',		2,		0),

		('FEATURE_GEYSER',		    'PLOT_LAND',		'YIELD_TOURISM',		1,		0),
		('FEATURE_GEYSER',	        'PLOT_HILLS',		'YIELD_TOURISM',		1,		0),
		('FEATURE_GEYSER',	        'PLOT_MOUNTAIN',	'YIELD_TOURISM',		1,		0),

		('FEATURE_FOUNTAIN_YOUTH',	'PLOT_LAND',	    'YIELD_HEALTH',		    1,		0),
		('FEATURE_FOUNTAIN_YOUTH',	'PLOT_HILLS',		'YIELD_HEALTH',		    1,		0),
		('FEATURE_FOUNTAIN_YOUTH',	'PLOT_MOUNTAIN',	'YIELD_HEALTH',		    1,		0);



--=======================================================================================================================
-- 新自然奇观
--=======================================================================================================================

INSERT INTO Feature_YieldChanges
		(FeatureType,			YieldType,				Yield)
VALUES	('FEATURE_MT_EVEREST',	'YIELD_FAITH',			4),
		('FEATURE_MT_EVEREST',	'YIELD_CULTURE',		4),
		('FEATURE_MT_EVEREST',	'YIELD_GOLD',			4),
		('FEATURE_MT_EVEREST',	'YIELD_HEALTH',			3),

		('FEATURE_SALAR_A',		'YIELD_PRODUCTION',		3),
		('FEATURE_SALAR_A',		'YIELD_GOLD',			3),
		('FEATURE_SALAR_A',		'YIELD_CULTURE',		3),
		('FEATURE_SALAR_A',		'YIELD_SCIENCE',		3),
		('FEATURE_SALAR_B',		'YIELD_PRODUCTION',		2),
		('FEATURE_SALAR_B',		'YIELD_GOLD',			1),
		('FEATURE_SALAR_B',		'YIELD_CULTURE',		1),
		('FEATURE_SALAR_B',		'YIELD_SCIENCE',		1),
		
		('FEATURE_RETBA',		'YIELD_PRODUCTION',		2),
		('FEATURE_RETBA',		'YIELD_SCIENCE',		1),
		('FEATURE_RETBA',		'YIELD_CULTURE',		2),
		('FEATURE_RETBA',		'YIELD_TOURISM',		1),

		('FEATURE_LUMI_BAY',	'YIELD_GOLD',			5),
		('FEATURE_LUMI_BAY',	'YIELD_SCIENCE',		4),
		('FEATURE_LUMI_BAY',	'YIELD_TOURISM',		3),

		('FEATURE_CAUSEWAY_A',	'YIELD_GOLD',			2),
		('FEATURE_CAUSEWAY_A',	'YIELD_SCIENCE',		1),
		('FEATURE_CAUSEWAY_A',	'YIELD_PRODUCTION',		5),
		('FEATURE_CAUSEWAY_A',	'YIELD_GOLDEN_AGE_POINTS',2),
		('FEATURE_CAUSEWAY_A',	'YIELD_TOURISM',2),

		('FEATURE_DALLOL',		'YIELD_PRODUCTION',		4),
		('FEATURE_DALLOL',		'YIELD_SCIENCE',		3),
		('FEATURE_DALLOL',		'YIELD_TOURISM',		2);




		

INSERT INTO Plot_AdjacentFeatureYieldChanges (FeatureType,	PlotType,	YieldType,	Yield,	IgnoreNaturalWonderPlots)
VALUES	('FEATURE_MT_EVEREST',		'PLOT_LAND',		'YIELD_FOOD',			1,		0),
		('FEATURE_MT_EVEREST',		'PLOT_HILLS',		'YIELD_FOOD',			1,		0),
		('FEATURE_MT_EVEREST',		'PLOT_MOUNTAIN',	'YIELD_FOOD',			1,		0),

		('FEATURE_MT_EVEREST',		'PLOT_LAND',		'YIELD_SCIENCE',		1,		0),
		('FEATURE_MT_EVEREST',		'PLOT_HILLS',		'YIELD_SCIENCE',		1,		0),
		('FEATURE_MT_EVEREST',		'PLOT_MOUNTAIN',	'YIELD_SCIENCE',		1,		0),

		('FEATURE_LUMI_BAY',		'PLOT_OCEAN',		'YIELD_TOURISM',		1,		0),
		('FEATURE_LUMI_BAY',		'PLOT_OCEAN',		'YIELD_GOLD',		    2,		0),
		('FEATURE_LUMI_BAY',		'PLOT_OCEAN',		'YIELD_FOOD',		    1,		0),
		('FEATURE_LUMI_BAY',		'PLOT_OCEAN',		'YIELD_SCIENCE',		1,		0),

		('FEATURE_SALAR_A',			'PLOT_HILLS',		'YIELD_SCIENCE',		2,		0),
		('FEATURE_SALAR_A',			'PLOT_MOUNTAIN',	'YIELD_SCIENCE',		2,		0),
		('FEATURE_SALAR_A',			'PLOT_LAND',		'YIELD_SCIENCE',		2,		0),
		
		('FEATURE_SALAR_A',			'PLOT_HILLS',		'YIELD_GOLD',		    3,		0),
		('FEATURE_SALAR_A',			'PLOT_MOUNTAIN',	'YIELD_GOLD',		    3,		0),
		('FEATURE_SALAR_A',			'PLOT_LAND',		'YIELD_GOLD',		    3,		0),

		('FEATURE_SALAR_B',			'PLOT_HILLS',		'YIELD_HEALTH',		    1,		0),
		('FEATURE_SALAR_B',			'PLOT_MOUNTAIN',	'YIELD_HEALTH',		    1,		0),
		('FEATURE_SALAR_B',			'PLOT_LAND',		'YIELD_HEALTH',		    1,		0),

		('FEATURE_SALAR_B',			'PLOT_HILLS',		'YIELD_PRODUCTION',		2,		0),
		('FEATURE_SALAR_B',			'PLOT_MOUNTAIN',	'YIELD_PRODUCTION',		2,		0),
		('FEATURE_SALAR_B',			'PLOT_LAND',		'YIELD_PRODUCTION',		2,		0),

		('FEATURE_DALLOL',			'PLOT_HILLS',		'YIELD_GOLD',		    2,		0),
		('FEATURE_DALLOL',			'PLOT_MOUNTAIN',	'YIELD_PRODUCTION',		2,		0),
		('FEATURE_DALLOL',			'PLOT_LAND',		'YIELD_SCIENCE',		2,		0),

		('FEATURE_CAUSEWAY_A',			'PLOT_OCEAN',	'YIELD_GOLD',		    2,		0),
		('FEATURE_CAUSEWAY_A',			'PLOT_OCEAN',	'YIELD_PRODUCTION',		2,		0),
		('FEATURE_CAUSEWAY_A',			'PLOT_OCEAN',	'YIELD_TOURISM',		1,		0),
		('FEATURE_CAUSEWAY_A',			'PLOT_OCEAN',	'YIELD_GOLDEN_AGE_POINTS',2,	0),
		('FEATURE_CAUSEWAY_A',			'PLOT_OCEAN',	'YIELD_SCIENCE',		2,		0);





INSERT INTO ArtDefine_LandmarkTypes (Type,	LandmarkType,	FriendlyName)
VALUES	('ART_DEF_FEATURE_MT_EVEREST',	'Resource',		'Mt. Everest'),
		('ART_DEF_FEATURE_SALAR_A',		'Resource',		'Salar de Uyuni 1'),
		('ART_DEF_FEATURE_SALAR_B',		'Resource',		'Salar de Uyuni 2'),
		('ART_DEF_FEATURE_LUMI_BAY',	'Resource',		'Bioluminescent Bay'),
		('ART_DEF_FEATURE_DALLOL',		'Resource',		'Dallol'),
		('ART_DEF_FEATURE_GIANTS_CAUSEWAY',	'Resource',		'Causeway'),
		('ART_DEF_FEATURE_RETBA',		'Resource',		'Lake Retba');


INSERT INTO ArtDefine_Landmarks (Era,		State,	Scale,	ImprovementType,	LayoutHandler,	ResourceType,	Model,	TerrainContour) VALUES
('Any',		'Any',	0.7,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_GIANTS_CAUSEWAY',	'feature_causeway.fxsxml',	0),
('Any',		'Any',	0.55,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_MT_EVEREST',	'feature_mt_everest.fxsxml',	1),
('Any',		'Any',	1,		'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_SALAR_A',		'feature_salar.fxsxml',			1),
('Any',		'Any',	1.3,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_SALAR_B',		'feature_salar_b.fxsxml',		1),
('Any',		'Any',	1.15,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_LUMI_BAY',		'lumi_bay.fxsxml',				0), --important!
('Any',		'Any',	1,		'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_DALLOL',		'feature_dallol.fxsxml',		1),
('Any',		'Any',	0.55,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_RETBA',		'feature_retba.fxsxml',			1);

-----------------------------------------------------------------------------------------------------------------------------
DELETE FROM ArtDefine_StrategicView WHERE StrategicViewType = 'ART_DEF_FEATURE_NATURAL_WONDER';
CREATE TABLE Feature_ArtDefine_StrategicView AS SELECT * FROM ArtDefine_StrategicView WHERE TileType = 'Feature';
DELETE FROM ArtDefine_StrategicView WHERE TileType = 'Feature';
INSERT OR REPLACE INTO ArtDefine_StrategicView(StrategicViewType,				TileType,		Asset)
VALUES	('ART_DEF_FEATURE_GIANTS_CAUSEWAY',	'Feature',	'sv_Causeway_C.dds'),
        ('ART_DEF_FEATURE_MT_EVEREST',	'Feature',		'sv_Mt_Everest.dds'),
		('ART_DEF_FEATURE_SALAR_A',		'Feature',		'sv_Salar_S.dds'),
		('ART_DEF_FEATURE_SALAR_B',		'Feature',		'sv_Salar_B.dds'),
		('ART_DEF_FEATURE_LUMI_BAY',	'Feature',		'SV_LumiBay.dds'),
		('ART_DEF_FEATURE_DALLOL',		'Feature',		'sv_Dallol.dds'),
		('ART_DEF_FEATURE_RETBA',		'Feature',		'sv_Retba.dds');

INSERT INTO ArtDefine_StrategicView SELECT * FROM Feature_ArtDefine_StrategicView AS t
	WHERE NOT EXISTS (SELECT 1 FROM ArtDefine_StrategicView AS a WHERE a.StrategicViewType = t.StrategicViewType);
DROP TABLE Feature_ArtDefine_StrategicView;


--=======================================================================================================================
-- VOLCANOS
--=======================================================================================================================
ALTER TABLE Features ADD VolcanoRange		integer 	default 0;
ALTER TABLE Features ADD TilesPerVolcano	integer 	default 0;

UPDATE Features SET VolcanoRange = 9 WHERE Type = 'FEATURE_NEW_VOLCANO';
UPDATE Features SET TilesPerVolcano = 160 WHERE Type = 'FEATURE_NEW_VOLCANO';

-- Terminal damage if you really want to stop atop the volcano!
-- ALL units take this damage, even if they have the IgnoreFeatureDamage promotion feature
UPDATE Features SET TurnDamage = 60 WHERE Type = 'FEATURE_NEW_VOLCANO';


INSERT INTO Feature_YieldChanges(FeatureType,YieldType,	Yield)
VALUES	('FEATURE_NEW_VOLCANO',	'YIELD_SCIENCE',		4);


INSERT OR REPLACE INTO Plot_AdjacentFeatureYieldChanges (FeatureType,PlotType,YieldType,Yield,	IgnoreNaturalWonderPlots)
VALUES	('FEATURE_NEW_VOLCANO',	'PLOT_LAND',		'YIELD_FOOD',			1,		1),
		('FEATURE_NEW_VOLCANO',	'PLOT_HILLS',		'YIELD_FOOD',			1,		1),
		('FEATURE_NEW_VOLCANO',	'PLOT_LAND',		'YIELD_TOURISM',		1,		1),
		('FEATURE_NEW_VOLCANO',	'PLOT_HILLS',		'YIELD_TOURISM',		1,		1);








