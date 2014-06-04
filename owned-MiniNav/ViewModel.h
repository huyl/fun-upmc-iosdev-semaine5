//
//  ViewModel.h
//  owned-MiniNav
//
//  Created by Huy on 5/30/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewModel : NSObject

@property (nonatomic, strong) NSString *homeURL;
@property (nonatomic, weak) NSString *currentURL;

@property (nonatomic, readonly) BOOL hasBackHistory;
@property (nonatomic, readonly) BOOL hasForwardHistory;

- (void)openUrl:(NSString *)url;
- (void)replaceWithUrl:(NSString *)url;

/**
 * Returns YES if there is enough back history to go back one
 */
- (BOOL)goBack;

/**
 * Returns YES if there is enough forward history to go forward one
 */
- (BOOL)goForward;

@end
