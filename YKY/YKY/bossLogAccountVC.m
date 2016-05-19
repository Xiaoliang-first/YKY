//
//  bossLogAccountVC.m
//  YKY
//
//  Created by 亮肖 on 15/6/25.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//
//********************商家已登录的界面*********************



#import "bossLogAccountVC.h"
#import "QRViewController.h"
#import "AFNetworking.h"
#import "common.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "bossAccount.h"
#import "bossAccountTool.h"
#import "bossAlterPwdVC.h"
#import "bossViewLogVC.h"
#import "myAccountVC.h"
#import "bossLogInAccountVC.h"


@interface bossLogAccountVC ()<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *putInCodeField;
/** 将要使用的奖品的名字 */
@property (weak, nonatomic) IBOutlet UILabel *prizeNameLabel;
/** 将要使用的奖品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *prizeImageView;
/** 奖品使用按钮 */
@property (weak, nonatomic) IBOutlet UIButton *useingPrizeBtn;
@property (weak, nonatomic) IBOutlet UIView *prizeBackView;
@property (nonatomic,copy) NSString * prizeId;
/** 是否已使用 */
@property (nonatomic,copy) NSString * isUsed;
/** 是否已验证 */
@property (nonatomic , copy) NSString * isvalid;
/** 是否已过期 */
@property (nonatomic , copy) NSString * isexpired;


@end

@implementation bossLogAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商家验证";

    [self setRigthItem];
    
    [self setLeftItem];
    
    [self setCurrountPageData];
}

#pragma mark - 导航栏左侧按钮被点击
-(void)setLeftItem{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    [left setImage:[UIImage imageNamed:@"jiantou-Left"]];
    self.navigationItem.leftBarButtonItem = left;
}

-(void)leftClick{
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"是否要退出应用!" message:@"点击“是”，应用将退出!" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alter show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //点击取消的时候不做任何处理，只是消失提示窗
            break;
        case 1:
            exit(0);//暴力退出程序
            break;
            
        default:
            break;
    }
}


#pragma mark - 隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.putInCodeField.text.length == 0) {
        [self.putInCodeField setPlaceholder:@"请输入查询码"];
    }
    [self.putInCodeField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.putInCodeField.text.length == 0) {
        [self.putInCodeField setPlaceholder:@"请输入查询码"];
    }
    [self.putInCodeField resignFirstResponder];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{

    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"prizeCodes"]) {
        if (!self.indentify) {//启动程序的出现
            self.prizeBackView.hidden = YES;
            self.putInCodeField.text = @"请输入查询码";
            self.indentify = @"0";//设置标志
        }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"saomiaochenggong"] isEqualToString:@"1"]){//二维码扫描成功返回的出现
            self.prizeBackView.hidden = NO;
            self.putInCodeField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"prizeCodes"];
            [self loadPrizeDataWithCouponsCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"prizeCodes"]];
            if (self.prizeImageView.image == nil) {//没网络，没数据
                self.prizeBackView.hidden = YES;
                [MBProgressHUD showError:@"网络连接异常，请检查网络"];
            }
            //判断标志清零
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"saomiaochenggong"];
        }else{
            self.prizeBackView.hidden = YES;
            self.putInCodeField.text = @"请输入查询码";
        }
    }else if ([self.putInCodeField.text isEqualToString:@"请输入查询码"]){
        self.prizeBackView.hidden = YES;
    }
    //判断标志清零
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"saomiaochenggong"];
}

