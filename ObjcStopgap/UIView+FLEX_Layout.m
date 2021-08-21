#import "UIView+FLEX_Layout.h"

@implementation UIView (FLEX_Layout)

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
