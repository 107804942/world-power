-- Insert SQL Rules Here 

UPDATE UnitPromotions SET NearbyUnitPromotionBonus=100,NearbyUnitPromotionBonusRange=6,CombatBonusFromNearbyUnitPromotion= 'PROMOTION_WEAPON_SHIP' WHERE Type='PROMOTION_NAVAL_RANGED_CRUISER';
UPDATE UnitPromotions SET NearbyUnitPromotionBonus=100,NearbyUnitPromotionBonusRange=6,CombatBonusFromNearbyUnitPromotion= 'PROMOTION_WEAPON_SHIP' WHERE Type='PROMOTION_SUBMARINE_COMBAT';
UPDATE UnitPromotions SET NearbyUnitPromotionBonus=100,NearbyUnitPromotionBonusRange=6,CombatBonusFromNearbyUnitPromotion= 'PROMOTION_WEAPON_SHIP' WHERE Type='PROMOTION_NAVAL_CAPITAL_SHIP';
		<Row Tag="TXT_KEY_FEATURE_GRAND_CANYON">
			<Text>科罗拉多大峡谷</Text>
			<Gender>neuter:no_article</Gender>
		</Row>
		<Row Tag="TXT_KEY_CIV5_FEATURES_GRAND_CANYON_TEXT">
			<Text>
				美国科罗拉多大峡谷(The Grand Canyon)位于美国亚利桑那州(Arizona)西北部，科罗拉多高原西南部。是世界上最大的峡谷之一，也是地球上自然界七大奇景之一。科罗拉多大峡谷(The Grand Canyon)总面积接近3000平方千米。大峡谷全长446千米，平均宽度16千米，最深处1829米，平均深度超过1500米，总面积2724平方千米。
				[NEWLINE]大峡谷山石多为红色，从谷底到顶部分布着从寒武纪到新生代各个时期的岩层，层次清晰，色调各异，并且含有各个地质年代的代表性生物化石，被称为"活的地质史教科书"。
				[NEWLINE]大峡谷两岸都是红色的巨岩断层，大自然用鬼斧神工的创造力镌刻得岩层嶙峋、层峦叠嶂，夹着一条深不见底的巨谷，卓显出无比的苍劲壮丽。更为奇特的是，这里的土壤虽然大都是褐色，但当它沐浴在阳光中时，依太阳光线的强弱，岩石的色彩则时而是深蓝色、时而是棕色、时而又是赤色，变幻无穷，彰显出大自然的斑斓诡秘。这时的大峡谷，宛若仙境般七彩缤纷、苍茫迷幻，迷人的景色令人流连忘返。峡谷的色彩与结构，特别是那气势磅礴的魅力，是任何雕塑家和画家都无法模拟的。
			</Text>
		</Row>


	<!--*********************新资源关联方式 ********************-->
	<Table name="Building_EmpireResourceAnds">
		<Column name="BuildingType" type="text" reference="Buildings(Type)"/>
		<Column name="ResourceType" type="text" reference="Resources(Type)"/>
		<Column name="AllowsImport" type="boolean" default="true"/>
	</Table>

	<Table name="Building_EmpireResourceOrs">
		<Column name="BuildingType" type="text" reference="Buildings(Type)"/>
		<Column name="ResourceType" type="text" reference="Resources(Type)"/>
		<Column name="AllowsImport" type="boolean" default="true"/>
	</Table>




INSERT INTO Policy_BuildingClassYieldModifiers (PolicyType, BuildingClassType, YieldType,YieldMod)
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_FACTORY',	         'YIELD_DISEASE', -50 UNION ALL  --工厂
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_NUCLEAR_PLANT',	     'YIELD_DISEASE', -40 UNION ALL  --核电站
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_STEEL_MILL',	     'YIELD_DISEASE', -50 UNION ALL --增值反应堆
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_OIL_REFINERY',		 'YIELD_DISEASE', -50 UNION ALL --石油精炼
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_MINING_COMPANY',	 'YIELD_DISEASE', -50 UNION ALL --矿业公司
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_COAL_PLANT',		 'YIELD_DISEASE', -50 UNION ALL --煤炭厂
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_COAL_PLANT_EXTEND',	 'YIELD_DISEASE', -50 UNION ALL --煤焦炭厂
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_COAL_COMPANY',		 'YIELD_DISEASE', -50 UNION ALL --煤焦炭厂
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_GAS_PLANT',			 'YIELD_DISEASE', -50 UNION ALL --燃气厂
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_OIL_PLANT',			 'YIELD_DISEASE', -50 ;  --燃石油厂


