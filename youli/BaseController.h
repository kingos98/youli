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


@property(nonatomic,retain) UIImageView *tabBarBgImage;
@property(nonatomic,retain) UIButton *tabBarLeftButton;
@property(nonatomic,retain) UIButton *tabBarBoxButton;
@property(nonatomic,retain) UIButton *tabBarRightButton;

@property (strong,nonatomic) id<YouliDelegate> youliDelegate;
@property bool isPopCategoryView;                   //判断是否打开分类列表

-(void)hideCategoryView;
-(void)showCategoryView;
@end
