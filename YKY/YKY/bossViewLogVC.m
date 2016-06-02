//
//  bossViewLogVC.m
//  YKY
//
//  Created by 亮肖 on 15/6/25.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "bossViewLogVC.h"
#import "AFNetworking.h"
#import "common.h"
#import "bossExpenseCell.h"
#import "UIView+XL.h"
#import "MBProgressHUD+MJ.h"
#import "bossLookConsumeListModel.h"
#import "UIImageView+WebCache.h"


@interface bossViewLogVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIButton *bossPrizeBtn;
@property (weak, nonatomic) IBOutlet UIButton *activityPrizeBtn;



@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , copy) NSString * starDate;
@property (nonatomic , copy) NSString * endDate;

@property (weak, nonatomic) IBOutlet UIButton *starDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
@property (nonatomic , strong) UIView *backView;
@property (nonatomic , copy) NSString * nowEndDate;
@property (nonatomic , copy) NSString * nowStarDate;
@property (nonatomic , strong) UIDatePicker * endDateDatepinker;
@property (nonatomic , strong) UIDatePicker * starDateDatepicker;
@property (nonatomic) BOOL isEndDatepicker;
@property (nonatomic) int lastPageNum ;
@property (nonatomic , copy) NSString * onlyOne;
/** 奖品类型1：商家奖品 1：专区奖品 */
@property (nonatomic , copy) NSString * type;

/** 搜索框承载view */
@property (weak, nonatomic) IBOutlet UIView *searchFeildBackView;
/** 搜索feild */
@property (weak, nonatomic) IBOutlet UITextField *searchFeild;
@property (nonatomic , strong) UIButton * btn;

@property (nonatomic) int index;
@property (nonatomic , copy) NSString * no;



@end

@implementation bossViewLogVC

#pragma mark - 懒加载数组
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchFeild.delegate = self;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"bossExpenseCell" bundle:nil] forCellReuseIdentifier:@"bossExpenseCell"];

    self.navigationItem.title = @"查询记录";
    
    [self setRigthItem];//设置导航条右侧放大镜按钮
    [self setLeftNavBtn];

    _index = 0;
    __weak typeof (self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        self.index = self.index + 1;
        NSString *idx = [NSString stringWithFormat:@"%d",self.index];
        if ([weakSelf.no isEqualToString:@"1"]) {
            self.index = 0;
            idx = [NSString stringWithFormat:@"%d",self.index];
            weakSelf.tableView.footer.stateHidden = YES;
            [weakSelf endrefreshing];
            return ;
        }
        [weakSelf loadConsumeDataWithPage:idx];
        [weakSelf endrefreshing];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.index = 0;
        weakSelf.no = @"0";
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf loadConsumeDataWithPage:@"0"];
        [weakSelf endrefreshing];
    }];
}
- (void)endrefreshing{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
    self.onlyOne = @"1";//右键可点标志设置可点一次
    self.type = @"0"; //商家奖品标志置0， 专区奖品为1
}

