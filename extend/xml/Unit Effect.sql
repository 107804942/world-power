-------------------------------------------------------------------------
-- 更新单位需求科技
-------------------------------------------------------------------------

UPDATE Units SET ObsoleteTech = 'TECH_LIQUIDMETAL'
WHERE Class = 'UNITCLASS_MILITIA_MODERN'; -- 民兵

UPDATE Units SET ObsoleteTech = 'TECH_HOMO_SUPERIOR'
WHERE Class IN (
    'UNITCLASS_MECHANIZED_INFANTRY',      -- 机械化步兵，盖里欧机甲
    'UNITCLASS_ROCKET_ARTILLERY',         -- 火箭炮，多管能量炮
    'UNITCLASS_SELF_PROPELLED_ARTILLERY', -- 攻城炮，悬浮攻城炮
    'UNITCLASS_SAM_INFANTRY',             -- 防空炮，重炮平台
    'UNITCLASS_CRUSADER_ARTILLERY',       -- 十字军火炮
    'UNITCLASS_CHINESE_WEISHI'            -- 卫士
);

UPDATE Units SET ObsoleteTech = 'TECH_AUTONOMOUS_SYSTEMS'
WHERE Class = 'UNITCLASS_MODERN_ARMOR'; -- 现代装甲，重型机甲

UPDATE Units SET ObsoleteTech = 'TECH_NANOTECHNOLOGY'
WHERE Class = 'UNITCLASS_ATGM_VEHICLE'; -- 反坦克导弹，悬浮穿甲炮

UPDATE Units SET ObsoleteTech = 'TECH_INTERSTELLAR_TRAVEL'
WHERE Class IN (
    'UNITCLASS_ATTACK_HELICOPTER',        -- 武装直升机，喷气式直升机
    'UNITCLASS_CARRIER_FIGHTER_ADV',      -- 舰载机
    'UNITCLASS_JET_FIGHTER',              -- 战斗机
    'UNITCLASS_STEALTH_BOMBER',           -- 隐形轰炸机
    'UNITCLASS_STEALTH_ATTACK_AIRCRAFT',  -- 隐形歼击机
    'UNITCLASS_PAKFA_T50',                -- yf23战斗机
    'UNITCLASS_STEALTH_HELICOPTER'        -- 科曼奇
);

UPDATE Units SET ObsoleteTech = 'TECH_MECHANICAL_ENGINEERING'
WHERE Class IN (
    'UNITCLASS_MODERN_DESTROYER',  -- 现代驱逐舰
    'UNITCLASS_SSBN',              -- 导弹核潜艇
    'UNITCLASS_MISSILE_CRUISER',   -- 导弹巡洋舰
    'UNITCLASS_FUTURE_BATTLESHIP', -- 武库舰
    'UNITCLASS_SUPER_CARRIER'      -- 超级核动力航母
);

UPDATE Units SET ObsoleteTech = 'TECH_MECHANICAL_ENGINEERING'
WHERE Type = 'UNIT_AMERICAN_NIMITZ'; -- 尼米兹

UPDATE Units SET ObsoleteTech = 'TECH_SPACE_TECHNOLOGY'
WHERE Class = 'UNITCLASS_GUIDED_MISSILE'; -- 导弹

UPDATE Units SET PrereqTech = 'TECH_EARTH'
WHERE Type = 'UNIT_SATELLITE_ORBITAL_STRIKE'; -- 上帝之杖

UPDATE Units SET PrereqTech = 'TECH_SPACE_TECHNOLOGY', Combat = 200
WHERE Class = 'UNITCLASS_XCOM_SQUAD'; -- XCOM

UPDATE Units SET PrereqTech = 'TECH_CHEMISTRY'
WHERE Type = 'UNIT_FRENCH_MUSKETEER'; -- 法火

UPDATE Units SET PrereqTech = 'TECH_INTERSTELLAR_TRAVEL'
WHERE Type = 'UNIT_SATELLITE_ECCM';

UPDATE Units SET PrereqTech = 'TECH_WAVEMECHANICS'
WHERE Type = 'UNIT_SATELLITE_RESOURCEPLUS';

UPDATE Units SET PrereqTech = 'TECH_ARTIFICIAL_INTELLIGENCE'
WHERE Type = 'UNIT_SATELLITE_SPACE_ELEVATOR';

UPDATE Units SET PrereqTech = 'TECH_CARTOGRAPHY', ObsoleteTech = 'TECH_NAUTICAL_SCIENCE'
WHERE Class = 'UNITCLASS_GREAT_GALLEASS';

UPDATE Units SET PrereqTech = 'TECH_ROBOTICS', ObsoleteTech = 'TECH_HOMO_SUPERIOR'
WHERE Class = 'UNITCLASS_LITTORAL_COMBAT_SHIP';

-- UPDATE Units SET ObsoleteTech = 'TECH_GRID_COMPUTING' WHERE Class = 'UNITCLASS_TASKFORCE_141';

-------------------------------------------------------------------------
-- 新航母晋升
-------------------------------------------------------------------------

INSERT INTO SPCarrierTransferPromotions (CarrierPromotionType, FighterPromotionType) VALUES
('PROMOTION_CARRIER_FIGHTER_SORTIE_2', 'PROMOTION_CARRIER_FIGHTER_SORTIE_2');

-------------------------------------------------------------------------
-- 远程夹击
-------------------------------------------------------------------------

UPDATE UnitPromotions
SET RangedFlankAttackModifier = 10
WHERE Type IN (
    'PROMOTION_ANTI_MOUNTED',
    'PROMOTION_ANTI_TANK',
    'PROMOTION_NAVAL_RANGED_CRUISER',
    'PROMOTION_NAVAL_RANGED_SHIP'
);

-------------------------------------------------------------------------
-- 工人可购买
-------------------------------------------------------------------------

UPDATE Units SET PuppetPurchaseOverride = 1
WHERE Class = 'UNITCLASS_WORKER';

