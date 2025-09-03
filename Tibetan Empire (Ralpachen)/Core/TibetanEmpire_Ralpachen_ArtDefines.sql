-- ArtDefine_UnitInfos
INSERT INTO
	ArtDefine_UnitInfos (Type, DamageStates, Formation)
SELECT
	'ART_DEF_UNIT_CHOLON',
	DamageStates,
	Formation
FROM
	ArtDefine_UnitInfos
WHERE
	Type = 'ART_DEF_UNIT_MERCHANT';

INSERT INTO
	ArtDefine_UnitInfos (Type, DamageStates, Formation)
SELECT
	'ART_DEF_UNIT_ZIMCHONGPA',
	DamageStates,
	Formation
FROM
	ArtDefine_UnitInfos
WHERE
	Type = 'ART_DEF_UNIT_LONGSWORDSMAN';

-- ArtDefine_UnitInfoMemberInfos
INSERT INTO
	ArtDefine_UnitInfoMemberInfos (UnitInfoType, UnitMemberInfoType, NumMembers)
SELECT
	'ART_DEF_UNIT_CHOLON',
	'ART_DEF_UNIT_MEMBER_CHOLON',
	NumMembers
FROM
	ArtDefine_UnitInfoMemberInfos
WHERE
	UnitInfoType = 'ART_DEF_UNIT_MERCHANT';

INSERT INTO
	ArtDefine_UnitInfoMemberInfos (UnitInfoType, UnitMemberInfoType, NumMembers)
SELECT
	'ART_DEF_UNIT_ZIMCHONGPA',
	'ART_DEF_UNIT_MEMBER_ZIMCHONGPA',
	NumMembers
FROM
	ArtDefine_UnitInfoMemberInfos
WHERE
	UnitInfoType = 'ART_DEF_UNIT_LONGSWORDSMAN';

-- ArtDefine_UnitMemberCombats
INSERT INTO
	ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
SELECT
	'ART_DEF_UNIT_MEMBER_CHOLON',
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
	UnitMemberType = 'ART_DEF_UNIT_MEMBER_MERCHANT';

INSERT INTO
	ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
SELECT
	'ART_DEF_UNIT_MEMBER_ZIMCHONGPA',
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
	UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN';

-- ArtDefine_UnitMemberCombatWeapons
INSERT INTO
	ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
SELECT
	'ART_DEF_UNIT_MEMBER_CHOLON',
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
	UnitMemberType = 'ART_DEF_UNIT_MEMBER_MERCHANT';

INSERT INTO
	ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
SELECT
	'ART_DEF_UNIT_MEMBER_ZIMCHONGPA',
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
	UnitMemberType = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN';

-- ArtDefine_UnitMemberInfos
INSERT INTO
	ArtDefine_UnitMemberInfos (Type, Scale, ZOffset, Domain, Model, MaterialTypeTag, MaterialTypeSoundOverrideTag)
SELECT
	'ART_DEF_UNIT_MEMBER_CHOLON',
	Scale,
	ZOffset,
	Domain,
	Model,
	MaterialTypeTag,
	MaterialTypeSoundOverrideTag
FROM
	ArtDefine_UnitMemberInfos
WHERE
	Type = 'ART_DEF_UNIT_MEMBER_MERCHANT';

INSERT INTO
	ArtDefine_UnitMemberInfos (Type, Scale, ZOffset, Domain, Model, MaterialTypeTag, MaterialTypeSoundOverrideTag)
SELECT
	'ART_DEF_UNIT_MEMBER_ZIMCHONGPA',
	Scale,
	ZOffset,
	Domain,
	Model,
	MaterialTypeTag,
	MaterialTypeSoundOverrideTag
FROM
	ArtDefine_UnitMemberInfos
WHERE
	Type = 'ART_DEF_UNIT_MEMBER_LONGSWORDSMAN';

-- ArtDefine_StrategicView
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO ArtDefine_StrategicView
        (StrategicViewType,                 TileType,        Asset)
VALUES    ('ART_DEF_UNIT_MEMBER_ZIMCHONGPA',            'Unit',         'Tibet_Thupten_Gyatso_UnitFlagAtlas_128.dds'),
          ('ART_DEF_UNIT_MEMBER_CHOLON',            'Unit',         'Tibet_Thupten_Gyatso_UnitFlagAtlas_128.dds');

-- Audio_Sounds
INSERT INTO
	Audio_Sounds (SoundID, Filename, LoadType)
