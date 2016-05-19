//
//  duihuanyinbi.h
//  YKY
//
//  Created by 肖 亮 on 16/1/7.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface duihuanyinbi : NSObject

+(BOOL)duiHuanYbWithTableView:(UITableView *)TableView array:(NSMutableArray *)willDeleteArray andVC:(UIViewController*)VC andJump:(SEL)action andRightBtn:(UIButton *)rightBtn andDataArray:(NSMutableArray*)prizeDataArray btnsView:(UIView*)btnsView;

@end
