-- Insert SQL Rules Here 

UPDATE UnitPromotions SET NearbyUnitPromotionBonus=100,NearbyUnitPromotionBonusRange=6,CombatBonusFromNearbyUnitPromotion= 'PROMOTION_WEAPON_SHIP' WHERE Type='PROMOTION_NAVAL_RANGED_CRUISER';
UPDATE UnitPromotions SET NearbyUnitPromotionBonus=100,NearbyUnitPromotionBonusRange=6,CombatBonusFromNearbyUnitPromotion= 'PROMOTION_WEAPON_SHIP' WHERE Type='PROMOTION_SUBMARINE_COMBAT';
UPDATE UnitPromotions SET NearbyUnitPromotionBonus=100,NearbyUnitPromotionBonusRange=6,CombatBonusFromNearbyUnitPromotion= 'PROMOTION_WEAPON_SHIP' WHERE Type='PROMOTION_NAVAL_CAPITAL_SHIP';
		<Row Tag="TXT_KEY_FEATURE_GRAND_CANYON">
			<Text>���������Ͽ��</Text>
			<Gender>neuter:no_article</Gender>
		</Row>
		<Row Tag="TXT_KEY_CIV5_FEATURES_GRAND_CANYON_TEXT">
			<Text>
				�������������Ͽ��(The Grand Canyon)λ����������ɣ����(Arizona)�����������������ԭ���ϲ���������������Ͽ��֮һ��Ҳ�ǵ�������Ȼ���ߴ��澰֮һ�����������Ͽ��(The Grand Canyon)������ӽ�3000ƽ��ǧ�ס���Ͽ��ȫ��446ǧ�ף�ƽ�����16ǧ�ף����1829�ף�ƽ����ȳ���1500�ף������2724ƽ��ǧ�ס�
				[NEWLINE]��Ͽ��ɽʯ��Ϊ��ɫ���ӹȵ׵������ֲ��ŴӺ���͵�����������ʱ�ڵ��Ҳ㣬���������ɫ�����죬���Һ��и�����������Ĵ��������ﻯʯ������Ϊ"��ĵ���ʷ�̿���"��
				[NEWLINE]��Ͽ���������Ǻ�ɫ�ľ��Ҷϲ㣬����Ȼ�ù��񹤵Ĵ������Կ̵��Ҳ���ᾡ����͵��֣�����һ������׵ľ޹ȣ�׿�Գ��ޱȵĲԾ�׳������Ϊ���ص��ǣ������������Ȼ���Ǻ�ɫ����������ԡ��������ʱ����̫�����ߵ�ǿ������ʯ��ɫ����ʱ��������ɫ��ʱ������ɫ��ʱ�����ǳ�ɫ�����������Գ�����Ȼ�İ�쵹��ء���ʱ�Ĵ�Ͽ�ȣ������ɾ����߲��ͷס���ã�Իã����˵ľ�ɫ��������������Ͽ�ȵ�ɫ����ṹ���ر��������ư�������������κε��ܼҺͻ��Ҷ��޷�ģ��ġ�
			</Text>
		</Row>


	<!--*********************����Դ������ʽ ********************-->
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
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_FACTORY',	         'YIELD_DISEASE', -50 UNION ALL  --����
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_NUCLEAR_PLANT',	     'YIELD_DISEASE', -40 UNION ALL  --�˵�վ
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_STEEL_MILL',	     'YIELD_DISEASE', -50 UNION ALL --��ֵ��Ӧ��
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_OIL_REFINERY',		 'YIELD_DISEASE', -50 UNION ALL --ʯ�;���
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_MINING_COMPANY',	 'YIELD_DISEASE', -50 UNION ALL --��ҵ��˾
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_COAL_PLANT',		 'YIELD_DISEASE', -50 UNION ALL --ú̿��
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_COAL_PLANT_EXTEND',	 'YIELD_DISEASE', -50 UNION ALL --ú��̿��
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_COAL_COMPANY',		 'YIELD_DISEASE', -50 UNION ALL --ú��̿��
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_GAS_PLANT',			 'YIELD_DISEASE', -50 UNION ALL --ȼ����
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_OIL_PLANT',			 'YIELD_DISEASE', -50 ;  --ȼʯ�ͳ�


