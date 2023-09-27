
INSERT INTO UnitCombatInfos  	(Type,					Description)VALUES		
    ('UNITCOMBAT_SETTLER',	'TXT_KEY_UNITCOMBAT_SETTLER'),
	('UNITCOMBAT_WORKER',	'TXT_KEY_UNITCOMBAT_WORKER');

UPDATE Units SET CombatClass = 'UNITCOMBAT_SETTLER' WHERE Class  = 'UNITCLASS_SETTLER';
UPDATE Units SET CombatClass = 'UNITCOMBAT_WORKER' WHERE Class = 'UNITCLASS_WORKER';




INSERT INTO Unit_TechCombatStrength 
(UnitType, 		TechType,		CombatStrength)
VALUES		('UNIT_MECH',		'TECH_HOMO_SUPERIOR', 1500);

INSERT INTO Unit_TechRangedCombatStrength 
(UnitType, 		TechType,		RangedCombatStrength)
VALUES		('UNIT_MECH',		'TECH_HOMO_SUPERIOR', 1500);


---对领域加成
INSERT  INTO UnitPromotions_Domains(PromotionType,DomainType,Defense)
VALUES('PROMOTION_PARATROOPER_BUFF', 'DOMAIN_AIR',50);



---晋升关联单位种类
INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_CAUSEWAY', Type FROM UnitCombatInfos WHERE ID >= 0;

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT  'PROMOTION_EXPLOSIVE_MIXTURE', Type FROM Units WHERE RangedCombat > 0;


INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_YUEYANG', Type FROM UnitCombatInfos WHERE Type= 'UNITCOMBAT_MELEE';


INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_BEILUN_TOWER', Type FROM UnitCombatInfos WHERE Type= 'UNITCOMBAT_SUBMARINE'OR Type= 'UNITCOMBAT_NAVALMELEE'OR Type= 'UNITCOMBAT_NAVALRANGED' OR Type= 'UNITCOMBAT_CARRIER';

INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_STEAM_POWERED', Type FROM UnitCombatInfos WHERE Type= 'UNITCOMBAT_SUBMARINE'OR Type= 'UNITCOMBAT_NAVALMELEE'OR Type= 'UNITCOMBAT_NAVALRANGED' OR Type= 'UNITCOMBAT_CARRIER';

INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_NAVAL_ACADEMY', Type FROM UnitCombatInfos WHERE Type= 'UNITCOMBAT_SUBMARINE'OR Type= 'UNITCOMBAT_NAVALMELEE'OR Type= 'UNITCOMBAT_NAVALRANGED' OR Type= 'UNITCOMBAT_CARRIER';


INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_PARATROOPER_BUFF', Type FROM UnitCombatInfos WHERE Type!= 'UNITCOMBAT_SUBMARINE'AND Type!= 'UNITCOMBAT_NAVALMELEE'AND Type!= 'UNITCOMBAT_NAVALRANGED' AND Type!= 'UNITCOMBAT_CARRIER' AND Type!= 'UNITCOMBAT_FIGHTER'AND Type!= 'UNITCOMBAT_ARCHER';

INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_FASIL_GHEBBI', Type FROM UnitCombatInfos WHERE Type!= 'UNITCOMBAT_SUBMARINE'AND Type!= 'UNITCOMBAT_NAVALMELEE'AND Type!= 'UNITCOMBAT_NAVALRANGED' AND Type!= 'UNITCOMBAT_CARRIER' AND Type!= 'UNITCOMBAT_FIGHTER'AND Type!= 'UNITCOMBAT_ARCHER';

INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_KGB', Type FROM UnitCombatInfos WHERE Type!= 'UNITCOMBAT_SUBMARINE'AND Type!= 'UNITCOMBAT_NAVALMELEE'AND Type!= 'UNITCOMBAT_NAVALRANGED' AND Type!= 'UNITCOMBAT_CARRIER' AND Type!= 'UNITCOMBAT_FIGHTER'AND Type!= 'UNITCOMBAT_ARCHER';

INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_ISHTARGATE', Type FROM UnitCombatInfos WHERE Type!= 'UNITCOMBAT_SUBMARINE'AND Type!= 'UNITCOMBAT_NAVALMELEE'AND Type!= 'UNITCOMBAT_NAVALRANGED' AND Type!= 'UNITCOMBAT_CARRIER' AND Type!= 'UNITCOMBAT_FIGHTER'AND Type!= 'UNITCOMBAT_ARCHER';

INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_MAGINOT_LINE', Type FROM UnitCombatInfos WHERE Type!= 'UNITCOMBAT_SUBMARINE'AND Type!= 'UNITCOMBAT_NAVALMELEE'AND Type!= 'UNITCOMBAT_NAVALRANGED' AND Type!= 'UNITCOMBAT_CARRIER' AND Type!= 'UNITCOMBAT_FIGHTER'AND Type!= 'UNITCOMBAT_ARCHER';

INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_CARCASSONNE_FAITH_COMBAT_BONUS', Type FROM UnitCombatInfos WHERE Type!= 'UNITCOMBAT_FIGHTER'AND Type!= 'UNITCOMBAT_ARCHER';

INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_SOVIET_FRIEND', Type FROM UnitCombatInfos WHERE Type!= 'UNITCOMBAT_FIGHTER'AND Type!= 'UNITCOMBAT_ARCHER';

INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_PEOPLES_HALL', Type FROM UnitCombatInfos WHERE Type!= 'UNITCOMBAT_FIGHTER'AND Type!= 'UNITCOMBAT_ARCHER';


INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_KARRUPP', Type FROM UnitCombatInfos WHERE Type!= 'UNITCOMBAT_SUBMARINE'AND Type!= 'UNITCOMBAT_NAVALMELEE'AND Type!= 'UNITCOMBAT_NAVALRANGED' AND Type!= 'UNITCOMBAT_CARRIER' AND Type!= 'UNITCOMBAT_FIGHTER'AND Type!= 'UNITCOMBAT_ARCHER';



INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_LIBERATION_STRENGTH', Type FROM UnitCombatInfos;

INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_FW_SKYNET_LINK', Type FROM UnitCombatInfos;

INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_GOLDEN_BUFF', Type FROM UnitCombatInfos;
------------------------------------------------------------------------------------------------------------------------
-- 单位战略视图
------------------------------------------------------------------------------------------------------------------------
UPDATE SPTriggerControler SET Enabled = 1 WHERE TriggerType = 'SPNDeleteALLUnitStrategicFlag';
UPDATE SPNewEffectControler SET Enabled = 1 WHERE Type = 'SP_DELETE_ALL_STRATEGIC_UNIT_FLAG';