-------------------------------------------------------------------------
-- 核武器调整
-------------------------------------------------------------------------

UPDATE Units SET ExtraNukeBlastRadius = -1 WHERE Class = 'UNITCLASS_ATOMIC_BOMB';
UPDATE Units SET ExtraNukeBlastRadius = 1  WHERE Class = 'UNITCLASS_ICBM_MISSILE';

INSERT INTO Unit_FreePromotions (UnitType, PromotionType)
SELECT Type, 'PROMOTION_NO_CAPTURED'
FROM Units
WHERE HurryCostModifier = -1 AND Combat >= 500;

-------------------------------------------------------------------------
-- 回回炮
-------------------------------------------------------------------------

INSERT INTO Unit_FreePromotions (UnitType, PromotionType) VALUES
('UNIT_MONGOLIAN_HUIHUIPAO', 'PROMOTION_HUIHUIPAO');

-------------------------------------------------------------------------
-- 步马协同
-------------------------------------------------------------------------

INSERT INTO UnitPromotions_CombatModPerAdjacentUnitCombat
    (PromotionType, UnitCombatType, Modifier, Attack, Defense)
VALUES
('PROMOTION_ANTI_ANTI_MOUNTED_BONUS', 'UNITCOMBAT_MELEE', 8, 0, 0);

-------------------------------------------------------------------------
-- 新增单位战斗类型
-------------------------------------------------------------------------

INSERT INTO UnitCombatInfos (Type, Description) VALUES
('UNITCOMBAT_SETTLER', 'TXT_KEY_UNITCOMBAT_SETTLER'),
('UNITCOMBAT_WORKER',  'TXT_KEY_UNITCOMBAT_WORKER');

UPDATE Units SET CombatClass = 'UNITCOMBAT_SETTLER' WHERE Class = 'UNITCLASS_SETTLER';
UPDATE Units SET CombatClass = 'UNITCOMBAT_WORKER'  WHERE Class = 'UNITCLASS_WORKER';

-------------------------------------------------------------------------
-- 更新单位需求产能
-------------------------------------------------------------------------

UPDATE Units SET Cost = 42,  WorkRate = 200 WHERE Class = 'UNITCLASS_NAVAL_MILITIA';
UPDATE Units SET Cost = 190, WorkRate = 200 WHERE Class = 'UNITCLASS_MONITOR_SHIP';
UPDATE Units SET Cost = 300, WorkRate = 200 WHERE Class = 'UNITCLASS_CORVETTE';

UPDATE Units
SET Cost = 420,
    Combat = 200,
    RangedCombat = 200,
    UnitArtInfo = 'ART_DEF_UNIT_IND',
    UnitFlagAtlas = 'UNIT_FLAG_ATLAS_2',
    UnitFlagIconOffset = 7,
    Moves = 5
WHERE Class = 'UNITCLASS_LITTORAL_COMBAT_SHIP';

-------------------------------------------------------------------------
-- 单位升级
-------------------------------------------------------------------------

INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType) VALUES
('UNIT_ELITE_BATTLECRUISER', 'UNITCLASS_NAVALFIGHTER04S'),
('UNIT_STURMTIGER',          'UNITCLASS_HOVERTANK'),
('UNIT_P1500',               'UNITCLASS_AEGIS'),
('UNIT_SUPER_BATTLESHIP',    'UNITCLASS_NAVALFIGHTER03P'),
-- ('UNIT_UNDERWATER_CARRIER','UNITCLASS_NAVALFIGHTER04P'),
('UNIT_CHINESE_WEISHI',      'UNITCLASS_SUPER_ROCKET'),
-- ('UNIT_TASKFORCE_141','UNITCLASS_XCOM_SQUAD'),
('UNIT_STEALTH_HELICOPTER',  'UNITCLASS_VERTOL'),
('UNIT_CRUSADER_ARTILLERY',  'UNITCLASS_HOVERTANK'),
('UNIT_PAKFA_T50',           'UNITCLASS_AIRFIGHTER03P');

-- 堡垒
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_CITADEL_FUTURE'
FROM Units WHERE Class = 'UNITCLASS_CITADEL_LATE';

-- 民兵
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_RANGEDMARINE04P'
FROM Units WHERE Class = 'UNITCLASS_MILITIA_MODERN';

-- 机械化步兵
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_GARIO_BATTLESUIT'
FROM Units WHERE Class = 'UNITCLASS_MECHANIZED_INFANTRY';

-- 反坦克
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_RAILGUN_TANK'
FROM Units WHERE Class = 'UNITCLASS_ATGM_VEHICLE';

-- 火箭炮
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_SUPER_ROCKET'
FROM Units WHERE Class = 'UNITCLASS_ROCKET_ARTILLERY';

-- 攻城炮
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_HOVERTANK'
FROM Units WHERE Class = 'UNITCLASS_SELF_PROPELLED_ARTILLERY';

-- 防空炮
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_SABR'
FROM Units WHERE Class = 'UNITCLASS_SAM_INFANTRY';

-- 直升机
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_VERTOL'
FROM Units WHERE Class = 'UNITCLASS_ATTACK_HELICOPTER';

-- 现代装甲
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_CARVR'
FROM Units WHERE Class = 'UNITCLASS_MODERN_ARMOR';

-- 海滨战舰
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALFIGHTER02'
FROM Units WHERE Class = 'UNITCLASS_LITTORAL_COMBAT_SHIP';

-- 驱逐舰
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALFIGHTER03H'
FROM Units WHERE Class = 'UNITCLASS_MODERN_DESTROYER';

-- 巡洋舰
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALFIGHTER04S'
FROM Units WHERE Class = 'UNITCLASS_MISSILE_CRUISER';

-- 超级武库舰
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALFIGHTER03P'
FROM Units WHERE Class = 'UNITCLASS_FUTURE_BATTLESHIP';

