/**
 *	From: https://github.com/rakkarage/objective-c-name-generator
 *  Updated for ARC with convinience methods for getting a random name
 */

@import Foundation;
@import UIKit;

#import"NameGenerator.h"


#define PRE_CHANCE 33
#define VOWEL_CHANCE 80
#define MIDDLE1_CHANCE 30
#define MIDDLE2_CHANCE 10
#define POST_CHANCE 22
#define GENERATED_CHANCE 50



@interface NameGenerator ()

@property (strong, nonatomic) NSMutableArray *vowel;

@property (strong, nonatomic) NSMutableArray *malePre;
@property (strong, nonatomic) NSMutableArray *maleStart;
@property (strong, nonatomic) NSMutableArray *maleMiddle;
@property (strong, nonatomic) NSMutableArray *maleEnd;
@property (strong, nonatomic) NSMutableArray *malePost;

@property (strong, nonatomic) NSMutableArray *male;

@property (strong, nonatomic) NSMutableArray *femalePre;
@property (strong, nonatomic) NSMutableArray *femaleStart;
@property (strong, nonatomic) NSMutableArray *femaleMiddle;
@property (strong, nonatomic) NSMutableArray *femaleEnd;
@property (strong, nonatomic) NSMutableArray *femalePost;

@property (strong, nonatomic) NSMutableArray *female;

@end



@implementation NameGenerator


#pragma mark -
#pragma mark - Singleton Creator

+ (instancetype)sharedGenerator
{
    static NameGenerator *_sharedGenerator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedGenerator = [[NameGenerator alloc] init];
    });
    
    return _sharedGenerator;
}


#pragma mark -
#pragma mark - Initializer

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _vowel = [NSMutableArray arrayWithObjects:@"a", @"e", @"i", @"o", @"u", @"y", nil];
        _malePre = [NSMutableArray array];
        _femalePre = [NSMutableArray array];
        _maleStart = [NSMutableArray array];
        _femaleStart = [NSMutableArray array];
        _maleMiddle = [NSMutableArray array];
        _femaleMiddle = [NSMutableArray array];
        _maleEnd = [NSMutableArray array];
        _femaleEnd = [NSMutableArray array];
        _malePost = [NSMutableArray array];
        _femalePost = [NSMutableArray array];
        _male = [NSMutableArray array];
        _female = [NSMutableArray array];
        
        NSStringEncoding encoding;
        NSError *error;
        
        NSBundle *bundle = [NSBundle mainBundle];
        
        NSString *syllablePath = [bundle pathForResource:@"syllable" ofType:@"csv"];
        NSString *syllableFile = [NSString stringWithContentsOfFile:syllablePath usedEncoding:&encoding error:&error];
        NSArray *syllableRows = [[NSArray alloc] initWithArray:[syllableFile componentsSeparatedByString:@"\n"]];
        
        for (NSUInteger i = 1; i < [syllableRows count]; i++)
        {
            NSArray *cells = [[syllableRows objectAtIndex:i] componentsSeparatedByString:@","];
            NSString *cell;
            if ((cells.count >= 1) && ([cells objectAtIndex:0] != nil))
            {
                cell = [cells objectAtIndex:0];
                if (cell.length != 0)
                {
                    [_maleStart addObject:cell];
                }
            }
            if ((cells.count >= 2) && ([cells objectAtIndex:1] != nil))
            {
                cell = [cells objectAtIndex:1];
                if (cell.length != 0)
                {
                    [_maleMiddle addObject:cell];
                }
            }
            if ((cells.count >= 3) && ([cells objectAtIndex:2] != nil))
            {
                cell = [cells objectAtIndex:2];
                if (cell.length != 0)
                {
                    [_maleEnd addObject:cell];
                }
            }
            if ((cells.count >= 4) && ([cells objectAtIndex:3] != nil))
            {
                cell = [cells objectAtIndex:3];
                if (cell.length != 0)
                {
                    [_femaleStart addObject:cell];
                }
            }
            if ((cells.count >= 5) && ([cells objectAtIndex:4] != nil))
            {
                cell = [cells objectAtIndex:4];
                if (cell.length != 0)
                {
                    [_femaleMiddle addObject:cell];
                }
            }
            if ((cells.count >= 6) && ([cells objectAtIndex:5] != nil))
            {
                cell = [cells objectAtIndex:5];
                if (cell.length != 0)
                {
                    [_femaleEnd addObject:cell];
                }
            }
            if ((cells.count >= 7) && ([cells objectAtIndex:6] != nil))
            {
                cell = [cells objectAtIndex:6];
                if (cell.length != 0)
                {
                    [_maleStart addObject:cell];
                    [_femaleStart addObject:cell];
                }
            }
            if ((cells.count >= 8) && ([cells objectAtIndex:7] != nil))
            {
                cell = [cells objectAtIndex:7];
                if (cell.length != 0)
                {
                    [_maleMiddle addObject:cell];
                    [_femaleMiddle addObject:cell];
                }
            }
            if ((cells.count >= 9) && ([cells objectAtIndex:8] != nil))
            {
                cell = [cells objectAtIndex:8];
                if (cell.length != 0)
                {
                    [_maleEnd addObject:cell];
                    [_femaleEnd addObject:cell];
                }
            }
        }
        
        NSString *titlePath = [bundle pathForResource:@"title" ofType:@"csv"];
        NSString *titleFile = [NSString stringWithContentsOfFile:titlePath usedEncoding:&encoding error:&error];
        NSArray *titleRows = [[NSArray alloc] initWithArray:[titleFile componentsSeparatedByString:@"\n"]];
        
        for (NSUInteger i = 1; i < [titleRows count]; i++)
        {
            NSArray *cells = [[titleRows objectAtIndex:i] componentsSeparatedByString:@","];
            NSString *cell;
            if ((cells.count >= 1) && ([cells objectAtIndex:0] != nil))
            {
                cell = [cells objectAtIndex:0];
                if (cell.length != 0)
                {
                    [_malePre addObject:cell];
                }
            }
            if ((cells.count >= 2) && ([cells objectAtIndex:1] != nil))
            {
                cell = [cells objectAtIndex:1];
                if (cell.length != 0)
                {
                    [_malePost addObject:cell];
                }
            }
            if ((cells.count >= 3) && ([cells objectAtIndex:2] != nil))
            {
                cell = [cells objectAtIndex:2];
                if (cell.length != 0)
                {
                    [_femalePre addObject:cell];
                }
            }
            if ((cells.count >= 4) && ([cells objectAtIndex:3] != nil))
            {
                cell = [cells objectAtIndex:3];
                if (cell.length != 0)
                {
                    [_femalePost addObject:cell];
                }
            }
            if ((cells.count >= 5) && ([cells objectAtIndex:4] != nil))
            {
                cell = [cells objectAtIndex:4];
                if (cell.length != 0)
                {
                    [_malePre addObject:cell];
                    [_femalePre addObject:cell];
                }
            }
            if ((cells.count >= 6) && ([cells objectAtIndex:5] != nil))
            {
                cell = [cells objectAtIndex:5];
                if (cell.length != 0)
                {
                    [_malePost addObject:cell];
                    [_femalePost addObject:cell];
                }
            }
        }
        
        NSString *namePath = [bundle pathForResource:@"name" ofType:@"csv"];
        NSString *nameFile = [NSString stringWithContentsOfFile:namePath usedEncoding:&encoding error:&error];
        NSArray *nameRows = [[NSArray alloc] initWithArray:[nameFile componentsSeparatedByString:@"\n"]];
        
        for (NSUInteger i = 1; i < [nameRows count]; i++)
        {
            NSArray *cells = [[nameRows objectAtIndex:i] componentsSeparatedByString:@","];
            NSString *cell;
            if ((cells.count >= 1) && ([cells objectAtIndex:0] != nil))
            {
                cell = [cells objectAtIndex:0];
                if (cell.length != 0)
                {
                    [_male addObject:cell];
                }
            }
            if ((cells.count >= 2) && ([cells objectAtIndex:1] != nil))
            {
                cell = [cells objectAtIndex:1];
                if (cell.length != 0)
                {
                    [_female addObject:cell];
                }
            }
            if ((cells.count >= 3) && ([cells objectAtIndex:2] != nil))
            {
                cell = [cells objectAtIndex:2];
                if (cell.length != 0)
                {
                    [_male addObject:cell];
                    [_female addObject:cell];
                }
            }
        }
    }
    return self;
}


