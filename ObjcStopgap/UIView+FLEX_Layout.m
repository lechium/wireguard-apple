#import "UIView+FLEX_Layout.h"

@implementation UIView (FLEX_Layout)

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

- (UIView *)flex_findFirstSubviewWithClass:(Class)theClass {
    if ([self isMemberOfClass:theClass]) {
        return self;
    }
    
    for (UIView *v in self.subviews) {
        UIView *theView = [v flex_findFirstSubviewWithClass:theClass];
        if (theView != nil) {
            return theView;
        }
    }
    return nil;
}

@end