-- 航母
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_NAVALCARRIER02'
FROM Units WHERE Class = 'UNITCLASS_SUPER_CARRIER';

-- 潜艇
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_SUB04S'
FROM Units WHERE Class = 'UNITCLASS_SSBN';

-- 舰载飞机
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_CARRIER_FIGHTER_FUTURE'
FROM Units WHERE Class = 'UNITCLASS_CARRIER_FIGHTER_ADV';

-- 战斗机
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_AIRFIGHTER03P'
FROM Units WHERE Class = 'UNITCLASS_JET_FIGHTER';

-- 歼击机
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_AIRFIGHTER04P'
FROM Units WHERE Class = 'UNITCLASS_STEALTH_ATTACK_AIRCRAFT';

-- 轰炸机
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_DRONE_FIGHTER'
FROM Units WHERE Class = 'UNITCLASS_STEALTH_BOMBER';

-- 导弹
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT Type, 'UNITCLASS_SUPER_MISSILE'
FROM Units WHERE Class = 'UNITCLASS_GUIDED_MISSILE';

-------------------------------------------------------------------------
-- 科技提升战斗力
-------------------------------------------------------------------------

INSERT INTO Unit_TechCombatStrength (UnitType, TechType, CombatStrength) VALUES
('UNIT_MECH', 'TECH_CYBERNETICS', 1500);

INSERT INTO Unit_TechRangedCombatStrength (UnitType, TechType, RangedCombatStrength) VALUES
('UNIT_MECH', 'TECH_CYBERNETICS', 1500);

-------------------------------------------------------------------------
-- 晋升关联单位种类 / 单位类型
-------------------------------------------------------------------------

-- 所有单位战斗类型获得 PROMOTION_CAUSEWAY
INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_CAUSEWAY', Type FROM UnitCombatInfos WHERE ID >= 0;

-- 有远程战斗力的单位获得 PROMOTION_EXPLOSIVE_MIXTURE
INSERT INTO UnitPromotions_UnitType (PromotionType, UnitType)
SELECT 'PROMOTION_EXPLOSIVE_MIXTURE', Type FROM Units WHERE RangedCombat > 0;

-- 海军单位获得 PROMOTION_BERMUDA
INSERT INTO UnitPromotions_UnitType (PromotionType, UnitType)
SELECT 'PROMOTION_BERMUDA', Type FROM Units WHERE Domain = 'DOMAIN_SEA';

-- 近战单位获得 PROMOTION_YUEYANG
INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_YUEYANG', Type FROM UnitCombatInfos WHERE Type = 'UNITCOMBAT_MELEE';

-- 海军相关单位获得 PROMOTION_ROYAL / BEILUN_TOWER / STEAM_POWERED
INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_ROYAL', Type FROM UnitCombatInfos
WHERE Type IN ('UNITCOMBAT_SUBMARINE','UNITCOMBAT_NAVALMELEE','UNITCOMBAT_NAVALRANGED','UNITCOMBAT_CARRIER');

INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_BEILUN_TOWER', Type FROM UnitCombatInfos
WHERE Type IN ('UNITCOMBAT_SUBMARINE','UNITCOMBAT_NAVALMELEE','UNITCOMBAT_NAVALRANGED','UNITCOMBAT_CARRIER');

INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_STEAM_POWERED', Type FROM UnitCombatInfos
WHERE Type IN ('UNITCOMBAT_SUBMARINE','UNITCOMBAT_NAVALMELEE','UNITCOMBAT_NAVALRANGED','UNITCOMBAT_CARRIER');

-- 非海军、非飞机、非弓箭单位获得 PROMOTION_FASIL_GHEBBI / ISHTARGATE / KARRUPP
INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_FASIL_GHEBBI', Type FROM UnitCombatInfos
WHERE Type NOT IN ('UNITCOMBAT_SUBMARINE','UNITCOMBAT_NAVALMELEE','UNITCOMBAT_NAVALRANGED','UNITCOMBAT_CARRIER','UNITCOMBAT_FIGHTER','UNITCOMBAT_ARCHER');

INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_ISHTARGATE', Type FROM UnitCombatInfos
WHERE Type NOT IN ('UNITCOMBAT_SUBMARINE','UNITCOMBAT_NAVALMELEE','UNITCOMBAT_NAVALRANGED','UNITCOMBAT_CARRIER','UNITCOMBAT_FIGHTER','UNITCOMBAT_ARCHER');

INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_KARRUPP', Type FROM UnitCombatInfos
WHERE Type NOT IN ('UNITCOMBAT_SUBMARINE','UNITCOMBAT_NAVALMELEE','UNITCOMBAT_NAVALRANGED','UNITCOMBAT_CARRIER','UNITCOMBAT_FIGHTER','UNITCOMBAT_ARCHER');

-- KGB：排除海军、飞机、弓箭、工人、移民
INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_KGB', Type FROM UnitCombatInfos
WHERE Type NOT IN ('UNITCOMBAT_SUBMARINE','UNITCOMBAT_NAVALMELEE','UNITCOMBAT_NAVALRANGED','UNITCOMBAT_CARRIER','UNITCOMBAT_FIGHTER','UNITCOMBAT_ARCHER','UNITCOMBAT_WORKER','UNITCOMBAT_SETTLER');

-- SOVIET_FRIEND / PEOPLES_HALL：排除飞机、弓箭
INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_SOVIET_FRIEND', Type FROM UnitCombatInfos
WHERE Type NOT IN ('UNITCOMBAT_FIGHTER','UNITCOMBAT_ARCHER');

INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_PEOPLES_HALL', Type FROM UnitCombatInfos
WHERE Type NOT IN ('UNITCOMBAT_FIGHTER','UNITCOMBAT_ARCHER');

-- 全单位战斗类型
INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_LIBERATION_STRENGTH', Type FROM UnitCombatInfos;

INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_SKYNET_LINK', Type FROM UnitCombatInfos;

INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_DIABLO', Type FROM UnitCombatInfos;

-- 太空堡垒
INSERT INTO UnitPromotions_UnitCombats (PromotionType, UnitCombatType)
SELECT 'PROMOTION_SPACE_FORTRESS', Type FROM UnitCombatInfos
WHERE Type NOT IN ('UNITCOMBAT_FIGHTER','UNITCOMBAT_ARCHER');

-- 行星扫描仪
INSERT INTO UnitPromotions_UnitType (PromotionType, UnitType)
SELECT 'PROMOTION_PARATROOPER_BUFF', Type FROM Units
WHERE CombatClass = 'UNITCOMBAT_GUN';

-- 精确制导
INSERT INTO UnitPromotions_UnitType (PromotionType, UnitType)
SELECT 'PROMOTION_FIGHTER_ATTACK', U.Type
FROM Units U
JOIN Technologies T ON U.PrereqTech = T.Type
JOIN Eras E ON T.Era = E.Type
WHERE U.CombatClass IN ('UNITCOMBAT_ARCHER','UNITCOMBAT_FIGHTER')
  AND E.ID > 6;

-- 海军防空
INSERT INTO UnitPromotions_UnitType (PromotionType, UnitType)
SELECT 'PROMOTION_ANTIAIRX', Type FROM Units
WHERE Class IN ('UNITCLASS_MODERN_DESTROYER','UNITCLASS_NAVALFIGHTER03H');

-- 轰炸机溅射
INSERT INTO UnitPromotions_UnitType (PromotionType, UnitType)
SELECT 'PROMOTION_AERIAL_REFUELING', Type FROM Units
WHERE Class IN ('UNITCLASS_STEALTH_BOMBER','UNITCLASS_DRONE_FIGHTER');

-- 骑士堡增强
INSERT INTO UnitPromotions_UnitType (PromotionType, UnitType)
SELECT 'PROMOTION_KRAK_DES_CHEVALIERS', Type FROM Units
WHERE CombatClass = 'UNITCOMBAT_MOUNTED';

-- 大军光环增强
INSERT INTO UnitPromotions_UnitType (PromotionType, UnitType)
SELECT 'PROMOTION_PEOPLES_HALL', Type FROM Units
WHERE Class = 'UNITCLASS_GREAT_GENERAL';

-- 堡垒增强
INSERT INTO UnitPromotions_UnitType (PromotionType, UnitType)
SELECT 'PROMOTION_HPMOD2', Type FROM Units
WHERE Class IN (
    'UNITCLASS_CITADEL_EARLY',
    'UNITCLASS_CITADEL_MID',
    'UNITCLASS_CITADEL_LATE',
    'UNITCLASS_CITADEL_FUTURE'
);

-------------------------------------------------------------------------
-- 全地貌防御加成
-------------------------------------------------------------------------

INSERT INTO UnitPromotions_Features (PromotionType, FeatureType, Defense)
SELECT 'PROMOTION_GHOST_POWER', Type, 100 FROM Features WHERE ID != -1;

INSERT INTO UnitPromotions_Features (PromotionType, FeatureType, Attack)
SELECT 'PROMOTION_GHOST_POWER', Type, 100 FROM Features WHERE ID != -1;

-------------------------------------------------------------------------
-- 删除歼击机初始领域加成
-------------------------------------------------------------------------

DELETE FROM UnitPromotions_UnitCombatMods
WHERE PromotionType = 'PROMOTION_AIR_ATTACK'
  AND UnitCombatType IN ('UNITCOMBAT_MOUNTED','UNITCOMBAT_ARMOR');

DELETE FROM UnitPromotions_Domains
WHERE PromotionType = 'PROMOTION_AIR_ATTACK'
  AND DomainType IN ('DOMAIN_LAND','DOMAIN_SEA');

DELETE FROM UnitPromotions_Domains
WHERE PromotionType = 'PROMOTION_CARRIER_FIGHTER'
  AND DomainType IN ('DOMAIN_LAND','DOMAIN_SEA');

-------------------------------------------------------------------------
-- 伟人一次性产出削弱
-------------------------------------------------------------------------

UPDATE Units SET BaseBeakersTurnsToCount = 2 WHERE Class = 'UNITCLASS_SCIENTIST';
UPDATE Units SET BaseCultureTurnsToCount = 3 WHERE Class = 'UNITCLASS_WRITER';
UPDATE Units SET OneShotTourism = 7          WHERE Class = 'UNITCLASS_MUSICIAN';
UPDATE Units SET BaseHurry = 3000, HurryMultiplier = 50 WHERE Class = 'UNITCLASS_ENGINEER';

-------------------------------------------------------------------------
-- 泰坦战舰对现代化海军的增幅
-------------------------------------------------------------------------

UPDATE UnitPromotions
SET NearbyUnitPromotionBonus = 100,
    NearbyUnitPromotionBonusRange = 6,
    CombatBonusFromNearbyUnitPromotion = 'PROMOTION_WEAPON_SHIP'
WHERE Type IN (
    'PROMOTION_DESTROYER_COMBAT',
    'PROMOTION_NAVAL_RANGED_CRUISER',
    'PROMOTION_SUBMARINE_COMBAT',
    'PROMOTION_NAVAL_CAPITAL_SHIP'
);

UPDATE UnitPromotions
SET NearbyUnitPromotionBonus = 100,
    NearbyUnitPromotionBonusRange = 3,
    CombatBonusFromNearbyUnitPromotion = 'PROMOTION_GOLEM'
WHERE Type IN ('PROMOTION_ROBORT_COMBAT','PROMOTION_HEAVY_ROBORT');

-------------------------------------------------------------------------
-- 晋升之间的相互加成
-------------------------------------------------------------------------