INSERT INTO Policy_BuildingClassYieldChanges (PolicyType, BuildingClassType, YieldType,YieldChange)
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_FACTORY',	         'YIELD_DISEASE', -20 UNION ALL  --工厂
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_NUCLEAR_PLANT',	     'YIELD_DISEASE', -10 UNION ALL  --核电站
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_STEEL_MILL',	     'YIELD_DISEASE', -10 UNION ALL --增值反应堆
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_OIL_REFINERY',		 'YIELD_DISEASE', -10 UNION ALL --石油精炼
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_MINING_COMPANY',	 'YIELD_DISEASE', -30 UNION ALL --矿业公司
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_COAL_PLANT',		 'YIELD_DISEASE', -20 UNION ALL --煤炭厂
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_COAL_PLANT_EXTEND',	 'YIELD_DISEASE', -20 UNION ALL --煤焦炭厂
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_COAL_COMPANY',		 'YIELD_DISEASE', -20 UNION ALL --煤焦炭厂
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_GAS_PLANT',			 'YIELD_DISEASE', -20 UNION ALL --燃气厂
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_OIL_PLANT',			 'YIELD_DISEASE', -20 ;  --燃石油厂




		<Row Tag="TXT_KEY_PROMOTION_URBAN">
			<Text>重创</Text>
		</Row>
		<Row Tag="TXT_KEY_PROMOTION_URBAN_HELP">
			<Text>攻击城市时有40%的几率破坏一个城防建筑（按照兵营，军械所，木栅栏，城墙，瞭望塔，城堡的顺序），且每次攻击均可让城市陷入1回合抵抗状态，额外造成城市最大生命值5%的伤害。攻击单位时被攻击单位及其同格的敌人将在下回合无法行动,并且有50%几率对临近一格所有敌人造成同样的效果（敌军拥有人造意志晋升则无效）。</Text>
		</Row>



		<Row Tag="TXT_KEY_BUILDING_ANCIENT_CITY">
			<Text>巴纳韦梯田</Text>
		</Row>
		<!-- Help tags -->
		<Row Tag="TXT_KEY_WONDER_ANCIENT_CITY_HELP">
			<Text>
				全国所有农场、梯田、圩田+1[ICON_FOOD]食物，+1[ICON_GOLD]金钱。全国每处[ICON_RES_WHEAT]小麦、[ICON_RES_BARLEY]大麦+1[ICON_PRODUCTION]产能，+1[ICON_GOLD]金钱,+1[ICON_FOOD]食物。
			</Text>
		</Row>
		<!-- Quote tags -->
		<Row Tag="TXT_KEY_WONDER_ANCIENT_CITY_QUOTE">
			<Text>
				[NEWLINE]"乃知大寒岁，农者尤苦辛。"[NEWLINE] - 《村居苦寒》[NEWLINE]
			</Text>
		</Row>
		<!-- Pedia tags -->
		<Row Tag="TXT_KEY_WONDER_ANCIENT_CITY_PEDIA">
			<Text>
				巴纳韦梯田形成于2000至3000多年前。这些在海拔一两千米光秃秃的山上一点一点开垦出来的梯田，依山而建。面积最大的只有1/4公顷，最小的只有4平方米左右。据测量，最高的梯田海拔在1500米以上，与最低的梯田垂直距离在420米以上。为防止土壤流失，梯田外墙多用石块砌成，石墙最高可达4米，最低不到2米。
				[NEWLINE]因其历史古老、规模庞大、灌溉方式巧妙，于1992年被世界遗产委员会列入世界文化遗产名录。巴纳韦梯田是菲律宾的标志之一，其美丽的形象印在该国的钞票上。
			</Text>
		</Row>




		<!--时态演算-->

		<Row>
			<Type>BUILDING_DIABLO</Type>
			<BuildingClass>BUILDINGCLASS_DIABLO</BuildingClass>
			<Description>TXT_KEY_BUILDING_DIABLO</Description>
			<Help>TXT_KEY_WONDER_DIABLO_HELP</Help>
			<Civilopedia>TXT_KEY_WONDER_DIABLO_PEDIA</Civilopedia>
			<Quote>TXT_KEY_WONDER_DIABLO_QUOTE</Quote>
			<Cost>17000</Cost>
			<ConquestProb>100</ConquestProb>
			<PrereqTech>TECH_OPTICALCOMPUTERS</PrereqTech>
			<NukeImmune>true</NukeImmune>
			<HurryCostModifier>-1</HurryCostModifier>
			<MinAreaSize>-1</MinAreaSize>
			<FreeTechs>3</FreeTechs>
			<IconAtlas>ROBOT_ICON_ATLAS2</IconAtlas>
			<PortraitIndex>74</PortraitIndex>
			<WonderSplashImage>DIABLO.dds</WonderSplashImage>
			<WonderSplashAnchor>L,T</WonderSplashAnchor>
		</Row>


		<Row Tag="TXT_KEY_BUILDING_DIABLO">
			<Text>时态演算</Text>
		</Row>
		<Row Tag="TXT_KEY_WONDER_DIABLO_PEDIA">
			<Text>
				数学领域的创新似乎停滞在摆动三段论及相关分支学科的出现上，导致人们对有可能进一步超越解脱过于复杂的方法不抱期望。然而，数学上的突破即将来临。[NEWLINE][NEWLINE]时态演算探讨最近的变化来确定未来的变化，具有卓越的精度。接受物理世界是由数学性质组成的，时态演算逆向通过策划生物对其环境的实时影响，来预测生物的位置。当数学应用到跟踪和可视化技术时，在目标到达之前就可以在误差范围内确定目标的未来位置。虽然对于带有混乱驱动程序的生物而言，如昆虫或较小动物，误差范围有些广，但精度随主题的复杂性而增加。对有感觉的生命形式的预测比非生命的存在更可靠，对如车辆或军事单位的有组织的或成组的工具的预测仍然更可靠。[NEWLINE][NEWLINE]近代时态演算是该领域的实验分支，探讨荒诞理论；如多远的轨迹可以预测到未来。在手术和医疗功能中利用NTC会产生神奇的效果，可预防潜在的疾病和细胞破裂之前进行修复。热情的、几乎狂热的NTC数学家结合德里斯-罗恩力学，即暗能量的物理，计算出一个阻止和控制宇宙的膨胀的假设途径。他们大胆的理论还没有其他猜想可比拟。
			</Text>
		</Row>
		<Row Tag="TXT_KEY_WONDER_DIABLO_QUOTE">
			<Text>[NEWLINE]"所谓科学，包括逻辑和数学在内，都是有关时代的函数，所有科学连同它的理想和成就统统都是如此。"[NEWLINE]        ——穆尔[NEWLINE]</Text>
		</Row>
		<Row Tag="TXT_KEY_WONDER_DIABLO_HELP">
			<Text>该奇观建成时，获得2个免费科技。</Text>
		</Row>




			<Row Tag="TXT_KEY_VOLCAN_EVENT_TITLE">
				<Text>火山爆发！</Text>
			</Row>
			<Row Tag="TXT_KEY_VOLCANO_EVENT_1">
				<Text>一处火山发生了小规模喷发。</Text>
			</Row>
			<Row Tag="TXT_KEY_VOLCANO_EVENT_2">
				<Text>一处火山发生了大规模喷发。</Text>
			</Row>
			<Row Tag="TXT_KEY_VOLCANO_EVENT_3">
				<Text>一处火山发生了超大规模喷发。</Text>
			</Row>


			本城每个采石场+1[ICON_RES_GUNPOWDER]火药。


