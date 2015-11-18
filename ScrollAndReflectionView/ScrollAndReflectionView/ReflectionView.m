//
//  ReflectionView.m
//  功能测试集3
//
//  Created by gmtx on 15/10/30.
//  Copyright © 2015年 gmtx. All rights reserved.
//

#import "ReflectionView.h"

@interface ReflectionView()
@property(nonatomic, strong)CAReplicatorLayer *replicatorLayer;
@property(nonatomic, strong)CALayer *contentLayer;
@property(nonatomic, strong)CAGradientLayer *gradientLayer;
@end

@implementation ReflectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.projectionOffset = frame.size.height * 0.2;
        self.spacing = 5.0;
        self.image = [UIImage imageNamed:@"1"];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.replicatorLayer removeFromSuperlayer];
    [self.contentLayer removeFromSuperlayer];
    [self.gradientLayer removeFromSuperlayer];
    [self addLayer];
}

-(void)addLayer
{
    //复制层
    self.replicatorLayer = ({
        CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
        replicatorLayer.frame = self.bounds;
        replicatorLayer.instanceCount = 2;
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DScale(transform, 1, -1, 1);
        transform = CATransform3DTranslate(transform, 0, - self.projectionOffset * 2 - self.spacing, 0);
        replicatorLayer.instanceTransform = transform;
        replicatorLayer.instanceAlphaOffset = -0.3;
        replicatorLayer;
    });
    [self.layer addSublayer:self.replicatorLayer];
    //内容层
    self.contentLayer = ({
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, self.replicatorLayer.bounds.size.width, self.replicatorLayer.bounds.size.height * 0.5 + self.projectionOffset);
        layer.contents = (id)self.image.CGImage;
        layer;
    });
    [self.replicatorLayer addSublayer:self.contentLayer];
    //阴影层
    self.gradientLayer = ({
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, self.bounds.size.height * 0.5 + self.projectionOffset, self.bounds.size.width, self.bounds.size.height * 0.5);
        gradientLayer.colors = @[(__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.1].CGColor, (__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.7].CGColor];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        gradientLayer;
    });
    [self.layer addSublayer:self.gradientLayer];
    //添加文字
    [self addTextLayer];
}
#pragma mark 添加显示文字的textLayer
-(void)addTextLayer
{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(0, 150, self.contentLayer.bounds.size.width, 50);
    textLayer.string = @"投影文字";
    textLayer.fontSize = 18.0;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.foregroundColor = [UIColor redColor].CGColor;
    [self.contentLayer addSublayer:textLayer];
    //
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    positionAnimation.duration = 2.0;
    positionAnimation.repeatCount = HUGE_VALF;
    positionAnimation.fromValue = @(-textLayer.bounds.size.height * 0.5);
    positionAnimation.toValue = @(self.contentLayer.bounds.size.width);
    [textLayer addAnimation:positionAnimation forKey:positionAnimation.keyPath];
}
#pragma mark-
#pragma mark 修改属性
-(void)setProjectionOffset:(CGFloat)projectionOffset
{
    _projectionOffset = projectionOffset;
    [self setNeedsLayout];
}

-(void)setSpacing:(CGFloat)spacing
{
    _spacing = spacing;
    [self setNeedsLayout];
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    self.contentLayer.contents = (id)image.CGImage;
}

-(void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    _contentView.frame = self.contentLayer.bounds;
    [self.contentLayer addSublayer:contentView.layer];
}

@end