INSERT INTO UnitPromotions_PromotionModifiers (PromotionType, OtherPromotionType, Modifier) VALUES
('PROMOTION_SKYNET_LINK', 'PROMOTION_ROBORT_COMBAT', 25),   -- 天网对机器人
('PROMOTION_HEAVY_ROBORT','PROMOTION_ROBORT_COMBAT', 25),   -- 重型机甲对机器人
('PROMOTION_STURMTIGER',  'PROMOTION_CITADEL_DEFENSE', 200),-- 突击虎对堡垒
('PROMOTION_COMBAT_TO_DEATH', 'PROMOTION_ANTI_MOUNTED', 100), -- 铁浮图/赫梯对反骑兵
('PROMOTION_COMBAT_TO_DEATH', 'PROMOTION_ANTI_TANK',    100),
('PROMOTION_ANTI_ANTI_MOUNTED_BONUS','PROMOTION_ANTI_MOUNTED',33),
('PROMOTION_ANTI_ANTI_MOUNTED_BONUS','PROMOTION_ANTI_TANK',   33);

INSERT INTO UnitPromotions_PromotionModifiers (PromotionType, OtherPromotionType, Attack) VALUES
('PROMOTION_BURNING_BOMB','PROMOTION_FREEZE_EFFECT',150), -- 燃烧弹对冰冻弹
('PROMOTION_FIRE_WEAPON', 'PROMOTION_BURNING_EFFECT',50), -- 燃烧弹
('PROMOTION_FOCUS',       'PROMOTION_CITADEL_DEFENSE',300);-- 超级武器对堡垒

-------------------------------------------------------------------------
-- 限制民兵数量
-------------------------------------------------------------------------

UPDATE UnitClasses SET MaxPlayerInstances = 5
WHERE Type IN (
    'UNITCLASS_WARRIOR',
    'UNITCLASS_MILITIA_ANCIENT',
    'UNITCLASS_MINUTEMAN',
    'UNITCLASS_CONSCRIPTMAN',
    'UNITCLASS_MILITIA_MODERN'
);

-------------------------------------------------------------------------
-- 资源需求：配置表 + 通用触发器
-------------------------------------------------------------------------

-- 资源需求配置表
CREATE TABLE IF NOT EXISTS UnitClassResourceRequirement (
    UnitClassType TEXT NOT NULL,
    ResourceType  TEXT NOT NULL,
    Cost          INTEGER NOT NULL,
    PRIMARY KEY (UnitClassType, ResourceType)
);

