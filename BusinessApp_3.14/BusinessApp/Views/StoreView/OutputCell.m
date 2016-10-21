//
//  OutputCell.m
//  BusinessApp
//
//  Created by wangyebin on 16/8/25.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OutputCell.h"

@interface OutputCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLab;//商品名称
@property (weak, nonatomic) IBOutlet UILabel *codeLab;//条形码
@property (weak, nonatomic) IBOutlet UITextField *priceTef;//价格
@property (weak, nonatomic) IBOutlet UIButton *subBtn;//数量减
@property (weak, nonatomic) IBOutlet UIButton *addBtn;//数量加
@property (weak, nonatomic) IBOutlet UILabel *countLab;//数量

@end


@implementation OutputCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    _priceTef.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    self.data.nPrice = [NSString stringWithFormat:@"%@",self.priceTef.text];
    return YES;
    
}

- (IBAction)addAction:(id)sender {
    
    NSInteger count = [self.countLab.text integerValue];
    count++;
    self.countLab.text = [NSString stringWithFormat:@"%ld",(long)count];
    _data.count = self.countLab.text;
    
    
}
- (IBAction)subAction:(id)sender {
    
    NSInteger count = [self.countLab.text integerValue];
    count--;
    
    if (count < 0) {
        count = 0;
    }
    self.countLab.text = [NSString stringWithFormat:@"%ld",(long)count];
    _data.count = self.countLab.text;

}

- (void)setTheDelegate:(id)delegate
{
    self.delegate = delegate;
}

- (void)setData:(OutputModel *)data
{
    WYBLog(@"%@",data);
    _data = data;
    //WYBLog(@"%@",_data.count);
    self.nameLab.text = _data.name;
    self.countLab.text = _data.count;
    self.codeLab.text = [NSString stringWithFormat:@"条形码  %@",_data.barcode];
    self.priceTef.placeholder = [NSString stringWithFormat:@"市场价为%@",_data.price];
    self.priceTef.text = [NSString stringWithFormat:@"%@",_data.nPrice];
}



@end
