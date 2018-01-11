//
//  CPLiteRefreshHeader.m
//    
//
//  Created by chengfei xiao on 2017/12/13.
//  Copyright © 2017年 CrespoXiao. All rights reserved.
//

#import "CPLiteRefreshHeader.h"
#import "CPLiteRefreshTipView.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

#define CPRefresh_DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

static const CGFloat CP_DefaultHeight = 80.f;
static const CGFloat CP_AnimationDuration = 1.f;
static const CGFloat CP_AnimationDamping = 0.4f;
static const CGFloat CP_AnimationVelosity = 0.8f;

static const CGFloat CP_CircleAngle = 360.f;
static const CGFloat CP_SpringTreshold = 118.0f; //80 + icon 高度38
static const CGFloat CP_RotateAnimationDuration = 0.95f;

@interface CPLiteRefreshHeader ()

@property (weak, nonatomic) IBOutlet UIImageView *rotateImgaeView;
@property (nonatomic,  weak) UIScrollView *scrollView;
@property (nonatomic,assign) BOOL forbidRotateSet;
@property (nonatomic,assign) BOOL forbidContentInsetChanges;
@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;//防止调用方没有调用 endRefreshing

@property (nonatomic, strong) CPLiteRefreshTipView *tipView;

@end

@implementation CPLiteRefreshHeader

#pragma clang diagnostic ignored "-Wobjc-designated-initializers"

#pragma mark - life cycle

-(void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(returnToDefaultState) object:nil];
    _refreshBlock = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [[[NSBundle mainBundle] loadNibNamed:@"CPRefreshControl" owner:self options:nil] firstObject];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.rotateImgaeView.image = [UIImage imageNamed:@"refresh_rotate"];
    [self addGestureRecognizer:self.tapGesture];
    [self insertSubview:self.tipView belowSubview:self.rotateImgaeView];
    [self makeConstraints];
    [self showTipView:NO];
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] init];
        __weak __typeof(self)weakSelf = self;
        [[[_tapGesture rac_gestureSignal] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
           __strong __typeof(weakSelf)strongSelf = weakSelf;
            CGPoint touchPoint = [strongSelf.tapGesture locationInView:strongSelf.rotateImgaeView];
            if ((touchPoint.x > 0 && touchPoint.x < strongSelf.rotateImgaeView.frame.size.width) &&
                (touchPoint.y > 0 && touchPoint.y < strongSelf.rotateImgaeView.frame.size.height)) {
                [strongSelf endRefreshing];
            }
        }];
    }
    return _tapGesture;
}

#pragma mark - setter

- (void)setBgType:(CPLiteRefreshTipBgType)bgType {
    _bgType = bgType;
    self.tipView.bgType = bgType;
    self.tipView.tipType = CPLiteRefreshTipStyleType_Header;
}

#pragma mark - lazy load

- (CPLiteRefreshTipView *)tipView {
    if (!_tipView) {
        _tipView = [[CPLiteRefreshTipView alloc] init];
    }
    return _tipView;
}

- (void)makeConstraints {
    [self.tipView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(@40);
    }];
}

- (void)showTipView:(BOOL)show {
    if (show) {
        if (self.tipView.alpha == 0) {
            self.tipView.alpha = 0.01f;
            [UIView animateWithDuration:0.2f animations:^{
                self.tipView.alpha = 1.0f;
            }];
        }
    } else {
        if (self.tipView.alpha == 1.0) {
            self.tipView.alpha = 0.99f;
            [UIView animateWithDuration:0.2f animations:^{
                self.tipView.alpha = 0;
            }];
        }
    }
}

#pragma mark - public methods

