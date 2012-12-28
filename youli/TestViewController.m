//
//  TestViewController.m
//  youli
//
//  Created by ufida on 12-12-21.
//
//

#import "TestViewController.h"
#import "AFJSONRequestOperation.h"
#import "UIImageView+WebCache.h"
#import "BirthdayGiftControllerItem.h"
#import "NMRangeSlider.h"
#import "BaseController.h"

@interface TestViewController ()
{
    @private
    int iGiftDisplayCount;
    int iGiftScrollViewHeight;
    
    __strong BirthdayGiftControllerItem *birthdayGiftControllerItem;
}
@end

@implementation TestViewController
@synthesize giftScrollView;
@synthesize items;
@synthesize av;

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

    [self loadDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadDataSource{
    [av startAnimating];


    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://imgur.com/gallery.json"]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            self.items = [JSON objectForKey:@"data"];
                                                                                            for (int i=iGiftDisplayCount; i<iGiftDisplayCount+10; i++) {                                                                                                NSDictionary *item = [self.items objectAtIndex:i];
                                                                                                
                                                                                                birthdayGiftControllerItem=[[BirthdayGiftControllerItem alloc] init];
                                                                                                
                                                                                                birthdayGiftControllerItem.view.frame=CGRectMake(8, iGiftScrollViewHeight, 308, 270);
                                                                                                
                                                                                                birthdayGiftControllerItem.PhotoURL=[NSString stringWithFormat:@"http://imgur.com/%@%@",[item objectForKey:@"hash"], [item objectForKey:@"ext"]];
                                                                                                
                                                                                                
                                                                                                //                                                                                                NSLog(@"%@",birthdayGiftControllerItem.PhotoURL);
                                                                                                
                                                                                                CGSize size = giftScrollView.frame.size;
                                                                                                [giftScrollView setContentSize:CGSizeMake(size.width, size.height +iGiftScrollViewHeight)];
                                                                                                [self.giftScrollView addSubview:birthdayGiftControllerItem.view];
                                                                                                
                                                                                                iGiftScrollViewHeight+=284;
                                                                                            }
                                                                                            
                                                                                           
                                                                                            [av stopAnimating];
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"error: %@", error);
                                                                                        }];
    [operation start];
    
    iGiftDisplayCount+=10;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = size.height;
    
    if(currentOffset==maximumOffset)
    {
        [self loadDataSource];      //load next group data when scroll the end
    }
}

- (void)viewDidUnload {
    [self setAv:nil];
    [super viewDidUnload];
}

@end
