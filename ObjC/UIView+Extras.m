#import "UIView+Extras.h"
#import <objc/runtime.h>

@implementation UIButton (setRealBackground)

- (void)setRealBackgroundColor:(UIColor *)backgroundColor {
    UIView *bgView = [self wg_findFirstSubviewWithClass:objc_getClass("_UIVisualEffectSubview")]; //this class has been around since tvOS 9, so this is definitely safe.
    if (bgView) {
        bgView.backgroundColor = backgroundColor;
    }
}

@end

@implementation UIView (findSubview)

#if TARGET_OS_TV
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"
#pragma clang diagnostic ignored "-Wunguarded-availability"
- (BOOL)darkMode {
    
    if ([[self traitCollection] respondsToSelector:@selector(userInterfaceStyle)]){
        return ([[self traitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark);
    } else {
        return false;
    }
    return false;
}
#endif

- (UIView *)wg_findFirstSubviewWithClass:(Class)theClass {
    if ([self isMemberOfClass:theClass]) {
        return self;
    }
    
    for (UIView *v in self.subviews) {
        UIView *theView = [v wg_findFirstSubviewWithClass:theClass];
        if (theView != nil) {
            return theView;
        }
    }
    return nil;
}

@end
