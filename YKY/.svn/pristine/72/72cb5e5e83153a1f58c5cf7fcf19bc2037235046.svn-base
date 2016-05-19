//
//  bossEnvirDetailVC.m
//  YKY
//
//  Created by 亮肖 on 15/6/12.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "bossEnvirDetailVC.h"
#import "UIImageView+WebCache.h"
#import "UIView+XL.h"
#import "bossEnvirModel.h"


@interface bossEnvirDetailVC ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *imagScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *imagePageControl;

@end

@implementation bossEnvirDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商家环境";

    if (self.imagesArray.count == 0) {
        return;
    }
    
    num = 0;//设置返回标志
    
    long imgsNumber = self.imagesArray.count;
    self.imagePageControl.numberOfPages = imgsNumber;
    self.imagScrollView.contentSize = CGSizeMake((self.view.frame.size.width)*imgsNumber, self.imagScrollView.height-104);
    self.imagScrollView.contentInset = UIEdgeInsetsMake(-64, 0,0,0);
    self.imagScrollView.delegate = self;
    self.imagScrollView.showsVerticalScrollIndicator = NO;
    self.imagScrollView.pagingEnabled = YES;
    
    //循环添加滚动内容
    for (int i = 0; i < imgsNumber; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        CGFloat iX = i*self.view.frame.size.width;
        CGFloat iY = 0;
        CGFloat iW = self.imagScrollView.width;
        CGFloat iH = self.imagScrollView.height;
        
        imageView.frame = CGRectMake(iX, iY, iW, iH-50);
        bossEnvirModel *model = self.imagesArray[i];
        NSString *string = [model.mimage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:string];
        [imageView sd_setImageWithURL:url];
        [self.imagScrollView addSubview:imageView];
    }
    
    //跳到点击的图片位置处
    [self.imagScrollView setContentOffset:CGPointMake(self.view.frame.size.width*self.index, 0)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
}

#pragma mark - 设置左导航nav
-(void)setLeftNavBtn{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 根据图片位置显示pegecontrol位置
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (int)(self.imagScrollView.contentOffset.x/self.view.frame.size.width+0.5);
    self.imagePageControl.currentPage = page;
}


@end
