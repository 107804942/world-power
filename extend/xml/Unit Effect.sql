---Զ�̼л�
UPDATE UnitPromotions SET RangedFlankAttackModifier = '10' WHERE Type  = 'PROMOTION_ARCHERY_COMBAT'OR Type= 'PROMOTION_NAVAL_RANGED_CRUISER'OR Type= 'PROMOTION_NAVAL_RANGED_SHIP';

---�������߷�²
INSERT  INTO Unit_FreePromotions(UnitType ,PromotionType)
SELECT  Type, 'PROMOTION_NO_CAPTURED' FROM Units WHERE HurryCostModifier = -1 AND Combat>=500;


---����Эͬ
INSERT  INTO UnitPromotions_CombatModPerAdjacentUnitCombat(PromotionType,UnitCombatType ,Modifier,Attack,Defense)
VALUES ('PROMOTION_ANTI_ANTI_MOUNTED_BONUS','UNITCOMBAT_MELEE',8,0,0);



INSERT INTO UnitCombatInfos (Type,	Description)VALUES		
    ('UNITCOMBAT_SETTLER',	'TXT_KEY_UNITCOMBAT_SETTLER'),
	('UNITCOMBAT_WORKER',	'TXT_KEY_UNITCOMBAT_WORKER');

UPDATE Units SET CombatClass = 'UNITCOMBAT_SETTLER' WHERE Class  = 'UNITCLASS_SETTLER';
UPDATE Units SET CombatClass = 'UNITCOMBAT_WORKER' WHERE Class = 'UNITCLASS_WORKER';


---���½���ս������Ƽ�
UPDATE Units SET PrereqTech = 'TECH_CARTOGRAPHY' ,ObsoleteTech = 'TECH_NAUTICAL_SCIENCE' WHERE Class  = 'UNITCLASS_GREAT_GALLEASS';


-----�Ƽ�����ս����
UPDATE Units SET UnitTechUpgrade = 1  WHERE Type= 'UNIT_UNDERWATER_CARRIER'OR Type= 'UNIT_CRUSADER_ARTILLERY'OR Type= 'UNIT_CHINESE_WEISHI' OR Type= 'UNIT_TASKFORCE_141'OR Type= 'UNIT_STEALTH_HELICOPTER' OR Type= 'UNIT_PAKFA_T50';


INSERT INTO Unit_TechCombatStrength (UnitType, 	TechType,	CombatStrength) VALUES
('UNIT_UNDERWATER_CARRIER',		'TECH_CYBERNETICS', 550),
('UNIT_CRUSADER_ARTILLERY',		'TECH_MECHANICAL_ENGINEERING',320),
('UNIT_CHINESE_WEISHI',		'TECH_HOMO_SUPERIOR', 90),	
('UNIT_TASKFORCE_141',		'TECH_GRID_COMPUTING',200),	 
('UNIT_STEALTH_HELICOPTER',		'TECH_ORBITAL_SUSPENSION',250), 		
('UNIT_MECH',		'TECH_NEURAL_INTERFACE', 1500);

INSERT INTO Unit_TechRangedCombatStrength (UnitType, TechType,	RangedCombatStrength)VALUES	
('UNIT_UNDERWATER_CARRIER',		'TECH_CYBERNETICS', 450),	
('UNIT_CRUSADER_ARTILLERY',		'TECH_MECHANICAL_ENGINEERING', 320),	
('UNIT_CHINESE_WEISHI',		'TECH_HOMO_SUPERIOR',450),
('UNIT_PAKFA_T50',		'TECH_SPACE_COLONIZATION',500),	
('UNIT_STEALTH_HELICOPTER',		'TECH_ORBITAL_SUSPENSION',250),	
('UNIT_MECH',		'TECH_NEURAL_INTERFACE', 1500);


---������ӳ�
INSERT  INTO UnitPromotions_Domains(PromotionType,DomainType,Defense)
VALUES('PROMOTION_PARATROOPER_BUFF', 'DOMAIN_AIR',50);



---����������λ����
INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_CAUSEWAY', Type FROM UnitCombatInfos WHERE ID >= 0;

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT  'PROMOTION_EXPLOSIVE_MIXTURE', Type FROM Units WHERE RangedCombat > 0;

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT  'PROMOTION_BERMUDA', Type FROM Units WHERE Domain= 'DOMAIN_SEA';

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
SELECT  'PROMOTION_SKYNET_LINK', Type FROM UnitCombatInfos;

INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_DIABLO', Type FROM UnitCombatInfos;

INSERT  INTO UnitPromotions_UnitCombats(PromotionType,UnitCombatType)
SELECT  'PROMOTION_GOLDEN_BUFF', Type FROM UnitCombatInfos;
------------------------------------------------------------------------------------------------------------------------
-- ��λս����ͼ
------------------------------------------------------------------------------------------------------------------------
UPDATE SPTriggerControler SET Enabled = 1 WHERE TriggerType = 'SPNDeleteALLUnitStrategicFlag';
UPDATE SPNewEffectControler SET Enabled = 1 WHERE Type = 'SP_DELETE_ALL_STRATEGIC_UNIT_FLAG';

UPDATE SPTriggerControler SET Enabled = 1 WHERE TriggerType = 'Minor_Building_Overrides_Trigger';


---����ͺ����Ͻ����߽���
--INSERT  INTO Unit_FreePromotions(UnitType,PromotionType)
--SELECT  Type, 'PROMOTION_ANTI_SPLASH' FROM Units WHERE Class= 'UNITCLASS_GREAT_GENERAL'OR Class= 'UNITCLASS_GREAT_ADMIRAL';



------------------------------------------------------------------------------------------------------------------------
-- �Ƽ�������ѽ���������λ����
------------------------------------------------------------------------------------------------------------------------



INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT  'PROMOTION_NAVAL_SIGHT', Type  FROM Units WHERE Domain ='DOMAIN_SEA';

