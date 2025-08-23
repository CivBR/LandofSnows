-- ArtDefine_UnitInfos
INSERT INTO
	ArtDefine_UnitInfos (Type, DamageStates, Formation)
SELECT
	'ART_DEF_UNIT_LONCHEN',
	DamageStates,
	Formation
FROM
	ArtDefine_UnitInfos
WHERE
	Type = 'ART_DEF_UNIT_GREAT_GENERAL';

-- ArtDefine_UnitInfoMemberInfos
INSERT INTO
	ArtDefine_UnitInfoMemberInfos (UnitInfoType, UnitMemberInfoType, NumMembers)
SELECT
	'ART_DEF_UNIT_LONCHEN',
	'ART_DEF_UNIT_MEMBER_LONCHEN',
	NumMembers
FROM
	ArtDefine_UnitInfoMemberInfos
WHERE
	UnitInfoType = 'ART_DEF_UNIT_GREAT_GENERAL';

-- ArtDefine_UnitMemberCombats
INSERT INTO
	ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
SELECT
	'ART_DEF_UNIT_MEMBER_LONCHEN',
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
	UnitMemberType = 'ART_DEF_UNIT_MEMBER_GREAT_GENERAL';

-- ArtDefine_UnitMemberCombatWeapons
INSERT INTO
	ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
SELECT
	'ART_DEF_UNIT_MEMBER_LONCHEN',
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
	UnitMemberType = 'ART_DEF_UNIT_MEMBER_GREAT_GENERAL';

-- ArtDefine_UnitMemberInfos
INSERT INTO
	ArtDefine_UnitMemberInfos (Type, Scale, ZOffset, Domain, Model, MaterialTypeTag, MaterialTypeSoundOverrideTag)
SELECT
	'ART_DEF_UNIT_MEMBER_LONCHEN',
	Scale,
	ZOffset,
	Domain,
	Model,
	MaterialTypeTag,
	MaterialTypeSoundOverrideTag
FROM
	ArtDefine_UnitMemberInfos
WHERE
	Type = 'ART_DEF_UNIT_MEMBER_GREAT_GENERAL';

-- Audio_Sounds
INSERT INTO
	Audio_Sounds (SoundID, Filename, LoadType)
VALUES
	('SND_LEADER_MUSIC_TIBETAN_EMPIRE_TRIMALO_PEACE', 'TibetanEmpire_Trimalo_Peace', 'DynamicResident'),
	('SND_LEADER_MUSIC_TIBETAN_EMPIRE_TRIMALO_WAR', 'TibetanEmpire_Trimalo_War', 'DynamicResident');

-- Audio_2DSounds
INSERT INTO
	Audio_2DSounds (ScriptID, SoundID, SoundType, TaperSoundtrackVolume, MinVolume, MaxVolume, IsMusic, Looping)
VALUES
	('AS2D_LEADER_MUSIC_TIBETAN_EMPIRE_TRIMALO_PEACE', 'SND_LEADER_MUSIC_TIBETAN_EMPIRE_TRIMALO_PEACE', 'GAME_MUSIC', -1.0, 50, 50, 1, 0),
	('AS2D_LEADER_MUSIC_TIBETAN_EMPIRE_TRIMALO_WAR', 'SND_LEADER_MUSIC_TIBETAN_EMPIRE_TRIMALO_WAR', 'GAME_MUSIC', -1.0, 50, 50, 1, 0);

-- Colors
INSERT INTO
	Colors (Type, Red, Green, Blue, Alpha)
VALUES
	('COLOR_PLAYER_TIBETAN_EMPIRE_TRIMALO_ICON', 0.54, 0.11, 0.15, 1),
	('COLOR_PLAYER_TIBETAN_EMPIRE_TRIMALO_BACKGROUND', 0.95, 0.87, 0.74, 1);

-- PlayerColors
INSERT INTO
	PlayerColors (Type, PrimaryColor, SecondaryColor, TextColor)
VALUES
	('PLAYERCOLOR_TIBETAN_EMPIRE_TRIMALO', 'COLOR_PLAYER_TIBETAN_EMPIRE_TRIMALO_ICON', 'COLOR_PLAYER_TIBETAN_EMPIRE_TRIMALO_BACKGROUND', 'COLOR_PLAYER_WHITE_TEXT');

-- IconTextureAtlases
INSERT INTO
	IconTextureAtlases (Atlas, IconSize, Filename, IconsPerRow, IconsPerColumn)
VALUES
	('TIBETAN_TRIMALO_ALPHA_ATLAS', 128, 'TibetanEmpire_Trimalo_AlphaAtlas_128.dds', 1, 1),
	('TIBETAN_TRIMALO_ALPHA_ATLAS', 80, 'TibetanEmpire_Trimalo_AlphaAtlas_80.dds', 1, 1),
	('TIBETAN_TRIMALO_ALPHA_ATLAS', 64, 'TibetanEmpire_Trimalo_AlphaAtlas_64.dds', 1, 1),
	('TIBETAN_TRIMALO_ALPHA_ATLAS', 48, 'TibetanEmpire_Trimalo_AlphaAtlas_48.dds', 1, 1),
	('TIBETAN_TRIMALO_ALPHA_ATLAS', 45, 'TibetanEmpire_Trimalo_AlphaAtlas_45.dds', 1, 1),
	('TIBETAN_TRIMALO_ALPHA_ATLAS', 32, 'TibetanEmpire_Trimalo_AlphaAtlas_32.dds', 1, 1),
	('TIBETAN_TRIMALO_ALPHA_ATLAS', 24, 'TibetanEmpire_Trimalo_AlphaAtlas_24.dds', 1, 1),
	('TIBETAN_TRIMALO_ALPHA_ATLAS', 16, 'TibetanEmpire_Trimalo_AlphaAtlas_16.dds', 1, 1),
	('TIBETAN_TRIMALO_ICON_ATLAS', 256, 'TibetanEmpire_Trimalo_IconAtlas_256.dds', 2, 2),
	('TIBETAN_TRIMALO_ICON_ATLAS', 128, 'TibetanEmpire_Trimalo_IconAtlas_128.dds', 2, 2),
	('TIBETAN_TRIMALO_ICON_ATLAS', 80, 'TibetanEmpire_Trimalo_IconAtlas_80.dds', 2, 2),
	('TIBETAN_TRIMALO_ICON_ATLAS', 64, 'TibetanEmpire_Trimalo_IconAtlas_64.dds', 2, 2),
	('TIBETAN_TRIMALO_ICON_ATLAS', 45, 'TibetanEmpire_Trimalo_IconAtlas_45.dds', 2, 2),
	('TIBETAN_TRIMALO_ICON_ATLAS', 32, 'TibetanEmpire_Trimalo_IconAtlas_32.dds', 2, 2),
	('TIBETAN_TRIMALO_UNIT_FLAG_ATLAS', 32, 'TibetanEmpire_Trimalo_UnitFlagAtlas_32.dds', 1, 1);