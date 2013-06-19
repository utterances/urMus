//
//  ExternalKeyboardReaderView.h
//  urMus
//
//  Created by gessl on 5/1/13.
//
//

#import <UIKit/UIKit.h>
@protocol ExternalKeyboardEventDelegate <NSObject>
@end

@interface ExternalKeyboardReaderView : UIView<UIKeyInput> {
    UIView                  *inputView;
    id<ExternalKeyboardEventDelegate>  _delegate;
}

    @property (nonatomic, assign) id<ExternalKeyboardEventDelegate> delegate;
    @property (nonatomic, assign) BOOL active;
@end

