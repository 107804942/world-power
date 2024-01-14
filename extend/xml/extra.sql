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



----科技解锁城市溅射
UPDATE Technologies SET CitySplashDamage = 1 WHERE Type ='TECH_RIFLING'; 


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
--UPDATE Buildings        SET BombardRange=1   WHERE BuildingClass='BUILDINGCLASS_WALLS';
UPDATE Buildings        SET BombardRange=1 , BombardIndirect=1  WHERE BuildingClass='BUILDINGCLASS_PALACE';
UPDATE Buildings        SET BombardRange=1   WHERE BuildingClass='BUILDINGCLASS_MILITARY_BASE';
UPDATE Buildings        SET BombardRange=1   WHERE BuildingClass='BUILDINGCLASS_KRAK_DES_CHEVALIERS';
UPDATE Buildings        SET BombardRange=1   WHERE BuildingClass='BUILDINGCLASS_MATRIX';
UPDATE Buildings        SET BombardRange=1   WHERE BuildingClass='BUILDINGCLASS_SPACE_FORTRESS';
UPDATE Defines          SET Value=7   WHERE Name='MAX_CITY_ATTACK_RANGE';
UPDATE Defines          SET Value=2   WHERE Name='CITY_ATTACK_RANGE';
--INSERT OR REPLACE INTO Defines(Name, Value) SELECT 'MAX_CITY_ATTACK_RANGE', max(BombardRange) FROM Technologies;
--INSERT OR REPLACE INTO Defines(Name, Value) SELECT 'MAX_CITY_ATTACK_RANGE', max(BombardRange) FROM Buildings;



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
--UPDATE Improvements SET ImprovementResource='RESOURCE_MANPOWER',ImprovementResourceQuantity=1 WHERE Type='IMPROVEMENT_MANUFACTORY';

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

DELETE FROM Improvement_TechYieldChanges WHERE ImprovementType = 'IMPROVEMENT_MOAI' AND TechType = 'TECH_FLIGHT';
DELETE FROM Improvement_TechYieldChanges WHERE ImprovementType = 'IMPROVEMENT_CHATEAU' AND TechType = 'TECH_CHEMISTRY';


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



-- Insert SQL Rules Here 
-- Tech Enhancement Icons atlas entries
INSERT INTO IconTextureAtlases(Atlas, IconSize, IconsPerRow, IconsPerColumn, Filename) VALUES
	('TECH_ENH_ICONS_ATLAS', 64, 8, 5, 'TechEnhIcons64.dds'),
	('TECH_ENH_ICONS_ATLAS', 45, 8, 5, 'TechEnhIcons45.dds'),
	('TECH_ENH_ICONS_ATLAS2', 64, 8, 8, 'techEnhIconAtlas64.dds'),
	('TECH_ENH_ICONS_ATLAS2', 45, 8, 8, 'techEnhIconAtlas45.dds');

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




		

INSERT INTO IconTextureAtlases	(Atlas, IconSize, Filename, IconsPerRow, IconsPerColumn) VALUES
	('MainRobotPromo_Atlas', 256, 'MianRobotPromotionAtlas256.dds', '8', '8'),
	('MainRobotPromo_Atlas', 064, 'MianRobotPromotionAtlas64.dds', '8', '8'),
	('MainRobotPromo_Atlas', 045, 'MianRobotPromotionAtlas45.dds', '8', '8'),
	('MainRobotPromo_Atlas', 032, 'MianRobotPromotionAtlas32.dds', '8', '8'),

	('robotPromo_Atlas', 256, 'ROBOTPromo_256.dds', '8', '8'),
	('robotPromo_Atlas', 064, 'ROBOTPromo_064.dds', '8', '8'),
	('robotPromo_Atlas', 045, 'ROBOTPromo_045.dds', '8', '8'),
	('robotPromo_Atlas', 032, 'ROBOTPromo_032.dds', '8', '8'),
	('robotPromo_Atlas', 016, 'ROBOTPromo_016.dds', '8', '8'),

	('VALERY_ATLAS', 256, 'PromoIconAtlasx256.dds', '8', '8'),
	('VALERY_ATLAS', 064, 'PromoIconAtlasx64.dds', '8', '8'),
	('VALERY_ATLAS', 045, 'PromoIconAtlasx45.dds', '8', '8'),
	('VALERY_ATLAS', 032, 'PromoIconAtlasx32.dds', '8', '8'),
	

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


		--('FEATURE_VALLEY_B',		'PLOT_LAND',		'YIELD_PRODUCTION',	    1,		0),
		--('FEATURE_VALLEY_B',	    'PLOT_HILLS',		'YIELD_PRODUCTION',		1,		0),
		--('FEATURE_VALLEY_B',	    'PLOT_MOUNTAIN',	'YIELD_PRODUCTION',		1,		0),
		('FEATURE_VALLEY_A',		'PLOT_LAND',		'YIELD_PRODUCTION',		1,		0),
		('FEATURE_VALLEY_A',	    'PLOT_HILLS',		'YIELD_PRODUCTION',		1,		0),
		('FEATURE_VALLEY_A',	    'PLOT_MOUNTAIN',	'YIELD_PRODUCTION',		1,		0),



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

