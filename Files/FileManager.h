//
//  FileManager.h
//
//  Created by Andrey Chernoev
//

@import Foundation;
@class RACSignal

@interface FileManager : NSObject

+ (instancetype _Nonnull)sharedManager;

- (RACSignal <NSURL *> * _Nonnull)saveImage:(UIImage * _Nonnull)image imageName:(NSString * _Nonnull)imageName;
- (RACSignal <NSURL *> * _Nonnull)saveFile:(NSData * _Nonnull)file fileName:(NSString * _Nonnull)fileName;
- (RACSignal * _Nonnull)removeFileSignal:(NSString * _Nonnull)fileName;

- (void)removeFile:(NSString * _Nonnull)fileName;
- (NSString * _Nonnull)generateUnicName;

@end