------���ֽ���
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
SELECT 'PROMOTION_SMETAL', Type  FROM Units WHERE Class ='UNITCLASS_HOVERTANK';

------���䴩͸

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_EQUICK', Type  FROM Units WHERE Class ='UNITCLASS_SUPER_ROCKET';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_EQUICK', Type  FROM Units WHERE Class ='UNITCLASS_ROCKET_ARTILLERY';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_EQUICK', Type  FROM Units WHERE Class ='UNITCLASS_CHINESE_WEISHI';







---��������
INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_ANTIAIRX', Type  FROM Units WHERE Class ='UNITCLASS_MODERN_DESTROYER';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_ANTIAIRX', Type  FROM Units WHERE Class ='UNITCLASS_NAVALFIGHTER03H';


---��ը������
INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_AERIAL_REFUELING', Type  FROM Units WHERE Class ='UNITCLASS_STEALTH_BOMBER';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_AERIAL_REFUELING', Type  FROM Units WHERE Class ='UNITCLASS_DRONE_FIGHTER';


---�߻���
INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_FIGHTER_ATTACK', Type  FROM Units WHERE Class ='UNITCLASS_AIRFIGHTER04P';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_FIGHTER_ATTACK', Type  FROM Units WHERE Class ='UNITCLASS_CARRIER_FIGHTER_FUTURE';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_FIGHTER_ATTACK', Type  FROM Units WHERE Class ='UNITCLASS_STEALTH_ATTACK_AIRCRAFT';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_FIGHTER_ATTACK', Type  FROM Units WHERE Class ='UNITCLASS_CARRIER_FIGHTER_ADV';


---����
INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_HPMOD1', Type  FROM Units WHERE Class ='UNITCLASS_MECH';


INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_CAN_RANGE_ATTACK', Type  FROM Units WHERE Class ='UNITCLASS_MECH';



---����⻷��ǿ
INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_GENERAL_1', Type  FROM Units WHERE Class ='UNITCLASS_GREAT_GENERAL';

INSERT  INTO UnitPromotions_UnitType(PromotionType,UnitType)
SELECT 'PROMOTION_PEOPLES_HALL', Type  FROM Units WHERE Class ='UNITCLASS_GREAT_GENERAL';


---������ǿ
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
-- ����ϵ
------------------------------------------------------------------------------------------------------------------------
UPDATE UnitPromotions SET ExtraAttacks=1,ExtraWithdrawal=50,AttackFullyHealedMod=50 WHERE Type='PROMOTION_HELI_ATTACK';
UPDATE UnitPromotions SET ExtraAttacks=1,ExtraWithdrawal=50,AttackFullyHealedMod=50 WHERE Type='PROMOTION_HITANDRUN';
------------------------------------------------------------------------------------------------------------------------
-- ȫ��ò�����ӳ�
------------------------------------------------------------------------------------------------------------------------
INSERT  INTO UnitPromotions_Features(PromotionType,FeatureType,Defense)
SELECT  'PROMOTION_GHOST_POWER', Type, 100  FROM Features WHERE ID !=-1;

INSERT  INTO UnitPromotions_Features(PromotionType,FeatureType,Attack)
SELECT  'PROMOTION_GHOST_POWER', Type, 100  FROM Features WHERE ID !=-1;






-----ɾ���߻�����ʼ����ӳ�
DELETE FROM UnitPromotions_UnitCombatMods WHERE PromotionType = 'PROMOTION_AIR_ATTACK' AND UnitCombatType = 'UNITCOMBAT_MOUNTED';
DELETE FROM UnitPromotions_UnitCombatMods WHERE PromotionType = 'PROMOTION_AIR_ATTACK' AND UnitCombatType = 'UNITCOMBAT_ARMOR';

DELETE FROM UnitPromotions_Domains WHERE PromotionType = 'PROMOTION_AIR_ATTACK' AND DomainType = 'DOMAIN_LAND';
DELETE FROM UnitPromotions_Domains WHERE PromotionType = 'PROMOTION_AIR_ATTACK' AND DomainType = 'DOMAIN_SEA';

DELETE FROM UnitPromotions_Domains WHERE PromotionType = 'PROMOTION_CARRIER_FIGHTER' AND DomainType = 'DOMAIN_LAND';
DELETE FROM UnitPromotions_Domains WHERE PromotionType = 'PROMOTION_CARRIER_FIGHTER' AND DomainType = 'DOMAIN_SEA';



-----ɾ�������Դ���25%������������
--DELETE FROM Unit_FreePromotions WHERE PromotionType = 'PROMOTION_SP_ATTACK25' AND UnitType = 'UNIT_JAPANESE_BATTLESHIP';



 ---ΰ��һ���Բ�������
 UPDATE Units SET BaseBeakersTurnsToCount=2 WHERE Class='UNITCLASS_SCIENTIST';
 UPDATE Units SET BaseCultureTurnsToCount=3 WHERE Class='UNITCLASS_WRITER';
 UPDATE Units SET OneShotTourism=7 WHERE Class='UNITCLASS_MUSICIAN';
 UPDATE Units SET BaseHurry=3000 ,HurryMultiplier=50 WHERE Class='UNITCLASS_ENGINEER';

------------------------------------------------------------------------------------------------------------------------
-- ̩̹ս�����ִ�������������
------------------------------------------------------------------------------------------------------------------------
UPDATE UnitPromotions SET NearbyUnitPromotionBonus=100,NearbyUnitPromotionBonusRange=6,CombatBonusFromNearbyUnitPromotion= 'PROMOTION_WEAPON_SHIP' WHERE Type='PROMOTION_DESTROYER_COMBAT' OR Type='PROMOTION_NAVAL_RANGED_CRUISER' OR Type='PROMOTION_SUBMARINE_COMBAT' OR Type='PROMOTION_NAVAL_CAPITAL_SHIP';

