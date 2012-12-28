//
//  Category.h
//  youli
//
//  Created by apple on 11/21/12.
//
//

#import <Foundation/Foundation.h>

@interface Category : NSObject

@property(nonatomic,retain)NSMutableArray *items;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *code;
@property int index;

- (void)loadData;

@end
