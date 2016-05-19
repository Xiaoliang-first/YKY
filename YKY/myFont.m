//
//  myFont.m
//  YKY
//
//  Created by 肖 亮 on 16/4/27.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "myFont.h"

@implementation myFont

+(void)setTitle{
    if (iPhone6plus) {
       title1 = 20;
       title2 = 18;
       title3 = 16;
       title4 = 13;
    }else if(iPhone6){
       title1 = 17;
       title2 = 15;
       title3 = 13;
       title4 = 11;
    }else{
       title1 = 16;
       title2 = 13;
       title3 = 11;
       title4 = 9;
    }
}

+(CGFloat)getTitle1{
    return title1;
}
+(CGFloat)getTitle2{
    return title2;
}
+(CGFloat)getTitle3{
    return title3;
}
+(CGFloat)getTitle4{
    return title4;
}


@end