UPDATE SPTriggerControler SET Enabled = 1 WHERE TriggerType = 'Minor_Building_Overrides_Trigger';


---大军和海军上将免疫溅射
--INSERT  INTO Unit_FreePromotions(UnitType,PromotionType)
--SELECT  Type, 'PROMOTION_ANTI_SPLASH' FROM Units WHERE Class= 'UNITCLASS_GREAT_GENERAL'OR Class= 'UNITCLASS_GREAT_ADMIRAL';



------------------------------------------------------------------------------------------------------------------------
-- 科技或建筑免费晋升关联单位种类
------------------------------------------------------------------------------------------------------------------------



INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT  'PROMOTION_NAVAL_SIGHT', Type  FROM Units WHERE Domain ='DOMAIN_SEA';

------特种金属
INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_SMETAL', Type  FROM Units WHERE Class ='UNITCLASS_SUPER_ROCKET';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_SMETAL', Type  FROM Units WHERE Class ='UNITCLASS_ROCKET_ARTILLERY';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_SMETAL', Type  FROM Units WHERE Class ='UNITCLASS_CHINESE_WEISHI';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_SMETAL', Type  FROM Units WHERE Class ='UNITCLASS_SABR';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_SMETAL', Type  FROM Units WHERE Class ='UNITCLASS_SAM_INFANTRY';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_SMETAL', Type  FROM Units WHERE Class ='UNITCLASS_SELF_PROPELLED_ARTILLERY';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_SMETAL', Type  FROM Units WHERE Class ='UNITCLASS_FW_HOVERTANK';

------溅射穿透

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_EQUICK', Type  FROM Units WHERE Class ='UNITCLASS_SUPER_ROCKET';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_EQUICK', Type  FROM Units WHERE Class ='UNITCLASS_ROCKET_ARTILLERY';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_EQUICK', Type  FROM Units WHERE Class ='UNITCLASS_CHINESE_WEISHI';

---悬浮

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_EHOVER', Type  FROM Units WHERE Class ='UNITCLASS_FW_HOVERTANK';





---海军防空
INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_ANTIAIRX', Type  FROM Units WHERE Class ='UNITCLASS_MODERN_DESTROYER';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_ANTIAIRX', Type  FROM Units WHERE Class ='UNITCLASS_NAVALFIGHTER03H';


---轰炸机溅射
INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_AERIAL_REFUELING', Type  FROM Units WHERE Class ='UNITCLASS_STEALTH_BOMBER';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_AERIAL_REFUELING', Type  FROM Units WHERE Class ='UNITCLASS_FW_DRONE_FIGHTER_2';


---歼击机
INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_FIGHTER_ATTACK', Type  FROM Units WHERE Class ='UNITCLASS_AIRFIGHTER04P';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_FIGHTER_ATTACK', Type  FROM Units WHERE Class ='UNITCLASS_CARRIER_FIGHTER_FUTURE';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_FIGHTER_ATTACK', Type  FROM Units WHERE Class ='UNITCLASS_STEALTH_ATTACK_AIRCRAFT';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_FIGHTER_ATTACK', Type  FROM Units WHERE Class ='UNITCLASS_CARRIER_FIGHTER_ADV';


---机甲
INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_HPMOD1', Type  FROM Units WHERE Class ='UNITCLASS_MECH';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_CAN_RANGE_ATTACK', Type  FROM Units WHERE Class ='UNITCLASS_MECH';

---大军光环增强
INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_GENERAL_1', Type  FROM Units WHERE Class ='UNITCLASS_GREAT_GENERAL';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_PEOPLES_HALL', Type  FROM Units WHERE Class ='UNITCLASS_GREAT_GENERAL';


---堡垒增强
INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_HPMOD2', Type  FROM Units WHERE Class ='UNITCLASS_CITADEL_EARLY';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_HPMOD2', Type  FROM Units WHERE Class ='UNITCLASS_CITADEL_MID';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_HPMOD2', Type  FROM Units WHERE Class ='UNITCLASS_CITADEL_LATE';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_HPMOD2', Type  FROM Units WHERE Class ='UNITCLASS_CITADEL_FUTURE';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT  'PROMOTION_MAGINOT_LINE', Type  FROM Units WHERE Domain ='DOMAIN_LAND';


------------------------------------------------------------------------------------------------------------------------
-- 游猎系
------------------------------------------------------------------------------------------------------------------------
UPDATE UnitPromotions SET ExtraAttacks=1,ExtraWithdrawal=50,AttackFullyHealedMod=50 WHERE Type='PROMOTION_HELI_ATTACK';
UPDATE UnitPromotions SET ExtraAttacks=1,ExtraWithdrawal=50,AttackFullyHealedMod=50 WHERE Type='PROMOTION_HITANDRUN';
------------------------------------------------------------------------------------------------------------------------
-- 全地貌防御加成
------------------------------------------------------------------------------------------------------------------------
INSERT  INTO UnitPromotions_Features(PromotionType,FeatureType,Defense)
SELECT  'PROMOTION_GHOST_POWER', Type, 100  FROM Features WHERE ID !=-1;

INSERT  INTO UnitPromotions_Features(PromotionType,FeatureType,Attack)
SELECT  'PROMOTION_GHOST_POWER', Type, 100  FROM Features WHERE ID !=-1;






-----删除歼击机初始领域加成
DELETE FROM UnitPromotions_UnitCombatMods WHERE PromotionType = 'PROMOTION_AIR_ATTACK' AND UnitCombatType = 'UNITCOMBAT_MOUNTED';
DELETE FROM UnitPromotions_UnitCombatMods WHERE PromotionType = 'PROMOTION_AIR_ATTACK' AND UnitCombatType = 'UNITCOMBAT_ARMOR';

DELETE FROM UnitPromotions_Domains WHERE PromotionType = 'PROMOTION_AIR_ATTACK' AND DomainType = 'DOMAIN_LAND';
DELETE FROM UnitPromotions_Domains WHERE PromotionType = 'PROMOTION_AIR_ATTACK' AND DomainType = 'DOMAIN_SEA';

DELETE FROM UnitPromotions_Domains WHERE PromotionType = 'PROMOTION_CARRIER_FIGHTER' AND DomainType = 'DOMAIN_LAND';
DELETE FROM UnitPromotions_Domains WHERE PromotionType = 'PROMOTION_CARRIER_FIGHTER' AND DomainType = 'DOMAIN_SEA';



