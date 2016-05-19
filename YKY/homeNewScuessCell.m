//
//  homeNewScuessCell.m
//  YKY
//
//  Created by 肖 亮 on 16/4/20.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "homeNewScuessCell.h"
#import "homeNewScuessModel.h"

@interface homeNewScuessCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *pNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *oderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckTimeLabel;


@end

@implementation homeNewScuessCell


-(void)setModel:(homeNewScuessModel *)model{
    _model = model;

    //设置图片圆角
    self.imgView.layer.cornerRadius = 2;
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.borderWidth = 0.01;

    if (model.url) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"prepare_loading_big"]];
    }else{
        self.imgView.image = [UIImage imageNamed:@"prepare_loading_big"];
    }
    if (model.pname) {
        self.pNameLabel.text = model.pname;
    }
    if (model.serials) {
        self.oderNumLabel.text = model.serials;
    }
    if (model.uname) {
        self.uNameLabel.text = model.uname;
        if ([phone isMobileNumber:model.uname]) {
            self.uNameLabel.text = [phoneSecret phoneSecretWithPhoneNum:model.uname];
        }
    }
    if (model.luckCount) {
        self.joinNumLabel.text = model.luckCount;
    }
    if (model.priNum) {
        self.luckNumLabel.text = model.priNum;
    }
    if (model.ptime) {
        self.luckTimeLabel.text = model.ptime;
    }
}



@end
