//
//  NSString+JTCCommon.m
//  JTCCommonSample
//
//  Created by Tomohisa Takaoka on 5/15/14.
//  Copyright (c) 2014 Tomohisa Takaoka. All rights reserved.
//

#import "NSString+JTCCommon.h"
@implementation NSString (JTCCommon)
-(BOOL) isEmpty{
    if (!self) {
        return YES;
    }
    if ([self isEqualToString:@""]) {
        return YES;
    }
    return NO;
}
+(NSString*) safeString:(id)str{
    if (!str) {
        return @"";
    }
    if ([str isKindOfClass:[NSString class]]){
        return str;
    }
    if ([str respondsToSelector:@selector(description)]){
        return [str description];
    }
    return @"";
    
}
- (BOOL)containsString:(NSString *)aString {
    if (aString==nil) {
        return NO;
    }
	return ([self rangeOfString:aString].location != NSNotFound);
}
- (BOOL)containsString:(NSString *)aString options:(NSStringCompareOptions)mask {
    if (aString==nil) {
        return NO;
    }
	return ([self rangeOfString:aString options:NSCaseInsensitiveSearch].location != NSNotFound);
}
- (NSInteger)indexOf:(NSString *)aString {
	NSInteger loc = [self rangeOfString:aString options:NSCaseInsensitiveSearch].location;
	if (loc==NSNotFound) {
		return -1;
	}
	return loc;
}




+ (NSString*) makeXMLElementWithTag:(NSString*)tagStr withData:(NSString*)dataStr {
    NSString* result = nil;
    if (dataStr==nil || [dataStr isEqualToString:@""]) {
        result = [NSString stringWithFormat:@"<%@ />", tagStr];
    }else{
        result = [NSString stringWithFormat:@"<%@>%@</%@>",tagStr,dataStr,tagStr];
        //        result = [NSString stringWithFormat:@"<%@>%@</%@>",tagStr,[dataStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],tagStr];
    }
    return result;
}


- (NSString*) stringByAddingPercentEscapesUsingEncodingBugFixed:(CFStringEncoding)encoding {
	
	CFStringRef str = CFURLCreateStringByAddingPercentEscapes(
                                                              NULL,
                                                              (__bridge CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              encoding );
	if (str) {
		NSString* encodedString = [(__bridge NSString*)str copy];
		CFRelease(str);
		return encodedString;
	}else {
		return @"";
	}
    
}

#import <ifaddrs.h>
#import <arpa/inet.h>



// Get IP Address
+ (NSString *)getIPAddress {
    NSString *address = @"127.0.0.1";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}


- (NSString*) stringByConvertingTransformWithTransform:(CFStringRef)transform reverse:(Boolean)reverse {
    NSMutableString* retStr = [[NSMutableString alloc] initWithString:self];
    CFStringTransform((__bridge CFMutableStringRef)retStr, NULL, transform, reverse);
    return retStr;
}
- (NSString*) stringByConvertingToFullwidth {
    return [self stringByConvertingTransformWithTransform:kCFStringTransformFullwidthHalfwidth
                                                  reverse:true];
}
- (BOOL)isAllKatakana {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤヰユヱヨラリルレロワヲンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポァィゥェォャュョッヮヴ"] invertedSet];
    NSString * legalString = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if ([legalString isEqualToString:self]) {
        return YES;
    }
    return NO;
}
- (BOOL)isAllKatakanaOrSpace {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤヰユヱヨラリルレロワヲンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポァィゥェォャュョッヮヴ 　"] invertedSet];
    NSString * legalString = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if ([legalString isEqualToString:self]) {
        return YES;
    }
    return NO;
}
- (BOOL)isValidEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}
- (NSString*) stringByConvertingToHalfwidth {
    return [self stringByConvertingTransformWithTransform:kCFStringTransformFullwidthHalfwidth
                                                  reverse:false];
}

- (NSString*) stringByConvertingKatakanaToHiragana {
    return [self stringByConvertingTransformWithTransform:kCFStringTransformHiraganaKatakana
                                                  reverse:true];
}

- (NSString*) stringByConvertingHiraganaToKatakana {
    return [self stringByConvertingTransformWithTransform:kCFStringTransformHiraganaKatakana
                                                  reverse:false];
}

- (NSString*) stringByConvertingHiraganaToLatin {
    return [self stringByConvertingTransformWithTransform:kCFStringTransformLatinHiragana
                                                  reverse:true];
}

- (NSString*) stringByConvertingLatinToHiragana {
    return [self stringByConvertingTransformWithTransform:kCFStringTransformLatinHiragana
                                                  reverse:false];
}

- (NSString*) stringByConvertingKatakanaToLatin {
    return [self stringByConvertingTransformWithTransform:kCFStringTransformLatinKatakana
                                                  reverse:true];
}

- (NSString*) stringByConvertingLatinToKatakana {
    return [self stringByConvertingTransformWithTransform:kCFStringTransformLatinKatakana
                                                  reverse:false];
}
@end