-----删除超弩级自带的25%攻击力防御力
--DELETE FROM Unit_FreePromotions WHERE PromotionType = 'PROMOTION_SP_ATTACK25' AND UnitType = 'UNIT_JAPANESE_BATTLESHIP';



 ---伟人一次性产出削弱
 UPDATE Units SET BaseBeakersTurnsToCount=1 WHERE Class='UNITCLASS_SCIENTIST';
 UPDATE Units SET BaseCultureTurnsToCount=3 WHERE Class='UNITCLASS_WRITER';
 UPDATE Units SET OneShotTourism=7 WHERE Class='UNITCLASS_MUSICIAN';
 UPDATE Units SET BaseHurry=3000 ,HurryMultiplier=50 WHERE Class='UNITCLASS_ENGINEER';
------------------------------------------------------------------------------------------------------------------------
-- 海军系判定
------------------------------------------------------------------------------------------------------------------------
INSERT  INTO Unit_FreePromotions(UnitType,PromotionType)
SELECT  Type, 'PROMOTION_SEA_COMBAT_UNIT' FROM Units WHERE Domain='DOMAIN_SEA' AND Class != 'UNITCLASS_NAVALCARRIER03S';

CREATE TRIGGER FreePromotionForSEA
AFTER INSERT ON Units
WHEN 'DOMAIN_SEA'=NEW.Domain AND NEW.Class != 'UNITCLASS_NAVALCARRIER03S'
BEGIN
  INSERT INTO Unit_FreePromotions(UnitType,PromotionType )
    VALUES(NEW.Type, 'PROMOTION_SEA_COMBAT_UNIT');
END;


---投石手
--INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Attack)
--SELECT  'PROMOTION_BLIALI', Type,DefenseMod FROM UnitPromotions WHERE DefenseMod != 0;

--INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Attack)
--SELECT  'PROMOTION_BLIALI', Type,RangedDefenseMod FROM UnitPromotions WHERE RangedDefenseMod != 0;


---天网对机器人
INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Modifier)
VALUES ('PROMOTION_FW_SKYNET_LINK','PROMOTION_ROBORT_COMBAT',25);

---重型机甲对机器人
INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Modifier)
VALUES ('PROMOTION_HEAVY_ROBORT','PROMOTION_ROBORT_COMBAT',25);

---突击虎对堡垒
INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Modifier)
VALUES ('PROMOTION_STURMTIGER','PROMOTION_CITADEL_DEFENSE',200);






---超级武器对堡垒
INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Attack)
VALUES ('PROMOTION_FOCUS','PROMOTION_CITADEL_DEFENSE',300);




---铁浮图以及赫梯对反骑兵、反装甲加成
INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Modifier)
VALUES ('PROMOTION_COMBAT_TO_DEATH','PROMOTION_ANTI_MOUNTED',100),
       ('PROMOTION_COMBAT_TO_DEATH','PROMOTION_ANTI_TANK',100),
       ('PROMOTION_ANTI_ANTI_MOUNTED_BONUS','PROMOTION_ANTI_MOUNTED',33),
       ('PROMOTION_ANTI_ANTI_MOUNTED_BONUS','PROMOTION_ANTI_TANK',33);
------------------------------------------------------------------------------------------------------------------------
-- 限制民兵数量
UPDATE UnitClasses SET MaxPlayerInstances=5 WHERE Type='UNITCLASS_WARRIOR';
UPDATE UnitClasses SET MaxPlayerInstances=5 WHERE Type='UNITCLASS_MILITIA_ANCIENT';
UPDATE UnitClasses SET MaxPlayerInstances=5 WHERE Type='UNITCLASS_MINUTEMAN';
UPDATE UnitClasses SET MaxPlayerInstances=5 WHERE Type='UNITCLASS_CONSCRIPTMAN';
UPDATE UnitClasses SET MaxPlayerInstances=5 WHERE Type='UNITCLASS_MILITIA_MODERN';

-- 给有关单位类型加入木材资源消耗

--复合弓
INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost )
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_COMPOSITE_BOWMAN';

CREATE TRIGGER CostForBowMan
AFTER INSERT ON Units
WHEN 'UNITCLASS_COMPOSITE_BOWMAN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;


 --弩兵
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost )
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_CROSSBOWMAN';

 CREATE TRIGGER CostForCrossBowMan
AFTER INSERT ON Units
WHEN 'UNITCLASS_CROSSBOWMAN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;


 --精英长弓手
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost )
 SELECT Type, 'RESOURCE_LUMBER',2 FROM Units WHERE Class='UNITCLASS_LONGBOWMAN';

  --投石车
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_CATAPULT';

 CREATE TRIGGER CostForCATAPULT
AFTER INSERT ON Units
WHEN 'UNITCLASS_CATAPULT'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;

 --抛石机
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost )
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_TREBUCHET';

CREATE TRIGGER CostForTREBUCHET
AFTER INSERT ON Units
WHEN 'UNITCLASS_TREBUCHET'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;



--三桨战船
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_TRIREME';

CREATE TRIGGER CostForTRIREME
AFTER INSERT ON Units
WHEN 'UNITCLASS_TRIREME'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;

 --桨帆战舰
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_GALLEASS';

CREATE TRIGGER CostForGALLEASS
AFTER INSERT ON Units
WHEN 'UNITCLASS_GALLEASS'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;


--桨帆大战舰
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_GREAT_GALLEASS';

 CREATE TRIGGER CostForGREATGALLEASS
AFTER INSERT ON Units
WHEN 'UNITCLASS_GREAT_GALLEASS'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;



--巡航舰
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',2  FROM Units WHERE Class='UNITCLASS_FRIGATE';

CREATE TRIGGER CostForFRIGATE
AFTER INSERT ON Units
WHEN 'UNITCLASS_FRIGATE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',2);
END;


   --喷火船
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_FIRE_SHIP';

 CREATE TRIGGER CostForFIRESHIP
AFTER INSERT ON Units
WHEN 'UNITCLASS_FIRE_SHIP'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;

    --单栀战船
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_SLOOP_OF_WAR';

 CREATE TRIGGER CostForSLOOPOFWAR
AFTER INSERT ON Units
WHEN 'UNITCLASS_SLOOP_OF_WAR'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;

    --宝船
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost )
 SELECT Type, 'RESOURCE_LUMBER',2 FROM Units WHERE Class='UNITCLASS_ZHENGHE_FLEET';

     --轻帆船
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_CARAVEL';

  CREATE TRIGGER CostForCARAVEL
AFTER INSERT ON Units
WHEN 'UNITCLASS_CARAVEL'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;


     --风帆主力舰
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',2 FROM Units WHERE Class='UNITCLASS_SHIP_OF_THE_LINE';

CREATE TRIGGER CostForSHIPOFTHELINE
AFTER INSERT ON Units
WHEN 'UNITCLASS_SHIP_OF_THE_LINE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',2);
END;

 -------------------------------------火药------------------------------------
  --征召兵
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CONSCRIPTMAN';

