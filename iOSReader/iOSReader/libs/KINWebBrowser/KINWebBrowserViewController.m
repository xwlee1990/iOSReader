//
//  KINWebBrowserViewController.m
//
//  KINWebBrowser
//
//  Created by David F. Muir V
//  dfmuir@gmail.com
//  Co-Founder & Engineer at Kinwa, Inc.
//  http://www.kinwa.co
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 David Muir
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "KINWebBrowserViewController.h"
#import "IRDataMannager.h"
#import "TUSafariActivity.h"
#import "SVProgressHUD.h"
//#import <ARChromeActivity/ARChromeActivity.h>

static void *KINContext = &KINContext;

@interface KINWebBrowserViewController ()

@property (nonatomic, assign) BOOL previousNavigationControllerToolbarHidden, previousNavigationControllerNavigationBarHidden;
@property (nonatomic, strong) UIBarButtonItem *backButton, *forwardButton, *refreshButton, *stopButton,*liekButton, *actionButton, *fixedSeparator, *flexibleSeparator;
@property (nonatomic, strong) UIPopoverController *actionPopoverController;
@property (nonatomic, strong) NSURL *uiWebViewCurrentURL;

@end

@implementation KINWebBrowserViewController

#pragma mark - Static Initializers

+ (KINWebBrowserViewController *)webBrowser {
    KINWebBrowserViewController *webBrowserViewController = [KINWebBrowserViewController webBrowserWithConfiguration:nil];
    return webBrowserViewController;
}

+ (KINWebBrowserViewController *)webBrowserWithConfiguration:(WKWebViewConfiguration *)configuration {
    KINWebBrowserViewController *webBrowserViewController = [[KINWebBrowserViewController alloc] initWithConfiguration:configuration];
    return webBrowserViewController;
}

+ (UINavigationController *)navigationControllerWithWebBrowser {
    KINWebBrowserViewController *webBrowserViewController = [[KINWebBrowserViewController alloc] initWithConfiguration:nil];
    return [KINWebBrowserViewController navigationControllerWithBrowser:webBrowserViewController];
}

+ (UINavigationController *)navigationControllerWithWebBrowserWithConfiguration:(WKWebViewConfiguration *)configuration {
    KINWebBrowserViewController *webBrowserViewController = [[KINWebBrowserViewController alloc] initWithConfiguration:configuration];
    return [KINWebBrowserViewController navigationControllerWithBrowser:webBrowserViewController];
}

+ (UINavigationController *)navigationControllerWithBrowser:(KINWebBrowserViewController *)webBrowser {
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:webBrowser action:@selector(doneButtonPressed:)];
    [webBrowser.navigationItem setRightBarButtonItem:doneButton];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webBrowser];
    return navigationController;
}

#pragma mark - Initializers

- (id)init {
    return [self initWithConfiguration:nil];
}

- (id)initWithConfiguration:(WKWebViewConfiguration *)configuration {
    self = [super init];
    if(self) {
        
        if(configuration)
        {
            self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        }
        else
        {
            self.wkWebView = [[WKWebView alloc] init];
        }
    
        
        self.actionButtonHidden = NO;
        self.showsURLInNavigationBar = NO;
        self.showsPageTitleInNavigationBar = YES;
        
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.previousNavigationControllerToolbarHidden = self.navigationController.toolbarHidden;
    self.previousNavigationControllerNavigationBarHidden = self.navigationController.navigationBarHidden;
    
    [self.wkWebView setFrame:self.view.bounds];
    [self.wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.wkWebView setNavigationDelegate:self];
    [self.wkWebView setMultipleTouchEnabled:YES];
    [self.wkWebView setAutoresizesSubviews:YES];
    [self.wkWebView.scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:self.wkWebView];
    [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:KINContext];
    

    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
    [self.progressView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height-self.progressView.frame.size.height, self.view.frame.size.width, self.progressView.frame.size.height)];
    [self.progressView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    [self.navigationController.navigationBar addSubview:self.progressView];
    
    [self updateToolbarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:self.previousNavigationControllerNavigationBarHidden animated:animated];
    
    [self.navigationController setToolbarHidden:self.previousNavigationControllerToolbarHidden animated:animated];
    
    [self.progressView removeFromSuperview];
}

#pragma mark - Public Interface

- (void)loadURL:(NSURL *)URL {
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)loadURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self.progressView setTintColor:tintColor];
    [self.navigationController.navigationBar setTintColor:tintColor];
    [self.navigationController.toolbar setTintColor:tintColor];
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    _barTintColor = barTintColor;
    [self.navigationController.navigationBar setBarTintColor:barTintColor];
    [self.navigationController.toolbar setBarTintColor:barTintColor];
}

