//
//  smallBtnsView.h
//  YKY
//
//  Created by 亮肖 on 15/5/11.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface smallBtnsView : UIView


/**
 *  小按钮（用于实现选中与非选中）
 */
@property (weak, nonatomic) IBOutlet UIButton *smallBtn;
/**
 *  小label（用于显示用户喜爱的项目名称）
 */
@property (weak, nonatomic) IBOutlet UILabel *smallLabel;



@end