CREATE TRIGGER CostForCONSCRIPTMAN
AFTER INSERT ON Units
WHEN 'UNITCLASS_CONSCRIPTMAN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

 --现代民兵
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MILITIA_MODERN';

CREATE TRIGGER CostForMILITIAMODERN
AFTER INSERT ON Units
WHEN 'UNITCLASS_MILITIA_MODERN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

 --火枪手
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MUSKETMAN';

CREATE TRIGGER CostForMUSKETMAN
AFTER INSERT ON Units
WHEN 'UNITCLASS_MUSKETMAN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


--雪橇步兵
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MUSKETEER';
--来复
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_RIFLEMAN';

CREATE TRIGGER CostForRIFLEMAN
AFTER INSERT ON Units
WHEN 'UNITCLASS_RIFLEMAN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--一战步兵
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_GREAT_WAR_INFANTRY';

CREATE TRIGGER CostForGREATWARINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_GREAT_WAR_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


--现代步兵
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_INFANTRY';

CREATE TRIGGER CostForINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--外籍军团
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_FOREIGNLEGION';
--摩托化步兵
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MOTORISED_INFANTRY';

CREATE TRIGGER CostForMOTORISEDINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_MOTORISED_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--机械化步兵
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MECHANIZED_INFANTRY';


CREATE TRIGGER CostForMECHANIZEDINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_MECHANIZED_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


 --伞兵
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_WWI_PARATROOPER';

CREATE TRIGGER CostForWWIPARATROOPER
AFTER INSERT ON Units
WHEN 'UNITCLASS_WWI_PARATROOPER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

 --陆战队
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MARINE';

CREATE TRIGGER CostForMARINE
AFTER INSERT ON Units
WHEN 'UNITCLASS_MARINE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

 --空降兵
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_PARATROOPER';

CREATE TRIGGER CostForPARATROOPER
AFTER INSERT ON Units
WHEN 'UNITCLASS_PARATROOPER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


 --精英阻击手
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_ELITE_SNIPER';


 --141
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_TASKFORCE_141';




 --胸甲骑兵
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_BOMBARD';

CREATE TRIGGER CostForBOMBARD
AFTER INSERT ON Units
WHEN 'UNITCLASS_BOMBARD'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;




 --一战战车
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_WWI_TANK';

CREATE TRIGGER CostForWWITANK
AFTER INSERT ON Units
WHEN 'UNITCLASS_WWI_TANK'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


 --战车
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_TANK';

CREATE TRIGGER CostForTANK
AFTER INSERT ON Units
WHEN 'UNITCLASS_TANK'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

 --主站坦克
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MAIN_BATTLE_TANK';

CREATE TRIGGER CostForMAINBATTLETANK
AFTER INSERT ON Units
WHEN 'UNITCLASS_MAIN_BATTLE_TANK'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

 --现代装甲
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MODERN_ARMOR';

CREATE TRIGGER CostForMODERNARMOR
AFTER INSERT ON Units
WHEN 'UNITCLASS_MODERN_ARMOR'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;



 --陆地铁甲舰
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',3 FROM Units WHERE Class='UNITCLASS_LAND_IRONCLAD';



 --哥萨克骑兵
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_COSSACK_MILITIA';

CREATE TRIGGER CostForCOSSACKMILITIA
AFTER INSERT ON Units
WHEN 'UNITCLASS_COSSACK_MILITIA'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


 --鼠式坦克
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_SUPER_TANK';






 --排放枪
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_VOLLEY_GUN';


CREATE TRIGGER CostForVOLLEYGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_VOLLEY_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


 --加特林机枪
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_GATLINGGUN';

CREATE TRIGGER CostForGATLINGGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_GATLINGGUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;



 --机关枪
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MACHINE_GUN';


CREATE TRIGGER CostForMACHINEGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_MACHINE_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;



 --高炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_ANTI_AIRCRAFT_GUN';


CREATE TRIGGER CostForANTIAIRCRAFT_GUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_ANTI_AIRCRAFT_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;



 --防空炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MOBILE_AA_GUN';


CREATE TRIGGER CostForMOBILEAAGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_MOBILE_AA_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;



 --导弹防空车
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_SAM_INFANTRY';


CREATE TRIGGER CostForSAMINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_SAM_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--超级臼炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',3 FROM Units WHERE Class='UNITCLASS_SUPER_HOWITZER';
--十字军火炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_CRUSADER_ARTILLERY';
--核火炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_NUCLEAR_ARTILLERY';


--火箭炮原型
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_PROTOTYPE_HWACHA';


  --重炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CULVERIN';

CREATE TRIGGER CostForCULVERIN
AFTER INSERT ON Units
WHEN 'UNITCLASS_CULVERIN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


 --加农炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CANNON';


CREATE TRIGGER CostForCANNON
AFTER INSERT ON Units
WHEN 'UNITCLASS_CANNON'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

  --火炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_HOWITZER';

CREATE TRIGGER CostForHOWITZER
AFTER INSERT ON Units
WHEN 'UNITCLASS_HOWITZER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

 --榴弹炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_ARTILLERY';

CREATE TRIGGER CostForARTILLERY
AFTER INSERT ON Units
WHEN 'UNITCLASS_ARTILLERY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


 --自走炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_SELF_PROPELLED_ARTILLERY';

CREATE TRIGGER CostForSELFPROPELLEDARTILLERY
AFTER INSERT ON Units
WHEN 'UNITCLASS_SELF_PROPELLED_ARTILLERY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;






--铁道炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_RAILROAD_GUN';

CREATE TRIGGER CostForRAILROADGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_RAILROAD_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--火箭炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_KATYUSHA';

CREATE TRIGGER CostForKATYUSHA
AFTER INSERT ON Units
WHEN 'UNITCLASS_KATYUSHA'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


--自行火箭炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_ROCKET_ARTILLERY';


CREATE TRIGGER CostForROCKETARTILLERY
AFTER INSERT ON Units
WHEN 'UNITCLASS_ROCKET_ARTILLERY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',2);
END;

--骑兵
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CAVALRY';

CREATE TRIGGER CostForCAVALRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_CAVALRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;



--巡航坦克
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CRUISER_TANK';

CREATE TRIGGER CostForCRUISERTANK
AFTER INSERT ON Units
WHEN 'UNITCLASS_CRUISER_TANK'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--直升机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_HELICOPTER_GUNSHIP';

CREATE TRIGGER CostForHELICOPTERGUNSHIP
AFTER INSERT ON Units
WHEN 'UNITCLASS_HELICOPTER_GUNSHIP'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


--武装直升机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_ATTACK_HELICOPTER';

CREATE TRIGGER CostForATTACKHELICOPTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_ATTACK_HELICOPTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;



--隐形直升机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_STEALTH_HELICOPTER';

