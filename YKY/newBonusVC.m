//
//  newBonusVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/6.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "newBonusVC.h"
#import "common.h"
#import "AFNetworking.h"
#import "Account.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "unUsedPrizeModel.h"
#import "UIView+XL.h"
#import <CommonCrypto/CommonDigest.h>
#import "boundCells.h"
#import "newBounsDetailVC.h"
#import "usedPrizeVC.h"
#import "duihuanyinbi.h"
#import "searchPrizesVC.h"
#import "alterView.h"


#define kopenUrl [kbaseURL stringByAppendingString:@"/jiangdou.jsp"]
//#define kopenUrl @"http://192.168.1.184:8585/ykyInterface/aa.html"

@interface newBonusVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


//奖品列表的tableView
@property (weak, nonatomic) IBOutlet UITableView *TableView;

/** 奖品数据模型数组 */
@property (nonatomic , strong) NSMutableArray * prizeDataArray;
/** 将要删除奖品的数据数组 */
@property (nonatomic , strong) NSMutableArray * willDeleteArray;
/**  存放所有选中的row  */
@property (nonatomic , strong) NSMutableArray * rowsArray;


/** 没有更多奖品标志符 */
@property (nonatomic , copy) NSString * no;
/**  标志右侧标题按钮是否被点击  */
@property (nonatomic ) BOOL rightclick;
/** 删除或兑换按钮背景View */
@property (nonatomic , strong) UIView * deletePrizeBtnBackView;
/** 删除或兑换按钮 */
@property (nonatomic , strong) UIButton * deletePrizeBtn;
/** 又导航按钮 */
@property (nonatomic , strong) UIButton * rightBtn;

@property (nonatomic , copy) NSString * prizeids;

@property (nonatomic ) int myIndex;
/** 顶部搜索框中的textfield */
@property (weak, nonatomic) IBOutlet UITextField *textfield;

/** 背景Btn */
@property (nonatomic , strong) UIButton * backBtn;
@property (nonatomic) int index;//上拉刷新页码
/** 全选的圆圈标志图 */
@property (nonatomic , strong) UIImageView * xuanImgView;



@end

@implementation newBonusVC


-(NSMutableArray *)rowsArray{
    if (_rowsArray == nil) {
        self.rowsArray = [[NSMutableArray alloc]init];
    }
    return _rowsArray;
}

-(NSMutableArray *)willDeleteArray{
    if (_willDeleteArray == nil) {
        self.willDeleteArray = [[NSMutableArray alloc]init];
    }
    return _willDeleteArray;
}
-(NSMutableArray *)prizeDataArray{
    if (_prizeDataArray == nil) {
        self.prizeDataArray = [[NSMutableArray alloc]init];
    }
    return _prizeDataArray;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textfield resignFirstResponder];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleStr;

    [self setNavigationBar];
    self.rightclick = NO;
    [self setLeft];
    //设置titleView
//    [self setTitleView];
    //没有用户登录的情况下直接跳转到登录界面
    Account * account = [AccountTool account];
    if (!account) {
        [self jumpToMyAccountVC];
        return;
    }
    //注册cell
    [self.TableView registerNib:[UINib nibWithNibName:@"boundCells" bundle:nil] forCellReuseIdentifier:@"boundCells"];
    // 添加传统的上拉刷新
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [self updataPrize];


    _index = 0;
    __weak typeof (self) weakSelf = self;
    [self.TableView addLegendFooterWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        self.index = self.index + 1;
        NSString *idx = [NSString stringWithFormat:@"%d",self.index];
        if ([weakSelf.no isEqualToString:@"1"]) {
            self.index = 0;
            idx = [NSString stringWithFormat:@"%d",self.index];
            weakSelf.TableView.footer.stateHidden = YES;
            [weakSelf endrefreshing];
            return ;
        }
        [weakSelf loadUsedDataWithPage:idx];
        [weakSelf endrefreshing];
    }];
    [self.TableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.index = 0;
        weakSelf.no = @"0";
        [weakSelf.prizeDataArray removeAllObjects];
        [weakSelf.TableView reloadData];
        [weakSelf loadUsedDataWithPage:@"0"];
        [weakSelf endrefreshing];
    }];
}
- (void)endrefreshing{
    [self.TableView.header endRefreshing];
    [self.TableView.footer endRefreshing];
}

