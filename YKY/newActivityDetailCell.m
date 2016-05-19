//
//  newActivityDetailCell.m
//  YKY
//
//  Created by 肖亮 on 15/9/17.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "newActivityDetailCell.h"
//#import "unUsedPrizeModel.h"
#import "newActivityDetailModel.h"
#import "UIImageView+WebCache.h"

@implementation newActivityDetailCell


-(void)setModel:(newActivityDetailModel *)model{
    _model = model;
    
    if (![self.model.url isKindOfClass:[NSNull class]]) {
        NSString *urlStr = [self.model.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self.prizeImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"prepareloading_small"]];
    }
    //设置图片圆角
    self.prizeImageView.layer.cornerRadius = 5;
    self.prizeImageView.layer.masksToBounds = YES;
    self.prizeImageView.layer.borderWidth = 0.01;
    
    if (![self.model.pname isKindOfClass:[NSNull class]]) {
        self.peizeNameLabel.text = self.model.pname;
    }
    
    if (![self.model.pamount isKindOfClass:[NSNull class]]) {
        int num = [self.model.pamount intValue];
        if (num >9999 && num < 10000000) {
            self.prizeNmbLabel.text = [NSString stringWithFormat:@"%.0d万份",num/10000];
        }else if(num < 10000){
            self.prizeNmbLabel.text = [NSString stringWithFormat:@"%@份",self.model.pamount];
        }else{
            self.prizeNmbLabel.text = @"无限";
        }
    }
    
    if (![self.model.pnowamount isKindOfClass:[NSNull class]]) {
        int num1 = [self.model.pamount intValue];
        int num2 = [self.model.pnowamount intValue];
        int num = num1-num2;
        if (num >9999 && num < 10000000) {
            self.rockedPrizeNmbLabel.text = [NSString stringWithFormat:@"%.0d万份",num/10000];
        }else if(num < 10000){
            self.rockedPrizeNmbLabel.text = [NSString stringWithFormat:@"%d份",num];
        }else{
            self.rockedPrizeNmbLabel.text = @"无限";
        }
//
//        self.rockedPrizeNmbLabel.text = [NSString stringWithFormat:@"%@份",self.model.pnowamount];
    }
    
    if (![self.model.experiedTime isKindOfClass:[NSNull class]]) {
        self.starAndEndDateLabel.text = self.model.experiedTime;
    }
    
}


@end
