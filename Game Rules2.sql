	addSmallGenericButtonNZ( tech.WorkerSpeedModifier, "TXT_KEY_EUI_WORKER_SPEED_MOD" )
	addSmallGenericButtonNZ( tech.FirstFreeTechs, "TXT_KEY_EUI_FIRST_FREE_TECHS" )
	addSmallGenericButtonIF( tech.EndsGame and "TXT_KEY_EUI_ENDS_GAME" )
	addSmallGenericButtonIF( tech.ExtraWaterSeeFrom and "TXT_KEY_EUI_EXTRA_WATER_SEE_FROM" )
	addSmallGenericButtonIF( tech.WaterWork and "TXT_KEY_EUI_WATER_WORK" )


	
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



