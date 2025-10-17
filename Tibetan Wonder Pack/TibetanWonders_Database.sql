-- ============================================================================
-- TIBETAN WONDER PACK - COMPLETE DATABASE
-- ============================================================================
-- A comprehensive collection of 8 Tibetan-themed wonders spanning Ancient to Industrial eras
-- Features unique mechanics reflecting Tibet's rich cultural and religious heritage
--
-- Author: Coiot
-- Version: 1.0
-- Compatible with: Civilization V (Base + G&K + BNW)
-- ============================================================================

-- ============================================================================
-- BUILDING CLASSES
-- ============================================================================
-- Defines the building classes for all 8 Tibetan wonders

INSERT INTO BuildingClasses
	(Type, DefaultBuilding, Description, MaxGlobalInstances)
VALUES
	('BUILDINGCLASS_YUMBU_LAGANG', 'BUILDING_YUMBU_LAGANG', 'TXT_KEY_BUILDING_YUMBU_LAGANG', 1),
	('BUILDINGCLASS_JOKHANG_TEMPLE', 'BUILDING_JOKHANG_TEMPLE', 'TXT_KEY_BUILDING_JOKHANG_TEMPLE', 1),
	('BUILDINGCLASS_SAMYE_MONASTERY', 'BUILDING_SAMYE_MONASTERY', 'TXT_KEY_BUILDING_SAMYE_MONASTERY', 1),
	('BUILDINGCLASS_SAKYA_LIBRARY', 'BUILDING_SAKYA_LIBRARY', 'TXT_KEY_BUILDING_SAKYA_LIBRARY', 1),
	('BUILDINGCLASS_POTALA_PALACE', 'BUILDING_POTALA_PALACE', 'TXT_KEY_BUILDING_POTALA_PALACE', 1),
	('BUILDINGCLASS_NORBULINGKA', 'BUILDING_NORBULINGKA', 'TXT_KEY_BUILDING_NORBULINGKA', 1),
	('BUILDINGCLASS_GYANTSE_KUMBUM', 'BUILDING_GYANTSE_KUMBUM', 'TXT_KEY_BUILDING_GYANTSE_KUMBUM', 1),
	('BUILDINGCLASS_DEGE_PARKHANG', 'BUILDING_DEGE_PARKHANG', 'TXT_KEY_BUILDING_DEGE_PARKHANG', 1);

-- ============================================================================
-- BUILDINGS
-- ============================================================================
-- Defines all 8 Tibetan wonders with their complete stats and properties

-- ANCIENT ERA
INSERT INTO Buildings
	(Type, BuildingClass, Description, Help, Civilopedia, Quote, Cost, PrereqTech, MaxStartEra, SpecialistType, GreatPeopleRateChange, NukeImmune, HurryCostModifier, MinAreaSize, ConquestProb, Mountain, Defense, IconAtlas, PortraitIndex, WonderSplashImage, WonderSplashAnchor)
VALUES
	('BUILDING_YUMBU_LAGANG', 'BUILDINGCLASS_YUMBU_LAGANG', 'TXT_KEY_BUILDING_YUMBU_LAGANG', 'TXT_KEY_WONDER_YUMBU_LAGANG_HELP', 'TXT_KEY_WONDER_YUMBU_LAGANG_PEDIA', 'TXT_KEY_WONDER_YUMBU_LAGANG_QUOTE', 185, 'TECH_ANIMAL_HUSBANDRY', 'ERA_CLASSICAL', 'SPECIALIST_ENGINEER', 1, 1, -1, -1, 100, 1, 500, 'TIBETAN_ATLAS_YUMBU', 0, 'YUMBU_LAGANG_splash.dds', 'L,B');

-- CLASSICAL ERA
INSERT INTO Buildings
	(Type, BuildingClass, Description, Help, Civilopedia, Quote, Cost, PrereqTech, MaxStartEra, SpecialistType, GreatPeopleRateChange, NukeImmune, HurryCostModifier, MinAreaSize, ConquestProb, Happiness, Culture, IconAtlas, PortraitIndex, WonderSplashImage, WonderSplashAnchor)
