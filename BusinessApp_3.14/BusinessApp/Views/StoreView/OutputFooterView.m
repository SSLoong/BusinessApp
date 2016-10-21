//
//  OutputFooterView.m
//  BusinessApp
//
//  Created by wangyebin on 16/8/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OutputFooterView.h"

@interface OutputFooterView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@end


@implementation OutputFooterView
- (IBAction)chooseAction:(id)sender {
    
    self.buttonBlcok();
}
- (void)awakeFromNib
{
    [self.chooseBtn setCornerRadius:18];
    self.phoneTef.delegate = self;
    self.nameTef.delegate = self;
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   
    self.changeBlock(self.nameTef.text,self.phoneTef.text);
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
