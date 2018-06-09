//
//  SharedModel.m
//
//  Created by Andrey Chernoev
//

#import "SharedModel.h"

@interface SharedModel ()

@property (nonatomic, strong, readwrite) id _Nonnull placeholderItem;
@property (nonatomic, strong, readwrite) NSString * _Nonnull subject;
@property (nonatomic, strong, readwrite) NSString * _Nonnull dataType;
@property (nonatomic, strong, readwrite) NSDictionary * _Nullable itemsWithTypes;

@end

@implementation SharedModel

- (instancetype _Nonnull)initWithPlaceholder:(id _Nonnull)placeholderItem
                                     subject:(NSString * _Nonnull)subject
                                    dataType:(NSString * _Nonnull)dataType {
    return [self initWithPlaceholder:placeholderItem
                             subject:subject
                            dataType:dataType
                      itemsWithTypes:nil];
}

- (instancetype _Nonnull)initWithPlaceholder:(id _Nonnull)placeholderItem
                                     subject:(NSString * _Nonnull)subject
                                    dataType:(NSString * _Nonnull)dataType
                              itemsWithTypes:(NSDictionary * _Nullable)itemsWithTypes {
    self = [super init];
    if(self) {
        self.placeholderItem = placeholderItem;
        self.subject = subject;
        self.dataType = dataType;
        self.itemsWithTypes = itemsWithTypes;
    }
    return self;
}

//MARK: - UIActivityItemSource
- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return self.placeholderItem;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController
         itemForActivityType:(NSString *)activityType {
    return self.itemsWithTypes ? [self.itemsWithTypes objectForKey:activityType] : self.placeholderItem;
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController
              subjectForActivityType:(NSString *)activityType {
    return self.subject;
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController
   dataTypeIdentifierForActivityType:(NSString *)activityType {
    return self.dataType;
}

@end
