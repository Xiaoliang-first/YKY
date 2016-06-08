//
//  meLuckPrizeState.m
//  YKY
//
//  Created by 肖 亮 on 16/4/26.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meLuckPrizeState.h"
#import "homeNewScuessModel.h"
#import "routeMessageModel.h"
#import "meAdressMangerVC.h"
#import "YGPrizeDetailVC.h"

#define kmagin 15.0
#define h 40.0
#define th  35.0
#define titW 80.0
#define textH 17.0


@interface meLuckPrizeState ()

@property(nonatomic,strong)UIView * TopView;
@property (nonatomic , strong) UIView * midView;
@property (nonatomic , strong) UIView * bottomView;
@property (nonatomic , strong) UIButton * writeAddessBtn;
@property (nonatomic , strong) routeMessageModel * routeModel;

@end

@implementation meLuckPrizeState

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品状态";
    self.view.backgroundColor = YKYColor(242, 242, 242);
    [self setLeft];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addViews];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.TopView removeFromSuperview];
    [self.midView removeFromSuperview];
    [self.bottomView removeFromSuperview];
}

-(void)addViews{
    [self addTopView];
}
-(void)addTopView{
    self.TopView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 110)];
    self.TopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.TopView];


    UILabel * titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(kmagin, 0.5*(th-textH), titW, textH)];
    titlelabel.font = [UIFont systemFontOfSize:15];
    titlelabel.textColor = YKYTitleColor;
    titlelabel.textAlignment = NSTextAlignmentLeft;
    titlelabel.text = @"商品状态";
    [self.TopView addSubview:titlelabel];

    [line addLineWithFrame:CGRectMake(0, th-1, kScreenWidth, 1) andBackView:self.TopView];

    NSString * nowState = [[NSUserDefaults standardUserDefaults]objectForKey:@"prizeState-me"];
    if (nowState) {
        self.model.orderStatue = nowState;
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"prizeState-me"];
    }
    
    [self addCellsWithFrame:CGRectMake(0, th, kScreenWidth, _TopView.height-th) state:_model.orderStatue toView:self.TopView];
}


