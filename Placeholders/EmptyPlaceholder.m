//
//  EmptyPlaceholder.m
//
//  Created by Andrey Chernoev
//

#import "EmptyPlaceholder.h"
#import "EmptyPlaceholderView.h"

@interface EmptyPlaceholder ()

@property (nonatomic, strong) EmptyPlaceholderView *placeholder;
@property (nonatomic, weak) id <EmptyPlaceholderDelegate> delegate;
@property (nonatomic, weak) id <EmptyPlaceholderDatasource> datasource;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) EmptyPlaceholderView *placeholderView;
@property (nonatomic, strong) NSString *placeholderTitle;
@property (nonatomic, strong) NSString *placeholderMessage;
@property (nonatomic, strong) NSString *animationTitle;
@property (nonatomic, assign, readwrite) NSUInteger minimumItemsCount;

@end

@implementation EmptyPlaceholder

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                                    image:(UIImage * _Nonnull)image
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel {
    return [self initWithDelegate:delegate image:image title:nil message:nil viewModel:viewModel];
}

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                                    image:(UIImage * _Nonnull)image
                                    title:(NSString * _Nullable)title {
    return [self initWithDelegate:delegate image:image title:title viewModel:nil];
}

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                                    image:(UIImage * _Nonnull)image
                                    title:(NSString * _Nullable)title
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel {
    return [self initWithDelegate:delegate image:image title:title message:nil viewModel:viewModel];
}

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                                    image:(UIImage * _Nonnull)image
                                    title:(NSString * _Nullable)title
                                  message:(NSString * _Nullable)message
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel {
    return [self initWithDelegate:delegate
                       datasource:nil
                            image:image
                            title:title message:message viewModel:viewModel];
}

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                                    image:(UIImage * _Nonnull)image
                                    title:(NSString * _Nullable)title
                           animationTitle:(NSString * _Nullable)animationTitle
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel {
    self = [self initWithDelegate:delegate datasource:nil image:image title:title message:nil viewModel:viewModel];
    if (self) {
        self.animationTitle = animationTitle;
    }
    return self;
}

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                               datasource:(id <EmptyPlaceholderDatasource> _Nonnull)datasource
                                    image:(UIImage * _Nonnull)image
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel
                        minimumItemsCount:(NSInteger )minimumItemsCount {
    return [self initWithDelegate:delegate
                       datasource:datasource
                            image:image
                            title:nil
                          message:nil
                        viewModel:viewModel
                minimumItemsCount:minimumItemsCount];
}

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                               datasource:(id <EmptyPlaceholderDatasource> _Nonnull)datasource
                                    image:(UIImage * _Nonnull)image
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel {
    return [self initWithDelegate:delegate
                       datasource:datasource
                            image:image
                            title:nil
                          message:nil
                        viewModel:viewModel
                minimumItemsCount:0];
}

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                               datasource:(id <EmptyPlaceholderDatasource> _Nullable)datasource
                                    image:(UIImage * _Nonnull)image
                                    title:(NSString * _Nullable)title
                                  message:(NSString * _Nullable)message
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel {
    return [self initWithDelegate:delegate
                       datasource:datasource
                            image:image
                            title:title
                          message:message
                        viewModel:viewModel
                minimumItemsCount:0];
}

- (instancetype _Nonnull)initWithDelegate:(id <EmptyPlaceholderDelegate> _Nonnull)delegate
                               datasource:(id <EmptyPlaceholderDatasource> _Nullable)datasource
                                    image:(UIImage * _Nonnull)image
                                    title:(NSString * _Nullable)title
                                  message:(NSString * _Nullable)message
                                viewModel:(id <CountableViewModel> _Nonnull)viewModel
                        minimumItemsCount:(NSInteger )minimumItemsCount {
    self = [super init];
    if (self) {
        self.image = image;
        self.datasource = datasource;
        self.delegate = delegate;
        self.placeholderTitle = title;
        self.placeholderMessage = message;
        self.minimumItemsCount = minimumItemsCount;
        [self createPlaceholderView];
        [self.placeholderView hideContentWhenAnimating:YES];
        if (viewModel) {
            self.viewModel = viewModel;
        }
    }
    return self;
}

- (EmptyPlaceholderView * _Nonnull)placeholderViewWithImage:(UIImage * _Nonnull)image
                                                      title:(NSString * _Nullable)title {
    return [self placeholderViewWithImage:image title:title subtitle:nil spinnerColor:nil];
}

//MARK: -

- (void)setViewModel:(id <CountableViewModel>)viewModel {
    _viewModel = viewModel;
    [self rac_liftSelector:@selector(handleChangesWithObject:) withSignals:RACObserve(self, viewModel), nil];
    [self rac_liftSelector:@selector(handleChangesWithObject:) withSignals:viewModel.changes, nil];
    [self rac_liftSelector:@selector(handleChangesWithObject:) withSignals:RACObserve(self, minimumItemsCount), nil];
}

- (void)handleChangesWithObject:(id)object {
    if ([self totalNumberOfItems] == self.minimumItemsCount) {
        if (self.datasource) {
            [self.placeholderView updateTitle:[self.datasource placeholderTitle]];
            [self.placeholderView updateSubtitle:[self.datasource placeholderMessage]];
        }
        [self.delegate showEmptyPlaceholder:self.placeholderView];
    } else {
        [self.delegate showEmptyPlaceholder:nil];
    }
}

- (NSInteger)totalNumberOfItems {
    NSInteger totalNumber = 0;
    for(int i = 0; i < [self.viewModel numberOfGrouppedItems]; i++) {
        totalNumber += [self.viewModel numberOfItemsInGroup:i];
    }
    return totalNumber;
}

- (void)createPlaceholderView {
    self.placeholderView = [self placeholderViewWithImage:self.image
                                                    title:self.placeholderTitle
                                                 subtitle:self.placeholderMessage
                                             spinnerColor:[UIColor grayColor]];
}

- (EmptyPlaceholderView * _Nonnull)placeholderViewWithImage:(UIImage * _Nullable)image
                                                         title:(NSString * _Nullable)title
                                                      subtitle:(NSString * _Nullable)subtitle
                                                  spinnerColor:(UIColor * _Nullable)spinnerColor {
    EmptyPlaceholderView *emptyListBackgroundView = [EmptyPlaceholderView loadFromXib];
    [emptyListBackgroundView loadBackgroundImage:image title:title subTitle:subtitle spinnerColor:spinnerColor];
    return emptyListBackgroundView;
}

//MARK: -

- (void)startAnimation {
    [self.placeholderView isLoading:YES];
    [self updateTitleWhenAnimating:YES];
}

- (void)stopAnimation {
    [self.placeholderView isLoading:NO];
    [self updateTitleWhenAnimating:NO];
}

- (void)updateTitleWhenAnimating:(BOOL)isAnimating {
    if (self.animationTitle && isAnimating) {
        [self.placeholderView updateTitle:self.animationTitle];
    } else {
        NSString *title = self.placeholderTitle;
        if (self.datasource) {
            title = [self.datasource placeholderTitle];
        }
        [self.placeholderView updateTitle:title];
    }
}

- (void)hideContentWhenAnimating:(BOOL)isNeedHide {
    [self.placeholderView hideContentWhenAnimating:isNeedHide];
}

- (void)setMinimunNumberOfItems:(NSUInteger)minimum {
    self.minimumItemsCount = minimum;
}

@end
