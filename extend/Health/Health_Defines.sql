--------------------------------------------------------------------------------------------------
--GameOptions
--------------------------------------------------------------------------------------------------
--INSERT INTO GameOptions (Type,				Description,									Help,										 SupportsMultiplayer)	
--SELECT 'GAMEOPTION_PLAGUE_DISABLED',		'TXT_KEY_GAMEOPTION_PLAGUE_DISABLED',			'TXT_KEY_GAMEOPTION_PLAGUE_DISABLED_HELP',			0 UNION ALL
--SELECT 'GAMEOPTION_PLAGUE_DESTROYS_CITIES',	'TXT_KEY_GAMEOPTION_PLAGUE_DESTROYS_CITIES',	'TXT_KEY_GAMEOPTION_PLAGUE_DESTROYS_CITIES_HELP',	 0 ;


UPDATE Yields SET GoldenAgeYieldMod = 20 WHERE Type = 'YIELD_HEALTH';
--UPDATE Yields SET GoldenAgeYield = 1 ,GoldenAgeYieldThreshold= 1 WHERE Type = 'YIELD_HEALTH';


INSERT INTO Defines(Name,									Value)
SELECT	'HEALTH_DISEASE_PER_POPULATION',					1;

INSERT INTO Defines(Name,									Value)
SELECT	'HEALTH_DISEASE_CITY_CONNECTION_MODIFIER',			5;

INSERT INTO Defines(Name,									Value)
SELECT	'HEALTH_DISEASE_TRADE_ROUTE_MODIFIER',				3;

INSERT INTO Defines(Name,									Value)
SELECT	'HEALTH_PLAGUE_FOOD_CONSUMPTION',					1;

INSERT INTO Defines(Name,									Value)
SELECT	'HEALTH_PLAGUE_MIN_THRESHOLD_GAMESPEED_EPIC',		200;

INSERT INTO Defines(Name,									Value)
SELECT	'HEALTH_PLAGUE_MIN_THRESHOLD_GAMESPEED_MARATHON',	300;

INSERT INTO Defines(Name,									Value)
SELECT	'HEALTH_PLAGUE_MIN_THRESHOLD_GAMESPEED_QUICK',		100;

INSERT INTO Defines  (Name,									Value)
SELECT	'HEALTH_PLAGUE_MIN_THRESHOLD_GAMESPEED_STANDARD',	150;


-----------------------------------------------------------------------------------------------------
--Promotions
----------------------------------------------------------------------------------------------------- 
INSERT INTO UnitPromotions (Type,CannotBeChosen, AttackMod,  DefenseMod,	        Description,					Help,								PediaEntry,						IconAtlas,					PortraitIndex,	Sound,				PediaType)
SELECT 'PROMOTION_PLAGUED',			 1,           	-50,		-50,		'TXT_KEY_PROMOTION_PLAGUED',	'TXT_KEY_PROMOTION_PLAGUED_HELP',	'TXT_KEY_PROMOTION_PLAGUED',	'VALERY_ATLAS',	25,				'AS2D_IF_LEVELUP',	'PEDIA_ATTRIBUTES';	

-----------------------------------------------------------------------------------------------------
--Pedia Entries
----------------------------------------------------------------------------------------------------- 
INSERT INTO Concepts (Type,		Topic,					Description,							Summary,								AdvisorQuestion,			Advisor,	CivilopediaHeaderType,	InsertBefore)
SELECT 'CONCEPT_HEALTH_CITY',	'TXT_KEY_TOPIC_CITIES',	'TXT_KEY_CITIES_HEALTH_HEADING3_TITLE',	'TXT_KEY_CITIES_HEALTH_HEADING3_BODY',	'TXT_KEY_CITIES_ADV_QUEST',	'ECONOMIC',	'HEADER_CITIES',		'CONCEPT_CITIES' UNION ALL
SELECT 'CONCEPT_HEALTH_EMPIRE',	'TXT_KEY_TOPIC_CITIES',	'TXT_KEY_EMPIRE_HEALTH_HEADING3_TITLE',	'TXT_KEY_EMPIRE_HEALTH_HEADING3_BODY',	'TXT_KEY_CITIES_ADV_QUEST',	'ECONOMIC',	'HEADER_CITIES',		'CONCEPT_CITIES' UNION ALL
SELECT 'CONCEPT_HEALTH_PLAGUE',	'TXT_KEY_TOPIC_CITIES',	'TXT_KEY_CITIES_PLAGUE_HEADING3_TITLE',	'TXT_KEY_CITIES_PLAGUE_HEADING3_BODY',	'TXT_KEY_CITIES_ADV_QUEST',	'ECONOMIC',	'HEADER_CITIES',		'CONCEPT_CITIES';


