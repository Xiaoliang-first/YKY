//
//  QRViewController.m
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRView.h"
#import "MBProgressHUD+MJ.h"
#import "bossLogAccountVC.h"


@interface QRViewController ()<AVCaptureMetadataOutputObjectsDelegate,QRViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;
@property (nonatomic , strong) UIAlertView * photoAlterView;

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫描";
    [self setLeftNavBtn];
    // Do any additional setup after loading the view.


    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if(status == AVAuthorizationStatusNotDetermined || status == AVAuthorizationStatusAuthorized) {
        // authorized
        [self setupCamera];
    } else if(status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted){
        self.photoAlterView = [[UIAlertView alloc]initWithTitle:@"提示:" message:@"没有访问相机权限,请您去设置界面提供访问授权!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去设置", nil];
        [self.photoAlterView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case 1:
            if ([alertView isEqual:self.photoAlterView]) {
                //跳转到设置的 Photos 照片与相机页面
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
            break;

        default:
            break;
    }

}
//开始相机访问（扫描）
-(void)setupCamera{
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];

    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }

    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }

    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];


    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResize;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];

    [_session startRunning];


    CGRect screenRect = [UIScreen mainScreen].bounds;
    QRView *qrRectView = [[QRView alloc] initWithFrame:screenRect];
    qrRectView.transparentArea = CGSizeMake(200, 200);
    qrRectView.backgroundColor = [UIColor clearColor];
    qrRectView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    qrRectView.delegate = self;
    [self.view addSubview:qrRectView];

    UIButton *pop = [UIButton buttonWithType:UIButtonTypeCustom];
    pop.frame = CGRectMake(20, 20, 50, 50);
    [pop setTitle:@"返回" forState:UIControlStateNormal];
    [pop addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pop];

    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - qrRectView.transparentArea.width) / 2,(screenHeight - qrRectView.transparentArea.height) / 2,qrRectView.transparentArea.width,qrRectView.transparentArea.height);

    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,cropRect.origin.x / screenWidth,cropRect.size.height / screenHeight,cropRect.size.width / screenWidth)];
}

- (void)pop:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark QRViewDelegate
-(void)scanTypeConfig:(QRItem *)item {
    
    if (item.type == QRItemTypeQRCode) {
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    } else if (item.type == QRItemTypeOther) {
        _output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeQRCode];
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }

    DebugLog(@"扫描结果=%@",stringValue);
    if (stringValue) {
        if ([self.ID isEqualToString:@"1"]) {//首页进入传1，商家段登陆不传
            [[NSUserDefaults standardUserDefaults]setObject:stringValue forKey:@"prizeCodes"];
            //进入扫描结果的列表界面
            
        }else{
            [[NSUserDefaults standardUserDefaults]setObject:stringValue forKey:@"prizeCodes"];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"saomiaochenggong"];
        }
    }else{
        [MBProgressHUD showError:@"二维码扫描失败"];
    }
    
    if (self.qrUrlBlock) {
        self.qrUrlBlock(stringValue);
    }

    [self pop:nil];
}


@end
