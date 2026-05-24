
ALTER TABLE Units ADD Era TEXT DEFAULT -1;

UPDATE Units SET Era = 'ERA_ANCIENT' WHERE PrereqTech = 'TECH_FISHERY' OR PrereqTech = 'TECH_AGRICULTURE' OR PrereqTech = 'TECH_HUNTING' 
OR PrereqTech = 'TECH_STONE_TOOLS'OR PrereqTech = 'TECH_POTTERY'OR PrereqTech = 'TECH_MYSTICISM'OR PrereqTech = 'TECH_ANIMAL_HUSBANDRY'OR PrereqTech = 'TECH_MASONRY'
OR PrereqTech = 'TECH_MINING'OR PrereqTech = 'TECH_SAILING'OR PrereqTech = 'TECH_WRITING'OR PrereqTech = 'TECH_CALENDAR'OR PrereqTech = 'TECH_WOOD_WORKING'
OR PrereqTech = 'TECH_THE_WHEEL'OR PrereqTech = 'TECH_BRONZE_WORKING';

UPDATE Units SET Era = 'ERA_CLASSICAL' WHERE PrereqTech = 'TECH_OPTICS' OR PrereqTech = 'TECH_MATHEMATICS' OR PrereqTech = 'TECH_HORSEBACK_RIDING' 
OR PrereqTech = 'TECH_CONSTRUCTION'OR PrereqTech = 'TECH_ART_THEORY'OR PrereqTech = 'TECH_PHILOSOPHY'OR PrereqTech = 'TECH_CURRENCY'OR PrereqTech = 'TECH_ENGINEERING'
OR PrereqTech = 'TECH_NATURAL_MEDICINE'OR PrereqTech = 'TECH_LITERATURE'OR PrereqTech = 'TECH_IRON_WORKING'OR PrereqTech = 'TECH_CARTOGRAPHY'
OR PrereqTech = 'TECH_DRAMA'OR PrereqTech = 'TECH_THEOLOGY' OR PrereqTech = 'TECH_MANIPULAR_SYSTEM' OR PrereqTech = 'TECH_ADVANCED_AGRICULTURE';

UPDATE Units SET Era = 'ERA_MEDIEVAL' WHERE PrereqTech = 'TECH_COMPASS' OR PrereqTech = 'TECH_CIVIL_SERVICE' OR PrereqTech = 'TECH_GUILDS' 
OR PrereqTech = 'TECH_PHYSICS'OR PrereqTech = 'TECH_STEEL'OR PrereqTech = 'TECH_EPHEMERIDES'OR PrereqTech = 'TECH_FEUDALISM'OR PrereqTech = 'TECH_DIVINE_RIGHT'
OR PrereqTech = 'TECH_MILITARY_ORDERS'OR PrereqTech = 'TECH_ALCHEMY'OR PrereqTech = 'TECH_ASTRONOMY'OR PrereqTech = 'TECH_EDUCATION'
OR PrereqTech = 'TECH_CHIVALRY'OR PrereqTech = 'TECH_MACHINERY';

UPDATE Units SET Era = 'ERA_RENAISSANCE' WHERE PrereqTech = 'TECH_NAVIGATION' OR PrereqTech = 'TECH_ACOUSTICS' OR PrereqTech = 'TECH_PRINTING_PRESS' 
OR PrereqTech = 'TECH_CHEMISTRY'OR PrereqTech = 'TECH_GUNPOWDER'OR PrereqTech = 'TECH_NAUTICAL_SCIENCE'OR PrereqTech = 'TECH_ADMINISTRATION'OR PrereqTech = 'TECH_DISCOVER'
OR PrereqTech = 'TECH_MILITARY_ORDERS'OR PrereqTech = 'TECH_ALCHEMY'OR PrereqTech = 'TECH_ASTRONOMY'OR PrereqTech = 'TECH_EDUCATION'
OR PrereqTech = 'TECH_FERTILIZER'OR PrereqTech = 'TECH_METALLURGY'OR PrereqTech = 'TECH_ARCHITECTURE'OR PrereqTech = 'TECH_SOVEREIGNTY'OR PrereqTech = 'TECH_NEW_HUMANISM'
OR PrereqTech = 'TECH_SCIENTIFIC_THEORY'OR PrereqTech = 'TECH_ECONOMICS';

