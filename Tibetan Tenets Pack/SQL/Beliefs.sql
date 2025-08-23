-- Buddhist Religion Expansion - Beliefs
-- Adds new Pantheon, Founder, Enhancer, and Reformation beliefs

-- Pantheon: Sacred Peaks & Hidden Valleys
INSERT INTO Beliefs
		(Type, 						Description, 								ShortDescription, 									Pantheon)
VALUES 	('BELIEF_SACRED_PEAKS', 	'TXT_KEY_BELIEF_SACRED_PEAKS', 			'TXT_KEY_BELIEF_SACRED_PEAKS_SHORT', 				1);

-- Shrine bonus for Sacred Peaks
INSERT INTO Belief_BuildingClassYieldChanges
		(BeliefType, 				BuildingClassType, 			YieldType, 			YieldChange)
VALUES	('BELIEF_SACRED_PEAKS', 	'BUILDINGCLASS_SHRINE', 		'YIELD_FAITH', 		1);

-- Founder: Universal Compassion
INSERT INTO Beliefs
		(Type, 							Description, 								ShortDescription, 									Founder)
VALUES 	('BELIEF_UNIVERSAL_COMPASSION', 'TXT_KEY_BELIEF_UNIVERSAL_COMPASSION', 	'TXT_KEY_BELIEF_UNIVERSAL_COMPASSION_SHORT', 		1);

-- Follower: Gompas (building-based belief)
INSERT INTO Beliefs
		(Type, 				Description, 					ShortDescription, 						Follower)
VALUES 	('BELIEF_GOMPAS', 	'TXT_KEY_BELIEF_GOMPAS', 		'TXT_KEY_BELIEF_GOMPAS_SHORT', 		1);

-- Allow Gompas to be purchased with Faith
INSERT INTO Belief_BuildingClassFaithPurchase
		(BeliefType, 		BuildingClassType)
VALUES	('BELIEF_GOMPAS', 	'BUILDINGCLASS_GOMPA');

-- Enhancer: Monastic Debate
INSERT INTO Beliefs
		(Type, 						Description, 							ShortDescription, 								Enhancer)
VALUES 	('BELIEF_MONASTIC_DEBATE', 'TXT_KEY_BELIEF_MONASTIC_DEBATE', 		'TXT_KEY_BELIEF_MONASTIC_DEBATE_SHORT', 		1);

-- Reformation: Non-Sectarianism (Burst of Faith when other religions spread)
INSERT INTO Beliefs
		(Type, 							Description, 								ShortDescription, 									Reformation)
VALUES 	('BELIEF_NON_SECTARIANISM', 	'TXT_KEY_BELIEF_NON_SECTARIANISM', 		'TXT_KEY_BELIEF_NON_SECTARIANISM_SHORT', 			1);