#pragma mark -
#pragma mark - Private Helper Methods

- (NSUInteger)random:(NSUInteger)max
{
    return (NSUInteger) floor(arc4random() % max);
}

- (NSString *)getName:(BOOL)generated male:(BOOL)sex prefix:(BOOL)prefix postfix:(BOOL)postfix
{
    NSMutableString *newName = [NSMutableString string];
    
    BOOL preAdded = NO;
    if (prefix && ([self random:100] < PRE_CHANCE))
    {
        [newName appendString:[(sex ? self.malePre : self.femalePre) objectAtIndex:[self random:[(sex ? self.malePre : self.femalePre) count]]]];
        [newName appendString:@" "];
        preAdded = YES;
    }
    
    if (generated && ([self random:100] < GENERATED_CHANCE))
    {
        [newName appendString:[(sex ? self.maleStart : self.femaleStart) objectAtIndex:[self random:[(sex ? self.maleStart : self.femaleStart) count]]]];
        
        if ([self random:100] < VOWEL_CHANCE)
        {
            [newName appendString:[self.vowel objectAtIndex:[self random:[self.vowel count]]]];
        }
        
        if ([self random:100] < MIDDLE1_CHANCE)
        {
            [newName appendString:[(sex ? self.maleMiddle : self.femaleMiddle) objectAtIndex:[self random:[(sex ? self.maleMiddle : self.femaleMiddle) count]]]];
        }
        if ([self random:100] < MIDDLE2_CHANCE)
        {
            [newName appendString:[(sex ? self.maleMiddle : self.femaleMiddle) objectAtIndex:[self random:[(sex ? self.maleMiddle : self.femaleMiddle) count]]]];
        }
        
        [newName appendString:[(sex ? self.maleEnd : self.femaleEnd) objectAtIndex:[self random:[(sex ? self.maleEnd : self.femaleEnd) count]]]];
    }
    else
    {
        [newName appendString:[(sex ? self.male : self.female) objectAtIndex:[self random:[(sex ? self.male : self.female) count]]]];
    }
    
    int postChance = POST_CHANCE;
    if (preAdded) postChance += 50;
    if (postfix && ([self random:100] > postChance))
    {
        [newName appendString:@" "];
        [newName appendString:[(sex ? self.malePost : self.femalePost) objectAtIndex:[self random:[(sex ? self.malePost : self.femalePost) count]]]];
    }
    
    return newName;
}


#pragma mark -
#pragma mark - Public Methods

- (NSString *)randomName
{
    return [self getName:YES male:YES prefix:YES postfix:YES];
}


@end
