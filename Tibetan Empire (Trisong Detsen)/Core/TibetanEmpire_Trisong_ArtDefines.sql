-- ArtDefine_UnitInfos for Chakgo Tamak (Knight replacement)
INSERT INTO
    ArtDefine_UnitInfos (Type, DamageStates, Formation)
SELECT
    'ART_DEF_UNIT_CHAKGO_TAMAK',
    DamageStates,
    Formation
FROM
    ArtDefine_UnitInfos
WHERE
    Type = 'ART_DEF_UNIT_KNIGHT';

-- ArtDefine_UnitInfoMemberInfos for Chakgo Tamak
INSERT INTO
    ArtDefine_UnitInfoMemberInfos (UnitInfoType, UnitMemberInfoType, NumMembers)
SELECT
    'ART_DEF_UNIT_CHAKGO_TAMAK',
    'ART_DEF_UNIT_MEMBER_CHAKGO_TAMAK',
    NumMembers
FROM
    ArtDefine_UnitInfoMemberInfos
WHERE
    UnitInfoType = 'ART_DEF_UNIT_KNIGHT';

-- ArtDefine_UnitMemberCombats for Chakgo Tamak
INSERT INTO
    ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
SELECT
    'ART_DEF_UNIT_MEMBER_CHAKGO_TAMAK',
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
    UnitMemberType = 'ART_DEF_UNIT_MEMBER_KNIGHT';

-- ArtDefine_UnitMemberCombatWeapons for Chakgo Tamak
INSERT INTO
    ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
SELECT
    'ART_DEF_UNIT_MEMBER_CHAKGO_TAMAK',
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
    UnitMemberType = 'ART_DEF_UNIT_MEMBER_KNIGHT';

-- ArtDefine_UnitMemberInfos for Chakgo Tamak
INSERT INTO
    ArtDefine_UnitMemberInfos (Type, Scale, ZOffset, Domain, Model, MaterialTypeTag, MaterialTypeSoundOverrideTag)
SELECT
    'ART_DEF_UNIT_MEMBER_CHAKGO_TAMAK',
    Scale,
    ZOffset,
    Domain,
    Model,
    MaterialTypeTag,
    MaterialTypeSoundOverrideTag
FROM
    ArtDefine_UnitMemberInfos
WHERE
    Type = 'ART_DEF_UNIT_MEMBER_KNIGHT';

-- ArtDefine_UnitInfos for Jetsun (Great Prophet replacement)
INSERT INTO
    ArtDefine_UnitInfos (Type, DamageStates, Formation)
SELECT
    'ART_DEF_UNIT_JETSUN',
    DamageStates,
    Formation
FROM
    ArtDefine_UnitInfos
WHERE
    Type = 'ART_DEF_UNIT_PROPHET';

-- ArtDefine_UnitInfoMemberInfos for Jetsun
INSERT INTO
    ArtDefine_UnitInfoMemberInfos (UnitInfoType, UnitMemberInfoType, NumMembers)
SELECT
    'ART_DEF_UNIT_JETSUN',
    'ART_DEF_UNIT_MEMBER_JETSUN',
    NumMembers
FROM
    ArtDefine_UnitInfoMemberInfos
WHERE
    UnitInfoType = 'ART_DEF_UNIT_PROPHET';

