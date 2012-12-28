//
//  TestViewController.h
//  youli
//
//  Created by ufida on 12-12-21.
//
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController<UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *giftScrollView;
@property(nonatomic,retain) NSMutableArray *items;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *av;

@end
