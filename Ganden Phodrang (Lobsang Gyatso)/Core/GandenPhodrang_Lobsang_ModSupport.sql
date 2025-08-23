-- Civilization_JFD_ColonialCityNames
CREATE TABLE
	IF NOT EXISTS Civilization_JFD_ColonialCityNames (CivilizationType, ColonyName, LinguisticType);

INSERT INTO
	Civilization_JFD_ColonialCityNames (CivilizationType, ColonyName)
VALUES
	('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 'TXT_KEY_COLONY_NAME_GANDEN_PHODRANG_LOBSANG_GYATSO_01');

-- Civilizations_YnAEMP
CREATE TABLE
	IF NOT EXISTS Civilizations_YnAEMP (CivilizationType, MapPrefix, X, Y, CapitalName, AltX, AltY, AltCapitalName);

INSERT INTO
	Civilizations_YnAEMP (CivilizationType, MapPrefix, X, Y, AltX, AltY, AltCapitalName)
VALUES -- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO',	'AfriAsiaAust',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO',	'AfricaLarge',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO',	'AfriSouthEuro',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO',	'Americas',			0,		0,		null,	null,	null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO',	'Apennine',			0,		0,		null,	null,	null),
	('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 'Asia', 41, 42, null, null, null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 	'BritishIsles', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO',	'Caribbean',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 	'Cordiform', 		0, 		0, 		null, 	null, 	null),
	('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 'EarthMk3', 72, 56, null, null, null),
	('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 'EastAsia', 14, 18, null, null, null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 	'EuroLarge', 		0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 	'EuroLargeNew', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN', 	'GreatestEarth', 	0, 		0, 		null, 	null, 	null),
	('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 'IndianOcean', 59, 71, null, null, null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO',	'Mediterranean',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO',	'Mesopotamia',		0,		0,		null,	null,	null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 	'NorthAtlantic', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO',	'NorthEastAsia',	0,		0,		null,	null,	null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 	'NorthWestEurope', 	0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 	'Orient', 			0, 		0, 		null, 	null, 	null),
	-- ('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO',	'SouthPacific',		0,		0,		null,	null,	null),
	('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 'Yagem', 70, 55, null, null, null),
	('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 'Yahem', 95, 50, null, null, null);

-- Civilizations_YnAEMPRequestedResources
CREATE TABLE
	IF NOT EXISTS Civilizations_YnAEMPRequestedResources (CivilizationType, MapPrefix, Req1, Yield1, Req2, Yield2, Req3, Yield3, Req4, Yield4, Req5, Yield5, Req6, Yield6);

INSERT INTO
	Civilizations_YnAEMPRequestedResources (CivilizationType, MapPrefix, Req1, Yield1, Req2, Yield2, Req3, Yield3, Req4, Yield4, Req5, Yield5, Req6, Yield6)
SELECT
	'CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO',
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
	('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 'JFD_Himalayan', 'JFD_Himalayan', 'JFD_Himalayan');

-- Civilization_JFD_Governments
CREATE TABLE
	IF NOT EXISTS Civilization_JFD_Governments (CivilizationType, GovernmentType, Weight);

INSERT INTO
	Civilization_JFD_Governments (CivilizationType, GovernmentType, Weight)
VALUES
	('CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO', 'GOVERNMENT_JFD_THEOCRATIC', 80);

-- Civilization_Religions
UPDATE Civilization_Religions
SET
	ReligionType = 'RELIGION_VAJRAYANA'
WHERE
	CivilizationType = 'CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO'
	AND EXISTS (
		SELECT
			*
		FROM
			Religions
		WHERE
			Type = 'RELIGION_VAJRAYANA'
	);
