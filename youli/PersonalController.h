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

@property(nonatomic,retain)NSMutableArray *items;
@property(strong,nonatomic)UITableView *friendTable;
@property(strong,nonatomic)FriendInfoController *friendInfoController;
@property(strong,nonatomic)UIButton *friendButton;
@property(strong,nonatomic)UIButton *collectButton;
@property(strong,nonatomic)UIButton *cartButton;
@property(strong,nonatomic)UIButton *editButton;
@property(strong,nonatomic)UIButton *messageView;
@property(strong,nonatomic)SubTableCell *subTableCell;
@property(strong,nonatomic)UIScrollView *collectView;
@property(strong,nonatomic)UIScrollView *cartView;

@end
