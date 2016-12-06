//
//  AFHttpTool.h
//  
//
//  Created by prefect on 16/3/4.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestMethodType){
    RequestMethodTypePost = 1,
    RequestMethodTypeGet = 2

};



@interface AFHttpTool : NSObject



//生成32位不同数字字符串
+(NSString *)getSuiJINum;


+(void) requestWihtMethod:(RequestMethodType)methodType
                     url : (NSString *)url
                   params:(NSDictionary *)params
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;



//上传图片
+(void) uploadPictureWithURL:(NSString *)url
                   nameArray:(NSArray *)names
                 imagesArray:(NSArray *)images
                      params:(NSDictionary *)params
                    progress:(void (^)(NSProgress *progress))progress
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure;


//商户入驻验证码
+(void) getCodePhone:(NSString *)login_phone
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure;


//商户入驻
+(void) registerStore:(NSString *)login_phone
            login_pwd:(NSString *)login_pwd
             sms_code:(NSString *)sms_code
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;




//修改密码和找回密码的验证码
+(void)findpwdCode:(NSString *)login_phone
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure;

//登录
+(void) LoginWithPhone:(NSString *)phone
                   pwd:(NSString *)pwd
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;


//重置登录密码
+(void) resetPassWord:(NSString *)login_phone
            login_pwd:(NSString *)login_pwd
             sms_code:(NSString *)sms_code
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;



//获取省
+(void) getProvinceList:(NSString *)query
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;



//获取城市
+(void) getCityList:(NSString *)province_id
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;

//获取县区
+(void) getCountyList:(NSString *)city_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;

//获取经销商
+(void)getStoreList:(NSString *)site_code
           progress:(void (^)(NSProgress *))progress
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure;

//门店信息补全
+(void)storeComplete:(NSString *)store_id
                name:(NSString *)name
        company_name:(NSString *)company_name
             contact:(NSString *)contact
               phone:(NSString *)phone
            province:(NSString *)province
                city:(NSString *)city
                area:(NSString *)area
             address:(NSString *)address
                type:(NSString *)type
           site_code:(NSString *)site_code
           dealer_id:(NSString *)dealer_id
            progress:(void (^)(NSProgress *))progress
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure;



#pragma mark - 订单api

//订单列表查询
+(void) getOrder:(NSString *)store_id
      start_time:(NSString *)start_time
        end_time:(NSString *)end_time
            type:(NSInteger)type
           phone:(NSString *)phone
            page:(NSInteger)page
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;


//订单详情
+(void) orderDetail:(NSString *)store_id
           order_id:(NSString *)order_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;



//查询可配送物流公司
+(void)logisticsCompany:(NSString *)store_id
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;

//选择订单配送公司
+(void) orderLogistics:(NSString *)order_id
ordexpress_company_ider_id:(NSString *)express_company_id
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;


//修改订单金额
+(void) orderUpdatePrice:(NSString *)store_id
                order_id:(NSString *)order_id
             login_phone:(NSString *)login_phone
                   money:(NSString *)money
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;



//订单确认验证码
+(void) orderConfirmorder:(NSString *)order_id
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;

//手动确认订单
+(void) orderCodeConfirm:(NSString *)order_id
                sms_code:(NSString *)sms_code
                 cust_id:(NSString *)cust_id
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;

//扫码确认订单
+(void) orderConfirmnew:(NSArray *)order_id
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;


//订单物流查询
+(void) orderExpress:(NSString *)order_id
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure;



#pragma mark - 门店api

//获取门店信息
+(void) getStoreInfo:(NSString *)store_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;


//分享店铺
+(void)appShare:(NSString *)store_id
       progress:(void (^)(NSProgress *progress))progress
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure;

//管理粉丝
+ (void)manageTheFan:(NSString *)store_id
                page:(NSString *)page
                name:(NSString *)name
            progress:(void (^)(NSProgress *))progress
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure;
//粉丝详情
+ (void)fansDetails:(NSString *)store_id
               page:(NSString *)page
            cust_id:(NSString *)cust_id
           progress:(void (^)(NSProgress *))progress
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure;

//新粉丝详情
+ (void)fansInfo:(NSString *)store_id
         fans_id:(NSString *)fans_id
            progress:(void (^)(NSProgress *))progress
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure;


