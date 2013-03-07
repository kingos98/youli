//
//  LoginController.h
//  youli
//
//  Created by sjun on 3/4/13.
//
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "SinaWeiboRequest.h"

@interface LoginController : BaseController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,SinaWeiboRequestDelegate>{
    SinaWeiboRequest *weiboRequest;
}

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSDate *expirationDate;
@property (nonatomic, copy) NSString *refreshToken;

@end
