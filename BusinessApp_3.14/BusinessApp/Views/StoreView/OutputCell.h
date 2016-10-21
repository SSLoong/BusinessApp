//
//  OutputCell.h
//  BusinessApp
//
//  Created by wangyebin on 16/8/25.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "OutputModel.h"
@protocol outputCellProtocol <NSObject>

- (void)sayHi;

@end


@interface OutputCell : BaseTableViewCell

@property (strong, nonatomic) OutputModel * data;
@property (weak, nonatomic) id<outputCellProtocol> delegate;
@end