- (void)setActionButtonHidden:(BOOL)actionButtonHidden {
    _actionButtonHidden = actionButtonHidden;
    [self updateToolbarState];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

    [self updateToolbarState];
    if([self.delegate respondsToSelector:@selector(webBrowser:didStartLoadingURL:)]) {
        [self.delegate webBrowser:self didStartLoadingURL:self.wkWebView.URL];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self updateToolbarState];
    if([self.delegate respondsToSelector:@selector(webBrowser:didFinishLoadingURL:)]) {
        [self.delegate webBrowser:self didFinishLoadingURL:self.wkWebView.URL];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    [self updateToolbarState];
    if([self.delegate respondsToSelector:@selector(webBrowser:didFailToLoadURL:error:)]) {
        [self.delegate webBrowser:self didFailToLoadURL:self.wkWebView.URL error:error];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    [self updateToolbarState];
    if([self.delegate respondsToSelector:@selector(webBrowser:didFailToLoadURL:error:)]) {
        [self.delegate webBrowser:self didFailToLoadURL:self.wkWebView.URL error:error];
    }
    
}

#pragma mark - Toolbar State

- (void)updateToolbarState {
    
    BOOL canGoBack = self.wkWebView.canGoBack;
    BOOL canGoForward = self.wkWebView.canGoForward;
    
    [self.backButton setEnabled:canGoBack];
    [self.forwardButton setEnabled:canGoForward];
    
    if(!self.backButton) {
        [self setupToolbarItems];
    }
    
    NSArray *barButtonItems;
    if(self.wkWebView.loading) {
        barButtonItems = @[self.backButton, self.fixedSeparator, self.forwardButton, self.fixedSeparator, self.stopButton, self.flexibleSeparator];
        
        if(self.showsURLInNavigationBar) {
            NSString *URLString;
            URLString = [self.wkWebView.URL absoluteString];
            URLString = [URLString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
            URLString = [URLString stringByReplacingOccurrencesOfString:@"https://" withString:@""];
            URLString = [URLString substringToIndex:[URLString length]-1];
            self.navigationItem.title = URLString;
        }
    }
    else {
        barButtonItems = @[self.backButton, self.fixedSeparator, self.forwardButton, self.fixedSeparator, self.refreshButton, self.flexibleSeparator];
        
        if(self.showsPageTitleInNavigationBar) {
            self.navigationItem.title = self.wkWebView.title;
        }
    }
    
    if(!self.actionButtonHidden) {
        NSMutableArray *mutableBarButtonItems = [NSMutableArray arrayWithArray:barButtonItems];
        if(self.showLikeButton){
         [mutableBarButtonItems addObject:self.liekButton];
         [mutableBarButtonItems addObject:self.flexibleSeparator];
        }
        [mutableBarButtonItems addObject:self.actionButton];
        barButtonItems = [NSArray arrayWithArray:mutableBarButtonItems];
    }
    
    [self setToolbarItems:barButtonItems animated:YES];
}

- (void)setupToolbarItems {
    self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed:)];
    self.stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopButtonPressed:)];
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backbutton"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forwardbutton"] style:UIBarButtonItemStylePlain target:self action:@selector(forwardButtonPressed:)];
     self.liekButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(likeButtonPressed:)];
    self.actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed:)];
    self.fixedSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.fixedSeparator.width = 50.0f;
    self.flexibleSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

#pragma mark - Done Button Action

- (void)doneButtonPressed:(id)sender {
    [self dismissAnimated:YES];
}

#pragma mark - UIBarButtonItem Target Action Methods

- (void)backButtonPressed:(id)sender {
    
    [self.wkWebView goBack];
    [self updateToolbarState];
}

- (void)forwardButtonPressed:(id)sender {
    [self.wkWebView goForward];
    [self updateToolbarState];
}

- (void)refreshButtonPressed:(id)sender {
        [self.wkWebView stopLoading];
        [self.wkWebView reload];
}

- (void)stopButtonPressed:(id)sender {
        [self.wkWebView stopLoading];
}
- (void)likeButtonPressed:(id)sender {
   
    [[IRDataMannager sharedManager] saveUserFavouriteArticleTitle:self.wkWebView.title ArticleUrl:self.wkWebView.URL.absoluteString WithSuccess:^(NSString *successStr,IRArticleModel *article) {
        [SVProgressHUD showSuccessWithStatus:successStr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IRAddFavouriteNoti" object:article];
        });
    } failure:^(NSString *errorStr) {
        [SVProgressHUD showErrorWithStatus:errorStr];
    }];
}


- (void)actionButtonPressed:(id)sender {
    NSURL *URLForActivityItem;
    if(self.wkWebView) {
        URLForActivityItem = self.wkWebView.URL;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        TUSafariActivity *safariActivity = [[TUSafariActivity alloc] init];
       // ARChromeActivity *chromeActivity = [[ARChromeActivity alloc] init];
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[URLForActivityItem] applicationActivities:@[safariActivity]];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if(self.actionPopoverController) {
                [self.actionPopoverController dismissPopoverAnimated:YES];
            }
            self.actionPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
            [self.actionPopoverController presentPopoverFromBarButtonItem:self.actionButton permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
        }
        else {
            [self presentViewController:controller animated:YES completion:NULL];
        }
    });
}


#pragma mark - Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - Dismiss

- (void)dismissAnimated:(BOOL)animated {
    [self.navigationController dismissViewControllerAnimated:animated completion:nil];
}

#pragma mark - Interface Orientation

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - Dealloc

- (void)dealloc {
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
    if ([self isViewLoaded]) {
        [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
}


@end

@implementation UINavigationController(KINWebBrowser)

- (KINWebBrowserViewController *)rootWebBrowser {
    UIViewController *rootViewController = [self.viewControllers objectAtIndex:0];
    return (KINWebBrowserViewController *)rootViewController;
}

@end
