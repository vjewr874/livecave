//
//  YBWebViewController.m
//  live1v1
//
//  Created by IOS1 on 2019/3/30.
//  Copyright © 2019 IOS1. All rights reserved.
//

#import "YBWebViewController.h"
#import "PhoneLoginVC.h"
#import "ZYTabBarController.h"
#import "AppDelegate.h"

#import <WebKit/WebKit.h>
@interface YBWebViewController ()<WKNavigationDelegate>
@property (nonatomic,strong) WKWebView *WKWebView;
@property (nonatomic,strong) CALayer *progresslayer;

@end

@implementation YBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.WKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-64-statusbarHeight)];
    self.WKWebView.navigationDelegate = self;
    [self.view addSubview:self.WKWebView];
    self.progresslayer = [[CALayer alloc]init];
    self.progresslayer.frame = CGRectMake(0, 0, _window_width*0.1, 2);
    self.progresslayer.backgroundColor = normalColors.CGColor;
    [self.WKWebView.layer addSublayer:self.progresslayer];
    
    [self.WKWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.WKWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

    [self.WKWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urls]]];
     

}
// 观察者
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progresslayer.opacity = 1;
        float floatNum = [[change objectForKey:@"new"] floatValue];
        self.progresslayer.frame = CGRectMake(0, 0, _window_width*floatNum, 2);
        if (floatNum == 1) {
            
            __weak __typeof(self)weakSelf = self;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                weakSelf.progresslayer.opacity = 0;
                
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                weakSelf.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
        
    }else if ([keyPath isEqualToString:@"title"]){//网页title
        if (object == self.WKWebView){
            self.titleL.text = self.WKWebView.title;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}
-(void)dealloc{
    NSLog(@"WKWebView dealloc------------");
    [self.WKWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.WKWebView removeObserver:self forKeyPath:@"title"];

}
- (void)doReturn{
    if (_isGuide) {
        UIApplication *app =[UIApplication sharedApplication];
        AppDelegate *app2 = (AppDelegate *)app.delegate;
        UINavigationController *nav;
        if ([Config getOwnID]) {
            nav = [[UINavigationController alloc]initWithRootViewController:[[ZYTabBarController alloc]init]];
        }else{
            nav = [[UINavigationController alloc]initWithRootViewController:[[PhoneLoginVC alloc]init]];
        }
        app2.window.rootViewController = nav;

    }else{
        if ([_WKWebView canGoBack]) {
            [_WKWebView goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
