//
//  GethontelModel.h
//  GetHotels
//
//  Created by admin on 2017/8/25.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GethontelModel : NSObject
@property (strong,nonatomic) NSString *distance;
@property (strong,nonatomic) NSString *hotel_address;
@property (strong,nonatomic) NSString *hotel_name;
@property (strong,nonatomic) NSString *Price;
@property (strong,nonatomic) NSString *latitude;
@property (strong,nonatomic) NSString *longitude;


- (instancetype)initWithDict: (NSDictionary *)dict;
@end
