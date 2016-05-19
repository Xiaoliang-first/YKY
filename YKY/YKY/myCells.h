//
//  myCells.h
//  YKY
//
//  Created by 肖 亮 on 16/4/15.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myCells : NSObject

+(UIView*)addCellsWithH:(CGFloat)h magin:(CGFloat)magin ImgvW:(CGFloat)shoujiW ImgH:(CGFloat)shoujiH backViewY:(CGFloat)viewY labelW:(CGFloat)labelW ImgName:(NSString *)imgName title:(NSString*)title ToView:(UIView*)mainView andClickAction:(SEL)action VC:(UIViewController*)VC;



@end
