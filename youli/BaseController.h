//
//  BaseController.h
//  youli
//
//  Created by apple on 11/19/12.
//
//

#import <UIKit/UIKit.h>
#import "CategoryTableView.h"
#import "YouliDelegate.h"

@interface BaseController : UIViewController<UITableViewDelegate>{
    UIView *mainView;
    UIView *categoryView;
    CategoryTableView *categoryTableView;
    UIImageView *categoryBgImage;
}


@property(nonatomic,retain) UIImageView *tabBarBgImage;
@property(nonatomic,retain) UIButton *tabBarLeftButton;
@property(nonatomic,retain) UIButton *tabBarBoxButton;
@property(nonatomic,retain) UIButton *tabBarRightButton;

@property (strong,nonatomic) id<YouliDelegate> youliDelegate;
@property bool isPopCategoryView;

-(void)hideCategoryView;
-(void)showCategoryView;
@end
