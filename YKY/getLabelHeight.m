//
//  getLabelHeight.m
//  YKY
//
//  Created by 肖亮 on 15/12/15.
//  Copyright © 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "getLabelHeight.h"

@implementation getLabelHeight


+(CGFloat)heightWithConnect:(NSString*)connect andLabelW:(CGFloat)width font:(CGFloat)font{
    //取出高度动态改变的label的字体
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:font];
    //设置换行的宽度
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    //label的Size
    CGSize contentLabelSize = [connect  boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    CGFloat contentLabelHeight = contentLabelSize.height+1;
    return contentLabelHeight;
}


+(CGFloat)wigthWithConnect:(NSString*)connect andHeight:(CGFloat)height font:(CGFloat)font{

//    label.font = [UIFont boldSystemFontOfSize:font];  //UILabel的字体大小
//    label.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
//    label.textColor = color;
//    label.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
////    [label setBackgroundColor:[UIColor redColor]];
//
//    //高度固定不折行，根据字的多少计算label的宽度
////    NSString *str = @"高度不变获取宽度，获取字符串不折行单行显示时所需要的长度";
//    CGSize size = [connect sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, label.frame.size.height)];
//    NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
    
    //取出高度动态改变的label的字体
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:font];
    //设置换行的宽度
    CGSize maxSize = CGSizeMake(MAXFLOAT, height);
    //label的Size
    CGSize contentLabelSize = [connect  boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

    CGFloat contentLabelWidth = contentLabelSize.width+1;
    return contentLabelWidth;
}


#pragma mark - 只适合于各个详情界面使用，若用与其他界面，请慎重，勿修改此方法！
+(UILabel *)labelWithFrame:(CGRect)frame andConnect:(NSString *)connectStr font:(CGFloat)font{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.text = connectStr;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = [UIColor colorWithRed:138.0/255.0 green:138.0/255.0 blue:138.0/255.0 alpha:1.0];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.preferredMaxLayoutWidth = frame.size.width-60;
    return label;
}

@end