INSERT INTO Feature_YieldChanges (FeatureType,			YieldType,				Yield)VALUES	
        ('FEATURE_VALLEY_A',	'YIELD_GOLDEN_AGE_POINTS',3),
		('FEATURE_VALLEY_A',	'YIELD_PRODUCTION',5),
		('FEATURE_VALLEY_A',	'YIELD_TOURISM',2),
		('FEATURE_VALLEY_A',	'YIELD_CULTURE',3),
		('FEATURE_VALLEY_A',	'YIELD_FAITH',2),

		--('FEATURE_VALLEY_B',	'YIELD_GOLDEN_AGE_POINTS',3),
		--('FEATURE_VALLEY_B',	'YIELD_PRODUCTION',5),
		--('FEATURE_VALLEY_B',	'YIELD_TOURISM',2),
		--('FEATURE_VALLEY_B',	'YIELD_CULTURE',3),
		--('FEATURE_VALLEY_B',	'YIELD_FAITH',2),

		('FEATURE_DANXIA',	'YIELD_GOLDEN_AGE_POINTS',6),
		('FEATURE_DANXIA',	'YIELD_GREAT_GENERAL_POINTS',3),
		('FEATURE_DANXIA',	'YIELD_TOURISM',2),
		('FEATURE_DANXIA',	'YIELD_CULTURE',6),

        ('FEATURE_SALAR_A',		'YIELD_PRODUCTION',		3),
		('FEATURE_SALAR_A',		'YIELD_GOLD',			3),
		('FEATURE_SALAR_A',		'YIELD_CULTURE',		3),
		('FEATURE_SALAR_A',		'YIELD_SCIENCE',		3),
		('FEATURE_SALAR_B',		'YIELD_PRODUCTION',		2),
		('FEATURE_SALAR_B',		'YIELD_GOLD',			1),
		('FEATURE_SALAR_B',		'YIELD_CULTURE',		1),
		('FEATURE_SALAR_B',		'YIELD_SCIENCE',		1),

		('FEATURE_ZHANGJIAJIE',	'YIELD_GOLD',			6),
		('FEATURE_ZHANGJIAJIE',	'YIELD_SCIENCE',		2),
		('FEATURE_ZHANGJIAJIE',	'YIELD_FOOD',		    3),
		('FEATURE_ZHANGJIAJIE',	'YIELD_TOURISM',		2),
		('FEATURE_ZHANGJIAJIE',	'YIELD_CULTURE',		5),

		--('FEATURE_WHITE_DESERT',	'YIELD_GOLD',			4),
		--('FEATURE_WHITE_DESERT',	'YIELD_SCIENCE',		7),
		--('FEATURE_WHITE_DESERT',	'YIELD_FOOD',		    3),
		--('FEATURE_WHITE_DESERT',	'YIELD_TOURISM',		2),

		('FEATURE_GALAPAGOS_A',	'YIELD_GOLD',			3),
		('FEATURE_GALAPAGOS_A',	'YIELD_CULTURE',		3),
		('FEATURE_GALAPAGOS_A',	'YIELD_FOOD',		    3),

		('FEATURE_GALAPAGOS_B',		'YIELD_GOLD',			3),
		('FEATURE_GALAPAGOS_B',		'YIELD_CULTURE',		3),
		('FEATURE_GALAPAGOS_B',		'YIELD_FOOD',		    3),

		('FEATURE_HA_LONG_A',		'YIELD_PRODUCTION',		3),
		('FEATURE_HA_LONG_A',		'YIELD_CULTURE',		3),
		('FEATURE_HA_LONG_A',		'YIELD_FOOD',		    3),

		('FEATURE_HA_LONG_B',		'YIELD_PRODUCTION',		3),
		('FEATURE_HA_LONG_B',		'YIELD_CULTURE',		3),
		('FEATURE_HA_LONG_B',		'YIELD_FOOD',		    3),
		
		('FEATURE_MT_PAEKTU',	'YIELD_FAITH',			5),
		('FEATURE_MT_PAEKTU',	'YIELD_CULTURE',		2),
		('FEATURE_MT_PAEKTU',	'YIELD_GOLD',			1),
		('FEATURE_MT_PAEKTU',	'YIELD_HEALTH',			4),
		('FEATURE_MT_PAEKTU',	'YIELD_FOOD',			4),

        ('FEATURE_MT_EVEREST',	'YIELD_FAITH',			4),
		('FEATURE_MT_EVEREST',	'YIELD_CULTURE',		4),
		('FEATURE_MT_EVEREST',	'YIELD_GOLD',			4),
		('FEATURE_MT_EVEREST',	'YIELD_HEALTH',			3),
	
		('FEATURE_RETBA',		'YIELD_PRODUCTION',		2),
		('FEATURE_RETBA',		'YIELD_SCIENCE',		1),
		('FEATURE_RETBA',		'YIELD_CULTURE',		2),
		('FEATURE_RETBA',		'YIELD_TOURISM',		1),

		('FEATURE_DELICATE_ARCH',		'YIELD_PRODUCTION',		2),
		('FEATURE_DELICATE_ARCH',		'YIELD_FAITH',		2),
		('FEATURE_DELICATE_ARCH',		'YIELD_CULTURE',		3),
		('FEATURE_DELICATE_ARCH',		'YIELD_TOURISM',		1),

		('FEATURE_LUMI_BAY',	'YIELD_GOLD',			5),
		('FEATURE_LUMI_BAY',	'YIELD_SCIENCE',		4),
		('FEATURE_LUMI_BAY',	'YIELD_TOURISM',		3),

		('FEATURE_CAUSEWAY_A',	'YIELD_GOLD',			2),
		('FEATURE_CAUSEWAY_A',	'YIELD_SCIENCE',		1),
		('FEATURE_CAUSEWAY_A',	'YIELD_PRODUCTION',		3),
		('FEATURE_CAUSEWAY_A',	'YIELD_GOLDEN_AGE_POINTS',2),
		('FEATURE_CAUSEWAY_A',	'YIELD_TOURISM',2),

		('FEATURE_CAUSEWAY_B',	'YIELD_GOLD',			2),
		('FEATURE_CAUSEWAY_B',	'YIELD_SCIENCE',		1),
		('FEATURE_CAUSEWAY_B',	'YIELD_PRODUCTION',		3),
		('FEATURE_CAUSEWAY_B',	'YIELD_GOLDEN_AGE_POINTS',2),
		('FEATURE_CAUSEWAY_B',	'YIELD_TOURISM',2),

		('FEATURE_BERMUDA_A',		'YIELD_SCIENCE',		5),


		('FEATURE_BLUE_HOLE',		'YIELD_SCIENCE',		3),
		('FEATURE_BLUE_HOLE',		'YIELD_FOOD',		    4),
		('FEATURE_BLUE_HOLE',		'YIELD_TOURISM',		4),

		('FEATURE_EYE_OF_SAHARA_A',		'YIELD_SCIENCE',		4),
		('FEATURE_EYE_OF_SAHARA_A',		'YIELD_PRODUCTION',		5),


		('FEATURE_DALLOL',		'YIELD_PRODUCTION',		4),
		('FEATURE_DALLOL',		'YIELD_SCIENCE',		3),
		('FEATURE_DALLOL',		'YIELD_TOURISM',		2);




		