UPDATE UnitPromotions SET NearbyUnitPromotionBonus=100,NearbyUnitPromotionBonusRange=3,CombatBonusFromNearbyUnitPromotion= 'PROMOTION_GOLEM' WHERE Type='PROMOTION_ROBORT_COMBAT' OR Type='PROMOTION_HEAVY_ROBORT';

---Ͷʯ��
--INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Attack)
--SELECT  'PROMOTION_BLIALI', Type,DefenseMod FROM UnitPromotions WHERE DefenseMod != 0;

--INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Attack)
--SELECT  'PROMOTION_BLIALI', Type,RangedDefenseMod FROM UnitPromotions WHERE RangedDefenseMod != 0;


---�����Ի�����
INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Modifier)
VALUES ('PROMOTION_SKYNET_LINK','PROMOTION_ROBORT_COMBAT',25);

---���ͻ��׶Ի�����
INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Modifier)
VALUES ('PROMOTION_HEAVY_ROBORT','PROMOTION_ROBORT_COMBAT',25);

---ͻ�����Ա���
INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Modifier)
VALUES ('PROMOTION_STURMTIGER','PROMOTION_CITADEL_DEFENSE',200);


---ȼ�յ��Ա�����
INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Attack)
VALUES ('PROMOTION_BURNING_BOMB','PROMOTION_FREEZE_EFFECT',150);


---ȼ�յ�
INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Attack)
VALUES ('PROMOTION_FIRE_WEAPON','PROMOTION_BURNING_EFFECT',50);

---���������Ա���
INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Attack)
VALUES ('PROMOTION_FOCUS','PROMOTION_CITADEL_DEFENSE',300);




---����ͼ�Լ����ݶԷ��������װ�׼ӳ�
INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Modifier)
VALUES ('PROMOTION_COMBAT_TO_DEATH','PROMOTION_ANTI_MOUNTED',100),
       ('PROMOTION_COMBAT_TO_DEATH','PROMOTION_ANTI_TANK',100),
       ('PROMOTION_ANTI_ANTI_MOUNTED_BONUS','PROMOTION_ANTI_MOUNTED',33),
       ('PROMOTION_ANTI_ANTI_MOUNTED_BONUS','PROMOTION_ANTI_TANK',33);
------------------------------------------------------------------------------------------------------------------------
-- �����������
UPDATE UnitClasses SET MaxPlayerInstances=5 WHERE Type='UNITCLASS_WARRIOR';
UPDATE UnitClasses SET MaxPlayerInstances=5 WHERE Type='UNITCLASS_MILITIA_ANCIENT';
UPDATE UnitClasses SET MaxPlayerInstances=5 WHERE Type='UNITCLASS_MINUTEMAN';
UPDATE UnitClasses SET MaxPlayerInstances=5 WHERE Type='UNITCLASS_CONSCRIPTMAN';
UPDATE UnitClasses SET MaxPlayerInstances=5 WHERE Type='UNITCLASS_MILITIA_MODERN';

-- ���йص�λ���ͼ���ľ����Դ����

--���Ϲ�
INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost )
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_COMPOSITE_BOWMAN';

CREATE TRIGGER CostForBowMan
AFTER INSERT ON Units
WHEN 'UNITCLASS_COMPOSITE_BOWMAN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;


 --���
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost )
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_CROSSBOWMAN';

 CREATE TRIGGER CostForCrossBowMan
AFTER INSERT ON Units
WHEN 'UNITCLASS_CROSSBOWMAN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;


 --��Ӣ������
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost )
 SELECT Type, 'RESOURCE_LUMBER',2 FROM Units WHERE Class='UNITCLASS_LONGBOWMAN';

  --Ͷʯ��
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_CATAPULT';

 CREATE TRIGGER CostForCATAPULT
AFTER INSERT ON Units
WHEN 'UNITCLASS_CATAPULT'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;

 --��ʯ��
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost )
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_TREBUCHET';

CREATE TRIGGER CostForTREBUCHET
AFTER INSERT ON Units
WHEN 'UNITCLASS_TREBUCHET'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;



--����ս��
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_TRIREME';

CREATE TRIGGER CostForTRIREME
AFTER INSERT ON Units
WHEN 'UNITCLASS_TRIREME'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;

 --����ս��
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_GALLEASS';

CREATE TRIGGER CostForGALLEASS
AFTER INSERT ON Units
WHEN 'UNITCLASS_GALLEASS'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;


--������ս��
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_GREAT_GALLEASS';

 CREATE TRIGGER CostForGREATGALLEASS
AFTER INSERT ON Units
WHEN 'UNITCLASS_GREAT_GALLEASS'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;



--Ѳ����
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',2  FROM Units WHERE Class='UNITCLASS_FRIGATE';

CREATE TRIGGER CostForFRIGATE
AFTER INSERT ON Units
WHEN 'UNITCLASS_FRIGATE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',2);
END;


   --���
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_FIRE_SHIP';

 CREATE TRIGGER CostForFIRESHIP
AFTER INSERT ON Units
WHEN 'UNITCLASS_FIRE_SHIP'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;

    --����ս��
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_SLOOP_OF_WAR';

 CREATE TRIGGER CostForSLOOPOFWAR
AFTER INSERT ON Units
WHEN 'UNITCLASS_SLOOP_OF_WAR'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;

    --����
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost )
 SELECT Type, 'RESOURCE_LUMBER',2 FROM Units WHERE Class='UNITCLASS_ZHENGHE_FLEET';

     --�ᷫ��
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',1 FROM Units WHERE Class='UNITCLASS_CARAVEL';

  CREATE TRIGGER CostForCARAVEL
