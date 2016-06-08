//
//  meLuckCell.m
//  YKY
//
//  Created by 肖 亮 on 16/4/25.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meLuckCell.h"
#import "homeNewScuessModel.h"

@interface meLuckCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *oderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *pnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yiyaoNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@property (weak, nonatomic) IBOutlet UILabel *luckCodeLabel;

@property (weak, nonatomic) IBOutlet UIButton *jixuYGBtn;




@end

@implementation meLuckCell


-(void)setModel:(homeNewScuessModel *)model{

    _model = model;

    //设置图片圆角
    self.imgView.layer.cornerRadius = 5;
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.borderWidth = 0.01;
    if (model.url) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"prepareloading_small"]];
    }else{
        self.imgView.image = [UIImage imageNamed:@"prepareloading_small"];
    }
    if (model.serials) {
        self.oderNumLabel.text = [NSString stringWithFormat:@"第%@期",model.serials];
    }
    if (model.luckCount) {
        self.yiyaoNumLabel.text = [NSString stringWithFormat:@"已摇%@次",model.luckCount];
    }
    if (model.pname) {
        self.pnameLabel.text = [NSString stringWithFormat:@"%@",model.pname];
    }
    if (model.luckCode) {
        self.luckCodeLabel.text = [NSString stringWithFormat:@"%@",model.luckCode];
    }
    if ([model.orderStatue isEqualToString:@"2"]) {
        [self.stateBtn setTitle:@"已完成" forState:UIControlStateNormal];
        [self.stateBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"已完成"] forState:UIControlStateNormal];
    }else if([model.orderStatue isEqualToString:@"3"]){
        [self.stateBtn setTitle:@"已作废" forState:UIControlStateNormal];
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"已摇满"] forState:UIControlStateNormal];
//        self.userInteractionEnabled = NO;
    }else{
        [self.stateBtn setTitle:@"状态跟踪" forState:UIControlStateNormal];
        [self.stateBtn setTitleColor:YKYColor(51, 51, 51) forState:UIControlStateNormal];
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"好友分享"] forState:UIControlStateNormal];
    }
}




- (IBAction)jixuyaogou:(id)sender {

    NSString * index = [NSString stringWithFormat:@"%f",self.index];
    [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"index-xingyundou-jixuYG"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"meluck-jixuYG" object:nil];
    
}

- (IBAction)stateBtnClick:(id)sender {

    NSString * index = [NSString stringWithFormat:@"%f",self.index];
    [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"index-xingyundou-ztgz"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"meluck-ztgz" object:nil];
}


- (IBAction)lookLuckCodeBtnClick:(id)sender {
    NSString * index = [NSString stringWithFormat:@"%f",self.index];
    [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"index-xingyundou-melook"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"me-xingyundou-llcode" object:nil];
}




- (IBAction)shareToFriend:(id)sender {

    NSString * index = [NSString stringWithFormat:@"%f",self.index];
    [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"index-xingyundou-share"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"me-xingyundou-share" object:nil];
}





@end
