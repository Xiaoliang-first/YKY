//
//  managerCommendatoryCell.h
//  YKY
//
//  Created by 亮肖 on 15/6/15.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class managerCommendatoryModel;

@interface managerCommendatoryCell : UITableViewCell

/** 奖品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *prizeImageView;
/** 奖品名字Label */
@property (weak, nonatomic) IBOutlet UILabel *prizeNameLabel;
/** 奖品价格Label */
@property (weak, nonatomic) IBOutlet UILabel *prizePriceLael;
/** 奖品所属类型描述 */
@property (weak, nonatomic) IBOutlet UILabel *prizeType;


/** 店长推荐的数据模型 */
@property (nonatomic , strong) managerCommendatoryModel * managerModel;


@end
