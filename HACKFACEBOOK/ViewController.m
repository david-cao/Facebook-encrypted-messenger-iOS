//
//  ViewController.m
//  HACKFACEBOOK
//
//  Created by David Cao on 7/23/15.
//  Copyright (c) 2015 David Cao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <WKScriptMessageHandler>

@property (nonatomic) WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]
                                             init];
    WKUserContentController *controller = [[WKUserContentController alloc]
                                           init];
    [controller addScriptMessageHandler:self name:@"MessageSent"];
    configuration.userContentController = controller;
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame
                                  configuration:configuration];
    
    NSURL *url = [NSURL URLWithString:@"http://www.messenger.com/"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [_webView loadRequest:req];
    [self.view addSubview:_webView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    // Log out the message received
    NSLog(@"Received event %@", message.body);
    
    // Then pull something from the device using the message body
    NSString *version = [[UIDevice currentDevice] valueForKey:message.body];
    
    // Execute some JavaScript using the result
    NSString *exec_template = @"set_headline(\"received: %@\");";
    NSString *exec = [NSString stringWithFormat:exec_template, version];
    [_webView evaluateJavaScript:exec completionHandler:nil];
}

@end
