//
//  ViewController.m
//  owned-MiniNav
//
//  Created by Huy on 5/29/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

// NOTE: We don't create a separate view because we need the viewController's topLayoutGuide to properly
// position the toolbar (and thus the webView)

#import "ViewController.h"
#import "ViewModel.h"
#import "UIWebView+RAC.h"
#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, strong) ViewModel *viewModel;

@property (nonatomic, weak) UIToolbar *toolbar;
@property (nonatomic, weak) UIBarButtonItem *backButton;
@property (nonatomic, weak) UIBarButtonItem *forwardButton;
@property (nonatomic, weak) UIBarButtonItem *homeButton;
@property (nonatomic, weak) UIBarButtonItem *openButton;
@property (nonatomic, weak) UIBarButtonItem *configButton;

@property (nonatomic, weak) UIWebView *webView;
@end

@implementation ViewController

+ (UIImage *)imageNamed:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [UIImage imageWithCGImage:[image CGImage] scale:(image.scale * 50.0/24.0) orientation:image.imageOrientation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.viewModel = [[ViewModel alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fond-1024x1024.jpg"]];
    
    /// Toolbar and buttons
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc]
                                   initWithImage:[ViewController imageNamed:@"line__0000s_0032_home.png"]
                                   style:UIBarButtonItemStylePlain target:nil action:nil];
    _homeButton = homeButton;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[ViewController imageNamed:@"line__0000s_0070_prev.png"]
                                   style:UIBarButtonItemStylePlain target:nil action:nil];
    _backButton = backButton;
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc]
                                      initWithImage:[ViewController imageNamed:@"line__0000s_0071_next.png"]
                                      style:UIBarButtonItemStylePlain target:nil action:nil];
    _forwardButton = forwardButton;
    UIBarButtonItem *openButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Ouvrir"
                                   style:UIBarButtonItemStyleBordered target:nil action:nil];
    _openButton = openButton;
    UIBarButtonItem *configButton = [[UIBarButtonItem alloc]
                                     initWithImage:[ViewController imageNamed:@"line__0000s_0091_config.png"]
                                     style:UIBarButtonItemStylePlain target:nil action:nil];
    _configButton = configButton;
    UIBarButtonItem *flexibleSpace =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fixedSpace =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 10;
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    _toolbar = toolbar;
    self.toolbar.items = @[self.backButton, fixedSpace, self.forwardButton, fixedSpace, self.homeButton,
                           flexibleSpace,
                           self.openButton,
                           flexibleSpace,
                           self.configButton];
    [self.view addSubview:self.toolbar];
    
    /// WebView
    
    UIWebView *webView = [[UIWebView alloc] init];
    _webView = webView;
    [self.view addSubview:self.webView];
    
    /// Set up the rest
    
    [self setupConstraints];
    [self setupRAC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Constraints

- (void)setupConstraints
{
    UIView *superview = self.view;

    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        // Making use of the topLayoutGuide in iOS7+ ensures that room is made for the toolbar,
        // regardless of whether the controller's view's frame is full screen or not
        if ([self respondsToSelector:@selector(topLayoutGuide)]) {
            UIView *topLayoutGuide = (id)self.topLayoutGuide;
            make.top.equalTo(topLayoutGuide.mas_bottom);
        } else {
            make.top.equalTo(superview);
        }
        
        make.left.equalTo(superview);
        make.right.equalTo(superview);
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolbar.mas_bottom);
        make.left.equalTo(superview);
        make.right.equalTo(superview);
        make.bottom.equalTo(superview);
    }];
}

#pragma mark - RAC

- (void)setupRAC
{
    @weakify(self);
    
    // React to change in viewModel's current URL
    [RACObserve(self, viewModel.currentURL) subscribeNext:^(NSString *url) {
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]]];
    }];
    
    // React to WebView's load failures
    [self.webView.rac_didFailLoadSignal subscribeNext:^(RACTuple *tuple) {
        NSError *error = (NSError *)tuple[1];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erreur"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *buttonIndex) {
            // Load Error page
            NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"error" ofType:@"html"]];
            [self.viewModel replaceWithUrl:[url absoluteString]];
        }];
        [alertView show];
    }];
    
    // React to click of Navigation buttons
    self.homeButton.rac_action = [[RACSignal create:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.viewModel openUrl:self.viewModel.homeURL];
        [subscriber sendCompleted];
    }] action];
    self.backButton.rac_action = [[RACSignal create:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.viewModel goBack];
        [subscriber sendCompleted];
    }] actionEnabledIf:RACObserve(self, viewModel.hasBackHistory)];
    self.forwardButton.rac_action = [[RACSignal create:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.viewModel goForward];
        [subscriber sendCompleted];
    }] actionEnabledIf:RACObserve(self, viewModel.hasForwardHistory)];
    
    // React to click of Config button
    self.configButton.rac_action = [[RACSignal create:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        // Prompt the user for the home URL
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"URL Maison"
                                                                    message:@"Entrez l'URL par défaut"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Annuler" otherButtonTitles:@"OK", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        // Put the old setting in the textfield
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.text = self.viewModel.homeURL;
        
        [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *buttonIndex) {
            // User clicked OK
            if (buttonIndex.intValue == 1) {
                NSString *url = [[alertView textFieldAtIndex:0].text
                                    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                // FIXME: doesn't handle other types of URLs
                if (![url hasPrefix:@"http"]) {
                    url = [NSString stringWithFormat:@"http://%@", url];
                }
                self.viewModel.homeURL = url;
            }
        }];
        [alertView show];
        [subscriber sendCompleted];
    }] action];
    
    // React to click of Open button
    self.openButton.rac_action = [[RACSignal create:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        // Prompt the user for the home URL
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"URL"
                                                                    message:@"Entrez l'URL à charger"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Annuler" otherButtonTitles:@"OK", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        [alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *buttonIndex) {
            // User clicked OK
            if (buttonIndex.intValue == 1) {
                NSString *url = [[alertView textFieldAtIndex:0].text
                                    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                // FIXME: doesn't handle other types of URLs
                if (![url hasPrefix:@"http"]) {
                    url = [NSString stringWithFormat:@"http://%@", url];
                }
                
                // Open URL
                [self.viewModel openUrl:url];
            }
        }];
        [alertView show];
        [subscriber sendCompleted];
    }] action];
    
}

@end
