//
//  BaseController.m
//  youli
//
//  Created by apple on 11/19/12.
//
//

#import "BaseController.h"
#import "PersonalController.h"
#import "BirthdayController.h"
#import "CategoryCell.h"
#import "YouliDelegate.h"
#import "AppDelegate.h"

@interface BaseController ()
@end

@implementation BaseController

@synthesize tabBarBgImage;
@synthesize tabBarBoxButton;
@synthesize tabBarLeftButton;
@synthesize tabBarRightButton;
@synthesize isPopCategoryView;


@synthesize youliDelegate;

- (id)init
{
    self = [super init];
    if (self) {
        //主页面view，当前可看到的页面。
        if(!iPhone5)
        {
            mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        }
        else
        {
            mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
        }
        
        
        //底部导航条
        if(!iPhone5)
        {
            self.tabBarBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 422, 320, 38)];
        }
        else
        {
            self.tabBarBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 510, 320, 38)];
        }
        
        tabBarBgImage.image = [UIImage imageNamed:@"tabbar_bg.png"];
        
        tabBarLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *tabBarLeftImage = [UIImage imageNamed:@"tabbar_left.png"];
        if(!iPhone5)
        {
            tabBarLeftButton.frame = CGRectMake(0, 422, 78, 38);
        }
        else
        {
            tabBarLeftButton.frame = CGRectMake(0, 510, 78, 38);
        }
        
        [self.tabBarLeftButton setBackgroundImage:tabBarLeftImage forState:UIControlStateNormal];
        [tabBarLeftButton addTarget:self action:@selector(CategoryViewOper) forControlEvents:UIControlEventTouchUpInside];
        
        tabBarBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *tabBarBoxImage = [UIImage imageNamed:@"tabbar_box.png"];
        if(!iPhone5)
        {
            tabBarBoxButton.frame = CGRectMake(120, 415, 78, 45);
        }
        else
        {
            tabBarBoxButton.frame = CGRectMake(120, 503, 78, 45);
        }
        
        [self.tabBarBoxButton setBackgroundImage:tabBarBoxImage forState:UIControlStateNormal];
        [tabBarBoxButton addTarget:self action:@selector(birthdayButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        tabBarRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *tabBarRightImage = [UIImage imageNamed:@"tabbar_right.png"];
        if(!iPhone5)
        {
            tabBarRightButton.frame = CGRectMake(240, 422, 78, 38);
        }
        else
        {
            tabBarRightButton.frame = CGRectMake(240, 510, 78, 38);
        }
        
        [self.tabBarRightButton setBackgroundImage:tabBarRightImage forState:UIControlStateNormal];
        [tabBarRightButton addTarget:self action:@selector(personalButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        //加到父view中的子view是按顺序加载的，需注意加载子view的顺序！
        [self.view addSubview:mainView];
        [mainView addSubview:tabBarBgImage];
        [mainView addSubview:tabBarLeftButton];
        [mainView addSubview:tabBarBoxButton];
        [mainView addSubview:tabBarRightButton];
                
        isPopCategoryView=false;
        
        self.youliDelegate=self;
    }
    return self;
}

-(void)CategoryViewOper
{
    if(isPopCategoryView)
    {
        [self hideCategoryView];
    }
    else
    {
        [self showCategoryView];
    }
}

//分类列表打开
- (void)showCategoryView
{
    if (isPopCategoryView) {
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGPoint point = mainView.center;
    
    mainView.center = CGPointMake(point.x+212,point.y);
    
    isPopCategoryView=true;
    
    [UIView commitAnimations];
}

//分类列表折叠
-(void)hideCategoryView
{
    if (!isPopCategoryView) {
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGPoint point=mainView.center;
    
    mainView.center=CGPointMake(point.x-212,point.y);
    
    isPopCategoryView = false;
    
    [UIView commitAnimations];
}


- (void)birthdayButtonPressed
{
    BirthdayController *birthdayController = [[BirthdayController alloc] init];
    [self.navigationController pushViewController:birthdayController animated:NO];
}

- (void)personalButtonPressed
{
    PersonalController *personalController = [[PersonalController alloc] init];
    [self.navigationController pushViewController:personalController animated:NO];
}
@end
