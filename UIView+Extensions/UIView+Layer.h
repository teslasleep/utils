//
//  UIView+Layer.h
//
//  Created by Andrey Chernoev
//

@import UIKit;

@interface UIView (Layer)

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderAlpha;
@property (nonatomic) IBInspectable CGFloat borderWidth;

- (void)addShadow;
- (void)circleCorners;

- (void)bezierEllipseBorderWithColor:(UIColor * _Nonnull)borderColor borderWidth:(CGFloat)borderWidth;

@end
