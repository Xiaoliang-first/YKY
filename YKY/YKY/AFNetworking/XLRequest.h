//
//  XLRequest.h
//  YKY
//
//  Created by 肖 亮 on 16/4/5.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface XLRequest : NSObject

//------------------请求--------------------
/**
 * 请求成功 调用block
 */
@property (nonatomic,strong)void (^callBackSuccess) ();
/**
 * 请求失败 调用Block
 */
@property (nonatomic,strong)void (^callBackFailure) ();

@property (nonatomic,weak)AFHTTPRequestOperation *operation;


// 可以在（setDefaultParamToDic:）这个类方法里 设置 默认给每个接口添加 固定的参数

/**
 *  get 请求

 第一个参数 hostString 是 域名
 第二个参数 bindPath 是 域名后面除了 参数的 接口
 第三个参数 dic 是get 请求的 参数

 */
+(XLRequest*)AFGetHost:(NSString*)hostString  bindPath:(NSString *)bindPath param:(NSMutableDictionary*)dic success:( void (^) ( AFHTTPRequestOperation *operation,NSDictionary* responseDic) )success failure:(void (^)( AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 * Post 请求

 第一个参数 hostString 是 域名
 第二个参数 bindPath 是 域名后面除了 参数的 接口
 第三个参数 postParam 是Post参数
 第三个参数 getParam  是Post请求的get参数 一般为空 nil
 */
+(XLRequest *)AFPostHost:(NSString *)hostString bindPath:(NSString *)bindPath postParam:(NSMutableDictionary *)postParam isClient:(BOOL)isclient getParam:(NSMutableDictionary *)getParam success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *responseDic))success failure:(void (^)(AFHTTPRequestOperation * operation, NSError *error))failure;



@end
