//
//  yaogouDetailVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/6.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "yaogouDetailVC.h"
#import "homeNewScuessModel.h"
#import "SDCycleScrollView.h"
#import "XLProgressBarView.h"
#import "YGCurrentyaogouList.h"
#import "YGPrizeDetailVC.h"
#import "YGLookOldVC.h"
#import "Account.h"
#import "AccountTool.h"
#import "jumpSafairTool.h"
#import "yaogouRockVC.h"
#import "YGBannerModel.h"
#import "jiaVC.h"

#define backClor YKYColor(242, 242, 242)

@interface yaogouDetailVC ()<UIScrollViewDelegate>

/** 最后边的滚动View */
@property (nonatomic , strong) UIScrollView * scrollView;
/** //顶部承载view */
@property (nonatomic , strong) UIView * topBackView;
/** 广告轮播器的滚动View */
@property (nonatomic , strong) SDCycleScrollView * adView;
/** 广告轮播期承载view */
@property (nonatomic , strong) UIView * adBackView;
/** 进度条 */
@property (nonatomic , strong) XLProgressBarView * progresView;
/** 总需人次label */
@property (nonatomic , strong) UILabel * zongLabel;
/** 剩余人次label */
@property (nonatomic , strong) UILabel * shengLabel;
/** 中部承载view */
@property (nonatomic , strong) UIView * midBackView;
/** 底部View */
@property (nonatomic , strong) UIView * bottomView;
/** 底部摇购按钮 */
@property (nonatomic , strong) UIButton * rockBtn;
/** 网络请求的详情数据字典 */
@property (nonatomic , strong) NSDictionary * data;
/** 名字label */
@property (nonatomic , strong) XLTextLabel * textLabel;
/** banner模型数组 */
@property (nonatomic , strong) NSMutableArray * bannerUrls;

@property (nonatomic , strong) UILabel * serilasLabel;


@end


@implementation yaogouDetailVC

-(NSMutableArray *)bannerUrls{
    if (_bannerUrls == nil) {
        self.bannerUrls = [[NSMutableArray alloc]init];
    }
    return _bannerUrls;
}
-(NSDictionary *)data{
    if (_data == nil) {
        self.data = [[NSDictionary alloc]init];
    }
    return _data;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"摇购详情";
    [self setLeft];
    self.view.backgroundColor = [UIColor whiteColor];

    //1.添加scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight+50)];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = YKYClearColor;
    _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenheight);
    //    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    //加载网络数据
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [self.topBackView addSubview:self.adBackView];
    self.adBackView.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.adBackView.hidden = YES;
    [self.adBackView removeFromSuperview];
}

-(void)addSubViews{
    //1.添加顶部固定控件
    [self addTopViews];
}

