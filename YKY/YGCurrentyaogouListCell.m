//
//  YGCurrentyaogouListCell.m
//  YKY
//
//  Created by 肖 亮 on 16/4/11.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "YGCurrentyaogouListCell.h"
#import "YGCurrentyaogouListModel.h"


@interface YGCurrentyaogouListCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *luckNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckRockNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *btnqicanyu;
@property (weak, nonatomic) IBOutlet UILabel *renci;

@end

@implementation YGCurrentyaogouListCell

-(void)setLuckModel:(YGCurrentyaogouListModel *)LuckModel{
    _LuckModel = LuckModel;

    self.luckNameLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    self.luckCityLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    self.luckRockNumLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    self.luckDateLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    self.btnqicanyu.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    self.renci.font = [UIFont systemFontOfSize:[myFont getTitle3]];

    self.userInteractionEnabled = NO;

    //设置图片圆角
    self.iconView.layer.cornerRadius = 30;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderWidth = 0.01;
    //设置图片圆角
    self.iconView.superview.layer.cornerRadius = 30;
    self.iconView.superview.layer.masksToBounds = YES;
    self.iconView.superview.layer.borderWidth = 0.01;

    if (LuckModel.luckerIconUrlstr) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:LuckModel.luckerIconUrlstr] placeholderImage:[UIImage imageNamed:@"prepare_loading_big"]];
    }else{
        self.iconView.image = [UIImage imageNamed:@"prepare_loading_big"];
    }
    if (LuckModel.luckerName) {
        if ([phone isMobileNumber:LuckModel.luckerName]) {
            self.luckNameLabel.text = [phoneSecret phoneSecretWithPhoneNum:LuckModel.luckerName];
        }else{
            self.luckNameLabel.text = LuckModel.luckerName;
        }
    }else{
        self.luckNameLabel.text = @"昵称";
    }
    if (LuckModel.luckerRockNum) {
        self.luckRockNumLabel.text = LuckModel.luckerRockNum;
    }else{
        self.luckRockNumLabel.text = @"0";
    }
    if (LuckModel.luckerCity) {
        self.luckCityLabel.text = LuckModel.luckerCity;
    }else{
        self.luckCityLabel.text = @"北京市";
    }
    if (LuckModel.luckDate) {
        self.luckDateLabel.text = LuckModel.luckDate;
    }else{
        self.luckDateLabel.text = @"2016-03-01 10:25:22:000";
    }
}


@end