--卫士火箭炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',3 FROM Units WHERE Class='UNITCLASS_CHINESE_WEISHI';


--反坦克炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_ANTI_TANK_GUN';


CREATE TRIGGER CostForANTITANKGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_ANTI_TANK_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--坦克歼击车
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_TANK_DESTROYER';




CREATE TRIGGER CostForTANKDESTROYER
AFTER INSERT ON Units
WHEN 'UNITCLASS_TANK_DESTROYER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


--反坦克导弹
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_ATGM_VEHICLE';

CREATE TRIGGER CostForATGMVEHICLE
AFTER INSERT ON Units
WHEN 'UNITCLASS_ATGM_VEHICLE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;






--轻型铁甲舰
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_LIGHT_IRONCLAD';

CREATE TRIGGER CostForLIGHTIRONCLAD
AFTER INSERT ON Units
WHEN 'UNITCLASS_LIGHT_IRONCLAD'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--潜艇
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_SUBMARINE';

CREATE TRIGGER CostForSUBMARINE
AFTER INSERT ON Units
WHEN 'UNITCLASS_SUBMARINE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--鹦鹉螺
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_PROTOTYPE_SUBMARINE';
--核潜艇
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_NUCLEAR_SUBMARINE';

CREATE TRIGGER CostForNUCLEARSUBMARINE
AFTER INSERT ON Units
WHEN 'UNITCLASS_NUCLEAR_SUBMARINE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--九头蛇
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_UNDERWATER_CARRIER';



--无畏舰
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_DREADNOUGHT';

CREATE TRIGGER CostForDREADNOUGHT
AFTER INSERT ON Units
WHEN 'UNITCLASS_DREADNOUGHT'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',2);
END;
--战列舰
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_BATTLESHIP';

CREATE TRIGGER CostForBATTLESHIP
AFTER INSERT ON Units
WHEN 'UNITCLASS_BATTLESHIP'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',2);
END;
--武库舰
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',3 FROM Units WHERE Class='UNITCLASS_FUTURE_BATTLESHIP';

CREATE TRIGGER CostForFUTUREBATTLESHIP
AFTER INSERT ON Units
WHEN 'UNITCLASS_FUTURE_BATTLESHIP'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',3);
END;
--大和号
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',4 FROM Units WHERE Class='UNITCLASS_ELITE_BATTLECRUISER';
--俾斯麦号
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',3 FROM Units WHERE Class='UNITCLASS_SUPER_BATTLESHIP';




--铁甲舰
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_IRONCLAD';

CREATE TRIGGER CostForIRONCLAD
AFTER INSERT ON Units
WHEN 'UNITCLASS_IRONCLAD'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--驱逐舰
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_DESTROYER';

CREATE TRIGGER CostForDESTROYER
AFTER INSERT ON Units
WHEN 'UNITCLASS_DESTROYER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--现代驱逐舰
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_MODERN_DESTROYER';

CREATE TRIGGER CostForMODERNDESTROYER
AFTER INSERT ON Units
WHEN 'UNITCLASS_MODERN_DESTROYER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',2);
END;





--装甲巡洋舰
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_PROTECTED_CRUISER';

CREATE TRIGGER CostForPROTECTEDCRUISER
AFTER INSERT ON Units
WHEN 'UNITCLASS_PROTECTED_CRUISER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--重型巡洋舰
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_HEAVY_CRUISER';

CREATE TRIGGER CostForHEAVYCRUISER
AFTER INSERT ON Units
WHEN 'UNITCLASS_HEAVY_CRUISER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


--导弹巡洋舰
DELETE FROM Unit_ResourceQuantityRequirements 
WHERE ResourceType = 'RESOURCE_OIL' AND UnitType = 'UNIT_FRANCE_MISTRAL';

DELETE FROM Unit_ResourceQuantityRequirements 
WHERE ResourceType = 'RESOURCE_OIL' AND UnitType = 'UNIT_MISSILE_CRUISER';

INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_MISSILE_CRUISER';

CREATE TRIGGER CostForMISSILECRUISER
AFTER INSERT ON Units
WHEN 'UNITCLASS_MISSILE_CRUISER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',2);
END;




--三翼机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_TRIPLANE';

CREATE TRIGGER CostForTRIPLANE
AFTER INSERT ON Units
WHEN 'UNITCLASS_TRIPLANE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--战机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_FIGHTER';

CREATE TRIGGER CostForFIGHTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_FIGHTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--喷气战机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_INTERCEPTER';


CREATE TRIGGER CostForINTERCEPTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_INTERCEPTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--隐形战机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_JET_FIGHTER';


CREATE TRIGGER CostForJETFIGHTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_JET_FIGHTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--T50
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_PAKFA_T50';





--一战轰炸机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_WWI_BOMBER';

CREATE TRIGGER CostForWWIBOMBER
AFTER INSERT ON Units
WHEN 'UNITCLASS_WWI_BOMBER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--俯冲轰炸机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_DIVE_BOMBER';

CREATE TRIGGER CostForDIVEBOMBER
AFTER INSERT ON Units
WHEN 'UNITCLASS_DIVE_BOMBER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--强击机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_ATTACK_AIRCRAFT';

CREATE TRIGGER CostForATTACKAIRCRAFT
AFTER INSERT ON Units
WHEN 'UNITCLASS_ATTACK_AIRCRAFT'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--隐形歼击机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_STEALTH_ATTACK_AIRCRAFT';

CREATE TRIGGER CostForSTEALTHATTACKAIRCRAFT
AFTER INSERT ON Units
WHEN 'UNITCLASS_STEALTH_ATTACK_AIRCRAFT'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',2);
END;




--一战舰载机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CARRIER_FIGHTER_WWII';

CREATE TRIGGER CostForCARRIERFIGHTERWWII
AFTER INSERT ON Units
WHEN 'UNITCLASS_CARRIER_FIGHTER_WWII'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--喷气式舰载机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CARRIER_FIGHTER_JET';

CREATE TRIGGER CostForCARRIERFIGHTERJET
AFTER INSERT ON Units
WHEN 'UNITCLASS_CARRIER_FIGHTER_JET'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--高级舰载机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CARRIER_FIGHTER_ADV';

CREATE TRIGGER CostForCARRIERFIGHTERADV
AFTER INSERT ON Units
WHEN 'UNITCLASS_CARRIER_FIGHTER_ADV'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;







--飞翼机原型
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_PROTOTYPE_BOMBER';

--战略轰炸机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_BOMBER';

CREATE TRIGGER CostForBOMBER
AFTER INSERT ON Units
WHEN 'UNITCLASS_BOMBER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',2);
END;

--喷气式轰炸机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',3 FROM Units WHERE Class='UNITCLASS_JET_BOMBER';

