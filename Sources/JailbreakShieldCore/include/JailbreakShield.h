//
//  JailbreakShield.h
//  JailbreakShield — Umbrella Header
//
//  Created by Harsh Dwivedi
//  Copyright © 2026 Harsh Dwivedi. All rights reserved.
//
//  This file lives in Sources/JailbreakShieldCore/include/
//
//  ObjC consumers:  #import <JailbreakShieldCore/JailbreakShield.h>
//  Swift consumers: import JailbreakShield  (uses the Swift wrapper target)
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double JailbreakShieldVersionNumber;
FOUNDATION_EXPORT const unsigned char JailbreakShieldVersionString[];

// Use relative imports here (NOT <JailbreakShield/...> style)
// because in SPM the module is JailbreakShieldCore, not JailbreakShield
#import "HDJailbreakDetection.h"
#import "HDSecurityBlockViewController.h"
#import "HDSecurityBlockWindow.h"
#import "ScreenProtectionManager.h"
