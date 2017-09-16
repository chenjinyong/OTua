//
//  FoundModel.h
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoundModel : NSObject
@property (strong,nonatomic)NSString *address;
@property (strong,nonatomic)NSString *distance;
@property (strong,nonatomic)NSString *image;
@property (strong,nonatomic)NSString *name;
@property (strong,nonatomic)NSString *logo;
@property (strong,nonatomic)NSString *orginPrice;
@property (strong,nonatomic)NSArray *models;
@property (strong,nonatomic)NSString *clubId;
//@property (strong,nonatomic)NSInteger ellNumber;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
