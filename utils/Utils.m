//
//  Utils.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-16.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "Utils.h"
#import "AppDelegate.h"

#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"

#import <MBProgressHUD.h>
#import <objc/runtime.h>
#import <Reachability.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <GRMustache.h>
#import <DTCoreText.h>
#import <objc/runtime.h>
static const void* HUDKey = &HUDKey;
@implementation Utils


#pragma mark - 处理API返回信息

+ (NSAttributedString *)getAppclient:(int)clientType
{
    NSMutableAttributedString *attributedClientString;
    if (clientType > 1 && clientType <= 6) {
        NSArray *clients = @[@"", @"", @"手机", @"Android", @"iPhone", @"Windows Phone", @"微信"];
        
        attributedClientString = [[NSMutableAttributedString alloc] initWithString:[NSString fontAwesomeIconStringForEnum:FAMobile]
                                                                        attributes:@{
                                                                                     NSFontAttributeName: [UIFont fontAwesomeFontOfSize:13],
                                                                                     }];
        
        [attributedClientString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", clients[clientType]]]];
    } else {
        attributedClientString = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    return attributedClientString;
}

+ (NSString *)generateRelativeNewsString:(NSArray *)relativeNews
{
    if (relativeNews == nil || [relativeNews count] == 0) {
        return @"";
    }
    
    NSString *middle = @"";
    for (NSArray *news in relativeNews) {
        middle = [NSString stringWithFormat:@"%@<a href=%@>%@</a><p/>", middle, news[1], news[0]];
    }
    return [NSString stringWithFormat:@"相关文章<div style='font-size:14px'><p/>%@</div>", middle];
}

+ (NSString *)generateTags:(NSArray *)tags
{
    if (tags == nil || tags.count == 0) {
        return @"";
    } else {
        NSString *result = @"";
        for (NSString *tag in tags) {
            result = [NSString stringWithFormat:@"%@<a style='background-color: #BBD6F3;border-bottom: 1px solid #3E6D8E;border-right: 1px solid #7F9FB6;color: #284A7B;font-size: 12pt;-webkit-text-size-adjust: none;line-height: 2.4;margin: 2px 2px 2px 0;padding: 2px 4px;text-decoration: none;white-space: nowrap;' href='http://www.oschina.net/question/tag/%@' >&nbsp;%@&nbsp;</a>&nbsp;&nbsp;", result, tag, tag];
        }
        return result;
    }
}




#pragma mark - 通用

#pragma mark - emoji Dictionary

+ (NSDictionary *)emojiDict
{
    static dispatch_once_t once;
    static NSDictionary *emojiDict;
    
    dispatch_once(&once, ^ {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"emoji" ofType:@"plist"];
        emojiDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    });
    
    return emojiDict;
}

#pragma mark 信息处理

+ (NSAttributedString *)attributedTimeString:(NSDate *)date
{
    NSString *rawString = [NSString stringWithFormat:@"%@ %@", [NSString fontAwesomeIconStringForEnum:FAClockO], [date timeAgoSinceNow]];
    
    NSAttributedString *attributedTime = [[NSAttributedString alloc] initWithString:rawString
                                                                         attributes:@{
                                                                                      NSFontAttributeName: [UIFont fontAwesomeFontOfSize:12],
                                                                                      }];
    
    return attributedTime;
}


// 参考 http://www.cnblogs.com/ludashi/p/3962573.html

+ (NSAttributedString *)emojiStringFromRawString:(NSString *)rawString
{
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:rawString attributes:nil];
    return [Utils emojiStringFromAttrString:attrString];
}