-- 配置数据
INSERT OR IGNORE INTO UnitClassResourceRequirement (UnitClassType, ResourceType, Cost) VALUES
-- 木材
('UNITCLASS_COMPOSITE_BOWMAN', 'RESOURCE_LUMBER', 1),
('UNITCLASS_CROSSBOWMAN',      'RESOURCE_LUMBER', 1),
('UNITCLASS_LONGBOWMAN',       'RESOURCE_LUMBER', 2),
('UNITCLASS_CATAPULT',         'RESOURCE_LUMBER', 1),
('UNITCLASS_TREBUCHET',        'RESOURCE_LUMBER', 1),
('UNITCLASS_NAVAL_MILITIA',    'RESOURCE_LUMBER', 1),
('UNITCLASS_TRIREME',          'RESOURCE_LUMBER', 1),
('UNITCLASS_GALLEASS',         'RESOURCE_LUMBER', 1),
('UNITCLASS_GREAT_GALLEASS',   'RESOURCE_LUMBER', 1),
('UNITCLASS_FRIGATE',          'RESOURCE_LUMBER', 2),
('UNITCLASS_FIRE_SHIP',        'RESOURCE_LUMBER', 1),
('UNITCLASS_SLOOP_OF_WAR',     'RESOURCE_LUMBER', 1),
('UNITCLASS_ZHENGHE_FLEET',    'RESOURCE_LUMBER', 2),
('UNITCLASS_CARAVEL',          'RESOURCE_LUMBER', 1),
('UNITCLASS_SHIP_OF_THE_LINE', 'RESOURCE_LUMBER', 2),
-- 火药
('UNITCLASS_CONSCRIPTMAN',           'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_MILITIA_MODERN',         'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_MUSKETMAN',              'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_MUSKETEER',              'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_RIFLEMAN',               'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_GREAT_WAR_INFANTRY',     'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_INFANTRY',               'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_FOREIGNLEGION',          'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_MOTORISED_INFANTRY',     'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_MECHANIZED_INFANTRY',    'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_WWI_PARATROOPER',        'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_MARINE',                 'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_PARATROOPER',            'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_ELITE_SNIPER',           'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_TASKFORCE_141',          'RESOURCE_GUNPOWDER', 2),
('UNITCLASS_BOMBARD',                'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_WWI_TANK',               'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_TANK',                   'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_MAIN_BATTLE_TANK',       'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_MODERN_ARMOR',           'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_LAND_IRONCLAD',          'RESOURCE_GUNPOWDER', 3),
('UNITCLASS_COSSACK_MILITIA',        'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_SUPER_TANK',             'RESOURCE_GUNPOWDER', 2),
('UNITCLASS_VOLLEY_GUN',             'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_GATLINGGUN',             'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_MACHINE_GUN',            'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_ANTI_AIRCRAFT_GUN',      'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_MOBILE_AA_GUN',          'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_SAM_INFANTRY',           'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_SUPER_HOWITZER',         'RESOURCE_GUNPOWDER', 3),
('UNITCLASS_CRUSADER_ARTILLERY',     'RESOURCE_GUNPOWDER', 2),
('UNITCLASS_NUCLEAR_ARTILLERY',      'RESOURCE_GUNPOWDER', 2),
('UNITCLASS_PROTOTYPE_HWACHA',       'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_CULVERIN',               'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_CANNON',                 'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_HOWITZER',               'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_ARTILLERY',              'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_SELF_PROPELLED_ARTILLERY','RESOURCE_GUNPOWDER', 1),
('UNITCLASS_RAILROAD_GUN',           'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_KATYUSHA',               'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_ROCKET_ARTILLERY',       'RESOURCE_GUNPOWDER', 2),
('UNITCLASS_CAVALRY',                'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_CRUISER_TANK',           'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_HELICOPTER_GUNSHIP',     'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_ATTACK_HELICOPTER',      'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_STEALTH_HELICOPTER',     'RESOURCE_GUNPOWDER', 2),
('UNITCLASS_CHINESE_WEISHI',         'RESOURCE_GUNPOWDER', 3),
('UNITCLASS_ANTI_TANK_GUN',          'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_TANK_DESTROYER',         'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_ATGM_VEHICLE',           'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_LIGHT_IRONCLAD',         'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_SUBMARINE',              'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_PROTOTYPE_SUBMARINE',    'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_NUCLEAR_SUBMARINE',      'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_UNDERWATER_CARRIER',     'RESOURCE_GUNPOWDER', 2),
('UNITCLASS_DREADNOUGHT',            'RESOURCE_GUNPOWDER', 2),
('UNITCLASS_BATTLESHIP',             'RESOURCE_GUNPOWDER', 2),
('UNITCLASS_FUTURE_BATTLESHIP',      'RESOURCE_GUNPOWDER', 3),
('UNITCLASS_ELITE_BATTLECRUISER',    'RESOURCE_GUNPOWDER', 4),
('UNITCLASS_SUPER_BATTLESHIP',       'RESOURCE_GUNPOWDER', 3),
('UNITCLASS_IRONCLAD',               'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_DESTROYER',              'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_MODERN_DESTROYER',       'RESOURCE_GUNPOWDER', 2),
('UNITCLASS_PROTECTED_CRUISER',      'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_HEAVY_CRUISER',          'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_MISSILE_CRUISER',        'RESOURCE_GUNPOWDER', 2),
('UNITCLASS_MONITOR_SHIP',           'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_CORVETTE',               'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_LITTORAL_COMBAT_SHIP',   'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_TRIPLANE',               'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_FIGHTER',                'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_INTERCEPTER',            'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_JET_FIGHTER',            'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_PAKFA_T50',              'RESOURCE_GUNPOWDER', 2),
('UNITCLASS_WWI_BOMBER',             'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_DIVE_BOMBER',            'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_ATTACK_AIRCRAFT',        'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_STEALTH_ATTACK_AIRCRAFT','RESOURCE_GUNPOWDER', 2),
('UNITCLASS_CARRIER_FIGHTER_WWII',   'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_CARRIER_FIGHTER_JET',    'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_CARRIER_FIGHTER_ADV',    'RESOURCE_GUNPOWDER', 1),
('UNITCLASS_PROTOTYPE_BOMBER',       'RESOURCE_GUNPOWDER', 2),
('UNITCLASS_BOMBER',                 'RESOURCE_GUNPOWDER', 2),
('UNITCLASS_JET_BOMBER',             'RESOURCE_GUNPOWDER', 3),
('UNITCLASS_STEALTH_BOMBER',         'RESOURCE_GUNPOWDER', 4),
-- 石油
('UNITCLASS_CORVETTE',               'RESOURCE_OIL', 1),
('UNITCLASS_DESTROYER',              'RESOURCE_OIL', 1),
('UNITCLASS_MODERN_DESTROYER',       'RESOURCE_OIL', 3),
--('UNITCLASS_MISSILE_CRUISER',        'RESOURCE_OIL', 4),
('UNITCLASS_FUTURE_BATTLESHIP',      'RESOURCE_OIL', 5),
('UNITCLASS_MOTORISED_INFANTRY',     'RESOURCE_OIL', 1),
('UNITCLASS_MECHANIZED_INFANTRY',    'RESOURCE_OIL', 1),
('UNITCLASS_HELICOPTER_GUNSHIP',     'RESOURCE_OIL', 1),
('UNITCLASS_ATTACK_HELICOPTER',      'RESOURCE_OIL', 1),
('UNITCLASS_TANK_DESTROYER',         'RESOURCE_OIL', 1),
('UNITCLASS_ATGM_VEHICLE',           'RESOURCE_OIL', 1),
('UNITCLASS_RAILROAD_GUN',           'RESOURCE_OIL', 1),
('UNITCLASS_TRIPLANE',               'RESOURCE_OIL', 1),
('UNITCLASS_FIGHTER',                'RESOURCE_OIL', 1),
('UNITCLASS_INTERCEPTER',            'RESOURCE_OIL', 1),
('UNITCLASS_JET_FIGHTER',            'RESOURCE_OIL', 1),
('UNITCLASS_SR71_BLACKBIRD',         'RESOURCE_OIL', 3),
('UNITCLASS_CARRIER_FIGHTER_WWII',   'RESOURCE_OIL', 1),
('UNITCLASS_CARRIER_FIGHTER_JET',    'RESOURCE_OIL', 1),
('UNITCLASS_CARRIER_FIGHTER_ADV',    'RESOURCE_OIL', 1),
-- 铁
('UNITCLASS_ANTI_TANK_GUN',          'RESOURCE_IRON', 1),
-- 铝
('UNITCLASS_SAM_INFANTRY',           'RESOURCE_ALUMINUM', 1);

-- 初始批量插入
INSERT OR IGNORE INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType, Cost)
SELECT U.Type, R.ResourceType, R.Cost
FROM Units U
JOIN UnitClassResourceRequirement R ON R.UnitClassType = U.Class;

-- 通用触发器：新单位插入时自动补资源需求
DROP TRIGGER IF EXISTS TRG_UnitRes_OnUnitInsert;
CREATE TRIGGER TRG_UnitRes_OnUnitInsert
AFTER INSERT ON Units
BEGIN
    INSERT OR IGNORE INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType, Cost)
    SELECT NEW.Type, R.ResourceType, R.Cost
    FROM UnitClassResourceRequirement R
    WHERE R.UnitClassType = NEW.Class;
END;

