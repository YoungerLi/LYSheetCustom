//
//  RegionModel.h
//  Demo
//
//  Created by liyang on 2018/12/14.
//  Copyright © 2018 kosien. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///省
@interface RegionModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *citys;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END




///市
@interface CityModel : NSObject

@property (nonatomic, copy) NSString *city;
@property (nonatomic, strong) NSArray *areas;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
