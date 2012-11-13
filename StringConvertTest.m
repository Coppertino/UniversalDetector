//
//  StringConvertTest.m
//  UniversalDetector
//
//  Created by Ivan Ablamskyi on 13.11.12.
//
//

#import "StringConvertTest.h"
#import "NSString+Detector.h"

@implementation StringConvertTest

- (void)testString;
{
    NSString *wrongString = @"Çàïëåòè (ó ñâî¿ êîñè í³÷)";
    
    NSString *rightString = [wrongString stringByAutodetectingCharset];
    
}

@end
