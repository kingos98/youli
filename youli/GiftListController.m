//
//  GiftListController.m
//  youli
//
//  Created by apple on 11/15/12.
//
//

#import "GiftListController.h"

@interface GiftListController ()

@end

@implementation GiftListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIImageView *mainBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    mainBgView.image = [UIImage imageNamed:@"bg.png"];
    
    UIImageView *priceBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    priceBgView.image = [UIImage imageNamed:@"price_bg.png"];
    
    UIImageView *giftBgView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 60, 308, 270)];
    giftBgView.image = [UIImage imageNamed:@"gift_bg.png"];
    
    UIImageView *giftView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 70, 281, 210)];
    giftView.image = [UIImage imageNamed:@"3.jpg"];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 26, 90, 15)];
    nameLabel.text = @"头花";
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    nameLabel.textColor = [UIColor colorWithRed:0.31 green:0.30 blue:0.30 alpha:1];
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    
    [mainView addSubview:mainBgView];
    [mainView addSubview:priceBgView];
    [mainView addSubview:giftBgView];
    [mainView addSubview:giftView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
