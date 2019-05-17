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

//是否是持续定位,默认为否(单次定位)
@property (nonatomic , assign)BOOL isLongLocation;
//获取返回的地址等信息
@property (nonatomic , copy)getLocationBlock block;
/**
 定位管理者
 */
@property (nonatomic , retain)AMapLocationManager *locationManager;

- (instancetype)initWithAppKey:(NSString *)appkey;

/**
 开始定位,支持单次定位和持续定位,如果需要持续定位,则设置isLongLocation = YES
 */
-(void)locationSigle;

- (void)stoplocation;

@end