#pragma mark - 添加固定控件
-(void)addTopViews{
    CGFloat vMagin = 8.0f;
    CGFloat hMagin = 15;
    //2.顶部固定backView
    _topBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.45*kScreenheight)];
    _topBackView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_topBackView];
    //2.1轮播图承载view
    _adBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.6*_topBackView.height)];
    _adBackView.backgroundColor = [UIColor grayColor];
    [_topBackView addSubview:_adBackView];


    //2.2介绍详情的label
    _textLabel = [[XLTextLabel alloc]init];
    _textLabel.text = @"奖品名称       ";
    _textLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    [_textLabel setFrames:CGRectMake(hMagin,_adBackView.y+_adBackView.height+vMagin, _adBackView.width-2*hMagin, 28)];
    _textLabel.numberOfLines = 0;
    _textLabel.textColor = [UIColor darkGrayColor];
    [_topBackView addSubview:_textLabel];


    //期号
    self.serilasLabel = [[UILabel alloc]initWithFrame:CGRectMake(_textLabel.x, _textLabel.y+_textLabel.height+8, kScreenWidth, 20)];
    _serilasLabel.text = [NSString stringWithFormat:@"期号：%@",_prizeModel.serials];;
    _serilasLabel.textColor = YKYDeTitleColor;
    _serilasLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    [_topBackView addSubview:_serilasLabel];


    //2.3进度条
    _progresView = [[XLProgressBarView alloc]initWithFrame:CGRectMake(_serilasLabel.x, _serilasLabel.y+_serilasLabel.height+5, kScreenWidth-2*hMagin, 8) backgroundImage: [UIImage imageNamed:@"progressBack"] foregroundImage:[UIImage imageNamed:@"progress"]];
    if (_prizeModel.zongNum && _prizeModel.shengNum) {
        _progresView.progress = ([_prizeModel.zongNum floatValue]-[_prizeModel.shengNum floatValue])/[_prizeModel.zongNum floatValue];
    }else{
        _progresView.progress = 0.58f;
    }
    [_topBackView addSubview:_progresView];
    
    //2.4总需人次跟剩余人次
    _zongLabel = [[UILabel alloc]initWithFrame:CGRectMake(_progresView.x, _progresView.y+_progresView.height+vMagin, 0.5*_progresView.width, 15)];
    _zongLabel.textColor = YKYDeTitleColor;
    _zongLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    _zongLabel.textAlignment = NSTextAlignmentLeft;
    _zongLabel.text = [NSString stringWithFormat:@"总需%@人次",_prizeModel.zongNum];
    [_topBackView addSubview:_zongLabel];


    _shengLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.5*_topBackView.width, _zongLabel.y, _zongLabel.width, _zongLabel.height)];
    NSString * red1 = [NSString stringWithFormat:@"<font size=\"4\" color=\"red\">%@</font>",_prizeModel.shengNum];
    NSString * gray1 = @"<font size=\"4\" color=\"#666666\">剩余</font>";
    NSString * gray2 = @"<font size=\"4\" color=\"#666666\">人次</font>";
    NSString * plimit = [NSString stringWithFormat:@"%@%@%@",gray1,red1,gray2];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[plimit dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _shengLabel.attributedText = attrStr;

    _shengLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    _shengLabel.textAlignment = NSTextAlignmentRight;
    [_topBackView addSubview:_shengLabel];


    //改变backView的高度
    _topBackView.size = CGSizeMake(_topBackView.width, _zongLabel.y+_zongLabel.height+20);
}

#pragma mark - 添加中部cells
-(void)addMiddleViews{
    int num = 3;
    CGFloat H = 44;
    CGFloat margin = 15;
    _midBackView = [[UIView alloc]initWithFrame:CGRectMake(0, _topBackView.y+_topBackView.height+10, kScreenWidth, num*H)];
    _midBackView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_midBackView];
    NSArray * array = @[@"该奖品摇购记录",@"图文详情",@"查看往期",@"晒单分享"];
    for (int i = 0; i < num; i++) {
        //单个承载view
        UIView * oneBack = [[UIView alloc]initWithFrame:CGRectMake(0, i*H, kScreenWidth, H)];
        oneBack.backgroundColor = [UIColor clearColor];
        [_midBackView addSubview:oneBack];
        //titleLabel
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, 10, 200, 20)];
        titleLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = YKYTitleColor;
        titleLabel.text = array[i];
        [oneBack addSubview:titleLabel];
        //右箭头
        CGFloat imgW = 7.0f;
        CGFloat imgH = 13.0f;
        UIImageView * rigImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-margin-imgW, 0.5*(H-imgH), imgW, imgH)];
        rigImgView.image = [UIImage imageNamed:@"jiantou_me"];
        [oneBack addSubview:rigImgView];
        //line
        [line addLineWithFrame:CGRectMake(0, H-1, kScreenWidth, 1) andBackView:oneBack];
        //btns
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, H)];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 3234+i;
        [btn addTarget:self action:@selector(midBtnsClick:) forControlEvents:UIControlEventTouchUpInside];
        [oneBack addSubview:btn];
    }
}

