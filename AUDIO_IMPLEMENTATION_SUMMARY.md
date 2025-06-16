# AZAMANE Audio Implementation Summary

## Overview
Successfully implemented a comprehensive audio system for the AZAMANE game with the three provided audio files:

- `desert-wind-1-350398.mp3` - Desert wind background music for Welcome Screen
- `click-234708.mp3` - Click sound for all buttons
- `rebab-72605.mp3` - Rehab music for Character Customization and Amziane Intro screens

## Implementation Details

### 1. AudioManager Singleton
Created `scripts/AudioManager.gd` as an autoload singleton that handles:
- Loading and managing audio resources
- Playing background music with looping
- Playing sound effects (click sounds)
- Volume control (master, music, SFX)
- Fade in/out transitions between scenes
- Proper cleanup and signal management

### 2. Audio Integration by Screen

#### Welcome Screen (`scripts/WelcomeScreen.gd`)
- **Background Music**: Desert wind audio with fade-in on scene load
- **Click Sound**: Start button plays click sound
- **Fade Out**: Music fades out before scene transition

#### Character Customization Screen (`scripts/CharacterCustomizationScreen.gd`)
- **Background Music**: Rehab audio with fade-in on scene load
- **Click Sound**: Male/Female selection buttons play click sound
- **Fade Out**: Music fades out before scene transition

#### Amziane Intro Screen (`scripts/AmzianeIntroScreen.gd`)
- **Background Music**: Rehab audio with fade-in on scene load
- **Click Sound**: Next/Continue buttons play click sound
- **Fade Out**: Music fades out before scene transition

#### Game Description Screen (`scripts/GameDescriptionScreen.gd`)
- **Click Sound**: Next button plays click sound

#### Rules Screen (`scripts/RulesScreen.gd`)
- **Click Sound**: Next button plays click sound

#### Quest Screen (`scripts/QuestScreen.gd`)
- **Click Sound**: All option buttons (A, B, C), submit button, and back button play click sound

#### Map Screen (`scripts/MapScreen.gd`)
- **Click Sound**: All quest location buttons, time capsule button, panel close buttons, and quest start buttons play click sound

#### Mobile Launcher (`scripts/MobileLauncher.gd`)
- **Click Sound**: Normal game and mobile preview buttons play click sound

### 3. Technical Features

#### Godot 4 Compatibility
- Fixed MP3 looping by using signal-based approach instead of deprecated `loop` property
- Proper signal connection/disconnection for background music looping
- Volume control using `linear_to_db()` for proper audio scaling

#### Audio Management
- Separate audio players for background music and sound effects
- Volume controls for master, music, and SFX independently
- Fade in/out transitions for smooth audio experience
- Proper cleanup when stopping music

#### Error Handling
- Checks for AudioManager existence before making calls
- Graceful fallback if audio files are missing
- Debug logging for audio operations

## Audio Flow

### Welcome Screen Flow
1. Scene loads → Desert wind fades in (2 seconds)
2. User clicks Start → Click sound plays + music fades out
3. Scene transitions to Game Description

### Character Customization Flow
1. Scene loads → Rehab music fades in (2 seconds)
2. User selects character → Click sound plays + music fades out
3. Scene transitions to Rules Screen

### Amziane Intro Flow
1. Scene loads → Rehab music fades in (2 seconds)
2. User clicks Next/Continue → Click sound plays + music fades out
3. Scene transitions to Map Screen

### General Button Interaction
- All buttons throughout the game play click sound when pressed
- Consistent audio feedback across all screens

## Files Modified

### New Files
- `scripts/AudioManager.gd` - Main audio management singleton

### Modified Files
- `project.godot` - Added AudioManager to autoload
- `scripts/WelcomeScreen.gd` - Added desert audio + click sounds
- `scripts/CharacterCustomizationScreen.gd` - Added rehab audio + click sounds
- `scripts/AmzianeIntroScreen.gd` - Added rehab audio + click sounds
- `scripts/GameDescriptionScreen.gd` - Added click sounds
- `scripts/RulesScreen.gd` - Added click sounds
- `scripts/QuestScreen.gd` - Added click sounds to all buttons
- `scripts/MapScreen.gd` - Added click sounds to all buttons
- `scripts/MobileLauncher.gd` - Added click sounds

## Usage Instructions

The audio system is now fully integrated and will work automatically:

1. **Background Music**: Plays automatically when entering Welcome Screen (desert) or Character Customization/Amziane Intro (rehab)
2. **Click Sounds**: Play automatically when any button is pressed
3. **Smooth Transitions**: Music fades out smoothly when changing scenes

No additional setup required - the system is ready to use!

## Volume Control

The AudioManager provides volume control functions:
- `AudioManager.set_master_volume(0.0 to 1.0)`
- `AudioManager.set_music_volume(0.0 to 1.0)`
- `AudioManager.set_sfx_volume(0.0 to 1.0)`

Default volumes:
- Master: 100%
- Music: 70%
- SFX: 80%
