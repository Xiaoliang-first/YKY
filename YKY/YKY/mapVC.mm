//
//  mapVC.m
//  YKY
//
//  Created by 亮肖 on 15/6/15.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "mapVC.h"
#import "prizeDetailModel.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD+MJ.h"
#import "UIView+XL.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "UIImage+Rotate.h"
#import "boundsPrizeDetailModel.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

//#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件



#import "navBtn.h"



#define MYBUNDLE_NAME @"mapapi.bundle"

#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]

#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]




@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}
@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation
@synthesize type = _type;
@synthesize degree = _degree;
@end



@interface mapVC ()<CLLocationManagerDelegate,UIAlertViewDelegate,BMKMapViewDelegate,BMKRouteSearchDelegate,BMKLocationServiceDelegate>


@property (weak, nonatomic) IBOutlet UIView *mapBackView;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic , strong) CLLocationManager * locationManager;
@property (nonatomic , strong) BMKMapManager * mapManager;
@property (nonatomic , strong) BMKMapView * mapview;
@property (nonatomic , strong) BMKRouteSearch * searcher;
@property (nonatomic , strong) BMKLocationService * location;

/** 用户当前位置维度 */
@property (nonatomic , copy) NSString * nowLat;
/** 用户当前位置经度 */
@property (nonatomic , copy) NSString * nowLon;
@property (nonatomic , copy) NSString * NaviString;
/** 用户所在的城市名 */
@property (nonatomic , copy) NSString * city;


@end

@implementation mapVC


- (BMKRouteSearch *)searcher
{
    if (!_searcher) {
        _searcher = [[BMKRouteSearch alloc] init];
        _searcher.delegate = self;
    }
    return _searcher;
}

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

#pragma mark - 规划路线
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}
#pragma mark - 画线
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - 规划公交路线
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:    (BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    
    NSArray* array = [NSArray arrayWithArray:_mapview.annotations];
    [_mapview removeAnnotations:array];
    
    array = [NSArray arrayWithArray:_mapview.overlays];
    [_mapview removeOverlays:array];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = (int)[plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapview addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapview addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapview addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }

        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapview addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }else if (error == BMK_SEARCH_ST_EN_TOO_NEAR){
        [MBProgressHUD showError:@"您的位置和目的地离得太近了!"];
        return;
    }else if (error == BMK_SEARCH_NOT_SUPPORT_BUS_2CITY){
        [MBProgressHUD showError:@"不支持跨城市公交"];
        return;
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"路线规划失败!"];
        return;
    }

}
#pragma mark - 规划驾车路线
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapview.annotations];
    [_mapview removeAnnotations:array];
    
    array = [NSArray arrayWithArray:_mapview.overlays];
    [_mapview removeOverlays:array];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = (int)[plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapview addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapview addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapview addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapview addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapview addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }else{
        [MBProgressHUD showError:@"路线规划失败!"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
}
#pragma mark - 规划步行路线
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapview.annotations];
    [_mapview removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapview.overlays];
    [_mapview removeOverlays:array];
    
    if (error == BMK_SEARCH_RESULT_NOT_FOUND) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"亲~,路程太远了,步行会累坏的!"];
    }
    
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        int size = (int)[plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapview addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapview addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapview addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapview addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - 根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapview setVisibleMapRect:rect];
    _mapview.zoomLevel = _mapview.zoomLevel - 0.3;
}


#pragma mark - 代理的管理
-(void)viewWillAppear:(BOOL)animated
{
    [_mapview viewWillAppear];
    _mapview.delegate = self;// 此处记得不用的时候需要置nil，否则影响内存的释放
    _searcher.delegate = self;

    //设置左导航按钮
    [self setLeftNavBtn];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapview viewWillDisappear];
    _mapview.delegate = nil; // 不用时，置nil
    _searcher.delegate = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"商家导航";
    self.tabBarController.tabBar.hidden = YES;
    
    //获取用户当前位置信息
    [self getUserLocation];
    
    //设置地图视图
    [self setBMapView];

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