-(void)addCellsWithFrame:(CGRect)frame state:(NSString*)state toView:(UIView*)view{

    UIView *back = [[UIView alloc]initWithFrame:frame];
    back.backgroundColor = YKYClearColor;
    [view addSubview:back];


    if ([state isEqualToString:@"-1"]) {//未填写地址
        [self addcell1WithView:back];

        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(back.width-kmagin-70, 10+h, 70, 20)];
        [btn setBackgroundImage:[UIImage imageNamed:@"tx"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addAdreessBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [back addSubview:btn];

        self.TopView.frame = CGRectMake(0, 64, kScreenWidth, th+2*h);
        [self addMidView];
        [self addBottomView];
    }else if([state isEqualToString:@"0"]){//待发货
        [self addcell1WithView:back];
        [self addCell3WithView:back];
        self.TopView.frame = CGRectMake(0, 64, kScreenWidth, th+3*h);
        [self addMidView];
        [self addBottomView];
    }else if([state isEqualToString:@"1"]){//商家已发货
        [self loadMessage];
        self.TopView.frame = CGRectMake(0, 64, kScreenWidth, th+5*h);
        [self addMidView];
        [self addBottomView];
    }else if([state isEqualToString:@"2"]){//已完成
        [self loadMessage];
        self.TopView.frame = CGRectMake(0, 64, kScreenWidth, th+5*h);
        [self addMidView];
        [self addBottomView];
    }else if([state isEqualToString:@"3"]){//订单已摧毁
        [MBProgressHUD showError:@"该订单被自然灾害损毁,请联系客服!"];
    }
}

-(void)draw1Or2WithWithFrame:(CGRect)frame State:(NSString*)state toView:(UIView*)view{
    UIView *back = [[UIView alloc]initWithFrame:frame];
    back.backgroundColor = YKYClearColor;
    [view addSubview:back];

    if ([state isEqualToString:@"1"]) {
        [self addcell1WithView:back];
        if (_routeModel.otime) {
            UILabel * otimeL = [self labelTime:80+3*kmagin Y:h+0.5*(h-textH) text:_routeModel.otime];
            [back addSubview:otimeL];
        }
        [self addCell3WithView:back];
        [self addCell4WithView:back];
        [self addCell5ToView:back];
        self.writeAddessBtn = [[UIButton alloc]initWithFrame:CGRectMake(back.width-kmagin-60, 10+4*h, 60, 20)];
        [self.writeAddessBtn setBackgroundImage:[UIImage imageNamed:@"确认收货button"] forState:UIControlStateNormal];
        [back addSubview:self.writeAddessBtn];
        [self.writeAddessBtn addTarget:self action:@selector(querenshouhuoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self addcell1WithView:back];
        if (_routeModel.otime) {
            UILabel * otimeL = [self labelTime:80+3*kmagin Y:h+0.5*(h-textH) text:_routeModel.otime];
            [back addSubview:otimeL];
        }
        [self addCell3WithView:back];
        [self addCell4WithView:back];
        [self addCell6View:back];
    }
}
-(void)addCell6View:(UIView*)back{
    [line addLineWithFrame:CGRectMake(kmagin+2, 3.5*h+2, 1, h-10) andBackView:back];//竖线
    [line addLineWithFrame:CGRectMake(2*kmagin, 4*h-1, back.width-2*kmagin, 1) andBackView:back];
    UIImageView *gralyPoint_4 =[[UIImageView alloc]initWithFrame:CGRectMake(kmagin, 4*h+0.5*(h-5) , 5, 5)];
    gralyPoint_4.image = [UIImage imageNamed:@"大圆"];
    [back addSubview:gralyPoint_4];
    UILabel * sentLabel = [self labeTitleX:2*kmagin Y:4*h+0.5*(h-textH) text:@"已完成"];
    sentLabel.textColor = [UIColor redColor];
    [back addSubview:sentLabel];
    UILabel * sentTime = [self labelTime:sentLabel.x+sentLabel.width+8 Y:sentLabel.y text:_routeModel.rtime];
    [back addSubview:sentTime];
}

-(void)addCell5ToView:(UIView*)back{
    [line addLineWithFrame:CGRectMake(kmagin+2, 3.5*h+2, 1, h-10) andBackView:back];//竖线
    [line addLineWithFrame:CGRectMake(2*kmagin, 4*h-1, back.width-2*kmagin, 1) andBackView:back];
    UIImageView *gralyPoint_4 = [self gralyPointX:kmagin Y:4*h+0.5*(h-5)];
    [back addSubview:gralyPoint_4];
    UILabel * sentLabel = [self labeTitleX:2*kmagin Y:4*h+0.5*(h-textH) text:@"确认收货"];
    [back addSubview:sentLabel];
}

-(void)addCell4WithView:(UIView*)back{
    [line addLineWithFrame:CGRectMake(kmagin+2, 2.5*h+2, 1, h-10) andBackView:back];//竖线
    [line addLineWithFrame:CGRectMake(2*kmagin, 3*h-1, back.width-2*kmagin, 1) andBackView:back];
    UIImageView *gralyPoint_4 = [self gralyPointX:kmagin Y:3*h+0.5*(h-5)];
    [back addSubview:gralyPoint_4];
    UILabel * sentLabel = [self labeTitleX:2*kmagin Y:3*h+0.5*(h-textH) text:@"商家已发货"];
    [back addSubview:sentLabel];
    UILabel * sentTime = [self labelTime:sentLabel.x+sentLabel.width+8 Y:sentLabel.y text:_routeModel.stime];
    [back addSubview:sentTime];

}

-(void)addCell3WithView:(UIView*)back{
    [line addLineWithFrame:CGRectMake(kmagin+2, 1.5*h+2, 1, h-10) andBackView:back];//竖线
    [line addLineWithFrame:CGRectMake(2*kmagin, 2*h-1, back.width-(2*kmagin), 1) andBackView:back];
    UIImageView *gralyPoint_3 = [self gralyPointX:kmagin Y:2*h+0.5*(h-5)];
    [back addSubview:gralyPoint_3];
    UILabel * sentLabel = [self labeTitleX:2*kmagin Y:2*h+0.5*(h-textH) text:@"待商家发货"];
    [back addSubview:sentLabel];

}



-(void)addcell1WithView:(UIView*)back{
    UIImageView *gralyPoint_1=[self gralyPointX:kmagin Y:0.5*(h-5)];
    [back addSubview:gralyPoint_1];

    UILabel * labe1 = [self labeTitleX:2*kmagin Y:0.5*(h-textH) text:@"获取商品"];
    [back addSubview:labe1];
    NSRange ptRange = [_model.ptime rangeOfString:@"."];
    NSString * ptime = [_model.ptime substringToIndex:ptRange.location];
    UILabel * time_1 = [self labelTime:80+3*kmagin Y:labe1.y text:ptime];
    [back addSubview:time_1];
    [line addLineWithFrame:CGRectMake(gralyPoint_1.x+2, gralyPoint_1.y+5, 1, h-10) andBackView:back];
    [line addLineWithFrame:CGRectMake(labe1.x, h-1, back.width-labe1.x, 1) andBackView:back];
    UIImageView *gralyPoint_2 = [self gralyPointX:gralyPoint_1.x Y:gralyPoint_1.y+h];
    [back addSubview:gralyPoint_2];

    UILabel * title_2 = [self labeTitleX:labe1.x Y:labe1.y+h text:@"确认收货信息"];
    [back addSubview:title_2];
}

-(UILabel *)labeTitleX:(int)x Y:(int)y text:(NSString*)text {
    UILabel * la1 = [[UILabel alloc]initWithFrame:CGRectMake(x,y, 80, textH)];
    la1.font = [UIFont systemFontOfSize:13];
    la1.textColor=YKYTitleColor;
    la1.text = text;
    return la1;
}

-(UILabel *)labelTime:(int)x Y:(int)y text:(NSString*)text {
    UILabel * la1 = [[UILabel alloc]initWithFrame:CGRectMake(x,y,kScreenWidth-x-kmagin, textH)];
    la1.textAlignment=NSTextAlignmentRight;
    la1.font = [UIFont systemFontOfSize:12];
    la1.textColor=YKYDeTitleColor;
    la1.text = text;
    return la1;
}


-(UIImageView *) gralyPointX:(int)x Y:(int)y {

    UIImageView * imgV2 = [[UIImageView alloc]initWithFrame:CGRectMake(x, y , 5, 5)];
    imgV2.image = [UIImage imageNamed:@"小圆"];
    return imgV2;
}




-(void)addAdreessBtnClick{
    DebugLog(@"填写收货地址按钮被点击");
    meAdressMangerVC * vc = [[meAdressMangerVC alloc]init];
    vc.serialId = _model.serialId;
    vc.agentId = _model.agentId;
    vc.identify = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)querenshouhuoBtnClick{
    DebugLog(@"确认收货按钮被点击");
    [self getPrizeOk];
}



-(void)addMidView{
    self.midView = [[UIView alloc]initWithFrame:CGRectMake(0, self.TopView.y + self.TopView.height+10, kScreenWidth, th+3*h)];
    self.midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.midView];


    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(kmagin, 0.5*(th-textH), titW, textH)];
    label.text = @"物流信息";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = YKYTitleColor;
    [self.midView addSubview:label];
    [line addLineWithFrame:CGRectMake(0, th-1, kScreenWidth, 1) andBackView:self.midView];

    //产品名称
    [self labelWithX:kmagin Y:th+0.5*(h-textH) W:kScreenWidth-2*kmagin text:_model.pname isLeft:YES toView:self.midView];

    if ([_model.orderStatue isEqualToString:@"1"]) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(self.midView.width-kmagin-90, 0.5*(th-textH-2), 90, textH+2)];
        [btn setTitle:@"查看物流信息" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
        [btn setBackgroundImage:[UIImage imageNamed:@"继续摇购"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(lookWuLiu) forControlEvents:UIControlEventTouchUpInside];
        [self.midView addSubview:btn];
    }

    if ([_model.orderStatue isEqualToString:@"1"] || [_model.orderStatue isEqualToString:@"2"]) {
        [self labelWithX:kmagin Y:th+h W:kScreenWidth-2*kmagin text:[NSString stringWithFormat:@"物流公司：%@",_routeModel.lname] isLeft:YES toView:self.midView];
        [self labelWithX:kmagin Y:th+1.7*h W:kScreenWidth-2*kmagin text:[NSString stringWithFormat:@"物流单号：%@",_routeModel.lnumber] isLeft:YES toView:self.midView];

        self.midView.frame = CGRectMake(0, self.TopView.y+self.TopView.height+10, kScreenWidth, th+1.7*h+2*textH);
    }
}

