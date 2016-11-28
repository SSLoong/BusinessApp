//
//  GoodsAddViewController.m
//  
//
//  Created by 孙升隆 on 2016/11/28.
//
//

#import "GoodsAddViewController.h"

@interface GoodsAddViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;

@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;

@property (weak, nonatomic) IBOutlet UILabel *pushLabel;

@end

@implementation GoodsAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加活动";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
   

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
