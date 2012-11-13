//
//  NSString+Detector.h
//  UniversalDetector
//
//  Created by Ivan Ablamskyi on 13.11.12.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Detector)

- (NSString *)stringByAutoconvertingCharset;
- (NSString *)stringByAutoconvertingCharsetByReferenceToString:(NSString *)refString;

@end