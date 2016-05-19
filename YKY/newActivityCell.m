//
//  newActivityCell.m
//  YKY
//
//  Created by 肖亮 on 15/9/16.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "newActivityCell.h"
#import "UIImageView+WebCache.h"
#import "newActivityModel.h"

@implementation newActivityCell


-(void)setActivityModel:(newActivityModel *)activityModel{
    _activityModel = activityModel;


    if ([activityModel.statu isEqual:@0]) {
        self.backTimeView.hidden = YES;
    }else{
        self.backTimeView.hidden = NO;
    }

    //图片
    [self.prizeImageView sd_setImageWithURL:[NSURL URLWithString:_activityModel.activeUrl] placeholderImage:[UIImage imageNamed:@"prepare_loading_big"]];
    //奖品名称
    self.prizeNameLabel.text = _activityModel.activeName;
    //有效期
    NSString *star = _activityModel.startDate;
    NSString * starDate = [star stringByAppendingString:@"至"];
    self.starAndEndDateLabel.text = [starDate stringByAppendingString:_activityModel.endDate];
    
}



@end
