//
//  Target_WDZLocationManager.h
//  WDZForAppStore
//
//  Created by Daniel on 2019/5/8.
//  Copyright © 2019 Wandianzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_WDZLocationManager : NSObject

// 单次定位
- (void)Action_locationSigle:(NSDictionary *)params;
// 多次定位
- (void)Action_repeatedlyLocation:(NSDictionary *)params;
// 停止定位
- (void)Action_stoplocation;

@end

NS_ASSUME_NONNULL_END
