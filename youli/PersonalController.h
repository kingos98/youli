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

@interface PersonalController : BaseController<UITableViewDelegate, UITableViewDataSource,SinaWeiboDelegate,SinaWeiboRequestDelegate>{
    NSMutableArray *data;
    NSDictionary *friendDic;
    UITableView *tableView;
}

@property(nonatomic,retain)NSMutableArray *items;

@end
