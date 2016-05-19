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
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.设置默认的属性
    [filter setDefaults];
    
    // 3.给滤镜设置数据
    NSString *string = self.prizeModel.couponsCode;
    if ([self.identafy isEqualToString:@"2"]) {
        string = self.bPDetailModel.couponsCode;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取出输出的数据
    CIImage *outputImage = [filter outputImage];
    
    // 5.设置到imageView上面
    self.quickMarkImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


@end
