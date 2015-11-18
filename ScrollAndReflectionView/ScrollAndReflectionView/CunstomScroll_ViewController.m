//
//  CunstomScroll_ViewController.m
//  功能测试集3
//
//  Created by gmtx on 15/11/4.
//  Copyright © 2015年 gmtx. All rights reserved.
//

#import "CunstomScroll_ViewController.h"
#import "CustomScrollView.h"
#import "ReflectionView.h"

@interface CunstomScroll_ViewController ()<CustomScrollViewDataSource>

@end

@implementation CunstomScroll_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomScrollView * scrollView = [[CustomScrollView alloc]initWithFrame:CGRectMake(70, 100, 300, 300)];
    [self.view addSubview:scrollView];
    scrollView.dataSource = self;
}

-(NSInteger)numberOfItemsInCustomScrollView:(CustomScrollView *)scrollView
{
    return 6;
}

-(UIView *)customScrollView:(CustomScrollView *)scrollView contentViewAtIndex:(NSInteger)index
{
    return ({
        ReflectionView *view = [[ReflectionView alloc]initWithFrame:CGRectMake(0, 0, 200, 300)];
        view.image = [UIImage imageNamed:[NSString stringWithFormat:@"%li", index + 1]];
        view;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