VALUES
	('BUILDING_JOKHANG_TEMPLE', 'BUILDINGCLASS_JOKHANG_TEMPLE', 'TXT_KEY_BUILDING_JOKHANG_TEMPLE', 'TXT_KEY_WONDER_JOKHANG_TEMPLE_HELP', 'TXT_KEY_WONDER_JOKHANG_TEMPLE_PEDIA', 'TXT_KEY_WONDER_JOKHANG_TEMPLE_QUOTE', 250, 'TECH_PHILOSOPHY', 'ERA_MEDIEVAL', 'SPECIALIST_ARTIST', 1, 1, -1, -1, 100, 1, 1, 'TIBETAN_ATLAS_JOKHANG', 0, 'JOKHANG_TEMPLE_splash.dds', 'L,B');

INSERT INTO Buildings
	(Type, BuildingClass, Description, Help, Civilopedia, Quote, Cost, PrereqTech, MaxStartEra, SpecialistType, GreatPeopleRateChange, NukeImmune, HurryCostModifier, MinAreaSize, ConquestProb, Faith, IconAtlas, PortraitIndex, WonderSplashImage, WonderSplashAnchor)
VALUES
	('BUILDING_SAMYE_MONASTERY', 'BUILDINGCLASS_SAMYE_MONASTERY', 'TXT_KEY_BUILDING_SAMYE_MONASTERY', 'TXT_KEY_WONDER_SAMYE_MONASTERY_HELP', 'TXT_KEY_WONDER_SAMYE_MONASTERY_PEDIA', 'TXT_KEY_WONDER_SAMYE_MONASTERY_QUOTE', 300, 'TECH_THEOLOGY', 'ERA_MEDIEVAL', 'SPECIALIST_ENGINEER', 2, 1, -1, -1, 100, 2, 'TIBETAN_ATLAS_SAMYE', 0, 'SAMYE_MONASTERY_splash.dds', 'L,B');

-- MEDIEVAL ERA
INSERT INTO Buildings
	(Type, BuildingClass, Description, Help, Civilopedia, Quote, Cost, PrereqTech, MaxStartEra, SpecialistType, GreatPeopleRateChange, NukeImmune, HurryCostModifier, MinAreaSize, ConquestProb, Science, GreatWorkSlotType, GreatWorkCount, IconAtlas, PortraitIndex, WonderSplashImage, WonderSplashAnchor)
VALUES
	('BUILDING_SAKYA_LIBRARY', 'BUILDINGCLASS_SAKYA_LIBRARY', 'TXT_KEY_BUILDING_SAKYA_LIBRARY', 'TXT_KEY_WONDER_SAKYA_LIBRARY_HELP', 'TXT_KEY_WONDER_SAKYA_LIBRARY_PEDIA', 'TXT_KEY_WONDER_SAKYA_LIBRARY_QUOTE', 400, 'TECH_EDUCATION', 'ERA_RENAISSANCE', 'SPECIALIST_SCIENTIST', 2, 1, -1, -1, 100, 2, 'GREAT_WORK_SLOT_LITERATURE', 2, 'TIBETAN_ATLAS_SAKYA', 0, 'SAKYA_LIBRARY_splash.dds', 'L,B');

-- RENAISSANCE ERA
INSERT INTO Buildings
	(Type, BuildingClass, Description, Help, Civilopedia, Quote, Cost, PrereqTech, MaxStartEra, SpecialistType, GreatPeopleRateChange, NukeImmune, HurryCostModifier, MinAreaSize, ConquestProb, Defense, Mountain, IconAtlas, PortraitIndex, WonderSplashImage, WonderSplashAnchor)
