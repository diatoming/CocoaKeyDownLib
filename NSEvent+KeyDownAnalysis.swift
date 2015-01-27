//
//  NSEvent+ModifierFlagsExtension.swift
//  ModifierMate
//
//  Created by Paul Patterson on 23/01/2015.
//  Copyright (c) 2015 paulpatterson. All rights reserved.
//

import Foundation
import Cocoa

// MARK: Carbon KeyCodes used to denote arrow keys

let kArrowLeft:  UInt16 = 123
let kArrowRight: UInt16 = 124
let kArrowDown:  UInt16 = 125
let kArrowUp:    UInt16 = 126

let arrowKeys = [kArrowLeft, kArrowRight, kArrowUp, kArrowDown]


// MARK: NSEvent extension

extension NSEvent {

    /// Returns <true> if both of the following criteria are met:
    ///
    /// - The event's <modifierFlags> property indicates that the only two modifer flags present are the NumericPadKey mask and the FunctionKey mask.
    /// - The event's <KeyCode> property matches one of the four keyCodes used by Cocoa to denote the arrow keys.
    ///
    /// If neither of these criteria are met, or only one is met, <false> is returned.
    var matchesAnyArrowKey: Bool {
        var retval = false
        let flags = modifierFlags
        
        if contains(arrowKeys, keyCode) {
            if (flags.rScreenedFlags - (rFunctionKeyMask + rNumericPadKeyMask)) == 0 {
                retval = true
            }
        }
        
        return retval
    }
    
    /// Returns <true> if both of the following criteria are met: 
    ///
    /// - The event's <modifierFlags> property contains both the FunctionKeyMask and the NumericPadKey mask.
    /// - The event's <KeyCode> property matches one of the four keyCodes used by Cocoa to denote the arrow keys.
    ///
    /// If neither of these criteria are met, or only one is met, <false> is returned.
    var containsAnyArrowKey: Bool {
        var retval = false
        let flags = modifierFlags
        
        if contains([kArrowUp, kArrowDown, kArrowLeft, kArrowRight], keyCode) {
            if flags.containsNumericPadKey && flags.containsFunctionKey {
                retval = true
            }
        }
        
        return retval
    }
    
    /// Returns <true> if the ONLY key pressed on the keyboard (including modifiers like Shift,
    /// Alt, Cmd, and Ctrl) is the Arrow-Down key, otherwise returns <false>.
    var matchesArrowDownKey: Bool {
        return matchesAnyArrowKey && keyCode == kArrowDown
    }
   
    /// Returns <true> if the ONLY key pressed on the keyboard (including modifiers like Shift,
    /// Alt, Cmd, and Ctrl) is the Arrow-Up key, otherwise returns <false>.
    var matchesArrowUpKey: Bool {
        return matchesAnyArrowKey && keyCode == kArrowUp
    }
    
    /// Returns <true> if the ONLY key pressed on the keyboard (including modifiers like Shift,
    /// Alt, Cmd, and Ctrl) is the Arrow-Left key, otherwise returns <false>.
    var matchesArrowLeftKey: Bool {
        return matchesAnyArrowKey && keyCode == kArrowLeft
    }

    /// Returns <true> if the ONLY key pressed on the keyboard (including modifiers like Shift,
    /// Alt, Cmd, and Ctrl) is the Arrow-Right key, otherwise returns <false>.
    var matchesArrowRightKey: Bool {
        return matchesAnyArrowKey && keyCode == kArrowRight
    }
    
    
    /// Returns <true> if both of the following evaluate to <true>
    ///
    /// - The value of the first argument exactly matches the value of <modifierFlags>
    /// - The value of the second argument exactly matches the value of <charactersIgnoringModifiers>
    ///
    /// It's important to bear in mind that the value of charactersIgnoringModifiers is 
    /// influenced by the presence of the shift key. For example, if you want to check for
    /// the presence of the shift key, the alt key and the letter 's' you must pass the 
    /// upper-case 'S' to the character argument - otherwise the function will return false.
    func matchesModifiers(modifiers: NSEventModifierFlags, andCharacter character: Character) -> Bool {
        let flags = modifierFlags
        var retval = false
        
        if flags.matchesCombination(modifiers) {
            /// charactersIgnoringModifiers does NOT ignore the influence of the shift key: if the user
            /// has pressed shift-s, the value of charactersIgnoringModifiers will be 'S' (uppercase);
            /// if the user has pressed alt-s, the value will be 's' (lowercase).
            if let char = charactersIgnoringModifiers {
                if char == String(character) {
                    retval = true
                }
            }
        }
        return retval
    }
    
    /// Returns <true> if both of the following evaluate to <true>
    ///
    /// - The value of the first argument exactly matches the value of <modifierFlags>
    /// - The value of the second argument is one of [123,124,125,126]
    func matchesModifiers(modifiers: NSEventModifierFlags, andArrowKey arrowKey: UInt16) -> Bool {
        let flags = modifierFlags
        var retval = false
        
        /// Even in the absence of any user-pressed modifier keys, an arrow key press results in
        /// two device-independent modifier masks being added to the event's <modifierFlags>: 
        /// NSNumericPadKeyMask and NSFunctionKeyMask. If one of these is NOT present, it 
        /// isn't an arrow key press.
        if flags.containsFunctionKey {
            if flags.containsNumericPadKey {
                var remainingModifiers = Int32(flags.rScreenedFlags - rFunctionKeyMask - rNumericPadKeyMask)
                let raw = Int32(modifiers.rawValue)
                if (remainingModifiers - raw) == 0 {
                    if keyCode == arrowKey {
                        retval = true
                    }
                }
            }
        }
        return retval
    }
}











