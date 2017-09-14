//
//  DetailModel.m
//  convergence
//
//  Created by admin on 2017/9/11.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self ==[super init]) {
        _clubAddressB = [Utilities nullAndNilCheck:dict[@"clubAddressB"] replaceBy:@""];
        _fImgUrl = [Utilities nullAndNilCheck:dict[@"fImgUrl"] replaceBy:@""];
        _fName = [Utilities nullAndNilCheck:dict[@"fName"] replaceBy:@""];
        _fId = [Utilities nullAndNilCheck:dict[@"fId"] replaceBy:@""];
        _fName = [Utilities nullAndNilCheck:dict[@"fName"] replaceBy:@""];
        _grayImgUrl = [Utilities nullAndNilCheck:dict[@"grayImgUrl"] replaceBy:@""];
        _greenImgUrl = [Utilities nullAndNilCheck:dict[@"greenImgUrl"] replaceBy:@""];
        _clubJing = [Utilities nullAndNilCheck:dict[@"clubJing"] replaceBy:@""];
        _clubMember = [Utilities nullAndNilCheck:dict[@"clubMember"] replaceBy:@""];
        _clubMoods = [Utilities nullAndNilCheck:dict[@"clubMoods"] replaceBy:@""];
        _clubName = [Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@""];
        _clubPerson = [Utilities nullAndNilCheck:dict[@"clubPerson"] replaceBy:@""];
        _clubIntroduce = [Utilities nullAndNilCheck:dict[@"clubIntroduce"] replaceBy:@""];
        _openTime = [Utilities nullAndNilCheck:dict[@"openTime"] replaceBy:@""];
        
        _clubSite = [Utilities nullAndNilCheck:dict[@"clubSite"] replaceBy:@""];
        _storeNums = [Utilities nullAndNilCheck:dict[@"storeNums"] replaceBy:@""];
        _name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@""];
 
        _eLogo = [Utilities nullAndNilCheck:dict[@"eLogo"] replaceBy:@""];
        _address = [Utilities nullAndNilCheck:@"address" replaceBy:@""];
        _eName = [Utilities nullAndNilCheck:dict[@"eName"] replaceBy:@""];
        _price = [[Utilities nullAndNilCheck:dict[@"price"] replaceBy:@""]integerValue];
        _number = [[Utilities nullAndNilCheck:dict[@"number"] replaceBy:@""]integerValue];
        
    }
    return self;
}
@end