VALUES
	('BUILDING_POTALA_PALACE', 'BUILDINGCLASS_POTALA_PALACE', 'TXT_KEY_BUILDING_POTALA_PALACE', 'TXT_KEY_WONDER_POTALA_PALACE_HELP', 'TXT_KEY_WONDER_POTALA_PALACE_PEDIA', 'TXT_KEY_WONDER_POTALA_PALACE_QUOTE', 625, 'TECH_ASTRONOMY', 'ERA_INDUSTRIAL', 'SPECIALIST_ENGINEER', 3, 1, -1, -1, 100, 500, 1, 'TIBETAN_ATLAS_POTALA', 0, 'POTALA_PALACE_splash.dds', 'L,B');

INSERT INTO Buildings
	(Type, BuildingClass, Description, Help, Civilopedia, Quote, Cost, PrereqTech, MaxStartEra, SpecialistType, GreatPeopleRateChange, NukeImmune, HurryCostModifier, MinAreaSize, ConquestProb, Happiness, River, IconAtlas, PortraitIndex, WonderSplashImage, WonderSplashAnchor)
VALUES
	('BUILDING_NORBULINGKA', 'BUILDINGCLASS_NORBULINGKA', 'TXT_KEY_BUILDING_NORBULINGKA', 'TXT_KEY_WONDER_NORBULINGKA_HELP', 'TXT_KEY_WONDER_NORBULINGKA_PEDIA', 'TXT_KEY_WONDER_NORBULINGKA_QUOTE', 625, 'TECH_BANKING', 'ERA_INDUSTRIAL', 'SPECIALIST_ARTIST', 1, 1, -1, -1, 100, 3, 1, 'TIBETAN_ATLAS_NORBU', 0, 'NORBULINGKA_splash.dds', 'L,B');

INSERT INTO Buildings
	(Type, BuildingClass, Description, Help, Civilopedia, Quote, Cost, PrereqTech, MaxStartEra, SpecialistType, GreatPeopleRateChange, NukeImmune, HurryCostModifier, MinAreaSize, ConquestProb, Gold, GreatWorkSlotType, GreatWorkCount, ThemingBonusHelp, IconAtlas, PortraitIndex, WonderSplashImage, WonderSplashAnchor)
VALUES
	('BUILDING_GYANTSE_KUMBUM', 'BUILDINGCLASS_GYANTSE_KUMBUM', 'TXT_KEY_BUILDING_GYANTSE_KUMBUM', 'TXT_KEY_WONDER_GYANTSE_KUMBUM_HELP', 'TXT_KEY_WONDER_GYANTSE_KUMBUM_PEDIA', 'TXT_KEY_WONDER_GYANTSE_KUMBUM_QUOTE', 625, 'TECH_ACOUSTICS', 'ERA_INDUSTRIAL', 'SPECIALIST_ARTIST', 1, 1, -1, -1, 100, 3, 'GREAT_WORK_SLOT_ART_ARTIFACT', 3, 'TXT_KEY_THEMING_BONUS_GYANTSE_KUMBUM_HELP', 'TIBETAN_ATLAS_GYANTSE', 0, 'GYANTSE_KUMBUM_splash.dds', 'L,B');

-- INDUSTRIAL ERA
INSERT INTO Buildings
	(Type, BuildingClass, Description, Help, Civilopedia, Quote, Cost, PrereqTech, MaxStartEra, SpecialistType, GreatPeopleRateChange, NukeImmune, HurryCostModifier, MinAreaSize, ConquestProb, GreatWorkSlotType, GreatWorkCount, IconAtlas, PortraitIndex, WonderSplashImage, WonderSplashAnchor)
VALUES
	('BUILDING_DEGE_PARKHANG', 'BUILDINGCLASS_DEGE_PARKHANG', 'TXT_KEY_BUILDING_DEGE_PARKHANG', 'TXT_KEY_WONDER_DEGE_PARKHANG_HELP', 'TXT_KEY_WONDER_DEGE_PARKHANG_PEDIA', 'TXT_KEY_WONDER_DEGE_PARKHANG_QUOTE', 750, 'TECH_STEAM_POWER', 'ERA_MODERN', 'SPECIALIST_WRITER', 3, 1, -1, -1, 100, 'GREAT_WORK_SLOT_LITERATURE', 2, 'TIBETAN_ATLAS_DEGE', 0, 'DEGE_PARKHANG_splash.dds', 'L,B');

