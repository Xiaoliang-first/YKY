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


@interface getMyFriendsVC ()

@property (weak, nonatomic) IBOutlet UILabel *friendsNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *getFriendBtn;

@property (weak, nonatomic) IBOutlet UIImageView *QRImgView;



@property (weak, nonatomic) IBOutlet UILabel *getedL;
@property (weak, nonatomic) IBOutlet UILabel *renL;
@property (weak, nonatomic) IBOutlet UIButton *lookDetailBtn;


@property (weak, nonatomic) IBOutlet UILabel *getNoFirendTopL;
@property (weak, nonatomic) IBOutlet UILabel *getNoFirendBottomL;


@end

@implementation getMyFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    [self setLeft];

    //设置图片圆角
    self.getFriendBtn.layer.cornerRadius = 5;
    self.getFriendBtn.layer.masksToBounds = YES;
    self.getFriendBtn.layer.borderWidth = 0.01;

    [self loadData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
    Account * account = [AccountTool account];

    [sharToFrend shareWithImgurl:nil andPid:nil phone:account.phone andVC:self];
}




#pragma mark - 获取界面信息
-(void)loadData{
    self.friendsNumLabel.text = @"0";
    Account * account = [AccountTool account];
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


@end