#pragma mark - 商家奖品按钮被点击
- (IBAction)bossPrizeBtnClick:(id)sender {
    //改变按钮状体
    [self.bossPrizeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bossPrizeBtn setBackgroundImage:[UIImage imageNamed:@"twoBtns-left"] forState:UIControlStateNormal];
    [self.activityPrizeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.activityPrizeBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    //保存状态
    self.type = @"0";
    
    [self.dataArray removeAllObjects];
    //加载数据
    [self loadConsumeDataWithPage:@"0"];
}
#pragma mark - 专区奖品按钮被点击
- (IBAction)activityPrizeBtnClick:(id)sender {
    //改变按钮状态
    [self.bossPrizeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bossPrizeBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.activityPrizeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.activityPrizeBtn setBackgroundImage:[UIImage imageNamed:@"twoBtns-right"] forState:UIControlStateNormal];
    
    //保存状态
    self.type = @"1";
    
    [self.dataArray removeAllObjects];
    //加载数据
    [self loadConsumeDataWithPage:@"0"];
}

#pragma mark - 起始时间按钮被点击
- (IBAction)starTimeBtnClick:(id)sender {
    [self addDatepicker:self.starDateDatepicker isEndDatepicker:NO];
}

#pragma mark - 截止时间按钮点击事件
- (IBAction)endTimeBtnClick:(id)sender {
    [self addDatepicker:self.endDateDatepinker isEndDatepicker:YES];
}

#pragma mark - 添加对应的pickerView
-(void)addDatepicker:(UIDatePicker*)picker isEndDatepicker:(BOOL)isEndDatepicker{
    
    self.isEndDatepicker = isEndDatepicker;
    
    _backView = [[UIView alloc]init];
    _backView.frame = CGRectMake(0, 74, kScreenWidth, kScreenheight);
    _backView.backgroundColor = [UIColor lightGrayColor];
    _backView.alpha = 0.8;
    [self.view addSubview:_backView];
    
    picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(20, 100, kScreenWidth-40, 200)];
    [_backView addSubview:picker];
    
    [picker setCalendar:[NSCalendar currentCalendar]];//默认显示当天
    [picker setDate:[NSDate date]];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
    
    NSDate *minimunDate = [NSDate distantPast];
    NSDate *maximunDate = [NSDate distantFuture];
    picker.minimumDate = minimunDate;
    picker.maximumDate = maximunDate;
    
    NSDateFormatter *dateFoematter = [[NSDateFormatter alloc]init];
    [dateFoematter setDateFormat:@"yyyy-MM-dd"];
    
    //滚动结束时的监听事件
    [picker addTarget:self action:@selector(endDateChange:)forControlEvents:UIControlEventValueChanged];
    
    UIButton *ok = [[UIButton alloc]initWithFrame:CGRectMake(picker.width-100, picker.y+picker.height, 100, 40)];
    [ok setTitle:@"确定" forState:UIControlStateNormal];
    [ok setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [ok addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:ok];
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(picker.x, picker.y+picker.height, 100, 40)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:cancel];
    
    
    self.nowEndDate = [dateFoematter stringFromDate:picker.date];
    self.nowStarDate = [dateFoematter stringFromDate:picker.date];
}

#pragma mark - 取消按钮点击事件
-(void)cancelClick{
    
    NSDateFormatter *dateFoematter = [[NSDateFormatter alloc]init];
    [dateFoematter setDateFormat:@"yyyy-MM-dd"];
    if (self.isEndDatepicker) {
        NSString *string = [dateFoematter stringFromDate:[NSDate date]];
        [self.endDateBtn setTitle:string forState:UIControlStateNormal];
    }else{
        NSString *string = [dateFoematter stringFromDate:[NSDate date]];
        [self.starDateBtn setTitle:string forState:UIControlStateNormal];
    }
    [self.backView removeFromSuperview];
}


#pragma mark - 确定按钮点击事件
-(void)okClick{
    NSDateFormatter *dateFoematter = [[NSDateFormatter alloc]init];
    [dateFoematter setDateFormat:@"yyyy-MM-dd"];

    if (self.isEndDatepicker) {//点击的是截止时间按钮时的事件
        NSString * date = [dateFoematter stringFromDate:self.endDateDatepinker.date];
        if (![date isEqualToString:self.endDateBtn.titleLabel.text]) {
            [self.endDateBtn setTitle:self.nowEndDate forState:UIControlStateNormal];
        }
    }else{
        NSString * date = [dateFoematter stringFromDate:self.starDateDatepicker.date];
        if (![date isEqualToString:self.starDateBtn.titleLabel.text]) {
            [self.starDateBtn setTitle:self.nowStarDate forState:UIControlStateNormal];
        }
    }
    [self.backView removeFromSuperview];
    
    self.onlyOne = @"1";//切换时间恢复右键可点
    [self.dataArray removeAllObjects];//清空数据源
}