INSERT INTO Plot_AdjacentFeatureYieldChanges (FeatureType,	PlotType,	YieldType,	Yield,	IgnoreNaturalWonderPlots)VALUES	
 
        ('FEATURE_VALLEY_A',	    'PLOT_HILLS',       'YIELD_GOLDEN_AGE_POINTS',2,	0),
		('FEATURE_VALLEY_A',	    'PLOT_HILLS',       'YIELD_PRODUCTION',     2,		0),
		('FEATURE_VALLEY_A',	    'PLOT_HILLS',       'YIELD_TOURISM',        1,		0),
		('FEATURE_VALLEY_A',	    'PLOT_HILLS',       'YIELD_CULTURE',        1,		0),
		('FEATURE_VALLEY_A',	    'PLOT_HILLS',       'YIELD_FAITH',          1,		0),

		--('FEATURE_VALLEY_B',	    'PLOT_LAND',        'YIELD_GOLDEN_AGE_POINTS',2,	0),
		--('FEATURE_VALLEY_B',	    'PLOT_LAND',        'YIELD_PRODUCTION',     2,		0),
		--('FEATURE_VALLEY_B',	    'PLOT_LAND',        'YIELD_TOURISM',        1,		0),
		--('FEATURE_VALLEY_B',	    'PLOT_LAND',        'YIELD_CULTURE',        1,		0),
		--('FEATURE_VALLEY_B',	    'PLOT_LAND',        'YIELD_FAITH',          1,		0),

        ('FEATURE_LUMI_BAY',		'PLOT_OCEAN',		'YIELD_TOURISM',		1,		0),
		('FEATURE_LUMI_BAY',		'PLOT_OCEAN',		'YIELD_GOLD',		    2,		0),
		('FEATURE_LUMI_BAY',		'PLOT_OCEAN',		'YIELD_FOOD',		    1,		0),
		('FEATURE_LUMI_BAY',		'PLOT_OCEAN',		'YIELD_SCIENCE',		1,		0),

		('FEATURE_LUMI_BAY',		'PLOT_OCEAN',		'YIELD_TOURISM',		1,		0),
		('FEATURE_LUMI_BAY',		'PLOT_OCEAN',		'YIELD_GOLD',		    2,		0),
		('FEATURE_LUMI_BAY',		'PLOT_OCEAN',		'YIELD_FOOD',		    1,		0),
		('FEATURE_LUMI_BAY',		'PLOT_OCEAN',		'YIELD_SCIENCE',		1,		0),


		('FEATURE_GALAPAGOS_A',		'PLOT_OCEAN',		'YIELD_FOOD',			2,		0),
		('FEATURE_GALAPAGOS_A',		'PLOT_OCEAN',		'YIELD_GOLD',			2,		0),
		('FEATURE_GALAPAGOS_A',		'PLOT_OCEAN',	    'YIELD_CULTURE',		2,		0),

		('FEATURE_GALAPAGOS_B',		'PLOT_OCEAN',		'YIELD_FOOD',			2,		0),
		('FEATURE_GALAPAGOS_B',		'PLOT_OCEAN',		'YIELD_GOLD',			2,		0),
		('FEATURE_GALAPAGOS_B',		'PLOT_OCEAN',	    'YIELD_CULTURE',		2,		0),


		('FEATURE_MT_PAEKTU',			'PLOT_HILLS',		'YIELD_FAITH',		2,		0),
		('FEATURE_MT_PAEKTU',			'PLOT_MOUNTAIN',	'YIELD_FAITH',		2,		0),
		('FEATURE_MT_PAEKTU',			'PLOT_LAND',		'YIELD_FAITH',		2,		0),
		
		('FEATURE_MT_PAEKTU',			'PLOT_HILLS',		'YIELD_FOOD',		1,		0),
		('FEATURE_MT_PAEKTU',			'PLOT_MOUNTAIN',	'YIELD_FOOD',		1,		0),
		('FEATURE_MT_PAEKTU',			'PLOT_LAND',		'YIELD_FOOD',		1,		0),


		('FEATURE_DANXIA',			'PLOT_HILLS',		'YIELD_CULTURE',		1,		0),
		('FEATURE_DANXIA',			'PLOT_LAND',		'YIELD_CULTURE',		1,		0),
		
		('FEATURE_DANXIA',			'PLOT_HILLS',		'YIELD_GREAT_GENERAL_POINTS',		    1,		0),
		('FEATURE_DANXIA',			'PLOT_LAND',		'YIELD_GREAT_GENERAL_POINTS',		    1,		0),


		('FEATURE_ZHANGJIAJIE',			'PLOT_HILLS',		'YIELD_SCIENCE',		1,		0),
		('FEATURE_ZHANGJIAJIE',			'PLOT_MOUNTAIN',	'YIELD_SCIENCE',		1,		0),
		('FEATURE_ZHANGJIAJIE',			'PLOT_LAND',		'YIELD_SCIENCE',		1,		0),
		
		('FEATURE_ZHANGJIAJIE',			'PLOT_HILLS',		'YIELD_GOLD',		    2,		0),
		('FEATURE_ZHANGJIAJIE',			'PLOT_MOUNTAIN',	'YIELD_GOLD',		    2,		0),
		('FEATURE_ZHANGJIAJIE',			'PLOT_LAND',		'YIELD_GOLD',		    2,		0),

		('FEATURE_ZHANGJIAJIE',			'PLOT_HILLS',		'YIELD_CULTURE',		1,		0),
		('FEATURE_ZHANGJIAJIE',			'PLOT_MOUNTAIN',	'YIELD_CULTURE',		1,		0),
		('FEATURE_ZHANGJIAJIE',			'PLOT_LAND',		'YIELD_CULTURE',		1,		0),

		('FEATURE_ZHANGJIAJIE',			'PLOT_HILLS',		'YIELD_TOURISM',		1,		0),
		('FEATURE_ZHANGJIAJIE',			'PLOT_MOUNTAIN',	'YIELD_TOURISM',		1,		0),
		('FEATURE_ZHANGJIAJIE',			'PLOT_LAND',		'YIELD_TOURISM',		1,		0),


		('FEATURE_HA_LONG_B',			'PLOT_OCEAN',		'YIELD_PRODUCTION',		1,		0),
		('FEATURE_HA_LONG_B',			'PLOT_OCEAN',	    'YIELD_PRODUCTION',		1,		0),
		('FEATURE_HA_LONG_B',			'PLOT_OCEAN',		'YIELD_PRODUCTION',		1,		0),

		('FEATURE_HA_LONG_A',			'PLOT_OCEAN',		'YIELD_TOURISM',		1,		0),
		('FEATURE_HA_LONG_A',			'PLOT_OCEAN',	     'YIELD_TOURISM',		1,		0),
		('FEATURE_HA_LONG_A',			'PLOT_OCEAN',		'YIELD_TOURISM',		1,		0),




		--('FEATURE_WHITE_DESERT',			'PLOT_HILLS',		'YIELD_SCIENCE',		2,		0),
		--('FEATURE_WHITE_DESERT',			'PLOT_MOUNTAIN',	'YIELD_SCIENCE',		2,		0),
		--('FEATURE_WHITE_DESERT',			'PLOT_LAND',		'YIELD_SCIENCE',		2,		0),
		
		--('FEATURE_WHITE_DESERT',			'PLOT_HILLS',		'YIELD_GOLD',		    2,		0),
		--('FEATURE_WHITE_DESERT',			'PLOT_MOUNTAIN',	'YIELD_GOLD',		    2,		0),
		--('FEATURE_WHITE_DESERT',			'PLOT_LAND',		'YIELD_GOLD',		    2,		0),

		--('FEATURE_WHITE_DESERT',			'PLOT_HILLS',		'YIELD_PRODUCTION',		1,		0),
		--('FEATURE_WHITE_DESERT',			'PLOT_MOUNTAIN',	'YIELD_PRODUCTION',		1,		0),
		--('FEATURE_WHITE_DESERT',			'PLOT_LAND',		'YIELD_PRODUCTION',		1,		0),


        ('FEATURE_MT_EVEREST',		'PLOT_LAND',		'YIELD_FOOD',			2,		0),
		('FEATURE_MT_EVEREST',		'PLOT_HILLS',		'YIELD_FOOD',			2,		0),
		('FEATURE_MT_EVEREST',		'PLOT_MOUNTAIN',	'YIELD_FOOD',			2,		0),

		('FEATURE_MT_EVEREST',		'PLOT_LAND',		'YIELD_SCIENCE',		2,		0),
		('FEATURE_MT_EVEREST',		'PLOT_HILLS',		'YIELD_SCIENCE',		2,		0),
		('FEATURE_MT_EVEREST',		'PLOT_MOUNTAIN',	'YIELD_SCIENCE',		2,		0),

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

		('FEATURE_DELICATE_ARCH',			'PLOT_HILLS',		'YIELD_FAITH',		2,		0),
		('FEATURE_DELICATE_ARCH',			'PLOT_MOUNTAIN',	'YIELD_FAITH',		2,		0),
		('FEATURE_DELICATE_ARCH',			'PLOT_LAND',		'YIELD_FAITH',		2,		0),

		('FEATURE_DELICATE_ARCH',			'PLOT_HILLS',		'YIELD_GOLD',		2,		0),
		('FEATURE_DELICATE_ARCH',			'PLOT_MOUNTAIN',	'YIELD_GOLD',		2,		0),
		('FEATURE_DELICATE_ARCH',			'PLOT_LAND',		'YIELD_GOLD',		2,		0),


		('FEATURE_BERMUDA_A',		'PLOT_OCEAN', 'YIELD_SCIENCE',		3,		0),
		----('FEATURE_BERMUDA_B',		'PLOT_OCEAN', 'YIELD_SCIENCE',		1,		0),
		---('FEATURE_BERMUDA_C',		'PLOT_OCEAN', 'YIELD_SCIENCE',		1,		0),


		('FEATURE_BLUE_HOLE',		'PLOT_OCEAN', 'YIELD_SCIENCE',		1,		0),
		('FEATURE_BLUE_HOLE',		'PLOT_OCEAN', 'YIELD_GOLD',		2,		0),
		('FEATURE_BLUE_HOLE',		'PLOT_OCEAN', 'YIELD_FOOD',		2,		0),


		
		('FEATURE_EYE_OF_SAHARA_A',			'PLOT_HILLS',		'YIELD_TOURISM',		1,		0),
		('FEATURE_EYE_OF_SAHARA_A',			'PLOT_MOUNTAIN',	'YIELD_TOURISM',		1,		0),
		('FEATURE_EYE_OF_SAHARA_A',			'PLOT_LAND',		'YIELD_TOURISM',		1,		0),

		('FEATURE_EYE_OF_SAHARA_A',			'PLOT_HILLS',		'YIELD_SCIENCE',		1,		0),
		('FEATURE_EYE_OF_SAHARA_A',			'PLOT_MOUNTAIN',	'YIELD_SCIENCE',		1,		0),
		('FEATURE_EYE_OF_SAHARA_A',			'PLOT_LAND',		'YIELD_SCIENCE',		1,		0),





		('FEATURE_CAUSEWAY_A',			'PLOT_HILLS',		'YIELD_GOLDEN_AGE_POINTS',		2,		0),
		('FEATURE_CAUSEWAY_A',			'PLOT_MOUNTAIN',	'YIELD_GOLDEN_AGE_POINTS',		2,		0),
		('FEATURE_CAUSEWAY_A',			'PLOT_LAND',		'YIELD_GOLDEN_AGE_POINTS',		2,		0),

		('FEATURE_CAUSEWAY_A',			'PLOT_HILLS',		'YIELD_PRODUCTION',		2,		0),
		('FEATURE_CAUSEWAY_A',			'PLOT_MOUNTAIN',	'YIELD_PRODUCTION',		2,		0),
		('FEATURE_CAUSEWAY_A',			'PLOT_LAND',		'YIELD_PRODUCTION',		2,		0),

		('FEATURE_CAUSEWAY_B',			'PLOT_OCEAN',	'YIELD_GOLD',		    2,		0),
		('FEATURE_CAUSEWAY_B',			'PLOT_OCEAN',	'YIELD_PRODUCTION',		2,		0),
		('FEATURE_CAUSEWAY_B',			'PLOT_OCEAN',	'YIELD_GOLDEN_AGE_POINTS',2,	0);





