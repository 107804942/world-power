--==========================================================================================================================
-- BELIEFS
--==========================================================================================================================	
ALTER TABLE Beliefs	ADD FaithToHealthRate	integer	default 0;



INSERT INTO Beliefs (Type,				Pantheon,	Founder,	Follower,	Description,							ShortDescription)
SELECT 'BELIEF_HEALTH_VAPORS',			1,			0,			0,			'TXT_KEY_BELIEF_HEALTH_VAPORS',			'TXT_KEY_BELIEF_HEALTH_VAPORS_SHORT' UNION ALL
--SELECT 'BELIEF_HEALTH_PRAYER',			0,			1,			0,			'TXT_KEY_BELIEF_HEALTH_PRAYER',			'TXT_KEY_BELIEF_HEALTH_PRAYER_SHORT' UNION ALL
SELECT 'BELIEF_HEALTH_SACRIFICE',		0,			0,			1,			'TXT_KEY_BELIEF_HEALTH_SACRIFICE',		'TXT_KEY_BELIEF_HEALTH_SACRIFICE_SHORT';


INSERT INTO Belief_CityYieldChanges (BeliefType,			YieldType,		Yield)
SELECT 'BELIEF_CEREMONIAL_BURIAL',	                        'YIELD_HEALTH',	2 ;   --‘·¿Ò“« Ω


--INSERT INTO Belief_YieldChangePerForeignCity (BeliefType,	YieldType,		Yield)
--SELECT 'BELIEF_HEALTH_PRAYER',								'YIELD_HEALTH',	2;


INSERT INTO Belief_FeatureYieldChanges (BeliefType,	FeatureType,			YieldType,		Yield)
SELECT 'BELIEF_HEALTH_VAPORS',						'FEATURE_MARSH',		'YIELD_HEALTH',	1 UNION ALL
SELECT 'BELIEF_HEALTH_VAPORS',						'FEATURE_FLOOD_PLAINS',	'YIELD_HEALTH',	1;

INSERT INTO Belief_BuildingClassYieldChanges (BeliefType,	BuildingClassType,		YieldType,		YieldChange)
SELECT 'BELIEF_HEALTH_SACRIFICE',							'BUILDINGCLASS_SHRINE',	'YIELD_HEALTH',	1 UNION ALL
SELECT 'BELIEF_HEALTH_SACRIFICE',							'BUILDINGCLASS_TEMPLE',	'YIELD_HEALTH',	1;

