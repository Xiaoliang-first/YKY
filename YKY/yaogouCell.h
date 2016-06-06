//
//  yaogouCell.h
//  YKY
//
//  Created by 肖 亮 on 16/4/5.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class homeNewScuessModel;
@interface yaogouCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *oderNumLabel;

@property (weak, nonatomic) IBOutlet UIView *myConnectView;

@property (weak, nonatomic) IBOutlet UIImageView *prizeImgView;

@property (weak, nonatomic) IBOutlet UILabel *prizeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *plimitLabel;

@property (nonatomic ) long index;

@property (nonatomic , strong) homeNewScuessModel * prizeModel;

@end