CREATE TRIGGER CostForJETBOMBER
AFTER INSERT ON Units
WHEN 'UNITCLASS_JET_BOMBER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',3);
END;

--隐形轰炸机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',4 FROM Units WHERE Class='UNITCLASS_STEALTH_BOMBER';

CREATE TRIGGER CostForSTEALTHBOMBER
AFTER INSERT ON Units
WHEN 'UNITCLASS_STEALTH_BOMBER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',4);
END;




----------------------------------------石油------------------------------------
--护卫舰
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_CORVETTE';

CREATE TRIGGER CostForOilCORVETTE
AFTER INSERT ON Units
WHEN 'UNITCLASS_CORVETTE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;


 --驱逐舰
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_DESTROYER';

CREATE TRIGGER CostForOilDESTROYER
AFTER INSERT ON Units
WHEN 'UNITCLASS_DESTROYER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
 --现代驱逐舰
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',3 FROM Units WHERE Class='UNITCLASS_MODERN_DESTROYER';

CREATE TRIGGER CostForOilMODERNDESTROYER
AFTER INSERT ON Units
WHEN 'UNITCLASS_MODERN_DESTROYER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',3);
END;
 --导弹巡洋舰
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',4 FROM Units WHERE Class='UNITCLASS_MISSILE_CRUISER';


CREATE TRIGGER CostForOilMISSILECRUISER
AFTER INSERT ON Units
WHEN 'UNITCLASS_MISSILE_CRUISER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',4);
END;
 --武库舰
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',5 FROM Units WHERE Class='UNITCLASS_FUTURE_BATTLESHIP';

CREATE TRIGGER CostForOilFUTUREBATTLESHIP
AFTER INSERT ON Units
WHEN 'UNITCLASS_FUTURE_BATTLESHIP'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',5);
END;

 --摩托化步兵
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_MOTORISED_INFANTRY';


CREATE TRIGGER CostForOilMOTORISEDINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_MOTORISED_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--机械化步兵
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_MECHANIZED_INFANTRY';

CREATE TRIGGER CostForOilMECHANIZEDINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_MECHANIZED_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;

 --直升机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_HELICOPTER_GUNSHIP';

CREATE TRIGGER CostForOilHELICOPTERGUNSHIP
AFTER INSERT ON Units
WHEN 'UNITCLASS_HELICOPTER_GUNSHIP'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
 --武装直升机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_ATTACK_HELICOPTER';

CREATE TRIGGER CostForOilATTACKHELICOPTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_ATTACK_HELICOPTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--反坦克车
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_TANK_DESTROYER';

CREATE TRIGGER CostForOilTANKDESTROYER
AFTER INSERT ON Units
WHEN 'UNITCLASS_TANK_DESTROYER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--反坦克导弹
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_ATGM_VEHICLE';

CREATE TRIGGER CostForOilATGMVEHICLE
AFTER INSERT ON Units
WHEN 'UNITCLASS_ATGM_VEHICLE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;

--铁道炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_RAILROAD_GUN';

CREATE TRIGGER CostForOilRAILROADGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_RAILROAD_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;



--三翼机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_TRIPLANE';

CREATE TRIGGER CostForOilTRIPLANE
AFTER INSERT ON Units
WHEN 'UNITCLASS_TRIPLANE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--战机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_FIGHTER';

CREATE TRIGGER CostForOilFIGHTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_FIGHTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--喷气战机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_INTERCEPTER';

CREATE TRIGGER CostForOilINTERCEPTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_INTERCEPTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--隐形战机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_JET_FIGHTER';

CREATE TRIGGER CostForOilJETFIGHTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_JET_FIGHTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--黑鸟
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',3 FROM Units WHERE Class='UNITCLASS_SR71_BLACKBIRD';


--一战舰载机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_CARRIER_FIGHTER_WWII';

CREATE TRIGGER CostForOilCARRIERFIGHTERWWII
AFTER INSERT ON Units
WHEN 'UNITCLASS_CARRIER_FIGHTER_WWII'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--喷气式舰载机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_CARRIER_FIGHTER_JET';

CREATE TRIGGER CostForOilCARRIERFIGHTERJET
AFTER INSERT ON Units
WHEN 'UNITCLASS_CARRIER_FIGHTER_JET'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--高级舰载机
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_CARRIER_FIGHTER_ADV';


CREATE TRIGGER CostForOilCARRIERFIGHTERADV
AFTER INSERT ON Units
WHEN 'UNITCLASS_CARRIER_FIGHTER_ADV'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;

 ------------------------------铁------------------------------
--反坦克炮
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_IRON',1 FROM Units WHERE Class='UNITCLASS_ANTI_TANK_GUN';

CREATE TRIGGER CostForIRONANTITANKGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_ANTI_TANK_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_IRON',1);
END;

 -------------------------------铝------------------------------
--防空导弹车
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_ALUMINUM',1 FROM Units WHERE Class='UNITCLASS_SAM_INFANTRY';

CREATE TRIGGER CostForALUMINUMSAMINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_SAM_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_ALUMINUM',1);
END;



 ----------------------------------给有关建筑类型加入木材资源消耗------------------------------
 --木栅栏
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',1 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_PALISADE';

--马厩
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',1 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_STABLE';

--乡村俱乐部
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',3 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_COUNTRY_CLUB';
--游乐场
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',3 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_AMUSEMENT_PARK';
--主题公园
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',3 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_THEME_PARK';
--酒吧
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',3 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_BEVERAGE_FACTORY';


--风车
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',1 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_WINDMILL';

--画廊
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',1 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_ART_GALLERY';

--水磨坊
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',1 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_WATERMILL';

--马戏场
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',1 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_CIRCUS';

--山寨
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',1 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_HILL_FORT';
 ----------------------------------------- 给兵工厂加入火药供给------------------------------
 INSERT INTO Building_ResourceQuantity (BuildingType, ResourceType,Quantity )
SELECT Type, 'RESOURCE_GUNPOWDER',3 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_ARSENAL';




 -------------------------------单位升级------------------------------

 --医生
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_MODERN_DOCTOR' FROM Units WHERE Class='UNITCLASS_DOCTOR';

 --堡垒
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_CITADEL_FUTURE' FROM Units WHERE Class='UNITCLASS_CITADEL_LATE';
 --民兵
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_RANGEDMARINE04P' FROM Units WHERE Class='UNITCLASS_MILITIA_MODERN';


 --机械化步兵
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_FW_BATTLESUIT' FROM Units WHERE Class='UNITCLASS_MECHANIZED_INFANTRY';

--反坦克
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_FW_RAILGUN_TANK' FROM Units WHERE Class='UNITCLASS_ATGM_VEHICLE';
--火箭炮
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_SUPER_ROCKET' FROM Units WHERE Class='UNITCLASS_ROCKET_ARTILLERY';

