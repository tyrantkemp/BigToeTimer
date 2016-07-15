//
//  XZHttp.h
//  test1
//
//  Created by 肖准 on 5/20/16.
//  Copyright © 2016 肖准. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadParam : NSObject
//
//  HttpRequest.h
//  基于AFNetWorking的再封装
//



/**
 *  图片的二进制数据
 */
@property (nonatomic, strong) NSData *data;
/**
 *  服务器对应的参数名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  文件的名称(上传到服务器后，服务器保存的文件名)
 */
@property (nonatomic, copy) NSString *filename;
/**
 *  文件的MIME类型(image/png,image/jpg等)
 */
@property (nonatomic, copy) NSString *mimeType;

@end

/**
 *  网络请求类型
 */
typedef NS_ENUM(NSUInteger,HttpRequestType) {
    /**
     *  get请求
     */
    HttpRequestTypeGet = 0,
    /**
     *  post请求
     */
    HttpRequestTypePost
};

@interface XZHttp : NSObject

+ (instancetype)sharedInstance;

/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/**
 *  发送网络请求
 *
 *  @param URLString   请求的网址字符串
 *  @param parameters  请求的参数
 *  @param type        请求的类型
 *  @param resultBlock 请求的结果
 */
- (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(HttpRequestType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

/**
 *  上传图片
 *
 *  @param URLString   上传图片的网址字符串
 *  @param parameters  上传图片的参数
 *  @param uploadParam 上传图片的信息
 *  @param success     上传成功的回调
 *  @param failure     上传失败的回调
 */
- (void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                uploadParam:(UploadParam *)uploadParam
                    success:(void (^)())success
                    failure:(void (^)(NSError *error))failure;

@end

