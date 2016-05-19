//
//  moneyImgAndLabel.h
//  YKY
//
//  Created by 肖 亮 on 16/4/15.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface moneyImgAndLabel : NSObject

+(UILabel*)addjinyinImagAndlabelBackViewWithFrame:(CGRect)frame ImgName:(NSString*)imgName imgW:(CGFloat)glImgvW imgH:(CGFloat)glImgvH backView:(UIView *)backView;

+(UILabel*)SHUaddjinyinImagAndlabelBackViewWithFrame:(CGRect)frame ImgName:(NSString*)imgName imgW:(CGFloat)glImgvW imgH:(CGFloat)glImgvH backView:(UIView *)backView titleColor:(UIColor*)color;

@end
