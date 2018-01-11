//
//  CPLiteRefreshTipView.h
//   
//
//  Created by chengfei xiao on 2018/01/10.
//  Copyright © 2017年 CrespoXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPLiteRefreshDefine.h"

@interface CPLiteRefreshTipView : UIView

@property (nonatomic, assign)CPLiteRefreshTipBgType bgType;//先设置bgType再设置tipType
@property (nonatomic, assign)CPLiteRefreshTipStyleType tipType;

@end