CREATE TRIGGER EliteUnitsChangesANCIENT
AFTER INSERT ON Units
WHEN  NEW.ProjectPrereq !=-1
BEGIN
   UPDATE Units SET Era = 'ERA_ANCIENT' WHERE PrereqTech = 'TECH_FISHERY' OR PrereqTech = 'TECH_AGRICULTURE' OR PrereqTech = 'TECH_HUNTING' 
OR PrereqTech = 'TECH_STONE_TOOLS'OR PrereqTech = 'TECH_POTTERY'OR PrereqTech = 'TECH_MYSTICISM'OR PrereqTech = 'TECH_ANIMAL_HUSBANDRY'OR PrereqTech = 'TECH_MASONRY'
OR PrereqTech = 'TECH_MINING'OR PrereqTech = 'TECH_SAILING'OR PrereqTech = 'TECH_WRITING'OR PrereqTech = 'TECH_CALENDAR'OR PrereqTech = 'TECH_WOOD_WORKING'
OR PrereqTech = 'TECH_THE_WHEEL'OR PrereqTech = 'TECH_BRONZE_WORKING';
END;


CREATE TRIGGER EliteUnitsChangesCLASSICAL
AFTER INSERT ON Units
WHEN  NEW.ProjectPrereq !=-1
BEGIN
   UPDATE Units SET Era = 'ERA_CLASSICAL' WHERE PrereqTech = 'TECH_OPTICS' OR PrereqTech = 'TECH_MATHEMATICS' OR PrereqTech = 'TECH_HORSEBACK_RIDING' 
OR PrereqTech = 'TECH_CONSTRUCTION'OR PrereqTech = 'TECH_ART_THEORY'OR PrereqTech = 'TECH_PHILOSOPHY'OR PrereqTech = 'TECH_CURRENCY'OR PrereqTech = 'TECH_ENGINEERING'
OR PrereqTech = 'TECH_NATURAL_MEDICINE'OR PrereqTech = 'TECH_LITERATURE'OR PrereqTech = 'TECH_IRON_WORKING'OR PrereqTech = 'TECH_CARTOGRAPHY'
OR PrereqTech = 'TECH_DRAMA'OR PrereqTech = 'TECH_THEOLOGY' OR PrereqTech = 'TECH_MANIPULAR_SYSTEM' OR PrereqTech = 'TECH_ADVANCED_AGRICULTURE';
END;

CREATE TRIGGER EliteUnitsChangesMEDIEVAL
AFTER INSERT ON Units
WHEN  NEW.ProjectPrereq !=-1
BEGIN
   UPDATE Units SET Era = 'ERA_MEDIEVAL'  WHERE PrereqTech = 'TECH_COMPASS' OR PrereqTech = 'TECH_CIVIL_SERVICE' OR PrereqTech = 'TECH_GUILDS' 
OR PrereqTech = 'TECH_PHYSICS'OR PrereqTech = 'TECH_STEEL'OR PrereqTech = 'TECH_EPHEMERIDES'OR PrereqTech = 'TECH_FEUDALISM'OR PrereqTech = 'TECH_DIVINE_RIGHT'
OR PrereqTech = 'TECH_MILITARY_ORDERS'OR PrereqTech = 'TECH_ALCHEMY'OR PrereqTech = 'TECH_ASTRONOMY'OR PrereqTech = 'TECH_EDUCATION'
OR PrereqTech = 'TECH_CHIVALRY'OR PrereqTech = 'TECH_MACHINERY';
END;

CREATE TRIGGER EliteUnitsChangesRENAISSANCE
AFTER INSERT ON Units
WHEN  NEW.ProjectPrereq !=-1
BEGIN
   UPDATE Units SET Era = 'ERA_RENAISSANCE' WHERE PrereqTech = 'TECH_NAVIGATION' OR PrereqTech = 'TECH_ACOUSTICS' OR PrereqTech = 'TECH_PRINTING_PRESS' 