+ (NSAttributedString *)emojiStringFromAttrString:(NSAttributedString*)attrString
{
    NSMutableAttributedString *emojiString = [[NSMutableAttributedString alloc] initWithAttributedString:attrString];
    NSDictionary *emoji = self.emojiDict;
    
    NSString *pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]|:[a-zA-Z0-9\\u4e00-\\u9fa5_]+:";
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *resultsArray = [re matchesInString:attrString.string options:0 range:NSMakeRange(0, attrString.string.length)];
    
    NSMutableArray *emojiArray = [NSMutableArray arrayWithCapacity:resultsArray.count];
    
    for (NSTextCheckingResult *match in resultsArray) {
        NSRange range = [match range];
        NSString *emojiName = [attrString.string substringWithRange:range];
        
        if ([emojiName hasPrefix:@"["] && emoji[emojiName]) {
            NSTextAttachment *textAttachment = [NSTextAttachment new];
            textAttachment.image = [UIImage imageNamed:emoji[emojiName]];
            [textAttachment adjustY:-3];
            
            NSAttributedString *emojiAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            
            [emojiArray addObject: @{@"image": emojiAttributedString, @"range": [NSValue valueWithRange:range]}];
        } else if ([emojiName hasPrefix:@":"]) {
            if (emoji[emojiName]) {
                [emojiArray addObject:@{@"text": emoji[emojiName], @"range": [NSValue valueWithRange:range]}];
            } else {
                UIImage *emojiImage = [UIImage imageNamed:[emojiName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]]];
                NSTextAttachment *textAttachment = [NSTextAttachment new];
                textAttachment.image = emojiImage;
                [textAttachment adjustY:-3];
                
                NSAttributedString *emojiAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                [emojiArray addObject: @{@"image": emojiAttributedString, @"range": [NSValue valueWithRange:range]}];
            }
        }
    }
    
    for (NSInteger i = emojiArray.count -1; i >= 0; i--) {
        NSRange range;
        [emojiArray[i][@"range"] getValue:&range];
        if (emojiArray[i][@"image"]) {
            [emojiString replaceCharactersInRange:range withAttributedString:emojiArray[i][@"image"]];
        } else {
            [emojiString replaceCharactersInRange:range withString:emojiArray[i][@"text"]];
        }
    }
    
    return emojiString;
}

+ (NSAttributedString *)attributedStringFromHTML:(NSString *)html
{
    // [NSAttributedAttributedString initWithData:options:documentAttributes:error:] is very slow
    // use DTCoreText instead
    
    if (![html hasPrefix:@"<"]) {
        html = [NSString stringWithFormat:@"<span>%@</span>", html]; // DTCoreText treat raw string as <p> element
    }
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSAttributedString alloc] initWithHTMLData:data options:@{ DTUseiOS6Attributes: @YES}
                                     documentAttributes:nil];
}

+ (NSString *)convertRichTextToRawText:(UITextView *)textView
{
    NSMutableString *rawText = [[NSMutableString alloc] initWithString:textView.text];
    
    [textView.attributedText enumerateAttribute:NSAttachmentAttributeName
                                        inRange:NSMakeRange(0, textView.attributedText.length)
                                        options:NSAttributedStringEnumerationReverse
                                     usingBlock:^(NSTextAttachment *attachment, NSRange range, BOOL *stop) {
                                                    if (!attachment) {return;}
                                        
                                                    NSString *emojiStr = objc_getAssociatedObject(attachment, @"emoji");
                                                    [rawText insertString:emojiStr atIndex:range.location];
                                                }];
    
    NSString *pattern = @"[\ue000-\uf8ff]|[\\x{1f300}-\\x{1f7ff}]|\\x{263A}\\x{FE0F}|☺";
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *resultsArray = [re matchesInString:textView.text options:0 range:NSMakeRange(0, textView.text.length)];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"emojiToText" ofType:@"plist"];
    NSDictionary *emojiToText = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    for (NSTextCheckingResult *match in [resultsArray reverseObjectEnumerator]) {
        NSString *emoji = [textView.text substringWithRange:match.range];
        [rawText replaceCharactersInRange:match.range withString:emojiToText[emoji]];
    }
    
    return [rawText stringByReplacingOccurrencesOfString:@"\U0000fffc" withString:@""];
}

+ (NSData *)compressImage:(UIImage *)image
{
    CGSize size = [self scaleSize:image.size];
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSUInteger maxFileSize = 500 * 1024;
    CGFloat compressionRatio = 0.7f;
    CGFloat maxCompressionRatio = 0.1f;
    
    NSData *imageData = UIImageJPEGRepresentation(scaledImage, compressionRatio);
    
    while (imageData.length > maxFileSize && compressionRatio > maxCompressionRatio) {
        compressionRatio -= 0.1f;
        imageData = UIImageJPEGRepresentation(image, compressionRatio);
    }
    
    return imageData;
}

