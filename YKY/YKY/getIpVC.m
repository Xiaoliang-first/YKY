//
//  getIpVC.m
//  YKY
//
//  Created by 肖 亮 on 16/5/1.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "getIpVC.h"
#import "RegexKitLite.h"

@interface getIpVC ()

@end

@implementation getIpVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

+(void)getUserIp{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://www.ip.cn/" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        DebugLog(@"=====%@",responseObject);
        NSData * data = [NSData dataWithData:responseObject];
        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [self getIpWithStr:str];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {

    }];
}

+(void)getIpWithStr:(NSString*)str{
    // 编写正则表达式：只能是数字或英文，或两者都存在
    NSString *regex = @"((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))";

    NSString *matchedString1 = [str stringByMatching:regex capture:1L];

    NSString * cityRE = @"((来自：).*(市))";

    NSString * userCity = [str stringByMatching:cityRE capture:1L];
    NSString * city = [userCity stringByReplacingOccurrencesOfString:@"来自：" withString:@""];

    DebugLog(@"====%@====%@===city=%@",matchedString1,userCity,city);

    [[NSUserDefaults standardUserDefaults]setObject:matchedString1 forKey:@"userIP"];
    [[NSUserDefaults standardUserDefaults]setObject:city forKey:@"userCity"];
    
}



@end