//备注姓名
+ (void)edtiorname:(NSString *)customeid
              name:(NSString *)name
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure;
//扫码出库
+ (void)output:(NSString *)store_id
     codeArray:(NSString *)codeArray
      progress:(void (^)(NSProgress *))progress
       success:(void (^)(id))success
       failure:(void (^)(NSError *))failure;
//确认出库
+(void)sureout:(NSString *)store_id
     goodArray:(NSString *)codeArray
         phone:(NSString *)phone
          name:(NSString *)name
      progress:(void (^)(NSProgress *))progress
       success:(void (^)(id))success
       failure:(void (^)(NSError *))failure;

//选择老客户
+ (void)storeCustomer:(NSString *)store_id
                 name:(NSString *)name
                 page:(NSString *)page
                 rows:(NSString *)rows
             progress:(void (^)(NSProgress *))progress
              success:(void (^)(id))success
              failure:(void (^)(NSError *))failure;

//问题反馈
 +(void)feedback:(NSString *)login_phone
feedback_content:(NSString *)feedback_content
    contact_mode:(NSString *)contact_mode
        store_id:(NSString *)store_id
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;



//修改门店信息
+(void)changeStoreInfo:(NSString *)store_id
                  name:(NSString *)name
                 phone:(NSString *)phone
               contact:(NSString *)contact
             site_code:(NSString *)site_code
              province:(NSString *)province
                  city:(NSString *)city
                  area:(NSString *)area
               address:(NSString *)address
                  type:(NSString *)type
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;

//修改门店配送状态
+(void) chanegStoreDeliver:(NSString *)store_id
                  progress:(void (^)(NSProgress *progress))progress
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError *err))failure;


//修改营业状态
+(void) chanegStoreStatus:(NSString *)store_id
                   status:(NSString *)status
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;

//修改门店发票服务
+(void) changeReceipt:(NSString *)store_id
              receipt:(NSInteger)receipt
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;




//获取门店认证信息
+(void) getStoreAuthInfo:(NSString *)store_id
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;


//注册门店认证信息
+(void) registerComplete:(NSString *)store_id
             id_img_pros:(NSString *)id_img_pros
             id_img_cons:(NSString *)id_img_cons
    business_license_img:(NSString *)business_license_img
     hygiene_license_img:(NSString *)hygiene_license_img
               store_img:(NSString *)store_img
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;



//修改门店配置送范围
+(void) updateDeliverranges:(NSString *)store_id
              deliver_range:(NSString *)deliver_range
                   progress:(void (^)(NSProgress *progress))progress
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;




//消息列表
+(void)StoreMsgList:(NSString *)store_id
               page:(NSInteger)page
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;

//删除消息
+(void)StoreDeleteMsg:(NSString *)msg_id
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;

//读取消息
+(void)StoreReadMsg:(NSString *)msg_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;






//操作员列表
+(void)StoreOperatorList:(NSString *)store_id
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;


//添加门店操作员
+(void)StoreAddoperator:(NSString *)login_phone
               store_id:(NSString *)store_id
              login_pwd:(NSString *)login_pwd
               sms_code:(NSString *)sms_code
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;
//锁定操作员
+(void)StoreLockoperator:(NSString *)store_id
             login_phone:(NSString *)login_phone
                   phone:(NSString *)phone
                  status:(NSString *)status
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;

//删除操作员
+(void)StoreOperatorDel:(NSString *)store_id
            login_phone:(NSString *)login_phone
                  phone:(NSString *)phone
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;

//添加操作员发送验证码
+(void)SmsauthAddOperator:(NSString *)login_phone
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;


//生成订单左边品牌
+(void)StoreSaleBrand:(NSString *)store_id
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;


//生成订单查询在售商品
+(void)StoreSaleGoods:(NSString *)store_id
             brand_id:(NSString *)brand_id
                 page:(NSInteger)page
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;



//生成订单提交订单内容
+(void)StoreCreateOrder:(NSString *)store_id
                   data:(NSDictionary *)data
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;


//购物车订单详情
+(void)OrderCart:(NSString *)key
        store_id:(NSString *)store_id
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;

//生成订单活动商品详情
+(void)SpecialGoods:(NSString *)store_id
           goods_id:(NSString *)goods_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;


