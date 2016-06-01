//
//  getNoFriendVC.m
//  YKY
//
//  Created by 肖 亮 on 16/5/31.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "getNoFriendVC.h"
#import "sharToFrend.h"
#import "Account.h"
#import "AccountTool.h"

@interface getNoFriendVC ()

@property (weak, nonatomic) IBOutlet UIButton *getFriendBtn;


@end

@implementation getNoFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友明细";
    [self setLeft];

    //设置图片圆角
    self.getFriendBtn.layer.cornerRadius = 5;
    self.getFriendBtn.layer.masksToBounds = YES;
    self.getFriendBtn.layer.borderWidth = 0.01;
    
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

#pragma mark - 速去推荐好友按钮点击事件
- (IBAction)getFriendBtnClick:(id)sender {
    DebugLog(@"===去推荐好友");
    Account * account = [AccountTool account];

    [sharToFrend shareWithImgurl:nil andPid:nil phone:account.phone andVC:self];
}









@end
