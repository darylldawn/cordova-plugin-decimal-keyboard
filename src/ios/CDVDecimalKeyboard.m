#import "CDVDecimalKeyboard.h"

@implementation CDVDecimalKeyboard


UIWebView* wv;
UIView* ui;

CGRect cgButton;
BOOL isDecimalKeyRequired=YES;
UIButton *decimalButton;

CGRect cgButtonm;
BOOL isMinusKeyRequired=YES;
UIButton *minusButton;

BOOL isAppInBackground=NO;

- (void)pluginInitialize {
    wv = self.webView;
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWillAppear:)
                                                 name: UIKeyboardWillShowNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWillDisappear:)
                                                 name: UIKeyboardWillHideNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    
}
- (void) appWillResignActive: (NSNotification*) n{
    isAppInBackground = YES;
    [self removeDecimalButton];
    [self removeMinusButton];
}

- (void) appDidBecomeActive: (NSNotification*) n{
    if(isAppInBackground==YES){
        isAppInBackground = NO;
        [self processKeyboardShownEvent];
        
    }
}


- (void) keyboardWillDisappear: (NSNotification*) n{
    [self removeDecimalButton];
    [self removeMinusButton];
}
-(void) setDecimalChar{
    NSString* decimalChar = [wv stringByEvaluatingJavaScriptFromString:@"DecimalKeyboard.getDecimalChar();"];
    [decimalButton setTitle:decimalChar forState:UIControlStateNormal];
}

-(void) setMinusChar{
    NSString* minusChar = [wv stringByEvaluatingJavaScriptFromString:@"DecimalKeyboard.getMinusChar();"];
    [minusButton setTitle:minusChar forState:UIControlStateNormal];
}

- (void) addDecimalButton{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return ; /* Device is iPad and this code works only in iPhone*/
    }
    decimalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setDecimalChar];
    [decimalButton setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
    decimalButton.titleLabel.font = [UIFont systemFontOfSize:40.0];
    [decimalButton addTarget:self action:@selector(buttonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
    [decimalButton addTarget:self action:@selector(buttonTapped:)
            forControlEvents:UIControlEventTouchDown];
    [decimalButton addTarget:self action:@selector(buttonPressCancel:)
            forControlEvents:UIControlEventTouchUpOutside];
    
    
    decimalButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [decimalButton setTitleEdgeInsets:UIEdgeInsetsMake(-20.0f, 0.0f, 0.0f, 0.0f)];
    [decimalButton setBackgroundColor: [UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1.0]];
    
    // locate keyboard view
    UIWindow* tempWindow = nil;
    NSArray* openWindows = [[UIApplication sharedApplication] windows];
    
    for(UIWindow* object in openWindows){
        if([[object description] hasPrefix:@"<UIRemoteKeyboardWindow"] == YES){
            tempWindow = object;
        }
    }
    
    if(tempWindow ==nil){
        //for ios 8
        for(UIWindow* object in openWindows){
            if([[object description] hasPrefix:@"<UITextEffectsWindow"] == YES){
                tempWindow = object;
            }
        }
    }

    
    UIView* keyboard;
    for(int i=0; i<[tempWindow.subviews count]; i++) {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        [self listSubviewsOfView: keyboard];
        decimalButton.frame = cgButton;
        [ui addSubview:decimalButton];
    }
}

- (void) addMinusButton{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return ; /* Device is iPad and this code works only in iPhone*/
    }
    minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setMinusChar];
    [minusButton setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
    minusButton.titleLabel.font = [UIFont systemFontOfSize:40.0];
    [minusButton addTarget:self action:@selector(buttonPressedm:)
            forControlEvents:UIControlEventTouchUpInside];
    [minusButton addTarget:self action:@selector(buttonTappedm:)
            forControlEvents:UIControlEventTouchDown];
    [minusButton addTarget:self action:@selector(buttonPressCancelm:)
            forControlEvents:UIControlEventTouchUpOutside];
    
    
    minusButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [minusButton setTitleEdgeInsets:UIEdgeInsetsMake(-20.0f, 0.0f, 0.0f, 0.0f)];
    [minusButton setBackgroundColor: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
    
    // locate keyboard view
    UIWindow* tempWindow = nil;
    NSArray* openWindows = [[UIApplication sharedApplication] windows];
    
    for(UIWindow* object in openWindows){
        if([[object description] hasPrefix:@"<UIRemoteKeyboardWindow"] == YES){
            tempWindow = object;
        }
    }
    
    if(tempWindow ==nil){
        //for ios 8
        for(UIWindow* object in openWindows){
            if([[object description] hasPrefix:@"<UITextEffectsWindow"] == YES){
                tempWindow = object;
            }
        }
    }

    
    UIView* keyboard;
    for(int i=0; i<[tempWindow.subviews count]; i++) {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        [self listSubviewsOfViewm: keyboard];
        minusButton.frame = cgButtonm;
        [ui addSubview:minusButton];
    }
}

- (void) removeDecimalButton{
    [decimalButton removeFromSuperview];
    decimalButton=nil;
    stopSearching=NO;
    
}

- (void) removeMinusButton{
    [minusButton removeFromSuperview];
    minusButton=nil;
    stopSearchingm=NO;
    
}

- (void) deleteDecimalButton{
    [decimalButton removeFromSuperview];
    decimalButton=nil;
    stopSearching=NO;
}

- (void) deleteMinusButton{
    [minusButton removeFromSuperview];
    minusButton=nil;
    stopSearchingm=NO;
}

BOOL isDifferentKeyboardShown=NO;

- (void) keyboardWillAppear: (NSNotification*) n{
    NSDictionary* info = [n userInfo];
    NSNumber* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    double dValue = [value doubleValue];
    
    if(dValue <= 0.0){
        [self removeDecimalButton];
        [self removeMinusButton];
        return;
    }
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * dValue);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [self processKeyboardShownEvent];
    });
    
    
}
- (void) processKeyboardShownEvent{
    BOOL isDecimalKeyRequired=[self isTextAndDecimal];
    BOOL isMinusKeyRequired=YES;
    
   // create custom button
    if(decimalButton == nil){
        if(isDecimalKeyRequired){
            [self addDecimalButton];
        }
    }else{
        if(isDecimalKeyRequired){
            decimalButton.hidden=NO;
            [self setDecimalChar];
        }else{
            [self removeDecimalButton];
        }
    }

        // create custom button
    if(minusButton == nil){
        if(isMinusKeyRequired){
            [self addMinusButton];
        }
    }else{
        if(isMinusKeyRequired){
            minusButton.hidden=NO;
            [self setMinusChar];
        }else{
            [self removeMinusButton];
        }
    }
}

