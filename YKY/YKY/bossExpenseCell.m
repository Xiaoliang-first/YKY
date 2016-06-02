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
    _model = model;
    self.prizeNameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    NSString * phone = [phoneSecret phoneSecretWithPhoneNum:model.phone];
    self.phoneL.text = [NSString stringWithFormat:@"%@",phone];
    self.timeL.text = [NSString stringWithFormat:@"%@",model.time];
    self.codeL.text = [NSString stringWithFormat:@"%@",model.code];

}

@end