+ (CGSize)scaleSize:(CGSize)sourceSize
{
    float width = sourceSize.width;
    float height = sourceSize.height;
    if (width >= height) {
        return CGSizeMake(800, 800 * height / width);
    } else {
        return CGSizeMake(800 * width / height, 800);
    }
}


+ (BOOL)isURL:(NSString *)string
{
    NSString *pattern = @"^(http|https)://.*?$(net|com|.com.cn|org|me|)";
    
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    
    return [urlPredicate evaluateWithObject:string];
}


+ (NSInteger)networkStatus
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.oschina.net"];
    return reachability.currentReachabilityStatus;
}

+ (BOOL)isNetworkExist
{
    return [self networkStatus] > 0;
}


#pragma mark UI处理

+ (CGFloat)valueBetweenMin:(CGFloat)min andMax:(CGFloat)max percent:(CGFloat)percent
{
    return min + (max - min) * percent;
}


#pragma mark - HUD 显示 操作
+(MBProgressHUD*)HUD{
    return objc_getAssociatedObject(self, HUDKey);
}

+(void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

+(void)showHUD:(NSString *)hint{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}
+(void)showHUDWithError:(NSError*)error{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
    hud.label.text = error.userInfo[NSLocalizedDescriptionKey];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}


+(void)showHUDWithErrorMsg:(NSString*)errorMsg{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
    hud.label.text = errorMsg;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

+(void)showHUDWithMsg:(NSString*)Msg andImage:(UIImage*)image{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.label.text = Msg;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

+(void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.label.text = hint;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    [self setHUD:HUD];
}

+ (void)showHudInView:(UIView *)view hint:(NSString *)hint yOffset:(float)yOffset{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.label.text = hint;
    HUD.margin = 10.f;
    HUD.yOffset += yOffset;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    [self setHUD:HUD];
}
+(void)hideHud{
    [[self HUD] hideAnimated:YES];
}

+ (UIImage *)createQRCodeFromString:(NSString *)string
{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *QRFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [QRFilter setValue:stringData forKey:@"inputMessage"];
    [QRFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CGFloat scale = 5;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:QRFilter.outputImage fromRect:QRFilter.outputImage.extent];
    
    //Scale the image usign CoreGraphics
    CGFloat width = QRFilter.outputImage.extent.size.width * scale;
    UIGraphicsBeginImageContext(CGSizeMake(width, width));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //Cleaning up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    return image;
}

+ (NSAttributedString *)attributedCommentCount:(int)commentCount
{
    NSString *rawString = [NSString stringWithFormat:@"%@ %d", [NSString fontAwesomeIconStringForEnum:FACommentsO], commentCount];
    NSAttributedString *attributedCommentCount = [[NSAttributedString alloc] initWithString:rawString
                                                                                 attributes:@{
                                                                                              NSFontAttributeName: [UIFont fontAwesomeFontOfSize:12],
                                                                                              }];
    
    return attributedCommentCount;
}


+ (NSString *)HTMLWithData:(NSDictionary *)data usingTemplate:(NSString *)templateName
{
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:templateName ofType:@"html" inDirectory:@"html"];
    NSString *template = [NSString stringWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableDictionary *mutableData = [data mutableCopy];
    [mutableData setObject:@(((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode)
                    forKey:@"night"];
    
    return [GRMustacheTemplate renderObject:mutableData fromString:template error:nil];
}

#pragma mark - 判断是否是手机号
+(BOOL)isPhoneNumber:(UITextField*)textfield Range:(NSRange)range String:(NSString*)string{
    NSString *text = [textfield text];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 如果是电话号码格式化，需要添加这三行代码
    NSMutableString *temString = [NSMutableString stringWithString:text];
    [temString insertString:@" " atIndex:0];
    text = temString;
    
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    
    if (newString.length >= 14) {
        return NO;
    }
    
    [textfield setText:newString];
    return NO;

}
/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

+(id)getJsonStringFromResponseObj:(id)responseObj{
    NSString *responseString = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
    //responseString = [responseString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    //responseString = [responseString substringWithRange:NSMakeRange(1, [responseString length]-2)];
    id json = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingMutableContainers error:nil];
    return json;
}

+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
