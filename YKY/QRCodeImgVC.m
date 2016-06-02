//
//  QRCodeImgVC.m
//  YKY
//
//  Created by 肖 亮 on 16/6/1.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "QRCodeImgVC.h"
#import "XLQRCode.h"
#import "bossAccount.h"
#import "bossAccountTool.h"

@interface QRCodeImgVC ()
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImgView;

@end

@implementation QRCodeImgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeft];
    self.title = @"商家二维码";

    [self setQRCode];
}
#pragma mark - 设置leftItem
-(void)setLeft{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"jiantou-Left"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)leftClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)setQRCode{
    bossAccount * account = [bossAccountTool account];
    NSString * codeStr = [NSString stringWithFormat:@"%@@%@",account.supplierId,account.mloginname];
    XLQRCode * code = [[XLQRCode alloc]init];
    code.codeStr = codeStr;
    code.imgView = self.QRCodeImgView;
    [code getQRCode];
}



@end
