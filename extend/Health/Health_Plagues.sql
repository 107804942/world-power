--==========================================================================================================================
-- PLAGUES
--==========================================================================================================================

CREATE TABLE IF NOT EXISTS 
	Plagues (
	ID  														integer 										primary key autoincrement,
	Type  														text 											default null,
	Description													text											default null,
	IsEventOnly													boolean											default 0,
	IconString													text											default null);

--------------------------------------------------------------------------------------------------------------------------
-- Building_HealthMods
--------------------------------------------------------------------------------------------------------------------------	
CREATE TABLE IF NOT EXISTS 
Building_HealthMods (
	BuildingType												text		REFERENCES Buildings(Type)				default null,
	DiseaseConnectionMod										integer												default 0,
	DiseasePopMod												integer												default 0,
	DiseaseTRMod												integer												default 0,
	HealthToFoodMod												integer												default 0,
	PlagueMod													integer												default 0,
	IsLocal														boolean												default 0);	
--------------------
--------------------------------------------------------------------------------------------------------------------------
-- Policy_HealthMods
--------------------------------------------------------------------------------------------------------------------------	
CREATE TABLE IF NOT EXISTS 
Policy_HealthMods (
	PolicyType													text		REFERENCES Policies(Type)				default null,
	DiseaseConnectionMod										integer												default 0,
	DiseasePopMod												integer												default 0,
	DiseaseTRMod												integer												default 0,
	HealthToFoodMod												integer												default 0,
	PlagueMod													integer												default 0);	
-----------------------------------------------------------------------------------------------------------------------
-- Trait_HealthMods
--------------------------------------------------------------------------------------------------------------------------	
CREATE TABLE IF NOT EXISTS 
Trait_HealthMods (
	TraitType													text		REFERENCES Traits(Type)					default null,
	DiseaseConnectionMod										integer												default 0,
	DiseasePopMod												integer												default 0,
	DiseaseTRMod												integer												default 0,
	HealthToFoodMod												integer												default 0,
	PlagueMod													integer												default 0);	
-----------------------------------------------------------------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------------------------------------------------	
INSERT INTO Colors ( Type, 	Red, 	Green, 	Blue, 	Alpha)
SELECT	'COLOR_DISEASE', 	0.560, 	0.576, 	0,		1 UNION ALL	
SELECT	'COLOR_HEALTH', 	0.803, 	0.929, 	0.929, 	1 UNION ALL	
SELECT	'COLOR_PLAGUE', 	0.650, 	0.4, 	0,		1;	



