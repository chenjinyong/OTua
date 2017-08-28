//
//  HontelModel.h
//  GetHotels
//
//  Created by admin on 2017/8/28.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HontelModel : NSObject
@property (strong,nonatomic) NSString *endRow;
@property (strong,nonatomic) NSString *firstPage;
@property (strong,nonatomic) NSString *hasNextPage;
@property (strong,nonatomic) NSString *hasPreviousPage;
@property (strong,nonatomic) NSString *isFirstPage;
@property (strong,nonatomic) NSString *isLastPage;
@property (strong,nonatomic) NSString *lastPage;
@property (strong,nonatomic) NSString *list;

- (instancetype)initWithDict: (NSDictionary *)dict;
@end
