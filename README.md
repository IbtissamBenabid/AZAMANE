# 🏜️ AZAMANE - Moroccan Time Capsule

[![Godot Engine](https://img.shields.io/badge/Godot-4.4+-blue.svg)](https://godotengine.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Cultural Heritage](https://img.shields.io/badge/Cultural-Heritage-gold.svg)](https://en.wikipedia.org/wiki/Berber_culture)

A text-based, narrative-driven 2D game exploring Morocco's 7th-century multicultural history and folklore through the eyes of Amziane, a Berber merchant.

![Game Screenshot](https://via.placeholder.com/800x400/2A3F7B/D4A017?text=AZAMANE+-+Moroccan+Time+Capsule)

## 🎮 Play Online
[🎯 **Play AZAMANE in Your Browser**](https://your-username.github.io/azamane-moroccan-time-capsule/) *(Coming Soon)*

## 🎮 Game Overview

**AZAMANE** takes players on a journey through Morocco's vibrant desert trade routes, where they embody Amziane, a clever Berber merchant. Through riddles, tales, and cultural encounters, players earn Culture Points and build community trust while collecting treasures for their time capsule.

## 🎯 Features

### ✅ **Completed Features**
- **Welcome Screen** - Animated title with desert atmosphere and particle effects
- **Game Description** - Introduction to the game world
- **Character Customization** - Choose gender and clothing styles with real-time preview
- **Rules Screen** - Game mechanics explanation
- **Amziane Introduction** - Meet your character with entrance animations
- **Interactive Map** - Desert outpost with character movement and clickable quest locations
- **Quest System** - 3 unique quests with riddles and cultural insights
- **Culture Points & Trust System** - Progress tracking with visual feedback
- **Time Capsule** - Collectible rewards with cultural lore
- **SVG Assets** - Scalable graphics with authentic Moroccan design

### 🎨 **Enhanced Visual Features**
- **Character Movement** - Amziane walks to quest locations on the map
- **Gender Variants** - Male and female character sprites with cultural authenticity
- **Interactive Elements** - Hover effects, button animations, and visual feedback
- **Particle Effects** - Desert atmosphere with floating particles
- **Smooth Animations** - Character entrance, selection feedback, and transitions
- **Visual Effects System** - Reusable effects for enhanced user experience

### 🎨 **Visual Design**
- **Authentic Color Palette**: Deep Blue (#2A3F7B), Desert Brown (#8B5523), Moroccan Gold (#D4A017), Oasis Green (#355E3B)
- **Cultural Assets**: Berber clothing, desert landscapes, traditional items
- **Scalable SVG Graphics**: Optimized for web deployment

## 🗺️ Game Flow

1. **Welcome Screen** → Start adventure
2. **Game Description** → Learn about the world
3. **Character Customization** → Choose Amziane's appearance
4. **Rules** → Understand game mechanics
5. **Meet Amziane** → Character introduction
6. **Desert Map** → Interactive quest selection
7. **Quests** → Solve riddles and earn rewards

## 🏜️ Quest System

### **Available Quests**
1. **Trader's Riddle** - Test your desert wisdom
2. **Camel Track** - Follow mystical clues to find a lost camel
3. **Berber Tale** - Share traditional stories at the caravan camp

### **Rewards**
- **Culture Points** (1-3 per quest)
- **Trust Level** progression (Low → Medium → High)
- **Collectibles** for time capsule:
  - Desert Veil
  - Salt Crystal
  - Carved Staff

## 🛠️ Technical Details

### **Built With**
- **Engine**: Godot 4.2
- **Graphics**: SVG assets for scalability
- **Target Platform**: HTML5 for web browsers
- **Resolution**: 320x180 base (scalable)

### **Project Structure**
```
AZAMANE/
├── assets/
│   ├── backgrounds/     # Scene backgrounds (320x180)
│   ├── sprites/         # Characters & items (32x32, 16x16)
│   └── audio/           # Sound effects (placeholder)
├── scenes/              # Game scenes (.tscn files)
├── scripts/             # GDScript files (.gd)
├── project.godot        # Godot project configuration
└── icon.svg            # Game icon
```

### **Key Scripts**
- **GameManager.gd** - Global game state and progression
- **WelcomeScreen.gd** - Main menu functionality
- **CharacterCustomizationScreen.gd** - Player customization
- **MapScreen.gd** - Interactive quest map
- **QuestScreen.gd** - Quest interactions and riddles

## 🎨 Assets Included

### **Backgrounds (320x180)**
- `desert_outpost_welcome_320x180.svg` - Welcome screen
- `desert_outpost_main_320x180.svg` - Interactive map
- `character_creation_320x180.svg` - Customization backdrop
- `narrative_scroll_320x180.svg` - Story screens

### **Character Sprites (32x32)**
- `amziane_32x32.svg` - Main character
- `player_base_32x32.svg` - Blue djellaba variant
- `player_djellaba_green_32x32.svg` - Green djellaba variant
- `player_tunic_blue_32x32.svg` - Blue tunic variant

### **Collectibles (16x16)**
- `salt_crystal_16x16.svg` - Trade quest reward
- `desert_veil_16x16.svg` - Riddle quest reward
- `berber_tale_16x16.svg` - Story quest reward

### **UI Elements**
- `dialog_panel.svg` - Quest dialog background
- `hotspot_marker.svg` - Map location indicators
- `ui_button_normal.svg` / `ui_button_pressed.svg` - Button states

## 🚀 How to Run

### **Option 1: Godot Editor**
1. Install Godot 4.2+
2. Open `project.godot`
3. Press F5 to run

### **Option 2: Web Export**
1. Export as HTML5 from Godot
2. Host on web server
3. Play in browser

### **Option 3: Test Script**
```bash
godot --script test_game.gd
```

## 🌟 Cultural Authenticity

### **Historical Accuracy**
- **7th-century setting** with period-appropriate elements
- **Berber trade culture** accurately represented
- **Trans-Saharan commerce** themes
- **Traditional clothing** and architecture

### **Educational Value**
- **Tamazight riddles** showcase Berber wisdom
- **Cultural insights** with each quest completion
- **Historical context** woven into gameplay
- **Respectful representation** of Moroccan heritage

## 🎯 Future Enhancements

- **Audio System** - Desert winds, market sounds
- **Additional Quests** - Expand the adventure
- **Multiplayer Elements** - Share time capsules
- **Mobile Optimization** - Touch-friendly controls
- **Localization** - Arabic/Berber language support

## 📝 Credits

**Game Design & Development**: AZAMANE Team
**Cultural Consultation**: Moroccan Heritage Research
**Art Style**: Authentic Berber-inspired pixel art
**Music**: Traditional Moroccan instruments (planned)

---

**Experience the magic of 7th-century Morocco through the eyes of Amziane! 🏜️✨**