#pragma mark - 添加底部view
-(void)addBottomView{
    CGFloat Hmagin = 15;
    CGFloat w = kScreenWidth-2*Hmagin;
    CGFloat h = 40;
//    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _midBackView.y+_midBackView.height+10, kScreenWidth, 0.6*_topBackView.height)];
//    _bottomView.backgroundColor = [UIColor whiteColor];
//    [_scrollView addSubview:_bottomView];
    //摇购按钮
    _rockBtn = [[UIButton alloc]initWithFrame:CGRectMake(Hmagin, kScreenheight-Hmagin-1-h, w, h)];
    [self.view addSubview:_rockBtn];
    //设置图片圆角
    _rockBtn.layer.cornerRadius = 5;
    _rockBtn.layer.masksToBounds = YES;
    _rockBtn.layer.borderWidth = 0.01;
    _rockBtn.backgroundColor = [UIColor redColor];
    _rockBtn.titleLabel.textColor = [UIColor whiteColor];
    DebugLog(@"=====剩余次数%@",_prizeModel.shengNum);
    if ([_prizeModel.shengNum isEqualToString:@"0"]) {
        [_rockBtn setTitle:@"继续摇购" forState:UIControlStateNormal];
        [_rockBtn addTarget:self action:@selector(lijiyaogou) forControlEvents:UIControlEventTouchUpInside];
    }else if ([_prizeModel.joinCount isEqual:_prizeModel.plimit]){//已摇满
        [_rockBtn setTitle:@"您已摇满" forState:UIControlStateNormal];
    }else{
        [_rockBtn setTitle:@"立即摇购" forState:UIControlStateNormal];
        [_rockBtn addTarget:self action:@selector(lijiyaogou) forControlEvents:UIControlEventTouchUpInside];
    }
    [_bottomView addSubview:_rockBtn];
    //调整scrollView 的 Size
    _scrollView.contentSize = CGSizeMake(kScreenWidth, _midBackView.y+_midBackView.height+100+2*Hmagin+_rockBtn.height);

    if (iPhone6 || iPhone6plus) {
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenheight + _rockBtn.height);
    }
}

#pragma mark - 中部cell点击事件
-(void)midBtnsClick:(UIButton* )btn{
    //摇购记录vc
    YGCurrentyaogouList * jiluVC = [[YGCurrentyaogouList alloc]init];
    jiluVC.serailId = _data[@"serialId"];
    //图文详情vc
    YGPrizeDetailVC * xqVC = [[YGPrizeDetailVC alloc]init];
    xqVC.vcTitle = @"图文详情";
    xqVC.requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/yshakeUtil/shakeProductDetial?pid=%@",kbaseURL,_data[@"pid"]]];

    //查看往期vc
    YGLookOldVC * lookOldVC = [[YGLookOldVC alloc]init];
    lookOldVC.vcTitle = @"查看往期";
    lookOldVC.pid = _data[@"pid"];
    lookOldVC.serials = _data[@"serials"];


    NSInteger num = btn.tag-3234;
    switch (num) {
        case 0:
            DebugLog(@"该奖品摇购记录");
            [self.navigationController pushViewController:jiluVC animated:YES];
            break;
        case 1:
            DebugLog(@"奖品详情");
            [self.navigationController pushViewController:xqVC animated:YES];
            break;
        case 2:
            DebugLog(@"查看往期");
            [self.navigationController pushViewController:lookOldVC animated:YES];
            break;
        case 3:
            DebugLog(@"晒单分享");
            break;

        default:
            break;
    }
}


-(void)lijiyaogou{
    DebugLog(@"立即摇购被点击");
//    yaogouRockVC * rockVC = [[yaogouRockVC alloc]init];
//    rockVC.model = _prizeModel;
//    rockVC.isRocking = @"0";
//    [self.navigationController pushViewController:rockVC animated:YES];


    Account * account = [AccountTool account];
    if (!account) {//没有用户登录
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示:" message:@"亲~您还未登录账号哦!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
        [alert show];
        return;
    }
    jumpSafairTool * tool = [[jumpSafairTool alloc]init];
    if ([tool jumpOrNo]) {//需要跳转到safair
        
        NSString * agentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentAgentId"];
        if (!agentId) {
            agentId = @"10";
        }
        NSString * ip = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIP"];
        NSString * seriaiId = _prizeModel.serialId;

        NSString * str = [NSString stringWithFormat:@"%@/iosyg/index.jsp?c=%@&t=%@&u=%@&a=%@&s=%@&ip=%@",kbaseURL,Kclient,account.reponseToken,account.uiId,agentId,seriaiId,ip];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

//        jiaVC * vc = [[jiaVC alloc]initWithNibName:@"jiaVC" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];

    }else{//正常执行程序
        yaogouRockVC * rockVC = [[yaogouRockVC alloc]init];
        rockVC.model = _prizeModel;
        rockVC.isRocking = @"0";
        [self.navigationController pushViewController:rockVC animated:YES];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self jumpToMyAccountVC];
            break;

        default:
            break;
    }
}