- (void)attachToScrollView:(UIScrollView *)scrollView {
    if (!self.superview) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(returnToDefaultState) object:nil];
        self.scrollView = scrollView;

        __weak __typeof(self)weakSelf = self;
        [[RACObserve(self.scrollView, contentOffset) takeUntil:[self.scrollView rac_willDeallocSignal]] subscribeNext:^(id  _Nullable x) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf calculateShift];
        }];
        
        [self setFrame:CGRectMake(0.f, 0.f, scrollView.frame.size.width, 0.f)];
        [scrollView addSubview:self];
        self.backgroundColor = scrollView.backgroundColor;
    }
}

- (void)unAttachToScrollView {
    if (self.superview) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(returnToDefaultState) object:nil];
        [self returnToDefaultState];
        self.scrollView = nil;
        [self removeFromSuperview];
    }
}

-(void)beginRefreshing {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(returnToDefaultState) object:nil];
    [self.scrollView setContentInset:UIEdgeInsetsMake(CP_DefaultHeight, 0.f, 0.f, 0.f)];
    [self.scrollView setContentOffset:CGPointMake(0.f, -CP_DefaultHeight) animated:YES];
    self.forbidContentInsetChanges = YES;
}

-(void)endRefreshing {
    if(self.scrollView.contentOffset.y > -CP_DefaultHeight) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(returnToDefaultState) object:nil];
        [self performSelector:@selector(returnToDefaultState) withObject:nil afterDelay:CP_AnimationDuration];
    } else {
        [self returnToDefaultState];
    }
}

#pragma mark - KVO methods

-(void)calculateShift {
    [self setFrame:CGRectMake(0.f,0.f,self.scrollView.frame.size.width,self.scrollView.contentOffset.y)];
    if(self.scrollView.contentOffset.y <= -CP_DefaultHeight) {
        if(self.scrollView.contentOffset.y == -CP_SpringTreshold) {
            [self showTipView:YES];//滑不动了
        } else if(self.scrollView.contentOffset.y < -CP_SpringTreshold) {
            [self.scrollView setContentOffset:CGPointMake(0.f, -CP_SpringTreshold)];
        }
        
        if(!self.forbidRotateSet) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            self.forbidRotateSet = YES;
        }
    }
    
    if(!self.scrollView.dragging && self.forbidRotateSet && self.scrollView.decelerating && !self.forbidContentInsetChanges){
        [self beginRefreshing];
        [self showTipView:NO];
        [self rotateSunInfinitely]; // 开始无限旋转
    }
    
    if(!self.forbidRotateSet) { // 边拉边旋转
        [self transformWhenPullToRefresh];
    }
}


-(void)transformWhenPullToRefresh {
    CGFloat shiftInPercents = [self shiftInPercents];
    CGFloat rotationAngle = (CP_CircleAngle / CP_DefaultHeight) * shiftInPercents;
    self.rotateImgaeView.transform = CGAffineTransformMakeRotation(CPRefresh_DEGREES_TO_RADIANS(rotationAngle));
}

-(CGFloat)shiftInPercents {
    return (CP_DefaultHeight / CP_DefaultHeight) * -self.scrollView.contentOffset.y;
}

#pragma mark - animation

-(void)returnToDefaultState {
    self.forbidContentInsetChanges = NO;
    [UIView animateWithDuration:CP_AnimationDuration
                          delay:0.f
         usingSpringWithDamping:CP_AnimationDamping
          initialSpringVelocity:CP_AnimationVelosity
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0.f, 0.f, 0.f)];
                     } completion:nil];
    self.forbidRotateSet = NO;
    [self stopSunRotating];
}

-(void)rotateSunInfinitely {
    if(!self.isRefreshing) {
        self.isRefreshing = YES;
        self.forbidRotateSet = YES;
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = @(M_PI * 2.0);
        rotationAnimation.duration = CP_RotateAnimationDuration;
        rotationAnimation.autoreverses = NO;
        rotationAnimation.repeatCount = HUGE_VALF;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.rotateImgaeView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

-(void)stopSunRotating {
    self.isRefreshing = NO;
    self.forbidRotateSet = NO;
    [self.rotateImgaeView.layer removeAnimationForKey:@"rotationAnimation"];
}

@end

