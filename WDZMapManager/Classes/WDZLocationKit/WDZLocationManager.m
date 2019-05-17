//
//  KDLocationManager.m
//  WDZForAppStore
//
//  Created by 夏征宇 on 2018/6/11.
//  Copyright © 2018年 Wandianzhang. All rights reserved.
//

#import "WDZLocationManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface WDZLocationManager ()<AMapLocationManagerDelegate,AMapSearchDelegate>
{
    AMapLocationManager *_locationManager;
    AMapSearchAPI *_mapSearch;
    CLLocation *selfLocation;
    NSInteger num;//返回的次数
    NSString *_appKey;
}

@end

@implementation WDZLocationManager
    
- (instancetype)init {
    
    if (self = [super init]) {
        
//        //设置mapKey
//        NSDictionary *appkey = ConfigData(@"APPKEY");
//        NSString *key = appkey[@"MapAppKey"];
//
//        [AMapServices sharedServices].apiKey = key;
        
        [self initManager];
        
    }
    return self;
}

- (instancetype)initWithAppKey:(NSString *)appkey {
    
    if (self = [super init]) {
        
        [AMapServices sharedServices].apiKey = appkey;
        
        [self initManager];
    }
    return self;
}
    
- (void)initManager {
    
    if (!_locationManager) {
        
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.locationTimeout = 10;
        _locationManager.reGeocodeTimeout = 10;
        _locationManager.distanceFilter = 100;//最小更新距离
        [_locationManager setLocatingWithReGeocode:YES];//设置返回逆地理位置编码
    }
    
    if (!_mapSearch) {
        _mapSearch = [[AMapSearchAPI alloc] init];
        _mapSearch.delegate = self;
    }
}
    
/**
 开始定位
 */
-(void)locationSigle
{
    num = 0;
    //开启持续定位,因为目前支持的是单次定位,采用的方案是持续定位的第一次返回位置,作为单次定位
    [_locationManager startUpdatingLocation];
}
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    selfLocation = [location copy];
    //获取到地理位置
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    regeo.requireExtension = YES;
    [_mapSearch AMapReGoecodeSearch:regeo];
}
//获取搜索出来的建筑物地址,主要根据此方法返回信息
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode.formattedAddress.length > 0) {
        num++;
        if (!self.isLongLocation) {//单次定位
            if (num == 1) {
                self.block(YES, selfLocation, response.regeocode.formattedAddress);
                    [_locationManager stopUpdatingLocation];//获取到地址即停止持续定位
            }
        }else{//持续定位,一直不停的返回
            self.block(YES, selfLocation, response.regeocode.formattedAddress);
        }
    }
}

/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{

}

/**
 *  @brief 连续定位回调函数.注意：本方法已被废弃，如果实现了amapLocationManager:didUpdateLocation:reGeocode:方法，则本方法将不会回调。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{

}


/**
 *  @brief 定位权限状态改变时回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param status 定位权限状态。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{

}

/**
 *  @brief 设备方向改变时回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param newHeading 设备朝向。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{

}

/**
 *  @brief 开始监控region回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param region 开始监控的region。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didStartMonitoringForRegion:(AMapLocationRegion *)region __attribute__((deprecated("请使用AMapGeoFenceManager")))
{

}

/**
 *  @brief 进入region回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param region 进入的region。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didEnterRegion:(AMapLocationRegion *)region __attribute__((deprecated("请使用AMapGeoFenceManager")))
{

}

/**
 *  @brief 离开region回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param region 离开的region。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didExitRegion:(AMapLocationRegion *)region __attribute__((deprecated("请使用AMapGeoFenceManager")))
{

}




-(AMapLocationManager *)locationManager
{

    _locationManager = [[AMapLocationManager alloc] init];
    //设置精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //设置定位超时时间//最低2秒
    _locationManager.locationTimeout = 3;
    //逆地理位置请求你超时时间，最低2秒
    _locationManager.reGeocodeTimeout = 3;
    return _locationManager;
}

- (void)stoplocation
{
    [self.locationManager stopUpdatingLocation];
}
    
@end