-------------------------------------------------------------------------
-- 建筑资源需求
-------------------------------------------------------------------------

-- 木材
INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType, Cost)
SELECT Type, 'RESOURCE_LUMBER', 1 FROM Buildings
WHERE BuildingClass IN (
    'BUILDINGCLASS_PALISADE',
    'BUILDINGCLASS_STABLE',
    'BUILDINGCLASS_WINDMILL',
    'BUILDINGCLASS_ART_GALLERY',
    'BUILDINGCLASS_WATERMILL',
    'BUILDINGCLASS_CIRCUS',
    'BUILDINGCLASS_HILL_FORT'
);

INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType, Cost)
SELECT Type, 'RESOURCE_LUMBER', 3 FROM Buildings
WHERE BuildingClass IN (
    'BUILDINGCLASS_COUNTRY_CLUB',
    'BUILDINGCLASS_AMUSEMENT_PARK',
    'BUILDINGCLASS_THEME_PARK',
    'BUILDINGCLASS_BEVERAGE_FACTORY'
);

-- 兵工厂火药供给
INSERT INTO Building_ResourceQuantity (BuildingType, ResourceType, Quantity)
SELECT Type, 'RESOURCE_GUNPOWDER', 3 FROM Buildings
WHERE BuildingClass = 'BUILDINGCLASS_ARSENAL';

-------------------------------------------------------------------------
-- 单位资源需求的例外删除
-------------------------------------------------------------------------

--DELETE FROM Unit_ResourceQuantityRequirements
--WHERE ResourceType = 'RESOURCE_OIL'
 -- AND UnitType IN ('UNIT_FRANCE_MISTRAL','UNIT_MISSILE_CRUISER');

-- 先尝试更新
UPDATE Unit_ResourceQuantityRequirements
SET Cost = 4
WHERE ResourceType = 'RESOURCE_OIL'
  AND UnitType IN (
      SELECT Type FROM Units WHERE Class = 'UNITCLASS_MISSILE_CRUISER'
  );

-- 如果没有更新到，再插入
INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType, Cost)
SELECT Type, 'RESOURCE_OIL', 4
FROM Units
WHERE Class = 'UNITCLASS_MISSILE_CRUISER'
  AND NOT EXISTS (
      SELECT 1 FROM Unit_ResourceQuantityRequirements R
      WHERE R.UnitType = Units.Type
        AND R.ResourceType = 'RESOURCE_OIL'
  );
-------------------------------------------------------------------------
-- 晋升定义
-------------------------------------------------------------------------

INSERT INTO UnitPromotions
    (Type, Description, Help, Sound, CannotBeChosen, PortraitIndex, IconAtlas, PediaEntry, PediaType, ShowInPedia, ShowInUnitPanel, CargoChange, RemoveAfterXTurns)
