//
//  ActivityViewCell.h
//  BusinessApp
//
//  Created by prefect on 16/3/30.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@interface ActivityViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *statuLabel;

-(void)configModel:(ActivityModel *)model;

@end
