//
//  yaogouRockVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/6.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "yaogouRockVC.h"
#import "homeNewScuessModel.h"
#import "moneyImgAndLabel.h"
#import "myAccountVC.h"
#import "Account.h"
#import "AccountTool.h"
#import "XLAudioTool.h"
#import <AVFoundation/AVFoundation.h>
#import "XLPlaysound.h"
#import "YGRockModel.h"
#import "addLuckNumCell.h"

#define kmagin 15.0f

@interface yaogouRockVC ()<UITextFieldDelegate,UIAccelerometerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) UILabel * topLabel;
@property (nonatomic , strong) UIView * imgBackView;
@property (nonatomic , strong) UIImageView * headImgV;
@property (nonatomic , strong) UIImageView * centerImgV;
@property (nonatomic , strong) UILabel * zsLabel;
@property (nonatomic , strong) UITextField * textField;
@property (nonatomic , strong) UIView * fieldBackView;
@property (nonatomic , strong) UIButton * btn;

@property (nonatomic , copy) NSString * on;

@property (nonatomic , copy) NSString * ip;
@property (nonatomic , copy) NSString * cityName;




@property (nonatomic , strong) UIView * smallView;
@property (nonatomic , strong) UIButton * xiaX;

@property (nonatomic , strong) NSMutableArray * codesArray;
@property (nonatomic , strong) UICollectionView * collView;


@end

@implementation yaogouRockVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"摇购";
    self.view.backgroundColor = YKYColor(247, 237, 240);
    [self setLeft];
    [self setright];
    [self addView];

}