VALUES
('PROMOTION_SPACE_BATTLECRUISER_MANA',            'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA',            'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_HELP',            'AS2D_IF_LEVELUP', 1, 22, 'MainRobotPromo_Atlas', 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA',            'PEDIA_ATTRIBUTES', 0, 1, 10, 0),
('PROMOTION_SPACE_BATTLECRUISER_MANA_COLD_DOWN',  'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_COLD_DOWN',  'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_COLD_DOWN_HELP',  'AS2D_IF_LEVELUP', 1, 22, 'MainRobotPromo_Atlas', 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_MANA_COLD_DOWN',  'PEDIA_ATTRIBUTES', 0, 0,  0, 3),
('PROMOTION_SPACE_BATTLECRUISER_NUKE_COLD_DOWN',  'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_NUKE_COLD_DOWN',  'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_NUKE_COLD_DOWN_HELP',  'AS2D_IF_LEVELUP', 1, 22, 'MainRobotPromo_Atlas', 'TXT_KEY_PROMOTION_SPACE_BATTLECRUISER_NUKE_COLD_DOWN',  'PEDIA_ATTRIBUTES', 0, 0,  0, 1);

-- HP MOD
INSERT OR IGNORE INTO UnitPromotions
    (Type, Description, Help, Sound, CannotBeChosen, ExtraAttacks, CanMoveAfterAttacking, MaxHitPointsChange, MovesChange, OrderPriority, PortraitIndex, IconAtlas, PediaType, PediaEntry, NeutralDamage, EnemyDamage, EnemyDamageChance, NeutralDamageChance)
VALUES
('PROMOTION_HPMOD1', 'TXT_KEY_PROMOTION_HPMOD1', 'TXT_KEY_PROMOTION_HPMOD1_HELP', 'AS2D_IF_LEVELUP', 1, 0, 1, 200, 1, 11, 4, 'MainRobotPromo_Atlas', 'PEDIA_ATTRIBUTES', 'TXT_KEY_PROMOTION_HPMOD1',   0,   0,   0,   0),
('PROMOTION_HPMOD2', 'TXT_KEY_PROMOTION_HPMOD2', 'TXT_KEY_PROMOTION_HPMOD2_HELP', 'AS2D_IF_LEVELUP', 1, 1, 1, 200, 1, 11, 4, 'MainRobotPromo_Atlas', 'PEDIA_ATTRIBUTES', 'TXT_KEY_PROMOTION_HPMOD2', -50, -50, 100, 100),
('PROMOTION_HPMOD3', 'TXT_KEY_PROMOTION_HPMOD3', 'TXT_KEY_PROMOTION_HPMOD3_HELP', 'AS2D_IF_LEVELUP', 1, 0, 1, 300, 1, 11, 4, 'MainRobotPromo_Atlas', 'PEDIA_ATTRIBUTES', 'TXT_KEY_PROMOTION_HPMOD3',   0,   0,   0,   0);

UPDATE UnitPromotions SET AdjacentEnemySapMovement = 60 WHERE Type = 'PROMOTION_HPMOD2';

-------------------------------------------------------------------------
-- 冰冻弹
-------------------------------------------------------------------------

INSERT INTO PromotionCollections (Type) VALUES ('PROMOTION_COLLECTION_FREEZE_BOMB');

INSERT INTO PromotionCollections_Entries
    (CollectionType, PromotionIndex, PromotionType, TriggerMeleeAttack, TriggerRangedAttack, TriggerHPFixed, TriggerLuaHook)
VALUES
('PROMOTION_COLLECTION_FREEZE_BOMB', 1, 'PROMOTION_FREEZE_BOMB', 1, 1, 10000, 1);

INSERT INTO PromotionCollections (Type) VALUES ('PROMOTION_COLLECTION_FREEZE_EFFECT');

INSERT INTO PromotionCollections_Entries
    (CollectionType, PromotionIndex, PromotionType)
VALUES
('PROMOTION_COLLECTION_FREEZE_EFFECT', 1, 'PROMOTION_FREEZE_EFFECT');

INSERT INTO PromotionCollections_AddEnemyPromotions (CollectionType, OtherCollectionType) VALUES
('PROMOTION_COLLECTION_FREEZE_BOMB', 'PROMOTION_COLLECTION_FREEZE_EFFECT');

-------------------------------------------------------------------------
-- 乌尔班
-------------------------------------------------------------------------

INSERT INTO BuildingClassCollections (Type) VALUES ('COLLECTIONS_WUBAN_CANNON');

INSERT INTO BuildingClassCollections_Entries
    (CollectionType, BuildingClassIndex, BuildingClassType)
VALUES
('COLLECTIONS_WUBAN_CANNON', 1, 'BUILDINGCLASS_BARRACKS'),
('COLLECTIONS_WUBAN_CANNON', 2, 'BUILDINGCLASS_ARMORY'),
('COLLECTIONS_WUBAN_CANNON', 3, 'BUILDINGCLASS_PALISADE'),
('COLLECTIONS_WUBAN_CANNON', 4, 'BUILDINGCLASS_WALLS'),
('COLLECTIONS_WUBAN_CANNON', 5, 'BUILDINGCLASS_WATCH'),
('COLLECTIONS_WUBAN_CANNON', 6, 'BUILDINGCLASS_CASTLE');

-------------------------------------------------------------------------
-- SP 兼容修改
-------------------------------------------------------------------------

UPDATE BuildingClassCollections_Entries
SET BuildingClassIndex = BuildingClassIndex + 4
WHERE CollectionType = 'COLLECTIONS_AIR_SIEGE';

INSERT INTO BuildingClassCollections_Entries
    (CollectionType, BuildingClassIndex, BuildingClassType)
VALUES
('COLLECTIONS_AIR_SIEGE', 1, 'BUILDINGCLASS_MATRIX'),
('COLLECTIONS_AIR_SIEGE', 2, 'BUILDINGCLASS_ZXZCC'),
('COLLECTIONS_AIR_SIEGE', 3, 'BUILDINGCLASS_NAVAL_BASE'),
('COLLECTIONS_AIR_SIEGE', 4, 'BUILDINGCLASS_MILITARY_AIRBASE');

-------------------------------------------------------------------------
-- Lua 公式
-------------------------------------------------------------------------

INSERT INTO LuaFormula (Type, Formula) VALUES
('FORMULA_HEAL_PERCENT_ON_ATTACK_DAMAGE',
 'local iAttackDamage, iMaxHitPoints, bEmenyDeath = ... if iAttackDamage >= 0 then return (iMaxHitPoints * 20 /100) else return 0 end');

-------------------------------------------------------------------------
-- 科技免费晋升
-------------------------------------------------------------------------

INSERT INTO Technology_FreePromotions (TechType, PromotionType) VALUES
('TECH_SDI',                'PROMOTION_ANTIAIRX'),
('TECH_PLANETARY_NETWORKS', 'PROMOTION_AERIAL_REFUELING'),
('TECH_ARMOR',              'PROMOTION_FIGHTER_ATTACK'),
('TECH_MATTERTRANSMISSION', 'PROMOTION_ALUMINIST');

-------------------------------------------------------------------------
-- 万国门：为早期世界奇观单位类提供额外建造上限
-------------------------------------------------------------------------

INSERT INTO Building_UnitClassMaxInstances (BuildingType, UnitClassType, ExtraMax)
SELECT 'BUILDING_GATE_ALL', U.Class, 1
FROM Units U
JOIN Technologies T ON U.PrereqTech = T.Type
JOIN Eras E ON T.Era = E.Type
WHERE U.Cost > 1
  AND U.ProjectPrereq != -1
  AND E.ID < 4;

DROP TRIGGER IF EXISTS TRG_GateAll_OnUnitClassInsert;
CREATE TRIGGER TRG_GateAll_OnUnitClassInsert
AFTER INSERT ON UnitClasses
WHEN NEW.MaxGlobalInstances = 1
BEGIN
    INSERT INTO Building_UnitClassMaxInstances (BuildingType, UnitClassType, ExtraMax)
    SELECT 'BUILDING_GATE_ALL', U.Class, 1
    FROM Units U
    WHERE U.Class = NEW.Type
      AND U.Cost > 1
      AND U.ProjectPrereq != -1
      AND EXISTS (
          SELECT 1
          FROM Technologies T
          JOIN Eras E ON T.Era = E.Type
          WHERE T.Type = U.PrereqTech
            AND E.ID < 4
      );
END;

-------------------------------------------------------------------------
-- 单位战略视图
-------------------------------------------------------------------------

UPDATE SPTriggerControler SET Enabled = 1 WHERE TriggerType = 'SPNDeleteALLUnitStrategicFlag';
UPDATE SPNewEffectControler SET Enabled = 1 WHERE Type = 'SP_DELETE_ALL_STRATEGIC_UNIT_FLAG';
UPDATE SPTriggerControler SET Enabled = 1 WHERE TriggerType = 'Minor_Building_Overrides_Trigger';
