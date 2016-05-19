//
//  pinlessVC.m
//  YKY
//
//  Created by 肖亮 on 15/10/15.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "pinlessVC.h"
#import "chargeCityCell.h"
#import "severceDeal.h"
#import "cityModel.h"
#import "common.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "AccountTool.h"
#import <CommonCrypto/CommonDigest.h>
#import "Account.h"



@interface pinlessVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

/** 电话号码label */
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

/** 推荐人电话号码电话号码field */
@property (weak, nonatomic) IBOutlet UITextField *friendPhoneNumberField;
/** 密码field */
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
/** 确认密码field */
@property (weak, nonatomic) IBOutlet UITextField *okPwdField;
/** 当前城市btn */
@property (weak, nonatomic) IBOutlet UIButton *currentCityBtn;
/** 选择市区btn */
@property (weak, nonatomic) IBOutlet UIButton *chooseCityBtn;

/** 是否已阅读服务协议 */
@property (weak, nonatomic) IBOutlet UIButton *okReadSeverBtn;

/** 城市tableView */
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
/** 确认按钮 */
@property (weak, nonatomic) IBOutlet UIButton *okBtn;


/** 数据源 */
@property (nonatomic , strong) NSMutableArray * dataArray;

/** 是否已阅读相关服务条款政策 */
@property (nonatomic) BOOL haveReadTheSeverce;


@property (nonatomic , copy) NSString * myChooesCityId;

@end

@implementation pinlessVC


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"绑定手机号";
    
    self.phoneNumberLabel.text = self.phoneNumber;
    
    self.pwdField.delegate = self;
    self.okPwdField.delegate = self;
    self.friendPhoneNumberField.delegate = self;
    
    //设置左按钮
    [self setLeftNavBtn];
    
    //用两个Tableview注册cell
    [self.cityTableView registerNib:[UINib nibWithNibName:@"chargeCityCell" bundle:nil] forCellReuseIdentifier:@"chargeCityCell"];
        
    //加载城市数据
    [self loadData];
    
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

#pragma mark - ViewApper和viewDissApper
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
    self.haveReadTheSeverce = YES;//默认勾选已阅读服务协议
}
-(void)viewWillDisappear:(BOOL)animated{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.pwdField resignFirstResponder];
    [self.friendPhoneNumberField resignFirstResponder];
    [self.okPwdField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.pwdField resignFirstResponder];
    [self.friendPhoneNumberField resignFirstResponder];
    [self.okPwdField resignFirstResponder];
    return YES;
}


#pragma mark - 加载城市数据
-(void)loadData{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    NSString * str = kgetCityListStr;

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:@(0)]) {
            if (responseObject[@"AllCity"] == nil) {
                return ;
            }
            for (NSDictionary * dict in responseObject[@"AllCity"]) {
                cityModel * model = [cityModel cityWithDict:dict];
                [self.dataArray addObject:model];
            }
            [self.cityTableView reloadData];
        }else{
            [MBProgressHUD showError:@"城市列表加载失败!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请稍后再试!"];
    }];
}

#pragma mark - 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID = @"chargeCityCell";
    chargeCityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cityModel * model = self.dataArray[indexPath.row];
    
    cell.cityNameLabel.text = model.ciName;
    
    return cell;
}


#pragma mark - 代理方法
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}


#pragma mark - 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cityModel * model = self.dataArray[indexPath.row];
        
    [self.currentCityBtn setTitle:model.ciName forState:UIControlStateNormal];
    
    //保存选中的城市
    [[NSUserDefaults standardUserDefaults] setObject:model.ciName forKey:@"signInCity"];
    
    self.myChooesCityId = model.ciId;
    
    self.okBtn.enabled = YES;
    
    self.cityTableView.hidden = YES;
    
}