-(void)labelWithX:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w text:(NSString*)text isLeft:(BOOL)isLeft toView:(UIView*)view{

    UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, textH)];
    la.font = [UIFont systemFontOfSize:13];
    la.textColor = YKYDeTitleColor;
    la.text = text;
    la.numberOfLines = 0;
    la.textAlignment = isLeft?NSTextAlignmentLeft:NSTextAlignmentRight;

    [view addSubview:la];
}

#pragma mark - 查看物流
-(void)lookWuLiu{
    DebugLog(@"查看物流按钮被点击");
    YGPrizeDetailVC * vc = [[YGPrizeDetailVC alloc]init];
    vc.vcTitle = @"查看物流";
    NSString * urlStr = [kbaseURL stringByAppendingString:[NSString stringWithFormat:@"/yshakeUtil/queryOrderLogistics?oid=%@",_model.orderId]];
    DebugLog(@"============urlStr=%@",urlStr);
    vc.requestUrl = [NSURL URLWithString:urlStr];
    [self.navigationController pushViewController:vc animated:YES];
}




-(void)addBottomView{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.midView.y + self.midView.height+10, kScreenWidth, th+2*h)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(kmagin, 0.5*(th-textH), 2*titW, textH)];
    label.text = @"收货人信息";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = YKYTitleColor;
    [self.bottomView addSubview:label];
    [line addLineWithFrame:CGRectMake(0, th-1, kScreenWidth, 1) andBackView:self.bottomView];

    if ([_model.orderStatue isEqualToString:@"1"] || [_model.orderStatue isEqualToString:@"2"]) {
        [self labelWithX:kmagin Y:th+0.5*(h-textH) W:90 text:self.routeModel.rname isLeft:YES toView:self.bottomView];

        [self labelWithX:kScreenWidth-kmagin-120 Y:th+0.5*(h-textH) W:120 text:[NSString stringWithFormat:@"%@",self.routeModel.rphone] isLeft:NO toView:self.bottomView];

         [self labelWithX:kmagin Y:th+h W:kScreenWidth-2*kmagin text:[NSString stringWithFormat:@"%@",self.routeModel.raddress] isLeft:YES toView:self.bottomView];

        self.bottomView.frame = CGRectMake(0, self.midView.y+self.midView.height+10, kScreenWidth, th+h+2*textH);
    }
}




