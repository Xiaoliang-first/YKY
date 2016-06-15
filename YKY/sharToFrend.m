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

#pragma mark - 奖兜
+(void)shareWithImgurl:(NSString*)imgurl title:(NSString*)title andPid:(NSString *)pid phone:(NSString*)phone andVC:(UIViewController*)VC{


//    UMShareToLWSession,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,UMShareToQQ,  UMShareToTencent

//    我刚在一块摇中获取了一个奖品，只要你摇，惊喜一直不断，你准备好了吗？
//    NSString * sPhone = @"12544";
//    if (phone.length == 11) {
        //手机号中间四位用*隐藏
    NSString*sPhone = [phoneSecret phoneSecretWithPhoneNum:phone];
//    }

    //完成分享链接编码
    NSString *url = [kbaseURL stringByAppendingString:[NSString stringWithFormat:@"/coupons/shareCoupons/%@-%@",sPhone,pid]];

    //设置分享内容，（图片加上分享内容和链接）
    UIImageView *imgview = [[UIImageView alloc]init];
//    [imgview sd_setImageWithURL:[NSURL URLWithString:imgurl]];

    [imgview sd_setImageWithURL:[NSURL URLWithString:imgurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        [UMSocialSnsService presentSnsIconSheetView:VC appKey:@"53f77204fd98c585f200de09"shareText:[NSString stringWithFormat:@"%@%@",title,url] shareImage:imgview.image shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone] delegate:VC];

        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]content:[NSString stringWithFormat:@"%@%@",title,url] image:imgview.image location:nil urlResource:nil presentedController:VC completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
            }}];
        
    }];

//    [UMSocialSnsService presentSnsIconSheetView:VC
//                                         appKey:@"53f77204fd98c585f200de09"
//                                      shareText:[NSString stringWithFormat:@"%@%@",title,url]
//                                     shareImage:imgview.image
//                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToSina,UMShareToQzone,UMShareToTencent]
//                                       delegate:VC];

    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"一块摇 有人@你";
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"一块摇 有人@你";

    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.url = url;
    [UMSocialData defaultData].extConfig.qqData.title = @"一块摇 有人@你";
    [UMSocialData defaultData].extConfig.qzoneData.title = @"一块摇 有人@你";

}


#pragma mark - 幸运兜分享
+(void)shareWithImgurl:(NSString*)imgUrl title:(NSString*)title andPid:(NSString *)pid andVC:(UIViewController*)VC{

    //    我刚在一块摇中获取了一个奖品，只要你摇，惊喜一直不断，你准备好了吗？

    //完成分享链接编码
    NSString *url = [kbaseURL stringByAppendingString:[NSString stringWithFormat:@"/yshakeUtil/shareShakeBuy?periods_id=%@",pid]];

    DebugLog(@"=====Url=%@",url);

    //设置分享内容，（图片加上分享内容和链接）
    UIImageView *imgview = [[UIImageView alloc]init];

    [imgview sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UMSocialSnsService presentSnsIconSheetView:VC appKey:@"53f77204fd98c585f200de09"shareText:[NSString stringWithFormat:@"%@%@",title,url] shareImage:imgview.image shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone] delegate:VC];
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]content:[NSString stringWithFormat:@"%@%@",title,url] image:imgview.image location:nil urlResource:nil presentedController:VC completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
            }}];
    }];


    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"一块摇 有人@你";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"一块摇 有人@你";


    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.url = url;
    [UMSocialData defaultData].extConfig.qqData.title = @"一块摇 有人@你";
    [UMSocialData defaultData].extConfig.qzoneData.title = @"一块摇 有人@你";
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
}



#pragma mark - 推荐好友分享
+(void)shareWithUrl:(NSString*)imgurl title:(NSString*)title name:(NSString*)name andQRImage:(UIImage *)image phone:(NSString*)phone andVC:(UIViewController*)VC{


    [UMSocialData defaultData].extConfig.title = title;
    [UMSocialData defaultData].extConfig.qqData.url = imgurl;

    [UMSocialSnsService presentSnsIconSheetView:VC
                                         appKey:@"53f77204fd98c585f200de09"
                                      shareText:[NSString stringWithFormat:@"%@%@",title,imgurl]
                                     shareImage:image
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                       delegate:VC];


    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]content:[NSString stringWithFormat:@"%@%@",title,imgurl] image:image location:nil urlResource:nil presentedController:VC completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
        }}];


    [UMSocialData defaultData].extConfig.wechatTimelineData.url = imgurl;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = imgurl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"一块摇 %@@你",name];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"一块摇 %@@你",name];


    [UMSocialData defaultData].extConfig.qqData.url = imgurl;
    [UMSocialData defaultData].extConfig.qzoneData.url = imgurl;
    [UMSocialData defaultData].extConfig.qqData.title = [NSString stringWithFormat:@"一块摇 %@@你",name];
    [UMSocialData defaultData].extConfig.qzoneData.title = [NSString stringWithFormat:@"一块摇 %@@你",name];
}






@end
