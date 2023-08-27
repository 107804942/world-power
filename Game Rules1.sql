-- Insert SQL Rules Here 


		<!--ʱ̬����-->

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
			<Text>ʱ̬����</Text>
		</Row>
		<Row Tag="TXT_KEY_WONDER_DIABLO_PEDIA">
			<Text>
				��ѧ����Ĵ����ƺ�ͣ���ڰڶ������ۼ���ط�֧ѧ�Ƶĳ����ϣ��������Ƕ��п��ܽ�һ����Խ���ѹ��ڸ��ӵķ�������������Ȼ������ѧ�ϵ�ͻ�Ƽ������١�[NEWLINE][NEWLINE]ʱ̬����̽������ı仯��ȷ��δ���ı仯������׿Խ�ľ��ȡ�������������������ѧ������ɵģ�ʱ̬��������ͨ���߻�������价����ʵʱӰ�죬��Ԥ�������λ�á�����ѧӦ�õ����ٺͿ��ӻ�����ʱ����Ŀ�굽��֮ǰ�Ϳ�������Χ��ȷ��Ŀ���δ��λ�á���Ȼ���ڴ��л������������������ԣ���������С�����Χ��Щ�㣬������������ĸ����Զ����ӡ����ио���������ʽ��Ԥ��ȷ������Ĵ��ڸ��ɿ������糵������µ�λ������֯�Ļ����Ĺ��ߵ�Ԥ����Ȼ���ɿ���[NEWLINE][NEWLINE]����ʱ̬�����Ǹ������ʵ���֧��̽�ֻĵ����ۣ����Զ�Ĺ켣����Ԥ�⵽δ������������ҽ�ƹ���������NTC����������Ч������Ԥ��Ǳ�ڵļ�����ϸ������֮ǰ�����޸�������ġ��������ȵ�NTC��ѧ�ҽ�ϵ���˹-�޶���ѧ���������������������һ����ֹ�Ϳ�����������͵ļ���;�������Ǵ󵨵����ۻ�û����������ɱ��⡣
			</Text>
		</Row>
		<Row Tag="TXT_KEY_WONDER_DIABLO_QUOTE">
			<Text>[NEWLINE]"��ν��ѧ�������߼�����ѧ���ڣ������й�ʱ���ĺ��������п�ѧ��ͬ��������ͳɾ�ͳͳ������ˡ�"[NEWLINE]        �����¶�[NEWLINE]</Text>
		</Row>
		<Row Tag="TXT_KEY_WONDER_DIABLO_HELP">
			<Text>����۽���ʱ�����2����ѿƼ���</Text>
		</Row>




			<Row Tag="TXT_KEY_VOLCAN_EVENT_TITLE">
				<Text>��ɽ������</Text>
			</Row>
			<Row Tag="TXT_KEY_VOLCANO_EVENT_1">
				<Text>һ����ɽ������С��ģ�緢��</Text>
			</Row>
			<Row Tag="TXT_KEY_VOLCANO_EVENT_2">
				<Text>һ����ɽ�����˴��ģ�緢��</Text>
			</Row>
			<Row Tag="TXT_KEY_VOLCANO_EVENT_3">
				<Text>һ����ɽ�����˳����ģ�緢��</Text>
			</Row>


			����ÿ����ʯ��+1[ICON_RES_GUNPOWDER]��ҩ��


INSERT INTO Project_YieldModifiers(ProjectType,YieldType, Yield)VALUES
('PROJECT_BLIALI', 'YIELD_SCIENCE',300);

INSERT INTO Project_YieldChanges(ProjectType,YieldType, Yield)VALUES
('PROJECT_BLIALI', 'YIELD_PRODUCTION',300);




	<Row Tag="TXT_KEY_KNOWLEDGE_5_HELP">
				<Text>[COLOR_POSITIVE_TEXT]�鱨����[ENDCOLOR][NEWLINE]���һ��[ICON_SPY]��������͵�Ƽ��ٶ�+50%��[ICON_SPY]���ÿ�غϿ�͵ȡ���ڳ���100%��[ICON_RESEARCH]���С����Ρ�������������+2[ICON_RESEARCH]���С�</Text>
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