--攻城炮
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_FW_HOVERTANK' FROM Units WHERE Class='UNITCLASS_SELF_PROPELLED_ARTILLERY';

--防空炮
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_SABR' FROM Units WHERE Class='UNITCLASS_SAM_INFANTRY';
--直升机
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_FW_VERTOL' FROM Units WHERE Class='UNITCLASS_ATTACK_HELICOPTER';



--现代装甲
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_CARVR' FROM Units WHERE Class='UNITCLASS_MODERN_ARMOR';

--海滨战舰
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALFIGHTER02' FROM Units WHERE Class='UNITCLASS_LITTORAL_COMBAT_SHIP';

--驱逐舰
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALFIGHTER03H' FROM Units WHERE Class='UNITCLASS_MODERN_DESTROYER';
--巡洋舰
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALFIGHTER04S' FROM Units WHERE Class='UNITCLASS_MISSILE_CRUISER';

--超级武库舰
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALFIGHTER03P' FROM Units WHERE Class='UNITCLASS_FUTURE_BATTLESHIP';

--航母
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALCARRIER02' FROM Units WHERE Class='UNITCLASS_SUPER_CARRIER';

--潜艇
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALFIGHTER04P' FROM Units WHERE Class='UNITCLASS_SSBN';



--舰载飞机
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_CARRIER_FIGHTER_FUTURE' FROM Units WHERE Class='UNITCLASS_CARRIER_FIGHTER_ADV';

--战斗机
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_AIRFIGHTER03P' FROM Units WHERE Class='UNITCLASS_JET_FIGHTER';
--歼击机
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_AIRFIGHTER04P' FROM Units WHERE Class='UNITCLASS_STEALTH_ATTACK_AIRCRAFT';
--轰炸机
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_FW_DRONE_FIGHTER_2' FROM Units WHERE Class='UNITCLASS_STEALTH_BOMBER'; 
--导弹
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_SUPER_MISSILE' FROM Units WHERE Class='UNITCLASS_GUIDED_MISSILE';   
----------------------------------------- end-----------------------------------------------------



-- PROMOTIONS
--=====================================================================================================================================================================================		
-- UnitPromotions
--------------------------------	
INSERT INTO UnitPromotions 
			(Type, 						Description, 	                 Help, 		                     Sound, 		CannotBeChosen,		PortraitIndex,		IconAtlas, 	                  PediaEntry,                       PediaType ,    ShowInPedia,  DefenseMod, AttackMod,  SplashDamageImmune,CollateralDamageImmune)
VALUES	    ('PROMOTION_COMBAT_TO_DEATH_0',     'TXT_KEY_PROMOTION_ANGRY',   'TXT_KEY_PROMOTION_ANGRY_HELP',   'AS2D_IF_LEVELUP',		1,					12,			'MORE_NEW_PROMOS_ATLAS', 	 'TXT_KEY_PROMOTION_ANGRY',         'PEDIA_ATTRIBUTES'        ,0 ,0 ,0 ,0  ,   0),
			('PROMOTION_COMBAT_TO_DEATH_1', 	'TXT_KEY_PROMOTION_ANGRY_1', 'TXT_KEY_PROMOTION_ANGRY_1_HELP', 'AS2D_IF_LEVELUP',		1,					12,			'MORE_NEW_PROMOS_ATLAS', 	 'TXT_KEY_PROMOTION_ANGRY',         'PEDIA_ATTRIBUTES'        ,0 ,10 ,5,0  ,   0),
			('PROMOTION_COMBAT_TO_DEATH_2', 	'TXT_KEY_PROMOTION_ANGRY_2', 'TXT_KEY_PROMOTION_ANGRY_2_HELP', 'AS2D_IF_LEVELUP',		1,					12,			'MORE_NEW_PROMOS_ATLAS', 	 'TXT_KEY_PROMOTION_ANGRY',         'PEDIA_ATTRIBUTES'        ,0 ,20 ,10,0  ,   0),
			('PROMOTION_COMBAT_TO_DEATH_3', 	'TXT_KEY_PROMOTION_ANGRY_3', 'TXT_KEY_PROMOTION_ANGRY_3_HELP', 'AS2D_IF_LEVELUP',		1,					12,			'MORE_NEW_PROMOS_ATLAS', 	 'TXT_KEY_PROMOTION_ANGRY',         'PEDIA_ATTRIBUTES'        ,0 ,30 ,15,0  ,   0),
			('PROMOTION_COMBAT_TO_DEATH_4', 	'TXT_KEY_PROMOTION_ANGRY_4', 'TXT_KEY_PROMOTION_ANGRY_4_HELP', 'AS2D_IF_LEVELUP',		1,					12,			'MORE_NEW_PROMOS_ATLAS', 	 'TXT_KEY_PROMOTION_ANGRY',         'PEDIA_ATTRIBUTES'        ,0 ,40 ,20,0  ,   0),
			('PROMOTION_COMBAT_TO_DEATH_5', 	'TXT_KEY_PROMOTION_ANGRY_5', 'TXT_KEY_PROMOTION_ANGRY_5_HELP', 'AS2D_IF_LEVELUP',		1,					12,			'MORE_NEW_PROMOS_ATLAS',     'TXT_KEY_PROMOTION_ANGRY',         'PEDIA_ATTRIBUTES'        ,0 ,50 ,25,1  ,   1);



INSERT INTO UnitPromotions 
			(Type, 													Description, 										Help, 														Sound, 		CannotBeChosen,		PortraitIndex,		IconAtlas, 			 			PediaEntry,  PediaType ,ShowInPedia, CargoChange)
