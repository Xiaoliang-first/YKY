//
//  YGChooseKindVC.h
//  YKY
//
//  Created by 肖 亮 on 16/4/12.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class rightImgBtn;
@interface YGChooseKindVC : UIViewController

@property (nonatomic , strong) rightImgBtn * kindsBtn;
@property (nonatomic , strong) rightImgBtn * citysBtn;
@property (nonatomic , copy) NSString * currentKind;
@property (nonatomic , copy) NSString * currentCity;


@end
