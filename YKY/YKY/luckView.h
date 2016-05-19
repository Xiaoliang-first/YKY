//
//  luckView.h
//  YKY
//
//  Created by 肖 亮 on 16/5/1.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface luckView : UIView

-(void)showWithModel:(id)model VC:(UIViewController*)VC Action:(SEL)action serials:(NSString*)serials pname:(NSString*)pname;

@end
