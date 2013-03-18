//
//  BirthdayWebViewController.h
//  youli
//
//  Created by ufida on 13-3-15.
//
//

#import <UIKit/UIKit.h>

@interface BirthdayWebViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic,strong)NSString *webUrl;
@property BOOL isChangeUrl;
@end
