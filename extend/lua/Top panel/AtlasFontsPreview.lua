
--[[
  NOTE: Due to a bug in the core engine, icons at glyph position 32 are always blank, this currently affects
    ICON_UNIT_ENGLISH_LONGBOWMAN
    ICON_UNIT_JET_FIGHTER
    ICON_TECH_BANKING
    ICON_PROMOTION_MARCH
    ICON_BUILD_REMOVE_JUNGLE / ICON_BUILD_REMOVE_FOREST
    ICON_BUILDING_SOLAR_PLANT
    ICON_WONDER_HEROIC_EPIC
]]--
--[[
  In general, the icon name is the item's type prefixed with ICON_

  BUILDING_XYZ      --> ICON_BUILDING_XYZ (excluding wonders)
  BUILDING_XYZ      --> ICON_WONDER_XYZ (wonders only)
  CIVILIZATION_XYZ  --> ICON_CIV_XYZ (core and DLC01 civs only)
  UNIT_XYZ          --> ICON_UNIT_XYZ (core and DLC01 civs only)
  TECH_XYZ          --> ICON_TECH_XYZ
  RESOURCE_XYZ      --> ICON_RESOURCE_XYZ
  PROMOTION_XYZ     --> ICON_PROMOTION_XYZ
  PROJECT_XYZ       --> ICON_PROJECT_XYZ
  FEATURE_XYZ       --> ICON_NWONDER_XYZ (Natural Wonder features only)
  PROCESS_XYZ       --> ICON_PROCESS_XYZ
  SPECIALIST_XYZ    --> ICON_SPECIALIST_XYZ
  AUTOMATE_XYZ      --> ICON_AUTOMATE_XYZ
  BUILD_XYZ         --> ICON_BUILD_XYZ
  MISSION_XYZ       --> ICON_MISSION_XYZ (Missions with an icon only)
  COMMAND_XYZ       --> ICON_COMMAND_XYZ (Commands with an icon only)
  INTERFACEMODE_XYZ --> ICON_MODE_XYZ (Modes with an icon only)
]]--

--[[
  Icons not following the general case and/or duplicate icons

  ICON_CIV_UNKNOWN      (? on a blue background)
  ICON_FUNCTION_GENERIC (multi-pointed star from the tech tree)

  ICON_CITIZEN_GREEN
  ICON_CITIZEN_ORANGE
  ICON_CITIZEN_BLUE
  ICON_CITIZEN_GOLD
  ICON_CITIZEN_MAGENTA
  ICON_CITIZEN_RED
  ICON_CITIZEN_BLACK
  ICON_CITIZEN_BLACK_ALPHA

  ICON_TILE_WORKED    (Green citizen)
  ICON_TILE_UNWORKED  (Black alpha citizen)
  ICON_TILE_FORCED    (Green lock)
  ICON_TILE_CITY      (Green city)
  ICON_TILE_SWAP      (Black double arrows)
  ICON_TILE_BLOCKADED (Red crossed swords)
]]--

sLineN = "[NEWLINE][NEWLINE]"
local sLine1 = "The horsemen [ICON_UNIT_HORSEMAN] watched as the Pyramids [ICON_WONDER_PYRAMID] rose from the sands" .. sLineN
local sLine2 = "Satellites [ICON_TECH_SATELLITES] lead to the Apollo Program [ICON_PROJECT_APOLLO_PROGRAM] and spaceship parts [ICON_UNIT_SS_ENGINE]" .. sLineN
local sLine3 = "Iron [ICON_RESOURCE_IRON] requires mining [ICON_TECH_MINING] skills before workers [ICON_UNIT_WORKER] can build mines" .. sLineN
local sLine4 = "The Mongolian [ICON_CIV_MONGOL] Keshiks [ICON_UNIT_MONGOLIAN_KESHIK] rode out to plunder El Dorado [ICON_NWONDER_EL_DORADO]" .. sLineN

Controls.Preview:SetText(string.format("%s%s%s%s", sLine1, sLine2, sLine3, sLine4))

