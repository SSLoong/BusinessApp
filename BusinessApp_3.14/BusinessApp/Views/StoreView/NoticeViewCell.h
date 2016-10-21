//
//  NoticeViewCell.h
//  BusinessApp
//
//  Created by perfect on 16/4/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>
#import "NoticeModel.h"
@interface NoticeViewCell : MGSwipeTableCell

@property(nonatomic,strong)UIImageView * logoImage;

@property(nonatomic,strong)UIImageView * smallImage;

@property(nonatomic,strong)UILabel * messLabel;

@property(nonatomic,strong)UILabel * timeLabel;

@property(nonatomic,strong)UILabel * orderLabel;

-(void)configModel:(NoticeModel*)model;
@end