//添加到购物车
+(void)AddGoodsCart:(NSString *)key
           store_id:(NSString *)store_id
         special_id:(NSString *)special_id
              sg_id:(NSString *)sg_id
            buy_num:(NSString *)buy_num
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;

//生成订单改价
+(void)CartBargain:(NSString *)key
           store_id:(NSString *)store_id
         special_id:(NSString *)special_id
              sg_id:(NSString *)sg_id
            price:(NSString *)price
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;



//查询购物车
+(void)cartDetail:(NSString *)key
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;



//扫描订单支付成功
+(void)orderResult:(NSString *)key
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure;




#pragma mark - 收入API

//收入汇总
+(void)incomeDetail:(NSString *)store_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;



//收入明细
+(void)incomeDetailData:(NSString *)store_id
             start_time:(NSString *)start_time
               end_time:(NSString *)end_time
                   page:(NSInteger)page
                   type:(NSInteger )type
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;

//提现明细
+(void)withdrawalsDetail:(NSString *)store_id
                    type:(NSString *)type
              start_time:(NSString *)start_time
                  amount:(NSString *)end_time
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;



//提现明细列表
+(void)IncomeWithDrawalsDetailed:(NSString *)store_id
                            type:(NSString *)type
                      start_time:(NSString *)start_time
                        end_time:(NSString *)end_time
                            page:(NSInteger)page
                        progress:(void (^)(NSProgress *progress))progress
                         success:(void (^)(id response))success
                         failure:(void (^)(NSError *err))failure;

//红包代金券明细列表
+(void)IncomeRewardDetailed:(NSString *)store_id
                       type:(NSString *)type
                       page:(NSInteger)page
                   progress:(void (^)(NSProgress *progress))progress
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;

//查询默认银行卡
+(void)getDefaultBank:(NSString *)store_id
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;

//提现申请
+(void)withdrawalsApply:(NSString *)store_id
            login_phone:(NSString *)login_phone
                   type:(NSString *)type
                  mount:(NSString *)amount
                bank_id:(NSString *)bank_id
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;


//银行卡列表
+(void)incomeBankList:(NSString *)store_id
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;

//删除银行卡
+(void)incomeDeleteBank:(NSString *)store_id
                bank_id:(NSString *)bank_id
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;

//设置默认银行卡
+(void)incomeSetDefaultBank:(NSString *)store_id
                    bank_id:(NSString *)bank_id
                   progress:(void (^)(NSProgress *progress))progress
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;


//查询支持的银行
+(void)incomeBindBankList:(NSString *)query
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;

//添加银行卡
+(void)incomeAddBank:(NSString *)store_id
           bank_code:(NSString *)bank_code
                name:(NSString *)name
         open_branch:(NSString *)open_branch
          bank_phone:(NSString *)bank_phone
           bank_card:(NSString *)bank_card
   open_bank_address:(NSString *)address
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure;



//收入商品统计

+(void)incomeGoods:(NSString *)store_id
            brand_id:(NSString *)brand_id
          start_time:(NSString *)start_time
            end_time:(NSString *)end_time
                page:(NSInteger)page
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure;






//收入商品明细列表
+(void)incomeGoodsDetailed:(NSString *)goods_id
                  store_id:(NSString *)store_id
                      page:(NSInteger )page
                  progress:(void (^)(NSProgress *progress))progress
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError *err))failure;


//商品收入汇总
+(void) GoodsIncome:(NSString *)store_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;



//所有商品类别列表-品牌
+(void)getAllGoods:(NSString *)query
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure;


//提现明细列表
+(void)withdrawDeposit:(NSString *)store_id
                  type:(NSString *)type
            start_time:(NSString *)start_time
              end_time:(NSString *)end_time
                  page:(NSInteger)page
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;






#pragma mark - 商品APi


//店铺库存
+(void)GoodsStock:(NSString *)store_id
         brand_id:(NSString *)brand_id
               page:(NSInteger)page
                type:(NSInteger)type
                 sort:(NSInteger)sort
        stocktype:(NSInteger)stocktype
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;



//扫码添加商品
+(void)GoodsScan:(NSString *)store_id
         barcode:(NSString *)barcode
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;



//非连锁店商品品牌
+(void)GoodsCategory:(NSString *)store_id
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure;

