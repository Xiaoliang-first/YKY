//
//  meAddAddressVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/18.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meAddAddressVC.h"
#import "Province.h"
#import "Account.h"
#import "AccountTool.h"


@interface meAddAddressVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (nonatomic , strong) UITextField * nameField;
@property (nonatomic , strong) UITextField * phoneField;
@property (nonatomic , strong) UITextField * jiedaoField;
@property (nonatomic , strong) UITextField * addressDetailField;
//@property (nonatomic , strong) UIButton * provinceBtn;
@property (nonatomic , strong) UILabel * provinceLabel;
@property (nonatomic , strong) UIView * picBackView;
@property (nonatomic , strong) UIPickerView * pickerV;
@property (nonatomic , strong) NSArray * provinces;
@property (nonatomic, assign) NSInteger lastProIndex;
@property (nonatomic , copy) NSString * provinceStr;
@property (nonatomic , copy) NSString * cityStr;
@property (nonatomic) BOOL isDefault;
@property (nonatomic , strong) UIImageView * imgView;



@end

@implementation meAddAddressVC

-(NSArray *)provinces{
    if (!_provinces) {
        // 获取解析的路径
        NSString* path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];

        // 用临时数组接收
        NSArray* tempArray = [NSArray arrayWithContentsOfFile:path];

        // 初始化一个 可变数组
        NSMutableArray* array = [NSMutableArray array];

        for (NSDictionary* dict in tempArray) {
            // 循环 通过字典来创建对象
            Province* pro = [Province provinceWithDict:dict];
            // 添加到可变数组当中
            [array addObject:pro];
        }
        _provinces = array;
    }
    return _provinces;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YKYColor(242, 242, 242);
    self.title = @"添加地址";
    [self setLeft];
    self.isDefault = NO;
    [self addViews];
    self.provinceStr = @"北京";
    self.cityStr = @"通州";
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
-(void)addViews{

    CGFloat h = 40;
    self.nameField = [self addTextFieldWithFrame:CGRectMake(0, 64, kScreenWidth, h) placeHolder:@"收货人姓名"];
    self.nameField.delegate = self;

    self.phoneField = [self addTextFieldWithFrame:CGRectMake(0, 64+h, kScreenWidth, h) placeHolder:@"手机号码"];
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [self addShengAndShiWithFrame:CGRectMake(0, 64+2*h, kScreenWidth, h)];

//    self.jiedaoField = [self addTextFieldWithFrame:CGRectMake(0, 64+3*h, kScreenWidth, h) placeHolder:@"街道地址"];
    self.addressDetailField = [self addTextFieldWithFrame:CGRectMake(0, 64+3*h, kScreenWidth, h) placeHolder:@"详细地址"];
    self.addressDetailField.delegate = self;


    [self addDefaultBtn];


    [self addSaveBtn];
}
#pragma mark - 点击后屏收回键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nameField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.jiedaoField resignFirstResponder];
    [self.addressDetailField resignFirstResponder];
    [self.picBackView removeFromSuperview];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nameField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.jiedaoField resignFirstResponder];
    [self.addressDetailField resignFirstResponder];
    [self.picBackView removeFromSuperview];
    return YES;
}