#pragma mark - 设置leftItem
-(void)setright{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"充值" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = left;
}
-(void)rightClick{
    DebugLog(@"充值");
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"newChargeDetailVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    // 设置陀螺仪
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer]; // 实例对象
    accelerometer.delegate = self; // 设置代理为本身控制器
    accelerometer.updateInterval = 0.1; // 设置传感器更新数据的时间间隔
    [self.view becomeFirstResponder]; // 窗口对象作为第一响应者运动事件
    //晃动标志
    self.isRocking = @"0";
    //音效开关标志
    self.on = @"1";
    //判断用户IP是否已拿到,如果没有拿到就重新请求网络获取用户IP
    [self userIpIsHaveOrNo];
}
-(void)userIpIsHaveOrNo{
    NSString * ip = [[NSUserDefaults standardUserDefaults]objectForKey:@"userIP"];
//    NSString * userCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"userCity"];
    if (!ip || [ip isEqualToString:@""] || [ip isKindOfClass:[NSNull class]] ) {
        [getIpVC getUserIp];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 取消传感器，也就是设置代理为空
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}
#pragma mark - 设置leftItem
-(void)setLeft{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"jiantou-Left"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)leftClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)addView{

    [self addTop];

    [self addImgV];

    [self addRedBack];

    [self addbottomField];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

-(void)addTop{
    self.topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,kmagin+64, kScreenWidth, 15)];
    [self toplableSetTextWithShengNumStr:_model.shengNum andPlimitStr:_model.plimit];
    [self.view addSubview:self.topLabel];
}
-(void)toplableSetTextWithShengNumStr:(NSString*)shengStr andPlimitStr:(NSString*)plimitStr{
    DebugLog(@"pli=%@",plimitStr);
    NSString * str1 = [NSString stringWithFormat:@"总需摇购:%@次    剩余:",_model.zongNum];
    NSString *red1 = [NSString stringWithFormat:@"<font size=\"4\" color=\"red\">%@</font>",shengStr];
    NSString * str2 = @"次 ";
    NSString * str3 = @"(每人限摇";
    NSString * red2 = [NSString stringWithFormat:@"<font size=\"4\" color=\"red\">%@</font>",plimitStr];
    NSString * str4 = @"次)";
    NSString * noPlimit = [NSString stringWithFormat:@"%@%@%@%@%@%@",str1,red1,str2,str3,red2,str4];

    NSString * plimit = [NSString stringWithFormat:@"%@%@%@",str1,red1,str2];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[noPlimit dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    NSAttributedString * attrStr2 = [[NSAttributedString alloc] initWithData:[plimit dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    if (![plimitStr isEqualToString:@"0"]) {
        self.topLabel.attributedText = attrStr;
    }else{
        self.topLabel.attributedText = attrStr2;
    }
    self.topLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
}
-(void)addImgV{
    CGFloat w = 0.3*kScreenWidth;
    CGFloat h = 0.25*kScreenWidth;
    self.imgBackView = [[UIView alloc]initWithFrame:CGRectMake(0.5*(kScreenWidth-w), self.topLabel.y+self.topLabel.height+kmagin, w, h)];
    self.imgBackView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.imgBackView];

    UIView * whitView = [[UIView alloc]initWithFrame:CGRectMake(1, 1, w-2, h-2)];
    whitView.backgroundColor = [UIColor whiteColor];
    [self.imgBackView addSubview:whitView];

    self.headImgV = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, w-8, h-8)];
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:_model.url] placeholderImage:[UIImage imageNamed:@"prepareloading_small"]];
    [self.imgBackView addSubview:self.headImgV];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight)];
    self.btn.backgroundColor = [UIColor blackColor];
    self.btn.alpha = 0.5;
    [self.btn addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.btn belowSubview:self.fieldBackView];

    return YES;
}
-(void)dissMiss{
    [self.textField resignFirstResponder];
    [self.btn removeFromSuperview];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self dissMiss];
    return YES;
}
-(void)addRedBack{
    UIImageView * redback = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.imgBackView.y+0.6*self.imgBackView.height, kScreenWidth, kScreenheight-(self.imgBackView.y+0.5*self.imgBackView.height))];
    redback.image = [UIImage imageNamed:@"摇购背景"];
    [self.view addSubview:redback];


    CGFloat w = 0.7*kScreenWidth;
    CGFloat h = 0.55*kScreenWidth;
    self.centerImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0.5*(kScreenWidth-w), 0.5*(kScreenheight-h)+3*kmagin, w, h)];
    self.centerImgV.image = [UIImage imageNamed:@"摇购手势图"];
    [self.view addSubview:self.centerImgV];

    CGFloat zsBackW = 150;
    CGFloat zsBackH = 100;
    self.zsLabel = [moneyImgAndLabel SHUaddjinyinImagAndlabelBackViewWithFrame:CGRectMake(0.5*(kScreenWidth-zsBackW), self.centerImgV.y+self.centerImgV.height-2*kmagin, zsBackW, zsBackH) ImgName:@"zuanshi-me" imgW:22 imgH:22 backView:self.view  titleColor:[UIColor whiteColor]];
    if ([AccountTool account]) {
        self.zsLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"diamonds"]];
    }else{
        self.zsLabel.text = @"0";
    }

}
-(void)addbottomField{
    CGFloat w = 0.33*kScreenWidth;
    CGFloat h = 25;
    if (iPhone6plus) {
        h = 30;
    }if (iPhone6) {
        h = 28;
    }
    self.fieldBackView = [[UIView alloc]initWithFrame:CGRectMake(0.5*(kScreenWidth-w), self.centerImgV.y+self.centerImgV.height+6*kmagin, w, h)];
    self.fieldBackView.backgroundColor = YKYClearColor;
    [self.view addSubview:self.fieldBackView];
    UIImageView * backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.fieldBackView.width, h)];
    backImg.image = [UIImage imageNamed:@"加减"];
    [self.fieldBackView addSubview:backImg];


    UIButton * jianBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0.2*self.fieldBackView.width, h)];
    jianBtn.backgroundColor = YKYClearColor;
    [jianBtn addTarget:self action:@selector(jian) forControlEvents:UIControlEventTouchUpInside];
    [self.fieldBackView addSubview:jianBtn];


    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(jianBtn.width, 0, self.fieldBackView.width-2*jianBtn.width, h)];
    self.textField.font = [UIFont systemFontOfSize:12];
    if (iPhone6plus) {
        self.textField.font = [UIFont systemFontOfSize:14];
    }
    self.textField.textColor = [UIColor whiteColor];
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.text = @"1";
    self.textField.delegate = self;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.fieldBackView addSubview:self.textField];

    UIButton *jiaBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.fieldBackView.width-jianBtn.width, 0, jianBtn.width, h)];
    jiaBtn.backgroundColor = YKYClearColor;
    [jiaBtn addTarget:self action:@selector(jia) forControlEvents:UIControlEventTouchUpInside];
    [self.fieldBackView addSubview:jiaBtn];


}
-(void)jian{
    DebugLog(@"减");
    int num = 1;
    num = [self.textField.text intValue];
    if (num>1) {
        num = num-1;
    }else if (num < 1){
        num = 1;
        [MBProgressHUD showError:@"摇奖次数不能小于\"1\""];
    }
    if (num == 0) {
        num = 1;
    }
    self.textField.text = [NSString stringWithFormat:@"%d",num];
}
-(void)jia{
    DebugLog(@"加");
    int num = 1;
    num = [self.textField.text intValue];
    if (num>0) {
        num = num+1;
    }
    if (![_model.plimit isEqualToString:@"0"]) {
        int pliNum = [_model.plimit intValue];
        if (num > pliNum) {
            num = pliNum;
            [MBProgressHUD showError:[NSString stringWithFormat:@"仅限购%@次哦",_model.plimit]];
        }
    }
    if (num>[_model.shengNum intValue]) {
        [MBProgressHUD showError:@"购买次数不能大于剩余次数!"];
        num = [_model.shengNum intValue];
    }

    if (num>9999) {
        [MBProgressHUD showError:@"亲~摇购次数不能大于1万哦!"];
        num = 9999;
    }

    if (num == 0) {
        num = 1;
    }

    self.textField.text = [NSString stringWithFormat:@"%d",num];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField) {
        if (textField.text.length > 4){
            [MBProgressHUD showError:@"亲~摇购次数不能大于1万哦!"];
            return NO;
        }
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    int num = [textField.text intValue];
    if (num>[_model.shengNum intValue]) {
        [MBProgressHUD showError:@"购买次数不能大于剩余次数!"];
        num = [_model.shengNum intValue];
    }
    if (num<1) {
        [MBProgressHUD showError:@"摇购次数不能小于1哦!"];
        num = 1;
    }

    if (num>[_model.plimit intValue] && [_model.plimit intValue] != 0) {
        [MBProgressHUD showError:@"购买次数不能大于限购次数!"];
        num = [_model.plimit intValue];
    }
    if (num>9999) {
        num = 9999;
    }
    if (num == 0) {
        num = 1;
    }
    self.textField.text = [NSString stringWithFormat:@"%d",num];
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
//    self.self.fieldBackView.frame = CGRectMake(15, kScreenheight-55-keyboardRect.size.height, kScreenWidth-30, 40);
    self.fieldBackView.frame = CGRectMake(0.5*(kScreenWidth-0.33*kScreenWidth), self.centerImgV.y+self.centerImgV.height+7*kmagin-keyboardRect.size.height, 0.33*kScreenWidth, 20);


}
- (void)keyboardWillHide:(NSNotification *)notification{
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    //    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
    self.self.fieldBackView.frame = CGRectMake(0.5*(kScreenWidth-0.33*kScreenWidth), self.centerImgV.y+self.centerImgV.height+6*kmagin, 0.33*kScreenWidth, 20);
}