static BOOL agree = YES;
#pragma mark - 选择是否已阅读服务协议按钮点击事件
- (IBAction)chooseReadSeverBtnClick:(id)sender {
    if (agree) {
        self.haveReadTheSeverce = NO;
        self.okBtn.enabled = NO;
        [self.okReadSeverBtn setBackgroundImage:[UIImage imageNamed:@"baisejuxing"] forState:UIControlStateNormal];
        agree = NO;
    }else{
        self.haveReadTheSeverce = YES;
        self.okBtn.enabled = YES;
        [self.okReadSeverBtn setBackgroundImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
        agree = YES;
    }
}

#pragma mark - 阅读服务协议按钮点击事件
- (IBAction)readSeverBntClick:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    severceDeal * vc = [sb instantiateViewControllerWithIdentifier:@"severceDeal"];
    vc.identify = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 选择城市按钮被点击
- (IBAction)chooseCityBtnClick:(id)sender {
    self.cityTableView.hidden = NO;
}



#pragma mark - 确认按钮点击事件
- (IBAction)okBtnClik:(id)sender {
    
    if (self.haveReadTheSeverce) {
        [self signAndUsePhoneNumberGetUserInfo];
    }else{
        [MBProgressHUD showError:@"请您阅读并同意相关协议!"];
        return;
    }
    
}

#pragma mark - 注册加绑定手机号
-(void)signAndUsePhoneNumberGetUserInfo{
    
    if (self.pwdField.text.length == 0) {
        [MBProgressHUD showError:@"请输入密码!"];
        return;
    }
    
    if (![self.pwdField.text isEqual:self.okPwdField.text]) {
        [MBProgressHUD showError:@"密码输入不一致!"];
        return;
    }
    
    [MBProgressHUD showMessage:@"绑定中..." toView:self.view];
    
    NSString * str = kthirdRegist;
    
    NSDictionary *parameter = [[NSDictionary alloc]init];
    
    if ([self.registType isEqualToString:@"2"]) {
        parameter = @{@"name":self.snsAccount.userName,@"openId":self.snsAccount.openId,@"third_type":self.registType,@"loginName":self.phoneNumber,@"cid":self.myChooesCityId,@"headImage":self.snsAccount.iconURL,@"pwd":[self md5:self.okPwdField.text],@"regFrom":@1};
        if (self.friendPhoneNumberField.text.length > 5) {
            parameter = @{@"name":self.snsAccount.userName,@"openId":self.snsAccount.openId,@"third_type":self.registType,@"loginName":self.phoneNumber,@"cid":self.myChooesCityId,@"headImage":self.snsAccount.iconURL,@"linkPhone":self.friendPhoneNumberField.text,@"pwd":[self md5:self.okPwdField.text],@"regFrom":@1};
        }
        
    }else{
        parameter = @{@"name":self.snsAccount.userName,@"openId":self.snsAccount.usid,@"third_type":self.registType,@"loginName":self.phoneNumber,@"cid":self.myChooesCityId,@"headImage":self.snsAccount.iconURL,@"pwd":[self md5:self.okPwdField.text],@"regFrom":@1};
        
        if (self.friendPhoneNumberField.text.length == 11) {
            parameter = @{@"name":self.snsAccount.userName,@"openId":self.snsAccount.usid,@"third_type":self.registType,@"loginName":self.phoneNumber,@"cid":self.myChooesCityId,@"headImage":self.snsAccount.iconURL,@"linkPhone":self.friendPhoneNumberField.text,@"pwd":[self md5:self.okPwdField.text],@"regFrom":@1};
        }
    }
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([responseObject[@"code"] isEqual:@(0)]) {
            Account * account = [Account accountWithDict:responseObject[@"data"][0]];
            [AccountTool saveAccount:nil];
            [AccountTool saveAccount:account];
            [MBProgressHUD showSuccess:@"手机号验证码成功!"];
            [self.navigationController popToRootViewControllerAnimated:YES];

        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常,请检查您的网络!"];
    }];
    
}


#pragma mark - MD5密码加密
-(NSString *)md5:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


@end
