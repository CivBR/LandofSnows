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
    Type = 'ART_DEF_UNIT_MUSICIAN';

-- ArtDefine_Landmarks for Sky Burial Ground
INSERT INTO ArtDefine_Landmarks (Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour)
VALUES
('Any', 'UnderConstruction', 0.12, 'ART_DEF_IMPROVEMENT_SKY_BURIAL_GROUND', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'er_burial_ground.fxsxml', 1),
('Any', 'Constructed',		 0.12, 'ART_DEF_IMPROVEMENT_SKY_BURIAL_GROUND', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'er_burial_ground.fxsxml', 1),
('Any', 'Pillaged', 		 0.12, 'ART_DEF_IMPROVEMENT_SKY_BURIAL_GROUND', 'SNAPSHOT', 'ART_DEF_RESOURCE_ALL', 'er_burial_ground.fxsxml', 1);

-- ArtDefine_Landmarks for Sacred Peak Feature
INSERT INTO ArtDefine_Landmarks (Era, State, Scale, ImprovementType, LayoutHandler, ResourceType, Model, TerrainContour)
VALUES
('Any', 'Any', 0.3, 'ART_DEF_IMPROVEMENT_NONE', 'SNAPSHOT', 'ART_DEF_FEATURE_SACRED_PEAK', 'feature_sacred_peak.fxsxml', 1);

-- ArtDefine_LandmarkTypes for Sky Burial Ground
INSERT INTO ArtDefine_LandmarkTypes (Type, LandmarkType, FriendlyName)
VALUES ('ART_DEF_IMPROVEMENT_SKY_BURIAL_GROUND', 'Improvement', 'Sky Burial Ground');

-- ArtDefine_LandmarkTypes for Sacred Peak Feature
INSERT INTO ArtDefine_LandmarkTypes (Type, LandmarkType, FriendlyName)
VALUES ('ART_DEF_FEATURE_SACRED_PEAK', 'Feature', 'Sacred Peak');

-- ArtDefine_StrategicView for Sky Burial Ground
INSERT INTO ArtDefine_StrategicView (StrategicViewType, TileType, Asset)
VALUES ('ART_DEF_IMPROVEMENT_SKY_BURIAL_GROUND', 'Improvement', 'er_burial_vulture_sref.dds');

-- ArtDefine_StrategicView for Sacred Peak Feature
INSERT INTO ArtDefine_StrategicView (StrategicViewType, TileType, Asset)
VALUES ('ART_DEF_FEATURE_SACRED_PEAK', 'Feature', 'plague_decal_h.dds');

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
    UnitInfoType = 'ART_DEF_UNIT_MUSICIAN';

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
    UnitMemberType = 'ART_DEF_UNIT_MEMBER_MUSICIAN';

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
    UnitMemberType = 'ART_DEF_UNIT_MEMBER_MUSICIAN';

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
    Type = 'ART_DEF_UNIT_MEMBER_MUSICIAN';

-- ArtDefine_StrategicView
INSERT OR REPLACE INTO ArtDefine_StrategicView (StrategicViewType, TileType, Asset)
VALUES ('ART_DEF_UNIT_MEMBER_PAWO', 'Unit', 'Yarlung_Nyatri_UnitFlagAtlas_128.dds');

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
    ('COLOR_PLAYER_YARLUNG_NYATRI_ICON', 0.94, 0.98, 0.68, 1),
    ('COLOR_PLAYER_YARLUNG_NYATRI_BACKGROUND', 0.01, 0.47, 0.41, 1);

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
    ('YARLUNG_NYATRI_ALPHA_ATLAS', 64, 'Yarlung_Nyatri_AlphaAtlas_64.dds', 1, 1),
    ('YARLUNG_NYATRI_ALPHA_ATLAS', 48, 'Yarlung_Nyatri_AlphaAtlas_48.dds', 1, 1),
    ('YARLUNG_NYATRI_ALPHA_ATLAS', 32, 'Yarlung_Nyatri_AlphaAtlas_32.dds', 1, 1),
    ('YARLUNG_NYATRI_ALPHA_ATLAS', 24, 'Yarlung_Nyatri_AlphaAtlas_24.dds', 1, 1),
    ('YARLUNG_NYATRI_ICON_ATLAS', 256, 'Yarlung_Nyatri_IconAtlas_256.dds', 2, 2),
    ('YARLUNG_NYATRI_ICON_ATLAS', 128, 'Yarlung_Nyatri_IconAtlas_128.dds', 2, 2),
    ('YARLUNG_NYATRI_ICON_ATLAS', 80, 'Yarlung_Nyatri_IconAtlas_80.dds', 2, 2),
    ('YARLUNG_NYATRI_ICON_ATLAS', 64, 'Yarlung_Nyatri_IconAtlas_64.dds', 2, 2),
    ('YARLUNG_NYATRI_ICON_ATLAS', 45, 'Yarlung_Nyatri_IconAtlas_45.dds', 2, 2),
    ('YARLUNG_NYATRI_ICON_ATLAS', 32, 'Yarlung_Nyatri_IconAtlas_32.dds', 2, 2),
    ('YARLUNG_NYATRI_UNIT_FLAG_ATLAS', 32, 'Yarlung_Nyatri_UnitFlagAtlas_32.dds', 1, 1),
    ('YARLUNG_NYATRI_UI_ATLAS', 45, 'YarlungButtonUI_45.dds', 1, 1),
    ('YARLUNG_NYATRI_UI_ATLAS', 64, 'YarlungButtonUI_64.dds', 1, 1);
