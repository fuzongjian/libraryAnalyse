//
//  ViewController.m
//  libraryAnalyse
//
//  Created by 付宗建 on 2020/5/27.
//  Copyright © 2020 52body. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)NSMutableArray * titleArray;
@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray<NSString *> * controllers;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"三方库";
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleArray = [NSMutableArray arrayWithObjects:@"AFNetworking",@"YYKit", nil];
    self.controllers = [NSMutableArray arrayWithObjects:@"AFNViewController",@"YYKitViewController", nil];
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"click indexPath");
    Class cls = NSClassFromString(self.controllers[indexPath.row]);
    UIViewController * next = [cls new];
    next.title = self.titleArray[indexPath.row];
    [self.navigationController pushViewController:next animated:true];
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


@end
