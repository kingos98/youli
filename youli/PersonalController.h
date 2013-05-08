//
//  PersonalController.h
//  youli
//
//  Created by jun on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "FriendInfoController.h"
#import "SubTableCell.h"

@interface PersonalController : BaseController<UITableViewDelegate, UITableViewDataSource,SinaWeiboDelegate,SinaWeiboRequestDelegate>{
    NSMutableArray *data;
    NSDictionary *friendDic;
}

@property(strong,nonatomic)FriendInfoController *friendInfoController;
@property(strong,nonatomic)UIButton *friendButton;
@property(strong,nonatomic)UIButton *collectButton;
@property(strong,nonatomic)UIButton *strangerButton;
@property(strong,nonatomic)UIButton *editButton;
@property(strong,nonatomic)NSMutableArray *messageArray;
@property(strong,nonatomic)SubTableCell *subTableCell;
@property(strong,nonatomic)UIScrollView *collectView;

@end
