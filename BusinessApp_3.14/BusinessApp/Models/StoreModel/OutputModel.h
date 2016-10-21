//
//  OutputModel.h
//  BusinessApp
//
//  Created by wangyebin on 16/8/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//  扫码出库

#import <Foundation/Foundation.h>

@interface OutputModel : NSObject

/**
 sgid	string	门店商品id
 goods_id	string	商品id
 dealer_id	string	经销商id
 name	string	商品名称
 price	string	默认售价
 barcode	string	条形码
 */

//@property (strong, nonatomic) NSDictionary * dataDic;//数据
@property (copy, nonatomic) NSString * sgid;
@property (copy, nonatomic) NSString * goods_id;
@property (copy, nonatomic) NSString * dealer_id;
@property (copy, nonatomic) NSString * nPrice;//当前价格
@property (copy, nonatomic) NSString * name;
@property (copy, nonatomic) NSString * price;
@property (copy, nonatomic) NSString * barcode;
@property (copy, nonatomic) NSString * count;//数量



@end
