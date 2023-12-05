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



