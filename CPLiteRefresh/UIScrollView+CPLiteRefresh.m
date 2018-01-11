//
//  UIScrollView+CPLiteRefresh.m
//   
//
//  Created by chengfei xiao on 2018/1/11.
//  Copyright © 2018年 CrespoXiao. All rights reserved.
//

#import "UIScrollView+CPLiteRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (CPLiteRefresh)

#pragma mark - setter

- (void)setCp_header:(CPLiteRefreshHeader *)cp_header {
    if (cp_header != self.cp_header) {
        [self.cp_header removeFromSuperview];
        [self insertSubview:cp_header atIndex:0];
        
        [self willChangeValueForKey:@"cp_header"]; // KVO
        objc_setAssociatedObject(self, _cmd, cp_header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"cp_header"];
    }
}

- (void)setCp_footer:(CPLiteRefreshFooter *)cp_footer {
    if (cp_footer != self.cp_footer) {
        [self.cp_footer removeFromSuperview];
        [self insertSubview:cp_footer atIndex:0];
        
        [self willChangeValueForKey:@"cp_footer"]; // KVO
        objc_setAssociatedObject(self, _cmd, cp_footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"cp_footer"];
    }
}

#pragma mark - getter

- (CPLiteRefreshHeader *)cp_header {
    CPLiteRefreshHeader *header = objc_getAssociatedObject(self, _cmd);
    if (header == nil) {
        header = [[CPLiteRefreshHeader alloc] init];
        [header attachToScrollView:self];
        objc_setAssociatedObject(self, _cmd, header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return header;
}

- (CPLiteRefreshFooter *)cp_footer {
    CPLiteRefreshFooter *footer = objc_getAssociatedObject(self, _cmd);
    if (footer == nil) {
        footer = [[CPLiteRefreshFooter alloc] init];
        [footer attachToScrollView:self];
        objc_setAssociatedObject(self, _cmd, footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return footer;
}

@end
