//
//  CPLiteRefreshDefine.h
//   
//
//  Created by chengfei xiao on 2018/01/10.
//  Copyright © 2017年 CrespoXiao. All rights reserved.
//

#ifndef CPLiteRefreshDefine_h
#define CPLiteRefreshDefine_h

typedef void (^CPrefreshBlock)(void);

typedef NS_ENUM (NSUInteger, CPLiteRefreshTipBgType) {
    CPLiteRefreshTipBgType_Light, //背景浅色
    CPLiteRefreshTipBgType_Dark, //背景深色
};


typedef NS_ENUM (NSUInteger, CPLiteRefreshTipStyleType) {
    CPLiteRefreshTipStyleType_Header, //下拉刷新的tip
    CPLiteRefreshTipStyleType_Footer, //上滑加载的tip
};

#endif /* CPLiteRefreshDefine_h */
