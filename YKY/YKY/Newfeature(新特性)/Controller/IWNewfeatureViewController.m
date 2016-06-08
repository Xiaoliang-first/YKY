//
//  IWNewfeatureViewController.m
//  传智微博
//
//  Created by teacher on 14-6-7.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWNewfeatureViewController.h"
#import "homeTableBarVC.h"
#import "UIView+XL.h"
#import "common.h"
#import "severceDeal.h"
#import "Account.h"
#import "AccountTool.h"

#define IWNewfeatureImageCount 2

@interface IWNewfeatureViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl;


@property (nonatomic , strong) UIScrollView * scrollView;

@end

@implementation IWNewfeatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //用户数据清空
    [AccountTool saveAccount:nil];

    // 1.添加UISrollView
    [self setupScrollView];
    
    // 2.添加pageControl
//    [self setupPageControl];
}

/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    // 1.添加UISrollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    // 2.添加图片
    CGFloat imageW = self.scrollView.width;
    CGFloat imageH = self.scrollView.height;
    for (int i = 0; i<IWNewfeatureImageCount; i++) {
        // 创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name = [NSString stringWithFormat:@"nav%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        
        [self.scrollView addSubview:imageView];
        
        // 设置frame
        imageView.y = 0;
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.x = i * imageW;
        
        // 处理最后一个ImageView
        if (i == IWNewfeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置其他属性
    self.scrollView.contentSize = CGSizeMake(IWNewfeatureImageCount * imageW, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.backgroundColor = YKYColor(255, 62, 62);
    self.scrollView.backgroundColor = [UIColor whiteColor];

}

/**
 如果一个控件点击没有反应, 有哪些可能?
 1.控件自己的userInteractionEnabled\enabled = NO
 2.父控件(的父控件)的userInteractionEnabled\enabled = NO
 3.控件自己不在父控件的边框范围内
 */

/**
 *  处理最后一个imageView
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    // 0.让imageView可以跟用户进行交互
    imageView.userInteractionEnabled = YES;
    
    // 1.添加开始按钮
    [self setupStartButton:imageView];
}



/**
 *  添加开始按钮
 */
- (void)setupStartButton:(UIImageView *)imageView
{
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    [imageView addSubview:startButton];
    
    // 2.设置背景图片
    [startButton setBackgroundImage:[UIImage imageNamed:@"立即体验"] forState:UIControlStateNormal];

    // 3.设置frame
    startButton.size = startButton.currentBackgroundImage.size;
    startButton.centerX = self.view.width * 0.5;
    startButton.centerY = self.view.height * 0.89;
    
    // 4.设置开始时间
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  开始
 */
- (void)start
{
    // 显示状态栏
    UIApplication *app = [UIApplication sharedApplication];
    app.statusBarHidden = NO;
    UIWindow *window = app.keyWindow;
    // 切换window的rootViewController
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeTableBarVC *VC = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
    
    //清除新特性的轮播图，减轻设备压力，提高性能
    [self.scrollView removeFromSuperview];
    
    //第一次使用时需要同意服务协议
    NSString * first = [[NSUserDefaults standardUserDefaults]objectForKey:@"first"];
    
    if (![first isEqualToString:@"1"]) {//第一次使用
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        severceDeal *vc = [sb instantiateViewControllerWithIdentifier:@"severceDeal"];
        vc.identify = @"1";
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        window.rootViewController = VC;
    }
}



/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = IWNewfeatureImageCount;
    pageControl.centerX = self.view.width * 0.5;
    pageControl.centerY = self.view.height - 30;
    [self.view addSubview:pageControl];
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = YKYColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = YKYColor(189, 189, 189);
    self.pageControl = pageControl;
}

- (void)dealloc
{
//    IWLog(@"dealloc----");
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double ratio = scrollView.contentOffset.x / scrollView.width;
    int pageNo = (int)(ratio + 0.5); // 四舍五入
    self.pageControl.currentPage = pageNo;
}
@end