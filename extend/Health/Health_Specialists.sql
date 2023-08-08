--==========================================================================================================================	
-- SPECIALISTS
--==========================================================================================================================	
--Specialists
--------------------------------------------------------------------------------------------------------------------------


-- Missions
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO Missions	
		(Type, 							Time,	OrderPriority,	EntityEventType,				Visible,	Description, 						Help, 									DisabledHelp, 									EntityEventType,			IconAtlas,				IconIndex)
VALUES	('MISSION_DOCTOR_CURE_CITY', 	20,		199,			'ENTITY_EVENT_GREAT_EVENT',		1,			'TXT_KEY_MISSION_DOCTOR_CURE_CITY', 	'TXT_KEY_MISSION_DOCTOR_CURE_CITY_HELP',	'TXT_KEY_MISSION_DOCTOR_CURE_DISABLED',		'ENTITY_EVENT_GREAT_EVENT',	'UNIT_ACTION_ATLAS',	40),
		('MISSION_DOCTOR_CURE_UNIT', 	20,		199,			'ENTITY_EVENT_GREAT_EVENT',		1,			'TXT_KEY_MISSION_DOCTOR_CURE_UNIT', 	'TXT_KEY_MISSION_DOCTOR_CURE_UNIT_HELP',	'TXT_KEY_MISSION_DOCTOR_CURE_DISABLED',		'ENTITY_EVENT_GREAT_EVENT',	'UNIT_ACTION_ATLAS',	3),
		('MISSION_CONSTRUCT_CITY',      20,		199,	        'ENTITY_EVENT_GREAT_EVENT',		1,	        'TXT_KEY_MISSION_GREAT_DOCTOR_CONSTRUCT_CITY', 	'TXT_KEY_MISSION_GREAT_DOCTOR_CONSTRUCT_CITY_HELP',	'TXT_KEY_MISSION_GREAT_DOCTOR_CONSTRUCT_CITY_DISABLED',		'ENTITY_EVENT_GREAT_EVENT',	'UNIT_ACTION_ATLAS',	40),
		('MISSION_GREAT_DOCTOR_CURE', 	20,		199,			'ENTITY_EVENT_GREAT_EVENT',		1,			'TXT_KEY_MISSION_GREAT_DOCTOR_CURE', 	'TXT_KEY_MISSION_GREAT_DOCTOR_CURE_HELP',	'TXT_KEY_MISSION_GREAT_DOCTOR_CURE_DISABLED',		'ENTITY_EVENT_GREAT_EVENT',	'UNIT_ACTION_ATLAS',	3);



-- UnitClasses
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO UnitClasses (Type, 			DefaultUnit, 					Description)
SELECT	'UNITCLASS_GREAT_DOCTOR',	'UNIT_GREAT_DOCTOR',		'TXT_KEY_UNIT_GREAT_DOCTOR';


--==========================================================================================================================
-- Units
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO Units 	
(Type, Class,	DontShowYields, Cost, Moves, CivilianAttackPriority, Special, Domain, DefaultUnitAI, Description, Civilopedia, 	Strategy,	AdvancedStartCost,	WorkRate, CombatLimit, DontShowYields, UnitArtInfoEraVariation, UnitArtInfo, UnitFlagIconOffset,	UnitFlagAtlas,MoveRate, PortraitIndex, 	IconAtlas)
SELECT	'UNIT_GREAT_DOCTOR',	'UNITCLASS_GREAT_DOCTOR',		1,	-1,   3,  'CIVILIAN_ATTACK_PRIORITY_HIGH', 'SPECIALUNIT_PEOPLE', 	'DOMAIN_LAND', 'UNITAI_SCIENTIST', 'TXT_KEY_UNIT_GREAT_DOCTOR', 'TXT_KEY_CIV5_ANTIQUITY_DOCTOR_TEXT',	'TXT_KEY_UNIT_GREAT_DOCTOR_STRATEGY',	-1, 1, 0, 1,   1,	'ART_DEF_UNIT_GREAT_DOCTOR',	0,	'UNIT_FLAG_GREAT_DOCTOR_ATLAS',	'GREAT_PERSON', 0, 				'HEALTH_UNIT_ATLAS';


INSERT  INTO Unit_FreePromotions(UnitType,PromotionType)
SELECT  Type, 'PROMOTION_GREAT_DOCTOR' FROM Units WHERE Class= 'UNITCLASS_GREAT_DOCTOR';

-- UNIT GRAPHICS医生
--==========================================================================================================================
-- ArtDefine_UnitInfos
------------------------------------------------------------------------------------------------------------------------	
INSERT INTO ArtDefine_UnitInfos (Type, 		DamageStates,	Formation)
SELECT	'ART_DEF_UNIT_GREAT_DOCTOR',	1, 	'EarlyGreatArtist';

