//
//  CurruntZoneVC.m
//  一块摇
//
//  Created by 亮肖 on 15/4/23.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//


/********************** 城市切换 **********************/


#import "CurruntZoneVC.h"
#import "UIView+XL.h"
#import "common.h"
#import "cityCell.h"

#define kcityNumber _cityDataArray.count

@interface CurruntZoneVC ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

/** 城市数组 */
@property (nonatomic , strong) NSArray * cityDataArray;
/** 地区数组 */
@property (nonatomic , strong) NSArray * zoneDataArray;
@property(nonatomic,weak) UIButton * currentbutton;
@end

@implementation CurruntZoneVC

/** 第一次登陆时选择城市地区 */
+(void)initialize{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.cityDataArray = @[@"太原市",@"太原市",@"太原市",@"太原市",@"太原市",@"太原市",@"太原市",@"太原市",@"太原市",@"太原市",@"太原市",@"太原市",];
    
    
    
    [self setCitysWithTableViewCell];
}

- (void)setCitys{
    //设置scrollviw
    UIScrollView * cityScroll = [[UIScrollView alloc]init];
    cityScroll.frame = CGRectMake(10,74, (self.view.width-20)/2, self.view.height-84);
    cityScroll.scrollEnabled = YES;
    cityScroll.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    cityScroll.bounces = NO;
    cityScroll.showsHorizontalScrollIndicator = NO;
    cityScroll.contentSize = CGSizeMake((self.view.width-20)/2, kcityNumber*45+1);
    cityScroll.backgroundColor = YKYColor(80, 154, 248);
    [self.view addSubview:cityScroll];
    
    //设置按钮们
    CGFloat margin = 1;
    CGFloat X = margin;
    CGFloat firstY = margin;
    CGFloat W = (self.view.width-20)/2;
    CGFloat H = 44;
    for (int i = 0; i < kcityNumber; i++) {
        UIButton * btn = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor whiteColor];
        btn.frame = CGRectMake(X, (firstY+H)*i+margin , W-2, H);
        NSString *str = self.cityDataArray[i];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitle:str forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(touchbutton:) forControlEvents:UIControlEventTouchUpInside];
        [cityScroll addSubview:btn];
    }
}

-(void)touchbutton:(UIButton *)button
{
    NSLog(@"dianji");
//    if (self.currentbutton!=nil) {
//        self.currentbutton.selected=NO;
//    }
//    button.selected=YES;
//    self.currentbutton=button;
}
- (void)setCitysWithTableViewCell{
    
    UITableView *tabview = [[UITableView alloc]init];
    tabview.frame = CGRectMake(10, 74, (self.view.width-20)/2, kcityNumber*45+1-64);
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.backgroundColor = YKYColor(80, 154, 248);
    tabview.showsHorizontalScrollIndicator = NO;
    tabview.bounces = NO;
    tabview.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    
    tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tabview.separatorColor = YKYColor(80, 154, 248);
    
    [self.view addSubview:tabview];
    
    [tabview registerNib:[UINib nibWithNibName:@"cityCell" bundle:nil] forCellReuseIdentifier:@"cityCell"];
}

#pragma mark - 数据源方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cityDataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
    
    //设置cell内容
    NSString *titleStr = self.cityDataArray[indexPath.row];
    [cell.btn setTitle:titleStr forState:UIControlStateNormal];
    
    
    
    return cell;
}

@end
