//
//  EditorNameVC.m
//  BusinessApp
//
//  Created by wangyebin on 16/9/5.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "EditorNameVC.h"

@interface EditorNameVC ()

@property (weak, nonatomic) IBOutlet UITextField *nameTef;//姓名输入框

@end

@implementation EditorNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

//初始化UI
- (void)initUI
{
    self.navigationItem.title = @"添加备注";
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
}

//提交
- (void)complete
{
    
    if (checkStrNull(self.nameTef.text)) {
        [self completeConnetion];
    }else{
        [self.view showLoadingWithMessage:@"请填写姓名" hideAfter:2.0];
    }
    
}

- (void)completeConnetion
{
    [self.view endEditing:YES];
    self.view.userInteractionEnabled = NO;
    [self.view showLoading];
    [AFHttpTool edtiorname:self.customerID name:self.nameTef.text  progress:^(NSProgress * progress){
        
    } success:^(id response) {
        WYBLog(@"%@",response);
        [self endRefresh];
        if ([response[@"code"] isEqualToString:@"0000"]) {
            [self.view showLoadingWithMessage:response[@"msg"] hideAfter:2.0];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [self.view showLoadingWithMessage:response[@"msg"] hideAfter:2.0];

        }
        
    } failure:^(NSError * error) {
        [self endRefresh];
        //        WYBLog(@"%@",error.description);
    }];

    
    
    
}


//结束刷新
- (void)endRefresh
{
    self.view.userInteractionEnabled = YES;
    [self.view hideLoading];
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