//#pragma mark - 设置TitleView
//-(void)setTitleView{
//    UIView * titleview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.6*self.view.width, 30)];
//    //添加背景图片
//    UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, titleview.width, titleview.height)];
//    imgview.image = [UIImage imageNamed:@"topSearch"];
//    [titleview addSubview:imgview];
//    //添加Button
//    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(8, 6, 17, 17)];
//    [btn setImage:[UIImage imageNamed:@"搜索按钮-1"] forState:UIControlStateNormal];
//    [titleview addSubview:btn];
////    //添加textView
////    self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(btn.x+btn.width+4, 0, titleview.width-(btn.x+btn.width+4)-4, titleview.height)];
//    self.textfield.placeholder = @"请输入关键字";
//    self.textfield.delegate = self;
//    self.textfield.clearsOnBeginEditing = YES;
//    self.textfield.font = [UIFont systemFontOfSize:15];
//    self.textfield.borderStyle = UITextBorderStyleNone;
//    self.textfield.keyboardType = UIKeyboardTypeDefault;
//    self.textfield.returnKeyType = UIReturnKeySearch;
//    self.textfield.userInteractionEnabled = NO;
//    [titleview addSubview:self.textfield];
//    UIButton * bigBtn = [[UIButton alloc]initWithFrame:CGRectMake(titleview.x, titleview.y, titleview.width, titleview.height)];
//    bigBtn.backgroundColor = [UIColor clearColor];
//    [bigBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
//    [titleview addSubview:bigBtn];
//    self.navigationItem.titleView = titleview;
//}
//-(void)search{
//    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    searchPrizesVC * vc = [sb instantiateViewControllerWithIdentifier:@"searchPrizesVC"];
//    if ([AccountTool account]) {
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//        [MBProgressHUD showError:@"您的账号信息有误!"];
//        [self jumpToMyAccountVC];
//    }
//}

- (IBAction)searchBtnClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    searchPrizesVC * vc = [sb instantiateViewControllerWithIdentifier:@"searchPrizesVC"];
    vc.type = [[NSUserDefaults standardUserDefaults]objectForKey:@"couponsType"];
    if ([AccountTool account]) {
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [MBProgressHUD showError:@"您的账号信息有误!"];
        [self jumpToMyAccountVC];
    }
}




#pragma mark - viewWillApper和viewWillDisapper
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"jumpedLogin"] isEqualToString:@"1"]) {
        [self.prizeDataArray removeAllObjects];
        [self.TableView reloadData];
        [self loadUsedDataWithPage:@"0"];
    }

    //注册cell
    [self.TableView registerNib:[UINib nibWithNibName:@"boundCells" bundle:nil] forCellReuseIdentifier:@"boundCells"];
    
    Account * account = [AccountTool account];
    if (account == nil) {
        [self.prizeDataArray removeAllObjects];
        [self.TableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请登录您的账号!"];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"haveJumped"] isEqualToString:@"1"]) {
            return;
        }
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"jumpedLogin"];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(jumpToMyAccountVC) userInfo:nil repeats:NO];
        return;
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"jumpedLogin"];
    }

    //接收执行过兑换或者删除的标识
    NSString * string = [[NSUserDefaults standardUserDefaults]objectForKey:@"shuaxin"];
    DebugLog(@"-=-====string=%@",string);
    CGFloat num = self.prizeDataArray.count;
    if (string) {
        [self.prizeDataArray removeAllObjects];
        [self loadUsedDataWithPage:@"0"];
        if (num-1 == 0) {
            [self.prizeDataArray removeAllObjects];
            [self.TableView reloadData];
        }
    }
    //清空执行过兑换或者删除的标识
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"shuaxin"];

    //接收使用按钮的点击事件通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumptoUsePrize) name:@"useBtnClick" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.tabBarController.tabBar.items[1] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"useBtnClick" object:nil];
}

/**
 *  使用按钮点击事件
 */
-(void)useBtnClick{
    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index"];
    int inx = [index intValue];
    unUsedPrizeModel *model = self.prizeDataArray[inx];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    newBounsDetailVC * bonusDetailVC = [sb instantiateViewControllerWithIdentifier:@"newBounsDetailVC"];
    bonusDetailVC.couponsId = [NSString stringWithFormat:@"%@",model.cid];
    bonusDetailVC.Type = [NSString stringWithFormat:@"%@", model.type];
    [self.navigationController pushViewController:bonusDetailVC animated:YES];
}