#pragma mark - 加载奖品数据
-(void)loadPrizeDataWithCouponsCode:(NSString *)CouponsCode{

    NSString *str = kGetPrizeDataStr;
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    bossAccount *account = [bossAccountTool account];
    
    if (!account) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"商家用户信息有误，请重新登录"];
        [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(goToLogIn) userInfo:nil repeats:NO];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if ([CouponsCode isEqualToString:@"请输入查询码"] || CouponsCode.length == 0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请输入唯一串码!"];
        return;
    }
    if (account.supplierId == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"用户信息不正确!"];
        return;
    }
    
    NSDictionary*parameter = @{@"mId":account.supplierId,@"code":CouponsCode};

    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"----%@",responseObject);
        if ([responseObject[@"code"] isEqual:@(0)]) {
            self.prizeBackView.hidden = NO;
            self.isUsed = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"isused"]];
            self.isvalid = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"isvalid"]];
            self.isexpired = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"isexpired"]];
            if ([self.isUsed isEqualToString:@"0"] && [self.isexpired isEqualToString:@"0"] && [self.isvalid isEqualToString:@"0"]) {
                [self.useingPrizeBtn setTitle:@"使用" forState:UIControlStateNormal];
                [self.useingPrizeBtn setBackgroundColor:[UIColor colorWithRed:29.0/255.0f green:195.0/255.0f blue:192.0/255.0f alpha:1.0f]];
                self.useingPrizeBtn.enabled = YES;
            }else if([self.isUsed isEqualToString:@"1"] || [self.isvalid isEqualToString:@"1"]){
                [self.useingPrizeBtn setTitle:@"已使用" forState:UIControlStateNormal];
                [self.useingPrizeBtn setBackgroundColor:[UIColor grayColor]];
                self.useingPrizeBtn.enabled = NO;
            }else{
                [self.useingPrizeBtn setTitle:@"已过期" forState:UIControlStateNormal];
                [self.useingPrizeBtn setBackgroundColor:[UIColor grayColor]];
                self.useingPrizeBtn.enabled = NO;
            }
            
            [self.prizeImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][0][@"smallUrl"]] placeholderImage:[UIImage imageNamed:@"prepare_loading_big"]];
            self.prizeNameLabel.text = responseObject[@"data"][0][@"couponsName"];
            self.prizeId = responseObject[@"data"][0][@"id"];
        }else{
            self.prizeBackView.hidden = YES;
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
}

#pragma mark - 跳转到商家登陆界面
-(void)goToLogIn{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    bossLogInAccountVC *bossLogIn = [sb instantiateViewControllerWithIdentifier:@"bossLogInAccountVC"];
    [self.navigationController pushViewController:bossLogIn animated:YES];
}

#pragma mark - 设置界面数据
-(void)setCurrountPageData{
    NSString * prizeCodeString = [[NSUserDefaults standardUserDefaults]objectForKey:@"prizeCodes"];
    if (prizeCodeString) {
        self.putInCodeField.text = prizeCodeString;
    }
}

#pragma mark - 设置导航条右侧扫描按钮
-(void)setRigthItem{
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"saomiaoanniu"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];

    self.navigationItem.rightBarButtonItem = right;
}
-(void)rightClick{
    
    if ([self validateCamera]) {
        [self showQRViewController];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头或摄像头不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - 判断是否有摄像头活着摄像头是否能用
- (BOOL)validateCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark - 跳转到扫描界面
- (void)showQRViewController {
    QRViewController *qrVC = [[QRViewController alloc] init];
    [self.navigationController pushViewController:qrVC animated:YES];
}

#pragma mark - 搜索查询码按钮被点击
- (IBAction)searchCodeBtn:(id)sender {
    [self loadPrizeDataWithCouponsCode:self.putInCodeField.text];
}

#pragma mark - 使用按钮被点击
- (IBAction)useringBtnClick:(UIButton*)sender {
    [self loadDataWhenClickUsedBtn];
}


-(void)loadDataWhenClickUsedBtn{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];

    bossAccount * account = [bossAccountTool account];
    NSString *str = kUserUsePrizeStr;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (self.prizeId == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"交易失败!"];
        return;
    }
    NSDictionary * parameters = @{@"couponsId":self.prizeId,@"mId":account.supplierId};
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] isEqual:@(0)]) {
            [MBProgressHUD showSuccess:@"交易成功!"];
            [self.useingPrizeBtn setTitle:@"已使用" forState:UIControlStateNormal];
            [self.useingPrizeBtn setBackgroundColor:[UIColor grayColor]];
            self.useingPrizeBtn.enabled = NO;
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
}

#pragma mark - 注销按钮被点击
- (IBAction)getOutBtnclick:(id)sender {
    [bossAccountTool saveAccount:nil];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myAccountVC *vc = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
    vc.ID = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 修改密码按钮被点击
- (IBAction)changePwdBtnClick:(id)sender {
    bossAccount *account = [bossAccountTool account];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    bossAlterPwdVC *vc = [sb instantiateViewControllerWithIdentifier:@"bossAlterPwdVC"];
    if (account.supplierId) {
        vc.bossID = account.supplierId;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 查看记录按钮被点击
- (IBAction)lookNotesBtnCilck:(id)sender {
    bossAccount *account = [bossAccountTool account];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    bossViewLogVC *vc = [sb instantiateViewControllerWithIdentifier:@"bossViewLogVC"];
    if (account.supplierId) {
        vc.bossID = account.supplierId;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
