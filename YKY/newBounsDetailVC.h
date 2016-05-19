//
//  newBounsDetailVC.h
//  YKY
//
//  Created by 肖亮 on 15/9/18.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface newBounsDetailVC : UIViewController

/** 优惠券Id */
@property (nonatomic , copy) NSString * couponsId;
///** 优惠券类型 */
@property (nonatomic , copy) NSString * Type;


/** 判断是否是搜索奖品界面进来 1：是  */
@property (nonatomic , copy) NSString * identify;

@end
