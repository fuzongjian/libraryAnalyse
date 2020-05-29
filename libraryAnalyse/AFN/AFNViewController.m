//
//  AFNViewController.m
//  libraryAnalyse
//
//  Created by deltalpha on 2020/5/28.
//  Copyright © 2020 52body. All rights reserved.
//

#import "AFNViewController.h"
#import "AFNetworking.h"
typedef void(^success) (id data);
typedef void(^fail) (id data);
@interface AFNViewController ()

@end

@implementation AFNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
- (void)genaralPost:(NSString *)path body:(NSDictionary *)body success:(success)success error:(fail)fail{
    AFHTTPSessionManager * manager = [AFNViewController sharedManager];
    [manager POST:path parameters:body progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
    
    [manager POST:path parameters:body constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)genaraGet:(NSString *)path body:(NSDictionary *)body success:(success)success error:(fail)fail
{
    AFHTTPSessionManager * manager = [AFNViewController sharedManager];
    [manager GET:path parameters:body progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
// DELETE、PUT方法雷同
+ (id)sharedManager
{
    static AFHTTPSessionManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        // 请求参数以json格式
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 此处可以设置一些请求头如token、userid......
        // manager.requestSerializer setValue:<#(nullable NSString *)#> forHTTPHeaderField:<#(nonnull NSString *)#>
        // 返回参数以json格式
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    });
    return manager;
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
