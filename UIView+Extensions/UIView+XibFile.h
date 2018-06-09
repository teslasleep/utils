//
//  UIView+XibFile.h
//
//  Created by Andrey Chernoev
//

@import UIKit;

@interface UIView (XibFile)

+ (UINib * _Nonnull)loadNib;
+ (instancetype _Nonnull)loadFromXib;
+ (NSString * _Nonnull)reuseIdentifier;

@end