// 用加速计侦测手机的晃动事件，需要在收到重力加速计的数据后做一些复杂的数学运算才能很好的实现，但是，UIResponder给我们提供了方法，已经帮我们完成了计算，我们只需使用下面的接口：
#pragma mark 重写----手机开始晃动时调用
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    Account *account = [AccountTool account];
    if (account == nil) {
        [MBProgressHUD showError:@"账号信息有误,请重新登录!"];
        [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(jumpToMyAccountVC) userInfo:nil repeats:NO];
        return;
    }

    NSString * isdiss = [[NSUserDefaults standardUserDefaults]objectForKey:@"isDissMiss"];
    if ([isdiss isEqualToString:@"1"]) {
        self.isRocking = @"0";
    }

    if (![self.isRocking isEqualToString:@"0"] ) {
        return;
    }
    //取出保存的开关标示
    self.on = [[NSUserDefaults standardUserDefaults]objectForKey:@"on"];
    if ([self.on isEqualToString:@"1"] || self.on.length == 0) {
        //播放声音
        [XLAudioTool playSound:@"rock_music.mp3"];
    }

    NSString *str = @"/yshake";
    NSString * agentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentAgentId"];
    if (!agentId) {
        agentId = @"43";
    }

    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];

    NSString * ip = [[NSUserDefaults standardUserDefaults]objectForKey:@"userIP"];
    NSString * userCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"userCity"];

    [parameter setValue:_model.agentId forKey:@"agentId"];
//    [parameter setValue:_model.pid forKey:@"pId"];
//    [parameter setValue:_model.zongNum forKey:@"moneyCount"];
//    [parameter setValue:_model.perNum forKey:@"serial"];
    [parameter setValue:self.textField.text forKey:@"times"];
