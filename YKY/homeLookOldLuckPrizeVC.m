//
//  homeLookOldLuckPrizeVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/21.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "homeLookOldLuckPrizeVC.h"
#import "YGLookOldModel.h"
#import "YGLookOldItems.h"
#import "homeNewScuessDetailVC.h"

#define linNum 3
#define margin 1

@interface homeLookOldLuckPrizeVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , copy) NSString * no;
@property (nonatomic) int index;


@end

@implementation homeLookOldLuckPrizeVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _vcTitle;
    [self setLeft];
    [self setMyCollectionview];
    [self loadData];
}

#pragma mark - 创建collection
-(void)setMyCollectionview{

    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight+44) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = YKYColor(242, 242, 242);
    //    //设置headerView的尺寸大小
    //    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake((kScreenWidth-linNum*margin-margin)/3, 40);
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YGLookOldItems" bundle:nil] forCellWithReuseIdentifier:@"YGLookOldItems"];
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


#pragma mark - dataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YGLookOldItems * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YGLookOldItems" forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[YGLookOldItems alloc]init];
    }
    cell.indexNum = 1;
    cell.model = self.dataArray[indexPath.item];

    return cell;
}

#pragma mark - delegate
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-linNum*margin-margin)/3, 40);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return margin;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return margin;
}


//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YGLookOldItems *cell = (YGLookOldItems *)[collectionView cellForItemAtIndexPath:indexPath];
    UIView * hongView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
    hongView.backgroundColor = YKYColor(255, 0, 0);
    cell.titlesLabel.textColor = [UIColor whiteColor];
    cell.selectedBackgroundView = hongView;
    DebugLog(@"%d====row=%ld===item=%ld",cell.indexNum,(long)indexPath.row,(long)indexPath.item);

    BOOL isHaveOldVc = NO;
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[homeNewScuessDetailVC class]]) {
            YGLookOldModel * model = _dataArray[indexPath.item];
            ((homeNewScuessDetailVC*)vc).serialID = model.serialId;
            ((homeNewScuessDetailVC*)vc).pid = _pid;

            DebugLog(@"====%@====%@====%@",model.serialId,_serials,_pid);
            [self.navigationController popToViewController:vc animated:YES];
            isHaveOldVc = YES;
            break;
        }
    }
}

//取消点击item方法设置字体颜色为333333
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    YGLookOldItems *cell = (YGLookOldItems *)[collectionView cellForItemAtIndexPath:indexPath];
    UIView * hongView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
    hongView.backgroundColor = [UIColor whiteColor];
    cell.titlesLabel.textColor = YKYTitleColor;
    cell.selectedBackgroundView = hongView;
    DebugLog(@"%d====row=%ld===item=%ld",cell.indexNum,(long)indexPath.row,(long)indexPath.item);
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
    [paramete setValue:_pid forKey:@"pid"];

    NSString * bindPath = @"/yshakeUtil/getPastSerials";
    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:paramete isClient:NO getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        DebugLog(@"查看往期获取结果=%@",responseDic);
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
                YGLookOldModel * model = [YGLookOldModel modelWithDict:dict];
                [self.dataArray addObject:model];
            }
        }else{
            [MBProgressHUD showError:responseDic[@"msg"]];
        }
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _index = 0;
        DebugLog(@"查看往期获取失败error=%@===oper=%@",error,operation);
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"网络加载失败,请稍后!"];
    }];
}


@end
