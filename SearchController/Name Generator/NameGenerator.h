/**
 *	From: https://github.com/rakkarage/objective-c-name-generator
 *  Updated for ARC with convinience methods for getting a random name
 */



@interface NameGenerator : NSObject

+ (instancetype)sharedGenerator;
- (NSString *)randomName;

@end
