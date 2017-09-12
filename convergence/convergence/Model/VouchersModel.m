//
//  VouchersModel.m
//  convergence
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "VouchersModel.h"

@implementation VouchersModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if(self = [super init]){
        _eLogo = [Utilities nullAndNilCheck:dict[@"eLogo"] replaceBy:@""];
        _eName =[Utilities nullAndNilCheck:dict[@"eName"] replaceBy:@""];
        _currentPrice =[Utilities nullAndNilCheck:dict[@"currentPrice"] replaceBy:@""];
        _orginPrice = [Utilities nullAndNilCheck:dict[@"orginPrice"] replaceBy:@""];
        _endDate = [Utilities nullAndNilCheck:dict[@"endDate"] replaceBy:@""];
        _beginDate = [Utilities nullAndNilCheck:dict[@"beginDate"] replaceBy:@""];
        _eAddress = [Utilities nullAndNilCheck:dict[@"eAddress"] replaceBy:@""];
        _eClubName = [Utilities nullAndNilCheck:dict[@"eClubName"] replaceBy:@""];
        _clubTel = [Utilities nullAndNilCheck:dict[@"clubTel"] replaceBy:@""];
        _saleCount = [Utilities nullAndNilCheck:dict[@"saleCount"] replaceBy:@""];
        _status = [Utilities nullAndNilCheck:dict[@"status"] replaceBy:@""];
        _useDate = [Utilities nullAndNilCheck:dict[@"useDate"] replaceBy:@""];
        _rules = [Utilities nullAndNilCheck:dict[@"rules"] replaceBy:@""];
        _ePromot = [Utilities nullAndNilCheck:dict[@"ePromot"] replaceBy:@""];
        _eFeature = [Utilities nullAndNilCheck:dict[@"eFeature"] replaceBy:@""];
        _experienceQuantity = [Utilities nullAndNilCheck:dict[@"experienceQuantity"] replaceBy:@""];
        _longitude = [Utilities nullAndNilCheck:dict[@"longitude"] replaceBy:@""];
        _latitude = [Utilities nullAndNilCheck:dict[@"latitude"] replaceBy:@""];
        
        
        
    }
    return self;
}
@end