INSERT INTO Project_YieldModifiers(ProjectType,YieldType, Yield)VALUES
('PROJECT_BLIALI', 'YIELD_SCIENCE',300);

INSERT INTO Project_YieldChanges(ProjectType,YieldType, Yield)VALUES
('PROJECT_BLIALI', 'YIELD_PRODUCTION',300);




	<Row Tag="TXT_KEY_KNOWLEDGE_5_HELP">
				<Text>[COLOR_POSITIVE_TEXT]情报网络[ENDCOLOR][NEWLINE]获得一个[ICON_SPY]间谍，间谍偷科技速度+50%。[ICON_SPY]间谍每回合可偷取所在城市100%的[ICON_RESEARCH]科研。地牢、监禁所、警察局+2[ICON_RESEARCH]科研。</Text>
			</Row>
		

-----------------------------------------------------------------------------------------------------
--Technologies
-----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Technology_Health (TechType TEXT DEFAULT NULL, Yield INTEGER DEFAULT 0);

INSERT INTO Technology_Health (TechType,	Yield)
SELECT 'TECH_ANIMAL_HUSBANDRY',				-1 UNION ALL
SELECT 'TECH_THE_WHEEL',					-1 UNION ALL
SELECT 'TECH_SAILING',						-1 UNION ALL
SELECT 'TECH_IRON_WORKING',					-1 UNION ALL
SELECT 'TECH_OPTICS',						-1 UNION ALL
SELECT 'TECH_COMPASS',						-2 UNION ALL
SELECT 'TECH_ASTRONOMY',					-1 UNION ALL
SELECT 'TECH_NAVIGATION',					-2 UNION ALL
SELECT 'TECH_COMBUSTION',					-2 UNION ALL
SELECT 'TECH_FLIGHT',						-2 UNION ALL
SELECT 'TECH_GLOBALIZATION',				-3 UNION ALL
SELECT 'TECH_PRINTING_PRESS',				1 UNION ALL
SELECT 'TECH_ARCHITECTURE',					1 UNION ALL
SELECT 'TECH_EDUCATION',					1 UNION ALL
SELECT 'TECH_POTTERY',						1 UNION ALL
SELECT 'TECH_ENGINEERING',					1 UNION ALL
SELECT 'TECH_CHEMISTRY',					1 UNION ALL
SELECT 'TECH_SCIENTIFIC_THEORY',			1 UNION ALL
SELECT 'TECH_BIOLOGY',						1 UNION ALL
SELECT 'TECH_ELECTRICITY',					1 UNION ALL
SELECT 'TECH_REFRIGERATION',				1 UNION ALL
SELECT 'TECH_PENICILIN',					1 UNION ALL
SELECT 'TECH_ECOLOGY',						1 UNION ALL
SELECT 'TECH_SATELLITES',					1 UNION ALL
SELECT 'TECH_ROBOTICS',						1 UNION ALL
SELECT 'TECH_NANOTECHNOLOGY',				1;

