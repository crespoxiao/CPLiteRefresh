//
//  CPLiteRefreshFooter.h
//   
//
//  Created by chengfei xiao on 2018/01/10.
//  Copyright © 2017年 CrespoXiao. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "CPLiteRefreshDefine.h"

@interface CPLiteRefreshFooter : UIControl

@property (nonatomic, assign, readonly) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isNoMoreData;
@property (nonatomic, copy  ) CPrefreshBlock refreshBlock;
@property (nonatomic, assign) CPLiteRefreshTipBgType bgType;

- (void)attachToScrollView:(UIScrollView *)scrollView;

- (void)unAttachToScrollView;

- (void)beginRefreshing;

- (void)endRefreshing;

@end
