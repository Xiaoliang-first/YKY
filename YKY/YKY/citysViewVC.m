//
//  citysViewVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/2.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "citysViewVC.h"
#import "common.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "cityModel.h"
#import "UIView+XL.h"
#import "NSString+PinYin.h"
#import "homeTableBarVC.h"
#import <CommonCrypto/CommonDigest.h>
#import "UMessage.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"


@interface citysViewVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

/** 组数据 */
@property (nonatomic , strong) NSMutableArray * sectionData;
/** 行数据 */
@property (nonatomic , strong) NSArray * rowsData;
/** section标题字母数组 */
@property (nonatomic , strong) NSMutableArray * cellTextsMutArray;
/** 热门城市模型数组 */
@property (nonatomic , strong) NSMutableArray * hotCitysArray;
/** ciNames数组 */
@property (nonatomic , strong) NSMutableArray * ciNamesArray;
@property (weak, nonatomic) IBOutlet UITextField *cityNameField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel;
@property (weak, nonatomic) IBOutlet UIView *hostCitysBackView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 遮盖半透明黑色Btn */
@property (nonatomic , strong) UIButton * blackBtn;

/** 持久化的数据源 */
@property (nonatomic , strong) NSMutableArray * dataAy;


@end

@implementation citysViewVC


- (NSMutableArray *)sectionData{
    if (_sectionData == nil) {
        self.sectionData = [[NSMutableArray alloc]init];
    }
    return _sectionData;
}
-(NSMutableArray *)ciNamesArray{
    if (_ciNamesArray == nil) {
        self.ciNamesArray = [[NSMutableArray alloc]init];
    }
    return _ciNamesArray;
}
-(NSMutableArray *)cellTextsMutArray{
    if (_cellTextsMutArray == nil) {
        self.cellTextsMutArray = [[NSMutableArray alloc]init];
    }
    return _cellTextsMutArray;
}
-(NSMutableArray *)hotCitysArray{
    if (_hotCitysArray == nil) {
        self.hotCitysArray = [[NSMutableArray alloc]init];
    }
    return _hotCitysArray;
}
- (NSArray *) rowsData{
    if (_rowsData == nil) {
        self.rowsData = [[NSArray alloc]init];
    }
    return _rowsData;
}
-(NSMutableArray *)dataAy{
    if (_dataAy == nil) {
        self.dataAy = [[NSMutableArray alloc]init];
    }
    return _dataAy;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cityNameField.delegate = self;
    
    self.navigationItem.title = @"服务地区";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //设置左导航
    [self setLeftBarBtn];
    
    //加载城市数据
    [self addCitysData];
    
}


-(void)setLeftBarBtn{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(LeftClick)];
    left.tintColor = [UIColor whiteColor];
    [left setImage:[UIImage imageNamed:@"jiantou-Left"]];
    self.navigationItem.leftBarButtonItem = left;
}
#pragma mark - 左导航按钮点击事件
-(void)LeftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - viewWillController方法
-(void)viewWillAppear:(BOOL)animated{
    //设置导航按钮们
    [self setLeftBarBtn];
    self.tabBarController.tabBar.hidden = YES;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentChooseCity"]) {
        self.currentCityLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentChooseCity"];
    }else{
        self.currentCityLabel.text = @"暂未选择";
    }
}

#pragma mark - 键盘消失事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.cityNameField resignFirstResponder];

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.blackBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight)];
    self.blackBtn.backgroundColor = [UIColor blackColor];
    self.blackBtn.alpha = 0.4f;
    [self.blackBtn addTarget:self action:@selector(blackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.blackBtn];

    //重新给数据源赋值
    self.ciNamesArray = [NSMutableArray arrayWithArray:self.dataAy];
    [self.tableView reloadData];

    return YES;
}
-(void)blackBtnClick:(UIButton *)btn{
    [btn removeFromSuperview];
    [self.cityNameField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self search];
    return YES;
}

