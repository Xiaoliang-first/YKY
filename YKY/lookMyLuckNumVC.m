//
//  lookMyLuckNumVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/22.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "lookMyLuckNumVC.h"
#import "homeMyYGLuckNumModel.h"
#import "homeMyYGLuckNumCell.h"
#import "homeNewScuessModel.h"
#import "Account.h"
#import "AccountTool.h"
#import "addLuckNumCell.h"


#define kmagin 15.0

@interface lookMyLuckNumVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) UIView * topBackView;
@property (nonatomic , strong) UIView * midBackView;
@property (nonatomic , strong) UILabel * pnameLabel;
@property (nonatomic , strong) UILabel * oderNumLabel;
@property (nonatomic , strong) UILabel * luckTimeLabel;
@property (nonatomic , strong) UILabel * luckNumLabel;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , strong) UILabel * joinCountLabel;

@property (nonatomic , strong) UIButton * btn;
@property (nonatomic , strong) UIView * smallView;
@property (nonatomic , strong) UIButton * xiaX;

@property (nonatomic , strong) NSMutableArray * codesArray;
@property (nonatomic , strong) UICollectionView * collView;


@end

@implementation lookMyLuckNumVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(NSMutableArray *)codesArray{
    if (_codesArray == nil) {
        self.codesArray = [[NSMutableArray alloc]init];
    }
    return _codesArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的该期摇码";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setLeft];
    [self addView];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookMyluckNums) name:@"lookMyLuckNum" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lookMyLuckNum" object:nil];
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

#pragma mark - 添加view
-(void)addView{
    [self addTopView];

    [self addmidView];

    [self addtableView];
}
#pragma mark - 添加顶部view
-(void)addTopView{
    CGFloat vMagin = 10;
    self.topBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 120)];
    self.topBackView.backgroundColor = YKYColor(247, 237, 240);
    [self.view addSubview:self.topBackView];

    self.pnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kmagin, kmagin, kScreenWidth-2*kmagin, 20)];
    self.pnameLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    self.pnameLabel.text = _prizemodel.pname;
    self.pnameLabel.textColor = YKYTitleColor;
    [self.topBackView addSubview:self.pnameLabel];

    UILabel * oderLabel = [[UILabel alloc]initWithFrame:CGRectMake(kmagin, self.pnameLabel.y+self.pnameLabel.height+vMagin, 40, 15)];
    oderLabel.textColor = YKYDeTitleColor;
    oderLabel.text = @"期号:";
    oderLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    [self.topBackView addSubview:oderLabel];

    self.oderNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(oderLabel.x+oderLabel.width, oderLabel.y, kScreenWidth-(oderLabel.x+oderLabel.y), 15)];
    self.oderNumLabel.textColor = YKYDeTitleColor;
    if (_serials) {
        self.oderNumLabel.text = [NSString stringWithFormat:@"第%@期",_serials];
    }else{
        self.oderNumLabel.text = [NSString stringWithFormat:@"第%@期",_prizemodel.serials];
    }
    self.oderNumLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    [self.topBackView addSubview:self.oderNumLabel];

    UILabel * luckLabel = [[UILabel alloc]initWithFrame:CGRectMake(kmagin, self.oderNumLabel.y+self.oderNumLabel.height+vMagin, 70, 15)];
    luckLabel.textColor = YKYDeTitleColor;
    luckLabel.text = @"揭晓时间:";
    luckLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    [self.topBackView addSubview:luckLabel];

    self.luckTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(luckLabel.x+luckLabel.width, luckLabel.y, kScreenWidth-(luckLabel.x+luckLabel.y), 15)];
    self.luckTimeLabel.textColor = YKYDeTitleColor;
    self.luckTimeLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    [self.topBackView addSubview:self.luckTimeLabel];


    UILabel * currentLuckLabel = [[UILabel alloc]initWithFrame:CGRectMake(kmagin, self.luckTimeLabel.y+self.luckTimeLabel.height+vMagin, 120, 15)];
    currentLuckLabel.textColor = YKYDeTitleColor;
    currentLuckLabel.text = @"本期摇购幸运码:";
    currentLuckLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    [self.topBackView addSubview:currentLuckLabel];

    self.luckNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(currentLuckLabel.x+currentLuckLabel.width, currentLuckLabel.y, kScreenWidth-(currentLuckLabel.x+currentLuckLabel.y), 15)];
    self.luckNumLabel.textColor = YKYDeTitleColor;
    self.luckNumLabel.text = _prizemodel.priNum;
    self.luckNumLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    [self.topBackView addSubview:self.luckNumLabel];
    DebugLog(@"-=-=-=%@----%@====ptime&=%p",_prizemodel.ptime,[_prizemodel.ptime class],_prizemodel.ptime);
    if (_prizemodel.ptime != NULL) {
        self.luckTimeLabel.text = _prizemodel.ptime;
    }else{
        self.luckTimeLabel.text = @"该期正在进行中";
        luckLabel.hidden = YES;
        currentLuckLabel.hidden = YES;
        self.luckNumLabel.hidden = YES;
        self.luckTimeLabel.frame = CGRectMake(luckLabel.x, luckLabel.y, kScreenWidth-(luckLabel.x+luckLabel.y), 15);
        self.topBackView.frame = CGRectMake(0, 64, kScreenWidth, 90);
    }
}


