//
//  homeTableViewCell.m
//  YKY
//
//  Created by 肖亮 on 15/9/8.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "homeTableViewCell.h"
#import "prizeModel.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"

@implementation homeTableViewCell

-(void)setPrizemodel:(prizeModel *)prizemodel{
    _prizemodel = prizemodel;

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    if (!prizemodel) {
        return;
    }
    if (!prizemodel.mname) {
        return;
    }
    self.bossNameLabel.text = prizemodel.mname;
    self.bossNameLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    if (!prizemodel.pname) {
        return;
    }
    self.prizeNameLabel.text = prizemodel.pname;
    self.prizeNameLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    if (!prizemodel.marketPrice) {
        return;
    }
    NSString *price = [NSString stringWithFormat:@"￥%@",prizemodel.marketPrice];
    self.prizePriceLabel.text = price;
    self.prizePriceLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    if (!prizemodel.shakeNum || !prizemodel.num) {
        return;
    }
    
    NSString * prizeNmb = [NSString stringWithFormat:@"%@份",prizemodel.num];
    DebugLog(@"===prizeNmb=%@",prizeNmb);
    CGFloat num = 0.0f;
    self.prizeNumberLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    if (kScreenWidth == 320) {
        self.prizeNumberLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
        self.prizeNumLayout.constant = -5;
    }
    if ([prizemodel.num intValue] > 9999 && [prizemodel.num intValue] < 1000000) {
        num = [prizemodel.num intValue]/10000;
        prizeNmb = [NSString stringWithFormat:@"%.1f万",num];
        self.prizeNumberLabel.text = prizeNmb;
    }else if ([prizemodel.num intValue] > 999999) {
        self.prizeNumberLabel.text = @"无限";
    }else{
        self.prizeNumberLabel.text = prizeNmb;
    }
    DebugLog(@"===prizeNmb=%@",prizeNmb);

    CGFloat rocNum = 0.0f;
    NSString * pRockNmb = [NSString stringWithFormat:@"%@份",prizemodel.shakeNum];
    DebugLog(@"====%@",pRockNmb);
    self.rockedNumberLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    self.shuliang.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    self.yiyaochu.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    if ([prizemodel.shakeNum intValue] > 10000 && [prizemodel.shakeNum intValue]<1000000) {
        rocNum = [prizemodel.shakeNum intValue]/10000;
        pRockNmb = [NSString stringWithFormat:@"%.1f万",num];
        self.rockedNumberLabel.text = pRockNmb;
    }else if ([prizemodel.shakeNum intValue] > 999999) {
        self.rockedNumberLabel.text = @"无限";
    }else{
        self.rockedNumberLabel.text = pRockNmb;
    }

    if (!prizemodel.url) {
        return;
    }
    NSURL *url = [NSURL URLWithString:prizemodel.url];
    [self.ImageView  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"prepare_loading_big"]];

    //设置图片圆角
    self.ImageView.layer.cornerRadius = 5;
    self.ImageView.layer.masksToBounds = YES;
    self.ImageView.layer.borderWidth = 0.01;
}


@end
