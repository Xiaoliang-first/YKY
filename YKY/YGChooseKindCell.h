//
//  YGChooseKindCell.h
//  YKY
//
//  Created by 肖 亮 on 16/4/12.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class kindModel;
@interface YGChooseKindCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *kindTitleLabel;

@property (nonatomic , strong) kindModel * kindmodel;

@end
