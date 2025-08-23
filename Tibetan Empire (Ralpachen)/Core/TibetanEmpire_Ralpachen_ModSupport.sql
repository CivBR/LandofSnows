-- Civilization_JFD_ColonialCityNames
CREATE TABLE
	IF NOT EXISTS Civilization_JFD_ColonialCityNames (CivilizationType, ColonyName, LinguisticType);

INSERT INTO
	Civilization_JFD_ColonialCityNames (CivilizationType, ColonyName)
VALUES
	('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 'TXT_KEY_COLONY_NAME_TIBETAN_EMPIRE_RALPACHEN_01');

-- Civilizations_YnAEMP
CREATE TABLE
	IF NOT EXISTS Civilizations_YnAEMP (CivilizationType, MapPrefix, X, Y, CapitalName, AltX, AltY, AltCapitalName);

INSERT INTO
	Civilizations_YnAEMP (CivilizationType, MapPrefix, X, Y, AltX, AltY, AltCapitalName)
VALUES -- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN',	'AfriAsiaAust',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN',	'AfricaLarge',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN',	'AfriSouthEuro',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN',	'Americas',			0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN',	'Apennine',			0,		0,		null,	null,	null),
	('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 'Asia', 41, 42, null, null, null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 	'BritishIsles', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN',	'Caribbean',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 	'Cordiform', 		0, 		0, 		null, 	null, 	null),
	('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 'EarthMk3', 72, 56, null, null, null),
	('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 'EastAsia', 14, 18, null, null, null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 	'EuroLarge', 		0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 	'EuroLargeNew', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 	'GreatestEarth', 	0, 		0, 		null, 	null, 	null),
	('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 'IndianOcean', 59, 71, null, null, null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN',	'Mediterranean',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN',	'Mesopotamia',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 	'NorthAtlantic', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN',	'NorthEastAsia',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 	'NorthWestEurope', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 	'Orient', 			0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN',	'SouthPacific',		0,		0,		null,	null,	null),
	('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 'Yagem', 70, 55, null, null, null),
	('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 'Yahem', 95, 50, null, null, null);

-- Civilizations_YnAEMPRequestedResources
CREATE TABLE
	IF NOT EXISTS Civilizations_YnAEMPRequestedResources (CivilizationType, MapPrefix, Req1, Yield1, Req2, Yield2, Req3, Yield3, Req4, Yield4, Req5, Yield5, Req6, Yield6);

INSERT INTO
	Civilizations_YnAEMPRequestedResources (CivilizationType, MapPrefix, Req1, Yield1, Req2, Yield2, Req3, Yield3, Req4, Yield4, Req5, Yield5, Req6, Yield6)
SELECT
	'CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN',
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
	('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 'JFD_Himalayan', 'JFD_Himalayan', 'JFD_Himalayan');

-- Civilization_JFD_Governments
CREATE TABLE
	IF NOT EXISTS Civilization_JFD_Governments (CivilizationType, GovernmentType, Weight);

INSERT INTO
	Civilization_JFD_Governments (CivilizationType, GovernmentType, Weight)
VALUES
	('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 'GOVERNMENT_JFD_MONARCHY', 80);

-- Civilization_Religions
UPDATE Civilization_Religions
SET
	ReligionType = 'RELIGION_VAJRAYANA'
WHERE
	CivilizationType = 'CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN'
	AND EXISTS (
		SELECT
			*
		FROM
			Religions
		WHERE
			Type = 'RELIGION_VAJRAYANA'
	);