VALUES
	('SND_LEADER_MUSIC_TIBETAN_EMPIRE_RALPACHEN_PEACE', 'TibetanEmpire_Ralpachen_Peace', 'DynamicResident'),
	('SND_LEADER_MUSIC_TIBETAN_EMPIRE_RALPACHEN_WAR', 'TibetanEmpire_Ralpachen_War', 'DynamicResident');

-- Audio_2DSounds
INSERT INTO
	Audio_2DSounds (ScriptID, SoundID, SoundType, TaperSoundtrackVolume, MinVolume, MaxVolume, IsMusic, Looping)
VALUES
	('AS2D_LEADER_MUSIC_TIBETAN_EMPIRE_RALPACHEN_PEACE', 'SND_LEADER_MUSIC_TIBETAN_EMPIRE_RALPACHEN_PEACE', 'GAME_MUSIC', -1.0, 50, 50, 1, 0),
	('AS2D_LEADER_MUSIC_TIBETAN_EMPIRE_RALPACHEN_WAR', 'SND_LEADER_MUSIC_TIBETAN_EMPIRE_RALPACHEN_WAR', 'GAME_MUSIC', -1.0, 50, 50, 1, 0);

-- Colors
INSERT INTO
	Colors (Type, Red, Green, Blue, Alpha)
VALUES
	('COLOR_PLAYER_TIBETAN_EMPIRE_RALPACHEN_ICON', 0.48, 0.20, 0.04, 1),
	('COLOR_PLAYER_TIBETAN_EMPIRE_RALPACHEN_BACKGROUND', 0.94, 0.73, 0.13, 1);

-- PlayerColors
INSERT INTO
	PlayerColors (Type, PrimaryColor, SecondaryColor, TextColor)
VALUES
	('PLAYERCOLOR_TIBETAN_EMPIRE_RALPACHEN', 'COLOR_PLAYER_TIBETAN_EMPIRE_RALPACHEN_ICON', 'COLOR_PLAYER_TIBETAN_EMPIRE_RALPACHEN_BACKGROUND', 'COLOR_PLAYER_WHITE_TEXT');

-- IconTextureAtlases
INSERT INTO
	IconTextureAtlases (Atlas, IconSize, Filename, IconsPerRow, IconsPerColumn)
VALUES
	('TIBETAN_EMPIRE_RALPACHEN_ALPHA_ATLAS', 128, 'TibetanEmpire_Ralpachen_AlphaAtlas_128.dds', 1, 1),
	('TIBETAN_EMPIRE_RALPACHEN_ALPHA_ATLAS', 64, 'TibetanEmpire_Ralpachen_AlphaAtlas_64.dds', 1, 1),
	('TIBETAN_EMPIRE_RALPACHEN_ALPHA_ATLAS', 48, 'TibetanEmpire_Ralpachen_AlphaAtlas_48.dds', 1, 1),
	('TIBETAN_EMPIRE_RALPACHEN_ALPHA_ATLAS', 32, 'TibetanEmpire_Ralpachen_AlphaAtlas_32.dds', 1, 1),
	('TIBETAN_EMPIRE_RALPACHEN_ALPHA_ATLAS', 24, 'TibetanEmpire_Ralpachen_AlphaAtlas_24.dds', 1, 1),
	('TIBETAN_EMPIRE_RALPACHEN_ICON_ATLAS', 256, 'TibetanEmpire_Ralpachen_IconAtlas_256.dds', 2, 2),
	('TIBETAN_EMPIRE_RALPACHEN_ICON_ATLAS', 128, 'TibetanEmpire_Ralpachen_IconAtlas_128.dds', 2, 2),
	('TIBETAN_EMPIRE_RALPACHEN_ICON_ATLAS', 80, 'TibetanEmpire_Ralpachen_IconAtlas_80.dds', 2, 2),
	('TIBETAN_EMPIRE_RALPACHEN_ICON_ATLAS', 64, 'TibetanEmpire_Ralpachen_IconAtlas_64.dds', 2, 2),
	('TIBETAN_EMPIRE_RALPACHEN_ICON_ATLAS', 45, 'TibetanEmpire_Ralpachen_IconAtlas_45.dds', 2, 2),
	('TIBETAN_EMPIRE_RALPACHEN_ICON_ATLAS', 32, 'TibetanEmpire_Ralpachen_IconAtlas_32.dds', 2, 2),
	('TIBETAN_EMPIRE_RALPACHEN_UNIT_FLAG_ATLAS', 32, 'TibetanEmpire_Ralpachen_UnitFlagAtlas_32.dds', 2, 1);
