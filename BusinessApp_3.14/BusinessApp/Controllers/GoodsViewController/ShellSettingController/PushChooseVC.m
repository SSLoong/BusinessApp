//
//  PushChooseVC.m
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "PushChooseVC.h"
#import "PushChooseCell.h"
#import "PushChooseModel.h"

@interface PushChooseVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,assign)NSInteger page;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic,  strong) UIButton *allChooseBtn;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, strong) NSMutableArray *selectedDataArray;

@property (nonatomic, strong) NSMutableArray *allSelectedArray;


@end

@implementation PushChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _modelArray = [NSMutableArray array];

    _page = 1;
    // Do any additional setup after loading the view.
    [self createUI];
    [self createTabelView];
    [self setUILayout];
    [self loadData];
    
}

- (void)createUI{
    
    _allChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allChooseBtn = [UIButton new];
    [_allChooseBtn setTitle:@"全部用户" forState:UIControlStateNormal];
    [_allChooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_allChooseBtn setBackgroundColor:[UIColor orangeColor]];
    _allChooseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _allChooseBtn.layer.masksToBounds = YES;
    _allChooseBtn.layer.cornerRadius = 15.0;
    [_allChooseBtn addTarget:self action:@selector(allChooseBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_allChooseBtn];

    _selectBtn = [UIButton new];
    [_selectBtn setTitle:@"确定选择" forState:UIControlStateNormal];
    [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectBtn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _selectBtn.layer.masksToBounds = YES;
    _selectBtn.layer.cornerRadius = 15.0;
    [_selectBtn addTarget:self action:@selector(selectBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectBtn];

}

- (void)allChooseBtnEvent:(UIButton *)btn{

    if (self.allChooseBtnBlock) {
        self.allChooseBtnBlock(_allSelectedArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectBtnEvent:(UIButton *)btn{
    if (self.chooseBtnBlock) {
        self.chooseBtnBlock(_selectedDataArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setUILayout{
    
        __weak typeof(self) weakSelf = self;

    [_allChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(weakSelf.view.mas_centerX).offset(-15);
        make.top.equalTo(weakSelf.lineView.mas_bottom).offset(7);
        make.height.equalTo(@30);
    }];

    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.left.equalTo(weakSelf.view.mas_centerX).offset(15);
        make.top.equalTo(weakSelf.lineView.mas_bottom).offset(7);
        make.height.equalTo(@30);
    }];
}

- (void)createTabelView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 108) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self.tableView registerNib: [UINib nibWithNibName:@"PushChooseCell" bundle:nil]forCellReuseIdentifier:@"PushChooseCellID"];

    _tableView.mj_footer = ({
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.refreshingTitleHidden = YES;
        footer.hidden = YES;
        footer;
    });
    

    
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 43, ScreenWidth, 0.5)];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    _lineView.layer.shadowColor = [UIColor grayColor].CGColor;
    _lineView.layer.shadowOpacity = 0.8f;
    _lineView.layer.shadowOffset = CGSizeMake(4, 4);
    [self.view addSubview:_lineView];

    
}


-(void)loadMoreData{
    

    _page++;
    
    [self loadData];
}


- (void)loadData{

    [AFHttpTool GoodsPushChoose:Store_id store_goods_id:_store_goods_id activity_id:@"" page:_page progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }

        
        if(_page ==1 && self.modelArray.count>0){
            
            [self.modelArray removeAllObjects];
        }
        
        if (_tableView.mj_footer.hidden) {
            _tableView.mj_footer.hidden = NO;
        }
        
        for (NSDictionary * dic in response[@"data"][@"list"]) {
            PushChooseModel *model = [[PushChooseModel alloc]init];
            [model mj_setKeyValues:dic];
            [self.modelArray addObject:model];
            [self.allSelectedArray addObject:model.id];
        }
        
        if(_page == [response[@"data"][@"totalPage"] integerValue] || [response[@"data"][@"totalPage"] integerValue] == 0){
            
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [_tableView.mj_footer endRefreshing];
            
        }

        
        [self.tableView reloadData];



    } failure:^(NSError *err) {
        
    }];



}


#pragma mark -
#pragma mark -- tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"PushChooseCellID";

    PushChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PushChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.model = _modelArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PushChooseModel *model = _modelArray[indexPath.row];
    //改变当前数据模型的BOOL值属性（是否选中：取反）
    model.isSelected = !model.isSelected;
    //刷新tableView
    [self.tableView reloadData];
    
    [self.selectedDataArray removeAllObjects];
    
    [_modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PushChooseModel *model = obj;
        if (model.isSelected == YES) {
            [_selectedDataArray addObject:model.id];
        }
    }];

    
    
    
//    NSUInteger row = [indexPath row];
//    NSMutableDictionary *dic = [contacts objectAtIndex:row];
//    if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
//        [dic setObject:@"YES" forKey:@"checked"];
//        [cell setChecked:YES];
//    }else {
//        [dic setObject:@"NO" forKey:@"checked"];
//        [cell setChecked:NO];
//    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 选中的模型数组
 */
- (NSMutableArray *)selectedDataArray {
    
    if (_selectedDataArray == nil) {
        
        _selectedDataArray = [NSMutableArray array];
    }
    return _selectedDataArray;
}

- (NSMutableArray *)allSelectedArray{

    if (_allSelectedArray == nil) {
        _allSelectedArray = [NSMutableArray array];

    }
    return _allSelectedArray;
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
