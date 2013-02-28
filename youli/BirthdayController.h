//
//  BirthdayController.h
//  youli
//
//  Created by jun on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Birthday.h"
#import "YouliDelegate.h"
#import "AssignBirthdayController.h"

@interface BirthdayController : UIViewController<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>{
    NSMutableArray *data;
}

@property (nonatomic,strong)UITableView *birthdayTableView;

@property (nonatomic, strong) Birthday *birthday;

@property(nonatomic,strong)AssignBirthdayController *assignBirthdayController;

@property(nonatomic,strong)id<YouliDelegate> delegate;

@end
