#import <UIKit/UIKit.h>
#import <TargetConditionals.h>
#define Padding(p) UIEdgeInsetsMake(p, p, p, p)

@interface UIButton (setRealBackground)
- (void)setRealBackgroundColor:(UIColor *)color;
@end

@interface UIView (findSubview)

- (UIView *)wg_findFirstSubviewWithClass:(Class)theClass;
#if TARGET_OS_TV
- (BOOL)darkMode;
#endif
@end
