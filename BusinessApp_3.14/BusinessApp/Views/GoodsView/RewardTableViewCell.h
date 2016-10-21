//
//  RewardTableViewCell.h
//  BusinessApp
//
//  Created by prefect on 16/7/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *completedLabel;

@property(nonatomic,strong)UILabel *rewardLabel;

@property(nonatomic,strong)UILabel *stateLabel;


@property (nonatomic, strong) UIImageView *rewardImg;

@property (nonatomic, strong) UIImageView *taskImg;

@property (nonatomic, strong) UIImageView *nonceImg;


@property (nonatomic, strong) UIView *grayLine;
@property (nonatomic, strong) UIView *grayLineOne;
@property (nonatomic, strong) UIView *grayLineTwo;



@end
