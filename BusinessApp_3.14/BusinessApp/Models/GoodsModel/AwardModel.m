//
//  AwardModel.m
//  BusinessApp
//
//  Created by prefect on 16/7/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "AwardModel.h"

@implementation AwardModel

-(NSAttributedString *)attributedString{

    if (_attributedString == nil) {
        
        NSDictionary *dictAttr = @{NSBackgroundColorAttributeName:[UIColor cyanColor]};
        
        _attributedString = [[NSAttributedString alloc]initWithString:_award_title attributes:dictAttr];
    }

    return _attributedString;
}

@end