//    [parameter setValue:_model.plimit forKey:@"limit"];
    [parameter setValue:[ip stringByAppendingString:[NSString stringWithFormat:@" %@",userCity]] forKey:@"ipAddress"];
    [parameter setValue:_model.serialId forKey:@"serialId"];


    [MBProgressHUD showMessage:@"正在出奖..." toView:self.view];
    [XLRequest AFPostHost:kbaseURL bindPath:str postParam:parameter isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"摇购结果=%@",responseDic);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseDic[@"code"] isEqual:@0]) {
            NSDictionary * dict = responseDic[@"data"][0];
            YGRockModel *Ygmodel = [YGRockModel modelWithDict:dict];
            [self toplableSetTextWithShengNumStr:Ygmodel.restNum andPlimitStr:_model.plimit];
            self.zsLabel.text = Ygmodel.diamonds;
            self.textField.text = @"1";
            self.model.shengNum = [NSString stringWithFormat:@"%@",Ygmodel.restNum];

            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"isDissMiss"];
            //未摇奖状态
            [self addSmallViewWithModel:Ygmodel];//弹窗//未摇奖状态下添加奖品提示图
            //保存新的钻石数
            self.zsLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"data"][0][@"diamonds"]];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",responseDic[@"data"][0][@"diamonds"]] forKey:@"diamonds"];


            if ([self.on isEqualToString:@"1"] || self.on.length == 0) {//音效开关开状态
                [XLAudioTool playSound:@"grade_2.mp3"];
            }
            self.isRocking = @"1";
        }else if ([responseDic[@"code"] isEqual:KotherLogin]){
            [self jumpToMyAccountVC];
        }else{
            [MBProgressHUD showError:responseDic[@"msg"]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络状况不好,请稍后再试!"];
    }];
}


-(void)addSmallViewWithModel:(YGRockModel*)model{
//    [addLuckNumView addSmallViewWithModel:model.uno VC:self toView:self.view];
    self.codesArray = [NSMutableArray arrayWithArray:model.uno];
    [self showWithArray:model.uno];
}


-(void)jumpToMyAccountVC{
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








-(void)showWithArray:(NSArray*)array{

    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight)];
    _btn.backgroundColor = [UIColor blackColor];
    _btn.alpha = 0.6;
    [_btn addTarget:self action:@selector(dissMess) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];

    self.smallView = [[UIView alloc]initWithFrame:CGRectMake(0.15*kScreenWidth, 0.3*kScreenheight, 0.7*kScreenWidth, 0.4*kScreenheight)];
    self.smallView.backgroundColor = [UIColor whiteColor];
    //设置图片圆角
    self.smallView.layer.cornerRadius = 5;
    self.smallView.layer.masksToBounds = YES;
    self.smallView.layer.borderWidth = 0.01;
    [self.view addSubview:self.smallView];


    self.xiaX = [[UIButton alloc]initWithFrame:CGRectMake(_smallView.x+self.smallView.width-30, self.smallView.y-35, 30, 30)];
    [self.xiaX setBackgroundImage:[UIImage imageNamed:@"xiaochazi"] forState:UIControlStateNormal];
    [self.xiaX addTarget:self action:@selector(dissMess) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.xiaX];


    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.smallView.width, 30)];
    title.text = @"我的摇码";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = YKYTitleColor;
    title.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    [self.smallView addSubview:title];
    [line addLineWithFrame:CGRectMake(0, 30, kScreenWidth, 1) andBackView:self.smallView];

    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, self.smallView.width, self.smallView.height-40) collectionViewLayout:layout];
    self.collView.delegate = self;
    self.collView.dataSource = self;
    self.collView.backgroundColor = [UIColor whiteColor];
    //该方法设置itemSize
    layout.itemSize =CGSizeMake((self.smallView.width-3)/2, 40);
    [self.smallView addSubview:self.collView];
    [self.collView registerNib:[UINib nibWithNibName:@"addLuckNumCell" bundle:nil] forCellWithReuseIdentifier:@"addLuckNumCell"];

    [self.collView reloadData];

}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _codesArray.count?_codesArray.count:0;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    addLuckNumCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addLuckNumCell" forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[addLuckNumCell alloc]init];
    }
    int luckCo = [self.codesArray[indexPath.item] intValue] + 10000000;

    cell.titleStrLabel.text = [NSString stringWithFormat:@"%d",luckCo];

    return cell;
}

#pragma mark - delegate
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.smallView.width-3)/2, 40);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

-(void)dissMess{
    self.isRocking = @"0";
    [_btn removeFromSuperview];
    [_smallView removeFromSuperview];
    [_xiaX removeFromSuperview];
}





@end
