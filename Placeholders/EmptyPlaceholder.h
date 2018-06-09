//
//  EmptyPlaceholder.h
//
//  Created by Andrey Chernoev
//

@class EmptyPlaceholderView;
@class CountableViewModel;

@import Foundation;
@import UIKit;
@import ReactiveObjC;

@protocol CountableViewModel <NSObject>

@property (nonatomic, readonly) RACSubject *changes;

- (NSInteger)numberOfGrouppedItems;
- (NSInteger)numberOfItemsInGroup:(NSInteger)group;

@end

@protocol EmptyPlaceholderDelegate <NSObject>

- (void)showEmptyPlaceholder:(UIView * _Nullable)placeholder;

@end

@protocol EmptyPlaceholderDatasource <NSObject>

- (NSString * _Nullable)placeholderTitle;
- (NSString * _Nullable)placeholderMessage;

@end

@interface EmptyPlaceholder : NSObject

@property (nonatomic, strong) id <CountableViewModel> _Nonnull viewModel;
@property (nonatomic, assign, readonly) NSUInteger minimumItemsCount;

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                               datasource:(id <EmptyPlaceholderDatasource> _Nonnull)datasource
                                    image:(UIImage * _Nonnull)image
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel;

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                               datasource:(id <EmptyPlaceholderDatasource> _Nullable)datasource
                                    image:(UIImage * _Nonnull)image
                                    title:(NSString * _Nullable)title
                                  message:(NSString * _Nullable)message
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel;

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                                    image:(UIImage * _Nonnull)image
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel;

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                                    image:(UIImage * _Nonnull)image
                                    title:(NSString * _Nullable)title;

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                                    image:(UIImage * _Nonnull)image
                                    title:(NSString * _Nullable)title
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel;

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                                    image:(UIImage * _Nonnull)image
                                    title:(NSString * _Nullable)title
                                  message:(NSString * _Nullable)message
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel;

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                                    image:(UIImage * _Nonnull)image
                                    title:(NSString * _Nullable)title
                           animationTitle:(NSString * _Nullable)animationTitle
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel;


- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                               datasource:(id <EmptyPlaceholderDatasource> _Nonnull)datasource
                                    image:(UIImage * _Nonnull)image
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel
                        minimumItemsCount:(NSInteger )minimumItemsCount;

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                               datasource:(id <EmptyPlaceholderDatasource> _Nullable)datasource
                                    image:(UIImage * _Nonnull)image
                                    title:(NSString * _Nullable)title
                                  message:(NSString * _Nullable)message
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel
                        minimumItemsCount:(NSInteger )minimumItemsCount NS_DESIGNATED_INITIALIZER;

- (EmptyPlaceholderView * _Nonnull)placeholderViewWithImage:(UIImage * _Nonnull)image
                                                      title:(NSString * _Nullable)title;

- (EmptyPlaceholderView * _Nonnull)placeholderViewWithImage:(UIImage * _Nullable)image
                                                      title:(NSString * _Nullable)title
                                                   subtitle:(NSString * _Nullable)subtitle
                                               spinnerColor:(UIColor * _Nullable)spinnerColor;
//MARK: - Animation
- (void)startAnimation;
- (void)stopAnimation;

- (void)hideContentWhenAnimating:(BOOL)isNeedHide; //Default value: YES
- (void)setMinimunNumberOfItems:(NSUInteger)minimum; //Default value: 0

@end
