//
//  chargeOrNoCell.m
//  YKY
//
//  Created by 肖亮 on 15/9/15.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "chargeOrNoCell.h"
#import "rechargeModel.h"

@implementation chargeOrNoCell


-(void)setModel:(rechargeModel *)model{
    _model = model;

    self.singNmbLabel.text = model.orderNum;
    
    if ([model.rechargeWay isEqualToString:@"99"]) {
        self.chargedWayLabel.text = @"web银联充值";
    }else if([model.rechargeWay isEqualToString:@"1"]){
        self.chargedWayLabel.text = @"微信充值";
    }else{
        self.chargedWayLabel.text = @"银联充值";
    }
    
    int money = [model.money intValue];
    
    if (money > 9999) {//万级单位显示多少多少万
        self.chargeNmbLabel.text = [NSString stringWithFormat:@"%0d万",money/10000];
    }else{//万级以下单位显示全部
        self.chargeNmbLabel.text = [NSString stringWithFormat:@"%d",money];
    }
    
    self.chargedTimeLabel.text = model.makeTime;
}

@end
