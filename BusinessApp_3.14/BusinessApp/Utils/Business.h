//
//  Business.h
//  BusinessApp
//
//  Created by prefect on 16/3/8.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#ifndef Business_h
#define Business_h

#endif /* Business_h */
#define DEFAULTS [NSUserDefaults standardUserDefaults]
#define ShareApplicationDelegate [[UIApplication sharedApplication] delegate]
//#define SITE_SERVER @"http://10.211.55.4:80/store"
//#define SITE_SERVER @"http://139.196.13.82:88/store"
//#define SITE_SERVER @"http://10.211.55.117:8080/store"
#define SITE_SERVER @"http://api.appsjk.com/store"
//#define SITE_SERVER @"http://10.211.56.14:8080/store"


#define Store_id [DEFAULTS objectForKey:@"store_id"]
#define LoginPhone [DEFAULTS objectForKey:@"userName"]
#define LoginPwd [DEFAULTS objectForKey:@"passWord"]
#define UmengAppKey @"57285caee0f55a9824000739"
