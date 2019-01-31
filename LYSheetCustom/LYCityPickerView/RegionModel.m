//
//  RegionModel.m
//  Demo
//
//  Created by liyang on 2018/12/14.
//  Copyright © 2018 kosien. All rights reserved.
//

#import "RegionModel.h"

@implementation RegionModel

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    RegionModel *model = [[RegionModel alloc] init];
    
    model.name = dict[@"state"];
    model.citys = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in dict[@"cities"]) {
        CityModel *cityModel = [CityModel modelWithDict:dic];
        [model.citys addObject:cityModel];
    }
    
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end




@implementation CityModel

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    CityModel *model = [[CityModel alloc] init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
