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
#import "getNoFriendVC.h"
#import "getManyFriendsVC.h"


@interface getMyFriendsVC ()

@property (weak, nonatomic) IBOutlet UILabel *friendsNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *getFriendBtn;

@property (weak, nonatomic) IBOutlet UIImageView *QRImgView;

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
        DebugLog(@"无明细可查");
        getNoFriendVC * vc = [[getNoFriendVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
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
    self.friendsNumLabel.text = @"1";
}



@end
