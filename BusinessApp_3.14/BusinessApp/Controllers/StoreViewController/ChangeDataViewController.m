//
//  ChangeDataViewController.m
//  MyTvGame
//
//  Created by perfect on 15/8/7.
//  Copyright (c) 2015年 prefect. All rights reserved.
//

#import "ChangeDataViewController.h"
#import "ChangeDataTableViewCell.h"




@interface ChangeDataViewController ()

{
    NSString *nValue;
    
    NSString *_name;
    NSString *_phone;
    NSString *_contact;
    NSString *_address;
    
    MBProgressHUD *_HUD;
}

@end

@implementation ChangeDataViewController


-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [_HUD hide:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0];
    self.title = self.titleString;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.tableFooterView = footer;
    
    UIBarButtonItem *changeItem =  [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(changeAction:)];
        
    self.navigationItem.rightBarButtonItem = changeItem;

    
}

-(void)changeAction:(id)sender{

    _HUD = [AppUtil createHUD];
    _HUD.labelText = @"正在修改...";
    _HUD.userInteractionEnabled = YES;
    
        NSIndexPath *pathOne=[NSIndexPath indexPathForRow:0 inSection:0];//获取cell的位置
        ChangeDataTableViewCell *cell = (ChangeDataTableViewCell *)[self.tableView cellForRowAtIndexPath:pathOne];
        nValue = cell.dataTextField.text;

    
        if ([self.value isEqualToString:nValue]) {
            
            _HUD.mode = MBProgressHUDModeText;
            _HUD.labelText = @"未改变要更改的内容";
            [_HUD hide:YES afterDelay:2];
            return;
            
        }
        if ([nValue isEqualToString:@""]) {
            
            _HUD.mode = MBProgressHUDModeText;
            _HUD.labelText = @"要更改的内容不能为空!";
            [_HUD hide:YES afterDelay:2];
            return;
            
        }

    
    if ([self.title isEqualToString:@"店铺名称"]) {
        
        _name = nValue;
        _phone = @"";
        _contact = @"";
        _address = @"";

    }else if([self.title isEqualToString:@"联系电话"]){
    
        _name = @"";
        _phone = nValue;
        _contact = @"";
        _address = @"";
    
    
    }else if([self.title isEqualToString:@"详细地址"]){
        
        _name = @"";
        _phone = @"";
        _contact = @"";
        _address = nValue;
        
        
    }else if([self.title isEqualToString:@"负责人"]){
        
        _name = @"";
        _phone = @"";
        _contact = nValue;
        _address = @"";
        
        
    }
    

    
    
    [AFHttpTool changeStoreInfo:Store_id name:_name phone:_phone contact:_contact site_code:@"" province:@"" city:@"" area:@"" address:_address type:@""progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _HUD.mode = MBProgressHUDModeCustomView;
            _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _HUD.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_HUD hide:YES afterDelay:3];
            
            return;
        }
        

        if (self.newValue) {
            self.newValue(nValue);
        }
        
        [_HUD hide:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *err) {
        
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _HUD.labelText = @"Error";
        _HUD.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_HUD hide:YES afterDelay:3];
        
    }];
    
    
    
  
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    
        static NSString *cellId = @"changeDataCellId";
        
        ChangeDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChangeDataTableViewCell" owner:self options:nil] lastObject];

            cell.dataTextField.text = self.value;
            
            if ([self.title isEqualToString:@"联系电话"]) {
                cell.dataTextField.keyboardType = UIKeyboardTypePhonePad;
            }
            
            [cell.dataTextField becomeFirstResponder];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
