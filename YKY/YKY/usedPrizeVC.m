//
//  usedPerzeVC.m
//  YKY
//
//  Created by 亮肖 on 15/5/6.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "usedPrizeVC.h"
#import "unUsedPrizeModel.h"
#import "common.h"
#import "boundsPrizeDetailModel.h"
#import "XLQRCode.h"

@interface usedPrizeVC ()


/** 查询码 */
@property (weak, nonatomic) IBOutlet UILabel *searchCodeLabel;
/** 二维码图片 */
@property (weak, nonatomic) IBOutlet UIImageView *quickMarkImageView;
/** 商家名称 */
@property (weak, nonatomic) IBOutlet UILabel *bossNameLabel;
/** 奖品名称 */
@property (weak, nonatomic) IBOutlet UILabel *prizeNameLabel;
/** 有效期限 */
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@end

@implementation usedPrizeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"使用奖品";
    [self setLeftNavBtn];
    if ([self.identafy isEqualToString:@"1"]) {
        /** 绑定相关数据 */
        if (self.prizeModel.couponsCode) {
            self.searchCodeLabel.text = [NSString stringWithFormat:@"兑换码:%@",self.prizeModel.couponsCode];
        }
        if (self.prizeModel.mname) {
            self.bossNameLabel.text = self.prizeModel.mname;
        }
        if (self.prizeModel.pname) {
            self.prizeNameLabel.text = self.prizeModel.pname;
        }
        if (self.prizeModel.etime) {
            self.endDateLabel.text = self.prizeModel.etime;
        }
    }else{
        /** 绑定相关数据 */
        if (self.bPDetailModel.couponsCode) {
            self.searchCodeLabel.text = [NSString stringWithFormat:@"兑换码:%@",self.bPDetailModel.couponsCode];
        }
        if (self.bPDetailModel.mname) {
            self.bossNameLabel.text = self.bPDetailModel.mname;
        }
        if (self.bPDetailModel.pname) {
            self.prizeNameLabel.text = self.bPDetailModel.pname;
        }
        if (self.bPDetailModel.etime) {
            self.endDateLabel.text = self.bPDetailModel.etime;
        }
    }
    
    self.tabBarController.tabBar.hidden = YES;
    
    /** 生成二维码 */
    [self loadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
}

#pragma mark - 设置左导航nav
-(void)setLeftNavBtn{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    [left setImage:[UIImage imageNamed:@"jiantou-Left"]];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

/**  生成二维码 */
- (void)loadData{

    // 1.创建一个滤镜
    XLQRCode * qr = [[XLQRCode alloc]init];
    // 3.给滤镜设置数据
    NSString *string = self.prizeModel.couponsCode;
    if ([self.identafy isEqualToString:@"2"]) {
        string = self.bPDetailModel.couponsCode;
    }
    qr.codeStr = string;
    qr.imgView = self.quickMarkImageView;
    // 4.获取出输出的数据
    [qr getQRCode];

}

@end