#pragma mark - 添加textfield
-(UITextField*)addTextFieldWithFrame:(CGRect)frame placeHolder:(NSString*)title{
    UIView * back = [[UIView alloc]initWithFrame:frame];
    back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:back];

    CGFloat magin = 15;
    UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(magin, 0, kScreenWidth-2*magin, frame.size.height)];
    field.placeholder = title;
    field.font = [UIFont systemFontOfSize:15];
    [back addSubview:field];
    [line addLineWithFrame:CGRectMake(0, frame.size.height-1, kScreenWidth, 1) andBackView:back];
    return field;
}
#pragma mark - 添加省市选择
-(void)addShengAndShiWithFrame:(CGRect)frame{
    UIView * back = [[UIView alloc]initWithFrame:frame];
    back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:back];

    self.provinceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 40)];
    self.provinceLabel.text = @"省、市";
    self.provinceLabel.textAlignment = NSTextAlignmentLeft;
    self.provinceLabel.textColor = YKYColor(123, 124, 125);
    self.provinceLabel.font = [UIFont systemFontOfSize:15];
    [back addSubview:self.provinceLabel];


    UIButton * provinceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    provinceBtn.backgroundColor = [UIColor clearColor];
    [provinceBtn addTarget:self action:@selector(addPicker) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:provinceBtn];
    [line addLineWithFrame:CGRectMake(0, frame.size.height-1, kScreenWidth, 1) andBackView:back];


}
#pragma mark - 添加省市选择框
-(void)addPicker{
    self.picBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 230)];
    self.picBackView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.picBackView];


    self.pickerV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    self.pickerV.backgroundColor = [UIColor whiteColor];
    self.pickerV.dataSource = self;
    self.pickerV.delegate = self;
    [self.picBackView addSubview:self.pickerV];
    // 设置picker显示选中框
    self.pickerV.showsSelectionIndicator=YES;


    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, self.picBackView.height-30, 40, 30)];
    cancelBtn.backgroundColor = [UIColor orangeColor];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.picBackView addSubview:cancelBtn];
    //设置图片圆角
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.borderWidth = 0.01;


    UIButton * okBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-40-15, cancelBtn.y, 40, 30)];
    okBtn.backgroundColor = [UIColor orangeColor];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [self.picBackView addSubview:okBtn];
    //设置图片圆角
    okBtn.layer.cornerRadius = 5;
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.borderWidth = 0.01;

}
#pragma mark - 取消选择
-(void)cancel{
    [self.picBackView removeFromSuperview];
}
#pragma mark - 确定选择
-(void)ok{
    //保存选择地区


    //设置选择按钮
    self.provinceLabel.text= [self.provinceStr stringByAppendingString:self.cityStr];


    //删除pickView
    [self.picBackView removeFromSuperview];
}


#pragma mark - pickerView数据源方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _provinces.count?_provinces.count:0;
    }else if(component == 1){
        // 城市
        // 获取省份
        NSInteger proIndex = [pickerView selectedRowInComponent:0];
        Province* pro = self.provinces[proIndex];
        // 通过省份获取城市
        NSArray* cities = pro.cities;
        return cities.count;
    }
    return 0;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSInteger proIndex = [pickerView selectedRowInComponent:0];
    DebugLog(@"%ld",(long)proIndex);
    if (component == 0) {
        // 省份
        Province * pro = self.provinces[row];
        return pro.state;
    }else if (component == 1){
        // 拿到省份的下标
        //        NSInteger proIndex = [pickerView selectedRowInComponent:0];
        NSInteger proIndex = self.lastProIndex;
        // 获取省份
        Province* pro = self.provinces[proIndex];
        // 通过省份获取城市
        NSArray* array = pro.cities;
        return array[row];
    }
    return nil;
}

#pragma mark - 设置pickerview的文字大小和其他参数
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    if (component == 0) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        Province * pro = _provinces[row];
        myView.text = pro.state;
        myView.font = [UIFont systemFontOfSize:[myFont getTitle3]];
        //用label来设置字体大小
        myView.backgroundColor = [UIColor clearColor];
    }else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 180, 30)];
        // 拿到省份的下标
        NSInteger proIndex = self.lastProIndex;
        // 获取省份
        Province* pro = self.provinces[proIndex];
        // 通过省份获取城市
        NSArray* array = pro.cities;
        myView.text = array[row];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.font = [UIFont systemFontOfSize:[myFont getTitle3]];
        myView.backgroundColor = [UIColor clearColor];
    }
    return myView;
}

#pragma mark - 设置pickerView代理方法
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
#pragma mark - 实现pickerView二级联动
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

//    [self.provinces[row] name];

    // id 类型可以调用任何已经存在的方法
    // array[x] 取下标
    // dict [@"x"] 取字典
    if (component == 0) {
        // 记录一下上一次选择的下标
        self.lastProIndex = [pickerView selectedRowInComponent:0];
        // 刷新
        // 刷新所有的组
        //           [pickerView reloadAllComponents];
        // 刷新指定的某一组
        [pickerView reloadComponent:1];
    }
    //     获取省份
    Province* pro = self.provinces[self.lastProIndex];
    // 获取城市的下标
    NSInteger cIndex = [pickerView selectedRowInComponent:1];
    // 通过城市的下标获取城市名字
    NSString* cName = pro.cities[cIndex];
    self.provinceStr = pro.state;
    self.cityStr = cName;
    DebugLog(@"%@ -- %@", pro.state, cName);

}

