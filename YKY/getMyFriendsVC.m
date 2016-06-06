//
//  getMyFriendsVC.m
//  YKY
//
//  Created by 肖 亮 on 16/5/31.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "getMyFriendsVC.h"
#import "sharToFrend.h"
#import "Account.h"
#import "AccountTool.h"
#import "getManyFriendsVC.h"
#import "XLQRCode.h"

#define kBottomMagin 15

@interface getMyFriendsVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *friendsNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *getFriendBtn;

@property (weak, nonatomic) IBOutlet UIImageView *QRImgView;



@property (weak, nonatomic) IBOutlet UILabel *getedL;
@property (weak, nonatomic) IBOutlet UILabel *renL;
@property (weak, nonatomic) IBOutlet UIButton *lookDetailBtn;


@property (weak, nonatomic) IBOutlet UILabel *getNoFirendTopL;
@property (weak, nonatomic) IBOutlet UILabel *getNoFirendBottomL;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;
@property (nonatomic) CGFloat bottomY;
@property (weak, nonatomic) IBOutlet UIView *bottomBackView;
@property (nonatomic , strong) UIButton * btn;



@end

@implementation getMyFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    self.nameField.delegate = self;
    [self setLeft];

    //设置图片圆角
    self.getFriendBtn.layer.cornerRadius = 5;
    self.getFriendBtn.layer.masksToBounds = YES;
    self.getFriendBtn.layer.borderWidth = 0.01;

    [self loadData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nameField resignFirstResponder];

}

#pragma mark - 设置leftItem
-(void)setLeft{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"jiantou-Left"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    DebugLog(@"=====self.bottomLayout.constant===%f",self.bottomLayout.constant);
    if ((int)self.bottomLayout.constant != kBottomMagin) {
        return;
    }

    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight)];
    self.btn.backgroundColor = [UIColor blackColor];
    self.btn.alpha = 0.5;
    [self.btn addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.btn belowSubview:self.bottomBackView];

    self.bottomLayout.constant = self.bottomLayout.constant+keyboardRect.size.height;
    self.bottomY = keyboardRect.size.height;
}

-(void)diss{
    [self.nameField resignFirstResponder];
    [self.btn removeFromSuperview];

}

- (void)keyboardWillHide:(NSNotification *)notification{
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self.btn removeFromSuperview];

    if ((int)self.bottomLayout.constant != (int)self.bottomY+kBottomMagin) {
        return;
    }

    self.bottomLayout.constant = self.bottomLayout.constant-self.bottomY;
}


#pragma mark - 查看明细按钮点击事件
- (IBAction)lookDetailBtnClick:(id)sender {
    if ([self.friendsNumLabel.text isEqualToString:@"0"]) {
//        DebugLog(@"无明细可查");
//        getNoFriendVC * vc = [[getNoFriendVC alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
    }else{
        DebugLog(@"很多明细");
        getManyFriendsVC * vc = [[getManyFriendsVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 速去推荐好友按钮点击事件
- (IBAction)getFriendBtnClick:(id)sender {
    DebugLog(@"推荐好友按钮点击");
    UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"提示:" message:@"先输入您的名字,让好友知道是您推荐的哦!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    NSString * name = [self.nameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    if (name == 0) {
        [alter show];
        return;
    }else if (name.length < 2){
        [MBProgressHUD showError:@"您的名字输入太少了!"];
        return;
    }else if (name.length > 6){
        [MBProgressHUD showError:@"您的名字输入太长了!"];
        return;
    }else{
        [self diss];
    }

    Account * account = [AccountTool account];
    NSString * tit = [NSString stringWithFormat:@"您的好友 【\"%@\"】 邀您一起来玩 *一块摇* 惊喜不断。注册后你也可以分享给自己的好友，送钱就是这么任性",self.nameField.text];

    NSString * codeStr = [NSString stringWithFormat:@"%@/zhuce.jsp?para=%@",kbaseURL,account.uiId];
    DebugLog(@"=====%@",codeStr);
    [sharToFrend shareWithUrl:codeStr title:tit name:name andQRImage:self.QRImgView.image  phone:account.uiId andVC:self];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self diss];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (self.nameField.text.length < 2) {
        [MBProgressHUD showError:@"名字不能少于2个字符哦~"];
    }
    if (self.nameField.text.length > 6) {
        [MBProgressHUD showError:@"输入名字不能过长哦~"];
    }
    return YES;
}



#pragma mark - 获取界面信息
-(void)loadData{
    self.friendsNumLabel.text = @"0";
    Account * account = [AccountTool account];

    //设置我的邀请二维码
    NSString * codeStr = [NSString stringWithFormat:@"%@/zhuce.jsp?para=%@",kbaseURL,account.uiId];
//    DebugLog(@"====codeStr=%@",codeStr);
//    XLQRCode * code = [[XLQRCode alloc]init];
//    code.codeStr = codeStr;
//    code.imgView = self.QRImgView;
//    [code getQRCode];
    [HGDQQRCodeView creatQRCodeWithURLString:codeStr superView:self.QRImgView logoImage:[UIImage imageNamed:@"一块摇4"] logoImageSize:CGSizeMake(40, 40) logoImageWithCornerRadius:5];



    if (!account) {
        [MBProgressHUD showError:@"账号信息有误,请重新登录!"];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(jumpToMyaccountVC) userInfo:nil repeats:NO];
        return;
    }

    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    NSString * bindPath =  @"/user/iniviteCount";

    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [parameter setObject:account.phone forKey:@"userPhone"];

    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameter isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"获取推荐好友数量==%@",responseDic);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseDic[@"code"] isEqual:@0]) {
            self.friendsNumLabel.text = responseDic[@"msg"];
            if ([self.friendsNumLabel.text isEqualToString:@"0"]) {
                self.friendsNumLabel.hidden = YES;
                self.getedL.hidden = YES;
                self.lookDetailBtn.hidden = YES;
                self.renL.hidden = YES;
                self.getNoFirendTopL.hidden = NO;
                self.getNoFirendBottomL.hidden = NO;
            }else{
                self.friendsNumLabel.hidden = NO;
                self.getedL.hidden = NO;
                self.lookDetailBtn.hidden = NO;
                self.renL.hidden = NO;
                self.getNoFirendTopL.hidden = YES;
                self.getNoFirendBottomL.hidden = YES;
            }
        }else if ([responseDic[@"code"] isEqual:KotherLogin]){
            [MBProgressHUD showError:@"账号信息有误,请重新登录!"];
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(jumpToMyaccountVC) userInfo:nil repeats:NO];
        }else{
            [MBProgressHUD showError:@"网络连接失败,请稍后再试!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请稍后再试!"];
    }];
}



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
    }else{
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



@end
