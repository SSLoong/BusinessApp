//
//  PerfectViewCell.m
//  PerfectMenu
//
//  Created by prefect on 16/3/10.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "PerfectViewCell.h"

@implementation PerfectViewCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.logoImageView = [[UIImageView alloc]init];
        [self addSubview:self.logoImageView];
        
    }
    return self;
}


-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    [super applyLayoutAttributes:layoutAttributes];
    
    self.logoImageView.frame = CGRectMake(layoutAttributes.bounds.origin.x , layoutAttributes.bounds.origin.y, layoutAttributes.bounds.size.width , layoutAttributes.bounds.size.height);
    
}

@end
