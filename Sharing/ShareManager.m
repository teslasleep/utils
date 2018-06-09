//
//  ShareManager.m
//
//  Created by Andrey Chernoev
//
//

#import "ShareManager.h"

@interface ShareManager () <UIActivityItemSource>

@property (nonatomic, strong) SharedModel * _Nonnull model;
@property (nonatomic, strong) UIViewController * _Nullable destinationController;

@end

@implementation ShareManager

- (instancetype _Nonnull)initWithModel:(SharedModel * _Nonnull)model
                 destinationController:(UIViewController * _Nullable)controller {
    self = [super init];
    if(self) {
        self.model = model;
        self.destinationController = controller;
    }
    return self;
}

//MARK: - Public
- (void)showShareActions {
    if (self.destinationController) {
        [self showActionWithDestinationController:self.destinationController];
    }
}

//MARK: - Private
- (void)showActionWithDestinationController:(UIViewController * _Nonnull)controller {
    [controller presentViewController:[self activity] animated:YES completion:NULL];
}

- (UIActivityViewController * _Nonnull)activity {
    return [[UIActivityViewController alloc] initWithActivityItems:@[self.model] applicationActivities:nil];
}

@end
