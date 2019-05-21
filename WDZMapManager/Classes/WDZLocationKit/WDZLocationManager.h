//
//  KDLocationManager.h
//  WDZForAppStore
//  定位实现类(单次定位)
//  Created by 夏征宇 on 2018/6/11.
//  Copyright © 2018年 Wandianzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class AMapLocationManager;

typedef void(^getLocationBlock)(BOOL isSuccess,CLLocation *location , NSString *addressString);

@interface WDZLocationManager : NSObject

//获取返回的地址等信息
@property (nonatomic , copy) getLocationBlock block;
// 高德定位对象
@property (nonatomic , retain) AMapLocationManager *locationManager;

// 设置高德地图appKey
+ (void)setAmapAppKey:(NSString *)appKey;

- (instancetype)initWithAppKey:(NSString *)appkey;

/**
 开启单次定位
 */
- (void)startSingleLocation;

/**
 开启持续定位
 */
- (void)startRepeatedlyLocation;

/**
 停止定位
 */
- (void)stopLocation;

@end
