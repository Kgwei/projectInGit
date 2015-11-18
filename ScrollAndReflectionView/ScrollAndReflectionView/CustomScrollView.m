//
//  CustomScrollView.m
//  功能测试集3
//
//  Created by gmtx on 15/11/4.
//  Copyright © 2015年 gmtx. All rights reserved.
//

#import "CustomScrollView.h"

#define ObliqueWidth 50                 //侧边宽
#define RotationAngle (M_PI / 6)        //侧边旋转角度
#define ObliqueScale 0.92               //侧边缩放

@interface CustomScrollView()<UIScrollViewDelegate>
@property(nonatomic, strong)NSMutableArray *contentViewArray;
@end

@implementation CustomScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.decelerationRate = 0.98;
        self.bounces = NO;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.contentViewArray = [NSMutableArray array];
    }
    return self;
}

-(void)setDataSource:(id<CustomScrollViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setUpContentViewTransform];
}

-(void)setUpContentViewTransform
{
    CGFloat centerX = self.contentOffset.x + self.frame.size.width * 0.5;
    CGFloat width = self.frame.size.width - ObliqueWidth * 2;
    [self.contentViewArray enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat distance = obj.center.x - centerX;
        //旋转角度
        CGFloat angle = RotationAngle / width * ABS(distance);
        //缩放
        CGFloat scale = 1 - (1 - ObliqueScale) / width * ABS(distance);
        CGFloat perspective = 0.001;
        //设置两个侧边的锚点--减小中间图和侧边的距离
        CGPoint anchorPoint = CGPointMake(0.5, 0.5);
        if (distance > 0.0) {
            perspective = -perspective;
            anchorPoint.x = 0.51;
        }
        else if (distance < 0.0)
        {
            anchorPoint.x = 0.49;
        }
        obj.layer.transform = [self transform3DWithRotation:angle scale:scale perspective:perspective];
        obj.layer.anchorPoint = anchorPoint;
    }];
}

- (CATransform3D)transform3DWithRotation:(CGFloat)angle
                                   scale:(CGFloat)scale
                             perspective:(CGFloat)perspective {
    CATransform3D rotateTransform = CATransform3DIdentity;
    rotateTransform.m34 = perspective;
    rotateTransform = CATransform3DRotate(rotateTransform, angle, 0.0, 1.0, 0.0);
    
    CATransform3D scaleTransform = CATransform3DIdentity;
    scaleTransform = CATransform3DScale(scaleTransform, scale, scale, 1.0);
    
    return CATransform3DConcat(rotateTransform, scaleTransform);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [scrollView setContentOffset:[self targetOffsetByContentOffset:scrollView.contentOffset] animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:[self targetOffsetByContentOffset:scrollView.contentOffset] animated:YES];
}

-(CGPoint)targetOffsetByContentOffset:(CGPoint)contentOffset
{
    CGFloat width = self.frame.size.width - ObliqueWidth * 2;
    NSInteger index = (contentOffset.x + width * 0.5) / width;
    return CGPointMake(width * index, contentOffset.y);
}

#pragma mark- 操作
-(void)reloadData
{
    //
    [self.contentViewArray removeAllObjects];
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInCustomScrollView:)]) {
        NSInteger count = [self.dataSource numberOfItemsInCustomScrollView:self];
        CGFloat width = self.frame.size.width - ObliqueWidth * 2;
        if ([self.dataSource respondsToSelector:@selector(customScrollView:contentViewAtIndex:)]) {
            for (int i = 0; i < count; i ++) {
                UIView *view = [self.dataSource customScrollView:self contentViewAtIndex:i];
                if (!view) {
                    view = [[UIView alloc]init];
                }
                view.frame = CGRectMake(ObliqueWidth + width * i, 0, width, self.frame.size.height);
                [self addSubview:view];
                [self.contentViewArray addObject:view];
            }
        }
        self.contentSize = CGSizeMake(width * count + ObliqueWidth * 2, self.frame.size.height);
    }
}

@end
