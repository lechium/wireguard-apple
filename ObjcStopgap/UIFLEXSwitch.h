
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIFLEXSwitch : UIButton <NSCoding>
@property(nullable, nonatomic, strong) UIColor *onTintColor;
@property(nullable, nonatomic, strong) UIColor *thumbTintColor; //here for protocol adherence - ignored
@property(nullable, nonatomic, strong) UIImage *onImage; //ditto above
@property(nullable, nonatomic, strong) UIImage *offImage; //ditto
@property(nonatomic,getter=isOn) BOOL on;
- (instancetype _Nonnull )initWithFrame:(CGRect)frame;      // This class enforces a size appropriate for the control, and so the frame size is ignored.
- (nullable instancetype)initWithCoder:(NSCoder *_Nonnull)coder;
- (void)setOn:(BOOL)on animated:(BOOL)animated; // does not send action
+ (id _Nonnull )newSwitch;
@end
