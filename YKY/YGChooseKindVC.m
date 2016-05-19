//
//  YGChooseKindVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/12.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "YGChooseKindVC.h"
#import "rightimgBtn.h"
#import "kindModel.h"
#import "YGChooseKindCell.h"

#define rowHeight 44

@interface YGChooseKindVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , strong) UILabel * currentLabel;

@end

@implementation YGChooseKindVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择分类";
    self.tabBarController.tabBar.items[1].title = @"摇购";
    [self setLeft];

    //添加views
    [self addViews];

    //加载数据
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    
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


#pragma mark - 添加顶部固定view
-(void)addViews{
    //1.添加顶部两块儿btn
//    //1.1大view
//    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, rowHeight)];
//    backView.backgroundColor = YKYColor(247, 237, 240);
//    [self.view addSubview:backView];
//    //1.2中分线
//    UIView * midLine = [[UIView alloc]initWithFrame:CGRectMake(backView.centerX-1, 2, 1, backView.height-4)];
//    midLine.backgroundColor = [UIColor lightGrayColor];
////    [backView addSubview:midLine];
//
//    //1.3全部分类
//    self.kindsBtn = [[rightImgBtn alloc]initWithFrame:CGRectMake(0, 0, 0.5*backView.width, backView.height)];
//    self.kindsBtn.backgroundColor = [UIColor clearColor];
//    [self.kindsBtn setImage:[UIImage imageNamed:@"blackDown"] withTitle:_currentKind forState:UIControlStateNormal font:[myFont getTitle2]];
//    [self.kindsBtn setTitleColor:YKYColor(51, 51, 51) forState:UIControlStateNormal];
//    self.kindsBtn.userInteractionEnabled = NO;
//    //    [self.kindsBtn addTarget:self action:@selector(chooseKind) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:self.kindsBtn];
//
//    //1.4全部城市
//    self.citysBtn = [[rightImgBtn alloc]initWithFrame:CGRectMake(0.5*backView.width, 0, 0.5*backView.width, backView.height)];
//    self.citysBtn.backgroundColor = [UIColor clearColor];
//    [self.citysBtn setImage:[UIImage imageNamed:@"blackDown"] withTitle:_currentCity forState:UIControlStateNormal font:[myFont getTitle2]];
//    [self.citysBtn setTitleColor:YKYColor(51, 51, 51) forState:UIControlStateNormal];
//    self.citysBtn.userInteractionEnabled = NO;
//    //    [self.citysBtn addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:self.citysBtn];

    //2.0显示current选择View
    UIView * currentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, rowHeight)];
    currentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:currentView];
    _currentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30, currentView.height-1)];
    NSString * str1 = @"当前分类：";
    NSString * red2 = [NSString stringWithFormat:@"<font size=\"5\" color=\"red\">%@</font>",_currentKind];
    NSString * plimit = [NSString stringWithFormat:@"%@%@",str1,red2];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[plimit dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _currentLabel.attributedText = attrStr;
    [currentView addSubview:_currentLabel];
    _currentLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    [line addLineWithFrame:CGRectMake(15, rowHeight-1, kScreenWidth, 1) andBackView:currentView];

    //2.添加tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, currentView.y+currentView.height, kScreenWidth, kScreenheight-currentView.y-currentView.height-kTabbarHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"YGChooseKindCell" bundle:nil] forCellReuseIdentifier:@"YGChooseKindCell"];
}


#pragma mark - 加载数据
-(void)loadData{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [XLRequest AFPostHost:kbaseURL bindPath:@"/yshakeUtil/getCloudTypes" postParam:dict isClient:NO getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DebugLog(@"摇购加载分类返回结果=%@",responseDic);
        if ([responseDic[@"code"] isEqual:@(0)]) {
            if (responseDic[@"data"]) {
                kindModel * model = [[kindModel alloc]init];
                model.kindName = @"全部分类";
                [self.dataArray addObject:model];
                for (NSDictionary * dict in responseDic[@"data"]) {
                    kindModel * model = [kindModel modelWithDict:dict];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];
            }else{
                [MBProgressHUD showError:responseDic[@"msg"]];
            }
        }else{
            [MBProgressHUD showError:responseDic[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络连接失败!"];
    }];
}


#pragma mark - datasouce
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YGChooseKindCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YGChooseKindCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[YGChooseKindCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YGChooseKindCell"];
    }

    if (_dataArray.count > 0) {
        cell.kindmodel = self.dataArray[indexPath.row];
    }

    return cell;
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    kindModel * model = _dataArray[indexPath.row];
    _currentLabel.text = model.kindName;
    [self.kindsBtn setImage:[UIImage imageNamed:@"jiantou_me"] withTitle:model.kindName forState:UIControlStateNormal font:15.0f];

    [[NSUserDefaults standardUserDefaults]setObject:model.kindName forKey:@"YGCurrentKindName"];
    [[NSUserDefaults standardUserDefaults]setObject:model.kindId forKey:@"YGCurrentKindID"];
    DebugLog(@"摇购选择分类ID=%@===模型kindName=%@",model.kindId,model.kindName);
    [self.navigationController popViewControllerAnimated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}

@end