- (void)buttonPressed:(UIButton *)button {
    [decimalButton setBackgroundColor: [UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1.0]];
    [wv stringByEvaluatingJavaScriptFromString:@"DecimalKeyboard.addDecimal();"];
}

- (void)buttonPressedm:(UIButton *)button {
    [minusButton setBackgroundColor: [UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1.0]];
    [wv stringByEvaluatingJavaScriptFromString:@"DecimalKeyboard.addMinus();"];
}

- (void)buttonTapped:(UIButton *)button {
    [decimalButton setBackgroundColor: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
}

- (void)buttonTappedm:(UIButton *)button {
    [minusButton setBackgroundColor: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
}

- (void)buttonPressCancel:(UIButton *)button{
    [decimalButton setBackgroundColor: [UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1.0]];
}

- (void)buttonPressCancelm:(UIButton *)button{
    [minusButton setBackgroundColor: [UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1.0]];
}

-(BOOL)isTextAndDecimal{
    BOOL bln = YES;
    NSString *isText = [wv stringByEvaluatingJavaScriptFromString:@"DecimalKeyboard.getActiveElementType();"];
    if([isText isEqual:@"text"]){
        NSString *isDecimal = [wv stringByEvaluatingJavaScriptFromString:@"DecimalKeyboard.isDecimal();"];
        if(![isDecimal isEqual:@"true"]){
            bln=NO;
        }
    }else{
        bln=NO;
    }
    return bln;
}
BOOL stopSearching=NO;
- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE
    
    for (UIView *subview in subviews) {
        if(stopSearching==YES){
            break;
        }
        if([[subview description] hasPrefix:@"<UIKBKeyplaneView"] == YES){
            ui = subview;
            stopSearching = YES;
            CGFloat height= 0.0;
            CGFloat width=0.0;
            CGFloat x = 0;
            CGFloat y =ui.frame.size.height;
            for(UIView *nView in ui.subviews){
                
                if([[nView description] hasPrefix:@"<UIKBKeyView"] == YES){
                    //all keys of same size;
                    height = nView.frame.size.height;
                    width = (nView.frame.size.width-1.5)/2;
                    y = y-(height-1);
                    cgButton = CGRectMake(x, y, width, height);
                    break;
                    
                }
                
            }
        }
        
        [self listSubviewsOfView:subview];
    }
}
BOOL stopSearchingm=NO;
- (void)listSubviewsOfViewm:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE
    
    for (UIView *subview in subviews) {
        if(stopSearchingm==YES){
            break;
        }
        if([[subview description] hasPrefix:@"<UIKBKeyplaneView"] == YES){
            ui = subview;
            stopSearchingm = YES;
            CGFloat height= 0.0;
            CGFloat width=0.0;
            CGFloat x = 0;
            CGFloat y =ui.frame.size.height;
            for(UIView *nView in ui.subviews){
                
                if([[nView description] hasPrefix:@"<UIKBKeyView"] == YES){
                    //all keys of same size;
                    height = nView.frame.size.height;
                    width = (nView.frame.size.width-1.5)/2;
                    x = width;
                    y = y-(height-1);
                    cgButtonm = CGRectMake(x, y, width, height);
                    break;
                    
                }
                
            }
        }
        
        [self listSubviewsOfViewm:subview];
    }
}

@end