-- ============================================================================
-- ICON TEXTURE ATLASES
-- ============================================================================
-- Defines icon atlases for all 8 Tibetan wonders in various sizes (256, 128, 80, 64, 45px)

INSERT INTO IconTextureAtlases
	(Atlas, IconSize, Filename, IconsPerRow, IconsPerColumn)
VALUES
	-- YUMBU LAGANG
	('TIBETAN_ATLAS_YUMBU', 256, 'YumbuLagang_256.dds', 1, 1),
	('TIBETAN_ATLAS_YUMBU', 128, 'YumbuLagang_128.dds', 1, 1),
	('TIBETAN_ATLAS_YUMBU', 80, 'YumbuLagang_80.dds', 1, 1),
	('TIBETAN_ATLAS_YUMBU', 64, 'YumbuLagang_64.dds', 1, 1),
	('TIBETAN_ATLAS_YUMBU', 45, 'YumbuLagang_45.dds', 1, 1),

	-- JOKHANG TEMPLE
	('TIBETAN_ATLAS_JOKHANG', 256, 'JokhangTemple_256.dds', 1, 1),
	('TIBETAN_ATLAS_JOKHANG', 128, 'JokhangTemple_128.dds', 1, 1),
	('TIBETAN_ATLAS_JOKHANG', 80, 'JokhangTemple_80.dds', 1, 1),
	('TIBETAN_ATLAS_JOKHANG', 64, 'JokhangTemple_64.dds', 1, 1),
	('TIBETAN_ATLAS_JOKHANG', 45, 'JokhangTemple_45.dds', 1, 1),

	-- SAMYE MONASTERY
	('TIBETAN_ATLAS_SAMYE', 256, 'SamyeMonastery_256.dds', 1, 1),
	('TIBETAN_ATLAS_SAMYE', 128, 'SamyeMonastery_128.dds', 1, 1),
	('TIBETAN_ATLAS_SAMYE', 80, 'SamyeMonastery_80.dds', 1, 1),
	('TIBETAN_ATLAS_SAMYE', 64, 'SamyeMonastery_64.dds', 1, 1),
	('TIBETAN_ATLAS_SAMYE', 45, 'SamyeMonastery_45.dds', 1, 1),

	-- SAKYA LIBRARY
	('TIBETAN_ATLAS_SAKYA', 256, 'SakyaLibrary_256.dds', 1, 1),
	('TIBETAN_ATLAS_SAKYA', 128, 'SakyaLibrary_128.dds', 1, 1),
	('TIBETAN_ATLAS_SAKYA', 80, 'SakyaLibrary_80.dds', 1, 1),
	('TIBETAN_ATLAS_SAKYA', 64, 'SakyaLibrary_64.dds', 1, 1),
	('TIBETAN_ATLAS_SAKYA', 45, 'SakyaLibrary_45.dds', 1, 1),

	-- POTALA PALACE
	('TIBETAN_ATLAS_POTALA', 256, 'PotalaPalace_256.dds', 1, 1),
	('TIBETAN_ATLAS_POTALA', 128, 'PotalaPalace_128.dds', 1, 1),
	('TIBETAN_ATLAS_POTALA', 80, 'PotalaPalace_80.dds', 1, 1),
	('TIBETAN_ATLAS_POTALA', 64, 'PotalaPalace_64.dds', 1, 1),
	('TIBETAN_ATLAS_POTALA', 45, 'PotalaPalace_45.dds', 1, 1),

	-- NORBULINGKA
	('TIBETAN_ATLAS_NORBU', 256, 'Norbulingka_256.dds', 1, 1),
	('TIBETAN_ATLAS_NORBU', 128, 'Norbulingka_128.dds', 1, 1),
	('TIBETAN_ATLAS_NORBU', 80, 'Norbulingka_80.dds', 1, 1),
	('TIBETAN_ATLAS_NORBU', 64, 'Norbulingka_64.dds', 1, 1),
	('TIBETAN_ATLAS_NORBU', 45, 'Norbulingka_45.dds', 1, 1),

	-- GYANTSE KUMBUM
	('TIBETAN_ATLAS_GYANTSE', 256, 'GyantseKumbum_256.dds', 1, 1),
	('TIBETAN_ATLAS_GYANTSE', 128, 'GyantseKumbum_128.dds', 1, 1),
	('TIBETAN_ATLAS_GYANTSE', 80, 'GyantseKumbum_80.dds', 1, 1),
	('TIBETAN_ATLAS_GYANTSE', 64, 'GyantseKumbum_64.dds', 1, 1),
	('TIBETAN_ATLAS_GYANTSE', 45, 'GyantseKumbum_45.dds', 1, 1),

	-- DEGE PARKHANG
	('TIBETAN_ATLAS_DEGE', 256, 'DegeParkhang_256.dds', 1, 1),
	('TIBETAN_ATLAS_DEGE', 128, 'DegeParkhang_128.dds', 1, 1),
	('TIBETAN_ATLAS_DEGE', 80, 'DegeParkhang_80.dds', 1, 1),
	('TIBETAN_ATLAS_DEGE', 64, 'DegeParkhang_64.dds', 1, 1),
	('TIBETAN_ATLAS_DEGE', 45, 'DegeParkhang_45.dds', 1, 1);

