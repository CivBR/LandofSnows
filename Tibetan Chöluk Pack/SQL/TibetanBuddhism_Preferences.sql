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
-- SELECT  Type,              'RELIGION_GELUK'
-- FROM Civilizations WHERE Type = 'CIVILIZATION_EXAMPLE';
--
-- The following schools are available:
-- RELIGION_NYINGMA - The "Ancient" school, oldest tradition
-- RELIGION_KARMA_KAGYU - Karma Kagyu lineage with the Karmapa
-- RELIGION_DRIKUNG_KAGYU - Drikung branch of Kagyu
-- RELIGION_DRUKPA_KAGYU - Dragon lineage, state religion of Bhutan
-- RELIGION_SAKYA - Grey Earth school, historically powerful
-- RELIGION_GELUK - Virtuous school of the Dalai Lamas
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
					Type = 'RELIGION_GELUK'
			) THEN 'RELIGION_GELUK'
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
					Type = 'RELIGION_GELUK'
			) THEN 'RELIGION_GELUK'
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

-- Mongolia (could use Sakya or Geluk due to historical connections)
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
					Type = 'RELIGION_GELUK'
			) THEN 'RELIGION_GELUK'
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
					Type = 'RELIGION_GELUK'
			) THEN 'RELIGION_GELUK'
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

-- Tibetan Empire (Trisong Detsen) - Nyingma school
DELETE FROM Civilization_Religions
WHERE
	CivilizationType = 'CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN';

INSERT INTO
	Civilization_Religions (CivilizationType, ReligionType)
SELECT
	Type,
	('RELIGION_BUDDHISM')
FROM
	Civilizations
WHERE
	Type = 'CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN';

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
					Type = 'RELIGION_NYINGMA'
			) THEN 'RELIGION_NYINGMA'
			ELSE 'RELIGION_BUDDHISM'
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN';

CREATE TRIGGER TibetanBuddhism_TrisongDetsen AFTER INSERT ON Civilization_Religions WHEN 'CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN' = NEW.CivilizationType BEGIN
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
					Type = 'RELIGION_NYINGMA'
			) THEN 'RELIGION_NYINGMA'
			ELSE 'RELIGION_BUDDHISM'
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN';

END;

-- Tibetan Empire (Ralpachen) - Nyingma school
DELETE FROM Civilization_Religions
WHERE
	CivilizationType = 'CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN';

INSERT INTO
	Civilization_Religions (CivilizationType, ReligionType)
SELECT
	Type,
	('RELIGION_BUDDHISM')
FROM
	Civilizations
WHERE
	Type = 'CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN';

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
					Type = 'RELIGION_NYINGMA'
			) THEN 'RELIGION_NYINGMA'
			ELSE 'RELIGION_BUDDHISM'
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN';

CREATE TRIGGER TibetanBuddhism_Ralpachen AFTER INSERT ON Civilization_Religions WHEN 'CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN' = NEW.CivilizationType BEGIN
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
					Type = 'RELIGION_NYINGMA'
			) THEN 'RELIGION_NYINGMA'
			ELSE 'RELIGION_BUDDHISM'
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN';

END;

-- Yarlung Pugyel (Nyatri Tsenpo) - Bon religion
DELETE FROM Civilization_Religions
WHERE
	CivilizationType = 'CIVILIZATION_YARLUNG_PUGYEL';

INSERT INTO
	Civilization_Religions (CivilizationType, ReligionType)
SELECT
	Type,
	('RELIGION_BUDDHISM')
FROM
	Civilizations
WHERE
	Type = 'CIVILIZATION_YARLUNG_PUGYEL';

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
					Type = 'RELIGION_BON'
			) THEN 'RELIGION_BON'
			ELSE 'RELIGION_BUDDHISM'
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_YARLUNG_PUGYEL';

CREATE TRIGGER TibetanBuddhism_YarlungPugyel AFTER INSERT ON Civilization_Religions WHEN 'CIVILIZATION_YARLUNG_PUGYEL' = NEW.CivilizationType BEGIN
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
					Type = 'RELIGION_BON'
			) THEN 'RELIGION_BON'
			ELSE 'RELIGION_BUDDHISM'
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_YARLUNG_PUGYEL';

END;

-- Ganden Phodrang (Lobsang Gyatso) - Geluk school
DELETE FROM Civilization_Religions
WHERE
	CivilizationType = 'CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO';

INSERT INTO
	Civilization_Religions (CivilizationType, ReligionType)
SELECT
	Type,
	('RELIGION_BUDDHISM')
FROM
	Civilizations
WHERE
	Type = 'CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO';

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
					Type = 'RELIGION_GELUK'
			) THEN 'RELIGION_GELUK'
			ELSE 'RELIGION_BUDDHISM'
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO';

CREATE TRIGGER TibetanBuddhism_LobsangGyatso AFTER INSERT ON Civilization_Religions WHEN 'CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO' = NEW.CivilizationType BEGIN
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
					Type = 'RELIGION_GELUK'
			) THEN 'RELIGION_GELUK'
			ELSE 'RELIGION_BUDDHISM'
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO';

END;

-- Tibet (Thupten Gyatso) - Geluk school
DELETE FROM Civilization_Religions
WHERE
	CivilizationType = 'CIVILIZATION_TIBET_THUPTEN_GYATSO';

INSERT INTO
	Civilization_Religions (CivilizationType, ReligionType)
SELECT
	Type,
	('RELIGION_BUDDHISM')
FROM
	Civilizations
WHERE
	Type = 'CIVILIZATION_TIBET_THUPTEN_GYATSO';

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
					Type = 'RELIGION_GELUK'
			) THEN 'RELIGION_GELUK'
			ELSE 'RELIGION_BUDDHISM'
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_TIBET_THUPTEN_GYATSO';

CREATE TRIGGER TibetanBuddhism_ThuptenGyatso AFTER INSERT ON Civilization_Religions WHEN 'CIVILIZATION_TIBET_THUPTEN_GYATSO' = NEW.CivilizationType BEGIN
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
					Type = 'RELIGION_GELUK'
			) THEN 'RELIGION_GELUK'
			ELSE 'RELIGION_BUDDHISM'
		END
	)
WHERE
	CivilizationType = 'CIVILIZATION_TIBET_THUPTEN_GYATSO';

END;
