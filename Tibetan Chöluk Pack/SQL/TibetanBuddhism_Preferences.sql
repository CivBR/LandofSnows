--==========================================================================================================================
-- Tibetan Buddhist Schools - Civilization Preferences
--==========================================================================================================================
-- This file can be used to set religious preferences for civilizations that might use Tibetan Buddhist schools
-- Add civilization-specific preferences here as needed
--
-- Example format:
-- DELETE FROM Civilization_Religions WHERE CivilizationType = 'CIVILIZATION_EXAMPLE';
-- INSERT INTO Civilization_Religions
--         (CivilizationType,	ReligionType)
-- SELECT  Type,              'RELIGION_GELUG'
-- FROM Civilizations WHERE Type = 'CIVILIZATION_EXAMPLE';
--
-- The following schools are available:
-- RELIGION_NYINGMA - The "Ancient" school, oldest tradition
-- RELIGION_KARMA_KAGYU - Karma Kagyu lineage with the Karmapa
-- RELIGION_DRIKUNG_KAGYU - Drikung branch of Kagyu
-- RELIGION_DRUKPA_KAGYU - Dragon lineage, state religion of Bhutan
-- RELIGION_SAKYA - Grey Earth school, historically powerful
-- RELIGION_GELUG - Virtuous school of the Dalai Lamas
-- RELIGION_JONANG - Known for Kalachakra practices
-- RELIGION_BON - Indigenous Tibetan spiritual tradition
-- RELIGION_KADAMPA - Original reform school founded by Atisha
--==========================================================================================================================
-- Tibet (if using a Tibet civilization mod)
DELETE FROM Civilization_Religions
WHERE
	CivilizationType = 'CIVILIZATION_TIBET';

INSERT INTO
	Civilization_Religions (CivilizationType, ReligionType)
SELECT
	Type,
	('RELIGION_BUDDHISM')
FROM
	Civilizations
WHERE
	Type = 'CIVILIZATION_TIBET';

UPDATE Civilization_Religions
SET
	ReligionType = (
		CASE
			WHEN EXISTS (
				SELECT
					Type
				FROM
					Religions
				WHERE
					Type = 'RELIGION_GELUG'
			) THEN 'RELIGION_GELUG'
			ELSE 'RELIGION_BUDDHISM'
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_TIBET';

CREATE TRIGGER TibetanBuddhism_Tibet AFTER INSERT ON Civilization_Religions WHEN 'CIVILIZATION_TIBET' = NEW.CivilizationType BEGIN
UPDATE Civilization_Religions
SET
	ReligionType = (
		CASE
			WHEN EXISTS (
				SELECT
					Type
				FROM
					Religions
				WHERE
					Type = 'RELIGION_GELUG'
			) THEN 'RELIGION_GELUG'
			ELSE 'RELIGION_BUDDHISM'
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_TIBET';

END;

-- Bhutan (if using a Bhutan civilization mod)
DELETE FROM Civilization_Religions
WHERE
	CivilizationType = 'CIVILIZATION_BHUTAN';

INSERT INTO
	Civilization_Religions (CivilizationType, ReligionType)
SELECT
	Type,
	('RELIGION_BUDDHISM')
FROM
	Civilizations
WHERE
	Type = 'CIVILIZATION_BHUTAN';

UPDATE Civilization_Religions
SET
	ReligionType = (
		CASE
			WHEN EXISTS (
				SELECT
					Type
				FROM
					Religions
				WHERE
					Type = 'RELIGION_DRUKPA_KAGYU'
			) THEN 'RELIGION_DRUKPA_KAGYU'
			ELSE 'RELIGION_BUDDHISM'
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_BHUTAN';

CREATE TRIGGER TibetanBuddhism_Bhutan AFTER INSERT ON Civilization_Religions WHEN 'CIVILIZATION_BHUTAN' = NEW.CivilizationType BEGIN
UPDATE Civilization_Religions
SET
	ReligionType = (
		CASE
			WHEN EXISTS (
				SELECT
					Type
				FROM
					Religions
				WHERE
					Type = 'RELIGION_DRUKPA_KAGYU'
			) THEN 'RELIGION_DRUKPA_KAGYU'
			ELSE 'RELIGION_BUDDHISM'
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_BHUTAN';

END;

-- Mongolia (could use Sakya or Gelug due to historical connections)
DELETE FROM Civilization_Religions
WHERE
	CivilizationType = 'CIVILIZATION_MONGOL';

INSERT INTO
	Civilization_Religions (CivilizationType, ReligionType)
SELECT
	Type,
	('RELIGION_BUDDHISM')
FROM
	Civilizations
WHERE
	Type = 'CIVILIZATION_MONGOL';

UPDATE Civilization_Religions
SET
	ReligionType = (
		CASE
			WHEN EXISTS (
				SELECT
					Type
				FROM
					Religions
				WHERE
					Type = 'RELIGION_GELUG'
			) THEN 'RELIGION_GELUG'
			ELSE (
				CASE
					WHEN EXISTS (
						SELECT
							Type
						FROM
							Religions
						WHERE
							Type = 'RELIGION_SAKYA'
					) THEN 'RELIGION_SAKYA'
					ELSE 'RELIGION_BUDDHISM'
				END
			)
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_MONGOL';

CREATE TRIGGER TibetanBuddhism_Mongol AFTER INSERT ON Civilization_Religions WHEN 'CIVILIZATION_MONGOL' = NEW.CivilizationType BEGIN
UPDATE Civilization_Religions
SET
	ReligionType = (
		CASE
			WHEN EXISTS (
				SELECT
					Type
				FROM
					Religions
				WHERE
					Type = 'RELIGION_GELUG'
			) THEN 'RELIGION_GELUG'
			ELSE (
				CASE
					WHEN EXISTS (
						SELECT
							Type
						FROM
							Religions
						WHERE
							Type = 'RELIGION_SAKYA'
					) THEN 'RELIGION_SAKYA'
					ELSE 'RELIGION_BUDDHISM'
				END
			)
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_MONGOL';

END;