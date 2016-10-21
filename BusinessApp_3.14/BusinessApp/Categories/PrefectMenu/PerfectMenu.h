//
//  PerfectMenu.h
//  PerfectMenu
//
//  Created by prefect on 16/3/10.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PerfectMenu;

@protocol  PerfectMenuDataSource<NSObject>
//@required

-(NSInteger)menu:(PerfectMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;

- (NSString *)menu:(PerfectMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath;




-(NSInteger)menu:(PerfectMenu *)menu collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

-(NSInteger)menu:(PerfectMenu *)menu numberOfSectionsInCollectionView:(UICollectionView *)collectionView;

-(NSString *)menu:(PerfectMenu *)menu collectionView:(UICollectionView *)collectionView titleForItemAtIndexPath:(NSIndexPath *)indexPath;

-(NSString *)menu:(PerfectMenu *)menu collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol PerfectMenuDelegate <NSObject>
//@required

- (void)menu:(PerfectMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)menu:(PerfectMenu *)menu collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface PerfectMenu : UIView<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UITableView *leftTableView;

@property(nonatomic,strong)UICollectionView *rightCollectionView;

@property(nonatomic,strong)UIView *transformView;

@property(nonatomic,weak) id<PerfectMenuDataSource>dataSource;

@property(nonatomic,weak) id<PerfectMenuDelegate>delegate;

-(instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;

-(void)menuTapped;

//-(void)menuRelodata;

-(void)hideView;


@end
