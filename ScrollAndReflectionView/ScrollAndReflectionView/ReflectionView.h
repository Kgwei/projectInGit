//
//  ReflectionView.h
//  功能测试集3
//
//  Created by gmtx on 15/10/30.
//  Copyright © 2015年 gmtx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReflectionView : UIView
//偏移量和间隔决定投影大小
//投影偏移量，>0，默认：view的height * 0.2
@property(nonatomic, assign)CGFloat projectionOffset;
//间隔，默认0
@property(nonatomic, assign)CGFloat spacing;
//改变图片显示
@property(nonatomic, strong)UIImage *image;
//通过改变contentView来改变显示
@property(nonatomic, strong)UIView *contentView;
@end
