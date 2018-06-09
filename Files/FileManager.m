//
//  FileManager.m
//
//  Created by Andrey Chernoev
//

@import ReactiveObjC;

#import "FileManager.h"

@implementation FileManager

static FileManager *instance = nil;

+ (instancetype _Nonnull)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

//MARK: - Public
- (NSString * _Nonnull)generateUnicName {
    return [[NSProcessInfo processInfo] globallyUniqueString];
}

- (RACSignal <NSURL *> * _Nonnull)saveImage:(UIImage * _Nonnull)image imageName:(NSString * _Nonnull)imageName {
    return [self saveFile:UIImageJPEGRepresentation(image, 1.f) fileName:imageName];
}

- (RACSignal <NSURL *> * _Nonnull)saveFile:(NSData * _Nonnull)file fileName:(NSString * _Nonnull)fileName {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSError *error = nil;
        NSURL *path = [self pathWithFileName:fileName];
        BOOL status = [file writeToURL:path options:NSDataWritingAtomic error:&error];
        if (error) {
            [subscriber sendError:error];
        } else {
            if (status) {
                [subscriber sendNext:path];
            } else {
                [subscriber sendNext:nil];
            }
            [subscriber sendCompleted];
        }
        return nil;
    }];
    return signal;
    
}

- (RACSignal * _Nonnull)removeFileSignal:(NSString * _Nonnull)fileName {
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSError *error = nil;
        @strongify(self);
        NSURL *path = [self pathWithFileName:fileName];
        BOOL status = [[NSFileManager defaultManager] removeItemAtURL:path error:&error];
        if (error) {
            [subscriber sendError:error];
        } else {
            [subscriber sendNext:@(status)];
            [subscriber sendCompleted];
        }
        return nil;
    }];
    return signal;
}

- (void)removeFile:(NSString * _Nonnull)fileName {
    [[self removeFileSignal:fileName] subscribeError:^(NSError * _Nullable error) {
        NSLog(@"Remove file %@ error :%@", fileName, error.localizedDescription);
    }];
}

- (NSURL *_Nonnull)pathWithFileName:(NSString * _Nonnull)fileName {
    return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
}

@end
