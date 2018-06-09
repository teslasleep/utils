//
//  NotificationManager.m
//
//  Created by Andrey Chernoev
//

@import ReactiveObjC;
@import UserNotifications;

#import "NotificationManager.h"
#import "AppDelegate.h"

@interface NotificationManager ()

@property (nonatomic, assign) BOOL isOS10;

@end

@implementation NotificationManager

static NotificationManager *instance = nil;

+ (instancetype _Nonnull)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NotificationManager alloc] init];
    });
    return instance;
}

//MARK: - Public
- (void)postNotificationWithMessage:(NSString * _Nonnull)message messageId:(NSString * _Nonnull)messageId {
    if ([AppDelegate sharedDelegate].isNotificationEnabled) {
        UILocalNotification *localNotification = [self localNotificationWithmessage:message];
        if (self.isOS10) {
            [self postNotificationMessage:message messageId:message localNotification:localNotification];
        } else {
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }
    }
}

//MARK: - Post notifications iOS 10+
- (void)postNotificationMessage:(NSString * _Nonnull)message messageId:(NSString * _Nonnull)messageId localNotification:(UILocalNotification *)localNotification {
    @weakify(self);
    [[UNUserNotificationCenter currentNotificationCenter] getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postNotificationID:messageId
                           alertBody:localNotification.alertBody
                            fireDate:localNotification.fireDate];
        });
    }];
}

- (void)postNotificationID:(NSString *)notificationID alertBody:(NSString *)alertBody fireDate:(NSDate *)fireDate {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.sound = [UNNotificationSound defaultSound];
    content.body = alertBody;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *triggerDate = [calendar components:
                                     kCFCalendarUnitYear +
                                     kCFCalendarUnitMonth +
                                     kCFCalendarUnitDay +
                                     kCFCalendarUnitHour +
                                     kCFCalendarUnitMinute +
                                     kCFCalendarUnitSecond
                                                fromDate:fireDate];
    UNNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate
                                                                                              repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:notificationID content:content
                                                                          trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request
                                                           withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"%@", error];
            NSLog(@"Post notificaiton error: %@", errorMessage);
        }
    }];
}

//MARK - Local notification
- (UILocalNotification * _Nonnull)localNotificationWithmessage:(NSString * _Nonnull)message {
   UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = message;
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5.f];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    return localNotification;
}

//MARK: -
- (BOOL)isOS10 {
    static BOOL res = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        res = ([[UIDevice currentDevice].systemVersion compare:@"10" options:NSNumericSearch] != NSOrderedAscending);
    });
    return res;
}

@end