#pragma mark - 请求奖兜奖品数据
-(void)loadUsedDataWithPage:(NSString*)page{

    if (self.rightclick) {
        self.xuanImgView.image = [UIImage imageNamed:@"weigouxuan"];
    }
    NSString * str = kboundsPrizeDataListStr;
    Account *account = [AccountTool account];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (account == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"账号已过有效期，请重新登录"];
        self.index = 0;
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"haveJumped"] isEqualToString:@"1"]) {
            return;
        }
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(jumpToMyAccountVC) userInfo:nil repeats:NO];
        return;
    }
    NSString * couponsType = [[NSUserDefaults standardUserDefaults]objectForKey:@"couponsType"];
    DebugLog(@"请求网络========是否活动摇=%d=========当前类型=%@",_isActivityRockPrize,couponsType);
    if (account.uiId == nil || account.reponseToken == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"账号信息有误,请重新登录!"];
        [self jumpToMyAccountVC];
    }
    NSDictionary *parameters = @{@"pageNum":page,@"serverToken":account.reponseToken,@"userId":account.uiId,@"client":Kclient,@"couponsType":couponsType,@"vagueFlag":@"0"};
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"奖兜列表数据请求结果==%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"]  isEqual: @(0)]){
            NSArray * array = [[NSArray alloc]init];
            array = responseObject[@"data"];
            if (array.count == 0) {
                self.no = @"1";
                [MBProgressHUD showError:@"没有更多数据!"];
                self.index = 0;
                [self.TableView reloadData];
                return ;
            }
            //往数据源里添加数据
            for (NSDictionary *dict in responseObject[@"data"]) {
                unUsedPrizeModel *unUsedPrize = [unUsedPrizeModel prizeWithDict:dict];
                [self.prizeDataArray addObject:unUsedPrize];
            }
            //刷新数据
            [self.TableView reloadData];
        }else if ([responseObject[@"code"] isEqual:KotherLogin]){
            self.no = @"1";
            [MBProgressHUD showError:@"账号已过有效期，请重新登录" ];
            [self jumpToMyAccountVC];
        }else{
            self.no = @"1";
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败!"];
    }];
}

#pragma mark - 设置NavigationBar
- (void)setNavigationBar{
    //右侧NVB按钮设置
    self.rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(10, 0, 40,20)];
    [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    UIBarButtonItem * right=[[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    [self.rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = right;
}

static BOOL clickOne = YES;
#pragma mark - 实现cell 删除功能
-(void)rightClick:(UIButton *)btn{
    if ([AccountTool account] == nil) {
        [MBProgressHUD showError:@"账号信息有误,请重新登录!"];
        return;
    }
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [self.willDeleteArray removeAllObjects];
    [self.deletePrizeBtnBackView removeFromSuperview];
    self.rightclick = YES;
//添加兑换银币或删除按钮
    CGFloat w = kScreenWidth;
    CGFloat h = 40;
    CGFloat y = kScreenheight-88;
    self.deletePrizeBtnBackView = [[UIView alloc]initWithFrame:CGRectMake(0, y, w, h)];
    if (self.view.height > 668) {
        self.deletePrizeBtnBackView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenheight-99, w, h)];
    }
    self.deletePrizeBtnBackView.backgroundColor = [UIColor clearColor];
    [self.deletePrizeBtnBackView removeFromSuperview];


    //全选模块
    UIView * globView = [self quanxuanView];

    //删除按钮
    [self deletBtnWithX:globView.width-1 andWidth:kScreenWidth-globView.width];

    if (clickOne) {
        [self.view insertSubview:self.deletePrizeBtnBackView aboveSubview:self.TableView];
        self.TableView.sectionIndexTrackingBackgroundColor = [UIColor redColor];
        //设置tableviewcell可删除
        [self.TableView setEditing:YES animated:YES];
        clickOne = NO;
    }else if (clickOne == NO){
        [self.deletePrizeBtnBackView removeFromSuperview];
        //取消tableview的可编辑状态
        [self.TableView setEditing:NO animated:YES];
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        clickOne = YES;
        self.rightclick = NO;
        return;
    }
    [self.deletePrizeBtn setTitle:@"兑换银币" forState:UIControlStateNormal];
    //添加事件
    [self.deletePrizeBtn addTarget:self action:@selector(duiHuanYB:) forControlEvents:UIControlEventTouchUpInside];

}

//全选的View
-(UIView *)quanxuanView{
    CGFloat globW = 0.75*kScreenWidth;
    CGFloat h = 40;
    if (self.view.height > 668) {
        h = 50;
    }
    UIView * globView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, globW, h)];
    globView.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:104.0/255.0 blue:101.0/255.0 alpha:1.0];
    [self.deletePrizeBtnBackView addSubview:globView];
    //圆圈
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(11, 11, 20, 20)];
    if (self.view.height > 668) {
        imgView.frame = CGRectMake(11, 15, 20, 20);
    }
    imgView.image = [UIImage imageNamed:@"weigouxuan"];
    [globView addSubview:imgView];
    self.xuanImgView = imgView;
    //文字
    UILabel * text = [[UILabel alloc]initWithFrame:CGRectMake(imgView.x+imgView.width+8, imgView.y, 60, imgView.height)];
    text.backgroundColor = [UIColor clearColor];
    text.font = [UIFont systemFontOfSize:17];
    text.text = @"全选";
    text.textColor = [UIColor whiteColor];
    [globView addSubview:text];
    //覆盖透明按钮
    UIButton * topBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0.5*globView.width, globView.height)];
    topBtn.backgroundColor = [UIColor clearColor];
    [globView addSubview:topBtn];
    [topBtn addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];

    return globView;
}

