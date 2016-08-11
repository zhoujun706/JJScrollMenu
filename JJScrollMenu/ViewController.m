//
//  ViewController.m
//  market
//
//  Created by 邹俊 on 2016/8/3.
//  Copyright © 2016年 尚娱网络. All rights reserved.
//

#import "ViewController.h"
#import "JJScrollMenu.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSArray *titles = @[@"头条",@"大数据股票财经",@"精选",@"娱乐视",@"热点点附近会计分录的",@"体育",@"科技",@"汽车"];
    NSArray *titles = @[@"头条",@"大数据股票财经"];
    NSMutableArray *contentControllers = [NSMutableArray array];
    for (NSString *title in titles) {
        TestViewController *controller = [[TestViewController alloc] init];
        controller.title = title;
        [contentControllers addObject:controller];
    }


    JJScrollMenu *menu = [[JJScrollMenu alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    menu.menuTitles = titles;
    menu.contentControllers = contentControllers;
    [self.view addSubview:menu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
