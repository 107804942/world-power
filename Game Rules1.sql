-- Insert SQL Rules Here 

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