INSERT INTO ArtDefine_LandmarkTypes (Type,	LandmarkType,	FriendlyName)VALUES	
	   ('ART_DEF_FEATURE_DANXIA',	'Resource',		'Dan Xia'),

        ('ART_DEF_FEATURE_BLUE_HOLE',		'Resource',		'Great Blue Hole'),
        ('ART_DEF_FEATURE_ZHANGJIAJIE',		'Resource',		'Zhangjiajie'),
        ('ART_DEF_FEATURE_HA_LONG_A',		'Resource',		'Ha Long Bay A'),
		('ART_DEF_FEATURE_HA_LONG_B',		'Resource',		'Ha Long Bay B'),
		('ART_DEF_FEATURE_MT_PAEKTU',       'Resource',		'Mt. Paektu'),
        ('ART_DEF_FEATURE_DELICATE_ARCH',    'Resource',		'Arch'),
        ('ART_DEF_FEATURE_MT_EVEREST',	'Resource',		'Mt. Everest'),
		('ART_DEF_FEATURE_SALAR_A',		'Resource',		'Salar de Uyuni A'),
		('ART_DEF_FEATURE_SALAR_B',		'Resource',		'Salar de Uyuni B'),
		('ART_DEF_FEATURE_LUMI_BAY',	'Resource',		'Bioluminescent Bay'),
		('ART_DEF_FEATURE_DALLOL',		'Resource',		'Dallol'),
		('ART_DEF_FEATURE_GIANTS_CAUSEWAY_A',	'Resource',		'Causeway A'),
		('ART_DEF_FEATURE_GIANTS_CAUSEWAY_B',	'Resource',		'Causeway B'),
		--('ART_DEF_FEATURE_WHITE_DESERT',	'Resource',		'White Desert'),
		('ART_DEF_FEATURE_GALAPAGOS_A',		'Resource',		'Galapagos A'),
		('ART_DEF_FEATURE_GALAPAGOS_B',		'Resource',		'Galapagos B'),

		('ART_DEF_FEATURE_BERMUDA_A',	'Resource',		'Bermuda Triangle A'),


		-- ('ART_DEF_FEATURE_VALLEY_B',	'Resource',		'Valley B'),
		  ('ART_DEF_FEATURE_VALLEY_A',	'Resource',		'Valley A'),

		('ART_DEF_FEATURE_EYE_OF_SAHARA_A',	'Resource',		'Eye of the Sahara A'),

		('ART_DEF_FEATURE_VOLCANO_1',	'Resource',		'Volcan 1'),

		('ART_DEF_FEATURE_RETBA',		'Resource',		'Lake Retba');


