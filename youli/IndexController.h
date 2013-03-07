//
//  ViewController.h
//  youli
//
//  Created by jun on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "BirthdayGiftController.h"
#import "YouliDelegate.h"
#import "PersonalController.h"
#import "BirthdayController.h"
#import "LoginController.h"

@interface IndexController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    bool isPopCategoryView;
    UIScrollView *mainScrollView;
    UIView *categoryView;
    UIImageView *categoryBgImage;
    UIImageView *imgGiftScrollView;
    CategoryTableView *categoryTableView;
    UITextField *_value;
    
    BOOL isLoading;
    
    UIImageView *splashView;            //欢迎图片
}

@property(nonatomic, retain)UITextField *value;
@property(nonatomic, retain)UIImageView *tabBarBgView;
@property(nonatomic, retain)UIButton *tabBarLeftButton;
@property(nonatomic, retain)UIButton *tabBarBoxButton;
@property(nonatomic, retain)UIButton *tabBarRightButton;

@property(nonatomic,retain)NSMutableArray *items;
@property(nonatomic,retain)NSMutableArray *giftTypeItems;
@property(nonatomic,retain)NSArray *templateForIphone4;
@property (nonatomic, strong)Category *category;
@property(nonatomic,strong)BirthdayGiftController *birthdayGiftController;
@property(nonatomic,strong)PersonalController *personalController;
@property(nonatomic,strong)LoginController *loginController;
@property(nonatomic,strong)BirthdayController *birthdayController;


@property (nonatomic, strong) UIView *refreshFooterView;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, strong) NSString *textPull;
@property (nonatomic, strong) NSString *textLoading;

@property id<YouliDelegate> delegate;

@end