-- ============================================================================
-- AI BEHAVIOR & FLAVORS
-- ============================================================================
-- Building Flavors for AI decision making and prioritization

INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor)
VALUES
	('BUILDING_YUMBU_LAGANG', 'FLAVOR_DEFENSE', 8),
	('BUILDING_YUMBU_LAGANG', 'FLAVOR_RELIGION', 6),
	('BUILDING_YUMBU_LAGANG', 'FLAVOR_WONDER', 10),

	('BUILDING_JOKHANG_TEMPLE', 'FLAVOR_RELIGION', 9),
	('BUILDING_JOKHANG_TEMPLE', 'FLAVOR_CULTURE', 7),
	('BUILDING_JOKHANG_TEMPLE', 'FLAVOR_HAPPINESS', 6),
	('BUILDING_JOKHANG_TEMPLE', 'FLAVOR_WONDER', 10),

	('BUILDING_SAMYE_MONASTERY', 'FLAVOR_RELIGION', 9),
	('BUILDING_SAMYE_MONASTERY', 'FLAVOR_EXPANSION', 6),
	('BUILDING_SAMYE_MONASTERY', 'FLAVOR_WONDER', 10),

	('BUILDING_SAKYA_LIBRARY', 'FLAVOR_SCIENCE', 9),
	('BUILDING_SAKYA_LIBRARY', 'FLAVOR_CULTURE', 7),
	('BUILDING_SAKYA_LIBRARY', 'FLAVOR_GREAT_PEOPLE', 8),
	('BUILDING_SAKYA_LIBRARY', 'FLAVOR_WONDER', 10),

	('BUILDING_POTALA_PALACE', 'FLAVOR_DEFENSE', 8),
	('BUILDING_POTALA_PALACE', 'FLAVOR_RELIGION', 9),
	('BUILDING_POTALA_PALACE', 'FLAVOR_GREAT_PEOPLE', 7),
	('BUILDING_POTALA_PALACE', 'FLAVOR_WONDER', 10),

	('BUILDING_NORBULINGKA', 'FLAVOR_HAPPINESS', 9),
	('BUILDING_NORBULINGKA', 'FLAVOR_GROWTH', 7),
	('BUILDING_NORBULINGKA', 'FLAVOR_CULTURE', 6),
	('BUILDING_NORBULINGKA', 'FLAVOR_WONDER', 10),

	('BUILDING_GYANTSE_KUMBUM', 'FLAVOR_CULTURE', 9),
	('BUILDING_GYANTSE_KUMBUM', 'FLAVOR_GOLD', 7),
	('BUILDING_GYANTSE_KUMBUM', 'FLAVOR_GREAT_PEOPLE', 6),
	('BUILDING_GYANTSE_KUMBUM', 'FLAVOR_WONDER', 10),

	('BUILDING_DEGE_PARKHANG', 'FLAVOR_RELIGION', 9),
	('BUILDING_DEGE_PARKHANG', 'FLAVOR_CULTURE', 8),
	('BUILDING_DEGE_PARKHANG', 'FLAVOR_GREAT_PEOPLE', 8),
	('BUILDING_DEGE_PARKHANG', 'FLAVOR_WONDER', 10);

