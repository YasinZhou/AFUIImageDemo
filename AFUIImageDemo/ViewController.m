//
//  ViewController.m
//  AFUIImageDemo
//
//  Created by Yasin on 16/2/16.
//  Copyright © 2016年 Yasin. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFImageDownloader.h"
#import <objc/runtime.h>
#import "UIActivityIndicatorView+AFNetworking.h"

#define WEAKSELF typeof(self) __weak weakSelf = self; //weak self for block
@interface ViewController ()
{
    NSString *urlStr;
    NSURL *url;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    urlStr = @"http://d.hiphotos.baidu.com/image/pic/item/71cf3bc79f3df8dcd227017cc911728b461028c0.jpg";
    url = [NSURL URLWithString:urlStr];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.URLCache = [NSURLCache sharedURLCache];
    [config setHTTPAdditionalHeaders:@{@"Accept":@"image/*"}];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    WEAKSELF
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [weakSelf downImageAgain];
    }];
    [task resume];
    
    
//    [imageView setImageWithURL:url];
//    
//    //AFNetWorking下给UIImageView添加旋转小转轮，有兴趣的可以看下
//    AFImageDownloadReceipt *af_activeImageDownloadReceipt = objc_getAssociatedObject(self.imageView, @selector(af_activeImageDownloadReceipt));
//    NSURLSessionTask *afTask = af_activeImageDownloadReceipt.task;
//    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
//    [self.imageView addSubview:activityView];
//    activityView.center = CGPointMake(self.imageView.frame.size.width/2, self.imageView.frame.size.height/2);
//    [activityView setAnimatingWithStateOfTask:afTask];

   
    
}
- (void)downImageAgain{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];     //使用default配置
    [config setHTTPAdditionalHeaders:@{@"Accept":@"image/*"}];//设置网络数据格式
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    WEAKSELF
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) { //使用’获取数据(NSURLSessionDataTask)‘的方式发起请求
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imageView.image = image;
        });
    }];
    [task resume];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
