//
//  CustomScrollView.h
//  功能测试集3
//
//  Created by gmtx on 15/11/4.
//  Copyright © 2015年 gmtx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomScrollViewDataSource;

@interface CustomScrollView : UIScrollView
@property(nonatomic, weak)id<CustomScrollViewDataSource> dataSource;

-(void)reloadData;
@end

@protocol CustomScrollViewDataSource <NSObject>

-(NSInteger)numberOfItemsInCustomScrollView:(CustomScrollView *)scrollView;

-(UIView *)customScrollView:(CustomScrollView *)scrollView contentViewAtIndex:(NSInteger)index;

@end
