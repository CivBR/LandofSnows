-- Civilization_JFD_ColonialCityNames
CREATE TABLE
	IF NOT EXISTS Civilization_JFD_ColonialCityNames (CivilizationType, ColonyName, LinguisticType);

INSERT INTO
	Civilization_JFD_ColonialCityNames (CivilizationType, ColonyName)
VALUES
	('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 'TXT_KEY_COLONY_NAME_TIBETAN_EMPIRE_TRISONG_DETSEN_01');

-- Civilizations_YnAEMP
CREATE TABLE
	IF NOT EXISTS Civilizations_YnAEMP (CivilizationType, MapPrefix, X, Y, CapitalName, AltX, AltY, AltCapitalName);

INSERT INTO
	Civilizations_YnAEMP (CivilizationType, MapPrefix, X, Y, AltX, AltY, AltCapitalName)
VALUES -- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN',	'AfriAsiaAust',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN',	'AfricaLarge',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN',	'AfriSouthEuro',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN',	'Americas',			0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN',	'Apennine',			0,		0,		null,	null,	null),
	('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 'Asia', 41, 42, null, null, null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 	'BritishIsles', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN',	'Caribbean',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 	'Cordiform', 		0, 		0, 		null, 	null, 	null),
	('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 'EarthMk3', 73, 56, null, null, null),
	('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 'EastAsia', 14, 18, null, null, null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 	'EuroLarge', 		0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 	'EuroLargeNew', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 	'GreatestEarth', 	0, 		0, 		null, 	null, 	null),
	('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 'IndianOcean', 59, 71, null, null, null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN',	'Mediterranean',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN',	'Mesopotamia',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 	'NorthAtlantic', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN',	'NorthEastAsia',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 	'NorthWestEurope', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 	'Orient', 			0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN',	'SouthPacific',		0,		0,		null,	null,	null),
	('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 'Yagem', 70, 55, null, null, null),
	('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 'Yahem', 96, 50, null, null, null);

-- Civilizations_YnAEMPRequestedResources
CREATE TABLE
	IF NOT EXISTS Civilizations_YnAEMPRequestedResources (CivilizationType, MapPrefix, Req1, Yield1, Req2, Yield2, Req3, Yield3, Req4, Yield4, Req5, Yield5, Req6, Yield6);

INSERT INTO
	Civilizations_YnAEMPRequestedResources (CivilizationType, MapPrefix, Req1, Yield1, Req2, Yield2, Req3, Yield3, Req4, Yield4, Req5, Yield5, Req6, Yield6)
SELECT
	'CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN',
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
	('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 'JFD_Himalayan', 'JFD_Himalayan', 'JFD_Himalayan');

-- Civilization_JFD_Governments
CREATE TABLE
	IF NOT EXISTS Civilization_JFD_Governments (CivilizationType, GovernmentType, Weight);

INSERT INTO
	Civilization_JFD_Governments (CivilizationType, GovernmentType, Weight)
VALUES
	('CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN', 'GOVERNMENT_JFD_MONARCHY', 80);

-- Civilization_Religions
UPDATE Civilization_Religions
SET
	ReligionType = 'RELIGION_VAJRAYANA'
WHERE
	CivilizationType = 'CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN'
	AND EXISTS (
		SELECT
			*
		FROM
			Religions
		WHERE
			Type = 'RELIGION_VAJRAYANA'
	);