AFTER INSERT ON Units
WHEN 'UNITCLASS_CARAVEL'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',1);
END;


     --�緫������
 INSERT  INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
 SELECT Type, 'RESOURCE_LUMBER',2 FROM Units WHERE Class='UNITCLASS_SHIP_OF_THE_LINE';

CREATE TRIGGER CostForSHIPOFTHELINE
AFTER INSERT ON Units
WHEN 'UNITCLASS_SHIP_OF_THE_LINE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_LUMBER',2);
END;

 -------------------------------------��ҩ------------------------------------
  --���ٱ�
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CONSCRIPTMAN';

CREATE TRIGGER CostForCONSCRIPTMAN
AFTER INSERT ON Units
WHEN 'UNITCLASS_CONSCRIPTMAN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

 --�ִ����
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MILITIA_MODERN';

CREATE TRIGGER CostForMILITIAMODERN
AFTER INSERT ON Units
WHEN 'UNITCLASS_MILITIA_MODERN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

 --��ǹ��
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MUSKETMAN';

CREATE TRIGGER CostForMUSKETMAN
AFTER INSERT ON Units
WHEN 'UNITCLASS_MUSKETMAN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


--ѩ������
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MUSKETEER';
--����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_RIFLEMAN';

CREATE TRIGGER CostForRIFLEMAN
AFTER INSERT ON Units
WHEN 'UNITCLASS_RIFLEMAN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--һս����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_GREAT_WAR_INFANTRY';

CREATE TRIGGER CostForGREATWARINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_GREAT_WAR_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


--�ִ�����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_INFANTRY';

CREATE TRIGGER CostForINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--�⼮����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_FOREIGNLEGION';
--Ħ�л�����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MOTORISED_INFANTRY';

CREATE TRIGGER CostForMOTORISEDINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_MOTORISED_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--��е������
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MECHANIZED_INFANTRY';


CREATE TRIGGER CostForMECHANIZEDINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_MECHANIZED_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


 --ɡ��
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_WWI_PARATROOPER';

CREATE TRIGGER CostForWWIPARATROOPER
AFTER INSERT ON Units
WHEN 'UNITCLASS_WWI_PARATROOPER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

 --½ս��
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MARINE';

CREATE TRIGGER CostForMARINE
AFTER INSERT ON Units
WHEN 'UNITCLASS_MARINE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

 --�ս���
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_PARATROOPER';

CREATE TRIGGER CostForPARATROOPER
AFTER INSERT ON Units
WHEN 'UNITCLASS_PARATROOPER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


 --��Ӣ�����
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_ELITE_SNIPER';


 --141
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_TASKFORCE_141';




 --�ؼ����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_BOMBARD';

CREATE TRIGGER CostForBOMBARD
AFTER INSERT ON Units
WHEN 'UNITCLASS_BOMBARD'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;




 --һսս��
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_WWI_TANK';

CREATE TRIGGER CostForWWITANK
AFTER INSERT ON Units
WHEN 'UNITCLASS_WWI_TANK'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


 --ս��
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_TANK';

CREATE TRIGGER CostForTANK
AFTER INSERT ON Units
WHEN 'UNITCLASS_TANK'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

 --��վ̹��
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MAIN_BATTLE_TANK';

CREATE TRIGGER CostForMAINBATTLETANK
AFTER INSERT ON Units
WHEN 'UNITCLASS_MAIN_BATTLE_TANK'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

 --�ִ�װ��
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MODERN_ARMOR';

CREATE TRIGGER CostForMODERNARMOR
AFTER INSERT ON Units
WHEN 'UNITCLASS_MODERN_ARMOR'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;



 --½�����׽�
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',3 FROM Units WHERE Class='UNITCLASS_LAND_IRONCLAD';



 --���������
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_COSSACK_MILITIA';

CREATE TRIGGER CostForCOSSACKMILITIA
AFTER INSERT ON Units
WHEN 'UNITCLASS_COSSACK_MILITIA'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


 --��ʽ̹��
 INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_SUPER_TANK';






 --�ŷ�ǹ
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_VOLLEY_GUN';


CREATE TRIGGER CostForVOLLEYGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_VOLLEY_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


 --�����ֻ�ǹ
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_GATLINGGUN';

CREATE TRIGGER CostForGATLINGGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_GATLINGGUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;



 --����ǹ
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MACHINE_GUN';


CREATE TRIGGER CostForMACHINEGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_MACHINE_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;



 --����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_ANTI_AIRCRAFT_GUN';


CREATE TRIGGER CostForANTIAIRCRAFT_GUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_ANTI_AIRCRAFT_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;



 --������
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_MOBILE_AA_GUN';


CREATE TRIGGER CostForMOBILEAAGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_MOBILE_AA_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;



 --�������ճ�
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_SAM_INFANTRY';


CREATE TRIGGER CostForSAMINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_SAM_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--��������
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',3 FROM Units WHERE Class='UNITCLASS_SUPER_HOWITZER';
--ʮ�־�����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_CRUSADER_ARTILLERY';
--�˻���
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_NUCLEAR_ARTILLERY';


--�����ԭ��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_PROTOTYPE_HWACHA';


  --����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CULVERIN';

CREATE TRIGGER CostForCULVERIN
AFTER INSERT ON Units
WHEN 'UNITCLASS_CULVERIN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


 --��ũ��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CANNON';


CREATE TRIGGER CostForCANNON
AFTER INSERT ON Units
WHEN 'UNITCLASS_CANNON'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

  --����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_HOWITZER';

CREATE TRIGGER CostForHOWITZER
AFTER INSERT ON Units
WHEN 'UNITCLASS_HOWITZER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

 --����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_ARTILLERY';

CREATE TRIGGER CostForARTILLERY
AFTER INSERT ON Units
WHEN 'UNITCLASS_ARTILLERY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


 --������
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_SELF_PROPELLED_ARTILLERY';

CREATE TRIGGER CostForSELFPROPELLEDARTILLERY
AFTER INSERT ON Units
WHEN 'UNITCLASS_SELF_PROPELLED_ARTILLERY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;






