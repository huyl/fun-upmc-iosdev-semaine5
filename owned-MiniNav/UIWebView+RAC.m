//
//  UIWebView+RAC.m
//  owned-MiniNav
//
//  Created by Huy on 6/4/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import <objc/runtime.h>
#import "UIWebView+RAC.h"


@interface UIWebView () <UIWebViewDelegate>
@end

@implementation UIWebView (RAC)

- (RACSignal *)rac_didFailLoadSignal {
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) return signal;
    
    signal = [self rac_signalForSelector:@selector(webView:didFailLoadWithError:)
                            fromProtocol:@protocol(UIWebViewDelegate)];
    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Must reset delegate after setting the signals to workaround Cocoa's cache
    self.delegate = self;
    
    return signal;
}

@end
