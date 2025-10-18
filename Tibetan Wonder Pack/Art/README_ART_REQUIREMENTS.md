# Tibetan Wonder Pack - Art Requirements

This document outlines all the art assets required for the Tibetan Wonder Pack mod to function properly.

## Directory Structure

```
Art/
├── Atlases/           # Icon files for wonder selection/city screens
└── Splashes/          # Wonder completion splash screens
```

## Required Icon Atlas Files

For each wonder, you need 5 different icon sizes in DDS format:

testing push

### Yumbu Lagang
- `Art/Atlases/YumbuLagang_256.dds` (256x256 pixels)
- `Art/Atlases/YumbuLagang_128.dds` (128x128 pixels)
- `Art/Atlases/YumbuLagang_80.dds` (80x80 pixels)
- `Art/Atlases/YumbuLagang_64.dds` (64x64 pixels)
- `Art/Atlases/YumbuLagang_45.dds` (45x45 pixels)

### Jokhang Temple
- `Art/Atlases/JokhangTemple_256.dds`
- `Art/Atlases/JokhangTemple_128.dds`
- `Art/Atlases/JokhangTemple_80.dds`
- `Art/Atlases/JokhangTemple_64.dds`
- `Art/Atlases/JokhangTemple_45.dds`

### Samye Monastery
- `Art/Atlases/SamyeMonastery_256.dds`
- `Art/Atlases/SamyeMonastery_128.dds`
- `Art/Atlases/SamyeMonastery_80.dds`
- `Art/Atlases/SamyeMonastery_64.dds`
- `Art/Atlases/SamyeMonastery_45.dds`

### Sakya Great Library
- `Art/Atlases/SakyaLibrary_256.dds`
- `Art/Atlases/SakyaLibrary_128.dds`
- `Art/Atlases/SakyaLibrary_80.dds`
- `Art/Atlases/SakyaLibrary_64.dds`
- `Art/Atlases/SakyaLibrary_45.dds`

### Potala Palace
- `Art/Atlases/PotalaPalace_256.dds`
- `Art/Atlases/PotalaPalace_128.dds`
- `Art/Atlases/PotalaPalace_80.dds`
- `Art/Atlases/PotalaPalace_64.dds`
- `Art/Atlases/PotalaPalace_45.dds`

### Norbulingka
- `Art/Atlases/Norbulingka_256.dds`
- `Art/Atlases/Norbulingka_128.dds`
- `Art/Atlases/Norbulingka_80.dds`
- `Art/Atlases/Norbulingka_64.dds`
- `Art/Atlases/Norbulingka_45.dds`

### Gyantse Kumbum
- `Art/Atlases/GyantseKumbum_256.dds`
- `Art/Atlases/GyantseKumbum_128.dds`
- `Art/Atlases/GyantseKumbum_80.dds`
- `Art/Atlases/GyantseKumbum_64.dds`
- `Art/Atlases/GyantseKumbum_45.dds`

### Dégé Parkhang
- `Art/Atlases/DegeParkhang_256.dds`
- `Art/Atlases/DegeParkhang_128.dds`
- `Art/Atlases/DegeParkhang_80.dds`
- `Art/Atlases/DegeParkhang_64.dds`
- `Art/Atlases/DegeParkhang_45.dds`

## Required Wonder Splash Screen Files

One splash screen per wonder (recommended resolution: 1024x768 or higher):

- `Art/Splashes/YUMBU_LAGANG_splash.dds`
- `Art/Splashes/JOKHANG_TEMPLE_splash.dds`
- `Art/Splashes/SAMYE_MONASTERY_splash.dds`
- `Art/Splashes/SAKYA_LIBRARY_splash.dds`
- `Art/Splashes/POTALA_PALACE_splash.dds`
- `Art/Splashes/NORBULINGKA_splash.dds`
- `Art/Splashes/GYANTSE_KUMBUM_splash.dds`
- `Art/Splashes/DEGE_PARKHANG_splash.dds`

## Art Creation Guidelines

### Icons
- Should show the distinctive architectural features of each wonder
- Use warm, earthy colors that reflect Tibetan architecture (reds, golds, whites)
- Ensure good contrast and visibility at smallest sizes (45x45)
- Consider the wonder's unique characteristics when designing

### Splash Screens
- Should be dramatic and inspiring
- Include environmental context (mountains, sky, surrounding landscape)
- Use the game's existing splash screen style as reference
- Consider including architectural details and cultural elements

## Wonder Descriptions for Artists

1. **Yumbu Lagang**: Tibet's first palace, a fortress-like structure on a hilltop
2. **Jokhang Temple**: Sacred golden-roofed temple in Lhasa with distinctive Tibetan architecture
3. **Samye Monastery**: First Buddhist monastery in Tibet with unique cosmic layout
4. **Sakya Library**: Ancient monastery library with distinctive striped walls
5. **Potala Palace**: Massive red and white palace complex on a mountain
6. **Norbulingka**: Beautiful summer palace with extensive gardens and pavilions
7. **Gyantse Kumbum**: Multi-story chorten (stupa) with intricate mandala design
8. **Dégé Parkhang**: Traditional printing house with wooden architecture

## File Format Notes

- All files must be in DDS format
- Use BC1/DXT1 compression for files without alpha
- Use BC3/DXT5 compression for files with alpha transparency
- Ensure mipmaps are generated for optimal performance
- Test files in-game to verify proper display
