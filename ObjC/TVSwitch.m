#import "TVSwitch.h"
#import "UIView+Extras.h"

@interface TVSwitch() {
    BOOL _isOn;
}
@property UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation TVSwitch

- (BOOL)isOn {
    return _isOn;
}

- (void)initDefaults {
    self.onTintColor = [UIColor greenColor];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchToggled:)];
    self.tapGestureRecognizer.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypePlayPause]];
    [self addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)switchToggled:(UITapGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self setOn:!self.isOn];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initDefaults];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
    }
    return self;
}

- (void)setOn:(BOOL)on{
    [self setOn:on animated:true];
}

- (NSString *)onTitle {
    return @"ON";
}

- (NSString *)offTitle {
    return @"OFF";
}

- (void)_updateBackgroundForMode {
    if ([self isOn]){
        [self setBackgroundColor:self.onTintColor];
    } else {
        [self setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:0.5]];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    UIView *bgView = [self wg_findFirstSubviewWithClass:objc_getClass("_UIVisualEffectSubview")]; //this class has been around since tvOS 9, so this is definitely safe.
    if (bgView) {
        bgView.backgroundColor = backgroundColor;
    }
}

- (CGSize)intrinsicContentSize {
    CGSize og = [super intrinsicContentSize];
    if (og.width == 0 || og.height == 0){
        return CGSizeMake(150, 87);
    }
    return og;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self _updateBackgroundForMode];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    _isOn = on;
    if (_isOn){
        [self setTitle:[self onTitle] forState:UIControlStateNormal];
    } else {
        [self setTitle:[self offTitle] forState:UIControlStateNormal];
    }
    [self _updateBackgroundForMode];
    //[self sendActionsForControlEvents:[self allControlEvents]];
}

+ (id)newSwitch {
    TVSwitch *new = [TVSwitch buttonWithType:UIButtonTypeSystem];
    [new initDefaults];
    return new;
}

@end
