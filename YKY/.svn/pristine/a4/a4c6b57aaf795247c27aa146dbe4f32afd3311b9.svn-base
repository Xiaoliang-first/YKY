//
//  hopyVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/11.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "hopyVC.h"
#import "UIView+XL.h"
#import "smallBtnsView.h"


@interface hopyVC ()



@property (weak, nonatomic) IBOutlet UIView *eatBackView;

@property (weak, nonatomic) IBOutlet UIView *playBackView;

@property (nonatomic , strong) smallBtnsView * smallButtonsView;
/** 用于存放小按钮名字内容的数组 */
@property (nonatomic , strong) NSMutableArray * smallBtnsArray;



@end

@implementation hopyVC


-(NSMutableArray *)smallBtnsArray{
    if (_smallBtnsArray == nil) {
        self.smallBtnsArray = [[NSMutableArray alloc]init];
    }
    return _smallBtnsArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置做导航按钮
    [self setLeftNavBtn];
    //添加洗好按钮
    [self addBtns];
}

-(void)setLeftNavBtn{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    [left setImage:[UIImage imageNamed:@"jiantou-Left"]];
    self.navigationItem.leftBarButtonItem = left;


    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleBtnClick)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
}
#pragma mark - 左导航按钮点击事件
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)addBtns{
    
    //4.0添加饮食口味按钮和娱乐爱好按钮
    CGFloat w = 60;
    CGFloat margin = (self.view.bounds.size.width-80-3*w)/4;
    CGFloat y = 20;
    CGFloat h = 24;
    CGFloat firstX = margin+10;
    
    //设置数据数组
    NSArray*array = @[@"中餐",@"西餐",@"酸爽",@"甜心",@"苦味",@"辣劲"];
    NSArray*array1 = @[@"运动",@"交友",@"电影",@"上网",@"旅游",@"唱歌"];
    //循环添加12个按钮
    for (int i = 0; i<6; i++) {
        NSArray  * viewArray=[[NSBundle mainBundle]loadNibNamed:@"smallBtnsView" owner:nil options:nil];
        smallBtnsView * smallView=[viewArray firstObject];
        self.smallButtonsView = smallView;
        switch (i) {
            case 0:
                self.smallButtonsView.frame = CGRectMake(firstX, y, w, h);
                break;
            case 1:
                self.smallButtonsView.frame = CGRectMake(firstX+margin+w, y, w, h);
                break;
            case 2:
                self.smallButtonsView.frame = CGRectMake(firstX+2*(margin+w), y, w, h);
                break;
            case 3:
                self.smallButtonsView.frame = CGRectMake(firstX, 2*y+h, w, h);
                break;
            case 4:
                self.smallButtonsView.frame = CGRectMake(firstX+margin+w, 2*y+h, w, h);
                break;
            case 5:
                self.smallButtonsView.frame = CGRectMake(firstX+2*(margin+w), 2*y+h, w, h);
                break;
                
            default:
                break;
        }
        
        //绑定tag
        self.smallButtonsView.smallBtn.tag = i+3000;
        
        //设置smallLabel数据并添加到btnsView上
        self.smallButtonsView.smallLabel.text = array[i];
        [self.eatBackView addSubview:self.smallButtonsView];
        
        //添加smallBtn们的点击事件
        [self.smallButtonsView.smallBtn addTarget:self action:@selector(smallButtonClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (int i = 0; i < 6; i++) {
        NSArray  * viewArray1=[[NSBundle mainBundle]loadNibNamed:@"smallBtnsView" owner:nil options:nil];
        smallBtnsView * smallView1=[viewArray1 firstObject];
        switch (i) {
            case 0:
                smallView1.frame = CGRectMake(firstX, y, w, h);
                break;
            case 1:
                smallView1.frame = CGRectMake(firstX+margin+w, y, w, h);
                break;
            case 2:
                smallView1.frame = CGRectMake(firstX+2*(margin+w), y, w, h);
                break;
            case 3:
                smallView1.frame = CGRectMake(firstX, 2*y+h, w, h);
                break;
            case 4:
                smallView1.frame = CGRectMake(firstX+margin+w, 2*y+h, w, h);
                break;
            case 5:
                smallView1.frame = CGRectMake(firstX+2*(margin+w), 2*y+h, w, h);
                break;
                
            default:
                break;
        }
        
        //绑定tag
        smallView1.smallBtn.tag = i+3006;
        
        //设置smallLabel数据并添加到btnsView上
        smallView1.smallLabel.text = array1[i];
        [self.playBackView addSubview:smallView1];
        
        //添加smallBtn们的点击事件
        [smallView1.smallBtn addTarget:self action:@selector(smallButtonClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    }

}

//小按钮的点击事件
- (void)smallButtonClickWithBtn:(UIButton *)btn{
    
    switch (btn.tag) {
        case 3000:
            
            if (btn.selected == YES) {
                btn.selected = NO;
                [self.smallBtnsArray removeObject:@"中餐"];
            }else{
                btn.selected = YES;
                [self.smallBtnsArray addObject:@"中餐"];
            }
            
            break;
        case 3001:
            
            if (btn.selected == YES) {
                btn.selected = NO;
                [self.smallBtnsArray removeObject:@"西餐"];
            }else{
                btn.selected = YES;
                [self.smallBtnsArray addObject:@"西餐"];
            }
            
            break;
            
        case 3002:
            
            if (btn.selected == YES) {
                btn.selected = NO;
                [self.smallBtnsArray removeObject:@"酸爽"];
            }else{
                btn.selected = YES;
                [self.smallBtnsArray addObject:@"酸爽"];
            }
            
            break;
            
        case 3003:
            
            if (btn.selected == YES) {
                btn.selected = NO;
                [self.smallBtnsArray removeObject:@"甜心"];
            }else{
                btn.selected = YES;
                [self.smallBtnsArray addObject:@"甜心"];
            }
            
            break;
            
        case 3004:
            
            if (btn.selected == YES) {
                btn.selected = NO;
                [self.smallBtnsArray removeObject:@"苦味"];
            }else{
                btn.selected = YES;
                [self.smallBtnsArray addObject:@"苦味"];
            }
            
            break;
            
        case 3005:
            
            if (btn.selected == YES) {
                btn.selected = NO;
                [self.smallBtnsArray removeObject:@"辣劲"];
            }else{
                btn.selected = YES;
                [self.smallBtnsArray addObject:@"辣劲"];
            }
            
            break;
            
        case 3006:
            
            if (btn.selected == YES) {
                btn.selected = NO;
                [self.smallBtnsArray removeObject:@"运动"];
            }else{
                btn.selected = YES;
                [self.smallBtnsArray addObject:@"运动"];
            }
            
            break;
            
        case 3007:
            
            if (btn.selected == YES) {
                btn.selected = NO;
                [self.smallBtnsArray removeObject:@"交友"];
            }else{
                btn.selected = YES;
                [self.smallBtnsArray addObject:@"交友"];
            }
            
            break;
            
        case 3008:
            
            if (btn.selected == YES) {
                btn.selected = NO;
                [self.smallBtnsArray removeObject:@"电影"];
            }else{
                btn.selected = YES;
                [self.smallBtnsArray addObject:@"电影"];
            }
            
            break;
            
        case 3009:
            
            if (btn.selected == YES) {
                btn.selected = NO;
                [self.smallBtnsArray removeObject:@"上网"];
            }else{
                btn.selected = YES;
                [self.smallBtnsArray addObject:@"上网"];
            }
            
            break;
            
        case 3010:
            
            if (btn.selected == YES) {
                btn.selected = NO;
                [self.smallBtnsArray removeObject:@"旅游"];
            }else{
                btn.selected = YES;
                [self.smallBtnsArray addObject:@"旅游"];
            }
            
            break;
            
        case 3011:
            
            if (btn.selected == YES) {
                btn.selected = NO;
                [self.smallBtnsArray removeObject:@"唱歌"];
            }else{
                btn.selected = YES;
                [self.smallBtnsArray addObject:@"唱歌"];
            }
            
            break;
        default:
            break;
    }
    DebugLog(@"=====%@====%lu",self.smallBtnsArray,(unsigned long)self.smallBtnsArray.count);
}

#pragma mark - 确认按钮点击事件
- (IBAction)okBtnClick:(id)sender {
    
    //获取到loveLabel的文字信息并在本地设置
    if (self.smallBtnsArray.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSString * loveString = [NSString string];
    NSString * loveStr = [NSString string];
    for (NSString *str3 in self.smallBtnsArray) {
        NSString *str4 = [str3 stringByAppendingString:@" "];
        loveString = [loveString stringByAppendingString:str4];
        NSString *str5 = [str3 stringByAppendingString:@"、"];
        loveStr = [loveStr stringByAppendingString:str5];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:loveStr forKey:@"myHopy"];
    [[NSUserDefaults standardUserDefaults] setObject:loveString forKey:@"myHopy-update"];
    //返回
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 取消按钮点击事件
- (void)cancleBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
