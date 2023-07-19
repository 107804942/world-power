--ALTER TABLE Technologies ADD BombardRange INTEGER DEFAULT 0;
--ALTER TABLE Technologies ADD BombardIndirect INTEGER DEFAULT 0;
--ALTER TABLE Buildings ADD BombardRange INTEGER DEFAULT 0;
--ALTER TABLE Buildings ADD BombardIndirect INTEGER DEFAULT 0;


UPDATE Technologies     SET BombardIndirect=1   WHERE Type='TECH_ENGINEERING';
UPDATE Buildings        SET BombardRange=2   WHERE BuildingClass='BUILDINGCLASS_WALLS';
UPDATE Buildings        SET BombardRange=3 ,BombardIndirect=1  WHERE BuildingClass='BUILDINGCLASS_PALACE';
--UPDATE Buildings      SET BombardRange=2   WHERE Type='BUILDING_NORMAN_CAMP';
--UPDATE Buildings      SET BombardRange=2   WHERE Type='BUILDING_WALLS_OF_BABYLON';
UPDATE Buildings        SET BombardRange=3   WHERE BuildingClass='BUILDINGCLASS_MILITARY_BASE';
UPDATE Buildings        SET BombardRange=4   WHERE BuildingClass='BUILDINGCLASS_KRAK_DES_CHEVALIERS';
UPDATE Buildings        SET BombardRange=5   WHERE BuildingClass='BUILDINGCLASS_MATRIX';
UPDATE Buildings        SET BombardRange=8   WHERE BuildingClass='BUILDINGCLASS_SPACE_FORTRESS';


INSERT OR REPLACE INTO Defines(Name, Value) SELECT 'MAX_CITY_ATTACK_RANGE', max(BombardRange) FROM Technologies;
INSERT OR REPLACE INTO Defines(Name, Value) SELECT 'MAX_CITY_ATTACK_RANGE', max(BombardRange) FROM Buildings;

UPDATE CustomModOptions SET Value=1 WHERE Name='EVENTS_CITY_BOMBARD';




--ALTER TABLE Buildings ADD FreePromotion2 TEXT DEFAULT NULL;
