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
}

- (void)testString;
{
    NSString *wrongString = @"Çàïëåòè (ó ñâî¿ êîñè í³÷)";
    
    NSString *rightString = [wrongString stringByAutoconvertingCharset];
    NSLog(@"\n\nConvertion result: %@\n\n", rightString);
}

- (void)testComlicatedString;
{
    NSString *wrongString = @"Áðþññåëü";
    NSString *refString = @"Çàïëåòè (ó ñâî¿ êîñè í³÷)";
    
    NSString *rightString = [wrongString stringByAutoconvertingCharsetByReferenceToString:refString];
    
    NSLog(@"\n\nConvetions result: %@\n\n", rightString);
}

- (void)testOnemore;
{
    NSString *fileName = @"Ïîiçä ◊óæà ëﬂáîâ.mp3";
    NSString *title = @"Ïîiçä ◊óæà ëﬂáîâ";
    NSString *album = @"Òàì, äå íàñ íåìà";
    
    NSLog(@"\n\nTitle:\t%@\nFile:\t%@\nAlbum:\t%@\n", [fileName stringByAutoconvertingCharset], [title stringByAutoconvertingCharset], [album stringByAutoconvertingCharset]);
}

@end

