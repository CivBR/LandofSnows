-- Buddhist Religion Expansion - Buildings
-- Defines the Gompa follower building and dummy buildings for various effects

-- Building Class for Gompa
INSERT INTO BuildingClasses (Type, DefaultBuilding, Description)
VALUES ('BUILDINGCLASS_GOMPA', 'BUILDING_GOMPA', 'TXT_KEY_BUILDING_GOMPA');

-- Gompa Building Definition
INSERT INTO Buildings (
	Type,
	BuildingClass,
	Defense,
	GlobalPlotBuyCostModifier,
	GlobalPlotCultureCostModifier,
	SpecialistType,
	GreatPeopleRateChange,
	UnlockedByBelief,
	Cost,
	FaithCost,
	PrereqTech,
	Description,
	Help,
	NeverCapture
)
VALUES (
	'BUILDING_GOMPA',
	'BUILDINGCLASS_GOMPA',
	0,
	0,
	0,
	NULL,
	0,
	1,
	-1,
	225,
	NULL,
	'TXT_KEY_BUILDING_GOMPA',
	'TXT_KEY_BUILDING_GOMPA_HELP',
	1
);

-- Gompa additional properties
UPDATE Buildings SET
	Happiness = 1,
	ReligiousPressureModifier = 10,
	GreatWorkSlotType = 'GREAT_WORK_SLOT_LITERATURE',
	GreatWorkCount = 1,
	ConquestProb = 66,
	ArtDefineTag = 'TEMPLE',
	MinAreaSize = -1,
	PortraitIndex = 33,
	IconAtlas = 'GOMPA_ATLAS',
	PortraitIndex = 0
WHERE Type = 'BUILDING_GOMPA';

-- Gompa Base Yields
INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield)
VALUES
	('BUILDING_GOMPA', 'YIELD_FAITH', 2),
	('BUILDING_GOMPA', 'YIELD_CULTURE', 1);

-- Building Flavors for AI
INSERT INTO Building_Flavors (BuildingType, FlavorType, Flavor)
VALUES
	('BUILDING_GOMPA', 'FLAVOR_RELIGION', 8),
	('BUILDING_GOMPA', 'FLAVOR_CULTURE', 6),
	('BUILDING_GOMPA', 'FLAVOR_HAPPINESS', 4);

-- Dummy Building Classes
INSERT INTO BuildingClasses (Type, DefaultBuilding, Description)
VALUES
	('BUILDINGCLASS_BUDDHIST_MOUNTAIN_CULTURE', 'BUILDING_BUDDHIST_MOUNTAIN_CULTURE', 'TXT_KEY_BUILDING_BUDDHIST_MOUNTAIN_CULTURE'),
	('BUILDINGCLASS_BUDDHIST_GOMPA_MOUNTAIN_FAITH', 'BUILDING_BUDDHIST_GOMPA_MOUNTAIN_FAITH', 'TXT_KEY_BUILDING_BUDDHIST_GOMPA_MOUNTAIN_FAITH'),
	('BUILDINGCLASS_BUDDHIST_UNIVERSAL_COMPASSION', 'BUILDING_BUDDHIST_UNIVERSAL_COMPASSION', 'TXT_KEY_BUILDING_BUDDHIST_UNIVERSAL_COMPASSION'),
	('BUILDINGCLASS_BUDDHIST_TRADE_PRESSURE', 'BUILDING_BUDDHIST_TRADE_PRESSURE', 'TXT_KEY_BUILDING_BUDDHIST_TRADE_PRESSURE'),
	('BUILDINGCLASS_BUDDHIST_NON_SECTARIAN', 'BUILDING_BUDDHIST_NON_SECTARIAN', 'TXT_KEY_BUILDING_BUDDHIST_NON_SECTARIAN');

-- Dummy Building: Mountain Culture for Sacred Peaks
INSERT INTO Buildings (
	Type,
	BuildingClass,
	Defense,
	GlobalPlotBuyCostModifier,
	GlobalPlotCultureCostModifier,
	SpecialistType,
	GreatPeopleRateChange,
	UnlockedByBelief,
	Cost,
	FaithCost,
	PrereqTech,
	Description,
	Help,
	NeverCapture
)
VALUES (
	'BUILDING_BUDDHIST_MOUNTAIN_CULTURE',
	'BUILDINGCLASS_BUDDHIST_MOUNTAIN_CULTURE',
	0,
	0,
	0,
	NULL,
	0,
	0,
	-1,
	-1,
	NULL,
	'TXT_KEY_BUILDING_BUDDHIST_MOUNTAIN_CULTURE',
	'TXT_KEY_BUILDING_BUDDHIST_MOUNTAIN_CULTURE_HELP',
	1
);

INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield)
VALUES ('BUILDING_BUDDHIST_MOUNTAIN_CULTURE', 'YIELD_CULTURE', 2);