#pragma mark - 添加中部view
-(void)addmidView{
    self.midBackView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topBackView.y+self.topBackView.height+8, kScreenWidth, 80)];
    self.midBackView.backgroundColor = YKYClearColor;
    [self.view addSubview:self.midBackView];

    self.joinCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    self.joinCountLabel.text = @"以下是您该期全部摇购记录";
    self.joinCountLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    self.joinCountLabel.textAlignment = NSTextAlignmentCenter;
    self.joinCountLabel.textColor = YKYTitleColor;
    [self.midBackView addSubview:self.joinCountLabel];

    [line addLineWithFrame:CGRectMake(0, 39, kScreenWidth, 1) andBackView:self.midBackView];

    UILabel *left = [[UILabel alloc]initWithFrame:CGRectMake(3.5*kmagin, 40, 80, 40)];
    left.textColor = YKYTitleColor;
    left.textAlignment = NSTextAlignmentLeft;
    left.text = @"摇购时间";
    left.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    [self.midBackView addSubview:left];


    UILabel *center = [[UILabel alloc]initWithFrame:CGRectMake(0.63*(kScreenWidth-80), 40, 80, 40)];
    center.textColor = YKYTitleColor;
    center.textAlignment = NSTextAlignmentCenter;
    center.text = @"参与次数";
    center.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    [self.midBackView addSubview:center];


    UILabel *right = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-kmagin-90, 40, 80, 40)];
    right.textColor = YKYTitleColor;
    right.textAlignment = NSTextAlignmentRight;
    right.text = @"操作";
    right.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    [self.midBackView addSubview:right];

    [line addLineWithFrame:CGRectMake(0, 79, kScreenWidth, 1) andBackView:self.midBackView];

}

#pragma mark - 添加tableView
-(void)addtableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.midBackView.y+self.midBackView.height, kScreenWidth, kScreenheight-(self.midBackView.y+self.midBackView.height)) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"homeMyYGLuckNumCell" bundle:nil] forCellReuseIdentifier:@"homeMyYGLuckNumCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    homeMyYGLuckNumCell * cell = [tableView dequeueReusableCellWithIdentifier:@"homeMyYGLuckNumCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[homeMyYGLuckNumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeMyYGLuckNumCell"];
    }

    cell.index = (int)indexPath.row;
    if (indexPath.row>_dataArray.count-1) {
        return cell;
    }
    cell.model = _dataArray[indexPath.row];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark - 查看我的摇码
-(void)lookMyluckNums{
    NSString * idx = [[NSUserDefaults standardUserDefaults]objectForKey:@"index-lookMyLuckNum"];
    int index = [idx intValue];
    homeMyYGLuckNumModel * model = _dataArray[index];
    NSArray * array = [NSArray arrayWithArray:model.luckNums];
    self.codesArray = [NSMutableArray arrayWithArray:array];
    //摇码提示窗
//    [addLuckNumView addSmallViewWithModel:array VC:self toView:self.view];
    [self showWithArray:array];
}



-(void)loadData{
    Account * account = [AccountTool account];
    if (!account) {
        [self jumpToMyAccountVC];
        return;
    }
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    DebugLog(@"====-%@=====%@",_prizemodel.serialId , _serialId);
    if (_serialId) {
        [parameters setValue:_serialId forKey:@"serialId"];
    }else{
        [parameters setValue:_prizemodel.serialId forKey:@"serialId"];
    }


    [XLRequest AFPostHost:kbaseURL bindPath:@"/yshakeCoupons/getMineRecordOnSerial" postParam:parameters isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DebugLog(@"查看我的摇码获取结果==%@",responseDic);

        NSArray * array = [NSArray arrayWithArray:responseDic[@"data"]];
        if ([responseDic[@"code"] isEqual:@0]) {
            if (array.count == 0) {
                [MBProgressHUD showError:@"您未参与该期摇购!"];
                return ;
            }
            for (NSDictionary * dict in responseDic[@"data"]) {
                homeMyYGLuckNumModel * model = [homeMyYGLuckNumModel modelWithDict:dict];
                [self.dataArray addObject:model];
            }
        }else if ([responseDic[@"code"] isEqual:KotherLogin]){
            [MBProgressHUD showError:@"账号信息有误,请重新登录!"];
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(jumpToMyAccountVC) userInfo:nil repeats:NO];
//            [self jumpToMyAccountVC];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载超时,请检查网络!"];
        DebugLog(@"查看我的摇码失败error==%@===oper=%@",error,operation);
    }];
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
    _btn.alpha = kalpha;
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
    //该方法也可以设置itemSize
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
    
    cell.titleStrLabel.text = self.codesArray[indexPath.item];

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
    [_btn removeFromSuperview];
    [_smallView removeFromSuperview];
    [_xiaX removeFromSuperview];
}

@end
