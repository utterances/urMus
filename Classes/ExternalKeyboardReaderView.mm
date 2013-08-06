//
//  ExternalKeyboardReaderView.m
//  urMus
//
//  Created by gessl on 5/1/13.
//
//

#import "ExternalKeyboardReaderView.h"
#include "urAPI.h"

@interface ExternalKeyboardReaderView()

- (void)didEnterBackground;
- (void)didBecomeActive;

@end


@implementation ExternalKeyboardReaderView
@synthesize delegate=_delegate, active;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    inputView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [super dealloc];
}

- (void)didEnterBackground {
    if (self.active)
        [self resignFirstResponder];
}

- (void)didBecomeActive {
    if (self.active)
        [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)setActive:(BOOL)value {
    if (active == value) return;
    
    active = value;
    if (active) {
        [self becomeFirstResponder];
    } else {
        [self resignFirstResponder];
    }
}

- (UIView*) inputView {
    return inputView;
}

- (void)setDelegate:(id<ExternalKeyboardEventDelegate>)delegate {
    _delegate = delegate;
    if (!_delegate) return;
}

#pragma mark -
#pragma mark UIKeyInput Protocol Methods

- (BOOL)hasText {
    return NO;
}

- (void)insertText:(NSString *)text {
    
    char ch = [text characterAtIndex:0];
    const char *str = [text UTF8String];
//    NSLog(@"%@",text);
    callAllOnKeyboard(str);
//    NSLog(@"Text input %@",text);
    /*
    static int cycleResponder = 0;
    if (++cycleResponder > 20) {
        // necessary to clear a buffer that accumulates internally
        cycleResponder = 0;
        [self resignFirstResponder];
        [self becomeFirstResponder];
    }
    */
}

- (void)deleteBackward {
    // This space intentionally left blank to complete protocol
    callAllOnKeyboardBackspace();
}

@end
