//
//  NSString+Util.m
//  iosapp
//
//  Created by AeternChan on 10/16/15.
//  Copyright © 2015 oschina. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Util)

- (NSString *)escapeHTML
{
    NSMutableString *result = [self mutableCopy];
    [result replaceOccurrencesOfString:@"&"  withString:@"&amp;"  options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"<"  withString:@"&lt;"   options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@">"  withString:@"&gt;"   options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"'"  withString:@"&#39;"  options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    
    return result;
}

- (NSString *)deleteHTMLTag
{
    NSMutableString *trimmedHTML = [self mutableCopy];
    
    NSString *styleTagPattern = @"<style[^>]*?>[\\s\\S]*?<\\/style>";
    NSRegularExpression *styleTagRe = [NSRegularExpression regularExpressionWithPattern:styleTagPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *resultsArray = [styleTagRe matchesInString:trimmedHTML options:0 range:NSMakeRange(0, trimmedHTML.length)];
    for (NSTextCheckingResult *match in [resultsArray reverseObjectEnumerator]) {
        [trimmedHTML replaceCharactersInRange:match.range withString:@""];
    }
    
    NSString *htmlTagPattern = @"<[^>]+>";
    NSRegularExpression *normalHTMLTagRe = [NSRegularExpression regularExpressionWithPattern:htmlTagPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    resultsArray = [normalHTMLTagRe matchesInString:trimmedHTML options:0 range:NSMakeRange(0, trimmedHTML.length)];
    for (NSTextCheckingResult *match in [resultsArray reverseObjectEnumerator]) {
        [trimmedHTML replaceCharactersInRange:match.range withString:@""];
    }
    
    return trimmedHTML;
}


-(BOOL)isNullOrEmpty{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""].length==0;
    
}
-(NSString*)StringWithoutEmpty{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];

}

- (NSString *)md5Checksum
{
    const char *cStr = [self UTF8String];
    unsigned char result [CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}

@end