//下边的删除按钮
-(void)deletBtnWithX:(CGFloat)x andWidth:(CGFloat)W{
    //添加兑换银币按钮
    UIButton *deletBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, W, 40)];
    //删除和兑换功能实现
    self.deletePrizeBtn = deletBtn;
    if (self.view.height > 668) {
        deletBtn.frame = CGRectMake(x, 0, W, 50);
    }
    [self.deletePrizeBtnBackView addSubview:self.deletePrizeBtn];
    //设置Btn属性
    [deletBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtnBack"] forState:UIControlStateNormal];
    [deletBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    return;
}

static BOOL click = YES;
-(void)choose{
    if (click) {//点一次
        //界面
        self.xuanImgView.image = [UIImage imageNamed:@"xuanzhong"];
        for (int i = 0; i<self.prizeDataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i  inSection:0];
            [self.TableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            [self.willDeleteArray addObject:self.prizeDataArray[i]];
        }
        //数据
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"quanxuan"];

        click = NO;
    }else{//点第二次
        //界面
        self.xuanImgView.image = [UIImage imageNamed:@"weigouxuan"];
        for (int i = 0; i<self.prizeDataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i  inSection:0];
            [self.TableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.willDeleteArray removeAllObjects];
        }
        //数据
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"quanxuan"];

        click = YES;
    }
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

/**  兑换银币事件 */
-(void)duiHuanYB:(UIButton *)btn{
    [self duiHuanYb];
}

#pragma mark - 兑换银币功能实现
-(void)duiHuanYb{
    BOOL seccess = YES;
    seccess = [duihuanyinbi duiHuanYbWithTableView:self.TableView array:self.willDeleteArray andVC:self andJump:@selector(jumpToMyAccountVC) andRightBtn:self.rightBtn andDataArray:self.prizeDataArray btnsView:self.deletePrizeBtnBackView];
    self.rightclick = NO;
}

#pragma mark - 未使用按钮点击事件
- (void)updataPrize {
    self.no = @"0";//判空标识符置零
    self.rightclick = NO;
    self.TableView.footer.hidden = NO;//上啦刷新功能恢复
    [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];

    if (!clickOne) {
        clickOne = YES;
    }
    [self.TableView setEditing:NO animated:YES];
    [self.deletePrizeBtnBackView removeFromSuperview];
    [self.prizeDataArray removeAllObjects];

    //接收执行过兑换或者删除的标识
    NSString * string = [[NSUserDefaults standardUserDefaults]objectForKey:@"shuaxin"];
    if (!string) {
        //加载未使用奖品数据
        [self loadUsedDataWithPage:@"0"];
    }
}

#pragma mark - 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.prizeDataArray.count?self.prizeDataArray.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    boundCells *cell = [tableView dequeueReusableCellWithIdentifier:@"boundCells"];
    if (cell == nil) {
        cell = [[boundCells alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"boundCells"];
    }

    cell.index = (int)indexPath.row;
    if (self.prizeDataArray.count == 0) {
        return cell;
    }
    cell.model = self.prizeDataArray[indexPath.row];

    return cell;
}