VALUES	    ('PROMOTION_SPACE_BATTLECRUISER_MANA', 	    'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA', 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_HELP',   'AS2D_IF_LEVELUP',		1,					22,			'MainRobotPromo_Atlas', 	 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA',         'PEDIA_ATTRIBUTES'        ,0  ,   10 ),
			('PROMOTION_SPACE_BATTLECRUISER_MANA_1', 	'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_1', 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_1_HELP', 'AS2D_IF_LEVELUP',		1,					22,			'MainRobotPromo_Atlas', 	 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA',         'PEDIA_ATTRIBUTES'        ,0  ,   10 ),
			('PROMOTION_SPACE_BATTLECRUISER_MANA_2', 	'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_2', 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_2_HELP', 'AS2D_IF_LEVELUP',		1,					22,			'MainRobotPromo_Atlas', 	 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA',         'PEDIA_ATTRIBUTES'        ,0  ,   10 ),
			('PROMOTION_SPACE_BATTLECRUISER_MANA_3', 	'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_3', 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_3_HELP', 'AS2D_IF_LEVELUP',		1,					22,			'MainRobotPromo_Atlas', 	 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA',         'PEDIA_ATTRIBUTES'        ,0  ,   10 ),
			('PROMOTION_SPACE_BATTLECRUISER_MANA_4', 	'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_4', 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_4_HELP', 'AS2D_IF_LEVELUP',		1,					22,			'MainRobotPromo_Atlas', 	 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA',         'PEDIA_ATTRIBUTES'        ,0  ,   10 ),
			('PROMOTION_SPACE_BATTLECRUISER_MANA_5', 	'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_5', 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_5_HELP', 'AS2D_IF_LEVELUP',		1,					22,			'MainRobotPromo_Atlas',      'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA',         'PEDIA_ATTRIBUTES'        ,0  ,   10 ),
			('PROMOTION_SPACE_BATTLECRUISER_MANA_6', 	'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_6', 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_6_HELP', 'AS2D_IF_LEVELUP',		1,					22,			'MainRobotPromo_Atlas', 	 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA',         'PEDIA_ATTRIBUTES'        ,0  ,   10 ),
			('PROMOTION_SPACE_BATTLECRUISER_MANA_7', 	'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_7', 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_7_HELP', 'AS2D_IF_LEVELUP',		1,					22,			'MainRobotPromo_Atlas', 	 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA',         'PEDIA_ATTRIBUTES'        ,0  ,   10 ),
			('PROMOTION_SPACE_BATTLECRUISER_MANA_8', 	'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_8', 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_8_HELP', 'AS2D_IF_LEVELUP',		1,					22,			'MainRobotPromo_Atlas', 	 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA',         'PEDIA_ATTRIBUTES'        ,0  ,   10 );


-- HP MOD
--------------------------------	
INSERT OR IGNORE INTO UnitPromotions(Type, Description, Help, Sound, CannotBeChosen, ExtraAttacks, CanMoveAfterAttacking, MaxHitPointsChange, MovesChange, OrderPriority, PortraitIndex, IconAtlas, PediaType, PediaEntry,NeutralDamage,EnemyDamage,EnemyDamageChance,NeutralDamageChance) 
VALUES('PROMOTION_HPMOD1', 'TXT_KEY_PROMOTION_HPMOD1', 'TXT_KEY_PROMOTION_HPMOD1_HELP', 'AS2D_IF_LEVELUP', 1, 0, 1, 200, 1, 11, 4, 'MainRobotPromo_Atlas', 'PEDIA_ATTRIBUTES', 'TXT_KEY_PROMOTION_HPMOD1', 0, 0,0,0),
('PROMOTION_HPMOD2', 'TXT_KEY_PROMOTION_HPMOD2', 'TXT_KEY_PROMOTION_HPMOD2_HELP', 'AS2D_IF_LEVELUP', 1, 1, 1, 200, 1, 11, 4, 'MainRobotPromo_Atlas', 'PEDIA_ATTRIBUTES', 'TXT_KEY_PROMOTION_HPMOD2', -50, -50,100,100),
('PROMOTION_HPMOD3', 'TXT_KEY_PROMOTION_HPMOD3', 'TXT_KEY_PROMOTION_HPMOD3_HELP', 'AS2D_IF_LEVELUP', 1, 0, 1, 300, 1, 11, 4, 'MainRobotPromo_Atlas', 'PEDIA_ATTRIBUTES', 'TXT_KEY_PROMOTION_HPMOD3', 0, 0,0,0);




-- 冰冻弹
insert into PromotionCollections(Type) values ('PROMOTION_COLLECTION_FREEZE_BOMB');
insert into PromotionCollections_Entries(CollectionType, PromotionIndex, PromotionType,  TriggerMeleeAttack,TriggerRangedAttack, TriggerHPFixed, TriggerLuaHook) values
('PROMOTION_COLLECTION_FREEZE_BOMB', 1, 'PROMOTION_FREEZE_BOMB', 1,1, 10000, 1);


insert into PromotionCollections(Type) values ('PROMOTION_COLLECTION_FREEZE_EFFECT');
insert into PromotionCollections_Entries(CollectionType, PromotionIndex, PromotionType) values
('PROMOTION_COLLECTION_FREEZE_EFFECT', 1, 'PROMOTION_FREEZE_EFFECT');

insert into PromotionCollections_AddEnemyPromotions(CollectionType, OtherCollectionType) values
('PROMOTION_COLLECTION_FREEZE_BOMB', 'PROMOTION_COLLECTION_FREEZE_EFFECT');



---乌尔班
INSERT INTO BuildingClassCollections(Type)
SELECT 'COLLECTIONS_WUBAN_CANNON';

INSERT INTO BuildingClassCollections_Entries(CollectionType,BuildingClassIndex,BuildingClassType)
SELECT 'COLLECTIONS_WUBAN_CANNON', 1,   'BUILDINGCLASS_BARRACKS' UNION ALL
SELECT 'COLLECTIONS_WUBAN_CANNON', 2,   'BUILDINGCLASS_ARMORY' UNION ALL
SELECT 'COLLECTIONS_WUBAN_CANNON', 3,   'BUILDINGCLASS_PALISADE' UNION ALL
SELECT 'COLLECTIONS_WUBAN_CANNON', 4,   'BUILDINGCLASS_WALLS' UNION ALL
SELECT 'COLLECTIONS_WUBAN_CANNON', 5,   'BUILDINGCLASS_WATCH' UNION ALL
SELECT 'COLLECTIONS_WUBAN_CANNON', 6,   'BUILDINGCLASS_CASTLE';


---sp兼容修改
UPDATE BuildingClassCollections_Entries SET BuildingClassIndex = BuildingClassIndex + 4  WHERE CollectionType = 'COLLECTIONS_AIR_SIEGE';

INSERT INTO BuildingClassCollections_Entries(CollectionType,BuildingClassIndex,BuildingClassType)
SELECT 'COLLECTIONS_AIR_SIEGE', 1,   'BUILDINGCLASS_MATRIX' UNION ALL
SELECT 'COLLECTIONS_AIR_SIEGE', 2,   'BUILDINGCLASS_ZXZCC' UNION ALL
SELECT 'COLLECTIONS_AIR_SIEGE', 3,   'BUILDINGCLASS_NAVAL_BASE' UNION ALL
SELECT 'COLLECTIONS_AIR_SIEGE', 4,   'BUILDINGCLASS_MILITARY_AIRBASE' ;

insert into LuaFormula(Type, Formula) values
('FORMULA_HEAL_PERCENT_ON_ATTACK_DAMAGE', 'local iAttackDamage, iMaxHitPoints, bEmenyDeath = ... if iAttackDamage >= 0 then return (iMaxHitPoints * 20 /100) else return 0 end');