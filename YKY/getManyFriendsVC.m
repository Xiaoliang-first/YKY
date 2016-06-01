//
//  getManyFriendsVC.m
//  YKY
//
//  Created by 肖 亮 on 16/5/31.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "getManyFriendsVC.h"
#import "getFriendsCell.h"
#import "getFriendModel.h"

@interface getManyFriendsVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;

@end

@implementation getManyFriendsVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友明细";
    [self setLeft];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"getFriendsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"getFriendsCell"];

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    getFriendsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"getFriendsCell"];

    if (cell == nil) {
        cell = [[getFriendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"getFriendsCell"];
    }
    if (_dataArray.count == 0 || _dataArray.count<indexPath.row) {
        return cell;
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}





-(void)loadData{

    NSDictionary * dic = @{@"phone":@"13716344285",@"signtime":@"2016-05-20",@"diamondsnum":@"2"};

    getFriendModel * model = [getFriendModel modelWithDict:dic];
    [self.dataArray addObject:model];
    [self.tableView reloadData];

    
}


@end
