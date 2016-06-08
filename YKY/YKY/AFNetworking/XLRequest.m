//
//  XLRequest.m
//  YKY
//
//  Created by 肖 亮 on 16/4/5.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "XLRequest.h"
#import "Account.h"
#import "AccountTool.h"


#define NetTimeOutInterval 15.f
@implementation XLRequest


///**
// * 给每次的请求加上 默认必须添加的参数 比如版本号（版本升级时 不同的版本分别处理） 渠道号 (Appstore 和越狱的一些渠道如：91手机助手、同步推)
//
// 手机型号（区分安卓和iPhone 在需要的时候做不同的处理）
// */
+(void)setDefaultParamToDic:(NSMutableDictionary *)dic
{
    if (dic)
    {
        // 版本号 参数
//        NSString * versionParam = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        // 渠道号 参数
//        NSString * unionIdParam = @"000"; // 和后台约定的任意字符 120 或 182 或 123
//        // 手机型号 参数
//        NSString * osParam = @"iphone"; // iphone android
//        // 添加参数
//        [dic setObject:versionParam forKey:@"versionParam"];
//
//        [dic setObject:unionIdParam forKey:@"unionIdParam"];
//
//        [dic setObject:osParam forKey:@"osParam"];
        Account * account = [AccountTool account];
        if (account) {
            [dic setObject:@"1" forKey:@"client"];
            [dic setObject:account.uiId forKey:@"userId"];
            [dic setObject:account.reponseToken forKey:@"serverToken"];
        }else{

        }
    }
}


+(XLRequest *)AFGetHost:(NSString *)hostString bindPath:(NSString *)bindPath param:(NSMutableDictionary *)dic success:(void (^)(AFHTTPRequestOperation *, NSDictionary *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{

//    [XLRequest setDefaultParamToDic:dic];

    NSString* url = [NSString stringWithFormat:@"%@%@",hostString,bindPath];

    XLRequest *afH = [[XLRequest alloc] init];
    afH.callBackSuccess = success;
    afH.callBackFailure = failure;

    AFHTTPRequestOperationManager *operation = [[AFHTTPRequestOperationManager alloc] init];
    operation.requestSerializer.timeoutInterval = NetTimeOutInterval;
    //此处添加一个  text/plain
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html",@"text/plain", nil];
    //申明请求的数据是json类型
    operation.requestSerializer=[AFHTTPRequestSerializer serializer];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    afH.operation = [operation GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"网络请求成功回调=%@",responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        NSError *error = nil;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];
        if (error) {
            afH.callBackFailure(operation,error);
            afH.callBackSuccess = nil;
            afH.callBackFailure = nil;
        }else{
            afH.callBackSuccess(operation,resultDic);
            afH.callBackSuccess = nil;
            afH.callBackFailure = nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        afH.callBackFailure(operation,error);
        afH.callBackSuccess = nil;
        afH.callBackFailure = nil;
    }];
    DebugLog(@"AFGet--URl--:%@",afH.operation.request.URL);
    return afH;
}

+(XLRequest *)AFPostHost:(NSString *)hostString bindPath:(NSString *)bindPath postParam:(NSMutableDictionary *)postParam isClient:(BOOL)isclient getParam:(NSMutableDictionary *)getParam success:(void (^)(AFHTTPRequestOperation *, NSDictionary *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{

    NSString* url = [NSString stringWithFormat:@"%@%@",hostString,bindPath];

    if (isclient) {
        [XLRequest setDefaultParamToDic:postParam];
    }
    //   [MDYAFHelp setDefaultParamToDic:getParam]; // 必填参数 添加到 get参数中

    //   [MDYAFHelp setDefaultParamToDic:postParam]; // 必填参数 添加到 post参数中 //  可以只填写一个

    // get参数 拼接 到url 上
    //    url = [MDYAFHelp setParamDIc:getParam toUrlString:url];

    XLRequest *AFH = [[XLRequest alloc] init];
    AFH.callBackSuccess = success;
    AFH.callBackFailure = failure;
    ///////
    AFHTTPRequestOperationManager *operation = [[AFHTTPRequestOperationManager alloc] init];
    operation.requestSerializer.timeoutInterval = 15.0f;

    /////////////////////////////////////////////////////////////////
    //发送请求
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;

    operation.securityPolicy = securityPolicy;
    //    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/vnd.wap.wml",@"text/html", nil];

    //申明请求的数据是json类型
    operation.requestSerializer=[AFHTTPRequestSerializer serializer];
    //    operation.requestSerializer=[AFJSONResponseSerializer serializer];

    
    //////////////////////////////////////////////////////////////////
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    AFH.operation = [operation POST:url parameters:postParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        NSError *error = nil;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];
        if (error) {
            AFH.callBackFailure(operation,error);
            AFH.callBackSuccess = nil;
            AFH.callBackFailure = nil;
        }else{
            AFH.callBackSuccess(operation,resultDic);
            AFH.callBackSuccess = nil;
            AFH.callBackFailure = nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        AFH.callBackFailure(operation,error);

        AFH.callBackSuccess = nil;
        AFH.callBackFailure = nil;
    }];
    DebugLog(@"AFPost-url:%@",AFH.operation.request.URL);
    DebugLog(@"AFPostDic:%@",postParam);
    return AFH;
}


@end
