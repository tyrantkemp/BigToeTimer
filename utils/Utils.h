//
//  Utils.h
//  iosapp
//
//  Created by chenhaoxiang on 14-10-16.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIView+Util.h"
#import "UIColor+Util.h"
#import "UIImageView+Util.h"
#import "UIImage+Util.h"
#import "NSTextAttachment+Util.h"
//#import "UINavigationController+Router.h"
#import "NSDate+Util.h"
#import "NSString+Util.h"


typedef NS_ENUM(NSUInteger, hudType) {
    hudTypeSendingTweet,
    hudTypeLoading,
    hudTypeCompleted
};

@class MBProgressHUD;

@interface Utils : NSObject

+ (NSDictionary *)emojiDict;

+ (NSAttributedString *)getAppclient:(int)clientType;

+ (NSString *)generateRelativeNewsString:(NSArray *)relativeNews;
+ (NSString *)generateTags:(NSArray *)tags;

+ (NSAttributedString *)emojiStringFromRawString:(NSString *)rawString;
+ (NSAttributedString *)emojiStringFromAttrString:(NSAttributedString*)attrString;
+ (NSAttributedString *)attributedStringFromHTML:(NSString *)HTML;
+ (NSData *)compressImage:(UIImage *)image;
+ (NSString *)convertRichTextToRawText:(UITextView *)textView;

+ (BOOL)isURL:(NSString *)string;
+ (NSInteger)networkStatus;
+ (BOOL)isNetworkExist;

+ (CGFloat)valueBetweenMin:(CGFloat)min andMax:(CGFloat)max percent:(CGFloat)percent;

+ (MBProgressHUD *)createHUD;
+ (MBProgressHUD *)createHUDWithText:(NSString*)text;
+ (MBProgressHUD *)createHUDWithText:(NSString*)text delayTime:(NSTimeInterval)delay;
+ (MBProgressHUD *)createHUDErrorWithError:(NSError*)error;
+ (MBProgressHUD *)createHUDErrorWithErrorMessage:(NSString*)message delay:(NSTimeInterval)delay;
+ (MBProgressHUD *)createHUDWithSuccess:(NSString*)message delay:(NSTimeInterval)delay;

+ (UIImage *)createQRCodeFromString:(NSString *)string;
+ (NSAttributedString *)attributedTimeString:(NSDate *)date;
+ (NSAttributedString *)attributedCommentCount:(int)commentCount;
+ (NSString *)HTMLWithData:(NSDictionary *)data usingTemplate:(NSString *)templateName;


+(BOOL)isPhoneNumber:(UITextField*)textfield Range:(NSRange)range String:(NSString*)string;


//获得文字高度
+(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;

//将responseobj 转化为json
+(id)getJsonStringFromResponseObj:(id)responseObj;

//判断邮箱格式是否正确
+(BOOL)isValidateEmail:(NSString *)email;

@end
