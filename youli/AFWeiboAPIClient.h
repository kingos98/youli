//
//  AFWeiboAPIClient.h
//  youli
//
//  Created by sjun on 3/6/13.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface AFWeiboAPIClient : AFHTTPClient

+ (AFWeiboAPIClient *)getInstance;

@end
