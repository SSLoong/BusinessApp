//
//  OpenTicketViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/3/23.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OpenTicketViewCell.h"

@implementation OpenTicketViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    
    return self;
}

-(void)configModel:(LogisticsModel *)model{

    _nameLabel.text = model.name;

}


-(void)initSubviews{
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font= [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:_nameLabel];

    
    _chooseImage = [UIImageView new];
    [self.contentView addSubview:_chooseImage];
}


-(void)setLayout{
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(16);
        
    }];
    
    

    
    
    [_chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(14, 14));
        
        make.right.mas_equalTo(-15);
        
        make.top.mas_equalTo(15);
        
    }];
    
}


-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        _chooseImage.image = [UIImage imageNamed:@"goods_selelet"];
    }else{
        _chooseImage.image = [UIImage imageNamed:@"goods_unselelet"];
    }
}


@end