INSERT INTO ArtDefine_Landmarks (Era,		State,	Scale,	ImprovementType,	LayoutHandler,	ResourceType,	Model,	TerrainContour) VALUES
('Any',		'Any',	1.3,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_VOLCANO_1',	'apocalyptic_volcano_1.fxsxml',1),       --important!

--('Any',		'Any',	1.3,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_VALLEY_B',	'Monument_valley_1.fxsxml',1),       --important!
('Any',		'Any',	1.3,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_VALLEY_A',	'Monument_valley_2.fxsxml',1),       --important!


('Any',		'Any',	1,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_DANXIA',	'Danxia_Mountain.fxsxml',1),       --important!

('Any',		'Any',	0.85,	'ART_DEF_IMPROVEMENT_NONE',		'SNAPSHOT',		'ART_DEF_FEATURE_BERMUDA_A',	'bermuda_triangle_1.fxsxml',1),       --important!


('Any',		'Any',	1,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_EYE_OF_SAHARA_A',	'eye_of_the_sahara.fxsxml',1),       --important!


('Any',		'Any',	1.1,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_BLUE_HOLE',	'Great_blue_hole.fxsxml',1),       --important!

('Any',		'Any',	1.2,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_ZHANGJIAJIE',	'feature_zhangjiajie.fxsxml',1),       --important!

('Any',		'Any',	1.1,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_HA_LONG_A',	'Halong_Bay_1.fxsxml',0),       --important!
('Any',		'Any',	1.1,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_HA_LONG_B',	'Halong_Bay_2.fxsxml',	0),      --important!

('Any',		'Any',	0.85,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_MT_PAEKTU',	'MT_PAEKTU_GRASS.fxsxml',	1),      --important!

('Any',		'Any',	0.7,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_DELICATE_ARCH',	'DelicateArch.fxsxml',	1),      --important!

('Any',		'Any',	1.3,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_GIANTS_CAUSEWAY_A',	'causeway_land.fxsxml',1),       --important!
('Any',		'Any',	1.3,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_GIANTS_CAUSEWAY_B',	'causeway_sea.fxsxml',	0),      --important!

('Any',		'Any',	1.5,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_MT_EVEREST',	'Mt_Everest.fxsxml',	1),          --important!

('Any',		'Any',	1,		'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_SALAR_A',		'feature_salar.fxsxml',			1),  --important!
('Any',		'Any',	1.3,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_SALAR_B',		'feature_salar_b.fxsxml',		1),  --important!

('Any',		'Any',	1.15,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_LUMI_BAY',		'lumi_bay.fxsxml',				0), --important!

('Any',		'Any',	1,		'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_DALLOL',		'dallol_3d.fxsxml',		1),         --important!

('Any',		'Any',	1.4,	'ART_DEF_IMPROVEMENT_NONE',		    'SNAPSHOT',		'ART_DEF_FEATURE_GALAPAGOS_A',	'galapagos.fxsxml',				1),  --important!
('Any',		'Any',	1.2,	'ART_DEF_IMPROVEMENT_NONE',		    'SNAPSHOT',		'ART_DEF_FEATURE_GALAPAGOS_B',	'galapagos_2.fxsxml',				1),  --important!

--('Any',		'Any',	0.5,	    'ART_DEF_IMPROVEMENT_NONE',		'SNAPSHOT',		'ART_DEF_FEATURE_WHITE_DESERT',	'whitedesert.fxsxml',			1),  --important!

('Any',		'Any',	0.9,	'ART_DEF_IMPROVEMENT_NONE',			'SNAPSHOT',		'ART_DEF_FEATURE_RETBA',		'Lake_Retba.fxsxml',			1);  --important!

-----------------------------------------------------------------------------------------------------------------------------
DELETE FROM ArtDefine_StrategicView WHERE StrategicViewType = 'ART_DEF_FEATURE_NATURAL_WONDER';
CREATE TABLE Feature_ArtDefine_StrategicView AS SELECT * FROM ArtDefine_StrategicView WHERE TileType = 'Feature';
DELETE FROM ArtDefine_StrategicView WHERE TileType = 'Feature';
INSERT OR REPLACE INTO ArtDefine_StrategicView(StrategicViewType,				TileType,		Asset)VALUES	
        ('ART_DEF_FEATURE_HA_LONG_A',	'Feature',	'sv_Ha_Long_A.dds'),
        ('ART_DEF_FEATURE_HA_LONG_B',	'Feature',	'sv_Ha_Long_B.dds'),
		('ART_DEF_FEATURE_MT_PAEKTU',	'Feature',	'sv_Paektu.dds'),
		('ART_DEF_FEATURE_BLUE_HOLE',	'Feature',	'sv_Blue_Hole.dds'),
        ('ART_DEF_FEATURE_GIANTS_CAUSEWAY_A',	'Feature',	'sv_Causeway_T.dds'),
        ('ART_DEF_FEATURE_GIANTS_CAUSEWAY_B',	'Feature',	'sv_Causeway_C.dds'),
        ('ART_DEF_FEATURE_DELICATE_ARCH',	'Feature',	'sv_DelicateArch.dds'),
        ('ART_DEF_FEATURE_MT_EVEREST',	'Feature',	    'sv_Mt_Everest.dds'),
		('ART_DEF_FEATURE_SALAR_A',		'Feature',		'sv_Salar_S.dds'),
		('ART_DEF_FEATURE_SALAR_B',		'Feature',		'sv_Salar_B.dds'),
		('ART_DEF_FEATURE_LUMI_BAY',	'Feature',		'SV_LumiBay.dds'),
		('ART_DEF_FEATURE_DALLOL',		'Feature',		'sv_Dallol.dds'),
		('ART_DEF_FEATURE_GALAPAGOS_A',	'Feature',		'sv_Galapagos_A.dds'),
		('ART_DEF_FEATURE_GALAPAGOS_B',	'Feature',		'sv_Galapagos_B.dds'),
		--('ART_DEF_FEATURE_WHITE_DESERT','Feature',		'SV_WhiteDesert.dds'),
		('ART_DEF_FEATURE_ZHANGJIAJIE','Feature',		'sv_Zhangjiajie.dds'),

		('ART_DEF_FEATURE_EYE_OF_SAHARA_A','Feature',		'sv_Sahara_Eye.dds'),

		('ART_DEF_FEATURE_BERMUDA_A','Feature',		'sv_Bermuda.dds'),

		('ART_DEF_FEATURE_VALLEY_A','Feature',		'sv_VALLEY.dds'),
		--('ART_DEF_FEATURE_VALLEY_B','Feature',		'sv_VALLEY.dds'),

		('ART_DEF_FEATURE_DANXIA','Feature',		'sv_Dan Xia.dds'),
		
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

--------------------------------------------------------------------------------------------------
--GameOptions
--------------------------------------------------------------------------------------------------
--INSERT INTO GameOptions (Type,				Description,									Help,										 SupportsMultiplayer)	
--SELECT 'GAMEOPTION_NEW_VOLCANO',		'TXT_KEY_GAMEOPTION_NEW_VOLCANO',			'TXT_KEY_GAMEOPTION_NEW_VOLCANO_HELP',			0 ;