#pragma mark - 监听时间的改变事件（滚动结束时调用）
-(void)endDateChange:(UIDatePicker *)datePicker{
    
    //上传服务器的格式
    NSDateFormatter *dateFormetter = [[NSDateFormatter alloc]init];
    [dateFormetter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [dateFormetter stringFromDate:datePicker.date];//需要上传的字符串
    
    //显示到界面的格式
    NSDateFormatter *dateFormetter1 = [[NSDateFormatter alloc]init];
    [dateFormetter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *string1 = [dateFormetter1 stringFromDate:datePicker.date];//需要显示的字符串
    
    
    if (self.isEndDatepicker) {
        [self.endDateBtn setTitle:string1 forState:UIControlStateNormal];
        self.endDate = string;
        self.nowEndDate = string1;
    }else{
        [self.starDateBtn setTitle:string1 forState:UIControlStateNormal];
        self.starDate = string;
        self.nowStarDate = string1;
    }

}

#pragma mark - 设置导航条右侧放大镜按钮
-(void)setRigthItem{
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}


#pragma mark - 导航栏右侧放大镜按钮被点击事件
-(void)rightClick{
    if ([self.starDateBtn.titleLabel.text isEqualToString:@"起始时间"] || [self.endDateBtn.titleLabel.text isEqualToString:@"截止时间"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError: @"起止时间选择有误"];
        return;
    }else if([_onlyOne isEqualToString:@"1"]){
        self.onlyOne = @"2";//点击次数标识 1：右键被点击过一次
    }else{
        return;
    }
    [self.dataArray removeAllObjects];//清空数据源
    [self.tableView reloadData];//刷新界面
    [self loadConsumeDataWithPage:@"0"];//初始化时加载第一页
    
}

#pragma mark - 加载消费列表数据
-(void)loadConsumeDataWithPage:(NSString*)page{
    [MBProgressHUD showMessage:@"查询中..." toView:self.view];

    NSString *str = kcheckCouponsListStr;

    if (![self.starDateBtn.titleLabel.text isEqualToString:@"起始时间"]) {
        self.starDate = self.starDateBtn.titleLabel.text;
    }
    if (![self.endDateBtn.titleLabel.text isEqualToString:@"截止时间"]) {
        self.endDate = self.endDateBtn.titleLabel.text;
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameters = [NSDictionary dictionary];
    if (self.bossID==nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"用户信息有误"];
        return;
    }
    if (self.starDate.length!=0 && self.endDate.length!=0) {
        parameters = @{@"mId":self.bossID,@"sTime":self.starDate,@"eTime":self.endDate,@"type":self.type,@"pageNum":page};
        if (self.searchFeild.text.length>10) {
            if (![phone isMobileNumber:self.searchFeild.text]) {
                [MBProgressHUD showError:@"请输入正确的手机号"];
                return;
            }
            parameters = @{@"mId":self.bossID,@"sTime":self.starDate,@"eTime":self.endDate,@"type":self.type,@"pageNum":page,@"userPhone":self.searchFeild.text};
        }
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }

    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:@(0)]) {
            NSArray * array = responseObject[@"data"];
            if (array.count == 0) {
                [MBProgressHUD showError:@"没有更多记录!"];
                return ;
            }
            for (NSDictionary *dict in responseObject[@"data"]) {
                bossLookConsumeListModel *model = [bossLookConsumeListModel usedPrizeWithDict:dict];
                [self.dataArray addObject:model];
            }
        }else{
            NSArray * array = responseObject[@"data"];
            if (array.count == 0) {
                [MBProgressHUD showError:@"没有更多数据"];
            }
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载超时,请重试!"];
    }];
}

#pragma mark - 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    bossExpenseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bossExpenseCell"];
    if (cell == nil) {
        cell = [[bossExpenseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bossExpenseCell"];
        return cell;
    }
    if (self.dataArray.count == 0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"没有更多数据"];
        return cell;
    }
    bossLookConsumeListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - 代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

#pragma mark - textfield代理方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat y = self.searchFeildBackView.y+self.searchFeildBackView.height;
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, kScreenheight-y)];
    self.btn.backgroundColor = YKYClearColor;
    [self.btn addTarget:self action:@selector(dissMess) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    return YES;
}

#pragma mark - 键盘消失
-(void)dissMess{
    [self.btn removeFromSuperview];
    [self.searchFeild resignFirstResponder];
}


#pragma mark - 搜索按钮点击事件
- (IBAction)searchBtnClick:(id)sender {
    [self dissMess];
    DebugLog(@"搜索按钮被点击");
    [self rightClick];
}



@end
