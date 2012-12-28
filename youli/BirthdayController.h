//
//  BirthdayController.h
//  youli
//
//  Created by jun on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Birthday.h"

@interface BirthdayController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *data;
}

@property (nonatomic, strong) Birthday *birthday;

@end
