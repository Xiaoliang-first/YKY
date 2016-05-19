//
//  myCenterVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/10.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "myCenterVC.h"
#import "userInfo.h"
#import "common.h"
#import "UIButton+WebCache.h"
#import "AFNetworking.h"
#import "smallBtnsView.h"
#import "UIView+XL.h"
#import "Account.h"
#import "AccountTool.h"
#import "fixUserNameVC.h"
#import "MBProgressHUD+MJ.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <SystemConfiguration/SystemConfiguration.h>



@interface myCenterVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>


/** 头像图片按钮 */
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
/** 用户昵称Label */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/** 用户性别Label */
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
/** 性别标注（1：男 0：女  上传服务器用）*/
@property (nonatomic , copy) NSString * sexStr;
/** 用户年龄Label */
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
/** 年龄字符串 */
@property (nonatomic , copy) NSString * ageStr;
/** 用户爱好Label */
@property (weak, nonatomic) IBOutlet UILabel *hopyLabel;


/** 选择头像和性别时弹框的背景View */
@property (nonatomic , strong) UIView * backView;
/** 选择取照方式或男女性别的背景View */
@property (nonatomic , strong) UIView * choiceView;
/** 取消选择取照方式或男女性别的背景View */
@property (nonatomic , strong) UIView * cancleChoiceView;
/** 半透明黑色遮盖的Btn */
@property (nonatomic , strong) UIButton * backBtn;
/** 年龄选择的backview */
@property (nonatomic , strong) UIView * ageChoiceBackView;
/** 供选择的年龄数组 */
@property (nonatomic , strong) NSMutableArray * ages;
@property (nonatomic , strong) NSMutableArray * ageStrs;
@property (nonatomic , strong) UIPickerView * agePick;


/* 访问相机alter **/
@property (nonatomic , strong) UIAlertView * alter1;
/* 访问相册alter **/
@property (nonatomic , strong) UIAlertView * alter2;
@property (nonatomic , strong) UIImagePickerController *imagePick;


@end

@implementation myCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    
    //设置界面上的数据
    [self setDataWithModel];
    
    //设置左右导航按钮
    [self setLeftAndRightNavBtn];
}

#pragma mark - 设置界面上的数据
- (void)setDataWithModel{
    if (self.userInfoModel.uiHeadImage) {
        [self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.userInfoModel.uiHeadImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon-me"]];
        //设置图片圆角
        self.iconBtn.layer.cornerRadius = 0.5*self.iconBtn.width;
        self.iconBtn.layer.masksToBounds = YES;
        self.iconBtn.layer.borderWidth = 0.01;
    }
    if (self.userInfoModel.uiHeadImage.length==0){
        [self.iconBtn setBackgroundImage:[UIImage imageNamed:@"icon-me"] forState:UIControlStateNormal];
    }
    if (self.userInfoModel.uiName) {
        self.userNameLabel.text = self.userInfoModel.uiName;
    }else{
        self.userNameLabel.text = self.userName;
    }
    if (self.userInfoModel.age) {
        if (self.userInfoModel.age) {
            self.ageLabel.text = [NSString stringWithFormat:@"%@岁",self.userInfoModel.age];
        }else{
            self.ageLabel.text = @"0岁";
        }
    }else if([[NSUserDefaults standardUserDefaults]objectForKey:@"myAge"]){
        self.ageLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"myAge"];
    }
    //设置用户性别(男或者女)
    if (self.userInfoModel.uiSex) {
        if ([self.userInfoModel.uiSex isEqual:@1]) {
            self.sexLabel.text = @"男";
        }else{
            self.sexLabel.text = @"女";
        }
    }else{
        if ([self.sex isEqualToString:@"1"]) {
            self.sexLabel.text = @"男";
        }else{
            self.sexLabel.text = @"女";
        }
    }
   
    //设置用户喜爱和城市（是否从网上获取到数据的判断和设置）
    if ([self.userInfoModel.hobby isEqualToString:@""]) {//从网上获取到空字符串
        self.hopyLabel.text = @"请认真填写";
    }else{//从网上获取到数据时
        self.hopyLabel.text = self.userInfoModel.hobby;
    }
}

