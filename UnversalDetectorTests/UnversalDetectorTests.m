//
//  UnversalDetectorTests.m
//  UnversalDetectorTests
//
//  Created by Ivan Ablamskyi on 13.11.12.
//
//

#import "UnversalDetectorTests.h"
#import "NSString+Detector.h"

@implementation UnversalDetectorTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testString;
{
    NSString *wrongString = @"Çàïëåòè (ó ñâî¿ êîñè í³÷)";
    
    NSString *rightString = [wrongString stringByAutoconvertingCharset];
    NSLog(@"result: %@", rightString);
//    ST(rightString, wrongString, @"Not converted");
}

- (void)testComlicatedString;
{
    NSString *wrongString = @"Áðþññåëü";
    NSString *rightString = [wrongString stringByAutoconvertingCharset];
    
    NSLog(@"result: %@", rightString);
}

@end
