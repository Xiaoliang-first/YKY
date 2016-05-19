//
//  YGChooseCityVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/12.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "YGChooseCityVC.h"
#import "rightimgBtn.h"
#import "YGChooseCityCell.h"
#import "cityModel.h"
#import "NSString+PinYin.h"


#define rowHeight 40

@interface YGChooseCityVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) rightImgBtn * kindsBtn;
@property (nonatomic , strong) rightImgBtn * citysBtn;
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , strong) UILabel * currentLabel;
@property (nonatomic , strong) NSMutableArray * ciNamesArray;

@end

@implementation YGChooseCityVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(NSMutableArray *)ciNamesArray{
    if (_ciNamesArray == nil) {
        self.ciNamesArray = [[NSMutableArray alloc]init];
    }
    return _ciNamesArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    self.tabBarController.tabBar.items[1].title = @"摇购";
    [self setLeft];

    //添加views
    [self addViews];
    
    //加载数据
    [self loadData];

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
//
//    //1.3全部分类
//    self.kindsBtn = [[rightImgBtn alloc]initWithFrame:CGRectMake(0, 0, 0.5*backView.width, backView.height)];
//    self.kindsBtn.backgroundColor = [UIColor clearColor];
//    [self.kindsBtn setImage:[UIImage imageNamed:@"blackDown"] withTitle:_currentKind forState:UIControlStateNormal font:[myFont getTitle2]];
//    [self.kindsBtn setTitleColor:YKYColor(51, 51, 51) forState:UIControlStateNormal];
//    self.kindsBtn.userInteractionEnabled = NO;
//    [backView addSubview:self.kindsBtn];
//
//    //1.4全部城市
//    self.citysBtn = [[rightImgBtn alloc]initWithFrame:CGRectMake(0.5*backView.width, 0, 0.5*backView.width, backView.height)];
//    self.citysBtn.backgroundColor = [UIColor clearColor];
//    [self.citysBtn setImage:[UIImage imageNamed:@"blackDown"] withTitle:_currentCity forState:UIControlStateNormal font:[myFont getTitle2]];
//    [self.citysBtn setTitleColor:YKYColor(51, 51, 51) forState:UIControlStateNormal];
//    self.citysBtn.userInteractionEnabled = NO;
//    [backView addSubview:self.citysBtn];


    //2.0显示current选择View
    UIView * currentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, rowHeight)];
    currentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:currentView];
    _currentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30, currentView.height-1)];
    NSString * str1 = @"当前地区：";

    NSString * red2 = [NSString stringWithFormat:@"<font size=\"5\" color=\"red\">%@</font>",_currentCity];
    if ([_currentCity isEqualToString:@"城市"]) {
        red2 = @"<font size=\"5\" color=\"red\">请选择</font>";
    }
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
    [self.tableView registerNib:[UINib nibWithNibName:@"YGChooseCityCell" bundle:nil] forCellReuseIdentifier:@"YGChooseCityCell"];
}


#pragma mark - 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return _ciNamesArray.count?_ciNamesArray.count+1:0;
    return _ciNamesArray.count?_ciNamesArray.count:0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 1;
//    }else{
//        NSDictionary * dict = _ciNamesArray[section-1];
        NSDictionary * dict = _ciNamesArray[section];
        NSArray * array = dict[@"content"];
        return array.count?array.count:0;
//    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YGChooseCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YGChooseCityCell"];

    if (cell == nil) {
        cell = [[YGChooseCityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YGChooseCityCell"];
    }

//    if (indexPath.section==0) {
//        cityModel * model = [[cityModel alloc]init];
//        model.ciName = @"全国";
//        cell.citymodel = model;
//    }else{
//        NSDictionary * dict = _ciNamesArray[indexPath.section-1];
        NSDictionary * dict = _ciNamesArray[indexPath.section];
        NSArray * array = dict[@"content"];
        cityModel * model = array[indexPath.row];
        cell.citymodel = model;
//    }

    return cell;
}

#pragma mark - delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}

#pragma mark - 选中跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    if (indexPath.section == 0) {
//        [[NSUserDefaults standardUserDefaults]setObject:@"全国" forKey:@"YGCurrentCity"];
//        [[NSUserDefaults standardUserDefaults]setObject:@"43" forKey:@"YGCurrentAgentId"];
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        NSDictionary * dict = _ciNamesArray[indexPath.section-1];
        NSDictionary * dict = _ciNamesArray[indexPath.section];
        NSArray * array = dict[@"content"];
        cityModel * model = array[indexPath.row];
        [[NSUserDefaults standardUserDefaults]setObject:model.ciName forKey:@"YGCurrentCity"];
        [[NSUserDefaults standardUserDefaults]setObject:model.agentId forKey:@"YGCurrentAgentId"];
        [self.navigationController popViewControllerAnimated:YES];
        DebugLog(@"摇购选择城市的名字=%@代理商id=%@",model.ciName,model.agentId);
//    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
////        cityModel * model = _dataArray[0];
//        return nil;
//    }else{
//        NSDictionary *dict = _ciNamesArray[section-1];
        NSDictionary *dict = _ciNamesArray[section];
        NSString *title = dict[@"firstLetter"];
        tableView.tableHeaderView.tintColor = [UIColor darkGrayColor];
        return title;
//    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *resultArray = [NSMutableArray array];

    for (NSDictionary *dict in _ciNamesArray) {
        NSString *title = dict[@"firstLetter"];
        [resultArray addObject:title];
    }
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    return resultArray;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理

    //以下e.g.实现了将索引0对应到section 1里。其他的正常对应。

    if (index == 0) {
        return 1;
    }
    return index;

//    return index;
}





#pragma mark - 加载数据
-(void)loadData{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    [XLRequest AFPostHost:kbaseURL bindPath:kYGCityListStr postParam:dict isClient:NO getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DebugLog(@"摇购加载分类返回结果=%@",responseDic);
        if ([responseDic[@"code"] isEqual:@(0)]) {
            [self.ciNamesArray removeAllObjects];
            for (NSDictionary * ciDict in responseDic[@"data"]) {
                cityModel *citymodel = [cityModel cityWithDict:ciDict];
                [self.dataArray addObject:citymodel];
            }
            NSArray * array = [self.dataArray arrayWithPinYinFirstLetterFormat];
            self.ciNamesArray = [NSMutableArray arrayWithArray:array];

            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:responseDic[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络连接失败!"];
    }];
}



@end
