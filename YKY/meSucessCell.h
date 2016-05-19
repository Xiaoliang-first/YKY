//
//  meSucessCell.h
//  YKY
//
//  Created by 肖 亮 on 16/4/25.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class homeNewScuessModel;

@interface meSucessCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *getPrizeBtn;

@property (nonatomic , strong) homeNewScuessModel * model;
@property (nonatomic) CGFloat index;

@end