--������
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_RAILROAD_GUN';

CREATE TRIGGER CostForRAILROADGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_RAILROAD_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--�����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_KATYUSHA';

CREATE TRIGGER CostForKATYUSHA
AFTER INSERT ON Units
WHEN 'UNITCLASS_KATYUSHA'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


--���л����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_ROCKET_ARTILLERY';


CREATE TRIGGER CostForROCKETARTILLERY
AFTER INSERT ON Units
WHEN 'UNITCLASS_ROCKET_ARTILLERY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',2);
END;

--���
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CAVALRY';

CREATE TRIGGER CostForCAVALRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_CAVALRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;



--Ѳ��̹��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CRUISER_TANK';

CREATE TRIGGER CostForCRUISERTANK
AFTER INSERT ON Units
WHEN 'UNITCLASS_CRUISER_TANK'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--ֱ����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_HELICOPTER_GUNSHIP';

CREATE TRIGGER CostForHELICOPTERGUNSHIP
AFTER INSERT ON Units
WHEN 'UNITCLASS_HELICOPTER_GUNSHIP'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


--��װֱ����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_ATTACK_HELICOPTER';

CREATE TRIGGER CostForATTACKHELICOPTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_ATTACK_HELICOPTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;



--����ֱ����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_STEALTH_HELICOPTER';

--��ʿ�����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',3 FROM Units WHERE Class='UNITCLASS_CHINESE_WEISHI';


--��̹����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_ANTI_TANK_GUN';


CREATE TRIGGER CostForANTITANKGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_ANTI_TANK_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--̹�˼߻���
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_TANK_DESTROYER';




CREATE TRIGGER CostForTANKDESTROYER
AFTER INSERT ON Units
WHEN 'UNITCLASS_TANK_DESTROYER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


--��̹�˵���
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_ATGM_VEHICLE';

CREATE TRIGGER CostForATGMVEHICLE
AFTER INSERT ON Units
WHEN 'UNITCLASS_ATGM_VEHICLE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;






--�������׽�
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_LIGHT_IRONCLAD';

CREATE TRIGGER CostForLIGHTIRONCLAD
AFTER INSERT ON Units
WHEN 'UNITCLASS_LIGHT_IRONCLAD'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--Ǳͧ
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_SUBMARINE';

CREATE TRIGGER CostForSUBMARINE
AFTER INSERT ON Units
WHEN 'UNITCLASS_SUBMARINE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--������
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_PROTOTYPE_SUBMARINE';
--��Ǳͧ
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_NUCLEAR_SUBMARINE';

CREATE TRIGGER CostForNUCLEARSUBMARINE
AFTER INSERT ON Units
WHEN 'UNITCLASS_NUCLEAR_SUBMARINE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--��ͷ��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_UNDERWATER_CARRIER';



--��η��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_DREADNOUGHT';

CREATE TRIGGER CostForDREADNOUGHT
AFTER INSERT ON Units
WHEN 'UNITCLASS_DREADNOUGHT'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',2);
END;
--ս�н�
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_BATTLESHIP';

CREATE TRIGGER CostForBATTLESHIP
AFTER INSERT ON Units
WHEN 'UNITCLASS_BATTLESHIP'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',2);
END;
--��⽢
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',3 FROM Units WHERE Class='UNITCLASS_FUTURE_BATTLESHIP';

CREATE TRIGGER CostForFUTUREBATTLESHIP
AFTER INSERT ON Units
WHEN 'UNITCLASS_FUTURE_BATTLESHIP'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',3);
END;
--��ͺ�
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',4 FROM Units WHERE Class='UNITCLASS_ELITE_BATTLECRUISER';
--��˹���
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',3 FROM Units WHERE Class='UNITCLASS_SUPER_BATTLESHIP';




--���׽�
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_IRONCLAD';

CREATE TRIGGER CostForIRONCLAD
AFTER INSERT ON Units
WHEN 'UNITCLASS_IRONCLAD'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_DESTROYER';

CREATE TRIGGER CostForDESTROYER
AFTER INSERT ON Units
WHEN 'UNITCLASS_DESTROYER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--�ִ�����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_MODERN_DESTROYER';

CREATE TRIGGER CostForMODERNDESTROYER
AFTER INSERT ON Units
WHEN 'UNITCLASS_MODERN_DESTROYER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',2);
END;





--װ��Ѳ��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_PROTECTED_CRUISER';

CREATE TRIGGER CostForPROTECTEDCRUISER
AFTER INSERT ON Units
WHEN 'UNITCLASS_PROTECTED_CRUISER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--����Ѳ��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_HEAVY_CRUISER';

CREATE TRIGGER CostForHEAVYCRUISER
AFTER INSERT ON Units
WHEN 'UNITCLASS_HEAVY_CRUISER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;


--����Ѳ��
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




--�����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_TRIPLANE';

CREATE TRIGGER CostForTRIPLANE
AFTER INSERT ON Units
WHEN 'UNITCLASS_TRIPLANE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--ս��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_FIGHTER';

CREATE TRIGGER CostForFIGHTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_FIGHTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--����ս��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_INTERCEPTER';


CREATE TRIGGER CostForINTERCEPTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_INTERCEPTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--����ս��
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





--һս��ը��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_WWI_BOMBER';

CREATE TRIGGER CostForWWIBOMBER
AFTER INSERT ON Units
WHEN 'UNITCLASS_WWI_BOMBER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--�����ը��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_DIVE_BOMBER';

CREATE TRIGGER CostForDIVEBOMBER
AFTER INSERT ON Units
WHEN 'UNITCLASS_DIVE_BOMBER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--ǿ����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_ATTACK_AIRCRAFT';

