//
//  SYZRootViewController.m
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import "SYZRootViewController.h"
#import <SYZUIBasekit/SYZUIBasekit.h>
#import "SYZMediator+SYZAModule.h"
#import "SYZMediator+SYZBModule.h"
#import "SYZMediator+SYZCModule.h"
#import "SYZDetailViewController.h"


@interface SYZRootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *list;
@end

@implementation SYZRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SYZGlobalMediator.appSchema = @"AAA";
    self.title = @"首页";
     self.list = @[@"push到A页面",@"跳转的B页面",@"自动跳转到B页面",@"使用路径跳转",@"link打开B页面",@"打开url"];
    [self.view addSubview:self.tableView];
    
    /** 拦截a */
    [SYZGlobalMediator registerTarget:@"a" action:@"detail" handler:^id(SYZRouterContext* context) {
        NSString* resId = context.customParams[@"id"];
        SYZDetailViewController* vc = [[SYZDetailViewController alloc] initWithNibName:nil bundle:nil];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.title = [NSString stringWithFormat:@"被拦截了，id为: %@",resId];
        return vc;
    }];
    
    /** 拦截b */
//    [SYZGlobalMediator registerTarget:@"b" action:@"detail" handler:^id(SYZRouterContext* context) {
//        NSString* resId = context.customParams[@"someId"];
//        SYZDetailViewController* vc = [[SYZDetailViewController alloc] initWithNibName:nil bundle:nil];
//        vc.view.backgroundColor = [UIColor whiteColor];
//        vc.title = [NSString stringWithFormat:@"被拦截了，id为: %@",resId];
//        return vc;
//    }];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if ([self.list syz_isValidIndex:indexPath.row]) {
        cell.textLabel.text = self.list[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.list syz_isValidIndex:indexPath.row]) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[SYZMediator sharedMediator] a_detailPageWithId:@"123"] animated:YES];
            //取消拦截
            [SYZGlobalMediator unregisterTarget:@"a"];
            [SYZGlobalMediator unregisterTarget:@"a" action:@"detail"];
        }else if (indexPath.row == 1){
            UIViewController* bVC = [SYZGlobalMediator b_detailPage:@"bbb" callback:^(NSString *word) {
                NSLog(@"word: %@",word);
            }];
            if (bVC) {
                [self presentViewController:bVC animated:YES completion:nil];
            }
            
        }else if (indexPath.row == 2){
            SYZRouterPackage* package = [SYZGlobalMediator b_detailPackage:@"bb" callback:^(NSString *word) {
                NSLog(@"auto word: %@",word);
            }];
            [SYZGlobalMediator openPackage:package];
        }else if (indexPath.row == 3){
            [SYZGlobalMediator openInnerURLString:@"c/main"];
//            [SYZGlobalMediator main_open];
        }else if (indexPath.row == 4){
             [SYZGlobalMediator openURLString:[SYZGlobalMediator b_detailLink:@"哈哈哈"]];
        }else if (indexPath.row == 5){
            /** 打开网页 */
            [SYZGlobalMediator openURLString:@"https://www.baidu.com"];
        }
    }
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50.;
    }
    return _tableView;
}

@end
