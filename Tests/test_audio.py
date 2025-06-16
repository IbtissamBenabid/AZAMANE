#!/usr/bin/env python3
"""
Test script to validate audio implementation in AZAMANE game
"""

import os
import sys

def test_audio_files_exist():
    """Test that all required audio files exist"""
    print("Testing audio files existence...")
    
    audio_files = [
        "assets/audio/desert-wind-1-350398.mp3",
        "assets/audio/click-234708.mp3", 
        "assets/audio/rebab-72605.mp3"
    ]
    
    missing_files = []
    for audio_file in audio_files:
        if not os.path.exists(audio_file):
            missing_files.append(audio_file)
        else:
            print(f"✓ Found: {audio_file}")
    
    if missing_files:
        print(f"✗ Missing audio files: {missing_files}")
        return False
    
    print("✓ All audio files found")
    return True

def test_audio_manager_script():
    """Test that AudioManager script exists and has required functions"""
    print("\nTesting AudioManager script...")
    
    audio_manager_path = "scripts/AudioManager.gd"
    if not os.path.exists(audio_manager_path):
        print(f"✗ AudioManager script not found: {audio_manager_path}")
        return False
    
    print(f"✓ Found: {audio_manager_path}")
    
    # Read the script and check for required functions
    with open(audio_manager_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    required_functions = [
        "play_background_music",
        "play_click_sound", 
        "fade_in_background_music",
        "fade_out_background_music",
        "stop_background_music"
    ]
    
    missing_functions = []
    for func in required_functions:
        if f"func {func}" not in content:
            missing_functions.append(func)
        else:
            print(f"✓ Found function: {func}")
    
    if missing_functions:
        print(f"✗ Missing functions: {missing_functions}")
        return False
    
    print("✓ All required functions found in AudioManager")
    return True

def test_project_autoload():
    """Test that AudioManager is added to project autoloads"""
    print("\nTesting project autoload configuration...")
    
    project_file = "project.godot"
    if not os.path.exists(project_file):
        print(f"✗ Project file not found: {project_file}")
        return False
    
    with open(project_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if 'AudioManager="*res://scripts/AudioManager.gd"' in content:
        print("✓ AudioManager found in autoload configuration")
        return True
    else:
        print("✗ AudioManager not found in autoload configuration")
        return False

def test_script_modifications():
    """Test that scripts have been modified to include audio calls"""
    print("\nTesting script modifications...")
    
    scripts_to_check = [
        ("scripts/WelcomeScreen.gd", ["AudioManager.fade_in_background_music", "AudioManager.play_click_sound"]),
        ("scripts/CharacterCustomizationScreen.gd", ["AudioManager.fade_in_background_music", "AudioManager.play_click_sound"]),
        ("scripts/AmzianeIntroScreen.gd", ["AudioManager.fade_in_background_music", "AudioManager.play_click_sound"]),
        ("scripts/GameDescriptionScreen.gd", ["AudioManager.play_click_sound"]),
        ("scripts/RulesScreen.gd", ["AudioManager.play_click_sound"]),
        ("scripts/QuestScreen.gd", ["AudioManager.play_click_sound"]),
        ("scripts/MapScreen.gd", ["AudioManager.play_click_sound"])
    ]
    
    all_passed = True
    for script_path, expected_calls in scripts_to_check:
        if not os.path.exists(script_path):
            print(f"✗ Script not found: {script_path}")
            all_passed = False
            continue
        
        with open(script_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        missing_calls = []
        for call in expected_calls:
            if call not in content:
                missing_calls.append(call)
        
        if missing_calls:
            print(f"✗ {script_path}: Missing audio calls: {missing_calls}")
            all_passed = False
        else:
            print(f"✓ {script_path}: All audio calls found")
    
    return all_passed

def main():
    """Run all audio tests"""
    print("AZAMANE Audio System Test")
    print("=" * 40)
    
    tests = [
        test_audio_files_exist,
        test_audio_manager_script,
        test_project_autoload,
        test_script_modifications
    ]
    
    passed = 0
    total = len(tests)
    
    for test in tests:
        if test():
            passed += 1
        print()
    
    print("=" * 40)
    print(f"Test Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("✓ All audio tests passed! Audio system should be working correctly.")
        return 0
    else:
        print("✗ Some tests failed. Please check the issues above.")
        return 1

if __name__ == "__main__":
    sys.exit(main())
