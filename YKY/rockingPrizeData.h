//
//  rockingPrizeData.h
//  YKY
//
//  Created by 肖亮 on 15/12/17.
//  Copyright © 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface rockingPrizeData : NSObject


/**
 *  展示摇出来的奖品数据
 *
 *  @param couponsName 奖品名称
 *  @param url         奖品的图片URL
 *  @param endDate     奖品有效期截止时间
 *  @param VC          要展示的控制器
 *  @param remove      删除展示图方法
 *  @param lookDetail  查看奖品详情方法
 *  @param share       分享给好友的方法
 */
+(void)prizeShowWithCouponsName:(NSString*)couponsName andImgUrlStr:(NSString*)url andEndDate:(NSString*)endDate andVC:(UIViewController*)VC remove:(SEL)remove lookDetail:(SEL)lookDetail share:(SEL)share;

/**
 *  删除展示图的方法
 */
+(void)dissmess;



@end
