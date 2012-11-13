//
//  NSString+Detector.m
//  UniversalDetector
//
//  Created by Ivan Ablamskyi on 13.11.12.
//
//

#import "NSString+Detector.h"
#import "UniversalDetector.h"
#import "WrappedUniversalDetector.h"

@implementation NSString (Detector)

- (NSString *)stringByConvertionFrom:(NSStringEncoding)fromEncoding toEncoding:(NSStringEncoding)toEncoding;
{
    if (fromEncoding == 0 || toEncoding == 0 || fromEncoding == toEncoding)
        return self;
    NSUInteger numbersOfBytes = [self maximumLengthOfBytesUsingEncoding:fromEncoding];
    
    void *stringBytes = malloc(numbersOfBytes);
    
    [self getBytes:stringBytes maxLength:numbersOfBytes usedLength:NULL encoding:fromEncoding options:NSStringEncodingConversionAllowLossy range:NSMakeRange(0, self.length) remainingRange:NULL];
    
    if (!stringBytes)
        return nil;
    
    return [[[NSString alloc] initWithBytesNoCopy:stringBytes length:numbersOfBytes encoding:toEncoding freeWhenDone:YES] autorelease];
}

- (NSStringEncoding)getUsedEncodingByEncoding:(NSStringEncoding)refEncoding confidence:(float *)confidence;
{
    if (refEncoding == 0)
        return NSUTF8StringEncoding;
    
    NSUInteger bytesLength = [self maximumLengthOfBytesUsingEncoding:refEncoding];
    void * bytes = malloc(bytesLength);
    [self getBytes:bytes maxLength:bytesLength usedLength:NULL encoding:refEncoding options:NSStringEncodingConversionAllowLossy range:NSMakeRange(0, self.length) remainingRange:NULL];
    
    UniversalDetector *detector = [[[UniversalDetector alloc] init] autorelease];
    [detector analyzeBytes:bytes length:self.length];
    free(bytes); bytes = NULL;
    
//    NSLog(@"\n\nDetected encoding: %@ (%f%%)\n\n", [detector MIMECharset], detector.confidence*100);
    
    if (confidence)
        *confidence = detector.confidence;

    return detector.encoding;
}

- (NSString *)stringByAutoconvertingCharsetByReferenceToString:(NSString *)refString;
{
    NSStringEncoding fromEncoding, fromRefEncoding;
    NSStringEncoding toEncoding, toRefEncoding;
    float confidence = .0, refConfidence = .0;
    
    fromEncoding = [self getUsedEncodingByEncoding:NSUnicodeStringEncoding confidence:NULL];
    
    // Incase utf8 string - return witout converstion
    if (fromEncoding == NSUTF8StringEncoding)
        return self;
    
    toEncoding = [self getUsedEncodingByEncoding:fromEncoding confidence:&confidence];
    
    if (refString && refString.length > 0) {
        fromRefEncoding = [refString getUsedEncodingByEncoding:NSUnicodeStringEncoding confidence:NULL];
        toRefEncoding = [refString getUsedEncodingByEncoding:fromRefEncoding confidence:&refConfidence];
        
        if (fromRefEncoding == fromEncoding && refConfidence > confidence)
            toEncoding = toRefEncoding;
    }
    
    return [self stringByConvertionFrom:fromEncoding toEncoding:toEncoding];
}

- (NSString *)stringByAutoconvertingCharset;
{
    if (self.length == 0)
        return @"";
    
    // Step one: find out from encoding
    NSStringEncoding fromEncoding = [self getUsedEncodingByEncoding:NSUnicodeStringEncoding confidence:NULL];
    
    if (fromEncoding == NSUTF8StringEncoding)
        return self;
    
    // Step two: open data with found encoding and try find out to encoding
    NSStringEncoding toEncoding = [self getUsedEncodingByEncoding:fromEncoding confidence:NULL];

    // Step three: return converted string
    return [self stringByConvertionFrom:fromEncoding toEncoding:toEncoding];
}

@end