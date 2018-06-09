//
//  SharedModel.h
//
//  Created by Andrey Chernoev
//

@import Foundation;
@import UIKit;

@interface SharedModel : NSObject <UIActivityItemSource>

@property (nonatomic, strong, readonly) id _Nonnull placeholderItem;
@property (nonatomic, strong, readonly) NSString * _Nonnull subject;
@property (nonatomic, strong, readonly) NSString * _Nonnull dataType;
@property (nonatomic, strong, readonly) NSDictionary * _Nullable itemsWithTypes;

- (instancetype _Nonnull)initWithPlaceholder:(id _Nonnull)placeholderItem
                                     subject:(NSString * _Nonnull)subject
                                    dataType:(NSString * _Nonnull)dataType;

- (instancetype _Nonnull)initWithPlaceholder:(id _Nonnull)placeholderItem
                                     subject:(NSString * _Nonnull)subject
                                    dataType:(NSString * _Nonnull)dataType
                              itemsWithTypes:(NSDictionary * _Nullable)itemsWithTypes;

@end
