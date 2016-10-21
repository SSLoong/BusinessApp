//
//  PerfectMenu.m
//  PerfectMenu
//
//  Created by prefect on 16/3/10.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "PerfectMenu.h"
#import "PerfectViewCell.h"

//#define ScreenWidth CGRectGetWidth([UIScreen mainScreen].applicationFrame)

@interface PerfectMenu()

@property(nonatomic,assign)BOOL show;
@property(nonatomic,assign)CGPoint origin;
@property(nonatomic,assign)CGFloat height;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic,assign)NSInteger curIndex;

@end

@implementation PerfectMenu

-(instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, 0)];
    if (self) {
        
        _origin = origin;
        _height = height;
        _show = NO;
        
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, ScreenWidth*0.25, 0) style:UITableViewStylePlain];
        _leftTableView.rowHeight = 44;
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _leftTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _leftTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        
        
        UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
        flowayout.headerReferenceSize = CGSizeMake(ScreenWidth*0.75, 30);
        _rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(origin.x+ScreenWidth*0.3, self.frame.origin.y + self.frame.size.height, ScreenWidth*0.75, 0) collectionViewLayout:flowayout];
        _rightCollectionView.dataSource=self;
        _rightCollectionView.delegate = self;
        _rightCollectionView.backgroundColor = [UIColor whiteColor];
        [_rightCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
        [_rightCollectionView registerClass:[PerfectViewCell class] forCellWithReuseIdentifier:@"perfectIdentifier"];

        
        self.backgroundColor = [UIColor whiteColor];
        
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
        
        //add bottom shadow
//        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, screenSize.width, 0.5)];
//        bottomShadow.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:bottomShadow];
    
    }
    return self;
}




//-(void)menuRelodata{
//
//
//    [self.leftTableView reloadData];
//
//
//}


#pragma mark - gesture handle

-(void)menuTapped{

    if (!_show) {
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.leftTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    [self animateBackGroundView:_backGroundView show:!_show complete:^{
        [self animateTableViewShow:!_show complete:^{
            [self tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            _show = !_show;
        }];
    }];

}

-(void)hideView{

    [self animateBackGroundView:_backGroundView show:NO complete:^{
        [self animateTableViewShow:NO complete:^{
            _show = NO;
        }];
    }];

}


- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    [self animateBackGroundView:_backGroundView show:NO complete:^{
        [self animateTableViewShow:NO complete:^{
            _show = NO;
        }];
    }];
}


- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {

    if (show) {
        
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        }];
 
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateTableViewShow:(BOOL)show complete:(void(^)())complete {
    if (show) {
        
        _rightCollectionView.frame = CGRectMake(self.origin.x+self.bounds.size.width*0.25, self.frame.origin.y, self.bounds.size.width*0.75, 0);
        [self.superview addSubview:_rightCollectionView];
        _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y, self.bounds.size.width*0.25, 0);
        [self.superview addSubview:_leftTableView];
        
        _leftTableView.alpha = 1.f;
        _rightCollectionView.alpha = 1.f;
        [UIView animateWithDuration:0.2 animations:^{
            _rightCollectionView.frame = CGRectMake(self.origin.x+self.bounds.size.width*0.25, self.frame.origin.y, self.bounds.size.width*0.75, _height);
            _leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y, self.bounds.size.width*0.25, _height);
            if (self.transformView) {
                self.transformView.transform = CGAffineTransformMakeRotation(M_PI);
            }
        } completion:^(BOOL finished) {
            
        }];
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
            _leftTableView.alpha = 0.f;
            _rightCollectionView.alpha = 0.f;
            if (self.transformView) {
                self.transformView.transform = CGAffineTransformMakeRotation(0);
            }
        } completion:^(BOOL finished) {
            [_leftTableView removeFromSuperview];
            [_rightCollectionView removeFromSuperview];
        }];
    }
    complete();
}



-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (self.rightCollectionView == scrollView) {
        
        
        NSArray *indexArr = [self.rightCollectionView indexPathsForVisibleItems];
        
        NSIndexPath *lastIndexPath = [indexArr lastObject];
        
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastIndexPath.section+1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }


}

//当单元格减速时调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (self.rightCollectionView == scrollView) {
        
        
        NSArray *indexArr = [self.rightCollectionView indexPathsForVisibleItems];
        
        NSIndexPath *lastIndexPath = [indexArr lastObject];
        
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastIndexPath.section+1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
}
}





#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if ([self.dataSource respondsToSelector:@selector(menu:tableView:numberOfRowsInSection:)]) {
        
        return [self.dataSource menu:self tableView:tableView numberOfRowsInSection:section];
        
    }else{
    
        return 0;
    }

}





#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:tableView:didSelectRowAtIndexPath:)]) {
        
        if (indexPath.row==0) {
            
            [self animateBackGroundView:_backGroundView show:NO complete:^{
                [self animateTableViewShow:NO complete:^{
                    _show = NO;
                }];
            }];
            
            
        }else{
            
            [self.rightCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row-1] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        
        }

        [self.delegate menu:self tableView:tableView didSelectRowAtIndexPath:indexPath];

    }
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([self.dataSource respondsToSelector:@selector(menu:tableView:titleForRowAtIndexPath:)]) {
        cell.textLabel.text = [self.dataSource menu:self tableView:tableView titleForRowAtIndexPath:indexPath];
    }

    UIView *sView = [[UIView alloc] init];
    sView.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = sView;
    [cell setSelected:YES animated:NO];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.separatorInset = UIEdgeInsetsZero;
    
    return cell;
}





#pragma mark - UICollectionViewDatesource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    if ([self.dataSource respondsToSelector:@selector(menu:numberOfSectionsInCollectionView:)]) {
        
        return [self.dataSource menu:self numberOfSectionsInCollectionView:collectionView];
    }else{
    
        return 0;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{


    if ([self.dataSource respondsToSelector:@selector(menu:collectionView:numberOfItemsInSection:)]) {
        
        return [self.dataSource menu:self collectionView:collectionView numberOfItemsInSection:section];
    }else{
    
        return 0;
    }

}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:collectionView:didSelectItemAtIndexPath:)]) {
        
        [self animateBackGroundView:_backGroundView show:NO complete:^{
            [self animateTableViewShow:NO complete:^{
                _show = NO;
            }];
        }];
        [self.delegate menu:self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }

}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    PerfectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"perfectIdentifier" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor redColor];

    
    if ([self.dataSource respondsToSelector:@selector(menu:collectionView:cellForItemAtIndexPath:)]) {
        
       [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:[self.dataSource menu:self collectionView:collectionView cellForItemAtIndexPath:indexPath]] placeholderImage:[UIImage imageNamed:@"store_header"]];

    }
    
    return cell;
}



- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    //创建头视图
    UICollectionReusableView *headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    
    //添加label
    UILabel *label = [[UILabel alloc]initWithFrame:headerCell.bounds];
    
    label.textColor = [UIColor grayColor];
    
    label.font = [UIFont systemFontOfSize:13.f];
    
    label.backgroundColor = [UIColor whiteColor];
    
    if ([self.dataSource respondsToSelector:@selector(menu:collectionView:titleForItemAtIndexPath:)]) {
    
        NSString *titleString = [NSString stringWithFormat:@"  %@",[self.dataSource menu:self collectionView:collectionView titleForItemAtIndexPath:indexPath]];
        
        label.text = titleString;
    
        }

    [headerCell addSubview:label];
    
    return headerCell;



}





-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (self.bounds.size.width*0.75-40)/3;
    
    return CGSizeMake(w,w);
    
}


@end
