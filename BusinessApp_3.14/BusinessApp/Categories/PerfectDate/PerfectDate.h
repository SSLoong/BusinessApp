//
//  PerfectDate.h
//  PerfectDateChoose
//
//  Created by prefect on 16/3/11.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^didSelectBtn)(NSString *startTime,NSString *endTime);

@interface PerfectDate : UIView

@property(nonatomic,copy)didSelectBtn didSelectBtn;

-(instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;

-(void)clickBtn;

-(void)hideView;

@end
