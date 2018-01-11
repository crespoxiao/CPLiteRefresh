//
//  CPLiteRefreshFooter.m
//   
//
//  Created by chengfei xiao on 2018/01/10.
//  Copyright © 2017年 CrespoXiao. All rights reserved.
//

#import "CPLiteRefreshFooter.h"
#import "CPLiteRefreshTipView.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

static const CGFloat CP_FooterHeight = 80.f;


@interface CPLiteRefreshFooter ()

@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic,   weak) UIScrollView *scrollView;
@property (nonatomic, strong) CPLiteRefreshTipView *tipView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) CGFloat  contentHeight;

@end



@implementation CPLiteRefreshFooter

#pragma mark - life cycle

-(void)dealloc {
    if (_activityView.isAnimating) {
        [_activityView stopAnimating];
    }
    _refreshBlock = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.tipView];
        [self addSubview:self.activityView];
        [self makeConstraints];
    }
    return self;
}

#pragma mark - setter

- (void)setBgType:(CPLiteRefreshTipBgType)bgType {
    _bgType = bgType;
    self.tipView.bgType = bgType;
    self.tipView.tipType = CPLiteRefreshTipStyleType_Footer;
}

- (void)setIsNoMoreData:(BOOL)isNoMoreData {
    _isNoMoreData = isNoMoreData;
    BOOL isDisplayTipView = NO;
    if (_isNoMoreData) {
        if ((self.contentHeight > self.scrollView.frame.size.height)) {
            self.isRefreshing = NO;
            self.frame = CGRectMake(0, self.contentHeight, self.scrollView.frame.size.width, CP_FooterHeight);
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, CP_FooterHeight, 0);
            [self.activityView stopAnimating];
            [self showTipView:YES animated:YES];
            isDisplayTipView = YES;
        }
    }
    if (!isDisplayTipView) {
        self.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, self.scrollView.frame.size.width, CP_FooterHeight);
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark - lazy load

- (CPLiteRefreshTipView *)tipView {
    if (!_tipView) {
        _tipView = [[CPLiteRefreshTipView alloc] init];
    }
    return _tipView;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityView;
}

- (void)makeConstraints {
    [self.tipView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(@40);
    }];
    
    [self.activityView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
}

- (void)showTipView:(BOOL)show animated:(BOOL)animated {
    if (show) {
        if (self.tipView.alpha == 0) {
            self.tipView.alpha = 0.01f;
            [UIView animateWithDuration:animated ? 0.2f:0 animations:^{
                self.tipView.alpha = 1.0f;
            }];
        }
    } else {
        if (self.tipView.alpha == 1.0) {
            self.tipView.alpha = 0.99f;
            [UIView animateWithDuration:animated ? 0.2f:0 animations:^{
                self.tipView.alpha = 0;
            }];
        }
    }
}
#pragma mark - public methods

- (void)attachToScrollView:(UIScrollView *)scrollView {
    if (!self.superview) {
        self.scrollView = scrollView;
        __weak __typeof(self)weakSelf = self;
        [[RACObserve(self.scrollView, contentOffset) takeUntil:[self.scrollView rac_willDeallocSignal]] subscribeNext:^(id  _Nullable x) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf observeContentOffset];
        }];
        [scrollView addSubview:self];
        self.backgroundColor = scrollView.backgroundColor;
        
        self.contentHeight = self.scrollView.contentSize.height;
        if ((self.scrollView.contentOffset.y > (self.contentHeight - self.scrollView.frame.size.height)) &&
            (self.contentHeight > self.scrollView.frame.size.height)) {
            self.frame = CGRectMake(0, self.contentHeight, self.scrollView.frame.size.width, CP_FooterHeight);
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, CP_FooterHeight, 0);
        } else {
            self.frame = CGRectMake(0, -[[UIScreen mainScreen] bounds].size.height, self.scrollView.frame.size.width, CP_FooterHeight);
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
}

- (void)unAttachToScrollView {
    if (self.superview) {
        self.scrollView = nil;
        [self removeFromSuperview];
    }
}


-(void)beginRefreshing {
    if (!self.isRefreshing) {
        self.isRefreshing = YES;
        [self.activityView startAnimating];
        [UIView animateWithDuration:0.3f animations:^{
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, CP_FooterHeight, 0);
        }];
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }
}

-(void)endRefreshing {
    if (!self.isNoMoreData) {
        self.isRefreshing = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3f animations:^{
                [self.activityView stopAnimating];
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                self.frame = CGRectMake(0, self.contentHeight, [[UIScreen mainScreen] bounds].size.width, CP_FooterHeight);
            }];
        });
    }
}

#pragma mark - private method

- (void)observeContentOffset {
    self.contentHeight = self.scrollView.contentSize.height;
    if ((self.scrollView.contentOffset.y > (self.contentHeight - self.scrollView.frame.size.height)) &&
        (self.contentHeight > self.scrollView.frame.size.height)) {
        self.frame = CGRectMake(0, self.contentHeight, self.scrollView.frame.size.width, CP_FooterHeight);
        if (!self.isNoMoreData) {
            [self showTipView:NO animated:NO];
            [self beginRefreshing];
        }
    }
}

@end
