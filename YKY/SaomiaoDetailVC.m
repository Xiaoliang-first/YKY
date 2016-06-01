//
//  SaomiaoDetailVC.m
//  YKY
//
//  Created by 肖 亮 on 16/5/30.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "SaomiaoDetailVC.h"
#import "unUsedPrizeModel.h"


#define kmagin 15


@interface SaomiaoDetailVC ()

@property(nonatomic , strong) UIScrollView * scrollView;

@end

@implementation SaomiaoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"奖品详情";
    [self setLeft];

    [self addSubView];
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




#pragma mark - 添加子控件
-(void)addSubView{
//scrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight)];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenheight);
    self.scrollView.backgroundColor = YKYColor(242, 242, 242);
    [self.view addSubview:self.scrollView];
//顶部承载view
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.4*kScreenheight)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:topView];

    //图片
    CGFloat magin = 10;
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, topView.height-50)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.model.url] placeholderImage:[UIImage imageNamed:@"prepare_loading_big"]];
    [topView addSubview:imgView];
    //奖品名称有效期价格
    CGFloat priceW= [getLabelHeight wigthWithConnect:@"¥ 18888.00" andHeight:15 font:[myFont getTitle3]];
    CGFloat pnameLH = [getLabelHeight heightWithConnect:_model.pname andLabelW:kScreenWidth-3*kmagin-priceW font:[myFont getTitle2]];
    UILabel * pnameL = [[UILabel alloc]initWithFrame:CGRectMake(kmagin, imgView.height+magin, kScreenWidth-3*kmagin-priceW, pnameLH)];
    UILabel * priceL = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-kmagin-priceW, pnameL.y+pnameL.height-15, priceW, 15)];
    pnameL.text = [NSString stringWithFormat:@"%@ (%@)",_model.pname,_model.etime];
    priceL.text = @"¥ 18888.00";
    pnameL.textColor = YKYTitleColor;
    priceL.textColor = [UIColor redColor];
    [topView addSubview:pnameL];
    [topView addSubview:priceL];
    //修改topview高度
    topView.frame = CGRectMake(0, 0, kScreenWidth, pnameL.y+pnameL.height+magin);


//中部使用规则
    UILabel * useLabel = [[UILabel alloc]initWithFrame:CGRectMake(kmagin, topView.height+kmagin, 200, 17)];
    useLabel.text = @"使用规则";
    useLabel.textColor = YKYTitleColor;
    [_scrollView addSubview:useLabel];

    //小点
    UIImageView * dianV = [[UIImageView alloc]initWithFrame:CGRectMake(kmagin, useLabel.y+useLabel.height+kmagin+8, 4, 4)];
    dianV.image = [UIImage imageNamed:@""];
    [_scrollView addSubview:dianV];
    CGFloat userLH = [getLabelHeight heightWithConnect:@"使用规则使用规则使用规则使用规则使用规则使用规则使用规则使用规则使用规则使用规则使用规则使用规则使用规则使用规则使用规则使用规则使用规则使用规则使用规则" andLabelW:kScreenWidth-2*kmagin font:[myFont getTitle3]];
    UILabel * dianL = [[UILabel alloc]initWithFrame:CGRectMake(2*kmagin, useLabel.y+useLabel.height+kmagin, kScreenWidth-3*kmagin, userLH)];
    [_scrollView addSubview:dianL];


//底部悬浮view 提示以及兑换按钮
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenheight-44, kScreenWidth, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];

    //提示文字和兑换按钮
    CGFloat btnW = 100;
    UILabel * tishiL = [[UILabel alloc]initWithFrame:CGRectMake(kmagin, 12, kScreenWidth-2*kmagin-btnW, 20)];
    tishiL.textColor = [UIColor redColor];
    tishiL.text = @"*请在商户员工知道下点击确认使用";
    tishiL.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    [bottomView addSubview:tishiL];

    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kmagin-btnW, 10, btnW, 24)];
    [btn setTitle:@"我要兑换" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(duihuan) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];
    //设置图片圆角
    btn.layer.cornerRadius = 8;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 0.01;


}

-(void)duihuan{

    

}





@end