-- ============================================================================
-- PREREQUISITES & TECH REQUIREMENTS
-- ============================================================================
-- Additional tech requirements beyond the main prerequisite

INSERT INTO Building_TechAndPrereqs (BuildingType, TechType)
VALUES
	('BUILDING_YUMBU_LAGANG', 'TECH_MASONRY');

-- ============================================================================
-- BUILDING SYNERGIES & RELATIONSHIPS
-- ============================================================================
-- Building Class Overrides for unique mechanics

INSERT INTO Building_ClassesNeededInCity (BuildingType, BuildingClassType)
VALUES
	('BUILDING_NORBULINGKA', 'BUILDINGCLASS_GARDEN');

-- Yield Changes from Buildings (for Norbulingka garden bonus)
INSERT INTO Building_BuildingClassYieldChanges (BuildingType, BuildingClassType, YieldType, YieldChange)
VALUES
	('BUILDING_NORBULINGKA', 'BUILDINGCLASS_GARDEN', 'YIELD_FOOD', 2),
	('BUILDING_NORBULINGKA', 'BUILDINGCLASS_GARDEN', 'YIELD_CULTURE', 1);

-- Free Buildings (for building synergies)
INSERT INTO Building_FreeBuildings (BuildingType, FreeBuildingClass)
VALUES
	('BUILDING_YUMBU_LAGANG', 'BUILDINGCLASS_WALLS'),
	('BUILDING_POTALA_PALACE', 'BUILDINGCLASS_WALLS');

-- Faith from Defense Buildings (Yumbu Lagang effect)
INSERT INTO Building_BuildingClassYieldChanges (BuildingType, BuildingClassType, YieldType, YieldChange)
VALUES
	('BUILDING_YUMBU_LAGANG', 'BUILDINGCLASS_WALLS', 'YIELD_FAITH', 1),
	('BUILDING_YUMBU_LAGANG', 'BUILDINGCLASS_CASTLE', 'YIELD_FAITH', 1),
	('BUILDING_YUMBU_LAGANG', 'BUILDINGCLASS_ARSENAL', 'YIELD_FAITH', 1),
	('BUILDING_YUMBU_LAGANG', 'BUILDINGCLASS_MILITARY_BASE', 'YIELD_FAITH', 1);

-- ============================================================================
-- GREAT WORKS & THEMING
-- ============================================================================
-- Theming Bonuses for Gyantse Kumbum

INSERT INTO Building_ThemingBonuses (BuildingType, Description, Bonus, RequiresOwner, RequiresSamePlayer, RequiresUniquePlayers, RequiresSameCiv, RequiresUniqueCivs, RequiresSameEra, RequiresUniqueEras, AIPriority)
VALUES
	('BUILDING_GYANTSE_KUMBUM', 'TXT_KEY_THEMING_BONUS_GYANTSE_KUMBUM', 4, 0, 0, 0, 0, 0, 0, 1, 3);

-- ============================================================================
-- SPECIALIST & YIELD ENHANCEMENTS
-- ============================================================================
-- Specialist Slots and Yield Changes

INSERT INTO Building_SpecialistYieldChanges (BuildingType, SpecialistType, Yield, Change)
VALUES
	('BUILDING_SAKYA_LIBRARY', 'SPECIALIST_SCIENTIST', 'YIELD_SCIENCE', 1),
	('BUILDING_DEGE_PARKHANG', 'SPECIALIST_WRITER', 'YIELD_CULTURE', 2);