#pragma mark - 添加设置为默认地址的按钮
-(void)addDefaultBtn{

    UIView * addressDefault = [[UIView alloc]initWithFrame:CGRectMake(0, 64+4*40+15, kScreenWidth, 40)];
    addressDefault.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addressDefault];


    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 40)];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = YKYColor(249, 61, 66);
    label.text = @"设为默认地址";
    label.textAlignment = NSTextAlignmentLeft;
    [addressDefault addSubview:label];


    CGFloat imgw = 15;
    CGFloat imgh = 13;
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(addressDefault.width-imgw-30, 0.5*addressDefault.height-0.5*imgw, imgw, imgh)];
    self.imgView.image = [UIImage imageNamed:@"defaultAddress"];
    [addressDefault addSubview:_imgView];
    self.imgView.hidden = YES;


    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(setDefault) forControlEvents:UIControlEventTouchUpInside];
    [addressDefault addSubview:btn];

}

static BOOL oneClick = YES;
-(void)setDefault{
    if (oneClick) {
        self.imgView.hidden = NO;
        self.isDefault = YES;
        DebugLog(@"设置默认地址");
        oneClick = NO;
    }else{
        self.imgView.hidden = YES;
        self.isDefault = NO;
        DebugLog(@"不设置为默认地址");
        oneClick = YES;
    }
}



#pragma mark - 添加保存按钮
-(void)addSaveBtn{
    CGFloat magin = 15;
    CGFloat w = kScreenWidth-2*magin;
    CGFloat h = 40;
    CGFloat y = kScreenheight-h-1.5*magin;
    UIButton * save = [[UIButton alloc]initWithFrame:CGRectMake(magin, y, w, h)];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    save.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    save.titleLabel.textAlignment = NSTextAlignmentCenter;
    save.backgroundColor = YKYColor(249, 61, 66);
    [save addTarget:self action:@selector(saveAddressData) forControlEvents:UIControlEventTouchUpInside];
    //设置图片圆角
    save.layer.cornerRadius = 5;
    save.layer.masksToBounds = YES;
    save.layer.borderWidth = 0.01;
    [self.view addSubview:save];

}
#pragma mark - 保存按钮点击事件
-(void)saveAddressData{
    DebugLog(@"保存按钮被点击");

    [self loadData];
}

-(void)loadData{

    Account * account = [AccountTool account];
    if (!account) {
        [self jumpToMyaccountVC];
        return;
    }

    if (_nameField.text.length == 0) {
        [MBProgressHUD showError:@"收货人不能为空!"];
        return;
    }
    if (_phoneField.text.length == 0) {
        [MBProgressHUD showError:@"联系电话不能为空!"];
        return;
    }
    if ([self.provinceLabel.text isEqualToString:@"省、市"]) {
        [MBProgressHUD showError:@"未选择省、市!"];
        return;
    }
    if (_addressDetailField.text.length == 0) {
        [MBProgressHUD showError:@"详细地址不能为空!"];
        return;
    }

    if (![phone isMobileNumber:self.phoneField.text]) {
        [MBProgressHUD showError:@"您输入的电话号码不正确!"];
        return;
    }


    NSString * addressStr = [[self.provinceStr stringByAppendingString:[NSString stringWithFormat:@" %@",self.cityStr]] stringByAppendingString:[NSString stringWithFormat:@" %@",self.addressDetailField.text]];

    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];

    if (_isDefault) {
        [parameters setValue:@1 forKey:@"isDefault"];
    }
    [parameters setValue:self.phoneField.text forKey:@"phone"];
    [parameters setValue:self.nameField.text forKey:@"name"];
    [parameters setValue:addressStr forKey:@"address"];

    [MBProgressHUD showMessage:@"正在保存..." toView:self.view];
    [XLRequest AFPostHost:kbaseURL bindPath:@"/yshakeCoupons/saveNewAdds" postParam:parameters isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        DebugLog(@"新增地址成功==%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            [MBProgressHUD showSuccess:@"地址保存成功!"];
            [NSTimer scheduledTimerWithTimeInterval:1.7 target:self selector:@selector(back) userInfo:nil repeats:NO];
        }else if ([responseDic[@"code"] isEqual:KotherLogin]){
            [self jumpToMyaccountVC];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"保存失败,请检查网路!"];
        DebugLog(@"新增地址失败==error=%@===oper=%@",error,operation);
    }];
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


//单点登录
-(void)jumpToMyaccountVC{
    Account *account = [AccountTool account];
    if (account) {
        //实现当前用户注销（就是把 account.data文件清空）
        account = nil;
        [AccountTool saveAccount:account];

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