#pragma mark - 设置地图View
-(void)setBMapView{
    
    _mapview = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.mapBackView.width, self.view.height-64)];
    
    if (self.view.frame.size.height>668) {//适配6p
        _mapview.frame = CGRectMake(0, 0, self.mapBackView.width,self.view.height-64);
    }else if (self.view.frame.size.height<481){//适配4跟4s
        _mapview.frame = CGRectMake(0, 0, self.mapBackView.width, self.mapBackView.height-124);
    }
    [self.mapBackView addSubview:_mapview];
    self.mapBackView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
    
    //添加下边4个按钮
    [self add4Btns];
    
}


#pragma mark - 添加下边四个按钮
-(void)add4Btns{
    
    CGFloat w = 70;
    CGFloat margin = (self.view.width-w*4)/5;
    
    [self addNavBtnsWithX:margin andImgName:@"bus_icon" andTitle:@"公交" andAction:@selector(busBtnClick:)];
    
    [self addNavBtnsWithX:margin*2+w andImgName:@"car_icon" andTitle:@"驾车" andAction:@selector(carBtnClick:)];
    
    [self addNavBtnsWithX:margin*3+w*2 andImgName:@"walk_icon" andTitle:@"步行" andAction:@selector(wealkBtnClick:)];
    
    [self addNavBtnsWithX:margin*4+w*3 andImgName:@"location_icon" andTitle:@"导航" andAction:@selector(navBtnClick:)];

}


-(void)addNavBtnsWithX:(CGFloat)X andImgName:(NSString *)imgName andTitle:(NSString *)title andAction:(nonnull SEL) sel{
    
    
    CGFloat w = 70;
    
    //公交
    navBtn * btn = [[navBtn alloc]initWithFrame:CGRectMake(X,self.view.height-54, w, 25)];
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    btn.imgName = imgName;
    btn.btnTitle = title;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.mapBackView addSubview:btn];
    

}


