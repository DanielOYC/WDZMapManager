//
//  Target_WDZLocationManager.m
//  WDZForAppStore
//
//  Created by Daniel on 2019/5/8.
//  Copyright © 2019 Wandianzhang. All rights reserved.
//

#import "Target_WDZLocationManager.h"
#import "WDZLocationManager.h"
#import <AMapSearchKit/AMapSearchKit.h>

typedef void (^WDZLocationCallbackBlock)(BOOL isSuccess, CLLocation *location, NSString *addressString);
// MARK: 为提高外部使用的灵活性，将`逆地理位置编码结果`返回 使用的地方需要引入 #import <AMapSearchKit/AMapSearchKit.h>
typedef void (^WDZLocationCallbackBlock2)(BOOL isSuccess, CLLocation *location, AMapReGeocode *regeocode);

@interface Target_WDZLocationManager ()

@property (strong, nonatomic) WDZLocationManager *locationManager;

@end

@implementation Target_WDZLocationManager

- (void)Action_locationSigle:(NSDictionary *)params {
    
    
    [self.locationManager startSingleLocation];
    self.locationManager.block = ^(BOOL isSuccess, CLLocation *location, NSString *addressString) {
        
        WDZLocationCallbackBlock callBack = params[@"locationBlock"];
        if (callBack) {
            callBack(isSuccess,location,addressString);
        }
    };
    
    // MARK: 为提高外部使用的灵活性，将`逆地理位置编码结果`返回
    self.locationManager.block2 = ^(BOOL isSuccess, CLLocation *location, AMapReGeocode *regeocode) {
        WDZLocationCallbackBlock2 callBack = params[@"locationBlock"];
        if (callBack) {
            callBack(isSuccess,location,regeocode);
        }
    };
}

- (void)Action_repeatedlyLocation:(NSDictionary *)params {
    
    [self.locationManager startRepeatedlyLocation];
    
    self.locationManager.block = ^(BOOL isSuccess, CLLocation *location, NSString *addressString) {
        
        WDZLocationCallbackBlock callBack = params[@"locationBlock"];
        if (callBack) {
            callBack(isSuccess,location,addressString);
        }
    };
    
    // MARK: 为提高外部使用的灵活性，将`逆地理位置编码结果`返回
    self.locationManager.block2 = ^(BOOL isSuccess, CLLocation *location, AMapReGeocode *regeocode) {
        WDZLocationCallbackBlock2 callBack = params[@"locationBlock"];
        if (callBack) {
            callBack(isSuccess,location,regeocode);
        }
    };
}

- (void)Action_stoplocation {
    
    [self.locationManager stopLocation];
}

- (WDZLocationManager *)locationManager {
    
    if (!_locationManager) {
        _locationManager = [[WDZLocationManager alloc] init];
    }
    return _locationManager;
}

@end