-- Dummy Building: Extra Faith for Mountain Gompas
INSERT INTO Buildings (
	Type,
	BuildingClass,
	Defense,
	GlobalPlotBuyCostModifier,
	GlobalPlotCultureCostModifier,
	SpecialistType,
	GreatPeopleRateChange,
	UnlockedByBelief,
	Cost,
	FaithCost,
	PrereqTech,
	Description,
	Help,
	NeverCapture
)
VALUES (
	'BUILDING_BUDDHIST_GOMPA_MOUNTAIN_FAITH',
	'BUILDINGCLASS_BUDDHIST_GOMPA_MOUNTAIN_FAITH',
	0,
	0,
	0,
	NULL,
	0,
	0,
	-1,
	-1,
	NULL,
	'TXT_KEY_BUILDING_BUDDHIST_GOMPA_MOUNTAIN_FAITH',
	'TXT_KEY_BUILDING_BUDDHIST_GOMPA_MOUNTAIN_FAITH_HELP',
	1
);

INSERT INTO Building_YieldChanges (BuildingType, YieldType, Yield)
VALUES ('BUILDING_BUDDHIST_GOMPA_MOUNTAIN_FAITH', 'YIELD_FAITH', 2);

-- Dummy Building: Universal Compassion Happiness
INSERT INTO Buildings (
	Type,
	BuildingClass,
	Defense,
	GlobalPlotBuyCostModifier,
	GlobalPlotCultureCostModifier,
	SpecialistType,
	GreatPeopleRateChange,
	UnlockedByBelief,
	Cost,
	FaithCost,
	PrereqTech,
	Description,
	Help,
	NeverCapture
)
VALUES (
	'BUILDING_BUDDHIST_UNIVERSAL_COMPASSION',
	'BUILDINGCLASS_BUDDHIST_UNIVERSAL_COMPASSION',
	0,
	0,
	0,
	NULL,
	0,
	0,
	-1,
	-1,
	NULL,
	'TXT_KEY_BUILDING_BUDDHIST_UNIVERSAL_COMPASSION',
	'TXT_KEY_BUILDING_BUDDHIST_UNIVERSAL_COMPASSION_HELP',
	1
);

-- This happiness will be dynamically set via Lua
UPDATE Buildings SET Happiness = 0 WHERE Type = 'BUILDING_BUDDHIST_UNIVERSAL_COMPASSION';

-- Dummy Building: Monastic Debate Trade Route Pressure
INSERT INTO Buildings (
	Type,
	BuildingClass,
	Defense,
	GlobalPlotBuyCostModifier,
	GlobalPlotCultureCostModifier,
	SpecialistType,
	GreatPeopleRateChange,
	UnlockedByBelief,
	Cost,
	FaithCost,
	PrereqTech,
	Description,
	Help,
	NeverCapture
)
VALUES (
	'BUILDING_BUDDHIST_TRADE_PRESSURE',
	'BUILDINGCLASS_BUDDHIST_TRADE_PRESSURE',
	0,
	0,
	0,
	NULL,
	0,
	0,
	-1,
	-1,
	NULL,
	'TXT_KEY_BUILDING_BUDDHIST_TRADE_PRESSURE',
	'TXT_KEY_BUILDING_BUDDHIST_TRADE_PRESSURE_HELP',
	1
);

-- Apply trade route pressure bonuses
UPDATE Buildings SET
	TradeRouteRecipientBonus = 4,
	TradeRouteTargetBonus = 4
WHERE Type = 'BUILDING_BUDDHIST_TRADE_PRESSURE';

-- Dummy Building: Non-Sectarianism Faith Burst Tracker
INSERT INTO Buildings (
	Type,
	BuildingClass,
	Defense,
	GlobalPlotBuyCostModifier,
	GlobalPlotCultureCostModifier,
	SpecialistType,
	GreatPeopleRateChange,
	UnlockedByBelief,
	Cost,
	FaithCost,
	PrereqTech,
	Description,
	Help,
	NeverCapture
)
VALUES (
	'BUILDING_BUDDHIST_NON_SECTARIAN',
	'BUILDINGCLASS_BUDDHIST_NON_SECTARIAN',
	0,
	0,
	0,
	NULL,
	0,
	0,
	-1,
	-1,
	NULL,
	'TXT_KEY_BUILDING_BUDDHIST_NON_SECTARIAN',
	'TXT_KEY_BUILDING_BUDDHIST_NON_SECTARIAN_HELP',
	1
);

-- IconTextureAtlases
INSERT INTO
	IconTextureAtlases (Atlas, IconSize, Filename, IconsPerRow, IconsPerColumn)
VALUES
	('GOMPA_ATLAS', 256, 'gompa_256.dds', 2, 2),
	('GOMPA_ATLAS', 128, 'gompa_128.dds', 2, 2),
	('GOMPA_ATLAS', 80, 'gompa_80.dds', 2, 2),
	('GOMPA_ATLAS', 64, 'gompa_64.dds', 2, 2),
	('GOMPA_ATLAS', 32, 'gompa_32.dds', 2, 2);