OR PrereqTech = 'TECH_CHEMISTRY'OR PrereqTech = 'TECH_GUNPOWDER'OR PrereqTech = 'TECH_NAUTICAL_SCIENCE'OR PrereqTech = 'TECH_ADMINISTRATION'OR PrereqTech = 'TECH_DISCOVER'
OR PrereqTech = 'TECH_MILITARY_ORDERS'OR PrereqTech = 'TECH_ALCHEMY'OR PrereqTech = 'TECH_ASTRONOMY'OR PrereqTech = 'TECH_EDUCATION'
OR PrereqTech = 'TECH_FERTILIZER'OR PrereqTech = 'TECH_METALLURGY'OR PrereqTech = 'TECH_ARCHITECTURE'OR PrereqTech = 'TECH_SOVEREIGNTY'OR PrereqTech = 'TECH_NEW_HUMANISM'
OR PrereqTech = 'TECH_SCIENTIFIC_THEORY'OR PrereqTech = 'TECH_ECONOMICS';
END;


INSERT  INTO Building_UnitClassMaxInstances(BuildingType,UnitClassType,ExtraMax)
SELECT 'BUILDING_GATE_ALL',Class,1  FROM Units WHERE  ProjectPrereq !=-1 AND(Era = 'ERA_ANCIENT' OR Era = 'ERA_CLASSICAL' OR Era = 'ERA_MEDIEVAL' OR Era = 'ERA_RENAISSANCE');


















	addSmallGenericButtonNZ( tech.WorkerSpeedModifier, "TXT_KEY_EUI_WORKER_SPEED_MOD" )
	addSmallGenericButtonNZ( tech.FirstFreeTechs, "TXT_KEY_EUI_FIRST_FREE_TECHS" )
	addSmallGenericButtonIF( tech.EndsGame and "TXT_KEY_EUI_ENDS_GAME" )
	addSmallGenericButtonIF( tech.ExtraWaterSeeFrom and "TXT_KEY_EUI_EXTRA_WATER_SEE_FROM" )
	addSmallGenericButtonIF( tech.WaterWork and "TXT_KEY_EUI_WATER_WORK" )

		<Replace Tag="TXT_KEY_PROMOTION_ARCHERY_COMBAT_HELP">
			<Text>
				[ICON_BULLET]克制[COLOR_POSITIVE_TEXT]方阵步兵[ENDCOLOR]，[COLOR_POSITIVE_TEXT]反装甲[ENDCOLOR]和[COLOR_POSITIVE_TEXT]陆军游猎[ENDCOLOR]单位。
				[NEWLINE][ICON_BULLET]被[COLOR_NEGATIVE_TEXT]近战[ENDCOLOR]和[COLOR_NEGATIVE_TEXT]攻城[ENDCOLOR]单位克制。
				[NEWLINE][ICON_BULLET]对[COLOR_POSITIVE_TEXT]开阔[ENDCOLOR]地形中的单位+25%[ICON_RANGE_STRENGTH]远程战斗力。
				[NEWLINE][ICON_BULLET]自身所处[COLOR_POSITIVE_TEXT]高度[ENDCOLOR]大于敌方单位时，每点高度+25%战斗力，上限50%。
				[NEWLINE][ICON_BULLET]没有地形防御加成。
				[NEWLINE][ICON_BULLET]当本单位与[COLOR_POSITIVE_TEXT]步兵[ENDCOLOR]、[COLOR_POSITIVE_TEXT]反制[ENDCOLOR]或[COLOR_POSITIVE_TEXT]炮台[ENDCOLOR]单位重叠时，如果被敌方[COLOR_POSITIVE_TEXT]近战[ENDCOLOR]单位攻击，本单位会自动反击。
				[NEWLINE][ICON_BULLET]每回合反击次数无限。
				[NEWLINE][ICON_BULLET]如果你的掩护单位被消灭，则不能反击。
				[NEWLINE][ICON_BULLET]远程攻击敌军时，若敌人处于被夹击状态，则对其增加15%攻击力，根据夹击数量每级额外+15%。
			</Text>
		</Replace>
	
		<Row>
			<Type>PROMOTION_FOCUS</Type>
			<Description>TXT_KEY_PROMOTION_FOCUS</Description>
			<Help>TXT_KEY_PROMOTION_FOCUS_HELP</Help>
			<Sound>AS2D_IF_LEVELUP</Sound>
			<PortraitIndex>12</PortraitIndex>
			<IconAtlas>MainRobotPromo_Atlas</IconAtlas>
			<PediaEntry>TXT_KEY_PROMOTION_FOCUS</PediaEntry>
			<PediaType>PEDIA_ATTRIBUTES</PediaType>
			<CannotBeChosen>true</CannotBeChosen>
			<MovesChange>-7</MovesChange>
			<RangedAttackModifier>100</RangedAttackModifier>
		</Row>

		<Row>
			<Type>PROMOTION_CAN_FOCUS</Type>
			<Description>TXT_KEY_PROMOTION_CAN_FOCUS</Description>
			<Help>TXT_KEY_PROMOTION_CAN_FOCUS_HELP</Help>
			<Sound>AS2D_IF_LEVELUP</Sound>
			<PortraitIndex>12</PortraitIndex>
			<IconAtlas>MainRobotPromo_Atlas</IconAtlas>
			<PediaEntry>TXT_KEY_PROMOTION_CAN_FOCUS</PediaEntry>
			<PediaType>PEDIA_ATTRIBUTES</PediaType>
			<CannotBeChosen>true</CannotBeChosen>
			<SplashDamagePercent>100</SplashDamagePercent>
			<SplashDamageRadius>1</SplashDamageRadius>
			<SplashDamagePlotUnitLimit>10</SplashDamagePlotUnitLimit>
			<SplashDamageFixed>1</SplashDamageFixed>
			<CollateralDamageFixed>1</CollateralDamageFixed>
			<CollateralDamagePercent>100</CollateralDamagePercent>
			<CollateralDamagePlotUnitLimit>10</CollateralDamagePlotUnitLimit>
		</Row>





		<Row Tag="TXT_KEY_SP_BTNNOTE_UNIT_FOCUS_ON_SHORT">
			<Text>启动战舰超级武器</Text>
		</Row>
		<Row Tag="TXT_KEY_SP_BTNNOTE_UNIT_FOCUS_ON">
			<Text>启动战舰主炮，[COLOR_MAGENTA]远程攻击力+100%[ENDCOLOR]，防御力减少50%，移动力减7,移除溅射伤害转变为单体打击，除此之外对堡垒额外追加300%攻击力。</Text>
		</Row>

		<Row Tag="TXT_KEY_SP_BTNNOTE_UNIT_FOCUS_OFF_SHORT">
			<Text>关闭战舰超级武器</Text>
		</Row>
		<Row Tag="TXT_KEY_SP_BTNNOTE_UNIT_FOCUS_OFF">
			<Text>切换为普通模式：战斗力与移动力回复正常。消耗本回合內所有剩余[ICON_MOVES]移动力。</Text>
		</Row>



		<Row Tag="TXT_KEY_PROMOTION_CAN_FOCUS">
			<Text>[COLOR_POSITIVE_TEXT]超级武器（关闭）[ENDCOLOR]</Text>
		</Row>

		<Row Tag="TXT_KEY_PROMOTION_CAN_FOCUS_HELP">
			<Text>未开启单体打击模式，开启后：[COLOR_MAGENTA]远程攻击力+100%[ENDCOLOR]，移动力减7,移除溅射伤害转变为单体打击，除此之外对堡垒额外追加300%攻击力。</Text>
		</Row>
		
		<Row Tag="TXT_KEY_PROMOTION_FOCUS">
			<Text>超级武器（开启）</Text>
		</Row>
		<Row Tag="TXT_KEY_PROMOTION_FOCUS_HELP">
			<Text>当前模式下[COLOR_MAGENTA]远程攻击力+100%[ENDCOLOR]，移动力减7,移除溅射伤害转变为单体打击，除此之外对堡垒额外追加300%攻击力。</Text>
		</Row>




		<!--大峡谷-->

		<Row>
			<Type>FEATURE_GRAND_CANYON</Type>
			<Description>TXT_KEY_FEATURE_GRAND_CANYON</Description>
			<Civilopedia>TXT_KEY_CIV5_FEATURES_GRAND_CANYON_TEXT</Civilopedia>
			<ArtDefineTag>ART_DEF_FEATURE_GRAND_CANYON</ArtDefineTag>
			<Movement>1</Movement>
			<SeeThrough>0</SeeThrough>
			<Impassable>false</Impassable>
			<InfluenceCost>-3</InfluenceCost>
			<NaturalWonder>false</NaturalWonder>
			<PseudoNaturalWonder>true</PseudoNaturalWonder>
			<NoCity>true</NoCity>
			<NoImprovement>true</NoImprovement>
			<Rough>true</Rough>
			<YieldNotAdditive>true</YieldNotAdditive>
			<InBorderHappiness>5</InBorderHappiness>
			<PortraitIndex>64</PortraitIndex>
			<IconAtlas>ROBOT_ICON_ATLAS5</IconAtlas>
		</Row>








	INSERT INTO Defines(Name, Value) VALUES('CITY_CRIME_SPY_YIELD', -6);
	INSERT INTO Defines(Name, Value) VALUES('CITY_CRIME_OPINION_REVOLUTIONARY_WAVE_YIELD', 10);
	INSERT INTO Defines(Name, Value) VALUES('CITY_CRIME_OPINION_CIVIL_RESISTANCE_YIELD', 4);
	INSERT INTO Defines(Name, Value) VALUES('CITY_CRIME_OPINION_DISSIDENTS_YIELD', 1);


	---建筑关联改良加成
