//
//  custonVIew.m
//  HLQ
//
//  Created by kevin on 15/3/26.
//  Copyright (c) 2015年 hyqy. All rights reserved.
//

#import "CustomVIew.h"
//#import "detailTableVC.h"

@interface CustomVIew ()<UIScrollViewDelegate>
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
@end

@implementation CustomVIew



- (void)layoutSubviews
{
    //1.添加scrollView
    CGFloat width = self.bounds.size.width;
    
    CGFloat height = self.bounds.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    scrollView.delegate = self;
    
    self.scrollView = scrollView;
    
    [self addSubview:scrollView];
    
    self.scrollView.bounces = NO;
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    scrollView.contentSize = CGSizeMake(self.imagesArray.count * width, 0);
;
    
    scrollView.pagingEnabled = YES;
    
    for (int i = 0; i < self.imagesArray.count; i ++ ) {
        UIImageView *imageView = [[UIImageView alloc] init];
        CGFloat imageX = i * width;
        CGFloat imageY = 0.f;
        imageView.frame = CGRectMake(imageX, imageY, width, height);
//        imageView.image = self.imagesArray[i];
        imageView.image = self.imagesArray[i];
        [self.scrollView addSubview:imageView];
    }
    
    //2.添加scrollView
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, height - 20, width, 20)];
    self.pageControl = pageControl;
    pageControl.numberOfPages = self.imagesArray.count;
    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    [self addSubview:pageControl];

    [super layoutSubviews];
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *detail = [sb instantiateViewControllerWithIdentifier:@"detail"];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:detail animated:YES completion:nil];
//    
//    
//}

- (void)addScrollTimer:(CGFloat)time
{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(nextImage) userInfo:nil repeats:YES];

    self.timer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)removeScrollTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)nextImage
{
    int currentPage = (int)  self.pageControl.currentPage;
    currentPage ++;
    if (currentPage == self.imagesArray.count ) {
        currentPage = 0;
    }
    
    CGFloat width = self.scrollView.bounds.size.width;
    CGPoint offSet = CGPointMake(width * currentPage, 0.f);
   
    [UIView animateWithDuration:0.2f animations:^{
        self.scrollView.contentOffset = offSet;
    }];
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = self.scrollView.contentOffset;
    CGFloat offsetX = offset.x;
    CGFloat width = self.scrollView.bounds.size.width;
    int pageNum = (offsetX  + 0.5 * width ) / width;
    self.pageControl.currentPage = pageNum;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
        [self removeScrollTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addScrollTimer:2.0];
}


@end
