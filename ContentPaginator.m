//
//  ContentPaginator.m
//
//  Created by Andrey Chernoev
//

@import ReactiveObjC;

#import "ContentPaginator.h"

@interface ContentPaginator()
//Commands
@property (nonatomic, strong, readwrite) RACCommand * _Nonnull loadMoreCommand;
@property (nonatomic, strong, readwrite) RACCommand * _Nonnull loadLatestCommand;

//Pages loaded
@property (nonatomic, assign, readwrite) NSUInteger nextPage;
//Has more state
@property (nonatomic, assign, readwrite) BOOL hasMoreContent;
//Page size
@property (nonatomic, assign, readwrite) NSInteger pageSize;

@property (nonatomic, weak) id <ContentPaginatorSignalProducer> signalProducer;

@property (nonatomic, assign) BOOL isProcessing;
@property (nonatomic, strong) RACSignal *isProcessingSignal;
@property (nonatomic, strong) RACSubject *disposeSubject;

@end

@implementation ContentPaginator

static NSInteger defaultPageSize = 20

- (instancetype _Nonnull)initWithSignalProducer:(id <ContentPaginatorSignalProducer> _Nonnull)signalProducer
                                       pageSize:(NSNumber * _Nonnull)pageSize {
    self = [super init];
    if(self) {
        self.pageSize = pageSize ? pageSize.integerValue : defaultPageSize;
        self.signalProducer = signalProducer;
        [self commonInit];
        [self resetLoadingState];
        self.isProcessing = NO;
    }
    return self;
}

- (void)commonInit {
    @weakify(self);
    self.loadMoreCommand = [[RACCommand alloc] initWithEnabled:[self loadMoreCommandEnabledSignal]
                                                   signalBlock:^RACSignal * _Nonnull(id _Nullable input) {
                                                       @strongify(self);
                                                       return [self safeExecutinSignalWithServiceSignal:[self loadMoreSignlaProducerSignal]];
                                                   }];
    self.loadLatestCommand = [[RACCommand alloc] initWithEnabled:[self loadLatestCommandEnabledSignal]
                                                     signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
                                                         @strongify(self);
                                                         return [self safeExecutinSignalWithServiceSignal:[self loadLatestSignlaProducerSignal]];
                                                     }];
}

- (RACSignal * _Nonnull)loadMoreSignlaProducerSignal {
    RACSignal *signal = [self.signalProducer loadMoreSignalWithPage:self.nextPage];
    return [[self loadMoreContentWrappedSignal:signal] takeUntil:self.disposeSubject];
}

- (RACSignal * _Nonnull)loadLatestSignlaProducerSignal {
    [self resetLoadingState];
    RACSignal *signal = [self.signalProducer loadLatestSignalWithPage:0];
    return [[self loadLatestContentWrappedSignal:signal] takeUntil:self.disposeSubject];
}

- (RACSignal * _Nonnull)safeExecutinSignalWithServiceSignal:(RACSignal * _Nonnull)serviceSignal {
    if (!self.isProcessing) {
        [self startProcessing];
        @weakify(self);
        return [[serviceSignal doError:^(NSError * _Nonnull error) {
            @strongify(self);
            [self stopProcessing];
        }] doCompleted:^{
            @strongify(self);
            [self stopProcessing];
        }];
    } else {
        return [RACSignal empty];
    }
}

- (void)dealloc {
    [self resetLoadingState];
}

//MARK: -
- (RACSignal * _Nonnull)loadMoreContentWrappedSignal:(RACSignal * _Nonnull)signal {
    @weakify(self);
    return [[[signal doNext:^(NSArray * _Nullable items) {
        @strongify(self);
        [self hasMoreWithItems:items];
    }] doError:^(NSError * _Nonnull error) {
        @strongify(self);
        [self resetLoadingState];
    }] doCompleted:^{
        @strongify(self);
        self.nextPage += 1;
    }];
}

- (RACSignal * _Nonnull)loadLatestContentWrappedSignal:(RACSignal * _Nonnull)signal {
    @weakify(self);
    return [signal doNext:^(NSArray * _Nullable items) {
        @strongify(self);
        [self hasMoreWithItems:items];
    }];
}

- (void)stopProcessing {
    self.isProcessing = NO;
}

- (void)startProcessing {
    self.isProcessing = YES;
}

//MARK: -
- (RACSignal * _Nonnull)loadLatestCommandEnabledSignal {
    return [RACSignal return:@YES];
}

- (RACSignal * _Nonnull)loadMoreCommandEnabledSignal {
    return [[RACObserve(self, hasMoreContent) distinctUntilChanged] ignore:nil];
}

//MARK: -
- (void)resetLoadingState {
    self.nextPage = 0;
    self.hasMoreContent = YES;
    [self.disposeSubject sendNext:[RACUnit defaultUnit]];
}

- (void)hasMoreWithItems:(NSArray * _Nullable)items {
    self.hasMoreContent = (items.count == self.pageSize ? YES : NO);
}

//MARK: - Public
- (void)loadMore {
    [self.loadMoreCommand execute:nil];
}

- (void)loadLatest {
    [self.loadLatestCommand execute:nil];
}

- (RACSignal * _Nonnull)loadMoreSignal {
    return [self.loadMoreCommand execute:[RACUnit defaultUnit]];
}

- (RACSignal * _Nonnull)loadLatestSignal {
    return [self.loadLatestCommand execute:[RACUnit defaultUnit]];
}

@end
