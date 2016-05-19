//
//  YGLookOldItems.m
//  YKY
//
//  Created by 肖 亮 on 16/4/12.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "YGLookOldItems.h"
#import "YGLookOldModel.h"

@interface YGLookOldItems()



@end

@implementation YGLookOldItems

- (void)awakeFromNib {
    // Initialization code
}


-(void)setModel:(YGLookOldModel *)model{
    _model = model;
    DebugLog(@"期号对应的位置标号indexNum%d",_indexNum);
    if (_indexNum == 0) {
        if (_serials) {
            self.titlesLabel.text = [NSString stringWithFormat:@"第%@期正在进行",_serials];
        }
        self.titlesLabel.textColor = [UIColor redColor];
        self.titlesLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    }else{
        if (model.num) {
            self.titlesLabel.text = [NSString stringWithFormat:@"第%@期",model.num];
        }
//        self.titlesLabel.lineBreakMode = NSLineBreakByTruncatingHead;//设置超出部分文字显示方式为中间省略
        self.titlesLabel.textColor = YKYColor(51, 51, 51);
        self.titlesLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    }
}


@end
