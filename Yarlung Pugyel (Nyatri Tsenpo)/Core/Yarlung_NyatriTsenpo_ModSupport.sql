-- Civilization_JFD_ColonialCityNames
CREATE TABLE
	IF NOT EXISTS Civilization_JFD_ColonialCityNames (CivilizationType, ColonyName, LinguisticType);

INSERT INTO
	Civilization_JFD_ColonialCityNames (CivilizationType, ColonyName)
VALUES
	('CIVILIZATION_YARLUNG_PUGYEL', 'TXT_KEY_COLONY_NAME_YARLUNG_01');

-- Civilizations_YnAEMP
CREATE TABLE
	IF NOT EXISTS Civilizations_YnAEMP (CivilizationType, MapPrefix, X, Y, CapitalName, AltX, AltY, AltCapitalName);

INSERT INTO
	Civilizations_YnAEMP (CivilizationType, MapPrefix, X, Y, AltX, AltY, AltCapitalName)
VALUES -- ('CIVILIZATION_YARLUNG_PUGYEL',	'AfriAsiaAust',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL',	'AfricaLarge',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL',	'AfriSouthEuro',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL',	'Americas',			0,		0,		null,	null,	null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL',	'Apennine',			0,		0,		null,	null,	null),
	('CIVILIZATION_YARLUNG_PUGYEL', 'Asia', 41, 41, null, null, null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL', 	'BritishIsles', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL',	'Caribbean',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL', 	'Cordiform', 		0, 		0, 		null, 	null, 	null),
	('CIVILIZATION_YARLUNG_PUGYEL', 'EarthMk3', 73, 55, null, null, null),
	('CIVILIZATION_YARLUNG_PUGYEL', 'EastAsia', 14, 17, null, null, null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL', 	'EuroLarge', 		0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL', 	'EuroLargeNew', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL', 	'GreatestEarth', 	0, 		0, 		null, 	null, 	null),
	('CIVILIZATION_YARLUNG_PUGYEL', 'IndianOcean', 59, 71, null, null, null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL',	'Mediterranean',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL',	'Mesopotamia',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL', 	'NorthAtlantic', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL',	'NorthEastAsia',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL', 	'NorthWestEurope', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL', 	'Orient', 			0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_YARLUNG_PUGYEL',	'SouthPacific',		0,		0,		null,	null,	null),
	('CIVILIZATION_YARLUNG_PUGYEL', 'Yagem', 70, 55, null, null, null),
	('CIVILIZATION_YARLUNG_PUGYEL', 'Yahem', 95, 49, null, null, null);

-- Civilizations_YnAEMPRequestedResources
CREATE TABLE
	IF NOT EXISTS Civilizations_YnAEMPRequestedResources (CivilizationType, MapPrefix, Req1, Yield1, Req2, Yield2, Req3, Yield3, Req4, Yield4, Req5, Yield5, Req6, Yield6);

INSERT INTO
	Civilizations_YnAEMPRequestedResources (CivilizationType, MapPrefix, Req1, Yield1, Req2, Yield2, Req3, Yield3, Req4, Yield4, Req5, Yield5, Req6, Yield6)
SELECT
	'CIVILIZATION_YARLUNG_PUGYEL',
	MapPrefix,
	Req1,
	Yield1,
	Req2,
	Yield2,
	Req3,
	Yield3,
	Req4,
	Yield4,
	Req5,
	Yield5,
	Req6,
	Yield6
FROM
	Civilizations_YnAEMPRequestedResources
WHERE
	CivilizationType = 'CIVILIZATION_MONGOL';

-- Civilization_JFD_CultureTypes
CREATE TABLE
	IF NOT EXISTS Civilization_JFD_CultureTypes (CivilizationType, CultureType, SubCultureType, ArtDefineTag, DecisionsTag, DefeatScreenEarlyTag, DefeatScreenMidTag, DefeatScreenLateTag, IdealsTag, SplashScreenTag, SoundtrackTag, UnitDialogueTag);

INSERT INTO
	Civilization_JFD_CultureTypes (CivilizationType, CultureType, SplashScreenTag, SoundtrackTag)
VALUES
	('CIVILIZATION_YARLUNG_PUGYEL', 'JFD_Himalayan', 'JFD_Himalayan', 'JFD_Himalayan');

-- Civilization_JFD_Governments
CREATE TABLE
	IF NOT EXISTS Civilization_JFD_Governments (CivilizationType, GovernmentType, Weight);

INSERT INTO
	Civilization_JFD_Governments (CivilizationType, GovernmentType, Weight)
VALUES
	('CIVILIZATION_YARLUNG_PUGYEL', 'GOVERNMENT_JFD_MONARCHY', 80);

-- Civilization_Religions
UPDATE Civilization_Religions
SET
	ReligionType = 'RELIGION_VAJRAYANA'
WHERE
	CivilizationType = 'CIVILIZATION_YARLUNG_PUGYEL'
	AND EXISTS (
		SELECT
			*
		FROM
			Religions
		WHERE
			Type = 'RELIGION_VAJRAYANA'
	);