//
//  bossExpenseCell.m
//  YKY
//
//  Created by 亮肖 on 15/6/30.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "bossExpenseCell.h"
#import "bossLookConsumeListModel.h"
#import "UIImageView+WebCache.h"

@implementation bossExpenseCell


-(void)setModel:(bossLookConsumeListModel *)model{
    self.prizeNameLabel.text = model.name;
    self.peizeNumberLabel.text = [NSString stringWithFormat:@"%@",model.count];
    
}

@end