CREATE TRIGGER CostForATTACKAIRCRAFT
AFTER INSERT ON Units
WHEN 'UNITCLASS_ATTACK_AIRCRAFT'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;
--���μ߻���
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_STEALTH_ATTACK_AIRCRAFT';

CREATE TRIGGER CostForSTEALTHATTACKAIRCRAFT
AFTER INSERT ON Units
WHEN 'UNITCLASS_STEALTH_ATTACK_AIRCRAFT'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',2);
END;




--һս���ػ�
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CARRIER_FIGHTER_WWII';

CREATE TRIGGER CostForCARRIERFIGHTERWWII
AFTER INSERT ON Units
WHEN 'UNITCLASS_CARRIER_FIGHTER_WWII'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--����ʽ���ػ�
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CARRIER_FIGHTER_JET';

CREATE TRIGGER CostForCARRIERFIGHTERJET
AFTER INSERT ON Units
WHEN 'UNITCLASS_CARRIER_FIGHTER_JET'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;

--�߼����ػ�
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',1 FROM Units WHERE Class='UNITCLASS_CARRIER_FIGHTER_ADV';

CREATE TRIGGER CostForCARRIERFIGHTERADV
AFTER INSERT ON Units
WHEN 'UNITCLASS_CARRIER_FIGHTER_ADV'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',1);
END;







--�����ԭ��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_PROTOTYPE_BOMBER';

--ս�Ժ�ը��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',2 FROM Units WHERE Class='UNITCLASS_BOMBER';

CREATE TRIGGER CostForBOMBER
AFTER INSERT ON Units
WHEN 'UNITCLASS_BOMBER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',2);
END;

--����ʽ��ը��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',3 FROM Units WHERE Class='UNITCLASS_JET_BOMBER';

CREATE TRIGGER CostForJETBOMBER
AFTER INSERT ON Units
WHEN 'UNITCLASS_JET_BOMBER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',3);
END;

--���κ�ը��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_GUNPOWDER',4 FROM Units WHERE Class='UNITCLASS_STEALTH_BOMBER';

CREATE TRIGGER CostForSTEALTHBOMBER
AFTER INSERT ON Units
WHEN 'UNITCLASS_STEALTH_BOMBER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_GUNPOWDER',4);
END;




----------------------------------------ʯ��------------------------------------
--������
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_CORVETTE';

CREATE TRIGGER CostForOilCORVETTE
AFTER INSERT ON Units
WHEN 'UNITCLASS_CORVETTE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;


 --����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_DESTROYER';

CREATE TRIGGER CostForOilDESTROYER
AFTER INSERT ON Units
WHEN 'UNITCLASS_DESTROYER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
 --�ִ�����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',3 FROM Units WHERE Class='UNITCLASS_MODERN_DESTROYER';

CREATE TRIGGER CostForOilMODERNDESTROYER
AFTER INSERT ON Units
WHEN 'UNITCLASS_MODERN_DESTROYER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',3);
END;
 --����Ѳ��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',4 FROM Units WHERE Class='UNITCLASS_MISSILE_CRUISER';


CREATE TRIGGER CostForOilMISSILECRUISER
AFTER INSERT ON Units
WHEN 'UNITCLASS_MISSILE_CRUISER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',4);
END;
 --��⽢
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',5 FROM Units WHERE Class='UNITCLASS_FUTURE_BATTLESHIP';

CREATE TRIGGER CostForOilFUTUREBATTLESHIP
AFTER INSERT ON Units
WHEN 'UNITCLASS_FUTURE_BATTLESHIP'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',5);
END;

 --Ħ�л�����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_MOTORISED_INFANTRY';


CREATE TRIGGER CostForOilMOTORISEDINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_MOTORISED_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--��е������
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_MECHANIZED_INFANTRY';

CREATE TRIGGER CostForOilMECHANIZEDINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_MECHANIZED_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;

 --ֱ����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_HELICOPTER_GUNSHIP';

CREATE TRIGGER CostForOilHELICOPTERGUNSHIP
AFTER INSERT ON Units
WHEN 'UNITCLASS_HELICOPTER_GUNSHIP'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
 --��װֱ����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_ATTACK_HELICOPTER';

CREATE TRIGGER CostForOilATTACKHELICOPTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_ATTACK_HELICOPTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--��̹�˳�
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_TANK_DESTROYER';

CREATE TRIGGER CostForOilTANKDESTROYER
AFTER INSERT ON Units
WHEN 'UNITCLASS_TANK_DESTROYER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--��̹�˵���
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_ATGM_VEHICLE';

CREATE TRIGGER CostForOilATGMVEHICLE
AFTER INSERT ON Units
WHEN 'UNITCLASS_ATGM_VEHICLE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;

--������
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_RAILROAD_GUN';

CREATE TRIGGER CostForOilRAILROADGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_RAILROAD_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;



--�����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_TRIPLANE';

CREATE TRIGGER CostForOilTRIPLANE
AFTER INSERT ON Units
WHEN 'UNITCLASS_TRIPLANE'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--ս��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_FIGHTER';

CREATE TRIGGER CostForOilFIGHTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_FIGHTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--����ս��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_INTERCEPTER';

CREATE TRIGGER CostForOilINTERCEPTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_INTERCEPTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--����ս��
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_JET_FIGHTER';

CREATE TRIGGER CostForOilJETFIGHTER
AFTER INSERT ON Units
WHEN 'UNITCLASS_JET_FIGHTER'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',3 FROM Units WHERE Class='UNITCLASS_SR71_BLACKBIRD';


--һս���ػ�
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_CARRIER_FIGHTER_WWII';

CREATE TRIGGER CostForOilCARRIERFIGHTERWWII
AFTER INSERT ON Units
WHEN 'UNITCLASS_CARRIER_FIGHTER_WWII'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--����ʽ���ػ�
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_CARRIER_FIGHTER_JET';