#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

static BOOL one = YES;
//选中跳转方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger only = indexPath.row;
    if (one == YES) {
        [[NSUserDefaults standardUserDefaults]setObject:@(only) forKey:@"one"];
        one = NO;
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@(only) forKey:@"two"];
        one = YES;
    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    if (self.rightclick == NO && self.TableView.isEditing==NO) {
        if (self.prizeDataArray.count == 0) {
            return;
        }
        unUsedPrizeModel * model = self.prizeDataArray[indexPath.row];
        newBounsDetailVC * bonusDetailVC = [sb instantiateViewControllerWithIdentifier:@"newBounsDetailVC"];
        if (self.prizeDataArray.count == 0) {
            return;
        }else{
            bonusDetailVC.couponsId = [NSString stringWithFormat:@"%@",model.cid];
            bonusDetailVC.Type = [NSString stringWithFormat:@"%@",model.type];
        }
        [self.navigationController pushViewController:bonusDetailVC animated:YES];
    }else if (self.rightclick == YES || self.TableView.isEditing == YES){
        if (self.prizeDataArray[indexPath.row]) {
            [self.willDeleteArray addObject:self.prizeDataArray[indexPath.row]];
        }
    }
}


#pragma mark - 点击使用按钮
-(void)jumptoUsePrize{

    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index"];
    int findex = [index intValue];

    //拿到控制器
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    usedPrizeVC * vc = [sb instantiateViewControllerWithIdentifier:@"usedPrizeVC"];

    //拿到模型
    unUsedPrizeModel * model = self.prizeDataArray[findex];
    vc.identafy = @"1";
    vc.prizeModel = model;

    //删除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"useBtnClick" object:nil];

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 取消选中cell时调用方法
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    unUsedPrizeModel * model = self.prizeDataArray[indexPath.row];
    NSString * indStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"quanxuan"];
    if ([indStr isEqualToString:@"1"]) {
        self.xuanImgView.image = [UIImage imageNamed:@"weigouxuan"];
        if (self.willDeleteArray.count == 0) {
            return;
        }
        [self.willDeleteArray removeObject:model];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"quanxuan"];
    }else{
        if (self.willDeleteArray.count == 0) {
            return;
        }
        [self.willDeleteArray removeObject:model];
    }
}


/** Safari打开已使用已过期网址 */
-(void)jumpToSafari{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kopenUrl]];
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

//没有更多数据的标识符置零
-(void)noMoreData{
    self.no = @"0";
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
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"haveJumped"];
        [self.prizeDataArray removeAllObjects];
        [self.TableView reloadData];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }else{
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"haveJumped"];
        [self.prizeDataArray removeAllObjects];
        [self.TableView reloadData];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }
}






















#pragma mark - 搜索奖品方法
-(void)seachPrizeWithPage:(NSString *)page{
    if (self.textfield.text.length == 0) {
        return;
    }
    [MBProgressHUD showMessage:@"查询中..." toView:self.view];
    Account * account = [AccountTool account];
    NSString * str = kboundSearchStr;

    NSString * type = [[NSUserDefaults standardUserDefaults]objectForKey:@"nowPrizeType"];
    if (!type) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请输入搜索内容"];
        return;
    }

    NSDictionary *parameter = @{@"pageNum":page,@"serverToken":account.reponseToken,@"userId":account.uiId,@"client":Kclient,@"couponsType":type,@"vagueFlag":@"1",@"vagueVal":self.textfield.text};

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"搜索精品结果=%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"]  isEqual: @(0)]){
            NSArray * array = responseObject[@"data"];
            if (array.count == 0) {
                self.no = @"1";
                [MBProgressHUD showError:@"没有更多数据!"];
                [self.TableView reloadData];
                return ;
            }
            //往数据源里添加数据
            for (NSDictionary *dict in responseObject[@"data"]) {
                unUsedPrizeModel *unUsedPrize = [unUsedPrizeModel prizeWithDict:dict];
                [self.prizeDataArray addObject:unUsedPrize];
            }
            //刷新数据
            [self.TableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }else if ([responseObject[@"code"] isEqual:@(-99)]){
            self.no = @"1";
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"账号已过有效期，请重新登录" ];
            [self jumpToMyAccountVC];
        }else{
            self.no = @"1";
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:responseObject[@"msg"]];
            self.TableView.footer.hidden = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请稍后再试!"];
    }];
}





@end
