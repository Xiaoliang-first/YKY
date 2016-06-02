//
//  boundCells.m
//  YKY
//
//  Created by 肖亮 on 15/9/9.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "boundCells.h"
#import "unUsedPrizeModel.h"
#import "UIImageView+WebCache.h"


@implementation boundCells

-(void)setModel:(unUsedPrizeModel *)model{
    _model = model;
    UIView * bac = [[UIView alloc]init];
    bac.backgroundColor = YKYClearColor;
    self.selectedBackgroundView = bac;

    if (![model.url isKindOfClass:[NSNull class]]) {
        //设置新图片数据
        [self.prizeImageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"prepareloading_small"]];
    }else{
        //清理旧图片数据
        [self.prizeImageView setImage:[UIImage imageNamed:@"prepareloading_small"]];
    }
    if (model.mname) {
        self.bossNameLabel.text = model.mname;
    }
    if (self.ID && self.ID.length > 0) {
        self.bossNameLabel.text = self.ID;
    }
    if (model.pname) {
        self.prizeNameLabel.text = model.pname;
    }
    if (![model.etime isKindOfClass:[NSNull class]]) {
        self.endTimeLabel.text = [NSString stringWithFormat:@"%@",model.etime];
    }

    //设置图片圆角
    self.prizeImageView.layer.cornerRadius = 5;
    self.prizeImageView.layer.masksToBounds = YES;
    self.prizeImageView.layer.borderWidth = 0.01;

    [self.useBtn setBackgroundImage:[UIImage imageNamed:@"useBtnBackimg"] forState:UIControlStateNormal];
    //    }
    //奖兜搜索界面的cell设置
    NSString * scarchOrNo = [[NSUserDefaults standardUserDefaults]objectForKey:@"prizeSearch1"];
    if ([scarchOrNo isEqualToString:@"1"]) {
        [self.useBtn setBackgroundImage:[UIImage imageNamed:@"useBtnBackimg"] forState:UIControlStateNormal];
    }

}


#pragma mark - 使用按钮点击事件
- (IBAction)useBtnClick:(id)sender {
    
    NSString * index = [NSString stringWithFormat:@"%f",self.index];
    [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"index"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"useBtnClick" object:_model];
}




@end