CREATE TRIGGER CostForOilCARRIERFIGHTERJET
AFTER INSERT ON Units
WHEN 'UNITCLASS_CARRIER_FIGHTER_JET'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;
--�߼����ػ�
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_OIL',1 FROM Units WHERE Class='UNITCLASS_CARRIER_FIGHTER_ADV';


CREATE TRIGGER CostForOilCARRIERFIGHTERADV
AFTER INSERT ON Units
WHEN 'UNITCLASS_CARRIER_FIGHTER_ADV'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_OIL',1);
END;

 ------------------------------��------------------------------
--��̹����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_IRON',1 FROM Units WHERE Class='UNITCLASS_ANTI_TANK_GUN';

CREATE TRIGGER CostForIRONANTITANKGUN
AFTER INSERT ON Units
WHEN 'UNITCLASS_ANTI_TANK_GUN'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_IRON',1);
END;

 -------------------------------��------------------------------
--���յ�����
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType,Cost )
SELECT Type, 'RESOURCE_ALUMINUM',1 FROM Units WHERE Class='UNITCLASS_SAM_INFANTRY';

CREATE TRIGGER CostForALUMINUMSAMINFANTRY
AFTER INSERT ON Units
WHEN 'UNITCLASS_SAM_INFANTRY'=NEW.Class
BEGIN
  INSERT INTO Unit_ResourceQuantityRequirements(UnitType, ResourceType, Cost)
    VALUES(NEW.Type, 'RESOURCE_ALUMINUM',1);
END;



 ----------------------------------���йؽ������ͼ���ľ����Դ����------------------------------
 --ľդ��
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',1 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_PALISADE';

--���
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',1 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_STABLE';

--�����ֲ�
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',3 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_COUNTRY_CLUB';
--���ֳ�
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',3 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_AMUSEMENT_PARK';
--���⹫԰
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',3 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_THEME_PARK';
--�ư�
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',3 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_BEVERAGE_FACTORY';


--�糵
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',1 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_WINDMILL';

--����
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',1 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_ART_GALLERY';

--ˮĥ��
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',1 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_WATERMILL';

--��Ϸ��
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',1 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_CIRCUS';

--ɽկ
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType,Cost )
SELECT Type, 'RESOURCE_LUMBER',1 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_HILL_FORT';
 ----------------------------------------- �������������ҩ����------------------------------
 INSERT INTO Building_ResourceQuantity (BuildingType, ResourceType,Quantity )
SELECT Type, 'RESOURCE_GUNPOWDER',3 FROM Buildings WHERE BuildingClass='BUILDINGCLASS_ARSENAL';




 -------------------------------��λ����------------------------------

 --����
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_CITADEL_FUTURE' FROM Units WHERE Class='UNITCLASS_CITADEL_LATE';
 --���
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_RANGEDMARINE04P' FROM Units WHERE Class='UNITCLASS_MILITIA_MODERN';


 --��е������
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_GARIO_BATTLESUIT' FROM Units WHERE Class='UNITCLASS_MECHANIZED_INFANTRY';

--��̹��
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_RAILGUN_TANK' FROM Units WHERE Class='UNITCLASS_ATGM_VEHICLE';
--�����
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_SUPER_ROCKET' FROM Units WHERE Class='UNITCLASS_ROCKET_ARTILLERY';

--������
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_HOVERTANK' FROM Units WHERE Class='UNITCLASS_SELF_PROPELLED_ARTILLERY';

--������
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_SABR' FROM Units WHERE Class='UNITCLASS_SAM_INFANTRY';
--ֱ����
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_VERTOL' FROM Units WHERE Class='UNITCLASS_ATTACK_HELICOPTER';



--�ִ�װ��
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_CARVR' FROM Units WHERE Class='UNITCLASS_MODERN_ARMOR';

--����ս��
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALFIGHTER02' FROM Units WHERE Class='UNITCLASS_LITTORAL_COMBAT_SHIP';

--����
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALFIGHTER03H' FROM Units WHERE Class='UNITCLASS_MODERN_DESTROYER';
--Ѳ��
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALFIGHTER04S' FROM Units WHERE Class='UNITCLASS_MISSILE_CRUISER';

--������⽢
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALFIGHTER03P' FROM Units WHERE Class='UNITCLASS_FUTURE_BATTLESHIP';

--��ĸ
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALCARRIER02' FROM Units WHERE Class='UNITCLASS_SUPER_CARRIER';

--Ǳͧ
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALFIGHTER04P' FROM Units WHERE Class='UNITCLASS_SSBN';



--���طɻ�
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_CARRIER_FIGHTER_FUTURE' FROM Units WHERE Class='UNITCLASS_CARRIER_FIGHTER_ADV';

