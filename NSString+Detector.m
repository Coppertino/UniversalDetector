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

- (NSString *)stringByAutoconvertingCharset;
{
    void *detectorPtr = AllocUniversalDetector();
    if (detectorPtr == NULL)
        return self;
    
    CFStringRef stringRef = (CFStringRef)self;
    CFIndex stringLength = CFStringGetLength(stringRef);
    float confidence = 0;
    
    CFStringRef converterStringRef = NULL;
    
    // Getting bytes from string
    const char *buffer = (const char *)CFStringGetCharactersPtr(stringRef);
    if (buffer != NULL) {
        // Phase one: determinate from charset
        UniversalDetectorHandleData(detectorPtr, buffer, stringLength);
        const char *fromEncoding = UniversalDetectorCharset(detectorPtr, &confidence);
        
        if (fromEncoding != NULL) {
            CFStringRef fromEncodingString = CFStringCreateWithCString(NULL, fromEncoding, kCFStringEncodingUTF8);
            CFStringEncoding CFFromEncoding = CFStringConvertIANACharSetNameToEncoding(fromEncodingString);
            
            // Second stage - determinate to encoding
            if (CFFromEncoding != kCFStringEncodingUTF8) {
                UInt8 *stringBuffer = malloc(stringLength);
                memset(stringBuffer, 0, stringLength);
                
                __unused CFIndex usedBytes = 0;
                __unused CFIndex converted = CFStringGetBytes(stringRef, CFRangeMake(0, stringLength), CFFromEncoding, '?', false, stringBuffer, stringLength, &usedBytes);
                
                if (usedBytes > 0 && converted > 0 ) {
                    // Last phase: determinate proper encoding and convert
                    UniversalDetectorReset(detectorPtr);
                    UniversalDetectorHandleData(detectorPtr, (char *)stringBuffer, stringLength);
                    const char *toEncoding = UniversalDetectorCharset(detectorPtr, &confidence);
                    if (toEncoding) {
                        CFStringRef toEncodingString = CFStringCreateWithCString(NULL, toEncoding, kCFStringEncodingUTF8);
                        CFStringEncoding CFToEncoding = CFStringConvertIANACharSetNameToEncoding(toEncodingString);
//                        CFToEncoding = CFStringGetMostCompatibleMacStringEncoding(CFToEncoding);
                    
                        converterStringRef = CFStringCreateWithBytes(NULL, stringBuffer, stringLength, CFToEncoding, false);
                        
                        NSLog(@"Converting %@ (%@) to %@ (%@) %f%%", self, fromEncodingString, converterStringRef, toEncodingString, confidence * 100);
                    }
                }
                
                
                free(stringBuffer); stringBuffer = NULL;
            }
        }
    }
    
    FreeUniversalDetector(detectorPtr);
    
    if (converterStringRef) {
        return [(id)converterStringRef autorelease];
    }
    
    return self;

}


@end
