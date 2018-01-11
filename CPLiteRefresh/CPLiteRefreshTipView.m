//
//  CPLiteRefreshTipView.m
//   
//
//  Created by chengfei xiao on 2018/01/10.
//  Copyright © 2017年 CrespoXiao. All rights reserved.
//

#import "CPLiteRefreshTipView.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface CPLiteRefreshTipView ()

@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *descLbl;

@end



@implementation CPLiteRefreshTipView

- (instancetype)init {
    self = [super init];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tipImageView];
        [self addSubview:self.descLbl];
    }
    return self;
}

#pragma mark - layz load

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] init];
        _tipImageView.contentMode = UIViewContentModeScaleToFill;
        [_tipImageView setImage:[UIImage imageNamed:@"headerTip_green"]];
    }
    return _tipImageView;
}

- (UILabel *)descLbl {
    if (!_descLbl) {
        _descLbl = [[UILabel alloc] init];
        _descLbl.textAlignment = NSTextAlignmentCenter;
        _descLbl.numberOfLines = 1;
        _descLbl.lineBreakMode = NSLineBreakByTruncatingTail;
        _descLbl.font = [UIFont systemFontOfSize:12];
        _descLbl.text = @"滑不动啦，松手刷新吧";
        _descLbl.textColor = [UIColor blackColor];
    }
    return _descLbl;
}

#pragma mark -  constraints

- (void)makeConstriants {
    [self.tipImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.tipType == CPLiteRefreshTipStyleType_Header) {
            make.top.equalTo(self);
        } else {
            make.bottom.equalTo(self);
        }
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(22, 13));
    }];
    
    [self.descLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.tipType == CPLiteRefreshTipStyleType_Header) {
            make.bottom.equalTo(self);
        } else {
            make.top.equalTo(self);
        }
        make.left.right.equalTo(self);
    }];
}

#pragma mark - setter

- (void)setBgType:(CPLiteRefreshTipBgType)bgType {
    _bgType = bgType;
    if (_bgType == CPLiteRefreshTipBgType_Dark) {
        _descLbl.textColor = [UIColor whiteColor];
    } else {
        _descLbl.textColor = [UIColor blackColor];
    }
}


- (void)setTipType:(CPLiteRefreshTipStyleType)tipType {
    _tipType = tipType;
    if (_tipType == CPLiteRefreshTipStyleType_Header) {
        _descLbl.text = @"滑不动啦，松手刷新吧";
        if (self.bgType == CPLiteRefreshTipBgType_Dark) {
            [_tipImageView setImage:[UIImage imageNamed:@"headerTip_dark"]];
        } else {
            [_tipImageView setImage:[UIImage imageNamed:@"headerTip_green"]];
        }
    } else { // footer 
        _descLbl.text = @"到底啦，没有更多啦";
        if (self.bgType == CPLiteRefreshTipBgType_Dark) {
            [_tipImageView setImage:[UIImage imageNamed:@"footerTip_dark"]];
        } else {
            [_tipImageView setImage:[UIImage imageNamed:@"footerTip_green"]];
        }
    }
    [self makeConstriants];
}

@end
