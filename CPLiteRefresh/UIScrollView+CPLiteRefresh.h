//
//  UIScrollView+CPLiteRefresh.h
//   
//
//  Created by chengfei xiao on 2018/1/11.
//  Copyright © 2018年 CrespoXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPLiteRefreshDefine.h"
#import "CPLiteRefreshHeader.h"
#import "CPLiteRefreshFooter.h"

@interface UIScrollView (CPLiteRefresh)

@property (nonatomic, strong) CPLiteRefreshHeader *cp_header;
@property (nonatomic, strong) CPLiteRefreshFooter *cp_footer;

@end
