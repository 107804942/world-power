	addSmallGenericButtonNZ( tech.WorkerSpeedModifier, "TXT_KEY_EUI_WORKER_SPEED_MOD" )
	addSmallGenericButtonNZ( tech.FirstFreeTechs, "TXT_KEY_EUI_FIRST_FREE_TECHS" )
	addSmallGenericButtonIF( tech.EndsGame and "TXT_KEY_EUI_ENDS_GAME" )
	addSmallGenericButtonIF( tech.ExtraWaterSeeFrom and "TXT_KEY_EUI_EXTRA_WATER_SEE_FROM" )
	addSmallGenericButtonIF( tech.WaterWork and "TXT_KEY_EUI_WATER_WORK" )

		<Replace Tag="TXT_KEY_PROMOTION_ARCHERY_COMBAT_HELP">
			<Text>
				[ICON_BULLET]����[COLOR_POSITIVE_TEXT]���󲽱�[ENDCOLOR]��[COLOR_POSITIVE_TEXT]��װ��[ENDCOLOR]��[COLOR_POSITIVE_TEXT]½������[ENDCOLOR]��λ��
				[NEWLINE][ICON_BULLET]��[COLOR_NEGATIVE_TEXT]��ս[ENDCOLOR]��[COLOR_NEGATIVE_TEXT]����[ENDCOLOR]��λ���ơ�
				[NEWLINE][ICON_BULLET]��[COLOR_POSITIVE_TEXT]����[ENDCOLOR]�����еĵ�λ+25%[ICON_RANGE_STRENGTH]Զ��ս������
				[NEWLINE][ICON_BULLET]��������[COLOR_POSITIVE_TEXT]�߶�[ENDCOLOR]���ڵз���λʱ��ÿ��߶�+25%ս����������50%��
				[NEWLINE][ICON_BULLET]û�е��η����ӳɡ�
				[NEWLINE][ICON_BULLET]������λ��[COLOR_POSITIVE_TEXT]����[ENDCOLOR]��[COLOR_POSITIVE_TEXT]����[ENDCOLOR]��[COLOR_POSITIVE_TEXT]��̨[ENDCOLOR]��λ�ص�ʱ��������з�[COLOR_POSITIVE_TEXT]��ս[ENDCOLOR]��λ����������λ���Զ�������
				[NEWLINE][ICON_BULLET]ÿ�غϷ����������ޡ�
				[NEWLINE][ICON_BULLET]�������ڻ���λ���������ܷ�����
				[NEWLINE][ICON_BULLET]Զ�̹����о�ʱ�������˴��ڱ��л�״̬�����������15%�����������ݼл�����ÿ������+15%��
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
			<Text>����ս����������</Text>
		</Row>
		<Row Tag="TXT_KEY_SP_BTNNOTE_UNIT_FOCUS_ON">
			<Text>����ս�����ڣ�[COLOR_MAGENTA]Զ�̹�����+100%[ENDCOLOR]������������50%���ƶ�����7,�Ƴ������˺�ת��Ϊ������������֮��Ա��ݶ���׷��300%��������</Text>
		</Row>

		<Row Tag="TXT_KEY_SP_BTNNOTE_UNIT_FOCUS_OFF_SHORT">
			<Text>�ر�ս����������</Text>
		</Row>
		<Row Tag="TXT_KEY_SP_BTNNOTE_UNIT_FOCUS_OFF">
			<Text>�л�Ϊ��ͨģʽ��ս�������ƶ����ظ����������ı��غσ�����ʣ��[ICON_MOVES]�ƶ�����</Text>
		</Row>



		<Row Tag="TXT_KEY_PROMOTION_CAN_FOCUS">
			<Text>[COLOR_POSITIVE_TEXT]�����������رգ�[ENDCOLOR]</Text>
		</Row>

		<Row Tag="TXT_KEY_PROMOTION_CAN_FOCUS_HELP">
			<Text>δ����������ģʽ��������[COLOR_MAGENTA]Զ�̹�����+100%[ENDCOLOR]���ƶ�����7,�Ƴ������˺�ת��Ϊ������������֮��Ա��ݶ���׷��300%��������</Text>
		</Row>
		
		<Row Tag="TXT_KEY_PROMOTION_FOCUS">
			<Text>����������������</Text>
		</Row>
		<Row Tag="TXT_KEY_PROMOTION_FOCUS_HELP">
			<Text>��ǰģʽ��[COLOR_MAGENTA]Զ�̹�����+100%[ENDCOLOR]���ƶ�����7,�Ƴ������˺�ת��Ϊ������������֮��Ա��ݶ���׷��300%��������</Text>
		</Row>