--ս����
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_AIRFIGHTER03P' FROM Units WHERE Class='UNITCLASS_JET_FIGHTER';
--�߻���
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_AIRFIGHTER04P' FROM Units WHERE Class='UNITCLASS_STEALTH_ATTACK_AIRCRAFT';
--��ը��
INSERT INTO Unit_ClassUpgrades(UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_DRONE_FIGHTER' FROM Units WHERE Class='UNITCLASS_STEALTH_BOMBER'; 
--����
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
INSERT OR IGNORE INTO UnitPromotions(Type, Description, Help, Sound, CannotBeChosen, ExtraAttacks, CanMoveAfterAttacking, MaxHitPointsChange, MovesChange, OrderPriority, PortraitIndex, IconAtlas, PediaType, PediaEntry,NeutralDamage,EnemyDamage,EnemyDamageChance,NeutralDamageChance)VALUES
('PROMOTION_HPMOD1', 'TXT_KEY_PROMOTION_HPMOD1', 'TXT_KEY_PROMOTION_HPMOD1_HELP', 'AS2D_IF_LEVELUP', 1, 0, 1, 200, 1, 11, 4, 'MainRobotPromo_Atlas', 'PEDIA_ATTRIBUTES', 'TXT_KEY_PROMOTION_HPMOD1', 0, 0,0,0),
('PROMOTION_HPMOD2', 'TXT_KEY_PROMOTION_HPMOD2', 'TXT_KEY_PROMOTION_HPMOD2_HELP', 'AS2D_IF_LEVELUP', 1, 1, 1, 200, 1, 11, 4, 'MainRobotPromo_Atlas', 'PEDIA_ATTRIBUTES', 'TXT_KEY_PROMOTION_HPMOD2', -50, -50,100,100),
('PROMOTION_HPMOD3', 'TXT_KEY_PROMOTION_HPMOD3', 'TXT_KEY_PROMOTION_HPMOD3_HELP', 'AS2D_IF_LEVELUP', 1, 0, 1, 300, 1, 11, 4, 'MainRobotPromo_Atlas', 'PEDIA_ATTRIBUTES', 'TXT_KEY_PROMOTION_HPMOD3', 0, 0,0,0);


UPDATE UnitPromotions SET AdjacentEnemySapMovement = 1 WHERE Type = 'PROMOTION_HPMOD2';


-- ������
insert into PromotionCollections(Type) values ('PROMOTION_COLLECTION_FREEZE_BOMB');
insert into PromotionCollections_Entries(CollectionType, PromotionIndex, PromotionType,  TriggerMeleeAttack,TriggerRangedAttack, TriggerHPFixed, TriggerLuaHook) values
('PROMOTION_COLLECTION_FREEZE_BOMB', 1, 'PROMOTION_FREEZE_BOMB', 1,1, 10000, 1);


insert into PromotionCollections(Type) values ('PROMOTION_COLLECTION_FREEZE_EFFECT');
insert into PromotionCollections_Entries(CollectionType, PromotionIndex, PromotionType) values
('PROMOTION_COLLECTION_FREEZE_EFFECT', 1, 'PROMOTION_FREEZE_EFFECT');

insert into PromotionCollections_AddEnemyPromotions(CollectionType, OtherCollectionType) values
('PROMOTION_COLLECTION_FREEZE_BOMB', 'PROMOTION_COLLECTION_FREEZE_EFFECT');



---�ڶ���
INSERT INTO BuildingClassCollections(Type)
SELECT 'COLLECTIONS_WUBAN_CANNON';

INSERT INTO BuildingClassCollections_Entries(CollectionType,BuildingClassIndex,BuildingClassType)
SELECT 'COLLECTIONS_WUBAN_CANNON', 1,   'BUILDINGCLASS_BARRACKS' UNION ALL
SELECT 'COLLECTIONS_WUBAN_CANNON', 2,   'BUILDINGCLASS_ARMORY' UNION ALL
SELECT 'COLLECTIONS_WUBAN_CANNON', 3,   'BUILDINGCLASS_PALISADE' UNION ALL
SELECT 'COLLECTIONS_WUBAN_CANNON', 4,   'BUILDINGCLASS_WALLS' UNION ALL
SELECT 'COLLECTIONS_WUBAN_CANNON', 5,   'BUILDINGCLASS_WATCH' UNION ALL
SELECT 'COLLECTIONS_WUBAN_CANNON', 6,   'BUILDINGCLASS_CASTLE';


---sp�����޸�
UPDATE BuildingClassCollections_Entries SET BuildingClassIndex = BuildingClassIndex + 4  WHERE CollectionType = 'COLLECTIONS_AIR_SIEGE';

INSERT INTO BuildingClassCollections_Entries(CollectionType,BuildingClassIndex,BuildingClassType)
SELECT 'COLLECTIONS_AIR_SIEGE', 1,   'BUILDINGCLASS_MATRIX' UNION ALL
SELECT 'COLLECTIONS_AIR_SIEGE', 2,   'BUILDINGCLASS_ZXZCC' UNION ALL
SELECT 'COLLECTIONS_AIR_SIEGE', 3,   'BUILDINGCLASS_NAVAL_BASE' UNION ALL
SELECT 'COLLECTIONS_AIR_SIEGE', 4,   'BUILDINGCLASS_MILITARY_AIRBASE' ;

insert into LuaFormula(Type, Formula) values
('FORMULA_HEAL_PERCENT_ON_ATTACK_DAMAGE', 'local iAttackDamage, iMaxHitPoints, bEmenyDeath = ... if iAttackDamage >= 0 then return (iMaxHitPoints * 20 /100) else return 0 end');



INSERT INTO Technology_FreePromotions(TechType,PromotionType)
SELECT 'TECH_HOLOGRAPHY', 'PROMOTION_XCOM_WEAPON_BASE' UNION ALL
SELECT 'TECH_METAMATERIAL',  'PROMOTION_FORTIFY_PERFORMED' UNION ALL
SELECT 'TECH_NANOTECHNOLOGY',  'PROMOTION_SMETAL' UNION ALL
SELECT 'TECH_SDI', 'PROMOTION_ANTIAIRX' UNION ALL
SELECT 'TECH_PLANETARY_NETWORKS',  'PROMOTION_AERIAL_REFUELING' UNION ALL
SELECT 'TECH_AUTONOMOUS_SYSTEMS',  'PROMOTION_EQUICK' UNION ALL
SELECT 'TECH_HOMO_SUPERIOR', 'PROMOTION_HPMOD1' UNION ALL
SELECT 'TECH_NEURAL_INTERFACE',  'PROMOTION_CAN_RANGE_ATTACK' UNION ALL
SELECT 'TECH_APPLIEDGRAVITONICS',  'PROMOTION_FIGHTER_ATTACK' UNION ALL
SELECT 'TECH_MILITARY_OCEANOGRAPHY',  'PROMOTION_NAVAL_SIGHT' UNION ALL
SELECT 'TECH_MATTERTRANSMISSION', 'PROMOTION_ALUMINIST' ;





-- ��������ͼ��

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