//
//  meJinzhuanZuanVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/15.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meJinzhuanZuanVC.h"
#import "Account.h"
#import "AccountTool.h"

@interface meJinzhuanZuanVC ()<UITextFieldDelegate>

@property (nonatomic , strong) UIView * topView;
@property (nonatomic , strong) UILabel * zuanNumLabel;
@property (nonatomic , strong) UILabel * jinNumLabel;
@property (nonatomic) int duihuanZuanshiNum;
@property (nonatomic) int jinbiNum;
@property (nonatomic , strong) UITextField * zuField;
@property (nonatomic , strong) UILabel * leftLabel;
@property (nonatomic , strong) UIButton * duihuanBtn;


@end

@implementation meJinzhuanZuanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"金币转钻石";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeft];
    [self addView];
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

#pragma mark - 添加控件
-(void)addView{

    [self addTop];

    [self addMidView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)addTop{
    CGFloat h = 50;
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenheight, h)];
    [self.view addSubview:_topView];

    CGFloat magin = 15;
    CGFloat H = 20;
    CGFloat w = (kScreenWidth-2*magin)/2;
    self.zuanNumLabel = [moneyImgAndLabel addjinyinImagAndlabelBackViewWithFrame:CGRectMake(magin, 0.5*(h-H), w, H) ImgName:@"zuanshi-me" imgW:23 imgH:22 backView:_topView];
    self.zuanNumLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"diamonds"]];

    self.jinNumLabel = [moneyImgAndLabel addjinyinImagAndlabelBackViewWithFrame:CGRectMake(magin+w, 0.5*(h-H), w, H) ImgName:@"jinbi-me" imgW:23 imgH:20 backView:_topView];
    self.jinNumLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"gold"]];
    self.jinbiNum = [[[NSUserDefaults standardUserDefaults]objectForKey:@"gold"] intValue];
//    self.jinbiNum = 223;

    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _topView.y+_topView.height, kScreenWidth, 10)];
    line1.backgroundColor = YKYColor(242, 242, 242);
    [self.view addSubview:line1];
    
}

-(void)addMidView{
    DebugLog(@"==%d==%d",self.jinbiNum,self.jinbiNum/100);

    self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _topView.y+_topView.height+40, 0.35*kScreenWidth-8, 20)];
    self.leftLabel.text = [NSString stringWithFormat:@"金币 %d=",self.jinbiNum];
    self.leftLabel.textColor = YKYColor(38, 38, 39);
    self.leftLabel.textAlignment = NSTextAlignmentRight;
    self.leftLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    [self.view addSubview:self.leftLabel];



    UIImageView * filBack = [[UIImageView alloc]initWithFrame:CGRectMake(self.leftLabel.x+self.leftLabel.width+4, self.leftLabel.y-6, 0.4*kScreenWidth, 30)];
    filBack.image = [UIImage imageNamed:@"金币转钻石框"];
    [self.view addSubview:filBack];
    self.zuField = [[UITextField alloc]initWithFrame:CGRectMake(self.leftLabel.x+self.leftLabel.width+8, self.leftLabel.y+1, 0.4*kScreenWidth-8, 20)];
    [self.zuField setBackground:[[UIImage alloc]init]];
    self.zuField.placeholder = [NSString stringWithFormat:@"最多兑换%d个钻石",self.jinbiNum/100];
    self.zuField.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    self.zuField.delegate = self;
    self.zuField.textColor = YKYColor(38, 38, 39);
    self.zuField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.zuField];


    UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(filBack.x+filBack.width+4, _leftLabel.y, 0.25*kScreenWidth-4, 20)];
    rightLabel.text = @"钻石";
    rightLabel.textAlignment = NSTextAlignmentLeft;
    rightLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    rightLabel.textColor = YKYColor(38, 38, 39);
    [self.view addSubview:rightLabel];


    UILabel * centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, filBack.y+filBack.height+10, kScreenWidth, 15)];
    centerLabel.text = @"注：100金币=1钻石";
    centerLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    centerLabel.textColor = YKYColor(249, 61, 66);
    centerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:centerLabel];


    self.duihuanBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, kScreenheight-55, kScreenWidth-30, 40)];
    [self.duihuanBtn setTitle:@"确认兑换" forState:UIControlStateNormal];
    self.duihuanBtn.backgroundColor = YKYColor(249, 61, 66);
    [self.duihuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.duihuanBtn.titleLabel.font = [UIFont boldSystemFontOfSize:[myFont getTitle2]];
    [self.duihuanBtn addTarget:self action:@selector(duihuanzuanshiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //设置图片圆角
    self.duihuanBtn.layer.cornerRadius = 5;
    self.duihuanBtn.layer.masksToBounds = YES;
    self.duihuanBtn.layer.borderWidth = 0.01;
    [self.view addSubview:self.duihuanBtn];

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.zuField resignFirstResponder];
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
    DebugLog(@"keyboardRect  %f:%f:%f:%f",keyboardRect.origin.x,keyboardRect.origin.y,keyboardRect.size.width,keyboardRect.size.height);
    DebugLog(@"animationDuration  %f",animationDuration);

    //    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
    self.duihuanBtn.frame = CGRectMake(15, kScreenheight-55-keyboardRect.size.height, kScreenWidth-30, 40);
    
}
- (void)keyboardWillHide:(NSNotification *)notification{
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    //    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
    self.duihuanBtn.frame = CGRectMake(15, kScreenheight-55, kScreenWidth-30, 40);
}




-(void)duihuanzuanshiBtnClick{
    DebugLog(@"确定兑换钻石");
    [self.zuField resignFirstResponder];
    int num = [self.zuField.text intValue];
    if (num > self.jinbiNum/100) {
        self.zuField.text = nil;
        [MBProgressHUD showError:@"亲~金币不够哦!"];
        return;
    }
    if (num == 0) {
        self.zuField.text = nil;
        [MBProgressHUD showError:@"转换钻石数必须大于0!"];
        return;
    }

    [MBProgressHUD showMessage:@"兑换中..." toView:self.view];
    NSString * bingPath = @"/yshakeCoupons/doGold2Diamond";

    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:@(num) forKey:@"number"];

    [XLRequest AFPostHost:kbaseURL bindPath:bingPath postParam:parameters isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DebugLog(@"金币兑换钻石结果=%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            [MBProgressHUD showSuccess:@"兑换成功!"];

            self.zuField.text = nil;
            self.zuField.placeholder = [NSString stringWithFormat:@"最多兑换%d个钻石",[[NSString stringWithFormat:@"%@",responseDic[@"data"][0][@"glod"]] intValue]/100];

            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",responseDic[@"data"][0][@"glod"]] forKey:@"gold"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",responseDic[@"data"][0][@"diamonds"]] forKey:@"diamonds"];

            self.zuanNumLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"data"][0][@"diamonds"]];
            self.jinNumLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"data"][0][@"glod"]];
            self.leftLabel.text = [NSString stringWithFormat:@"金币 %@=",responseDic[@"data"][0][@"glod"]];
        }else {
            [MBProgressHUD showError:@"兑换失败,请重试!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DebugLog(@"金币兑换钻石失败==error=%@===oper=%@",error,operation);
    }];

}


//单点登录
-(void)jumpToMyaccountVC{
    Account *account = [AccountTool account];
    if (account) {
        //实现当前用户注销（就是把 account.data文件清空）
        account = nil;
        [AccountTool saveAccount:account];

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
