#!/usr/bin/env python3
"""
AZAMANE Game Validation Script
Checks if all required files and assets are present
"""

import os
import sys

def check_file_exists(filepath, description):
    """Check if a file exists and print result"""
    if os.path.exists(filepath):
        print(f"  ✅ {description}")
        return True
    else:
        print(f"  ❌ {description} - MISSING: {filepath}")
        return False

def validate_azamane_game():
    """Validate the AZAMANE game structure"""
    print("=== AZAMANE - Moroccan Time Capsule Validation ===\n")
    
    all_good = True
    
    # 1. Core Project Files
    print("1. Core Project Files:")
    core_files = [
        ("project.godot", "Godot project file"),
        ("icon.svg", "Game icon"),
        ("README.md", "Documentation"),
        ("test_game.gd", "Test script")
    ]
    
    for filepath, desc in core_files:
        if not check_file_exists(filepath, desc):
            all_good = False
    
    # 2. Scene Files
    print("\n2. Game Scenes:")
    scene_files = [
        ("scenes/WelcomeScreen.tscn", "Welcome Screen"),
        ("scenes/GameDescriptionScreen.tscn", "Game Description"),
        ("scenes/CharacterCustomizationScreen.tscn", "Character Customization"),
        ("scenes/RulesScreen.tscn", "Rules Screen"),
        ("scenes/AmzianeIntroScreen.tscn", "Amziane Introduction"),
        ("scenes/MapScreen.tscn", "Interactive Map"),
        ("scenes/QuestScreen.tscn", "Quest Screen")
    ]
    
    for filepath, desc in scene_files:
        if not check_file_exists(filepath, desc):
            all_good = False
    
    # 3. Script Files
    print("\n3. Game Scripts:")
    script_files = [
        ("scripts/GameManager.gd", "Game Manager"),
        ("scripts/WelcomeScreen.gd", "Welcome Screen Script"),
        ("scripts/GameDescriptionScreen.gd", "Game Description Script"),
        ("scripts/CharacterCustomizationScreen.gd", "Character Customization Script"),
        ("scripts/RulesScreen.gd", "Rules Screen Script"),
        ("scripts/AmzianeIntroScreen.gd", "Amziane Introduction Script"),
        ("scripts/MapScreen.gd", "Map Screen Script"),
        ("scripts/QuestScreen.gd", "Quest Screen Script")
    ]
    
    for filepath, desc in script_files:
        if not check_file_exists(filepath, desc):
            all_good = False
    
    # 4. Background Assets
    print("\n4. Background Assets:")
    background_assets = [
        ("assets/backgrounds/desert_outpost_welcome_320x180.svg", "Welcome Background"),
        ("assets/backgrounds/desert_outpost_main_320x180.svg", "Map Background"),
        ("assets/backgrounds/character_creation_320x180.svg", "Character Creation Background"),
        ("assets/backgrounds/narrative_scroll_320x180.svg", "Narrative Background")
    ]
    
    for filepath, desc in background_assets:
        if not check_file_exists(filepath, desc):
            all_good = False
    
    # 5. Character Sprites
    print("\n5. Character Sprites:")
    sprite_assets = [
        ("assets/sprites/amziane_32x32.svg", "Amziane Character (Male)"),
        ("assets/sprites/amziane_female_32x32.svg", "Amziane Character (Female)"),
        ("assets/sprites/player_base_32x32.svg", "Player Base Sprite (Male)"),
        ("assets/sprites/player_djellaba_green_32x32.svg", "Green Djellaba Variant (Male)"),
        ("assets/sprites/player_tunic_blue_32x32.svg", "Blue Tunic Variant (Male)"),
        ("assets/sprites/player_female_base_32x32.svg", "Player Base Sprite (Female)"),
        ("assets/sprites/player_female_djellaba_green_32x32.svg", "Green Djellaba Variant (Female)"),
        ("assets/sprites/player_female_tunic_blue_32x32.svg", "Blue Tunic Variant (Female)")
    ]
    
    for filepath, desc in sprite_assets:
        if not check_file_exists(filepath, desc):
            all_good = False
    
    # 6. Collectible Assets
    print("\n6. Collectible Items:")
    collectible_assets = [
        ("assets/sprites/salt_crystal_16x16.svg", "Salt Crystal"),
        ("assets/sprites/desert_veil_16x16.svg", "Desert Veil"),
        ("assets/sprites/berber_tale_16x16.svg", "Berber Tale")
    ]
    
    for filepath, desc in collectible_assets:
        if not check_file_exists(filepath, desc):
            all_good = False
    
    # 7. UI Assets
    print("\n7. UI Elements:")
    ui_assets = [
        ("assets/sprites/dialog_panel.svg", "Dialog Panel"),
        ("assets/sprites/hotspot_marker.svg", "Hotspot Marker"),
        ("assets/sprites/ui_button_normal.svg", "Normal Button"),
        ("assets/sprites/ui_button_pressed.svg", "Pressed Button")
    ]
    
    for filepath, desc in ui_assets:
        if not check_file_exists(filepath, desc):
            all_good = False
    
    # Summary
    print("\n" + "="*50)
    if all_good:
        print("🎉 VALIDATION PASSED! All files are present.")
        print("✅ AZAMANE is ready to play!")
        print("\nNext steps:")
        print("1. Install Godot 4.2+ from https://godotengine.org/download")
        print("2. Open project.godot in Godot")
        print("3. Press F5 to run the game")
    else:
        print("❌ VALIDATION FAILED! Some files are missing.")
        print("Please check the missing files above.")
    
    return all_good

if __name__ == "__main__":
    validate_azamane_game()
