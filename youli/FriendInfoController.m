//
//  FriendCollectController.m
//  youli
//
//  Created by apple on 11/20/12.
//
//

#import "FriendInfoController.h"

@interface FriendInfoController ()

@end

@implementation FriendInfoController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *mainBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,480)];
    [mainBgView setImage:[UIImage imageNamed:@"bg.jpg"]];
    
    UIImageView *personalInfoBgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,9,300,70)];
    [personalInfoBgView setImage:[UIImage imageNamed:@"friend_info_bg.png"]];
    
    UIImageView *faceBgView = [[UIImageView alloc] initWithFrame:CGRectMake(16,15,57,59)];
    [faceBgView setImage:[UIImage imageNamed:@"face_bg.png"]];
    
    UIImageView *faceView = [[UIImageView alloc] initWithFrame:CGRectMake(19,17,51,52)];
    [faceView setImage:[UIImage imageNamed:@"icon.jpeg"]];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 24, 90, 22)];
    nameLabel.text = @"Fenng";
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    nameLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    
    UIImageView *constellationView = [[UIImageView alloc] initWithFrame:CGRectMake(87,48,16,17)];
    [constellationView setImage:[UIImage imageNamed:@"constellation.png"]];
    
    UILabel *constellationLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 46, 110, 22)];
    constellationLabel.text = @"未填写星座";
    constellationLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    constellationLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    constellationLabel.textAlignment = UITextAlignmentLeft;
    constellationLabel.backgroundColor = [UIColor clearColor];
    
    UIImageView *birthdayView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 21, 21, 22)];
    [birthdayView setImage:[UIImage imageNamed:@"birthday_unselect.png"]];
    
    UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 46, 100, 22)];
    birthdayLabel.text = @"未填写生日";
    birthdayLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    birthdayLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    birthdayLabel.textAlignment = UITextAlignmentLeft;
    birthdayLabel.backgroundColor = [UIColor clearColor];
    
    UIImageView *firendCollectBgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,78,300,31)];
    [firendCollectBgView setImage:[UIImage imageNamed:@"friend_collect_bg.png"]];
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 110, 300, 300)];
    
    for (int i=0; i<1; i++) {
        UIImageView *collectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 99, 110)];
        collectView.image = [UIImage imageNamed:@"collect_bg.png"];
        UIImageView *giftView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 3, 92, 92)];
        giftView.image = [UIImage imageNamed:@"3.jpg"];
        [collectView addSubview:giftView];
        [scrollview addSubview:collectView];
    }
    
    [mainView addSubview:mainBgView];
    [mainView addSubview:personalInfoBgView];
    [mainView addSubview:faceBgView];
    [mainView addSubview:faceView];
    [mainView addSubview:nameLabel];
    [mainView addSubview:constellationView];
    [mainView addSubview:constellationLabel];
    [mainView addSubview:birthdayView];
    [mainView addSubview:birthdayLabel];
    [mainView addSubview:firendCollectBgView];
    [mainView addSubview:scrollview];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
