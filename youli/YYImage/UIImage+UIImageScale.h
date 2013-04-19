//
//  UIImage+UIImageScale.h
//  youli
//
//  Created by ufida on 13-4-11.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageScale)
-(UIImage*)getSubImage:(CGRect)rect;
-(UIImage*)scaleToSize:(CGSize)size;
@end
