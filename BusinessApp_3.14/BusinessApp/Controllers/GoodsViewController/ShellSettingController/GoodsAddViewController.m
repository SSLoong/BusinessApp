//
//  GoodsAddViewController.m
//  
//
//  Created by 孙升隆 on 2016/11/28.
//
//

#import "GoodsAddViewController.h"
#import "PushChooseVC.h"

#import "ActionSheetDatePicker.h"
#import "NSDate+Helper.h"
#import "NSDate+Common.h"

@interface GoodsAddViewController ()

@property(nonatomic,strong)MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;

@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;

@property (weak, nonatomic) IBOutlet UILabel *pushLabel;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, strong) NSArray *scustidArray;

@end

@implementation GoodsAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加活动";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
   
    _start_time = [AppUtil getStartTime];
    _end_time = [AppUtil getEndTime];
    
    self.titleTextField.text = self.activityName;
    self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 10;
    // Do any additional setup after loading the view from its nib.
}
//开始时间
- (IBAction)startTimeEvent:(id)sender {
    NSDate *curDate = [NSDate dateFromString:_end_time withFormat:@"yyyy-MM-dd"];
    if (!curDate) {
        curDate = [NSDate date];
    }
    
    __weak typeof(self) weakSelf = self;
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:curDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        
        weakSelf.start_time = [(NSDate *)selectedDate string_yyyy_MM_dd];
        [self.startTimeBtn setTitle:weakSelf.start_time forState:UIControlStateNormal];
        
    } cancelBlock:nil origin:self.view];
    
    [picker addCustomButtonWithTitle:@"今天" value:[NSDate date]];
    [picker setHideCancel:YES];
    picker.tapDismissAction = TapActionCancel;
    [picker setMinimumDate:[NSDate date]];
    [picker showActionSheetPicker];

    
}

//结束时间
- (IBAction)endTimeEvent:(id)sender {

    NSDate *curDate = [NSDate dateFromString:_start_time withFormat:@"yyyy-MM-dd"];
    if (!curDate) {
        curDate = [NSDate date];
    }
    
    __weak typeof(self) weakSelf = self;
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:curDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        
        weakSelf.end_time = [(NSDate *)selectedDate string_yyyy_MM_dd];
        [self.endTimeBtn setTitle:weakSelf.end_time forState:UIControlStateNormal];
        
    } cancelBlock:nil origin:self.view];
    
    [picker addCustomButtonWithTitle:@"今天" value:[NSDate date]];
    [picker setHideCancel:YES];
    picker.tapDismissAction = TapActionCancel;
    [picker setMinimumDate:[NSDate dateFromString:_start_time withFormat:@"yyyy-MM-dd"]];
    [picker showActionSheetPicker];
}

//推送好友手势触发事件
- (IBAction)pushTapEvent:(id)sender {

    __weak typeof(self)weakSelf = self;

    PushChooseVC *vc = [[PushChooseVC alloc]init];
    vc.store_goods_id = self.store_goods_id;
    vc.chooseBtnBlock =^(NSArray *scustidArr){
        weakSelf.scustidArray = scustidArr;
        NSString *numStr = [NSString stringWithFormat:@"已选择%lu人",(unsigned long)scustidArr.count];
        self.pushLabel.text = numStr;
    };
    
    vc.allChooseBtnBlock = ^(NSArray *scustidArr){
        weakSelf.scustidArray = scustidArr;
        NSString *numStr = [NSString stringWithFormat:@"已推送%lu人",(unsigned long)scustidArr.count];
        self.pushLabel.text = numStr;
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

//确定按钮触发事件
- (IBAction)sureBtnEvent:(id)sender {

    
    if (![self checkTextField]) {
        return;
    }
    
    _hud = [AppUtil createHUD];
    _hud.labelText = @"正在添加...";
    _hud.userInteractionEnabled = NO;
    
    [AFHttpTool GoodsAddActivity:Store_id store_goods_id:_store_goods_id title:_titleTextField.text start_time:_start_time end_time:_end_time subamount:_moneyTextField.text scustid:_scustidArray progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        _hud.labelText = @"添加成功";
        [_hud hide:YES];

        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *err) {
        _hud.labelText = @"添加失败";
        [_hud hide:YES afterDelay:1];

        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];

        
        
    }];
    
    
    
}

- (BOOL)checkTextField{

    
    if (_titleTextField.text.length==0) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        
        _hud.labelText = @"请输入活动标题";
        
        [_hud hide:YES afterDelay:2];
        
        return NO;
    }
    if (_moneyTextField.text.length<=0) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        
        _hud.labelText = @"请输入正确的价格";
        
        [_hud hide:YES afterDelay:3];
        
        return NO;
    }
    
    return YES;
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.titleTextField resignFirstResponder];
    [self.moneyTextField resignFirstResponder];
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
