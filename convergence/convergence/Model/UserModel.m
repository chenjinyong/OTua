//
//  UserModel.m
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _memberId = [Utilities nullAndNilCheck:dict[@"memberId"] replaceBy:@"0"];
        _phone = [Utilities nullAndNilCheck:dict[@"contactTel"] replaceBy:@"未设置"];
        _nickname = [Utilities nullAndNilCheck:dict[@"memberName"] replaceBy:@"未命名"];
        _age = [Utilities nullAndNilCheck:dict[@"age"] replaceBy:@"0"];
        _dob = [Utilities nullAndNilCheck:dict[@"birthday"] replaceBy:@"0"];
        _idCardNo = [Utilities nullAndNilCheck:dict[@"identificationcard"] replaceBy:@"0"];
        _credit = [Utilities nullAndNilCheck:dict[@"memberPoint"] replaceBy:@"0"];
        _avatarUrl = [Utilities nullAndNilCheck:dict[@"memberUrl"] replaceBy:@""];
        _tokenKey = [Utilities nullAndNilCheck:dict[@"key"] replaceBy:@""];
        
        if ([dict[@"memberSex"] isKindOfClass:[NSNull class]]) {
            _gender = @"";
        }else{
            switch ([dict[@"memberSex"] integerValue]) {
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
