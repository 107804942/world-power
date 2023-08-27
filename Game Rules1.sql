-- Insert SQL Rules Here 


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

