//
//  EmptyPlaceholderView.m
//
//  Created by Andrey Chernoev
//

#import "EmptyPlaceholderView.h"

@interface EmptyPlaceholderView ()

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *subTitle;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, assign) BOOL hideContent;

@end

@implementation EmptyPlaceholderView

- (void)loadBackgroundImage:(UIImage * _Nonnull)image {
    [self loadBackgroundImage:image title:nil subTitle:nil];
}

- (void)loadBackgroundImage:(UIImage * _Nonnull)image
                      title:(NSString * _Nullable)title {
    [self loadBackgroundImage:image title:title subTitle:nil];
}

- (void)loadBackgroundImage:(UIImage * _Nonnull)image
                      title:(NSString * _Nullable)title
                   subTitle:(NSString * _Nullable)subTitle {
    [self loadBackgroundImage:image
                        title:title
                     subTitle:subTitle
                 spinnerColor:nil];
}

- (void)loadBackgroundImage:(UIImage *)image
                      title:(NSString *)title
                   subTitle:(NSString *)subTitle
               spinnerColor:(UIColor * _Nullable)spinnerColor {
    self.backgroundImage.image = image;
    [self updateTitle:title];
    [self updateSubtitle:subTitle];
    [self updateSpinnerColor:spinnerColor];
}

- (void)updateSpinnerColor:(UIColor * _Nullable)color {
    self.spinner.color =  color ? color : [UIColor grayColor];
}

- (void)updateTitle:(NSString * _Nullable)title {
    self.title.text = title;
}

- (void)updateSubtitle:(NSString * _Nullable)subtitle {
    self.subTitle.text = subtitle;
}

//MARK: - Animation
- (void)isLoading:(BOOL)isLoading {
    if (self.hideContent) {
        self.backgroundImage.hidden = isLoading;
        self.title.hidden = isLoading;
        self.subTitle.hidden = isLoading;
    }
    if (isLoading) {
        [self.spinner startAnimating];
    } else {
        [self.spinner stopAnimating];
    }
}

- (void)hideContentWhenAnimating:(BOOL)isNeedHideContent {
    self.hideContent = isNeedHideContent;
}

@end
