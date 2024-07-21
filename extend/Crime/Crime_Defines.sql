--------------------------------------------------------------------------------------------------
--GameOptions
--------------------------------------------------------------------------------------------------
UPDATE Yields SET ImageTexture = 'yieldatlas_128_crime.dds',IconString= '[ICON_CRIME]' WHERE Type = 'YIELD_CRIME';




INSERT INTO Crimes( Type,					Description, 		 IconString)
SELECT 'CRIME_VIOLENCE',					'TXT_KEY_CRIME_VIOLENCE',				'[ICON_VIOLENCE]' UNION ALL							
SELECT 'CRIME_THEFT',				'TXT_KEY_CRIME_THEFT',			'[ICON_THEFT]' UNION ALL	
SELECT 'CRIME_CULT',					'TXT_KEY_CRIME_CULT',				'[ICON_CULT]'UNION ALL
SELECT 'CRIME_REVOLUTION',					'TXT_KEY_CRIME_REVOLUTION',				'[ICON_REVOLUTION]';	


INSERT INTO Defines(Name,							Value)
SELECT 'CRIME_MIN_THRESHOLD_GAMESPEED_EPIC',		600 UNION ALL
SELECT 'CRIME_MIN_THRESHOLD_GAMESPEED_MARATHON',	700 UNION ALL
SELECT 'CRIME_MIN_THRESHOLD_GAMESPEED_QUICK',	    400 UNION ALL	
SELECT 'CRIME_MIN_THRESHOLD_GAMESPEED_STANDARD',	500 ; 

--==========================================================================================================================
--==========================================================================================================================
