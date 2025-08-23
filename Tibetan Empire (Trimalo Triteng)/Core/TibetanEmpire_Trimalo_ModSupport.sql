-- Civilization_JFD_ColonialCityNames
CREATE TABLE
	IF NOT EXISTS Civilization_JFD_ColonialCityNames (CivilizationType, ColonyName, LinguisticType);

INSERT INTO
	Civilization_JFD_ColonialCityNames (CivilizationType, ColonyName)
VALUES
	('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 'TXT_KEY_COLONY_NAME_TIBETAN_EMPIRE_TRIMALO_01');

-- Civilizations_YnAEMP
CREATE TABLE
	IF NOT EXISTS Civilizations_YnAEMP (CivilizationType, MapPrefix, X, Y, CapitalName, AltX, AltY, AltCapitalName);

INSERT INTO
	Civilizations_YnAEMP (CivilizationType, MapPrefix, X, Y, AltX, AltY, AltCapitalName)
VALUES -- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO',	'AfriAsiaAust',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO',	'AfricaLarge',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO',	'AfriSouthEuro',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO',	'Americas',			0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO',	'Apennine',			0,		0,		null,	null,	null),
	('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 'Asia', 41, 43, null, null, null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 	'BritishIsles', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO',	'Caribbean',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 	'Cordiform', 		0, 		0, 		null, 	null, 	null),
	('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 'EarthMk3', 73, 56, null, null, null),
	('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 'EastAsia', 15, 18, null, null, null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 	'EuroLarge', 		0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 	'EuroLargeNew', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 	'GreatestEarth', 	0, 		0, 		null, 	null, 	null),
	('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 'IndianOcean', 59, 71, null, null, null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO',	'Mediterranean',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO',	'Mesopotamia',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 	'NorthAtlantic', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO',	'NorthEastAsia',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 	'NorthWestEurope', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 	'Orient', 			0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO',	'SouthPacific',		0,		0,		null,	null,	null),
	('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 'Yagem', 70, 55, null, null, null),
	('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 'Yahem', 96, 50, null, null, null);

-- Civilizations_YnAEMPRequestedResources
CREATE TABLE
	IF NOT EXISTS Civilizations_YnAEMPRequestedResources (CivilizationType, MapPrefix, Req1, Yield1, Req2, Yield2, Req3, Yield3, Req4, Yield4, Req5, Yield5, Req6, Yield6);

INSERT INTO
	Civilizations_YnAEMPRequestedResources (CivilizationType, MapPrefix, Req1, Yield1, Req2, Yield2, Req3, Yield3, Req4, Yield4, Req5, Yield5, Req6, Yield6)
SELECT
	'CIVILIZATION_TIBETAN_EMPIRE_TRIMALO',
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
	('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 'JFD_Himalayan', 'JFD_Himalayan', 'JFD_Himalayan');

-- Civilization_JFD_Governments
CREATE TABLE
	IF NOT EXISTS Civilization_JFD_Governments (CivilizationType, GovernmentType, Weight);

INSERT INTO
	Civilization_JFD_Governments (CivilizationType, GovernmentType, Weight)
VALUES
	('CIVILIZATION_TIBETAN_EMPIRE_TRIMALO', 'GOVERNMENT_JFD_MONARCHY', 80);

-- Civilization_Religions
UPDATE Civilization_Religions
SET
	ReligionType = 'RELIGION_VAJRAYANA'
WHERE
	CivilizationType = 'CIVILIZATION_TIBETAN_EMPIRE_TRIMALO'
	AND EXISTS (
		SELECT
			*
		FROM
			Religions
		WHERE
			Type = 'RELIGION_VAJRAYANA'
	);