-(void)jixuyaogou{
    DebugLog(@"继续摇购被点击");
    [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark - 设置界面信息
-(void)setDataWithModel{
    DebugLog(@"\n===prizeModel的===prizeName=%@\n=prizeUrl=%@\n=plimit=%@\n=zongNum=%@\n=shengNum=%@\n=oderNum=%@\n=pid=%@\n",_prizeModel.pname,_prizeModel.headImage,_prizeModel.plimit,_prizeModel.zongNum,_prizeModel.shengNum,_prizeModel.serials,_prizeModel.pid);

    //添加固定控件
    [self addSubViews];

    [self addTopAdScrollView];//添加banner

    //设置界面数据
    if (_data[@"plimit"] && [_data[@"plimit"] isEqual:@0]) {
        [_textLabel removeFromSuperview];
        NSString * text = [NSString stringWithFormat:@"%@",_data[@"pname"]];
        //2.2介绍详情的label
        _textLabel = [[XLTextLabel alloc]init];
        _textLabel.text = text;
        _textLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
        [_textLabel setFrames:CGRectMake(15,_adBackView.y+_adBackView.height+8, _adBackView.width-2*15, 28)];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor darkGrayColor];
        [_topBackView addSubview:_textLabel];

        //期号
        self.serilasLabel.frame = CGRectMake(_textLabel.x, _textLabel.y+_textLabel.height+8, kScreenWidth, 20);
        _serilasLabel.text = [NSString stringWithFormat:@"期号：%@",_data[@"serials"]];
//        [_topBackView addSubview:_serilasLabel];


        _progresView.frame = CGRectMake(_serilasLabel.x, _serilasLabel.y+_serilasLabel.height+5, kScreenWidth-2*15, 8);

        _zongLabel.frame = CGRectMake(_progresView.x, _progresView.y+_progresView.height+8, 0.5*_progresView.width, 15);

        _shengLabel.frame = CGRectMake(0.5*_topBackView.width, _zongLabel.y, _zongLabel.width, _zongLabel.height);

        //改变backView的高度
        _topBackView.size = CGSizeMake(_topBackView.width, _zongLabel.y+_zongLabel.height+20);

        [line addLineWithFrame:CGRectMake(0, self.topBackView.height+self.topBackView.y, kScreenWidth, 10) andBackView:self.scrollView];
//2.添加中部选择cell
        [self addMiddleViews];
        [line addLineWithFrame:CGRectMake(0, self.midBackView.height+self.midBackView.y, kScreenWidth, 10) andBackView:self.scrollView];
//3.添加底部固定提示图
        [self addBottomView];

    }else{
        [_textLabel removeFromSuperview];
        NSString * text = [NSString stringWithFormat:@"%@  (第%@期)  (限摇%@人次)",_data[@"pname"],_data[@"serials"],_data[@"plimit"]];
        //2.2介绍详情的label
        _textLabel = [[XLTextLabel alloc]init];
        _textLabel.text = text;
        _textLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
        [_textLabel setFrames:CGRectMake(15,_adBackView.y+_adBackView.height+8, _adBackView.width-2*15, 28)];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor darkGrayColor];
        [_topBackView addSubview:_textLabel];


        //期号
        self.serilasLabel.frame = CGRectMake(_textLabel.x, _textLabel.y+_textLabel.height+8, kScreenWidth, 20);
        _serilasLabel.text = [NSString stringWithFormat:@"期号：%@",_data[@"serials"]];

        _progresView.frame = CGRectMake(_serilasLabel.x, _serilasLabel.y+_serilasLabel.height+5, kScreenWidth-2*15, 8);

        _zongLabel.frame = CGRectMake(_progresView.x, _progresView.y+_progresView.height+8, 0.5*_progresView.width, 15);

        _shengLabel.frame = CGRectMake(0.5*_topBackView.width, _zongLabel.y, _zongLabel.width, _zongLabel.height);

        //改变backView的高度
        _topBackView.size = CGSizeMake(_topBackView.width, _zongLabel.y+_zongLabel.height+20);

        [line addLineWithFrame:CGRectMake(0, self.topBackView.height+self.topBackView.y, kScreenWidth, 10) andBackView:self.scrollView];
//2.添加中部选择cell
        [self addMiddleViews];
        [line addLineWithFrame:CGRectMake(0, self.midBackView.height+self.midBackView.y, kScreenWidth, 10) andBackView:self.scrollView];
//3.添加底部固定提示图
        [self addBottomView];
    }

    self.zongLabel.text = [NSString stringWithFormat:@"总需%@人次",_data[@"price"]];
    
    NSString * red1 = [NSString stringWithFormat:@"<font size=\"4\" color=\"red\">%@</font>",_data[@"restNum"]];
    NSString * gray1 = @"<font size=\"4\" color=\"#666666\">剩余</font>";
    NSString * gray2 = @"<font size=\"4\" color=\"#666666\">人次</font>";
    NSString * plimit = [NSString stringWithFormat:@"%@%@%@",gray1,red1,gray2];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[plimit dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _shengLabel.attributedText = attrStr;

    _shengLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    _shengLabel.textAlignment = NSTextAlignmentRight;

    CGFloat zong = [_data[@"price"] floatValue];
    CGFloat sheng = [_data[@"restNum"] floatValue];
    _progresView.progress = (zong-sheng)/zong;

}
#pragma mark - 添加banner滚动图片
- (void)addTopAdScrollView{
    NSMutableArray * imgs = [[NSMutableArray alloc]init];
    for (YGBannerModel *model in self.bannerUrls) {
        //将请求回来的URL字符串转换为URl
        NSURL * url = [NSURL URLWithString:model.banner];
        //添加URL到图片URL数组
        [imgs addObject:url];
    }
    self.adView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.adBackView.frame.size.height) imageURLsGroup:imgs];

