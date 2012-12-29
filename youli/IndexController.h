//
//  ViewController.h
//  youli
//
//  Created by jun on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "BirthdayGiftControllerNew.h"
#import "YouliDelegate.h"


@interface IndexController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    bool isPopCategoryView;
    UIScrollView *mainScrollView;
    UIView *categoryView;
    UIImageView *categoryBgImage;
    UITableView *categoryTableView;
    UITextField *_value;
}

@property(nonatomic, retain)UITextField *value;
@property(nonatomic, retain)UIImageView *tabBarBgView;
@property(nonatomic, retain)UIButton *tabBarLeftButton;
@property(nonatomic, retain)UIButton *tabBarBoxButton;
@property(nonatomic, retain)UIButton *tabBarRightButton;

@property(nonatomic,retain)NSMutableArray *items;
@property(nonatomic,retain)NSMutableArray *giftTypeItems;
@property(nonatomic,retain)NSArray *templateForIphone4;
@property (nonatomic, strong) Category *category;
@property(nonatomic,strong) BirthdayGiftControllerNew *birthdayGiftController;

@property id<YouliDelegate> delegate;

@end
