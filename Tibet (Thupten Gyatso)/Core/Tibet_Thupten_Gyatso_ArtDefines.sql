-- ArtDefine_UnitInfos
INSERT INTO
	ArtDefine_UnitInfos (Type, DamageStates, Formation)
SELECT
	'ART_DEF_UNIT_TIBET_KUSUNG',
	DamageStates,
	Formation
FROM
	ArtDefine_UnitInfos
WHERE
	Type = 'ART_DEF_UNIT_GREAT_WAR_INFANTRY';

-- ArtDefine_UnitInfoMemberInfos
INSERT INTO
	ArtDefine_UnitInfoMemberInfos (UnitInfoType, UnitMemberInfoType, NumMembers)
SELECT
	'ART_DEF_UNIT_TIBET_KUSUNG',
	'ART_DEF_UNIT_MEMBER_TIBET_KUSUNG',
	NumMembers
FROM
	ArtDefine_UnitInfoMemberInfos
WHERE
	UnitInfoType = 'ART_DEF_UNIT_GREAT_WAR_INFANTRY';

-- ArtDefine_UnitMemberCombats
INSERT INTO
	ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
SELECT
	'ART_DEF_UNIT_MEMBER_TIBET_KUSUNG',
	EnableActions,
	DisableActions,
	MoveRadius,
	ShortMoveRadius,
	ChargeRadius,
	AttackRadius,
	RangedAttackRadius,
	MoveRate,
	ShortMoveRate,
	TurnRateMin,
	TurnRateMax,
	TurnFacingRateMin,
	TurnFacingRateMax,
	RollRateMin,
	RollRateMax,
	PitchRateMin,
	PitchRateMax,
	LOSRadiusScale,
	TargetRadius,
	TargetHeight,
	HasShortRangedAttack,
	HasLongRangedAttack,
	HasLeftRightAttack,
	HasStationaryMelee,
	HasStationaryRangedAttack,
	HasRefaceAfterCombat,
	ReformBeforeCombat,
	HasIndependentWeaponFacing,
	HasOpponentTracking,
	HasCollisionAttack,
	AttackAltitude,
	AltitudeDecelerationDistance,
	OnlyTurnInMovementActions,
	RushAttackFormation
FROM
	ArtDefine_UnitMemberCombats
WHERE
	UnitMemberType = 'ART_DEF_UNIT_MEMBER_GREAT_WAR_INFANTRY';

-- ArtDefine_UnitMemberCombatWeapons
INSERT INTO
	ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
SELECT
	'ART_DEF_UNIT_MEMBER_TIBET_KUSUNG',
	"Index",
	SubIndex,
	ID,
	VisKillStrengthMin,
	VisKillStrengthMax,
	ProjectileSpeed,
	ProjectileTurnRateMin,
	ProjectileTurnRateMax,
	HitEffect,
	HitEffectScale,
	HitRadius,
	ProjectileChildEffectScale,
	AreaDamageDelay,
	ContinuousFire,
	WaitForEffectCompletion,
	TargetGround,
	IsDropped,
	WeaponTypeTag,
	WeaponTypeSoundOverrideTag
FROM
	ArtDefine_UnitMemberCombatWeapons
WHERE
	UnitMemberType = 'ART_DEF_UNIT_MEMBER_GREAT_WAR_INFANTRY';

-- ArtDefine_UnitMemberInfos
INSERT INTO
	ArtDefine_UnitMemberInfos (Type, Scale, ZOffset, Domain, Model, MaterialTypeTag, MaterialTypeSoundOverrideTag)
SELECT
	'ART_DEF_UNIT_MEMBER_TIBET_KUSUNG',
	Scale,
	ZOffset,
	Domain,
	Model,
	MaterialTypeTag,
	MaterialTypeSoundOverrideTag
FROM
	ArtDefine_UnitMemberInfos
WHERE
	Type = 'ART_DEF_UNIT_MEMBER_GREAT_WAR_INFANTRY';

-- Audio_Sounds
INSERT INTO
	Audio_Sounds (SoundID, Filename, LoadType)
VALUES
	('SND_LEADER_MUSIC_TIBET_THUPTEN_GYATSO_PEACE', 'Tibet_Thupten_Gyatso_Peace', 'DynamicResident'),
	('SND_LEADER_MUSIC_TIBET_THUPTEN_GYATSO_WAR', 'Tibet_Thupten_Gyatso_War', 'DynamicResident');

