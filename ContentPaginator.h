//
//  ContentPaginator.h
//
//  Created by Andrey Chernoev
//

@import Foundation;

@class RACCommand;

@protocol ContentPaginatorSignalProducer;

@interface ContentPaginator : NSObject

@property (nonatomic, strong, readonly) RACCommand * _Nonnull loadMoreCommand;
@property (nonatomic, strong, readonly) RACCommand *_Nonnull loadLatestCommand;
@property (nonatomic, assign, readonly) NSInteger pageSize;
@property (nonatomic, assign, readonly) BOOL hasMoreContent;
@property (nonatomic, assign, readonly) NSUInteger nextPage;

- (instancetype _Nonnull)initWithSignalProducer:(id <ContentPaginatorSignalProducer> _Nonnull)signalProducer
                                       pageSize:(NSNumber * _Nonnull)pageSize;

- (void)loadMore; //Execute loadMoreCommand command
- (void)loadLatest; //Execute loadLatestCommand command

- (RACSignal * _Nonnull)loadMoreSignal; //Return loadMore signal from signal producer
- (RACSignal * _Nonnull)loadLatestSignal; //Return loadLates signal from signal producer
- (void)resetLoadingState;

@end

@protocol ContentPaginatorSignalProducer

- (RACSignal * _Nonnull)loadMoreSignalWithPage:(NSInteger)page;
- (RACSignal * _Nonnull)loadLatestSignalWithPage:(NSInteger)page;

@end
