//
//  BaseController.h
//  youli
//
//  Created by apple on 11/19/12.
//
//

#import <UIKit/UIKit.h>
#import "YouliDelegate.h"

@interface BaseController : UIViewController<UITableViewDelegate>{
    UIView *mainView;
    UIView *categoryView;
    UIImageView *categoryBgImage;
}

@property(nonatomic,strong) UIImageView *tabBarBgImage;
@property(nonatomic,strong) UIButton *tabBarLeftButton;
@property(nonatomic,strong) UIButton *tabBarBoxButton;
@property(nonatomic,strong) UIButton *tabBarRightButton;
@property(nonatomic,strong) id<YouliDelegate> youliDelegate;
@property bool isPopCategoryView;                   //判断是否打开分类列表

-(void)hideCategoryView;
-(void)showCategoryView;
@end