-- Audio_2DSounds
INSERT INTO
	Audio_2DSounds (ScriptID, SoundID, SoundType, TaperSoundtrackVolume, MinVolume, MaxVolume, IsMusic, Looping)
VALUES
	('AS2D_LEADER_MUSIC_TIBET_THUPTEN_GYATSO_PEACE', 'SND_LEADER_MUSIC_TIBET_THUPTEN_GYATSO_PEACE', 'GAME_MUSIC', -1.0, 50, 50, 1, 0),
	('AS2D_LEADER_MUSIC_TIBET_THUPTEN_GYATSO_WAR', 'SND_LEADER_MUSIC_TIBET_THUPTEN_GYATSO_WAR', 'GAME_MUSIC', -1.0, 50, 50, 1, 0);

-- Colors
INSERT INTO
	Colors (Type, Red, Green, Blue, Alpha)
VALUES
	('COLOR_PLAYER_TIBET_THUPTEN_GYATSO_ICON', 0.66, 0.17, 0.01, 1),
	('COLOR_PLAYER_TIBET_THUPTEN_GYATSO_BACKGROUND', 0.94, 0.84, 0.8, 1);

-- PlayerColors
INSERT INTO
	PlayerColors (Type, PrimaryColor, SecondaryColor, TextColor)
VALUES
	('PLAYERCOLOR_TIBET_THUPTEN_GYATSO', 'COLOR_PLAYER_TIBET_THUPTEN_GYATSO_ICON', 'COLOR_PLAYER_TIBET_THUPTEN_GYATSO_BACKGROUND', 'COLOR_PLAYER_WHITE_TEXT');

-- IconTextureAtlases
INSERT INTO
	IconTextureAtlases (Atlas, IconSize, Filename, IconsPerRow, IconsPerColumn)
VALUES
	('TIBET_THUPTEN_GYATSO_ALPHA_ATLAS', 128, 'Tibet_Thupten_Gyatso_AlphaAtlas_128.dds', 1, 1),
	('TIBET_THUPTEN_GYATSO_ALPHA_ATLAS', 80, 'Tibet_Thupten_Gyatso_AlphaAtlas_80.dds', 1, 1),
	('TIBET_THUPTEN_GYATSO_ALPHA_ATLAS', 64, 'Tibet_Thupten_Gyatso_AlphaAtlas_64.dds', 1, 1),
	('TIBET_THUPTEN_GYATSO_ALPHA_ATLAS', 48, 'Tibet_Thupten_Gyatso_AlphaAtlas_48.dds', 1, 1),
	('TIBET_THUPTEN_GYATSO_ALPHA_ATLAS', 45, 'Tibet_Thupten_Gyatso_AlphaAtlas_45.dds', 1, 1),
	('TIBET_THUPTEN_GYATSO_ALPHA_ATLAS', 32, 'Tibet_Thupten_Gyatso_AlphaAtlas_32.dds', 1, 1),
	('TIBET_THUPTEN_GYATSO_ALPHA_ATLAS', 24, 'Tibet_Thupten_Gyatso_AlphaAtlas_24.dds', 1, 1),
	('TIBET_THUPTEN_GYATSO_ALPHA_ATLAS', 16, 'Tibet_Thupten_Gyatso_AlphaAtlas_16.dds', 1, 1),
	('TIBET_THUPTEN_GYATSO_ICON_ATLAS', 256, 'Tibet_Thupten_Gyatso_IconAtlas_256.dds', 2, 2),
	('TIBET_THUPTEN_GYATSO_ICON_ATLAS', 128, 'Tibet_Thupten_Gyatso_IconAtlas_128.dds', 2, 2),
	('TIBET_THUPTEN_GYATSO_ICON_ATLAS', 80, 'Tibet_Thupten_Gyatso_IconAtlas_80.dds', 2, 2),
	('TIBET_THUPTEN_GYATSO_ICON_ATLAS', 64, 'Tibet_Thupten_Gyatso_IconAtlas_64.dds', 2, 2),
	('TIBET_THUPTEN_GYATSO_ICON_ATLAS', 45, 'Tibet_Thupten_Gyatso_IconAtlas_45.dds', 2, 2),
	('TIBET_THUPTEN_GYATSO_ICON_ATLAS', 32, 'Tibet_Thupten_Gyatso_IconAtlas_32.dds', 2, 2),
	('TIBET_THUPTEN_GYATSO_UNIT_FLAG_ATLAS', 32, 'Tibet_Thupten_Gyatso_UnitFlagAtlas_32.dds', 1, 1);