//
//  CPLiteRefreshHeader.h
//    
//
//  Created by chengfei xiao on 2017/12/13.
//  Copyright © 2017年 CrespoXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "CPLiteRefreshDefine.h"


@interface CPLiteRefreshHeader : UIControl

@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, copy  ) CPrefreshBlock refreshBlock;
@property (nonatomic, assign) CPLiteRefreshTipBgType bgType;

- (void)attachToScrollView:(UIScrollView *)scrollView;

- (void)unAttachToScrollView;

- (void)beginRefreshing;

- (void)endRefreshing;

@end
