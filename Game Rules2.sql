-- Insert SQL Rules Here 

-- The Following Promotions Require IsNearbyPromotion and NearbyRange to be set. IsNearbyPromotion is an "m_unitsAreaEffectPromotion" Unit
ALTER TABLE UnitPromotions ADD IsNearbyPromotion BOOLEAN DEFAULT 0;
ALTER TABLE UnitPromotions ADD NearbyRange INTEGER DEFAULT 0;
-- Set the Domain that Gets the Bonus
ALTER TABLE UnitPromotions ADD COLUMN 'GiveDomain' TEXT DEFAULT NULL REFERENCES Domains(Type);

-- Unit gives additional combat strength to nearby units? Requires IsNearbyPromotion, NearbyRange, and GiveDomain Set on this Promotion.
ALTER TABLE UnitPromotions ADD COLUMN 'GiveCombatMod' INTEGER DEFAULT 0;

-- Unit Gives HP to additional units if they kill an enemy units? Requires IsNearbyPromotion, NearbyRange, and GiveDomain Set on this Promotion.
ALTER TABLE UnitPromotions ADD COLUMN 'GiveHPHealedIfEnemyKilled' INTEGER DEFAULT 0;

-- Unit Gives additional XP in combat to nearby units? Requires IsNearbyPromotion, NearbyRange, and GiveDomain Set on this Promotion.
ALTER TABLE UnitPromotions ADD COLUMN 'GiveExperiencePercent' INTEGER DEFAULT 0;

-- Unit Gives a bonus to outside friendly lands unis? Requires IsNearbyPromotion, NearbyRange, and GiveDomain Set on this Promotion.
ALTER TABLE UnitPromotions ADD COLUMN 'GiveOutsideFriendlyLandsModifier' INTEGER DEFAULT 0;

-- Unit Gives extra attacks to nearby units? Requires IsNearbyPromotion, NearbyRange, and GiveDomain Set on this Promotion.
ALTER TABLE UnitPromotions ADD COLUMN 'GiveExtraAttacks' INTEGER DEFAULT 0;

-- Unit Gives extra defense to nearby units? Requires IsNearbyPromotion, NearbyRange, and GiveDomain Set on this Promotion.
ALTER TABLE UnitPromotions ADD COLUMN 'GiveDefenseMod' INTEGER DEFAULT 0;

-- Unit gives Invisibility to another Unit? Requires IsNearbyPromotion, NearbyRange, and GiveDomain Set on this Promotion.
ALTER TABLE UnitPromotions ADD COLUMN 'GiveInvisibility' BOOLEAN DEFAULT 0;

-- Unit only gives these effects at the start of the turn (works for GiveExperiencePercent, GiveCombatMod, GiveDefenseMod, GiveInvisibility, GiveOutsideFriendlyLandsModifier, GiveHPHealedIfEnemyKilled, GiveExtraAttacks)
ALTER TABLE UnitPromotions ADD COLUMN 'GiveOnlyOnStartingTurn' BOOLEAN DEFAULT 0;