local sUnit1 = "[ICON_UNIT_SETTLER] [ICON_UNIT_WORKER] [ICON_UNIT_WORKBOAT] [ICON_UNIT_WARRIOR] [ICON_UNIT_AZTEC_JAGUAR] [ICON_UNIT_SCOUT] [ICON_UNIT_ARCHER] [ICON_UNIT_BARBARIAN_ARCHER] [ICON_UNIT_SPEARMAN] [ICON_UNIT_BARBARIAN_SPEARMAN]" .. sLineN
local sUnit2 = "[ICON_UNIT_GREEK_HOPLITE] [ICON_UNIT_PERSIAN_IMMORTAL] [ICON_UNIT_CHARIOT_ARCHER] [ICON_UNIT_EGYPTIAN_WARCHARIOT] [ICON_UNIT_SWORDSMAN] [ICON_UNIT_BARBARIAN_SWORDSMAN] [ICON_UNIT_ROMAN_LEGION] [ICON_UNIT_IROQUOIAN_MOHAWKWARRIOR] [ICON_UNIT_HORSEMAN] [ICON_UNIT_GREEK_COMPANIONCAVALRY]" .. sLineN
local sUnit3 = "[ICON_UNIT_INDIAN_WARELEPHANT] [ICON_UNIT_CATAPULT] [ICON_UNIT_ROMAN_BALLISTA] [ICON_UNIT_GALLEY] [ICON_UNIT_TRIREME] [ICON_UNIT_BARBARIAN_WARRIOR] [ICON_UNIT_KNIGHT] [ICON_UNIT_SONGHAI_MUSLIMCAVALRY] [ICON_UNIT_ARABIAN_CAMELARCHER] [ICON_UNIT_SIAMESE_WARELEPHANT]" .. sLineN
local sUnit4 = "[ICON_UNIT_CROSSBOWMAN] [ICON_UNIT_ENGLISH_LONGBOWMAN] [ICON_UNIT_CHINESE_CHUKONU] [ICON_UNIT_PIKEMAN] [ICON_UNIT_GERMAN_LANDSKNECHT] [ICON_UNIT_LONGSWORDSMAN] [ICON_UNIT_JAPANESE_SAMURAI] [ICON_UNIT_MUSKETMAN] [ICON_UNIT_AMERICAN_MINUTEMAN] [ICON_UNIT_FRENCH_MUSKETEER]" .. sLineN
local sUnit5 = "[ICON_UNIT_OTTOMAN_JANISSARY] [ICON_UNIT_TREBUCHET] [ICON_UNIT_CARAVEL] [ICON_UNIT_CANNON] [ICON_UNIT_LANCER] [ICON_UNIT_OTTOMAN_SIPAHI] [ICON_UNIT_RIFLEMAN] [ICON_UNIT_CAVALRY] [ICON_UNIT_RUSSIAN_COSSACK] [ICON_UNIT_FRIGATE]" .. sLineN
local sUnit6 = "[ICON_UNIT_ENGLISH_SHIPOFTHELINE] [ICON_UNIT_IRONCLAD] [ICON_UNIT_INFANTRY] [ICON_UNIT_ARTILLERY] [ICON_UNIT_TANK] [ICON_UNIT_PARATROOPER] [ICON_UNIT_ANTI_TANK_GUN] [ICON_UNIT_ANTI_AIRCRAFT_GUN] [ICON_UNIT_FIGHTER] [ICON_UNIT_BOMBER]" .. sLineN
local sUnit7 = "[ICON_UNIT_DESTROYER] [ICON_UNIT_BATTLESHIP] [ICON_UNIT_SUBMARINE] [ICON_UNIT_CARRIER] [ICON_UNIT_ATOMIC_BOMB] [ICON_UNIT_ROCKET_ARTILLERY] [ICON_UNIT_MECHANIZED_INFANTRY] [ICON_UNIT_MODERN_ARMOR] [ICON_UNIT_HELICOPTER_GUNSHIP] [ICON_UNIT_MOBILE_SAM]" .. sLineN
local sUnit8 = "[ICON_UNIT_GUIDED_MISSILE] [ICON_UNIT_JET_FIGHTER] [ICON_UNIT_MISSILE_CRUISER] [ICON_UNIT_NUCLEAR_SUBMARINE] [ICON_UNIT_NUCLEAR_MISSILE] [ICON_UNIT_MECH] [ICON_UNIT_STEALTH_BOMBER] [ICON_UNIT_FRENCH_FOREIGNLEGION] [ICON_UNIT_GERMAN_PANZER] [ICON_UNIT_JAPANESE_ZERO]" .. sLineN
local sUnit9 = "[ICON_UNIT_AMERICAN_B17] [ICON_UNIT_ARTIST] [ICON_UNIT_SCIENTIST] [ICON_UNIT_MERCHANT] [ICON_UNIT_ENGINEER] [ICON_UNIT_GREAT_GENERAL] [ICON_UNIT_SS_BOOSTER] [ICON_UNIT_SS_COCKPIT] [ICON_UNIT_SS_STASIS_CHAMBER] [ICON_UNIT_SS_ENGINE]" .. sLineN
sUnits = sUnit1 .. sUnit2 .. sUnit3 .. sUnit4 .. sUnit5 .. sUnit6 .. sUnit7 .. sUnit8 .. sUnit9

ContextPtr:SetHide(true)