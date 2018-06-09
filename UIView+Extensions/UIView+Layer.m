//
//  UIView+Layer.m
//
//  Created by Andrey Chernoev
//

#import "UIView+Layer.h"

@implementation UIView (Layer)

@dynamic borderColor, borderWidth, cornerRadius, borderAlpha;

- (void)setBorderColor:(UIColor *)borderColor {
    [self.layer setBorderColor:borderColor.CGColor];
    [self.layer setMasksToBounds:YES];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    [self.layer setBorderWidth:borderWidth];
    [self.layer setMasksToBounds:YES];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self.layer setCornerRadius:cornerRadius];
    [self.layer setMasksToBounds:YES];
}

- (void)setBorderAlpha:(CGFloat)borderAlpha {
    UIColor *color = [[UIColor colorWithCGColor:self.layer.borderColor] colorWithAlphaComponent:borderAlpha];
    [self.layer setBorderColor:color.CGColor];
    [self.layer setMasksToBounds:YES];
}

- (void)addShadow {
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 1.f;
    self.layer.shadowOpacity = 0.3f;
}

- (void)circleCorners {
    [self.layer setCornerRadius:self.bounds.size.width / 2];
    [self.layer setMasksToBounds:YES];
}

- (void)bezierEllipseBorderWithColor:(UIColor * _Nonnull)borderColor
                         borderWidth:(CGFloat)borderWidth {
    CGRect rect = self.bounds;
    CGSize ellipseRadiusSize = CGSizeMake(rect.size.width * 0.5, rect.size.height * 0.5);
    
    //Make round
    // Create the path for to make circle
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:ellipseRadiusSize];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = rect;
    maskLayer.path  = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
    
    //Give Border
    //Create path for border
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                     byRoundingCorners:UIRectCornerAllCorners
                                                           cornerRadii:ellipseRadiusSize];
    
    // Create the shape layer and set its path
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    
    borderLayer.frame = rect;
    borderLayer.path = borderPath.CGPath;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.lineWidth = borderWidth;
    
    //Add this layer to give border.
    [[self layer] addSublayer:borderLayer];
}

@end
