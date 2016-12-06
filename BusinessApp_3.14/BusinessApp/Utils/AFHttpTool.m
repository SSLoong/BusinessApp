
#import "AFHttpTool.h"
#import <AFNetworking.h>
#import "SecurityUtil.h"


@implementation AFHttpTool


+(NSString *)getSuiJINum{

    NSMutableString *nubStr = [NSMutableString string];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    NSString *temp = nil;
    for(int i =0; i < [timeString length]; i++)
    {
        temp = [timeString substringWithRange:NSMakeRange(i, 1)];
        if(![temp isEqualToString:@"."]){
            
            [nubStr appendFormat:@"%@",temp];
            [nubStr appendFormat:@"%@",temp];
            
        }
    }

    return [NSString stringWithFormat:@"?req_no=%@",[SecurityUtil encryptAESData:nubStr]];;

}


+(void)requestWihtMethod:(RequestMethodType)methodType
                     url:(NSString *)url
                  params:(NSDictionary *)params
                progress:(void (^)(NSProgress *))progress
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure
{

    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",SITE_SERVER,url,[AFHttpTool getSuiJINum]];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
   
    sessionManager.requestSerializer.timeoutInterval=60.0f;
    
    sessionManager.requestSerializer    = [AFHTTPRequestSerializer serializer];
    
    sessionManager.responseSerializer   = [AFHTTPResponseSerializer serializer];
    
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithDictionary:params copyItems:YES];
    [dic setObject:@"iOS" forKey:@"platform"];
    [dic setObject:[AppUtil getAppVersion] forKey:@"app_version"];

    NSString *jiaMiParams = [SecurityUtil encryptAESData:[dic mj_JSONString]];
    //WYBLog(@"%@",jiaMiParams);
    switch (methodType) {
            
        case RequestMethodTypeGet:
        {
            
            [sessionManager GET:urlString parameters:jiaMiParams progress:^(NSProgress *downloadProgress) {
                
                if (progress) {
                    progress(downloadProgress);
                }
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSDictionary *dicObject = [[SecurityUtil decryptAESHex:[responseObject mj_JSONString]] mj_JSONObject];
                
                if (success) {
                    success(dicObject);
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                if (failure) {
                    failure(error);
                }
                
            }];
            
        }
            break;
        case RequestMethodTypePost:
        {
            
            [sessionManager POST:urlString parameters:jiaMiParams progress:^(NSProgress * _Nonnull uploadProgress) {
                
                if (progress) {
                    progress(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                NSDictionary *dicObject = [[SecurityUtil decryptAESHex:[responseObject mj_JSONString]] mj_JSONObject];
                
                if (success) {
                    success(dicObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (failure) {
                    failure(error);
                }
                
            }];
            
        }
            break;
        default:
            break;
    }
}



+(void) uploadPictureWithURL:(NSString *)url
                   nameArray:(NSArray *)names
                 imagesArray:(NSArray *)images
                      params:(NSDictionary *)params
                    progress:(void (^)(NSProgress *progress))progress
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure{

    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    sessionManager.requestSerializer.timeoutInterval=30.0f;

    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",SITE_SERVER,url,[AFHttpTool getSuiJINum]];

    [sessionManager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
        int i = 0;

        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:date];
        
        for (UIImage *image in images) {
            
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
            
            NSData *imageData;
            
            imageData = UIImageJPEGRepresentation(image, 0.5f);
            
            [formData appendPartWithFileData:imageData name:names[i] fileName:fileName mimeType:@"image/jpg/png/jpeg"];
            
            i++;
        }
    
        } progress:^(NSProgress * _Nonnull uploadProgress) {
    
            if (progress) {
                progress(uploadProgress);
            }
    
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
            if (success) {
                success(responseObject);
            }
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
            if (failure) {
                failure(error);
            }
        }];
}


+(void)GoodsIncome:(NSString *)store_id
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/income/goods/count"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}




+(void)getCodePhone:(NSString *)login_phone
           progress:(void (^)(NSProgress *))progress
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure{

    
    NSDictionary *params = @{@"login_phone":login_phone};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/smsauth/register"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


+(void)findpwdCode:(NSString *)login_phone
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"login_phone":login_phone};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/smsauth/findpwd"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}



//注册商户
+(void)registerStore:(NSString *)login_phone
           login_pwd:(NSString *)login_pwd
            sms_code:(NSString *)sms_code
            progress:(void (^)(NSProgress *))progress
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"login_phone":login_phone,@"login_pwd":login_pwd,@"sms_code":sms_code};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/register"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}






+(void)LoginWithPhone:(NSString *)phone
                  pwd:(NSString *)pwd
             progress:(void (^)(NSProgress *))progress
              success:(void (^)(id))success
              failure:(void (^)(NSError *))failure{

    NSDictionary *params = @{@"login_phone":phone,@"login_pwd":pwd};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/login"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


+(void)resetPassWord:(NSString *)login_phone
           login_pwd:(NSString *)login_pwd
            sms_code:(NSString *)sms_code
            progress:(void (^)(NSProgress *))progress
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure{

    NSDictionary *params = @{@"login_phone":login_phone,@"login_pwd":login_pwd,@"sms_code":sms_code};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/loginpwd/reset"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}








+(void)getProvinceList:(NSString *)query
              progress:(void (^)(NSProgress *))progress
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure{

    NSDictionary *params = @{@"query":query};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/province/list"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


+(void)getCityList:(NSString *)province_id
              progress:(void (^)(NSProgress *))progress
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"province_id":province_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/city/list"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


+(void)getCountyList:(NSString *)city_id
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"city_id":city_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/area/list"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}



+(void)getStoreList:(NSString *)site_code
           progress:(void (^)(NSProgress *))progress
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"site_code":site_code};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/regalldealer"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}





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
             failure:(void (^)(NSError *))failure{


    NSDictionary *params = @{@"store_id":store_id,@"name":name,@"company_name":company_name,@"contact":contact,@"phone":phone,@"province":province,@"city":city,@"area":area,@"address":address,@"type":type,@"site_code":site_code,@"dealer_id":dealer_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/info/complete"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


+(void)registerComplete:(NSString *)store_id
            id_img_pros:(NSString *)id_img_pros
            id_img_cons:(NSString *)id_img_cons
   business_license_img:(NSString *)business_license_img
    hygiene_license_img:(NSString *)hygiene_license_img
              store_img:(NSString *)store_img
               progress:(void (^)(NSProgress *))progress
                success:(void (^)(id))success
                failure:(void (^)(NSError *))failure{

    
    NSDictionary *params = @{@"store_id":store_id,@"id_img_pros":id_img_pros,@"id_img_cons":id_img_cons,@"business_license_img":business_license_img,@"hygiene_license_img":hygiene_license_img,@"store_img":store_img};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/auth/complete"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
 
}





#pragma mark - 门店API

+ (void)getStoreInfo:(NSString *)store_id
            progress:(void (^)(NSProgress *))progress
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure{

    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/info"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}

//粉丝管理
+ (void)manageTheFan:(NSString *)store_id
                page:(NSString *)page
                name:(NSString *)name
            progress:(void (^)(NSProgress *))progress
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"store_id":store_id,@"page":page,@"name":name};
    WYBLog(@"%@",params);
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/fans/list"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}

+ (void)fansInfo:(NSString *)store_id
         fans_id:(NSString *)fans_id
        progress:(void (^)(NSProgress *))progress
         success:(void (^)(id))success
         failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"store_id":store_id,@"id":fans_id};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/fans/info"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//粉丝详情
+ (void)fansDetails:(NSString *)store_id
               page:(NSString *)page
            cust_id:(NSString *)cust_id
           progress:(void (^)(NSProgress *))progress
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"store_id":store_id,
                             @"page":page,
                             @"cust_id":cust_id};
    
    WYBLog(@"%@",params);
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/fans/trade/record"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}




//备注姓名
+ (void)edtiorname:(NSString *)customeid
                name:(NSString *)name
            progress:(void (^)(NSProgress *))progress
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"id":customeid,
                             @"name":name};
    WYBLog(@"%@",params);
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/fans/remark"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}




//扫码出库
+ (void)output:(NSString *)store_id
     codeArray:(NSString *)codeArray
      progress:(void (^)(NSProgress *))progress
       success:(void (^)(id))success
       failure:(void (^)(NSError *))failure
{
    
    NSDictionary *params = @{@"store_id":store_id,
                             @"code":codeArray};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/barcodes"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//扫码出库
+(void)sureout:(NSString *)store_id
     goodArray:(NSString *)codeArray
         phone:(NSString *)phone
          name:(NSString *)name
      progress:(void (^)(NSProgress *))progress
       success:(void (^)(id))success
       failure:(void (^)(NSError *))failure
{
    
    NSDictionary *params = @{@"store_id":store_id,
                             @"goods":codeArray,
                             @"phone":[phone checkTheStr],
                             @"name":[name checkTheStr]};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/saleout"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}


//选择老客户
+ (void)storeCustomer:(NSString *)store_id
                 name:(NSString *)name
                 page:(NSString *)page
                 rows:(NSString *)rows
           progress:(void (^)(NSProgress *))progress
       success:(void (^)(id))success
       failure:(void (^)(NSError *))failure
{
    
    NSDictionary *params = @{@"store_id":store_id,
                             @"name":[name checkTheStr],
                             @"page":page,
                             @"rows":rows};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/storecustomer"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}


//分享店铺
+(void)appShare:(NSString *)store_id
       progress:(void (^)(NSProgress *progress))progress
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/app/share"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}



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
              progress:(void (^)(NSProgress *))progress
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure{


    NSDictionary *params = @{@"store_id":store_id,@"name":name,@"phone":phone,@"contact":contact,@"site_code":site_code,@"province":province,@"city":city,@"area":area,@"address":address,@"type":type};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/info/update"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}




+ (void)feedback:(NSString *)login_phone
feedback_content:(NSString *)feedback_content
    contact_mode:(NSString *)contact_mode
        store_id:(NSString *)store_id
        progress:(void (^)(NSProgress *))progress
         success:(void (^)(id))success
         failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"store_id":store_id,@"login_phone":login_phone,@"feedback_content":feedback_content,@"contact_mode":contact_mode};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/feedback"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}







+(void)chanegStoreStatus:(NSString *)store_id
                  status:(NSString *)status
                progress:(void (^)(NSProgress *))progress
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure{

    NSDictionary *params = @{@"store_id":store_id,@"status":status};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/status/change"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];


}


+(void)changeReceipt:(NSString *)store_id
             receipt:(NSInteger)receipt
            progress:(void (^)(NSProgress *))progress
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure{

    NSString *receiptStr = [NSString stringWithFormat:@"%ld",(long)receipt];
    NSDictionary *params = @{@"store_id":store_id,@"receipt":receiptStr};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/receipt/update"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];


}




+(void)getStoreAuthInfo:(NSString *)store_id
               progress:(void (^)(NSProgress *))progress
                success:(void (^)(id))success
                failure:(void (^)(NSError *))failure{

    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/auth/info"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}



+(void)updateDeliverranges:(NSString *)store_id
             deliver_range:(NSString *)deliver_range
                  progress:(void (^)(NSProgress *))progress
                   success:(void (^)(id))success
                   failure:(void (^)(NSError *))failure{


    NSDictionary *params = @{@"store_id":store_id,@"deliver_range":deliver_range};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/update/deliverranges"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];


}




//消息列表
+(void)StoreMsgList:(NSString *)store_id
               page:(NSInteger)page
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure{
    
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    
    WYBLog(@"%@",pageString);
    NSDictionary *params = @{@"store_id":store_id,@"page":pageString,@"rows":@"20"};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/msg/list"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
    
}


//删除消息
+(void)StoreDeleteMsg:(NSString *)msg_id
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"msg_id":msg_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/msg/del"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}

//读取消息
+(void)StoreReadMsg:(NSString *)msg_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"msg_id":msg_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/msg/read"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}




//操作员列表
+(void)StoreOperatorList:(NSString *)store_id
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/operator/list"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
    
}


//添加门店操作员
+(void)StoreAddoperator:(NSString *)login_phone
               store_id:(NSString *)store_id
              login_pwd:(NSString *)login_pwd
               sms_code:(NSString *)sms_code
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"login_phone":login_phone,@"store_id":store_id,@"login_pwd":login_pwd,@"sms_code":sms_code};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/addoperator"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}
//锁定操作员
+(void)StoreLockoperator:(NSString *)store_id
             login_phone:(NSString *)login_phone
                   phone:(NSString *)phone
                  status:(NSString *)status
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"store_id":store_id,@"login_phone":login_phone,@"phone":phone,@"status":status};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/lockoperator"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}
//删除操作员
+(void)StoreOperatorDel:(NSString *)store_id
            login_phone:(NSString *)login_phone
                  phone:(NSString *)phone
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"store_id":store_id,@"login_phone":login_phone,@"phone":phone};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/operator/del"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
    
}
//添加操作员发送验证码
+(void)SmsauthAddOperator:(NSString *)login_phone
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"login_phone":login_phone};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/smsauth/addoperator"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}



