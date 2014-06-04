//
//  UIWebView+RAC.h
//  owned-MiniNav
//
//  Created by Huy on 6/4/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

@interface UIWebView (RAC)

- (RACSignal *)rac_didFailLoadSignal;

@end