//商品搜索--非连锁
+(void)GoodsSearch:(NSString *)store_id
          keywords:(NSString *)keywords
          brand_id:(NSString *)brand_id
             page:(NSInteger)page
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;

//商品图片和信息
+(void)GoodsInfo:(NSString *)store_id
        goods_id:(NSString *)goods_id
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;



//非连锁添加上库存
+(void)GoodsAdd:(NSString *)store_id
       goods_id:(NSString *)goods_id
       mk_price:(NSString *)mk_price
          price:(NSString *)price
       progress:(void (^)(NSProgress *progress))progress
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure;

//添加平台没有此商品的库存
+(void)GoodsAdd:(NSString *)store_id
      good_name:(NSString *)goods_name
        barcode:(NSString *)barcode
      goods_img:(NSString *)goods_img
       goods_id:(NSString *)goods_id
          price:(NSString *)price
     real_price:(NSString *)real_price
 purchase_price:(NSString *)purchase_price
          stock:(NSString *)stock
       progress:(void (^)(NSProgress *progress))progress
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure;

//商品营销设置列表
+(void)GoodsStand:(NSString *)store_id
         brand_id:(NSString *)brand_id
             type:(NSString *)type
             sort:(NSString *)sort
             page:(NSInteger)page
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;

//商品营销活动列表
+(void)GoodsActivityst:(NSString *)store_id
            store_goods_id:(NSString *)store_goods_id
                  page:(NSInteger)page
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure;

//添加活动
+(void)GoodsAddActivity:(NSString *)store_id
         store_goods_id:(NSString *)store_goods_id
                  title:(NSString *)title
             start_time:(NSString *)start_time
               end_time:(NSString *)end_time
              subamount:(NSString *)subamount
                scustid:(NSArray *)scustid
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;

//查询推送用户
+(void)GoodsPushChoose:(NSString *)store_id
        store_goods_id:(NSString *)store_goods_id
           activity_id:(NSString *)activity_id
                  page:(NSInteger)page
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;

//添加活动


//营销设置
+(void)GoodsSetSubamount:(NSString *)store_goods_id
               subamount:(NSString *)subamount
                store_id:(NSString *)store_id
               recommend:(NSString *)recommend
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;


//查询所有商品（连锁）

+(void)goodsSell:(NSString *)store_id
        brand_id:(NSString *)brand_id
            page:(NSInteger)page
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;



//商品开售停售（连锁）

+(void)goodsSaleSwitch:(NSString *)store_id
       dealer_goods_id:(NSString *)dealer_goods_id
                status:(NSInteger)status
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;




//专场列表

+(void)goodsSaleSpecial:(NSString *)store_id
                   page:(NSInteger)page
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;

//销售奖励
+(void)goodsSaleStatistics:(NSString *)store_id
                   page:(NSInteger)page
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;



//历史特卖
+(void)goodsSaleSpecial:(NSString *)store_id
             start_time:(NSString *)start_time
               end_time:(NSString *)end_time
                   page:(NSInteger)page
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;


//专场详情
+(void)goodsSpecialDetail:(NSString *)store_id
               special_id:(NSString *)special_id
                     page:(NSInteger)page
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;

//专场商品申请入库
+(void)goodsSpecialAdd:(NSString *)store_id
            special_id:(NSString *)special_id
             dealer_id:(NSString *)dealer_id
              goods_id:(NSString *)goods_id
                  nums:(NSString *)nums
                 price:(NSString *)price
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;


//分享专场
+(void)specialShare:(NSString *)store_id
         special_id:(NSString *)special_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;


//分享专场回调
+(void)specialShareBack:(NSString *)store_id
             special_id:(NSString *)special_id
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;



//门店配送
+(void)StoreUpdateDeliverys:(NSString *)store_id
                  rangetype:(NSString *)rangetype
                      money:(NSString *)money
                   progress:(void (^)(NSProgress *progress))progress
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;

//查询配送信息
+(void)StoreQueryDeliverys:(NSString *)store_id
                  progress:(void (^)(NSProgress *progress))progress
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError *err))failure;


//支付宝支付签名
+(void)alipaySign:(NSString *)order_id
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;





//检查版本
+(void)appVersion:(NSString *)platform
       os_version:(NSString *)os_version
      app_version:(NSString *)app_version
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure;

@end
