//
//  getFriendsCell.m
//  YKY
//
//  Created by 肖 亮 on 16/5/31.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "getFriendsCell.h"
#import "getFriendModel.h"

@implementation getFriendsCell

-(void)setModel:(getFriendModel *)model{


    if (model.phone) {
        self.phoneNumLabel.text = model.phone;
    }
    if (model.signTime) {
        self.signTimeLabel.text = model.signTime;
    }
    if (model.diamondsNum) {
        NSString * red1 = [NSString stringWithFormat:@"<font size=\"4\" color=\"red\">%@</font>",model.diamondsNum];
        NSString * str2 = [NSString stringWithFormat:@"<font size=\"4\" color=\"#333333\">%@</font>",@"个钻石"];;
        NSString * noPlimit = [NSString stringWithFormat:@"%@%@",red1,str2];

        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[noPlimit dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

        self.diamondsLabel.attributedText = attrStr;
        self.diamondsLabel.font = [UIFont systemFontOfSize:11];
    }

}


@end