INSERT INTO Policy_BuildingClassYieldChanges (PolicyType, BuildingClassType, YieldType,YieldChange)
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_FACTORY',	         'YIELD_DISEASE', -20 UNION ALL  --����
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_NUCLEAR_PLANT',	     'YIELD_DISEASE', -10 UNION ALL  --�˵�վ
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_STEEL_MILL',	     'YIELD_DISEASE', -10 UNION ALL --��ֵ��Ӧ��
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_OIL_REFINERY',		 'YIELD_DISEASE', -10 UNION ALL --ʯ�;���
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_MINING_COMPANY',	 'YIELD_DISEASE', -30 UNION ALL --��ҵ��˾
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_COAL_PLANT',		 'YIELD_DISEASE', -20 UNION ALL --ú̿��
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_COAL_PLANT_EXTEND',	 'YIELD_DISEASE', -20 UNION ALL --ú��̿��
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_COAL_COMPANY',		 'YIELD_DISEASE', -20 UNION ALL --ú��̿��
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_GAS_PLANT',			 'YIELD_DISEASE', -20 UNION ALL --ȼ����
SELECT  'POLICY_AI_REDUCE' , 'BUILDINGCLASS_OIL_PLANT',			 'YIELD_DISEASE', -20 ;  --ȼʯ�ͳ�




		<Row Tag="TXT_KEY_PROMOTION_URBAN">
			<Text>�ش�</Text>
		</Row>
		<Row Tag="TXT_KEY_PROMOTION_URBAN_HELP">
			<Text>��������ʱ��40%�ļ����ƻ�һ���Ƿ����������ձ�Ӫ����е����ľդ������ǽ���t�������Ǳ���˳�򣩣���ÿ�ι��������ó�������1�غϵֿ�״̬��������ɳ����������ֵ5%���˺���������λʱ��������λ����ͬ��ĵ��˽����»غ��޷��ж�,������50%���ʶ��ٽ�һ�����е������ͬ����Ч�����о�ӵ��������־��������Ч����</Text>
		</Row>



		<Row Tag="TXT_KEY_BUILDING_ANCIENT_CITY">
			<Text>����Τ����</Text>
		</Row>
		<!-- Help tags -->
		<Row Tag="TXT_KEY_WONDER_ANCIENT_CITY_HELP">
			<Text>
				ȫ������ũ�����������+1[ICON_FOOD]ʳ�+1[ICON_GOLD]��Ǯ��ȫ��ÿ��[ICON_RES_WHEAT]С��[ICON_RES_BARLEY]����+1[ICON_PRODUCTION]���ܣ�+1[ICON_GOLD]��Ǯ,+1[ICON_FOOD]ʳ�
			</Text>
		</Row>
		<!-- Quote tags -->
		<Row Tag="TXT_KEY_WONDER_ANCIENT_CITY_QUOTE">
			<Text>
				[NEWLINE]"��֪���꣬ũ���ȿ�����"[NEWLINE] - ����ӿຮ��[NEWLINE]
			</Text>
		</Row>
		<!-- Pedia tags -->
		<Row Tag="TXT_KEY_WONDER_ANCIENT_CITY_PEDIA">
			<Text>
				����Τ�����γ���2000��3000����ǰ����Щ�ں���һ��ǧ�׹�ͺͺ��ɽ��һ��һ�㿪�ѳ����������ɽ�������������ֻ��1/4���꣬��С��ֻ��4ƽ�������ҡ��ݲ�������ߵ����ﺣ����1500�����ϣ�����͵����ﴹֱ������420�����ϡ�Ϊ��ֹ������ʧ��������ǽ����ʯ�����ɣ�ʯǽ��߿ɴ�4�ף���Ͳ���2�ס�
				[NEWLINE]������ʷ���ϡ���ģ�Ӵ󡢹�ȷ�ʽ�����1992�걻�����Ų�ίԱ�����������Ļ��Ų���¼������Τ�����Ƿ��ɱ��ı�־֮һ��������������ӡ�ڸù��ĳ�Ʊ�ϡ�
			</Text>
		</Row>




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