-- ArtDefine_UnitMemberCombats for Jetsun
INSERT INTO
    ArtDefine_UnitMemberCombats (UnitMemberType, EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
SELECT
    'ART_DEF_UNIT_MEMBER_JETSUN',
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
    UnitMemberType = 'ART_DEF_UNIT_MEMBER_PROPHET';

-- ArtDefine_UnitMemberCombatWeapons for Jetsun
INSERT INTO
    ArtDefine_UnitMemberCombatWeapons (UnitMemberType, "Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
SELECT
    'ART_DEF_UNIT_MEMBER_JETSUN',
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
    UnitMemberType = 'ART_DEF_UNIT_MEMBER_PROPHET';

-- ArtDefine_UnitMemberInfos for Jetsun
INSERT INTO
    ArtDefine_UnitMemberInfos (Type, Scale, ZOffset, Domain, Model, MaterialTypeTag, MaterialTypeSoundOverrideTag)
SELECT
    'ART_DEF_UNIT_MEMBER_JETSUN',
    Scale,
    ZOffset,
    Domain,
    Model,
    MaterialTypeTag,
    MaterialTypeSoundOverrideTag
FROM
    ArtDefine_UnitMemberInfos
WHERE
    Type = 'ART_DEF_UNIT_MEMBER_PROPHET';

-- Audio_Sounds
INSERT INTO
    Audio_Sounds (SoundID, Filename, LoadType)
VALUES
    ('SND_LEADER_MUSIC_TIBETAN_EMPIRE_TRISONG_PEACE', 'TibetanEmpire_Trisong_Peace', 'DynamicResident'),
    ('SND_LEADER_MUSIC_TIBETAN_EMPIRE_TRISONG_WAR', 'TibetanEmpire_Trisong_War', 'DynamicResident');

-- Audio_2DSounds
INSERT INTO
    Audio_2DSounds (ScriptID, SoundID, SoundType, TaperSoundtrackVolume, MinVolume, MaxVolume, IsMusic, Looping)
VALUES
    ('AS2D_LEADER_MUSIC_TIBETAN_EMPIRE_TRISONG_PEACE', 'SND_LEADER_MUSIC_TIBETAN_EMPIRE_TRISONG_PEACE', 'GAME_MUSIC', -1.0, 50, 50, 1, 0),
    ('AS2D_LEADER_MUSIC_TIBETAN_EMPIRE_TRISONG_WAR', 'SND_LEADER_MUSIC_TIBETAN_EMPIRE_TRISONG_WAR', 'GAME_MUSIC', -1.0, 50, 50, 1, 0);

-- Colors
INSERT INTO
    Colors (Type, Red, Green, Blue, Alpha)
VALUES
    ('COLOR_PLAYER_TIBETAN_EMPIRE_TRISONG_ICON', 0.18, 0.32, 0.54, 1),
    ('COLOR_PLAYER_TIBETAN_EMPIRE_TRISONG_BACKGROUND', 0.95, 0.87, 0.74, 1);

-- PlayerColors
INSERT INTO
    PlayerColors (Type, PrimaryColor, SecondaryColor, TextColor)
VALUES
    ('PLAYERCOLOR_TIBETAN_EMPIRE_TRISONG', 'COLOR_PLAYER_TIBETAN_EMPIRE_TRISONG_ICON', 'COLOR_PLAYER_TIBETAN_EMPIRE_TRISONG_BACKGROUND', 'COLOR_PLAYER_WHITE_TEXT');

-- IconTextureAtlases
INSERT INTO
    IconTextureAtlases (Atlas, IconSize, Filename, IconsPerRow, IconsPerColumn)
VALUES
    ('TIBETAN_TRISONG_ALPHA_ATLAS', 128, 'TibetanEmpire_Trisong_AlphaAtlas_128.dds', 1, 1),
    ('TIBETAN_TRISONG_ALPHA_ATLAS', 80, 'TibetanEmpire_Trisong_AlphaAtlas_80.dds', 1, 1),
    ('TIBETAN_TRISONG_ALPHA_ATLAS', 64, 'TibetanEmpire_Trisong_AlphaAtlas_64.dds', 1, 1),
    ('TIBETAN_TRISONG_ALPHA_ATLAS', 48, 'TibetanEmpire_Trisong_AlphaAtlas_48.dds', 1, 1),
    ('TIBETAN_TRISONG_ALPHA_ATLAS', 45, 'TibetanEmpire_Trisong_AlphaAtlas_45.dds', 1, 1),
    ('TIBETAN_TRISONG_ALPHA_ATLAS', 32, 'TibetanEmpire_Trisong_AlphaAtlas_32.dds', 1, 1),
    ('TIBETAN_TRISONG_ALPHA_ATLAS', 24, 'TibetanEmpire_Trisong_AlphaAtlas_24.dds', 1, 1),
    ('TIBETAN_TRISONG_ALPHA_ATLAS', 16, 'TibetanEmpire_Trisong_AlphaAtlas_16.dds', 1, 1),
    ('TIBETAN_TRISONG_ICON_ATLAS', 256, 'TibetanEmpire_Trisong_IconAtlas_256.dds', 2, 2),
    ('TIBETAN_TRISONG_ICON_ATLAS', 128, 'TibetanEmpire_Trisong_IconAtlas_128.dds', 2, 2),
    ('TIBETAN_TRISONG_ICON_ATLAS', 80, 'TibetanEmpire_Trisong_IconAtlas_80.dds', 2, 2),
    ('TIBETAN_TRISONG_ICON_ATLAS', 64, 'TibetanEmpire_Trisong_IconAtlas_64.dds', 2, 2),
    ('TIBETAN_TRISONG_ICON_ATLAS', 45, 'TibetanEmpire_Trisong_IconAtlas_45.dds', 2, 2),
    ('TIBETAN_TRISONG_ICON_ATLAS', 32, 'TibetanEmpire_Trisong_IconAtlas_32.dds', 2, 2),
    ('TIBETAN_TRISONG_UNIT_FLAG_ATLAS', 32, 'TibetanEmpire_Trisong_UnitFlagAtlas_32.dds', 1, 1);