//    self.adView.delegate = self;
    self.adView.autoScrollTimeInterval = 2.0;
    [self.adView.mainView reloadData];
    [self.adBackView addSubview:self.adView];
}



#pragma mark - 下拉刷新数据
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    DebugLog(@"_scrollView.contentOffset.y=%f",_scrollView.contentOffset.y);
    DebugLog(@"摇购详情可以刷新数据啦");

    if (_scrollView.contentOffset.y < -77.0) {
        [_topBackView removeFromSuperview];
        [_midBackView removeFromSuperview];
        [_bottomView removeFromSuperview];
        [_rockBtn removeFromSuperview];
        for (UIView * view in _scrollView.subviews) {
            [view removeFromSuperview];
        }
        [self loadData];
    }
}






#pragma mark - 加载数据
-(void)loadData{
    NSString * bindPath = @"/yshakeUtil/detailCloud";

    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    if (_serialID) {
        [parameters setValue:_serialID forKey:@"serailId"];
    }else{
        [parameters setValue:self.prizeModel.serialId forKey:@"serailId"];
    }

    [MBProgressHUD showMessage:@"刷新中..." toView:self.view];
    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameters isClient:NO getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DebugLog(@"摇购列表详情获取结果=%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            self.data = responseDic[@"data"][0];
            if ([_data[@"restNum"] isEqual:@0]) {
                [MBProgressHUD showError:@"该期已结束!"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self loadBanner];//加载顶部banner数据
            }
        }else{
            [MBProgressHUD showError:responseDic[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败!"];
//        [self.navigationController popViewControllerAnimated:YES];
        DebugLog(@"摇购列表详情获取失败==error=%@===oper=%@",error,operation);
    }];
}

-(void)loadBanner{
    [self.bannerUrls removeAllObjects];
    NSString * bindPath = @"/yshakeUtil/getBanner";
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.prizeModel.pid forKey:@"pid"];
    
    DebugLog(@"model.pid = %@ ===data.pid=%@",self.prizeModel.pid,_data[@"pid"]);
//    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameters isClient:NO getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DebugLog(@"摇购列表详情获取banner=%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            NSArray * array = [NSArray arrayWithArray:responseDic[@"data"]];
            if (array.count == 0) {
                DebugLog(@"广告轮播图获取失败");
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }
            for (NSDictionary * dic in responseDic[@"data"]) {
                YGBannerModel * model = [YGBannerModel modelWithDict:dic];
                [self.bannerUrls addObject:model];
            }
            //设置界面信息
            [self setDataWithModel];
        }else{
            [MBProgressHUD showError:responseDic[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败!"];
        [self.navigationController popViewControllerAnimated:YES];
        DebugLog(@"摇购列表详情获取banner失败==error=%@===oper=%@",error,operation);
    }];
}




-(void)jumpToMyAccountVC{
    Account * account2 = [AccountTool account];
    if (account2) {
        //实现当前用户注销（就是把 account.data文件清空）
        account2 = nil;
        [AccountTool saveAccount:account2];
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }else{
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }
}



@end
