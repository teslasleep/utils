//
//  UIView+XibFile.m
//
//  Created by Andrey Chernoev
//

#import "UIView+XibFile.h"

@implementation UIView (XibFile)

+ (UINib * _Nonnull)loadNib {
    return [UINib nibWithNibName:[self reuseIdentifier] bundle:nil];
}

+ (instancetype _Nonnull)loadFromXib {
    return [[[NSBundle mainBundle] loadNibNamed:[self reuseIdentifier] owner:self options:nil] firstObject];
}

+ (NSString * _Nonnull)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
