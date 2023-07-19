
--建筑来自友好城邦的产出
--CREATE TABLE IF NOT EXISTS Building_YieldFromCityStates (
	--BuildingType text,
	--YieldType text,
	--Yield integer default 0,
	--IncludeFriendly boolean default false );



 -----晋升显示
--ALTER TABLE UnitPromotions ADD COLUMN 'ShowInTooltip' INTEGER DEFAULT 1;



-- 精英单位升级后移动
UPDATE Units SET MoveAfterUpgrade=1 WHERE HurryCostModifier='-1' AND ProjectPrereq != 'NULL';

-- 禁止城邦送精英单位
UPDATE Units SET NoMinorGifts=1 WHERE HurryCostModifier='-1' AND ProjectPrereq != 'NULL';



-- 取消石工坊地形要求
UPDATE Buildings
SET	ProhibitedCityTerrain = null
WHERE Type = 'BUILDING_STONE_WORKS';




-- 限定互斥晋升
ALTER TABLE UnitPromotions ADD MutuallyExclusiveGroup INTEGER DEFAULT -1;


-- 晋升显示
--ALTER TABLE UnitPromotions  ADD COLUMN 'ShowInUnitPanel' INTEGER DEFAULT 1;

--ALTER TABLE UnitPromotions ADD COLUMN 'ShowInPedia' INTEGER DEFAULT 1;



-- 多建筑关联
-- CREATE TABLE IF NOT EXISTS
 --Building_ClassesNeededInCityOR(
 --BuildingType                text    REFERENCES Buildings(TYPE)                      DEFAULT NULL,
 --BuildingClassType            text    REFERENCES BuildingClasses(TYPE)                DEFAULT NULL);



 


-- AUDIO
--=====================================================================================================================================================================================
-- Audio_Sounds
------------------------------
INSERT INTO Audio_Sounds 
		(SoundID, 								Filename, 			LoadType)
VALUES  ('SND_TECH_FISHING',                    'TechFishing',     'DynamicResident'),
        ('SND_SATELLITE_CANNON',		'planetcarverbeam-001',	    'DynamicResident'),
        ('SND_SPACESHIP_CANNON',	      	'spaceshipcannon',	    'DynamicResident'),
		('SND_ARCTURUS_YAMATO_CANNON',		'ArcturusYamatoCannon',	'DynamicResident'),
		('SND_SPACE_TRANSPORT',		      'PlanetfallFlyInLand',	'DynamicResident'),
		('SND_MECH_POWER',		               'OpticalFlare',	    'DynamicResident'),
        ('SND_UNIT_TRANSPORT',		          'UEDRestoration',	    'DynamicResident'),
		('SND_TECH_MYSTICISM',                  'TechMysticism',    'DynamicResident'),
		('SND_TECH_STONE_TOOLS',                 'TechStoneTools',  'DynamicResident'),
		('SND_TECH_HUNTING',                      'TechHunting',    'DynamicResident'),
		('SND_HORSE',		                     'horse',	        'DynamicResident'),
		('SND_PLAGUE',		                     'Plague',	        'DynamicResident');  
   
------------------------------
-- Audio_2DSounds
------------------------------
INSERT INTO Audio_2DSounds 
			(ScriptID, 							SoundID, 								SoundType, 	MinVolume, 	MaxVolume,	IsMusic)
VALUES	('AS2D_PLAGUE',			             'SND_PLAGUE',				            'GAME_SFX',		    100,			100,		0),
        ('AS2D_HORSE',			             'SND_HORSE',				             'GAME_SFX',		200,			200,		0),
	    ('AS2D_SATELLITE_CANNON',			 'SND_SATELLITE_CANNON',				'GAME_SFX',			65,				65,			0),
		('AS2D_SPACESHIP_CANNON',			 'SND_SPACESHIP_CANNON',				'GAME_SFX',			365,	        365,		0),
		('AS2D_ARCTURUS_YAMATO_CANNON',	     'SND_ARCTURUS_YAMATO_CANNON',			'GAME_SFX',			65,				65,			0),
		('AS2D_SPACE_TRANSPORT',			 'SND_SPACE_TRANSPORT',				    'GAME_SFX',		    65,			    65,		    0),
		('AS2D_MECH_POWER',			         'SND_MECH_POWER',				        'GAME_SFX',		    100,			100,		0),
		('AS2D_TECH_MYSTICISM',              'SND_TECH_MYSTICISM',                  'GAME_SPEECH',      80,             80,			0),
		('AS2D_TECH_STONE_TOOLS',            'SND_TECH_STONE_TOOLS',                'GAME_SPEECH',      80,             80,			0),
		('AS2D_TECH_HUNTING',                'SND_TECH_HUNTING',                    'GAME_SPEECH',      80,             80,			0),
		('AS2D_UNIT_TRANSPORT',			     'SND_UNIT_TRANSPORT',				    'GAME_SFX',	        500,			500,		0),
		('AS2D_TECH_FISHING',                 'SND_TECH_FISHING',                   'GAME_SPEECH',      80,              80,		0);	