#pragma mark - viewWillApper方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftAndRightNavBtn];
    self.tabBarController.tabBar.hidden = YES;
    
    //用户头像处理
    self.imagePick = [[UIImagePickerController alloc]init];
    self.imagePick.delegate = self;
    
    //用户名处理
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"fixedUserName"]) {
        self.userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"fixedUserName"];
        //清空暂存空间
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"fixedUserName"];
    }
    if (self.userName) {
        self.userNameLabel.text = self.userName;
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"myAge"]) {
        self.age = [[NSUserDefaults standardUserDefaults]objectForKey:@"myAge"];
        self.ageLabel.text = self.age;
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"sex"]) {
        self.sex = [[NSUserDefaults standardUserDefaults]objectForKey:@"sex"];
        if ([self.sex isEqualToString:@"1"]) {
            self.sexLabel.text = @"男";
        }else if ([self.sex isEqualToString:@"0"]){
            self.sexLabel.text = @"女";
        }
    }
    if (self.iconUrl.length>0) {
        [self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon-me"]];
    }
    //用户爱好处理
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"myHopy"]) {
        self.hopyLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"myHopy"];
    }
    
}

#pragma mark - 设置左右导航按钮
-(void)setLeftAndRightNavBtn{
    //设置导航栏右侧登陆按钮
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;


    //设置导航栏左侧城市切换按钮
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    [left setImage:[UIImage imageNamed:@"jiantou-Left"]];
    self.navigationItem.leftBarButtonItem = left;
}

