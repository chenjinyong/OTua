//
//  EnterModel.m
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "EnterModel.h"

@implementation EnterModel

- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
    _grade = [Utilities nullAndNilCheck:dict[@"grade"] replaceBy:@""];
    _head = [Utilities nullAndNilCheck:dict[@"head_img"] replaceBy:@"未设置"];
    _userId = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"未命名"];
    _cardId = [Utilities nullAndNilCheck:dict[@"id_card"] replaceBy:@"0"];
    _nickname = [Utilities nullAndNilCheck:dict[@"nick_name"] replaceBy:@"未命名"];
    _openid = [Utilities nullAndNilCheck:dict[@"openid"] replaceBy:@"0"];
    _password = [Utilities nullAndNilCheck:dict[@"password"] replaceBy:@"0"];
    _tel = [Utilities nullAndNilCheck:dict[@"tel"] replaceBy:@"0"];
        
        if ([dict[@"gender"] isKindOfClass:[NSNull class]]) {
            _gender = @"";
        }else{
            switch ([dict[@"gerder"] integerValue]) {
                case 1:
                    _gender = @"男";
                    break;
                case 2:
                    _gender = @"女";
                    break;
                    
                default:
                    _gender = @"未设置";
                    break;
            }
        }
    }
    return self;
}

@end
