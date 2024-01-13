	<Instance Name="ProductionInstance">
		<GridButton ID="PQbox" Anchor="L,T" Style="ListItem" Size="270,38" ToolTipType="EUI_ItemTooltip" >
			<Stack Anchor="L,C" Offset="40,-1" Padding="4" StackGrowth="Right" >
				<Label ID="PQrank" Anchor="L,C" Font="TwCenMT24" />
				<Image ID="PQportrait" Anchor="L,C" Texture="UnitPortraitsAncientMedieval360.dds" Size="45.45"/>
				<Stack Anchor="L,C" Padding="6" StackGrowth="Bottom" >
					<Label ID="PQname" Font="TwCenMT16"/>
					<Label ID="PQturns" Font="TwCenMT16"/>
				</Stack>
			</Stack>
			<Box ID="PQdisabled" Anchor="L,T" Size="270,38" Color="27.0.64.128" />
			<Button ID="PQremove" Anchor="L,C" Offset="4,-1" Size="32,32" Texture="IconFrame32Delete.dds" ToolTip="TXT_KEY_CITYVIEW_Q_X_TEXT" />
			<Image Anchor="L,B" Texture="bar340x2.dds" Size="270,1" Color="White.128" />
		</GridButton>
	</Instance>