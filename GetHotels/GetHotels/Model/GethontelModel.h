//
//  GethontelModel.h
//  GetHotels
//
//  Created by admin on 2017/8/25.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GethontelModel : NSObject
@property (strong,nonatomic) NSString *ad_img;
@property (strong,nonatomic) NSString *ad_name;
@property (strong,nonatomic) NSString *ad_url;
@property (strong,nonatomic) NSString *id;
@property (strong,nonatomic) NSString *start_time;



- (instancetype)initWithDict: (NSDictionary *)dict;
@end