-- Building Yield Modifiers
INSERT INTO Building_YieldModifiers (BuildingType, YieldType, Yield)
VALUES
	('BUILDING_SAKYA_LIBRARY', 'YIELD_SCIENCE', 10),
	('BUILDING_DEGE_PARKHANG', 'YIELD_CULTURE', 15);

-- ============================================================================
-- UNIT PRODUCTION & BONUSES
-- ============================================================================
-- Unit Movement Bonuses for Religious Units (Samye Monastery)

INSERT INTO Building_UnitCombatProductionModifiers (BuildingType, UnitCombatType, Modifier)
VALUES
	('BUILDING_SAMYE_MONASTERY', 'UNITCOMBAT_MISSIONARY', 15);

-- Domain Production Modifiers (for religious unit movement bonus)
INSERT INTO Building_DomainProductionModifiers (BuildingType, DomainType, Modifier)
VALUES
	('BUILDING_SAMYE_MONASTERY', 'DOMAIN_LAND', 10);

-- Free Units
INSERT INTO Building_FreeUnits (BuildingType, UnitType, NumUnits)
VALUES
	('BUILDING_JOKHANG_TEMPLE', 'UNIT_MISSIONARY', 1);

-- ============================================================================
-- RESOURCE REQUIREMENTS
-- ============================================================================
-- Resource Quantity Modifiers

INSERT INTO Building_ResourceQuantityRequirements (BuildingType, ResourceType, Cost)
VALUES
	('BUILDING_POTALA_PALACE', 'RESOURCE_STONE', 2),
	('BUILDING_YUMBU_LAGANG', 'RESOURCE_STONE', 1);

-- ============================================================================
-- POLICY INTERACTIONS
-- ============================================================================
-- Policy Modifiers for wonder interactions

INSERT INTO Building_PolicyYieldModifiers (BuildingType, PolicyType, YieldType, Yield)
VALUES
	('BUILDING_JOKHANG_TEMPLE', 'POLICY_RELIGIOUS_TOLERANCE', 'YIELD_FAITH', 2),
	('BUILDING_SAMYE_MONASTERY', 'POLICY_ORGANIZED_RELIGION', 'YIELD_FAITH', 3);

-- ============================================================================
-- AUDIO SYSTEMS
-- ============================================================================
-- Wonder Splash Screen Audio

INSERT INTO Audio_2DSounds (ScriptID, SoundID, SoundType, MinVolume, MaxVolume, IsMusic, Looping)
VALUES
	('AS2D_WONDER_SPEECH_YUMBU_LAGANG', 'SND_WONDER_SPEECH_YUMBU_LAGANG', 'GAME_SFX', 60, 60, 0, 0),
	('AS2D_WONDER_SPEECH_JOKHANG_TEMPLE', 'SND_WONDER_SPEECH_JOKHANG_TEMPLE', 'GAME_SFX', 60, 60, 0, 0),
	('AS2D_WONDER_SPEECH_SAMYE_MONASTERY', 'SND_WONDER_SPEECH_SAMYE_MONASTERY', 'GAME_SFX', 60, 60, 0, 0),
	('AS2D_WONDER_SPEECH_SAKYA_LIBRARY', 'SND_WONDER_SPEECH_SAKYA_LIBRARY', 'GAME_SFX', 60, 60, 0, 0),
	('AS2D_WONDER_SPEECH_POTALA_PALACE', 'SND_WONDER_SPEECH_POTALA_PALACE', 'GAME_SFX', 60, 60, 0, 0),
	('AS2D_WONDER_SPEECH_NORBULINGKA', 'SND_WONDER_SPEECH_NORBULINGKA', 'GAME_SFX', 60, 60, 0, 0),
	('AS2D_WONDER_SPEECH_GYANTSE_KUMBUM', 'SND_WONDER_SPEECH_GYANTSE_KUMBUM', 'GAME_SFX', 60, 60, 0, 0),
	('AS2D_WONDER_SPEECH_DEGE_PARKHANG', 'SND_WONDER_SPEECH_DEGE_PARKHANG', 'GAME_SFX', 60, 60, 0, 0);

-- ============================================================================
-- END OF DATABASE
-- ============================================================================
