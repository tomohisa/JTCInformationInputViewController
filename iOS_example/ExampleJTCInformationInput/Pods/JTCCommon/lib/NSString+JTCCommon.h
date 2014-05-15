//
//  NSString+JTCCommon.h
//  JTCCommonSample
//
//  Created by Tomohisa Takaoka on 5/15/14.
//  Copyright (c) 2014 Tomohisa Takaoka. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SafeString(x) [NSString safeString:x]
#define NULL2EMPTYString(a) (a?a:@"")
#define NULL2EMPTYIndexSet(a) (a?a:[NSMutableIndexSet indexSet])
#define SafeStringCompare(x,y) ((x==y)?YES:[x isEqual:y])
#define SafeStringAppend(x,y) [NULL2EMPTYString(x) stringByAppendingString:NULL2EMPTYString(y)]

@interface NSString (JTCCommon)
- (BOOL)containsString:(NSString *)aString;
- (BOOL)containsString:(NSString *)aString options:(NSStringCompareOptions)mask;
- (NSInteger)indexOf:(NSString *)aString;
+ (NSString*) makeXMLElementWithTag:(NSString*)tagStr withData:(NSString*)dataStr;
- (NSString*) stringByAddingPercentEscapesUsingEncodingBugFixed:(CFStringEncoding)encoding;
+ (NSString*) getIPAddress;
-(BOOL) isEmpty;
+(NSString*) safeString:(id)str;

- (NSString*) stringByConvertingToFullwidth;

- (BOOL)isAllKatakana;
- (BOOL)isAllKatakanaOrSpace;
- (BOOL)isValidEmail;
- (NSString*) stringByConvertingToHalfwidth;
- (NSString*) stringByConvertingKatakanaToHiragana;
- (NSString*) stringByConvertingHiraganaToKatakana;
- (NSString*) stringByConvertingHiraganaToLatin;
- (NSString*) stringByConvertingLatinToHiragana;
- (NSString*) stringByConvertingKatakanaToLatin;
- (NSString*) stringByConvertingLatinToKatakana;

@end