INSERT INTO Audio_Sounds (SoundID, Filename, LoadType) VALUES
('SND_TECH_FORTIFICATION', 'Fortification', 'DynamicResident'),
('SND_TECH_HUMANISM', 'Humanism', 'DynamicResident'),
('SND_TECH_MANUFACTURING', 'Manufacturing', 'DynamicResident'),
('SND_TECH_ROMANTICISM', 'Romanticism', 'DynamicResident'),
('SND_TECH_SOVEREIGNTY', 'Sovereignty', 'DynamicResident'),
('SND_TECH_NATURAL_HISTORY', 'NaturalHistory', 'DynamicResident'),
('SND_TECH_IMPERIALISM', 'Imperialism', 'DynamicResident');


INSERT INTO Audio_2DSounds (ScriptID,SoundID,SoundType,MinVolume,MaxVolume) VALUES
('AS2D_TECH_FORTIFICATION', 'SND_TECH_FORTIFICATION', 'GAME_SPEECH',80,80),
('AS2D_TECH_NATURAL_HISTORY', 'SND_TECH_NATURAL_HISTORY', 'GAME_SPEECH',80,80),
('AS2D_TECH_IMPERIALISM', 'SND_TECH_IMPERIALISM', 'GAME_SPEECH',80,80),
('AS2D_TECH_HUMANISM', 'SND_TECH_HUMANISM', 'GAME_SPEECH',80,80),
('AS2D_TECH_MANUFACTURING', 'SND_TECH_MANUFACTURING', 'GAME_SPEECH',80,80),
('AS2D_TECH_SOVEREIGNTY', 'SND_TECH_SOVEREIGNTY', 'GAME_SPEECH',80,80);


----删除堡垒的军团晋升触发器
DROP TRIGGER UnitClass_FreePromotions_Corps; 
DROP TRIGGER UnitClass_FreePromotions_Armee; 

----删除堡垒的军团
DELETE FROM Unit_FreePromotions WHERE PromotionType = 'PROMOTION_CORPS_1' AND UnitType = 'UNIT_CITADEL_MID';
DELETE FROM Unit_FreePromotions WHERE PromotionType = 'PROMOTION_CORPS_1' AND UnitType = 'UNIT_CITADEL_LATE';
DELETE FROM Unit_FreePromotions WHERE PromotionType = 'PROMOTION_CORPS_2' AND UnitType = 'UNIT_CITADEL_LATE';

----删除堡垒的军团晋升触发器
--CREATE TRIGGER IF NOT EXISTS CITADEL_Corps
--AFTER INSERT ON Unit_FreePromotions WHEN (NEW.PromotionType = 'PROMOTION_CARGO_I'  AND EXISTS (SELECT * FROM Unit_FreePromotions WHERE (PromotionType = 'PROMOTION_CITADEL_DEFENSE' AND UnitType = NEW.UnitType)))
--BEGIN
	--DELETE FROM Unit_FreePromotions 
		--WHERE PromotionType = 'PROMOTION_CORPS_1' AND UnitType = NEW.UnitType;
--END;


--CREATE TRIGGER IF NOT EXISTS CITADEL_Armee
--AFTER INSERT ON Unit_FreePromotions WHEN (NEW.PromotionType = 'PROMOTION_CARGO_IV' AND EXISTS (SELECT * FROM Unit_FreePromotions WHERE (PromotionType = 'PROMOTION_CITADEL_DEFENSE' AND UnitType = NEW.UnitType)))
--BEGIN
	--DELETE FROM Unit_FreePromotions 
		--WHERE PromotionType = 'PROMOTION_CORPS_1' AND UnitType = NEW.UnitType;
	--DELETE FROM Unit_FreePromotions 
		--WHERE PromotionType = 'PROMOTION_CORPS_2' AND UnitType = NEW.UnitType;
--END;


