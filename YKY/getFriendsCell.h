//
//  getFriendsCell.h
//  YKY
//
//  Created by 肖 亮 on 16/5/31.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class getFriendModel;
@interface getFriendsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *signTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *diamondsLabel;
@property (nonatomic , strong) getFriendModel * model;

@end