INSERT INTO Building_ImprovementYieldModifiers(BuildingType,ImprovementType,YieldType,Yield) 
VALUES ('BUILDING_SILKROAD', 'IMPROVEMENT_LATIFUNDIUM', 'YIELD_GOLD',10),
       ('BUILDING_MONASTERY_OF_METEORA', 'IMPROVEMENT_HOLY_SITE', 'YIELD_FAITH',8);



	   -----科技提升战斗力

--UPDATE Units SET UnitTechUpgrade = 1  WHERE Type= 'UNIT_UNDERWATER_CARRIER'OR Type= 'UNIT_CRUSADER_ARTILLERY'OR Type= 'UNIT_CHINESE_WEISHI' OR Type= 'UNIT_TASKFORCE_141'OR Type= 'UNIT_STEALTH_HELICOPTER' OR Type= 'UNIT_PAKFA_T50';

INSERT INTO Unit_TechCombatStrength (UnitType, 	TechType,	CombatStrength) VALUES
--('UNIT_UNDERWATER_CARRIER',		'TECH_CYBERNETICS', 550),
--('UNIT_CHINESE_WEISHI',		'TECH_HOMO_SUPERIOR', 90),	
---('UNIT_TASKFORCE_141',		'TECH_GRID_COMPUTING',200),	 
--('UNIT_STEALTH_HELICOPTER',		'TECH_ORBITAL_SUSPENSION',250), 		
('UNIT_MECH',		'TECH_NEURAL_INTERFACE', 1500);

INSERT INTO Unit_TechRangedCombatStrength (UnitType, TechType,	RangedCombatStrength)VALUES	
--('UNIT_UNDERWATER_CARRIER',		'TECH_CYBERNETICS', 450),	
--('UNIT_CRUSADER_ARTILLERY',		'TECH_MECHANICAL_ENGINEERING', 320),	
--('UNIT_CHINESE_WEISHI',		'TECH_HOMO_SUPERIOR',450),
--('UNIT_PAKFA_T50',		'TECH_SPACE_COLONIZATION',500),	
--('UNIT_STEALTH_HELICOPTER',		'TECH_ORBITAL_SUSPENSION',250),	
('UNIT_MECH',		'TECH_NEURAL_INTERFACE', 1500);