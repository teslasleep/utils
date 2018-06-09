//
//  NotificationManager.h
//
//  Created by Andrey Chernoev
//

@import Foundation;

@interface NotificationManager : NSObject

+ (instancetype _Nonnull)sharedManager;

- (void)postNotificationWithMessage:(NSString * _Nonnull)message
                          messageId:(NSString * _Nonnull)messageId;

@end