-(void)search{
    [self.blackBtn removeFromSuperview];
    [self.cityNameField resignFirstResponder];
    //检索包含输入内容的ciname所在Model
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ciName CONTAINS %@",self.cityNameField.text];

    for (NSDictionary * dict in self.dataAy) {

        NSArray * array = dict[@"content"];//装着Model的array
        NSArray * filteredArray = [array filteredArrayUsingPredicate:predicate];//检索
        if (filteredArray.count>0) {
            //清空数据源
            [self.ciNamesArray removeAllObjects];
            //重新赛数据
            NSArray * array1 = [filteredArray arrayWithPinYinFirstLetterFormat];
            self.ciNamesArray = [NSMutableArray arrayWithArray:array1];
            //数据源有无数据的后续操作
            if (self.ciNamesArray.count>0) {
                [self.tableView reloadData];
            }else{
                [MBProgressHUD showError:@"未检索到该城市!"];
            }
            return;//这个“return”不可少，因为在for循环中改变了便利对象的Count
        }
    }
}

#pragma mark - 加载城市数据
-(void)addCitysData{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString * urlStr = kgetCityListStr;

    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] isEqual:@(0)]) {
            UIApplication *app = [UIApplication sharedApplication];
            [self.ciNamesArray removeAllObjects];
            app.networkActivityIndicatorVisible=NO;
            for (NSDictionary * ciDict in responseObject[@"AllCity"]) {
                cityModel *citymodel = [cityModel cityWithDict:ciDict];
                [self.sectionData addObject:citymodel];
            }
            NSArray * hotCitys = [[NSArray alloc]init];
            hotCitys = responseObject[@"HotCity"];
            if (hotCitys.count>0) {
                for (NSDictionary * ciDict in responseObject[@"HotCity"]) {
                    cityModel *citymodel = [cityModel cityWithDict:ciDict];
                    [self.hotCitysArray addObject:citymodel];
                }
            }
            NSArray * array = [self.sectionData arrayWithPinYinFirstLetterFormat];
            self.ciNamesArray = [NSMutableArray arrayWithArray:array];
            //保存新加载的城市数据数组
            self.dataAy = self.ciNamesArray;

            [self addHostCitysWithCitys:self.hotCitysArray];//添加热门城市
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请检查您的网络状况!"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - 加载热门城市
-(void)addHostCitysWithCitys:(NSMutableArray *)citys{
    
    CGFloat W = 105;
    CGFloat H = 35;
    CGFloat margin = (self.hostCitysBackView.width-3*W)/5;
    CGFloat Y = 1;

    if (citys.count == 0) {
        citys = self.sectionData;
    }

    int Num = (int)citys.count>6?6:(int)citys.count;
    for (int i = 0; i < Num; i++) {
        UIButton * hostBack = [[UIButton alloc]initWithFrame:CGRectMake(i*(margin + W)+margin, Y, W, H)];
        hostBack.tag = 200000+i;
        if (i>2) {
            hostBack.frame = CGRectMake((i-3)*(margin + W)+margin, self.hostCitysBackView.height-H-8, W, H);
        }
        cityModel * model = citys[i];
        NSString * string = model.ciName;
        [hostBack setTitle:string forState:UIControlStateNormal];
        hostBack.backgroundColor = [UIColor whiteColor];
        [hostBack setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        hostBack.titleLabel.font = [UIFont systemFontOfSize:14];
        [hostBack addTarget:self action:@selector(hostBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.hostCitysBackView addSubview:hostBack];
    }
}
#pragma mark - 热门城市按钮点击事件
- (void)hostBtnClick:(UIButton *)btn{

    switch (btn.tag) {
        case 200000+0:
            if (self.hotCitysArray.count < 3) {
                [self saveCityModelWithModel:self.sectionData[0]];
            }else{
                [self saveCityModelWithModel:self.hotCitysArray[0]];
            }
            break;
        case 200000+1:
            if (self.hotCitysArray.count < 3) {
                [self saveCityModelWithModel:self.sectionData[1]];
            }else{
                [self saveCityModelWithModel:self.hotCitysArray[1]];
            }
            break;
        case 200000+2:
            if (self.hotCitysArray.count < 3) {
                [self saveCityModelWithModel:self.sectionData[2]];
            }else{
                [self saveCityModelWithModel:self.hotCitysArray[2]];
            }
            break;
        case 200000+3:
            if (self.hotCitysArray.count < 3) {
                [self saveCityModelWithModel:self.sectionData[3]];
            }else{
                [self saveCityModelWithModel:self.hotCitysArray[3]];
            }
            break;
        case 200000+4:
            if (self.hotCitysArray.count < 3) {
                [self saveCityModelWithModel:self.sectionData[4]];
            }else{
                [self saveCityModelWithModel:self.hotCitysArray[4]];
            }
            break;
        case 200000+5:
            if (self.hotCitysArray.count < 3) {
                [self saveCityModelWithModel:self.sectionData[5]];
            }else{
                [self saveCityModelWithModel:self.hotCitysArray[5]];
            }
            break;
        case 200000+6:
            if (self.hotCitysArray.count < 3) {
                [self saveCityModelWithModel:self.sectionData[6]];
            }else{
                [self saveCityModelWithModel:self.hotCitysArray[6]];
            }
            break;
        case 200000+7:
            if (self.hotCitysArray.count < 3) {
                [self saveCityModelWithModel:self.sectionData[7]];
            }else{
                [self saveCityModelWithModel:self.hotCitysArray[7]];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - 保存选中的城市id
-(void)saveCityModelWithModel:(cityModel *)model{
    
    [[NSUserDefaults standardUserDefaults]setObject:model.ciId forKey:@"cityId"];
    [[NSUserDefaults standardUserDefaults]setObject:model.ciName forKey:@"cityName"];
    [[NSUserDefaults standardUserDefaults] setObject:model.agentId forKey:@"agentId"];


//    NSString * agt = [[NSUserDefaults standardUserDefaults]objectForKey:@"agentId"];
    NSString * isUpTag = [[NSUserDefaults standardUserDefaults]objectForKey:@"agientID-UMAliasTag"];
    if (isUpTag) {
        [UMessage removeAlias:[NSString stringWithFormat:@"yky_%@",isUpTag] type:@"yky_push" response:^(id responseObject, NSError *error) {
            DebugLog(@"==remove%@",responseObject);
        }];
    }

    if (model.agentId) {
        [UMessage addAlias:[NSString stringWithFormat:@"yky_%@",model.agentId] type:@"yky_push" response:^(id responseObject, NSError *error) {
            DebugLog(@"===re%@",responseObject);
            if ([responseObject[@"success"] isEqual:@"ok"]) {
                [[NSUserDefaults standardUserDefaults]setObject:model.agentId forKey:@"agientID-UMAliasTag"];
            }
        }];
    }
    
    self.currentCityLabel.text = model.ciName;
    [[NSUserDefaults standardUserDefaults]setObject:model.ciName forKey:@"currentChooseCity"];
    
//    NSString* str = [[NSUserDefaults standardUserDefaults]objectForKey:@"first"];

//    if (![str isEqualToString:@"1"]) {//第一次打开应用
        UIApplication *app = [UIApplication sharedApplication];
        UIWindow *window = app.keyWindow;
        // 切换window的rootViewController
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITableViewController *VC = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
        window.rootViewController = VC;

        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"first"];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}


#pragma mark - 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _ciNamesArray.count?_ciNamesArray.count:0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary * dict = _ciNamesArray[section];
    NSArray * array = dict[@"content"];
    return array.count?array.count:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        NSDictionary * dict = _ciNamesArray[indexPath.section];
        NSArray * array = dict[@"content"];
        cityModel * model = array[indexPath.row];
        cell.textLabel.text = model.ciName;
        return cell;
    }else{
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        NSDictionary * dict = _ciNamesArray[indexPath.section];
        NSArray * array = dict[@"content"];
        cityModel * model = array[indexPath.row];
        cell.textLabel.text = model.ciName;
    }
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *dict = _ciNamesArray[section];
    NSString *title = dict[@"firstLetter"];
    tableView.tableHeaderView.tintColor = [UIColor darkGrayColor];
    return title;
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
    
    //    if (index == 0) {
    //        return 1;
    //    }
    //    return index;
    
    return index;
}

#pragma mark - 代理

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

#pragma mark - 选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary * dict = _ciNamesArray[indexPath.section];
    NSArray * array = dict[@"content"];
    cityModel * model = array[indexPath.row];

    [[NSUserDefaults standardUserDefaults] setObject:model.ciName forKey:@"currentChooseCity"];
    
    [self saveCityModelWithModel:model];

    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.keyWindow;
    // 切换window的rootViewController
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITableViewController *VC = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
    window.rootViewController = VC;
    
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"first"];
}


#pragma mark - 搜索按钮点击事件（放大镜）
- (IBAction)seachBtnClick:(id)sender {
    
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



@end
