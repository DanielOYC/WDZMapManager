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
#import <MAMapKit/MAMapKit.h>

@interface WDZLocationManager ()<AMapLocationManagerDelegate,AMapSearchDelegate>
{
    AMapLocationManager *_locationManager;
    AMapSearchAPI *_mapSearch;
    CLLocation *_currentLocation;
    NSInteger _num;//定位次数
    NSString *_appKey;
    BOOL _isRepeatLocation;
}
@end

@implementation WDZLocationManager
    
- (instancetype)init {
    
    if (self = [super init]) {
        
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
 开启单次定位
 */
- (void)startSingleLocation {
    
    _isRepeatLocation = NO;
    _num = 0;
    //开启持续定位,因为目前支持的是单次定位,采用的方案是持续定位的第一次返回位置,作为单次定位
    [_locationManager startUpdatingLocation];
}

/**
 开启多次定位
 */
- (void)startRepeatedlyLocation {
    
    [self startSingleLocation];
    _isRepeatLocation = YES;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    
    _currentLocation = [location copy];
    //获取到地理位置
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    regeo.requireExtension = YES;
    [_mapSearch AMapReGoecodeSearch:regeo];
}

/// 当定位发生错误时，会调用代理的此方法。
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    //定位失败
    if (error) {
        self.block(NO, nil, nil);
    }
}

//获取搜索出来的建筑物地址,主要根据此方法返回信息
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    
    if (response.regeocode.formattedAddress.length > 0) {
        _num++;
        if (!_isRepeatLocation) {//单次定位
            if (_num == 1) {
                !self.block?:self.block(YES, _currentLocation, response.regeocode.formattedAddress);
                !self.block2?:self.block2(YES, _currentLocation, response.regeocode);
                [_locationManager stopUpdatingLocation];//获取到地址即停止持续定位
            }
        }else{//持续定位,一直不停的返回
            !self.block?:self.block(YES, _currentLocation, response.regeocode.formattedAddress);
            !self.block2?:self.block2(YES, _currentLocation, response.regeocode);
        }
    }
}

- (AMapLocationManager *)locationManager {

    _locationManager = [[AMapLocationManager alloc] init];
    //设置精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //设置定位超时时间//最低2秒
    _locationManager.locationTimeout = 3;
    //逆地理位置请求你超时时间，最低2秒
    _locationManager.reGeocodeTimeout = 3;
    return _locationManager;
}

- (void)stopLocation {
    
    [self.locationManager stopUpdatingLocation];
}

+ (UIView *)mapView {
    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    MAMapView *_mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    
    return _mapView;
}

#pragma mark - getter,setter
+ (void)setAmapAppKey:(NSString *)appKey {
    
    [AMapServices sharedServices].apiKey = appKey;
}
@end
