//
//  BirthdayGiftDetailItem.m
//  youli
//
//  Created by ufida on 12-12-25.
//
//

#import "BirthdayGiftDetailItem.h"

@interface BirthdayGiftDetailItem ()

@end

@implementation BirthdayGiftDetailItem

@synthesize lblTitle;
@synthesize imgPhoto;
@synthesize lblDetail;
@synthesize lblPrice;
@synthesize btnBuy;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
