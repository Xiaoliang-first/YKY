//
//  meRuningPrizeCell.m
//  YKY
//
//  Created by 肖 亮 on 16/4/19.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meRuningPrizeCell.h"
#import "homeNewScuessModel.h"
#import "XLProgressBarView.h"

@interface meRuningPrizeCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *qiNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *prizeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *yiyaoNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *xiangouNumLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBackView;

@property (nonatomic , strong) XLProgressBarView * progressVeiw;
@property (nonatomic , strong) UILabel * leftLabel;
@property (nonatomic , strong) UILabel * rightLabel;

@property (weak, nonatomic) IBOutlet UIView *myContentView;
@property (weak, nonatomic) IBOutlet UILabel *xianyaoLabel;

@property (weak, nonatomic) IBOutlet UIButton *rockAgainBtn;



@end

@implementation meRuningPrizeCell


-(void)setModel:(homeNewScuessModel *)model{
    _model = model;

    if ([model.joinCount isEqual:model.plimit]) {//已摇满
        [self.rockAgainBtn setTitle:@"已摇满" forState:UIControlStateNormal];
        [self.rockAgainBtn setTitleColor:YKYColor(109, 109, 109) forState:UIControlStateNormal];
        [self.rockAgainBtn setBackgroundImage:[UIImage imageNamed:@"已摇满"] forState:UIControlStateNormal];
    }else{
        [self.rockAgainBtn setTitle:@"再次去摇" forState:UIControlStateNormal];
        [self.rockAgainBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.rockAgainBtn setBackgroundImage:[UIImage imageNamed:@"继续摇购"] forState:UIControlStateNormal];
    }

    
    //设置图片圆角
    self.imgV.layer.cornerRadius = 5;
    self.imgV.layer.masksToBounds = YES;
    self.imgV.layer.borderWidth = 0.01;
    self.imgV.image = [UIImage imageNamed:@"prepareloading_small"];

    if (model.url) {
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"prepareloading_small"]];
    }
    if (model.serials) {
        self.qiNumLabel.text = [NSString stringWithFormat:@"第%@期",model.serials];
    }
    if (model.pname) {
        self.prizeNameLabel.text = model.pname;
    }
    DebugLog(@"==%@",model.plimit);
    if ([model.plimit isEqualToString:@"0"] || !_model.plimit) {
        self.xiangouNumLabel.hidden = YES;
        self.xianyaoLabel.hidden = YES;
    }else{
        self.xiangouNumLabel.text = [NSString stringWithFormat:@"%@人次",model.plimit];
        self.xiangouNumLabel.hidden = NO;
        self.xianyaoLabel.hidden = NO;
    }
    if (model.zongNum && model.shengNum) {
        //添加progress
        CGFloat magin = 15;
        self.progressVeiw = [[XLProgressBarView alloc]initWithFrame:CGRectMake(_imgV.x, _imgV.y+_imgV.height+10, kScreenWidth-2*_imgV.x, 8) backgroundImage:[UIImage imageNamed:@"progressBack"] foregroundImage:[UIImage imageNamed:@"progress"]];
        //已摇出数量
        CGFloat pro = [model.zongNum floatValue] - [model.shengNum floatValue];
        self.progressVeiw.progress = pro/[model.zongNum floatValue];
        [self.myContentView addSubview:self.progressVeiw];


        //添加底部左右显示数量label
        //1.左
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(magin, self.progressVeiw.y+self.progressVeiw.height+4, 0.4*self.progressVeiw.width, 13)];
        self.leftLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
        self.leftLabel.textColor = [UIColor darkGrayColor];
        self.leftLabel.textAlignment = NSTextAlignmentLeft;
        self.leftLabel.text = [NSString stringWithFormat:@"总需%@人次",model.zongNum];
        [self.myContentView addSubview:self.leftLabel];
        //2.右
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-self.leftLabel.width-magin, self.progressVeiw.y+self.progressVeiw.height+4, 0.4*self.progressVeiw.width, 13)];
        self.rightLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
        self.rightLabel.textColor = [UIColor darkGrayColor];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        self.rightLabel.text = [NSString stringWithFormat:@"剩余%@人次",model.shengNum];
        [self.myContentView addSubview:self.rightLabel];
    }

    if (model.joinCount) {
        [self.yiyaoNumLabel setTitle:[NSString stringWithFormat:@"我已摇:%@次",model.joinCount] forState:UIControlStateNormal];
    }else{
        [self.yiyaoNumLabel setTitle:@"我已摇:0次" forState:UIControlStateNormal];
    }
}

#pragma mark - 查看摇码
- (IBAction)lookYaoMaBtnClick:(id)sender {
    NSString * index = [NSString stringWithFormat:@"%f",self.index];
    [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"index-yaogou-melook"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"melookMyLuckcode" object:nil];
}
#pragma mark - 再次去摇
- (IBAction)yaoGouAgainBtnClick:(id)sender {
    if ([_model.joinCount isEqual:_model.plimit]) {//已摇满
    }else{
        NSString * index = [NSString stringWithFormat:@"%f",self.index];
        [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"index-yaogou-merock"];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"meYGRockAgain" object:nil];
    }
}


//避免滚动重复显示 重写prepareForReuse方法，在重用时移除添加的视图
-(void)prepareForReuse{
    [super prepareForReuse];
    [self.progressVeiw removeFromSuperview];
    [self.leftLabel removeFromSuperview];
    [self.rightLabel removeFromSuperview];
}


@end
