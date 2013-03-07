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

@end
