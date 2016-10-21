//
//  OutputModel.m
//  BusinessApp
//
//  Created by wangyebin on 16/8/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OutputModel.h"

@interface OutputModel ()

@end


@implementation OutputModel


- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"price"]) {
        self.nPrice = value;
        self.count = @"1";
        self.price = value;
        
    }else{
        [super setValue:value forKey:key];
    }
}

@end
