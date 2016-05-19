//
//  getLabelHeight.h
//  YKY
//
//  Created by 肖亮 on 15/12/15.
//  Copyright © 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface getLabelHeight : NSObject

/**
 *  获取到label的高度
 *
 *  @param connect 计算动态label高度所需的label文字
 *  @param width   设定的label的文字宽度
 *
 *  @return 返回一个计算好的动态label高度
 */
+(CGFloat)heightWithConnect:(NSString*)connect andLabelW:(CGFloat)width font:(CGFloat)font;


/**
 *  获取到自己所需要的label类型，字体大小14，文字颜色深灰色，为满足各个详情界面中奖品描述或者商家描述使用。
 *
 *  @param frame      label的frame
 *  @param connectStr label的文字内容
 *
 *  @return 返回一个满足需要的label
 */
+(UILabel *)labelWithFrame:(CGRect)frame andConnect:(NSString *)connectStr font:(CGFloat)font;


+(CGFloat)wigthWithConnect:(NSString*)connect andHeight:(CGFloat)height font:(CGFloat)font;

@end