-(void)getPrizeOk{
    NSString * bindPath = @"/yshakeCoupons/receivedConfirm";
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [parameter setValue:_model.orderId forKey:@"orderId"];
    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameter isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"确认收货结果=%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            [MBProgressHUD showSuccess:@"收货成功!"];
            self.model.orderStatue = @"2";
            [self.TopView removeFromSuperview];
            [self addTopView];
        }else{
            [MBProgressHUD showError:@"确认收货失败,请检查网络!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"确认收货失败,请检查网络!"];
    }];
}




-(void)loadMessage{
    NSString * bindPath = @"/yshakeCoupons/queryLogistics";
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [parameter setValue:_model.orderId forKey:@"orderId"];
    [MBProgressHUD showSuccess:@"加载中..." toView:self.view];
    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameter isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DebugLog(@"===获取物流信息%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            routeMessageModel * model = [routeMessageModel modelWithDict:responseDic[@"data"][0]];
            self.routeModel = model;
            self.routeModel.otime = model.otime;
            [self draw1Or2WithWithFrame:CGRectMake(0, th, kScreenWidth, _TopView.height-th) State:_model.orderStatue toView:self.TopView];
            [self.midView removeFromSuperview];
            [self.bottomView removeFromSuperview];
            [self addMidView];
            [self addBottomView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请稍后再试!"];
    }];
}


@end