#pragma mark - 左导航按钮点击事件
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 提交(右导航)按钮点击事件
-(void)rightClick{
    NSString *string = @"0";
    if ([self.sexLabel.text isEqualToString:@"女"]) {
        string = @"0";
    }else{
        string = @"1";
    }

    Account * account = [AccountTool account];
    if (!account) {
        return;
    }
    NSString * str9=[[NSUserDefaults standardUserDefaults]objectForKey:@"iconUrl"];
    
    if (str9.length == 0 && self.userInfoModel.uiHeadImage.length == 0) {
        [MBProgressHUD showError:@"请选择头像"];
        return;
    }
    if (self.userNameLabel.text.length == 0) {
        [MBProgressHUD showError:@"请设置昵称"];
        return;
    }
    if ([self.ageLabel.text isEqualToString:@"0岁"] || self.ageLabel.text.length < 2) {
        [MBProgressHUD showError:@"请选择年龄"];
        return;
    }
    if (self.sexLabel.text.length == 0) {
        [MBProgressHUD showError:@"请选择性别"];
        return;
    }
    NSString * hopy = [[NSUserDefaults standardUserDefaults]objectForKey:@"myHopy-update"];

    //默认爱好
    if (hopy.length == 0 && self.hopyLabel.text.length == 0) {
        [MBProgressHUD showError:@"请选择爱好"];
        return;
    }else if (hopy.length == 0){
        hopy = [self.hopyLabel.text stringByReplacingOccurrencesOfString:@" " withString:@"、"];
    }

    NSString *str = kUpdateUserMessageStr;

    NSString * ageLast = [self.ageLabel.text substringToIndex:2];

    NSDictionary * parameters = [[NSDictionary alloc]init];

    parameters = @{@"client":Kclient,@"userId":[NSString stringWithFormat:@"%@",account.uiId],@"serverToken":account.reponseToken,@"headImage":self.iconUrl,@"name":self.userNameLabel.text,@"age":ageLast,@"sex":string,@"hobby":self.hopyLabel.text};

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self loadData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

#pragma mark - 数据提交成功的回调方法
//数据提交成功后回调方法
- (void)loadData:(NSDictionary *)dict{
    if ([dict[@"code"] isEqual:@(0)]) {
        [MBProgressHUD showSuccess:@"个人信息提交成功"];
        [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(backtoroot) userInfo:nil repeats:NO];
    }else if ([dict[@"code"] isEqual:KotherLogin]){
        [MBProgressHUD showError:@"您的账号信息有误,重新登录!"];
        [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(jumpToMyaccountVC) userInfo:nil repeats:NO];
    }else if([dict[@"code"] isEqual:@(-1)]){
        [MBProgressHUD showError:dict[@"msg"]];
    }
}

-(void)backtoroot{
    [self.navigationController popViewControllerAnimated:YES];
}

//单点登录
-(void)jumpToMyaccountVC{
    Account * account2 = [AccountTool account];
    if (account2) {
        //实现当前用户注销（就是把 account.data文件清空）
        account2 = nil;
        [AccountTool saveAccount:account2];
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
        
    }
}


#pragma mark - 头像按钮点击事件
- (IBAction)iconBtnClick:(id)sender {
    [self addBlickBackViewWithTopTitle:@"拍照" andBottomTitle:@"从相册选取" andcancleTitle:@"取消" type:@"0"];
}
#pragma mark - 添加遮盖
- (void)addBlickBackViewWithTopTitle:(NSString *)topTitle andBottomTitle:(NSString *)bottomTitle andcancleTitle:(NSString *)cancleTitle type:(NSString *)type{
    //1.0添加半透明黑色遮盖
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight)];
    self.backBtn.backgroundColor = [UIColor blackColor];
    self.backBtn.alpha = 0.6f;
    [self.backBtn addTarget:self action:@selector(chosePhotoCancle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    //2.0添加选择View
    CGFloat margin = 30;
    CGFloat rowHight = 44;
    self.choiceView = [[UIView alloc]initWithFrame:CGRectMake(margin, kScreenheight-(3*rowHight + margin), kScreenWidth-2*margin, 2*rowHight)];
    self.choiceView.backgroundColor = [UIColor whiteColor];
    //2.1设置choiceView圆角
    self.choiceView.layer.cornerRadius = 5;
    self.choiceView.layer.masksToBounds = YES;
    self.choiceView.layer.borderWidth = 0.1;
    //2.2给choiceView添加子控件
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, rowHight-1, self.choiceView.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.choiceView addSubview:line];
    
    UIButton * topBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.choiceView.width, rowHight)];
    [topBtn setTitle:topTitle forState:UIControlStateNormal];
    [topBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    topBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    if ([type isEqualToString:@"0"]) {
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([type isEqualToString:@"1"]){
        [topBtn addTarget:self action:@selector(choiceManBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton * bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, rowHight, self.choiceView.width, rowHight)];
    [bottomBtn setTitle:bottomTitle forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    if ([type isEqualToString:@"0"]) {
        [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([type isEqualToString:@"1"]){
        [bottomBtn addTarget:self action:@selector(choiceWomanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.choiceView addSubview:topBtn];
    [self.choiceView addSubview:bottomBtn];
    //3.0添加取消选择View
    self.cancleChoiceView = [[UIView alloc]initWithFrame:CGRectMake(margin, kScreenheight-(rowHight+(margin/2)), kScreenWidth-2*margin, rowHight)];
    self.cancleChoiceView.backgroundColor = [UIColor whiteColor];
    //3.1设置cancleChoiceView圆角
    self.cancleChoiceView.layer.cornerRadius = 5;
    self.cancleChoiceView.layer.masksToBounds = YES;
    self.cancleChoiceView.layer.borderWidth = 0.1;
    //3.2给cancleChoiceView添加子控件
    UIButton * cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.cancleChoiceView.width, rowHight)];
    [cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    if ([type isEqualToString:@"0"]) {
        [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([type isEqualToString:@"1"]){
        [cancleBtn addTarget:self action:@selector(cancleChoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.cancleChoiceView addSubview:cancleBtn];
    //4.0添加两个选择View
    [self.view insertSubview:self.choiceView aboveSubview:self.backBtn];
    [self.view insertSubview:self.cancleChoiceView aboveSubview:self.backBtn];

}
-(void)chosePhotoCancle:(UIButton *)btn{
    [btn removeFromSuperview];
    [self.ageChoiceBackView removeFromSuperview];
    [self.choiceView removeFromSuperview];
    [self.cancleChoiceView removeFromSuperview];
}
#pragma mark - 选取获得照片路径
//touxiang顶部选择按钮点击事件
-(void)topBtnClick:(UIButton *)btn{
    //1.是否调取相机
    self.alter1 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否允许访问您的摄像头" delegate:self cancelButtonTitle:@"不允许" otherButtonTitles:@"允许", nil];
    self.alter1.delegate = self;
    [_alter1 show];
    
}
//touxiang底部选择按钮点击事件
-(void)bottomBtnClick:(UIButton *)btn{
    //1.是否调取相册
    self.alter2 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否允许访问您的相册" delegate:self cancelButtonTitle:@"不允许" otherButtonTitles:@"允许", nil];
    self.alter2.delegate = self;
    [_alter2 show];
    
}
//touxiang取消选择按钮点击事件
-(void)cancleBtnClick:(UIButton *)btn{
    [self.backBtn removeFromSuperview];
    [self.choiceView removeFromSuperview];
    [self.cancleChoiceView removeFromSuperview];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            if ([alertView isEqual:self.alter1]) {//相机
                
            }else if([alertView isEqual:self.alter2]){//相册
                
            }
            //去掉遮盖
            [self.backBtn removeFromSuperview];
            [self.choiceView removeFromSuperview];
            [self.cancleChoiceView removeFromSuperview];
            break;
        case 1:
            if ([alertView isEqual:self.alter1]) {//相机
                _imagePick.sourceType =UIImagePickerControllerSourceTypeCamera;
                _imagePick.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
                _imagePick.allowsEditing = YES;
                [self presentViewController:_imagePick animated:YES completion:nil];
                
            }else if([alertView isEqual:self.alter2]){//相册
                //调出相册
                
                _imagePick.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
                _imagePick.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
                _imagePick.allowsEditing = YES;
                [self presentViewController:_imagePick animated:YES completion:nil];
            }
            //去掉遮盖
            [self.backBtn removeFromSuperview];
            [self.choiceView removeFromSuperview];
            [self.cancleChoiceView removeFromSuperview];
            break;
            
        default:
            break;
    }
}

#pragma mark - 头像从照片库中选择结束后要调用的代理方法
//从相册选择图片后操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
    //保存原始图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.iconBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    image = [self imageWithImageSimple:image scaledToSize:CGSizeMake(kScreenWidth/4, kScreenheight/4)];
    
    [self saveImage:image withName:@"currentImage.png"];
}

//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

//保存图片
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData* imageData = [[NSData alloc]init];
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(currentImage)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(currentImage);
    }else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(currentImage, 1.0);
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    [imageData writeToFile:fullPathToFile atomically:NO];    
    
    [self upDataImageWithImage:currentImage data:imageData];
}

//上传图片
- (void)upDataImageWithImage:(UIImage *)image data:(NSData *)data{
    
    NSString * str = kUserSendIconImgStr;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager POST:str parameters:nil  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) { // 一定要在这里拼接文件数据参数
        // 获得文件的二进制数据(NSData)
        [formData appendPartWithFileData:data name:@"headImage" fileName:@"my.png" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) { // 请求成功后会调用
        if ([responseObject[@"code"] isEqual:@(0)]) {
            NSString * imgUrl = responseObject[@"data"][0][@"url"];
            self.iconUrl = responseObject[@"data"][0][@"url"];
            [self setIconImge];
            if (imgUrl.length == 0) {
                [MBProgressHUD showError:@"头像获取失败!"];
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { // 请求失败后会调用
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
}
#pragma mark - 设置头像图片
-(void)setIconImge{
    [self.iconBtn setBackgroundImage:nil forState:UIControlStateNormal];
    //清理旧图片数据
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    //设置新图片数据
    [self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon-me"]];
    [[NSUserDefaults standardUserDefaults]setObject:self.iconUrl forKey:@"iconUrl"];
}

//取消图片设置操作时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}



#pragma mark - 选择男女的途径
-(void)choiceManBtnClick:(UIButton *)btn{
    self.sexLabel.text = @"男";
    [[NSUserDefaults standardUserDefaults]setObject:@"男" forKey:@"sex"];
    self.sexStr = @"1";
    [self.backBtn removeFromSuperview];
    [self.choiceView removeFromSuperview];
    [self.cancleChoiceView removeFromSuperview];
}
-(void)choiceWomanBtnClick:(UIButton *)btn{
    self.sexLabel.text = @"女";
    self.sexStr = @"0";
    [[NSUserDefaults standardUserDefaults]setObject:@"女" forKey:@"sex"];
    [self.backBtn removeFromSuperview];
    [self.choiceView removeFromSuperview];
    [self.cancleChoiceView removeFromSuperview];
}
-(void)cancleChoiceBtnClick:(UIButton *)btn{
    [self.backBtn removeFromSuperview];
    [self.choiceView removeFromSuperview];
    [self.cancleChoiceView removeFromSuperview];
}


#pragma mark - 用户昵称点击事件
- (IBAction)userNameBtnClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    fixUserNameVC * vc = [sb instantiateViewControllerWithIdentifier:@"fixUserNameVC"];
    vc.userName = self.userNameLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 性别按钮点击事件
- (IBAction)sexBtnClick:(id)sender {
    [self addBlickBackViewWithTopTitle:@"男" andBottomTitle:@"女" andcancleTitle:@"取消" type:@"1"];
}

#pragma mark - 年龄按钮点击事件
- (IBAction)ageBtnClick:(id)sender {
    //1.添加背景
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight)];
    self.backBtn.backgroundColor = [UIColor blackColor];
    self.backBtn.alpha = 0.6f;
    [self.backBtn addTarget:self action:@selector(chosePhotoCancle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    self.ageChoiceBackView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenheight-254, kScreenWidth, 254)];
    self.ageChoiceBackView.backgroundColor = [UIColor whiteColor];

    //2.添加选择和取消按钮
    //2.1 取消
    UIButton * cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 80, 44)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [self.ageChoiceBackView addSubview:cancleBtn];

    //2.2 选择
    UIButton * okBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.ageChoiceBackView.width-90, 10, 80, 44)];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(OK) forControlEvents:UIControlEventTouchUpInside];
    [self.ageChoiceBackView addSubview:okBtn];
    
    //3.添加pickView
    //设置pickView
    self.agePick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 200)];
    self.agePick.dataSource = self;
    self.agePick.delegate = self;
    [self.ageChoiceBackView addSubview:self.agePick];
    
    //4.添加到self.View上
    [self.view addSubview:self.ageChoiceBackView];
}
#pragma mark - ok
-(void)OK{
    [self.backBtn removeFromSuperview];
    [self.ageChoiceBackView removeFromSuperview];
}
#pragma mark - cancle
-(void)cancle{
    [self.backBtn removeFromSuperview];
    [self.ageChoiceBackView removeFromSuperview];
}

#pragma mark - pickView的数据源方法和代理方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.ages.count?self.ages.count:0;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.agePick.width, 37)];
    pickLabel.textAlignment = NSTextAlignmentCenter;
    pickLabel.text = self.ages[row];
    pickLabel.textColor = [UIColor blackColor];
    pickLabel.font = [UIFont systemFontOfSize:15];
    
    return pickLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.ageLabel.text = self.ages[row];//显示用

    [[NSUserDefaults standardUserDefaults] setObject:self.ages[row] forKey:@"myAge"];
    
    self.ageStr = self.ageStrs[row];//上传用
}


#pragma mark - 爱好按钮点击事件
- (IBAction)hopyBtnClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"hopyVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 懒加载
-(NSMutableArray *)ages{
    if (_ages == nil) {
        self.ages = [[NSMutableArray alloc]init];
        self.ageStrs = [[NSMutableArray alloc]init];
        for (int i = 18; i < 100; i++) {
            [self.ages addObject:[NSString stringWithFormat:@"%d岁",i]];
            [self.ageStrs addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _ages;
}

@end