INSERT INTO Plagues( Type,					Description, 		 IconString)
SELECT 'PLAGUE_AIDS',					'TXT_KEY_PLAGUE_AIDS',				'[ICON_PLAGUE_AIDS]' UNION ALL							
SELECT 'PLAGUE_ALCOHOL',				'TXT_KEY_PLAGUE_ALCOHOL',			'[ICON_PLAGUE_ALCOHOL]' UNION ALL	
SELECT 'PLAGUE_BONES',					'TXT_KEY_PLAGUE_BONES',				'[ICON_PLAGUE_BONES]'UNION ALL
SELECT 'PLAGUE_BRONCHITIS',			'TXT_KEY_PLAGUE_BRONCHITIS',		'[ICON_PLAGUE_BRONCHITIS]' UNION ALL	
SELECT 'PLAGUE_BUBONIC',				'TXT_KEY_PLAGUE_BUBONIC',			'[ICON_PLAGUE_BUBONIC]' UNION ALL								
SELECT 'PLAGUE_CANCER',				'TXT_KEY_PLAGUE_CANCER',			'[ICON_PLAGUE_CANCER]' UNION ALL	
SELECT 'PLAGUE_CHOLERA',				'TXT_KEY_PLAGUE_CHOLERA',			'[ICON_PLAGUE_CHOLERA]' UNION ALL	
SELECT 'PLAGUE_DANCING',				'TXT_KEY_PLAGUE_DANCING',			'[ICON_PLAGUE_DANCING]' UNION ALL	
SELECT 'PLAGUE_DENGUE',				'TXT_KEY_PLAGUE_DENGUE',			'[ICON_PLAGUE_DENGUE]' UNION ALL	
SELECT 'PLAGUE_DYSENTERY',				'TXT_KEY_PLAGUE_DYSENTERY',			'[ICON_PLAGUE_DYSENTERY]' UNION ALL	
SELECT 'PLAGUE_FATIGUE',				'TXT_KEY_PLAGUE_FATIGUE',			'[ICON_PLAGUE_FATIGUE]' UNION ALL	
SELECT 'PLAGUE_FEVER',					'TXT_KEY_PLAGUE_FEVER',				'[ICON_PLAGUE_FEVER]' UNION ALL	
SELECT 'PLAGUE_FOOD',					'TXT_KEY_PLAGUE_FOOD',				'[ICON_PLAGUE_FOOD]' UNION ALL	
SELECT 'PLAGUE_GOUT',					'TXT_KEY_PLAGUE_GOUT',				'[ICON_PLAGUE_GOUT]' UNION ALL	
SELECT 'PLAGUE_HIVES',					'TXT_KEY_PLAGUE_HIVES',				'[ICON_PLAGUE_HIVES]' UNION ALL	
SELECT 'PLAGUE_IMPOTENCE',				'TXT_KEY_PLAGUE_IMPOTENCE',			'[ICON_PLAGUE_IMPOTENCE]' UNION ALL	
SELECT 'PLAGUE_INFLUENZA',				'TXT_KEY_PLAGUE_INFLUENZA',			'[ICON_PLAGUE_INFLUENZA]' UNION ALL	
SELECT 'PLAGUE_LEG',					'TXT_KEY_PLAGUE_LEG',				'[ICON_PLAGUE_LEG]' UNION ALL	
SELECT 'PLAGUE_LEPROSY',				'TXT_KEY_PLAGUE_LEPROSY',			'[ICON_PLAGUE_LEPROSY]' UNION ALL	
SELECT 'PLAGUE_LOCKJAW',				'TXT_KEY_PLAGUE_LOCKJAW',			'[ICON_PLAGUE_LOCKJAW]' UNION ALL	
SELECT 'PLAGUE_LUNACY',				'TXT_KEY_PLAGUE_LUNACY',			'[ICON_PLAGUE_LUNACY]' UNION ALL		
SELECT 'PLAGUE_MALAISE',				'TXT_KEY_PLAGUE_MALAISE',			'[ICON_PLAGUE_MALAISE]' UNION ALL	
SELECT 'PLAGUE_MEASLES',				'TXT_KEY_PLAGUE_MEASLES',			'[ICON_PLAGUE_MEASLES]' UNION ALL	
SELECT 'PLAGUE_MENIERE',				'TXT_KEY_PLAGUE_MENIERE',			'[ICON_PLAGUE_MENIERE]' UNION ALL	
SELECT 'PLAGUE_POSSESSION',			'TXT_KEY_PLAGUE_POSSESSION',		'[ICON_PLAGUE_POSSESSION]' UNION ALL	
SELECT 'PLAGUE_PNEUMONIA',				'TXT_KEY_PLAGUE_PNEUMONIA',			'[ICON_PLAGUE_PNEUMONIA]' UNION ALL	
SELECT 'PLAGUE_RABIES',				'TXT_KEY_PLAGUE_RABIES',			'[ICON_PLAGUE_RABIES]' UNION ALL	
SELECT 'PLAGUE_SCURVY',				'TXT_KEY_PLAGUE_SCURVY',			'[ICON_PLAGUE_SCURVY]' UNION ALL	
SELECT 'PLAGUE_SEPTICEMIA',			'TXT_KEY_PLAGUE_SEPTICEMIA',		'[ICON_PLAGUE_SEPTICEMIA]' UNION ALL	
SELECT 'PLAGUE_SLEEPING',				'TXT_KEY_PLAGUE_SLEEPING',			'[ICON_PLAGUE_SLEEPING]' UNION ALL	
SELECT 'PLAGUE_SIDS',					'TXT_KEY_PLAGUE_SIDS',				'[ICON_PLAGUE_SIDS]' UNION ALL	
SELECT 'PLAGUE_SMALLPOX',				'TXT_KEY_PLAGUE_SMALLPOX',			'[ICON_PLAGUE_SMALLPOX]' UNION ALL	
SELECT 'PLAGUE_SYPHILIS',				'TXT_KEY_PLAGUE_SYPHILIS',			'[ICON_PLAGUE_SYPHILIS]' UNION ALL	
SELECT 'PLAGUE_SUICIDE',				'TXT_KEY_PLAGUE_SUICIDE',			'[ICON_PLAGUE_SUICIDE]' UNION ALL	
SELECT 'PLAGUE_TUBERCULOSIS',			'TXT_KEY_PLAGUE_TUBERCULOSIS',		'[ICON_PLAGUE_TUBERCULOSIS]' UNION ALL	
SELECT 'PLAGUE_TYPHOID',				'TXT_KEY_PLAGUE_TYPHOID',			'[ICON_PLAGUE_TYPHOID]' UNION ALL	
SELECT 'PLAGUE_TYPHUS',				'TXT_KEY_PLAGUE_TYPHUS',			'[ICON_PLAGUE_TYPHUS]' UNION ALL	
SELECT 'PLAGUE_WEILS',					'TXT_KEY_PLAGUE_WEILS',				'[ICON_PLAGUE_WEILS]' UNION ALL	
SELECT 'PLAGUE_YELLOW',				'TXT_KEY_PLAGUE_YELLOW',			'[ICON_PLAGUE_YELLOW]' UNION ALL	
SELECT 'PLAGUE_ZIKA',					'TXT_KEY_PLAGUE_ZIKA',				'[ICON_PLAGUE_ZIKA]';	

--==========================================================================================================================
--==========================================================================================================================
