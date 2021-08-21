#import <UIKit/UIKit.h>

#define Padding(p) UIEdgeInsetsMake(p, p, p, p)

@interface UIView (FLEX_Layout)

- (UIView *)flex_findFirstSubviewWithClass:(Class)theClass;

@end