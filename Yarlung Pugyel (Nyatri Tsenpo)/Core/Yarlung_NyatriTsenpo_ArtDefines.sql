-- ArtDefine_UnitInfos for Pawo (Great Musician replacement)
INSERT INTO
    ArtDefine_UnitInfos (Type, DamageStates, Formation)
SELECT
    'ART_DEF_UNIT_PAWO',
    DamageStates,
    Formation
FROM
    ArtDefine_UnitInfos
WHERE
    Type = 'ART_DEF_UNIT_GREAT_MUSICIAN';

-- ArtDefine_UnitInfoMemberInfos for Pawo
INSERT INTO
    ArtDefine_UnitInfoMemberInfos (UnitInfoType, UnitMemberInfoType, NumMembers)
SELECT
    'ART_DEF_UNIT_PAWO',
    'ART_DEF_UNIT_MEMBER_PAWO',
    NumMembers
FROM
    ArtDefine_UnitInfoMemberInfos
WHERE
    UnitInfoType = 'ART_DEF_UNIT_GREAT_MUSICIAN';

-- ArtDefine_UnitMemberCombats for Pawo
INSERT INTO
    ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
SELECT
    'ART_DEF_UNIT_MEMBER_PAWO',
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
    UnitMemberType = 'ART_DEF_UNIT_MEMBER_GREAT_MUSICIAN';

-- ArtDefine_UnitMemberCombatWeapons for Pawo
INSERT INTO
    ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
SELECT
    'ART_DEF_UNIT_MEMBER_PAWO',
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
    UnitMemberType = 'ART_DEF_UNIT_MEMBER_GREAT_MUSICIAN';

-- ArtDefine_UnitMemberInfos for Pawo
INSERT INTO
    ArtDefine_UnitMemberInfos (Type, Scale, ZOffset, Domain, Model, MaterialTypeTag, MaterialTypeSoundOverrideTag)
SELECT
    'ART_DEF_UNIT_MEMBER_PAWO',
    Scale,
    ZOffset,
    Domain,
    Model,
    MaterialTypeTag,
    MaterialTypeSoundOverrideTag
FROM
    ArtDefine_UnitMemberInfos
WHERE
    Type = 'ART_DEF_UNIT_MEMBER_GREAT_MUSICIAN';

-- Audio_Sounds
INSERT INTO
    Audio_Sounds (SoundID, Filename, LoadType)
VALUES
    ('SND_LEADER_MUSIC_YARLUNG_NYATRI_PEACE', 'Yarlung_Nyatri_Peace', 'DynamicResident'),
    ('SND_LEADER_MUSIC_YARLUNG_NYATRI_WAR', 'Yarlung_Nyatri_War', 'DynamicResident');

-- Audio_2DSounds
INSERT INTO
    Audio_2DSounds (ScriptID, SoundID, SoundType, TaperSoundtrackVolume, MinVolume, MaxVolume, IsMusic, Looping)
VALUES
    ('AS2D_LEADER_MUSIC_YARLUNG_NYATRI_PEACE', 'SND_LEADER_MUSIC_YARLUNG_NYATRI_PEACE', 'GAME_MUSIC', -1.0, 50, 50, 1, 0),
    ('AS2D_LEADER_MUSIC_YARLUNG_NYATRI_WAR', 'SND_LEADER_MUSIC_YARLUNG_NYATRI_WAR', 'GAME_MUSIC', -1.0, 50, 50, 1, 0);

-- Colors
INSERT INTO
    Colors (Type, Red, Green, Blue, Alpha)
VALUES
    ('COLOR_PLAYER_YARLUNG_NYATRI_ICON', 0.54, 0.11, 0.15, 1),
    ('COLOR_PLAYER_YARLUNG_NYATRI_BACKGROUND', 0.95, 0.87, 0.74, 1);

-- PlayerColors
INSERT INTO
    PlayerColors (Type, PrimaryColor, SecondaryColor, TextColor)
VALUES
    ('PLAYERCOLOR_YARLUNG_NYATRI', 'COLOR_PLAYER_YARLUNG_NYATRI_ICON', 'COLOR_PLAYER_YARLUNG_NYATRI_BACKGROUND', 'COLOR_PLAYER_WHITE_TEXT');

-- IconTextureAtlases
INSERT INTO
    IconTextureAtlases (Atlas, IconSize, Filename, IconsPerRow, IconsPerColumn)
VALUES
    ('YARLUNG_NYATRI_ALPHA_ATLAS', 128, 'Yarlung_Nyatri_AlphaAtlas_128.dds', 1, 1),
    ('YARLUNG_NYATRI_ALPHA_ATLAS', 80, 'Yarlung_Nyatri_AlphaAtlas_80.dds', 1, 1),
    ('YARLUNG_NYATRI_ALPHA_ATLAS', 64, 'Yarlung_Nyatri_AlphaAtlas_64.dds', 1, 1),
    ('YARLUNG_NYATRI_ALPHA_ATLAS', 48, 'Yarlung_Nyatri_AlphaAtlas_48.dds', 1, 1),
    ('YARLUNG_NYATRI_ALPHA_ATLAS', 45, 'Yarlung_Nyatri_AlphaAtlas_45.dds', 1, 1),
    ('YARLUNG_NYATRI_ALPHA_ATLAS', 32, 'Yarlung_Nyatri_AlphaAtlas_32.dds', 1, 1),
    ('YARLUNG_NYATRI_ALPHA_ATLAS', 24, 'Yarlung_Nyatri_AlphaAtlas_24.dds', 1, 1),
    ('YARLUNG_NYATRI_ALPHA_ATLAS', 16, 'Yarlung_Nyatri_AlphaAtlas_16.dds', 1, 1),
    ('YARLUNG_NYATRI_ICON_ATLAS', 256, 'Yarlung_Nyatri_IconAtlas_256.dds', 2, 2),
    ('YARLUNG_NYATRI_ICON_ATLAS', 128, 'Yarlung_Nyatri_IconAtlas_128.dds', 2, 2),
    ('YARLUNG_NYATRI_ICON_ATLAS', 80, 'Yarlung_Nyatri_IconAtlas_80.dds', 2, 2),
    ('YARLUNG_NYATRI_ICON_ATLAS', 64, 'Yarlung_Nyatri_IconAtlas_64.dds', 2, 2),
    ('YARLUNG_NYATRI_ICON_ATLAS', 45, 'Yarlung_Nyatri_IconAtlas_45.dds', 2, 2),
    ('YARLUNG_NYATRI_ICON_ATLAS', 32, 'Yarlung_Nyatri_IconAtlas_32.dds', 2, 2),
    ('YARLUNG_NYATRI_UNIT_FLAG_ATLAS', 32, 'Yarlung_Nyatri_UnitFlagAtlas_32.dds', 1, 1);