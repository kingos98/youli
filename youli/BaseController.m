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
        //类别view，可向右滑动，初始化时处于第一层，相当于被隐藏。
        categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 212, 460)];
        
        //添加分类页面
        categoryTableView = [[CategoryTableView alloc] initWithFrame:CGRectMake(0, 0, 212, 460)];
        [categoryView addSubview:categoryTableView];
        
        //主页面view，当前可看到的页面。
        mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        
        //底部导航条
        self.tabBarBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 378, 320, 38)];
        tabBarBgImage.image = [UIImage imageNamed:@"tabbar_bg.png"];
        
        tabBarLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *tabBarLeftImage = [UIImage imageNamed:@"tabbar_left.png"];
        tabBarLeftButton.frame = CGRectMake(0, 378, 78, 38);
        [self.tabBarLeftButton setBackgroundImage:tabBarLeftImage forState:UIControlStateNormal];
        [tabBarLeftButton addTarget:self action:@selector(showCategoryViewPressed) forControlEvents:UIControlEventTouchUpInside];
                
        tabBarBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *tabBarBoxImage = [UIImage imageNamed:@"tabbar_box.png"];
        tabBarBoxButton.frame = CGRectMake(120, 371, 78, 45);
        [self.tabBarBoxButton setBackgroundImage:tabBarBoxImage forState:UIControlStateNormal];
        [tabBarBoxButton addTarget:self action:@selector(birthdayButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        tabBarRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *tabBarRightImage = [UIImage imageNamed:@"tabbar_right.png"];
        tabBarRightButton.frame = CGRectMake(240, 378, 78, 38);
        [self.tabBarRightButton setBackgroundImage:tabBarRightImage forState:UIControlStateNormal];
        [tabBarRightButton addTarget:self action:@selector(personalButtonPressed) forControlEvents:UIControlEventTouchUpInside];
      
        //加到父view中的子view是按顺序加载的，需注意加载子view的顺序！
        [self.view addSubview:categoryView];
        [self.view addSubview:mainView];
        [mainView addSubview:tabBarBgImage];
        [mainView addSubview:tabBarLeftButton];
        [mainView addSubview:tabBarBoxButton];
        [mainView addSubview:tabBarRightButton];
        
        categoryTableView.delegate=self;

        isPopCategoryView=NO;
        //为mainScrollView添加手势操作
        UIPanGestureRecognizer *mainViewPan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleMainPan:)];
        [mainView addGestureRecognizer: mainViewPan];

        isPopCategoryView=false;
    }
    return self;
}

- (void)showCategoryViewPressed
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];

    CGPoint point = mainView.center;

    mainView.center = CGPointMake(point.x+212,point.y);

    isPopCategoryView=true;
    
    [UIView commitAnimations];
}

-(void)hideCategoryView
{
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

-(void) handleMainPan:(UIPanGestureRecognizer *) gestureRecognizer{
    if([gestureRecognizer state]==UIGestureRecognizerStateBegan||[gestureRecognizer state]==UIGestureRecognizerStateChanged)
    {
        CGPoint cgpoint=[gestureRecognizer translationInView:self.view];
        if(cgpoint.x<0)
        {
            if(isPopCategoryView)
            {
                [self hideCategoryView];
            }
            
        }
        else
        {
            if(!isPopCategoryView)
            {
                [self showCategoryViewPressed];
            }
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = (CategoryCell*)[categoryTableView cellForRowAtIndexPath:indexPath];
    
    [self.youliDelegate sendGiftTypeTitle:cell.nameLabel.text];
    
//    [self.navigationController pushViewController:self.birthdayGiftController animated:YES];
    
    cell.labelImage.image = [UIImage imageNamed:@"selected.png"];
    cell.nextImage.image = [UIImage imageNamed:@"pointerselect.png"];
    
    [self hideCategoryView];

    if ([youliDelegate respondsToSelector:@selector(changeGiftListByType:)])
    {
        [youliDelegate changeGiftListByType:123];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = (CategoryCell*)[categoryTableView cellForRowAtIndexPath:indexPath];
    cell.labelImage.image = [UIImage imageNamed:@"unselected.png"];
    cell.nextImage.image = [UIImage imageNamed:@"pointerunselect.png"];
}
@end
