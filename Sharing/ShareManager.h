//
//  ShareManager.h
//
//  Created by Andrey Chernoev
//

@import Foundation;
@import UIKit;

#import "SharedModel.h"

@interface ShareManager : NSObject 

- (instancetype _Nonnull)initWithModel:(SharedModel * _Nonnull)model
                 destinationController:(UIViewController * _Nullable)controller;

- (void)showShareActions;

@end
