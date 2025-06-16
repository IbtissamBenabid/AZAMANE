# MapScreen Desert Audio Implementation

## Overview
Successfully added desert wind background music to the MapScreen in the AZAMANE game.

## Implementation Details

### Audio Flow for MapScreen

#### 1. **Map Screen Entry**
- **When**: Player enters MapScreen from any other screen
- **Audio**: Desert wind music fades in over 2 seconds
- **Location**: `MapScreen._ready()` function

#### 2. **Quest Transition**
- **When**: Player starts a quest from the map
- **Audio**: Desert wind music fades out over 1 second before transitioning to QuestScreen
- **Location**: `MapScreen.start_quest()` function

#### 3. **Return to Map**
- **When**: Player returns to MapScreen from QuestScreen (after completing quest, retrying, or going back)
- **Audio**: Desert wind music automatically fades in again (via `_ready()` function)
- **Automatic**: No additional code needed since `_ready()` is called when scene loads

## Code Changes Made

### Modified `scripts/MapScreen.gd`:

1. **Added desert audio on scene load** (lines 31-33):
```gdscript
# Start desert wind background music
if AudioManager:
    AudioManager.fade_in_background_music("desert", 2.0)
```

2. **Added fade out before quest transition** (lines 196-198):
```gdscript
# Fade out background music before scene change
if AudioManager:
    AudioManager.fade_out_background_music(1.0)
```

## Audio Experience

### Complete Audio Journey:
1. **Welcome Screen** → Desert wind music
2. **Character Customization** → Rehab music (replaces desert)
3. **Amziane Intro** → Rehab music (continues)
4. **Map Screen** → Desert wind music (returns to desert theme)
5. **Quest Screen** → No background music (focus on quest)
6. **Return to Map** → Desert wind music (resumes desert exploration)

### Benefits:
- **Thematic Consistency**: Desert wind music reinforces the desert exploration theme
- **Smooth Transitions**: Fade in/out prevents jarring audio cuts
- **Immersive Experience**: Continuous desert ambiance during map exploration
- **Automatic Resumption**: Music automatically resumes when returning from quests

## Technical Notes

- Uses the same `desert-wind-1-350398.mp3` file as the Welcome Screen
- Leverages the existing AudioManager singleton for consistent audio handling
- Fade timings: 2 seconds for fade-in, 1 second for fade-out
- No additional audio files needed - reuses existing desert wind audio
- Compatible with all existing click sounds on map buttons

## Integration with Existing Audio System

The MapScreen desert audio integrates seamlessly with the existing audio system:
- **Welcome Screen**: Desert wind → Game Description (silent) → Character Customization (rehab)
- **Character Customization**: Rehab → Rules (silent) → Amziane Intro (rehab)  
- **Amziane Intro**: Rehab → **Map Screen (desert)** ← Perfect transition!
- **Map Screen**: Desert → Quest (silent) → Map (desert) ← Seamless loop!

This creates a natural audio progression that matches the game's narrative flow from welcome to character setup to desert exploration.
