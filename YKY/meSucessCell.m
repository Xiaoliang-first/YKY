//
//  meSucessCell.m
//  YKY
//
//  Created by 肖 亮 on 16/4/25.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meSucessCell.h"
#import "homeNewScuessModel.h"

@interface meSucessCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *oderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *pnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myRockNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rockNumLabel;




@end

@implementation meSucessCell

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
        self.rockNumLabel.text = [NSString stringWithFormat:@"已摇%@次",model.luckCount];
    }
    if (model.pname) {
        self.pnameLabel.text = [NSString stringWithFormat:@"%@",model.pname];
    }
    if (model.joinCount) {
        self.myRockNumLabel.text = [NSString stringWithFormat:@"我已摇%@次",model.joinCount];
    }
    if (model.uname) {
        if ([phone isMobileNumber:model.uname]) {
            self.luckNameLabel.text = [phoneSecret phoneSecretWithPhoneNum:[NSString stringWithFormat:@"%@",model.uname]];
        }else{
            self.luckNameLabel.text = [NSString stringWithFormat:@"%@",model.uname];
        }
    }
    if (model.luckCode) {
        self.luckNumLabel.text = [NSString stringWithFormat:@"%@",model.luckCode];
    }

    if ([model.state isEqualToString:@"0"]) {
        [self.getPrizeBtn setTitle:@"领取奖励" forState:UIControlStateNormal];
        [self.getPrizeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.getPrizeBtn setBackgroundImage:[UIImage imageNamed:@"继续摇购"] forState:UIControlStateNormal];
        self.getPrizeBtn.enabled = YES;
    }else{
        [self.getPrizeBtn setTitle:@"已领取" forState:UIControlStateNormal];
        [self.getPrizeBtn setTitleColor:YKYColor(51, 51, 51) forState:UIControlStateNormal];
        [self.getPrizeBtn setBackgroundImage:[UIImage imageNamed:@"好友分享"] forState:UIControlStateNormal];
        self.getPrizeBtn.enabled = NO;
    }

}


- (IBAction)lingqujiangli:(id)sender {
    NSString * index = [NSString stringWithFormat:@"%f",self.index];
    [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"index-jiexiao-lingqu"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"meSuccess-lingqu" object:nil];
}



- (IBAction)jisuanxiangqing:(id)sender {
    NSString * index = [NSString stringWithFormat:@"%f",self.index];
    [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"index-jiexiao-jisuan"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"meSuccess-jisuan" object:nil];
}

- (IBAction)lookMyLuckCode:(id)sender {

    NSString * index = [NSString stringWithFormat:@"%f",self.index];
    [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"index-jiexiao-melook"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"me-jiexiao-lookMyLuckcode" object:nil];
}



@end
