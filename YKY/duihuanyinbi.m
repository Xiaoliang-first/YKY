//
//  duihuanyinbi.m
//  YKY
//
//  Created by 肖 亮 on 16/1/7.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "duihuanyinbi.h"
#import <UIKit/UIKit.h>
#import "Account.h"
#import "AccountTool.h"
#import "common.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "unUsedPrizeModel.h"
#import <CommonCrypto/CommonDigest.h>
#import "newBonusVC.h"

@implementation duihuanyinbi

+(BOOL)duiHuanYbWithTableView:(UITableView *)TableView array:(NSMutableArray *)willDeleteArray andVC:(UIViewController*)VC andJump:(SEL)action andRightBtn:(UIButton *)rightBtn andDataArray:(NSMutableArray*)prizeDataArray btnsView:(UIView *)btnsView{

    Account *account = [AccountTool account];
    if (willDeleteArray.count>0) {
        NSString *str = kduihuanPrizeStr;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [MBProgressHUD showMessage:@"银币兑换中..." toView:VC.view];
        NSString *str0 = @"";
        for (unUsedPrizeModel * model in willDeleteArray) {
            NSString * last = [NSString stringWithFormat:@"%@,",model.cid];
            str0 = [str0 stringByAppendingString:last];
        }
        NSDictionary  *parameters = @{@"couponsId":str0 ,@"userId":account.uiId,@"client":Kclient,@"serverToken":account.reponseToken};
        if (willDeleteArray.count == 1) {
            str0 = [str0 stringByReplacingOccurrencesOfString:@"," withString:@""];
            parameters = @{@"couponsId":str0 ,@"userId":account.uiId,@"client":Kclient,@"serverToken":account.reponseToken};
        }
        DebugLog(@"奖兜兑换银币parameter=%@",parameters);
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DebugLog(@"奖兜兑换银币兑换返回结果res=%@",responseObject);
            [MBProgressHUD hideHUDForView:VC.view animated:YES];
            if ([responseObject[@"code"] isEqual:@(0)]){
                //取消tableview的可编辑状态
                [TableView setEditing:NO animated:YES];
                [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
                [btnsView removeFromSuperview];
                [prizeDataArray removeObjectsInArray:willDeleteArray];//删除已勾选的数据
                [willDeleteArray removeAllObjects];
                [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"silver"]forKey:@"silverCoin"];
                [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"glod"] forKey:@"gold"];
                [MBProgressHUD showSuccess:responseObject[@"msg"]];

                //兑换成功刷新列表
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                newBonusVC * boundvc = [sb instantiateViewControllerWithIdentifier:@"newBonusVC"];
                [boundvc updataPrize];
                
            }else if ([responseObject[@"code"] isEqual:KotherLogin]){
                [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
                [MBProgressHUD showError:@"您的账号在其他设备登录，请您重新登录"];
                [NSTimer timerWithTimeInterval:1.0 target:self selector:action userInfo:nil repeats:NO];
            }else{
                [MBProgressHUD showError:responseObject[@"msg"]];
                [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
            }
            [TableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [MBProgressHUD hideHUDForView:VC.view animated:YES];
            [MBProgressHUD showError:@"银币兑换失败，请检查您的网络"];
        }];
        return YES;
    }else{
        [MBProgressHUD showError:@"未选择奖品"];
        return NO;
    }
}



#pragma mark - MD5密码加密
+(NSString *)md5:(NSString *)str {

    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
