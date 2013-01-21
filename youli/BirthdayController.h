//
//  BirthdayController.h
//  youli
//
//  Created by jun on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Birthday.h"
#import "BirthdayGiftController.h"
#import "YouliDelegate.h"

@interface BirthdayController : UIViewController<UITableViewDelegate, UITableViewDataSource,YouliDelegate>{
    NSMutableArray *data;
}

@property (nonatomic,strong)UITableView *birthdayTableView;

@property (nonatomic, strong) Birthday *birthday;
@property(nonatomic,strong)BirthdayGiftController *birthdayGiftController;

@property id<YouliDelegate> delegate;

@end