#pragma mark - 获取用户当前位置信息
-(void)getUserLocation{
    
    // 实例化一个位置管理器
    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
        
    }else{
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.locationManager.delegate = self;
    
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动100再通知委托处理更新;
    self.locationManager.distanceFilter = 100.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    
    
    // 判断的手机的定位功能是否开启
    // 开启定位:设置 > 隐私 > 位置 > 定位服务
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [self.locationManager startUpdatingLocation];

    }else {

        UIAlertView * alterView = [[UIAlertView alloc]initWithTitle:@"请开启定位服务!" message:@"设置 > 隐私 > 位置 > 定位服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView show];
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                //如果点击打开的话，需要记录当前的状态，从设置回到应用的时候会用到
                [[UIApplication sharedApplication] openURL:url];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    self.nowLat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    self.nowLon = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
//            self.location.text = placemark.name;
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
                city = [city substringFromIndex:2];
            }
            self.city = city;
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"无法获取城市名");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
    
    // 停止位置更新
    [manager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    switch([error code]) {
        case kCLErrorDenied:
            //用户拒绝访问其位置
            errorString = @"Access to Location Services denied by user";
            [MBProgressHUD showError:@"应用访问位置未获得您的授权!"];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case kCLErrorLocationUnknown:
            //临时不能访问用户位置
            errorString = @"Location data unavailable";
            [MBProgressHUD showError:@"无法获取您的位置信息!"];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
}


#pragma mark - 公交路线规划
- (void)busBtnClick:(id)sender {

    [MBProgressHUD showMessage:@"规划中..." toView:self.view];
//    // 创建一个起始点
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.pt = CLLocationCoordinate2DMake([self.nowLat floatValue], [self.nowLon floatValue]);
    if (self.nowLon == nil || self.nowLat == nil) {
        [MBProgressHUD showError:@"请为“小摇”开启定位服务!"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    // 创建一个终点
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    
    if ([self.indentify isEqualToString:@"2"]) {
        if (self.prizeDetailModel.lat==nil || self.prizeDetailModel.lng == nil) {
            [MBProgressHUD showError:@"获取商家位置失败!"];
            return;
        }
        end.pt = CLLocationCoordinate2DMake([self.prizeDetailModel.lat floatValue],[self.prizeDetailModel.lng floatValue]);
//        end.cityName = self.activityDetailModel.ciName;
    }else if([self.indentify isEqualToString:@"1"]){
        if (self.boundsPrizeDetailModel.lat==nil || self.boundsPrizeDetailModel.lng == nil) {
            [MBProgressHUD showError:@"获取商家位置失败!"];
            return;
        }
        end.pt = CLLocationCoordinate2DMake([self.boundsPrizeDetailModel.lat floatValue],[self.boundsPrizeDetailModel.lng floatValue]);
//        end.cityName = self.unUsedPrizeModel.ciName;
    }else if ([self.indentify isEqualToString:@"3"]){
        if (self.prizeDetailModel.lat==nil || self.prizeDetailModel.lng == nil) {
            [MBProgressHUD showError:@"获取商家位置失败!"];
            return;
        }
        end.pt = CLLocationCoordinate2DMake([self.prizeDetailModel.lat floatValue],[self.prizeDetailModel.lng floatValue]);
//        end.cityName = self.prizeModel.ciName;
    }else{
        [MBProgressHUD showError:@"目的地获取失败!"];
        return;
    }
    
    // 创建一个步行选项
    BMKTransitRoutePlanOption *option = [[BMKTransitRoutePlanOption alloc] init];
    option.from = start;
    option.to = end;
//    option.city = self.prizeModel.ciName?self.prizeModel.ciName:self.activityDetailModel.ciName;

    // 搜索公交选项结果（结果在代理方法中去取）
    [self.searcher transitSearch:option];
    
}
 
#pragma mark - 驾车路线规划
- (void)carBtnClick:(id)sender {
    [MBProgressHUD showMessage:@"规划中..." toView:self.view];

    // 创建一个起始点
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.pt = CLLocationCoordinate2DMake([self.nowLat floatValue], [self.nowLon floatValue]);
    if (self.nowLon == nil || self.nowLat == nil) {
        [MBProgressHUD showError:@"请为“小摇”开启定位服务!"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    // 创建一个终点
    BMKPlanNode *end = [[BMKPlanNode alloc] init];

    if ([self.indentify isEqualToString:@"2"]) {
        if (self.prizeDetailModel.lat==nil || self.prizeDetailModel.lng == nil) {
            [MBProgressHUD showError:@"获取商家位置失败!"];
            return;
        }
        end.pt = CLLocationCoordinate2DMake([self.prizeDetailModel.lat floatValue],[self.prizeDetailModel.lng floatValue]);
//        end.cityName = self.city;
    }else if([self.indentify isEqualToString:@"1"]){
        if (self.boundsPrizeDetailModel.lat==nil || self.boundsPrizeDetailModel.lng == nil) {
            [MBProgressHUD showError:@"获取商家位置失败!"];
            return;
        }
        end.pt = CLLocationCoordinate2DMake([self.boundsPrizeDetailModel.lat floatValue],[self.boundsPrizeDetailModel.lng floatValue]);
//        end.cityName = self.unUsedPrizeModel.ciName;
    }else if ([self.indentify isEqualToString:@"3"]){
        if (self.prizeDetailModel.lat==nil || self.prizeDetailModel.lng == nil) {
            [MBProgressHUD showError:@"获取商家位置失败!"];
            return;
        }
        end.pt = CLLocationCoordinate2DMake([self.prizeDetailModel.lat floatValue],[self.prizeDetailModel.lng floatValue]);
//        end.cityName = self.prizeModel.ciName;
    }else{
        [MBProgressHUD showError:@"目的地获取失败!"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }

    // 创建一个驾车选项
    BMKDrivingRoutePlanOption *option = [[BMKDrivingRoutePlanOption alloc] init];
    option.from = start;
    option.to = end;
    
    // 搜索驾车选项结果（结果在代理方法中去取）
    [self.searcher drivingSearch:option];
    
}

#pragma mark - 步行路线规划
- (void)wealkBtnClick:(id)sender {
    [MBProgressHUD showMessage:@"规划中" toView:self.view];
    // 创建一个起始点
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.pt = CLLocationCoordinate2DMake([self.nowLat floatValue], [self.nowLon floatValue]);

    if (self.nowLon == nil || self.nowLat == nil) {
        [MBProgressHUD showError:@"请为“小摇”开启定位服务!"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    // 创建一个终点
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    if ([self.indentify isEqualToString:@"2"]) {
        if (self.prizeDetailModel.lat==nil || self.prizeDetailModel.lng == nil) {
            [MBProgressHUD showError:@"获取商家位置失败!"];
            return;
        }
        end.pt = CLLocationCoordinate2DMake([self.prizeDetailModel.lat floatValue],[self.prizeDetailModel.lng floatValue]);
//        end.cityName = self.newActivityPrizeDetailModel.ciName;
    }else if([self.indentify isEqualToString:@"1"]){
        if (self.boundsPrizeDetailModel.lat==nil || self.boundsPrizeDetailModel.lng == nil) {
            [MBProgressHUD showError:@"获取商家位置失败!"];
            return;
        }
        end.pt = CLLocationCoordinate2DMake([self.prizeDetailModel.lat floatValue],[self.prizeDetailModel.lng floatValue]);
//        end.cityName = self.unUsedPrizeModel.ciName;
    }else if([self.indentify isEqualToString:@"3"]){
        if (self.prizeDetailModel.lat==nil || self.prizeDetailModel.lng == nil) {
            [MBProgressHUD showError:@"获取商家位置失败!"];
            return;
        }
        end.pt = CLLocationCoordinate2DMake([self.prizeDetailModel.lat floatValue],[self.prizeDetailModel.lng floatValue]);
//        end.cityName = self.prizeModel.ciName;
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"目的地获取失败!"];
        return;
    }
    
    // 创建一个步行选项
    BMKWalkingRoutePlanOption *option = [[BMKWalkingRoutePlanOption alloc] init];
    option.from = start;
    option.to = end;
    
    // 搜索步行选项结果（结果在代理方法中去取）
    [self.searcher walkingSearch:option];
}

#pragma mark - 导航(语音)
- (void)navBtnClick:(id)sender {
    
//    NSString * ciName = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityName"];

    if (self.nowLat == nil || self.nowLon == nil) {
        [MBProgressHUD showError:@"请为“小摇”开启定位服务!"];
        return;
    }
    
    //默认地址为公司地理位置坐标
    NSString *wantLat = @"40.048770";
    NSString *wantLon = @"116.29738";
    NSString *wantCity = @"北京市";
    
    
    if ([self.indentify isEqualToString:@"1"]) {
        if (self.boundsPrizeDetailModel.lat==nil || self.boundsPrizeDetailModel.lng == nil) {
            [MBProgressHUD showError:@"获取商家位置失败!"];
            return;
        }
        wantLat = self.boundsPrizeDetailModel.lat;
        wantLon = self.boundsPrizeDetailModel.lng;
//        wantCity = ciName;
    }else if([self.indentify isEqualToString:@"2"]){
        if (self.prizeDetailModel.lat==nil || self.prizeDetailModel.lng == nil) {
            [MBProgressHUD showError:@"获取商家位置失败!"];
            return;
        }
        wantLat = self.prizeDetailModel.lat;
        wantLon = self.prizeDetailModel.lng;
//        wantCity = ciName;
    }else if ([self.indentify isEqualToString:@"3"]){
        if (self.prizeDetailModel.lat==nil || self.prizeDetailModel.lng == nil) {
            [MBProgressHUD showError:@"获取商家位置失败!"];
            return;
        }
        wantLat = self.prizeDetailModel.lat;
        wantLon = self.prizeDetailModel.lng;
//        wantCity = ciName;
    }
    
    self.NaviString = [NSString stringWithFormat:@"http://api.map.baidu.com/direction?origin=latlng:%@,%@|name:当前位置&destination=latlng:%@,%@|name:目的地&origin_region=北京市&destination_region=%@&output=html&mode=driving&src=金蚂蚁|一块摇",self.nowLat,self.nowLon,wantLat,wantLon,wantCity];
    
    NSString * str = [self.NaviString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //跳转到AppStore，加载百度网页地图
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}



@end
