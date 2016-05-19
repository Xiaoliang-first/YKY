//
//  bossEnvironmentVC.m
//  YKY
//
//  Created by 亮肖 on 15/6/11.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "bossEnvironmentVC.h"
#import "AFNetworking.h"
#import "common.h"
#import "UIButton+WebCache.h"
#import "bossEnvirModel.h"
#import "prizeDetailModel.h"
#import "MBProgressHUD+MJ.h"
#import "bossEnvirDetailVC.h"


@interface bossEnvironmentVC ()

@property (nonatomic , strong)NSMutableArray *ImagesUrlstrArray;

@end

@implementation bossEnvironmentVC

#pragma mark - ***********懒加载数组**********
-(NSMutableArray *)ImagesUrlstrArray{
    if (_ImagesUrlstrArray == nil) {
        self.ImagesUrlstrArray = [[NSMutableArray alloc]init];
    }
    return _ImagesUrlstrArray;
}


#pragma mark - *********viewDidLoad方法********
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商家环境";

    self.view.backgroundColor = YKYColor(242, 242, 242);

    //加载商家环境图片
    [self loadBossImagesData];
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
    
    if (num == 0) {//（0）表示是从detail界面返回来的
        
    }else{//（1）表示是从上个界面push进来的
        [MBProgressHUD showMessage:@"加载中" toView:self.view];
        num = 1;
    }

    [self setLeftNavBtn];
}

#pragma mark - *********加载商家环境的图片*********
-(void)loadBossImagesData{
    
    [MBProgressHUD showMessage:@"加载中" toView:[[self.view subviews]lastObject]];
    
    NSString *str = kbossEnvironmentStr;
    
    NSDictionary *parameters = [[NSDictionary alloc]init];
    

    if (self.prizeDetailModel.mid == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"没有数据"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    parameters = @{@"mId":self.prizeDetailModel.mid};

    DebugLog(@"==%@",parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DebugLog(@"商家环境数据请求结果==%@",responseObject);
        if ([responseObject[@"code"] isEqual:@(0)]) {
            NSArray * array = responseObject[@"data"];
            if (array.count == 0) {
                [MBProgressHUD showError:@"暂时没有数据"];
                if (_ImagesUrlstrArray.count == 0) {
                    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(goBack) userInfo:nil repeats:NO];
                }
                return ;
            }
            for (NSDictionary * dict in array) {
                bossEnvirModel *model = [bossEnvirModel modelWithDict:dict];
                [self.ImagesUrlstrArray addObject:model];
            }
            [self addButtonsWithModel:self.ImagesUrlstrArray];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
            return ;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - *******添加图片按钮********
-(void)addButtonsWithModel:(NSMutableArray *)dataArray{

//    self.ImagesUrlstrArray = model.imagesUrlArray;
//    NSArray *images = model.imagesUrlArray;
    //添加承载商家环境图片的Btns
    CGFloat lines = 2;//列数
    CGFloat btnsMargin = 20;//图片间的间隔
    CGFloat btnFirstX = btnsMargin;//第一个图片的x值
    CGFloat btnFirstY = 84;//第一个图片的y值
    CGFloat btnW = (self.view.frame.size.width-((lines+1)*btnsMargin))/lines;//图片的宽度
    CGFloat btnH = btnW*0.8;//图片的高度
    

    NSMutableArray *btns = [[NSMutableArray alloc]init];
    for (int i = 0; i< dataArray.count; i++) {
        CGFloat iRow = i/2;//第i个item所处的行号
        CGFloat iLine = i%2;//第i个item所处的列号
        CGFloat iX = btnFirstX+iLine*(btnsMargin+btnW);//第i个item的x值
        CGFloat iY = btnFirstY+iRow*(btnsMargin+btnH);//第i个item的Y值
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(iX, iY, btnW, btnH)];
        [self.view addSubview:btn];
        btn.tag = i+900;
        [btns addObject:btn];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 0.01;
        //给Btn添加图片
        [self imagesClickWihtBtns:btn model:dataArray];
    }
}

#pragma mark - ********按钮加载图片********
- (void)imagesClickWihtBtns:(UIButton *)btn model:(NSMutableArray *)array {
    
    NSArray *images = array;

    bossEnvirModel *model = images[btn.tag-900];
    
    NSString *str = [model.mimage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:str];

    [btn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"prepareloading_small"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //图片加载完成，停止风火轮转动
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
    [btn addTarget:self action:@selector(btnsClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - ********对应按钮的点击事件********
-(void)btnsClick:(UIButton*)btn{
    
    if (self.view.frame.size.height > 668.0f) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        bossEnvirDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"bossEnvirDetailVC-6"];
        if (self.ImagesUrlstrArray.count == 0) {
            [MBProgressHUD showError:@"环境图片为空!"];
            return;
        }
        vc.imagesArray = self.ImagesUrlstrArray;
        vc.index = btn.tag-900;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        bossEnvirDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"bossEnvirDetailVC"];
        if (self.ImagesUrlstrArray.count == 0) {
            [MBProgressHUD showError:@"环境图片为空!"];
            return;
        }
        vc.imagesArray = self.ImagesUrlstrArray;
        vc.index = btn.tag-900;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
