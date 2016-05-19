//
//  homeNewScuessPrizeVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/20.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "homeNewScuessPrizeVC.h"
#import "homeNewScuessCell.h"
#import "homeNewScuessModel.h"
#import "homeNewScuessDetailVC.h"

#define linNum 2
#define margin 1
#define kitemH 280

@interface homeNewScuessPrizeVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic) int index;
@property (nonatomic , strong) UICollectionView * collectionView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , copy) NSString * no;

@end

@implementation homeNewScuessPrizeVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最新揭晓";
    [self setLeft];

    [self addCollectionView];

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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - 添加collectionView
-(void)addCollectionView{
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight+49) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = YKYColor(242, 242, 242);
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake((kScreenWidth-linNum*margin-margin)/2, 270);
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"homeNewScuessCell" bundle:nil] forCellWithReuseIdentifier:@"homeNewScuessCell"];
}


#pragma mark - datascouce
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    homeNewScuessCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeNewScuessCell" forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[homeNewScuessCell alloc]init];
    }

    if (_dataArray.count == 0) {
        return cell;
    }
    cell.model = _dataArray[indexPath.row];

    return cell;
}

#pragma mark - delegate
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-linNum*margin-margin)/2+1, kitemH);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return margin;
}


//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    homeNewScuessDetailVC * vc = [[homeNewScuessDetailVC alloc]init];
    homeNewScuessModel * model = _dataArray[indexPath.item];
    vc.prizemodel = model;
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark - 数据加载
-(void)loadData{
    [self loadDataWithPage:@"0"];
    _index = 0;
    // 添加传统的上拉刷新
    __weak typeof (self) weakSelf = self;
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        weakSelf.index = weakSelf.index + 1;
        NSString *idx = [NSString stringWithFormat:@"%d",weakSelf.index];
        if ([weakSelf.no isEqualToString:@"1"]) {
            [weakSelf endrefreshing];
            return ;
        }
        [weakSelf loadDataWithPage:idx];
        [weakSelf endrefreshing];
    }];
}
-(void)endrefreshing{
    [self.collectionView.header endRefreshing];
    [self.collectionView.footer endRefreshing];
}
-(void)loadDataWithPage:(NSString *)page{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    NSMutableDictionary * paramete = [NSMutableDictionary dictionary];
    [paramete setValue:page forKey:@"pageNum"];

    NSString * bindPath = @"/yshakeUtil/getOpeneds";
    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:paramete isClient:NO getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        DebugLog(@"最新揭晓获取结果=%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            NSArray * array = [NSArray array];
            array = responseDic[@"data"];
            if (array.count == 0) {

                [MBProgressHUD showError:@"暂无更多记录"];
                self.no = @"1";
                _index = 0;
                return ;
            }
            for (NSDictionary * dict in responseDic[@"data"]) {
                homeNewScuessModel * model = [homeNewScuessModel modelWithDict:dict];
                [self.dataArray addObject:model];
            }
        }else{
            [MBProgressHUD showError:responseDic[@"msg"]];
        }
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _index = 0;
        DebugLog(@"最新揭晓获取失败error=%@===oper=%@",error,operation);
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"网络加载失败,请稍后!"];
    }];
}







@end
