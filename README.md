# JailbreakShield iOS SDK

## Installation via Swift Package Manager

1. In Xcode go to File → Add Package Dependencies
2. Paste URL: https://github.com/harshd30j-iOS/JailbreakShieldiOS
3. Change Branch dropdown to Exact Version
4. Type 1.0.4
5. Click Add Package
6. In Build Settings add Other Linker Flags: -ObjC

## Usage Objective-C
#import JailbreakShield/HDJailbreakDetection.h
[HDJailbreakDetection enforceSecurity];
