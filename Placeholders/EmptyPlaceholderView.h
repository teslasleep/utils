//
//  EmptyPlaceholderView.h
//
//  Created by Andrey Chernoev
//

@import UIKit;
#import "UIView+Layer.h"

@interface EmptyPlaceholderView : UIView

- (void)loadBackgroundImage:(UIImage * _Nonnull)image;
- (void)loadBackgroundImage:(UIImage * _Nonnull)image
                      title:(NSString * _Nullable)title;
- (void)loadBackgroundImage:(UIImage * _Nonnull)image
                      title:(NSString * _Nullable)title
                   subTitle:(NSString * _Nullable)subTitle;
- (void)loadBackgroundImage:(UIImage * _Nonnull)image
                      title:(NSString * _Nullable)title
                   subTitle:(NSString * _Nullable)subTitle
               spinnerColor:(UIColor * _Nullable)spinnerColor;

//MARK: - Updates
- (void)updateTitle:(NSString * _Nullable)title;
- (void)updateSubtitle:(NSString * _Nullable)subtitle;

//MARK: - Animation
- (void)hideContentWhenAnimating:(BOOL)isNeedHideContent;
- (void)isLoading:(BOOL)isLoading;

@end
