//
//  ConvergenceModel.h
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvergenceModel : NSObject

@property (strong,nonatomic)NSString *address;
@property (strong,nonatomic)NSString *distance;
@property (strong,nonatomic)NSString *categoryName;//类别名称
@property (strong,nonatomic)NSString *detailid;
@property (strong,nonatomic)NSString *Image;
@property (strong,nonatomic)NSString *image;
@property (strong,nonatomic)NSString *logo;
@property (strong,nonatomic)NSString *imgurl;
@property (strong,nonatomic)NSString *name;
@property (nonatomic) NSInteger  Price;  
@property (nonatomic) NSInteger orginPrice;
@property (strong,nonatomic)NSString *sellNumber;

@property (strong,nonatomic) NSString *latitude;
@property (strong,nonatomic) NSString *longitude;
///<<<<< HEAD
@property (strong,nonatomic)NSArray *experience;
//=======


//>>>>>>> d3c205da4586fdb26b6967810081ad49815a0bd6
- (instancetype)initWithDict: (NSDictionary *)dict;
@end