------------------------------------------------------------------------------------------------------------------------
-- ArtDefine_UnitInfoMemberInfos
------------------------------------------------------------------------------------------------------------------------	
INSERT INTO ArtDefine_UnitInfoMemberInfos 	
		(UnitInfoType,						UnitMemberInfoType,							NumMembers)
VALUES	('ART_DEF_UNIT_GREAT_DOCTOR',	'ART_DEF_UNIT_MEMBER_GREAT_DOCTOR',		1);
------------------------------------------------------------------------------------------------------------------------
-- ArtDefine_UnitMemberCombats
------------------------------------------------------------------------------------------------------------------------	
INSERT INTO ArtDefine_UnitMemberCombats 
(UnitMemberType,EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
SELECT	'ART_DEF_UNIT_MEMBER_GREAT_DOCTOR',	EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation
FROM ArtDefine_UnitMemberCombats WHERE UnitMemberType = 'ART_DEF_UNIT_MEMBER_GREATMERCHANT_EARLY_LEADER';
------------------------------------------------------------------------------------------------------------------------
-- ArtDefine_UnitMemberCombatWeapons
------------------------------------------------------------------------------------------------------------------------	
INSERT INTO ArtDefine_UnitMemberCombatWeapons	
(UnitMemberType,"Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
SELECT	'ART_DEF_UNIT_MEMBER_GREAT_DOCTOR',	"Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag
FROM ArtDefine_UnitMemberCombatWeapons WHERE UnitMemberType = 'ART_DEF_UNIT_MEMBER_GREATMERCHANT_EARLY_LEADER';
------------------------------------------------------------------------------------------------------------------------
-- ArtDefine_UnitMemberInfos
------------------------------------------------------------------------------------------------------------------------	
INSERT INTO ArtDefine_UnitMemberInfos 	(Type, 	Scale,  ZOffset, Domain, Model,							MaterialTypeTag, MaterialTypeSoundOverrideTag)
SELECT	'ART_DEF_UNIT_MEMBER_GREAT_DOCTOR',	Scale,	ZOffset, Domain, 'great_doctor_early.fxsxml',	MaterialTypeTag, MaterialTypeSoundOverrideTag
FROM ArtDefine_UnitMemberInfos WHERE Type = 'ART_DEF_UNIT_MEMBER_GREATMERCHANT_EARLY_LEADER';


------------------------------------------------------------------------------------------------------------------------
--后期医生
------------------------------------------------------------------------------------------------------------------------			
INSERT INTO ArtDefine_UnitInfos (Type,	DamageStates,	Formation,		IconAtlas,		PortraitIndex)
SELECT	'ART_DEF_UNIT_GREAT_DOCTOR_LATE',	1,			'TwoBigGuns',	'ROBOT_ICON_ATLAS',	3;


INSERT INTO ArtDefine_UnitInfoMemberInfos 
		(UnitInfoType, 		UnitMemberInfoType,					NumMembers)
SELECT	'ART_DEF_UNIT_GREAT_DOCTOR_LATE', 	'ART_DEF_UNIT_MEMBER_GREAT_DOCTOR_LATE', 		1;

INSERT INTO ArtDefine_UnitMemberCombats 
		(UnitMemberType,	EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
SELECT	'ART_DEF_UNIT_MEMBER_GREAT_DOCTOR_LATE',		EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation
FROM ArtDefine_UnitMemberCombats WHERE UnitMemberType = 'ART_DEF_UNIT_MEMBER_GREATMERCHANT_EARLY_LEADER';



INSERT INTO ArtDefine_UnitMemberCombatWeapons	
		(UnitMemberType,	"Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
SELECT	'ART_DEF_UNIT_MEMBER_GREAT_DOCTOR_LATE',		"Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag
FROM ArtDefine_UnitMemberCombatWeapons WHERE UnitMemberType = 'ART_DEF_UNIT_MEMBER_GREATMERCHANT_EARLY_LEADER';


INSERT INTO ArtDefine_UnitMemberInfos 	
		(Type, 			Scale,  			ZOffset, Domain, 	Model,		MaterialTypeTag, MaterialTypeSoundOverrideTag)
SELECT	'ART_DEF_UNIT_MEMBER_GREAT_DOCTOR_LATE',		Scale,	ZOffset, Domain, 	'great_doctor_late.fxsxml',	MaterialTypeTag, MaterialTypeSoundOverrideTag
FROM ArtDefine_UnitMemberInfos WHERE Type = 'ART_DEF_UNIT_MEMBER_GREATMERCHANT_EARLY_LEADER';



INSERT INTO IconTextureAtlases (Atlas, 								IconSize, 	Filename, 									IconsPerRow, 	IconsPerColumn)
VALUES	('HEALTH_UNIT_ATLAS',				256, 		'HealthUnitAtlas_256.dds',				1, 				1),
        ('HEALTH_UNIT_ATLAS',				214, 		'HealthUnitAtlas_214.dds',				1, 				1),
		('HEALTH_UNIT_ATLAS',				128, 		'HealthUnitAtlas_128.dds',				1, 				1),
		('HEALTH_UNIT_ATLAS',				80, 		'HealthUnitAtlas_80.dds',				1, 				1),
		('HEALTH_UNIT_ATLAS',				64, 		'HealthUnitAtlas_64.dds',				1, 				1),
		('HEALTH_UNIT_ATLAS',				45, 		'HealthUnitAtlas_45.dds',				1, 				1),
		('UNIT_FLAG_GREAT_DOCTOR_ATLAS',	32, 		'HealthGreatDoctorUnitFlag_32.dds',		1, 				1);


-- GreatPersons
-----------------------------------------------------------------------------------------------------
INSERT INTO GreatPersons (Type, 			Class,							Specialist)
SELECT	'GREATPERSON_GREAT_DOCTOR', 	'UNITCLASS_GREAT_DOCTOR',	'SPECIALIST_DOCTOR';
	

--------------------------------------------------------------------------------------------------------------------------
-- UnitGameplay2DScripts
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO UnitGameplay2DScripts 	
		(UnitType, 					SelectionSound, FirstSelectionSound)
SELECT	'UNIT_GREAT_DOCTOR', 	'AS2D_BUILD_UNIT', 'AS2D_BUILD_UNIT';
--------------------------------------------------------------------------------------------------------------------------
-- Unit_AITypes
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO Unit_AITypes 	
		(UnitType, 					UnitAIType)
SELECT	'UNIT_GREAT_DOCTOR', 	UnitAIType
FROM Unit_AITypes WHERE UnitType = 'UNIT_ENGINEER';

--------------------------------------------------------------------------------------------------------------------------
-- Unit_Flavors
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO Unit_Flavors 	
		(UnitType, 					FlavorType, Flavor)
SELECT	'UNIT_GREAT_DOCTOR', 	FlavorType, Flavor
FROM Unit_Flavors WHERE UnitType = 'UNIT_ENGINEER';


	

INSERT INTO Specialists (Type,	Visible,	Description,		Strategy,	GreatPeopleTitle,	IconAtlas,	PortraitIndex,  GreatPeopleUnitClass,  GreatPeopleRateChange) 
SELECT 'SPECIALIST_DOCTOR',	1,	'TXT_KEY_SPECIALIST_DOCTOR','TXT_KEY_SPECIALIST_DOCTOR_STRATEGY',	'TXT_KEY_SPECIALIST_DOCTOR_TITLE',	'ROBOT_ICON_ATLAS4',	45,'UNITCLASS_GREAT_DOCTOR',	2;


INSERT INTO SpecialistYields (SpecialistType,	YieldType,			Yield)
SELECT 'SPECIALIST_DOCTOR',						'YIELD_SCIENCE',	   1 UNION ALL
SELECT 'SPECIALIST_DOCTOR',						'YIELD_HEALTH',		2;


INSERT  INTO Policy_SpecialistYieldChanges(PolicyType,SpecialistType,YieldType,Yield )
SELECT 'POLICY_KNOWLEDGE_4', 'SPECIALIST_DOCTOR' ,'YIELD_HEALTH', 1 ;


INSERT INTO SpecialistFlavors (SpecialistType,	FlavorType,			Flavor)
SELECT 'SPECIALIST_DOCTOR',						'FLAVOR_SCIENCE',	40 UNION ALL
SELECT 'SPECIALIST_DOCTOR',						'FLAVOR_GROWTH',	240;


--------------------------------------------------------------------------------------------------------------------------
-- Unit_UniqueNames
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO Unit_UniqueNames 	
		(UnitType, 					UniqueName)
SELECT	'UNIT_GREAT_DOCTOR', 	Tag
FROM Language_en_US WHERE Tag IN ('TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_1', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_2', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_3', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_4', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_5', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_6', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_7', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_8', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_9', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_10', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_11', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_12', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_13', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_14', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_15', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_16', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_17', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_18', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_19', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_20', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_21', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_22', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_23', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_24', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_25', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_26', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_27', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_28', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_29', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_31', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_32', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_33', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_34', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_35', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_36', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_37', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_38', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_39', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_40', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_41', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_42', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_43', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_44', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_45', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_46', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_47', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_48', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_49', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_50', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_51', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_52', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_53', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_54', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_55', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_56', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_57', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_58', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_59', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_60', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_61', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_62', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_63', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_64', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_65', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_66', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_67', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_68', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_69', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_70', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_71', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_72', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_73', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_74', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_75', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_76', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_77', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_78', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_79', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_80', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_81', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_82', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_83', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_84', 'TXT_KEY_GREAT_PERSON_GREAT_DOCTOR_85');
--==========================================================================================================================
--==========================================================================================================================



--==========================================================================================================================	
-- Builds
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO Builds
		(Type,							ImprovementType, 				Kill,	Description,			  Help,			Recommendation,						CtrlDown,	OrderPriority,	IconIndex,	IconAtlas,					HotKey, EntityEvent)
SELECT	'BUILD_SANATORIUM',			'IMPROVEMENT_SANATORIUM',	1,		'TXT_KEY_BUILD_SANATORIUM', 'TXT_KEY_BUILD_SANATORIUM_HELP','TXT_KEY_BUILD_SANATORIUM_REC',	1,			96,				6,			'ROG_IMPROVEMENTS_ATLAS',	'KB_L',	'ENTITY_EVENT_IRRIGATE';

INSERT INTO Unit_Builds
		(UnitType,					BuildType)
SELECT	'UNIT_GREAT_DOCTOR',			'BUILD_SANATORIUM';


--------------------------------------------------------------------------------------------------------------------------
-- BuildFeatures
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO BuildFeatures
		(BuildType, 				FeatureType, PrereqTech, Time, Remove)
SELECT	'BUILD_SANATORIUM',			FeatureType, PrereqTech, Time, Remove
FROM BuildFeatures WHERE BuildType = 'BUILD_HOLY_SITE';



--==========================================================================================================================
-- Improvements
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO Improvements
		(Type,				BuildableOnResources,	CreatedByGreatPerson,	Description,	Help,							ArtDefineTag,							Civilopedia,										PillageGold,	PortraitIndex,	IconAtlas)
SELECT	'IMPROVEMENT_SANATORIUM',		1,			1,		'TXT_KEY_IMPROVEMENT_SANATORIUM','TXT_KEY_IMPROVEMENT_SANATORIUM_HELP',		'ART_DEF_IMPROVEMENT_EMBASSY', 	'TXT_KEY_CIV5_IMPROVEMENTS_SANATORIUM_TEXT',	20,				6,				'ROG_IMPROVEMENTS_ATLAS';


--------------------------------------------------------------------------------------------------------------------------
-- Improvement_ResourceTypes
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO Improvement_ResourceTypes
		(ImprovementType,				ResourceType)
SELECT	'IMPROVEMENT_SANATORIUM', 	ResourceType
FROM Improvement_ResourceTypes WHERE ImprovementType = 'IMPROVEMENT_HOLY_SITE';


--------------------------------------------------------------------------------------------------------------------------
-- Improvement_ValidTerrains
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO Improvement_ValidTerrains(ImprovementType,				TerrainType)
SELECT	'IMPROVEMENT_SANATORIUM', 	TerrainType
FROM Improvement_ValidTerrains WHERE ImprovementType = 'IMPROVEMENT_HOLY_SITE';







--==========================================================================================================================
-- AUDIO
--==========================================================================================================================	
-- Audio_Sounds
------------------------------	
INSERT INTO Audio_Sounds 
		(SoundID, 								Filename, 				LoadType)
VALUES	('SND_SOUND_DOCTOR', 				'Doctor',				'DynamicResident');	
------------------------------
-- Audio_2DSounds
------------------------------	
INSERT INTO Audio_2DSounds 
		(ScriptID, 								SoundID, 					SoundType, 				TaperSoundtrackVolume,	MinVolume, 	MaxVolume,  IsMusic, Looping)
VALUES	('AS2D_SOUND_DOCTOR',				'SND_SOUND_DOCTOR', 			'GAME_SFX', 			-1.0,					100, 		100, 		0, 		 0);
--==========================================================================================================================


-----------------------------------------------------------------------------------------------------
-- Trait_SpecialistYieldChanges
-----------------------------------------------------------------------------------------------------
--INSERT INTO Trait_SpecialistYieldChanges 
		--(TraitType,		SpecialistType, 			YieldType, 	Yield)
--SELECT	TraitType,		'SPECIALIST_DOCTOR',	YieldType, 	Yield
--FROM Trait_SpecialistYieldChanges WHERE SpecialistType = 'SPECIALIST_SCIENTIST';
--==========================================================================================================================	
