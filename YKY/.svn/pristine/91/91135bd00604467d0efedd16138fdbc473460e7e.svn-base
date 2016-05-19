//
//  sharToFrend.m
//  YKY
//
//  Created by 肖亮 on 15/12/15.
//  Copyright © 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "sharToFrend.h"
#import "common.h"
#import "UIImageView+WebCache.h"
//#import <CommonCrypto/CommonCryptor.h>
//#import "GTMBase64.h"


@interface sharToFrend()<UMSocialUIDelegate>

@end

@implementation sharToFrend


+(void)shareWithImgurl:(NSString*)imgurl andPid:(NSString *)pid phone:(NSString*)phone andVC:(UIViewController*)VC{

    //手机号中间四位用*隐藏
    NSString * phone2 = [phone substringFromIndex:7];
    NSString * phone1 = [phone substringToIndex:3];
    NSString * sPhone = [[phone1 stringByAppendingString:@"****"] stringByAppendingString:phone2];

    //完成分享链接编码
    NSString *url = [kbaseURL stringByAppendingString:[NSString stringWithFormat:@"/coupons/shareCoupons/%@-%@",sPhone,pid]];

    //设置分享内容，（图片加上分享内容和链接）
    UIImageView *imgview = [[UIImageView alloc]init];
    
    [imgview sd_setImageWithURL:[NSURL URLWithString:imgurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UMSocialSnsService presentSnsIconSheetView:VC appKey:@"53f77204fd98c585f200de09"shareText:[NSString stringWithFormat:@"我刚在一块摇中获取了一个奖品，只要你摇，惊喜一直不断，你准备好了吗？%@",imgurl] shareImage:imgview.image shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToLWSession,UMShareToTencent,UMShareToWechatTimeline,UMShareToWechatSession,nil,nil] delegate:VC];
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina,UMShareToLWSession,UMShareToTencent,UMShareToWechatTimeline,UMShareToWechatSession]content:[NSString stringWithFormat:@"我刚在一块摇中获取了一个奖品，只要你摇，惊喜一直不断，你准备好了吗？%@",imgurl] image:imgview.image location:nil urlResource:nil presentedController:VC completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
            }}];
    }];
    
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"一块摇";
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"一块摇";
}


@end
