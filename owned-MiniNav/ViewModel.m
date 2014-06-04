//
//  ViewModel.m
//  owned-MiniNav
//
//  Created by Huy on 5/30/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import "ViewModel.h"

@interface ViewModel ()

@property (nonatomic, strong) NSMutableArray *history;
@property (nonatomic) int currentURLIndex;
           
@end

@implementation ViewModel

- (id)init
{
    self = [super init];
    if (self != nil) {
        _history = [[NSMutableArray alloc] init];
        
        // First page should be blank
        _history[0] = @"";
        _currentURLIndex = 0;
        _currentURL = _history[0];
        
        [self setupRAC];
    }
    return self;
}


- (void)setupRAC
{
    RAC(self, hasBackHistory) = [RACObserve(self, currentURLIndex) map:^ id(NSNumber *index) {
        return @(index.intValue > 0);
    }];
    RAC(self, hasForwardHistory) = [RACObserve(self, currentURLIndex) map:^ id(NSNumber *index) {
        return @(index.intValue < [self.history count] - 1);
    }];
}

- (NSString *)homeURL
{
    NSString *urlString = [[[NSUserDefaults standardUserDefaults] stringForKey:@"homeURL"] lowercaseString];
    
    if (!urlString) {
        urlString = kDefaultHomeUrl;
        [self setHomeURL:urlString];
    }
    
    return urlString;
}

- (void)setHomeURL:(NSString *)homeURL
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[homeURL lowercaseString] forKey:@"homeURL"];
    [userDefaults synchronize];
}

- (void)openUrl:(NSString *)url
{
    url = [url lowercaseString];
    
    // If URL is different from current URL
    if (self.currentURLIndex < 0 || [url compare:self.currentURL] != NSOrderedSame) {
        // If not at end of history, then remove forward history
        if (self.currentURLIndex >= 0 && self.currentURLIndex < [self.history count] - 1) {
            [self.history removeObjectsInRange:NSMakeRange(self.currentURLIndex + 1,
                                                           [self.history count] - self.currentURLIndex - 1)];
        }
        
        // Limit size of history
        if ([self.history count] == kMaxHistorySize) {
            [self.history removeObjectAtIndex:0];
            self.currentURLIndex--;
        }
    
        // Add to history
        [self.history addObject:url];
        self.currentURLIndex++;
    }
    
    // Update the current URL
    self.currentURL = self.history[self.currentURLIndex];
}

- (void)replaceWithUrl:(NSString *)url
{
    if (self.currentURLIndex < 0) {
        NSLog(@"Cannot replaceWithUrl when there is no current page.");
        [self openUrl:url];
    } else {
        self.history[self.currentURLIndex] = url;
        self.currentURL = self.history[self.currentURLIndex];
    }
}

- (BOOL)goBack
{
    if (self.currentURLIndex > 0) {
        self.currentURLIndex--;
        self.currentURL = self.history[self.currentURLIndex];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)goForward
{
    if (self.currentURLIndex < [self.history count] - 1) {
        self.currentURLIndex++;
        self.currentURL = self.history[self.currentURLIndex];
        return YES;
    } else {
        return NO;
    }
}

@end
