//
//  newActivityPrizeDetailVC.h
//  YKY
//
//  Created by 肖亮 on 15/9/17.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface newActivityPrizeDetailVC : UIViewController

/** 滚动scrollView */
@property (nonatomic , strong) UIScrollView * backScrollView;
/** 小View */
@property (nonatomic , strong) UIView * smallBackView;

/** 奖品详情的title */
@property (nonatomic , strong) UILabel * prizeDeTitle;
/** 商家描述的title */
@property (nonatomic , strong) UILabel * bossDeTitle;
/** 联系电话的title */
@property (nonatomic , strong) UILabel * bossPhTitle;
/** 兑换地址的title */
@property (nonatomic , strong) UILabel * bossAdrTitle;



/** 右上角的奖字 */
@property (weak, nonatomic) UIImageView *rightTopImageView;
/** 奖品图片（大图） */
@property (weak, nonatomic) IBOutlet UIImageView *prizeImageView;
/** 奖品名字Label */
@property (weak, nonatomic) IBOutlet UILabel *prizeNameLabel;
/** 奖品价格label需要拼接“￥” */
@property (weak, nonatomic) IBOutlet UILabel *prizePriceLabel;
/** 活动描述Label */
@property (weak, nonatomic) IBOutlet UILabel *bossDescLabel;
/** 商家电话Label */
@property (weak, nonatomic) IBOutlet UILabel *bossPhoneNmbLabel;
/** 商家地址Label */
@property (weak, nonatomic) IBOutlet UILabel *bossAdressLabel;
/** 奖品描述Label */
@property (weak, nonatomic) UILabel *prizeDetailLabel;



/** 活动产品ID */
@property (nonatomic , copy) NSString  * prizeId;
/** 活动奖品ID */
@property (nonatomic , copy) NSString  * jpId;
/** 活动名称 */
@property (nonatomic , copy) NSString * activName;


@end