//生成订单左边品牌
+(void)StoreSaleBrand:(NSString *)store_id
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/query/salsebrand"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}



//生成订单查询在售商品
+(void)StoreSaleGoods:(NSString *)store_id
             brand_id:(NSString *)brand_id
                 page:(NSInteger)page
             progress:(void (^)(NSProgress *progress))progress
              success:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure{


    NSDictionary *params = @{@"store_id":store_id,@"brand_id":brand_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/query/salsegoods"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}



//生成订单提交订单内容
+(void)StoreCreateOrder:(NSString *)store_id
                   data:(NSDictionary *)data
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure{


    NSDictionary *params = @{@"store_id":store_id,@"data":data};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/create/order"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];


}



//购物车订单详情
+(void)OrderCart:(NSString *)key
        store_id:(NSString *)store_id
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"key":key,@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/cart"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


//生成订单活动商品详情
+(void)SpecialGoods:(NSString *)store_id
           goods_id:(NSString *)goods_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"store_id":store_id,@"goods_id":goods_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/query/specialgoods"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}

//添加到购物车
+(void)AddGoodsCart:(NSString *)key
           store_id:(NSString *)store_id
         special_id:(NSString *)special_id
              sg_id:(NSString *)sg_id
            buy_num:(NSString *)buy_num
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"key":key,@"store_id":store_id,@"special_id":special_id,@"sg_id":sg_id,@"buy_num":buy_num,};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/cart/add"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}

+(void)CartBargain:(NSString *)key
                 store_id:(NSString *)store_id
              special_id:(NSString *)special_id
                     sg_id:(NSString *)sg_id
                      price:(NSString *)price
                progress:(void (^)(NSProgress *))progress
                 success:(void (^)(id))success
                    failure:(void (^)(NSError *))failure{

    NSDictionary *params = @{@"key":key,@"store_id":store_id,@"special_id":special_id,@"sg_id":sg_id,@"price":price,};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/cart/bargain"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}

//查询购物车
+(void)cartDetail:(NSString *)key
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{


    NSDictionary *params = @{@"key":key};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/cart/detail"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


//扫描订单支付成功
+(void)orderResult:(NSString *)key
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"key":key};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/result"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];


}




#pragma mark - 订单api

+(void)getOrder:(NSString *)store_id
     start_time:(NSString *)start_time
       end_time:(NSString *)end_time
           type:(NSInteger)type
          phone:(NSString *)phone
           page:(NSInteger)page
       progress:(void (^)(NSProgress *))progress
        success:(void (^)(id))success
        failure:(void (^)(NSError *))failure{

    NSString *typeString = [NSString stringWithFormat:@"%ld",(long)type];
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];

    
    NSDictionary *params=@{@"store_id":store_id,@"start_time":start_time,@"end_time":end_time,@"type":typeString,@"phone":phone,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}



+(void) orderDetail:(NSString *)store_id
           order_id:(NSString *)order_id
           progress:(void (^)(NSProgress *))progress
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure{

    NSDictionary *params=@{@"store_id":store_id,@"order_id":order_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/info"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}





//查询可配送物流公司
+(void)logisticsCompany:(NSString *)store_id
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure{

    NSDictionary *params=@{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/site/expresscompany"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];



}



//选择订单配送公司
+(void) orderLogistics:(NSString *)order_id
ordexpress_company_ider_id:(NSString *)express_company_id
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure{

    NSDictionary *params=@{@"order_id":order_id,@"express_company_id":express_company_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/set/express"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}



//修改订单金额
+(void) orderUpdatePrice:(NSString *)store_id
                order_id:(NSString *)order_id
             login_phone:(NSString *)login_phone
                   money:(NSString *)money
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure{


    NSDictionary *params=@{@"order_id":order_id,@"store_id":store_id,@"login_phone":login_phone,@"money":money};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/realamount/update"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];



}



//订单确认验证码
+(void) orderConfirmorder:(NSString *)order_id
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure{


    NSDictionary *params=@{@"order_id":order_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/smsauth/confirmorder"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];


}



//手动确认订单
+(void) orderCodeConfirm:(NSString *)order_id
                sms_code:(NSString *)sms_code
                 cust_id:(NSString *)cust_id
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure{


    NSDictionary *params=@{@"order_id":order_id,@"sms_code":sms_code,@"cust_id":cust_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/confirm"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}



//扫码确认订单
+(void) orderConfirmnew:(NSArray *)order_id
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure{

    NSDictionary *params=@{@"order_id":order_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/confirmnew"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}



//订单物流查询
+(void) orderExpress:(NSString *)order_id
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure{

    NSDictionary *params=@{@"order_id":order_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/order/query/express"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


#pragma mark - 收入API


+(void)chanegStoreDeliver:(NSString *)store_id
                 progress:(void (^)(NSProgress *))progress
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure{

    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/deliver/change"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}



+(void)getDefaultBank:(NSString *)store_id
             progress:(void (^)(NSProgress *))progress
              success:(void (^)(id))success
              failure:(void (^)(NSError *))failure{

    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/bank/default"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


//收入商品明细列表
+(void)incomeGoodsDetailed:(NSString *)goods_id
                  store_id:(NSString *)store_id
                      page:(NSInteger )page
                  progress:(void (^)(NSProgress *progress))progress
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError *err))failure{

    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"goods_id":goods_id,@"store_id":store_id,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/income/goods/detailed"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}

//提现明细列表
+(void)IncomeWithDrawalsDetailed:(NSString *)store_id
                            type:(NSString *)type
                      start_time:(NSString *)start_time
                        end_time:(NSString *)end_time
                            page:(NSInteger)page
                        progress:(void (^)(NSProgress *progress))progress
                         success:(void (^)(id response))success
                         failure:(void (^)(NSError *err))failure{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"type":type,@"start_time":start_time,@"end_time":end_time,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/income/withdrawals/detailed"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];


}


//红包代金券列表
+(void)IncomeRewardDetailed:(NSString *)store_id
                            type:(NSString *)type
                            page:(NSInteger)page
                        progress:(void (^)(NSProgress *progress))progress
                         success:(void (^)(id response))success
                         failure:(void (^)(NSError *err))failure{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"type":type,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/income/rewarddetail"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
    
}


+(void)withdrawalsDetail:(NSString *)store_id
                    type:(NSString *)type
              start_time:(NSString *)start_time
                  amount:(NSString *)end_time
                progress:(void (^)(NSProgress *))progress
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure{

    NSDictionary *params = @{@"store_id":store_id,@"type":type,@"start_time":start_time,@"end_time":end_time};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/income/withdrawals/detailed"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}



+(void)withdrawalsApply:(NSString *)store_id
            login_phone:(NSString *)login_phone
                   type:(NSString *)type
                  mount:(NSString *)amount
                bank_id:(NSString *)bank_id
               progress:(void (^)(NSProgress *))progress
                success:(void (^)(id))success
                failure:(void (^)(NSError *))failure{

    NSDictionary *params = @{@"store_id":store_id,@"login_phone":login_phone,@"type":type,@"amount":amount,@"bank_id":bank_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/income/withdrawals/apply"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


+(void)incomeDetail:(NSString *)store_id
           progress:(void (^)(NSProgress *))progress
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/income"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}


+(void)incomeDetailData:(NSString *)store_id
             start_time:(NSString *)start_time
               end_time:(NSString *)end_time
                   page:(NSInteger)page
                   type:(NSInteger)type
               progress:(void (^)(NSProgress *))progress
                success:(void (^)(id))success
                failure:(void (^)(NSError *))failure{

    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"start_time":start_time,@"end_time":end_time,@"page":pageString,@"type":@(type)};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/income/detailed"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    

}


+(void)incomeBankList:(NSString *)store_id
             progress:(void (^)(NSProgress *))progress
              success:(void (^)(id))success
              failure:(void (^)(NSError *))failure{

    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/bank/list"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


+(void)incomeDeleteBank:(NSString *)store_id
                bank_id:(NSString *)bank_id
               progress:(void (^)(NSProgress *))progress
                success:(void (^)(id))success
                failure:(void (^)(NSError *))failure{

    NSDictionary *params = @{@"store_id":store_id,@"bank_id":bank_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/bank/del"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


+(void)incomeSetDefaultBank:(NSString *)store_id
                    bank_id:(NSString *)bank_id
                   progress:(void (^)(NSProgress *))progress
                    success:(void (^)(id))success
                    failure:(void (^)(NSError *))failure{
    
    NSDictionary *params = @{@"store_id":store_id,@"bank_id":bank_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/bank/setdefault"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}


+(void)incomeBindBankList:(NSString *)query
                 progress:(void (^)(NSProgress *))progress
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure{

    NSDictionary *params = @{@"query":query};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/bindbanks"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


+(void)incomeAddBank:(NSString *)store_id
           bank_code:(NSString *)bank_code
                name:(NSString *)name
         open_branch:(NSString *)open_branch
          bank_phone:(NSString *)bank_phone
           bank_card:(NSString *)bank_card
   open_bank_address:(NSString *)address
            progress:(void (^)(NSProgress *))progress
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure{



    NSDictionary *params = @{@"store_id":store_id,@"bank_code":bank_code,@"name":name,@"open_branch":open_branch,@"bank_phone":bank_phone,@"bank_card":bank_card,@"open_bank_address":address};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/bank/add"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


+(void)incomeGoods:(NSString *)store_id
          brand_id:(NSString *)brand_id
        start_time:(NSString *)start_time
          end_time:(NSString *)end_time
              page:(NSInteger)page
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure{

    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"brand_id":brand_id,@"start_time":start_time,@"end_time":end_time,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/income/goods/count"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


+(void)getAllGoods:(NSString *)query progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure{


    NSDictionary *params = @{@"query":query};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/category/all"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}




+(void)withdrawDeposit:(NSString *)store_id
                  type:(NSString *)type
            start_time:(NSString *)start_time
              end_time:(NSString *)end_time
                  page:(NSInteger)page
              progress:(void (^)(NSProgress *))progress
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure{


    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"type":type,@"start_time":start_time,@"end_time":end_time,@"page":pageString,};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/income/withdrawals/detailed"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];


}



#pragma mark - 商品api






//店铺库存
+(void)GoodsStock:(NSString *)store_id
         brand_id:(NSString *)brand_id
             page:(NSInteger)page
             type:(NSInteger)type
             sort:(NSInteger)sort
        stocktype:(NSInteger)stocktype
         progress:(void (^)(NSProgress *))progress
          success:(void (^)(id))success
          failure:(void (^)(NSError *))failure{
    
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    
    NSDictionary *params = @{@"store_id":store_id,@"brand_id":brand_id,@"type": @(type),@"sort":@(sort),@"stocktype":@(stocktype),@"page":pageString};
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                                      url:@"/goods/stock"
                                   params:params
                                 progress:progress
                                  success:success
                                  failure:failure];

}

//扫码添加商品
+(void)GoodsScan:(NSString *)store_id
         barcode:(NSString *)barcode
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"store_id":store_id,@"barcode":barcode};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/barcode"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


//非连锁店商品品牌
+(void)GoodsCategory:(NSString *)store_id
            progress:(void (^)(NSProgress *progress))progress
             success:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/site/category"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


//商品搜索--非连锁
+(void)GoodsSearch:(NSString *)store_id
          keywords:(NSString *)keywords
          brand_id:(NSString *)brand_id
              page:(NSInteger)page
          progress:(void (^)(NSProgress *progress))progress
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure{

    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"keywords":keywords,@"brand_id":brand_id,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/search"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}



//商品图片和信息
+(void)GoodsInfo:(NSString *)store_id
        goods_id:(NSString *)goods_id
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"store_id":store_id,@"goods_id":goods_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/info"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


//非连锁添加上库存
+(void)GoodsAdd:(NSString *)store_id
       goods_id:(NSString *)goods_id
       mk_price:(NSString *)mk_price
          price:(NSString *)price
       progress:(void (^)(NSProgress *progress))progress
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"store_id":store_id,@"store_goods_id":goods_id,@"price":price,@"mkprice":mk_price,};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/update/price"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}

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
        failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"store_id":store_id,@"goods_id":goods_id,@"price":price,@"real_price":real_price,@"purchase_price":purchase_price,@"stock":stock,@"type":@"2",@"goods_name":goods_name,@"goods_img":goods_img,@"barcode":barcode};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/add"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}







//商品营销设置列表
+(void)GoodsStand:(NSString *)store_id
         brand_id:(NSString *)brand_id
             type:(NSString *)type
             sort:(NSString *)sort
             page:(NSInteger)page
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"brand_id":brand_id,@"type":type,@"sort":sort,@"page":pageString,};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/stand"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
    
}


//商品营销活动列表
+(void)GoodsActivityst:(NSString *)store_id
        store_goods_id:(NSString *)store_goods_id
                  page:(NSInteger)page
              progress:(void (^)(NSProgress *))progress
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"store_goods_id":store_goods_id,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/activity/list"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}

//添加活动
+(void)GoodsAddActivity:(NSString *)store_id
         store_goods_id:(NSString *)store_goods_id
                  title:(NSString *)title
             start_time:(NSString *)start_time
               end_time:(NSString *)end_time
              subamount:(NSString *)subamount
                scustid:(NSArray *)scustid
               progress:(void (^)(NSProgress *))progress
                success:(void (^)(id))success
                failure:(void (^)(NSError *))failure{
    NSDictionary *params = @{@"store_id":store_id,@"store_goods_id":store_goods_id,@"title":title,@"start_time":start_time,@"end_time":end_time,@"subamount":subamount,@"scustid":scustid};
  
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/activity/add"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}

//查询推送用户

+(void)GoodsPushChoose:(NSString *)store_id
        store_goods_id:(NSString *)store_goods_id
                activity_id:(NSString *)activity_id
                  page:(NSInteger)page
              progress:(void (^)(NSProgress *))progress
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure{
    
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"store_goods_id":store_goods_id,@"activity_id":activity_id,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/activity/customer"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}


//营销设置
+(void)GoodsSetSubamount:(NSString *)store_goods_id
               subamount:(NSString *)subamount
                store_id:(NSString *)store_id
               recommend:(NSString *)recommend
                progress:(void (^)(NSProgress *progress))progress
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"store_goods_id":store_goods_id,@"subamount":subamount,@"store_id":store_id,@"recommend":recommend};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/set/subamount"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}





//查询所有商品（连锁）

+(void)goodsSell:(NSString *)store_id
        brand_id:(NSString *)brand_id
            page:(NSInteger)page
        progress:(void (^)(NSProgress *progress))progress
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure{


    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"brand_id":brand_id,@"page":pageString,};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/storesale/goods"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];



}


//商品开售停售（连锁）
+(void)goodsSaleSwitch:(NSString *)store_id
       dealer_goods_id:(NSString *)dealer_goods_id
                status:(NSInteger)status
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure{


    NSString *statusString = [NSString stringWithFormat:@"%ld",(long)status];
    NSDictionary *params = @{@"store_id":store_id,@"dealer_goods_id":dealer_goods_id,@"status":statusString,};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/store/sale"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


//专场列表

+(void)goodsSaleSpecial:(NSString *)store_id
                   page:(NSInteger)page
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure{


    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"page":pageString,};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/dealer/special"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}

//销售奖励
+(void)goodsSaleStatistics:(NSString *)store_id
                      page:(NSInteger)page
                  progress:(void (^)(NSProgress *))progress
                   success:(void (^)(id))success
                   failure:(void (^)(NSError *))failure{
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"page":pageString,@"rows":@10};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/purchase/salestatistics"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];



}

//历史特卖
+(void)goodsSaleSpecial:(NSString *)store_id
             start_time:(NSString *)start_time
               end_time:(NSString *)end_time
                   page:(NSInteger)page
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure{


    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"start_time":start_time,@"end_time":end_time,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/dealer/oldspecial"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}



//专场详情
+(void)goodsSpecialDetail:(NSString *)store_id
               special_id:(NSString *)special_id
                     page:(NSInteger)page
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure{

    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *params = @{@"store_id":store_id,@"special_id":special_id,@"page":pageString};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/dealer/specialinfo"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];


}






//专场商品申请入库
+(void)goodsSpecialAdd:(NSString *)store_id
            special_id:(NSString *)special_id
             dealer_id:(NSString *)dealer_id
              goods_id:(NSString *)goods_id
                  nums:(NSString *)nums
                 price:(NSString *)price
              progress:(void (^)(NSProgress *progress))progress
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"store_id":store_id,@"special_id":special_id,@"dealer_id":dealer_id,@"goods_id":goods_id,@"nums":nums,@"price":price};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/goods/add/specialgoods"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];


}


//分享专场
+(void)specialShare:(NSString *)store_id
         special_id:(NSString *)special_id
           progress:(void (^)(NSProgress *progress))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure{


    NSDictionary *params = @{@"store_id":store_id,@"special_id":special_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/app/specialshare"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


//分享专场回调
+(void)specialShareBack:(NSString *)store_id
             special_id:(NSString *)special_id
               progress:(void (^)(NSProgress *progress))progress
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure{


    NSDictionary *params = @{@"store_id":store_id,@"special_id":special_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/app/specialshareback"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}









//门店配送
+(void)StoreUpdateDeliverys:(NSString *)store_id
                  rangetype:(NSString *)rangetype
                      money:(NSString *)money
                   progress:(void (^)(NSProgress *progress))progress
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure{
    
    NSDictionary *params = @{@"store_id":store_id,@"rangetype":rangetype,@"money":money};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/update/deliverys"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
}

//查询配送信息
+(void)StoreQueryDeliverys:(NSString *)store_id
                  progress:(void (^)(NSProgress *progress))progress
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError *err))failure{
    NSDictionary *params = @{@"store_id":store_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/store/query/deliverys"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}


//支付宝支付签名
+(void)alipaySign:(NSString *)order_id
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"order_id":order_id};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/pay/sign/alipay"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];

}



//检查版本
+(void)appVersion:(NSString *)platform
       os_version:(NSString *)os_version
      app_version:(NSString *)app_version
         progress:(void (^)(NSProgress *progress))progress
          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure{

    NSDictionary *params = @{@"platform":platform,@"os_version":os_version,@"app_version":app_version};
    [AFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"/app/version/check"
                           params:params
                         progress:progress
                          success:success
                          failure:failure];
    
}







@end
