//
//  HistoryViewCell.h
//  BusinessApp
//
//  Created by prefect on 16/3/31.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryModel.h"

@interface HistoryViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *statuLabel;

-(void)configModel:(HistoryModel *)model;

@end
