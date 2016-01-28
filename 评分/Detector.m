//
//  Detector.m
//  评分
//
//  Created by ysj on 16/1/27.
//  Copyright © 2016年 newbieYin. All rights reserved.
//

#import "Detector.h"
#import "StudentScore.h"

@implementation Detector
+ (instancetype)sharedDetector{
    static Detector *detector = nil;
    if (!detector) {
        detector = [[Detector alloc] init];
        detector.results = [@{} mutableCopy];
        detector.standardAnswer = @"ABCD";
        detector.ignoredAnswers = @[@2];
    }
    return detector;
}



- (BOOL)detectWithAnswer:(NSString *)stuAnswer{
    
    NSString *name = nil;
    NSString *formatAnswer = nil;
    NSString *answer = nil;
     formatAnswer = [stuAnswer stringByReplacingOccurrencesOfString:@"：" withString:@":"];
    NSArray *infoAndAnswer = [formatAnswer componentsSeparatedByString:@":"];
    
    if (infoAndAnswer.count == 1) {
        NSLog(@"没有名字");
        return NO;
    } else {
        name = infoAndAnswer[0];
        answer = infoAndAnswer[1];
    }
    if (answer.length > self.standardAnswer.length) {
        NSLog(@"答案个数多了%lu个", answer.length - self.standardAnswer.length);
        return NO;
    } else if (answer.length < self.standardAnswer.length){
        NSLog(@"答案个数少了%lu个", -(answer.length - self.standardAnswer.length));
        return NO;
    }
    
    
    [self getResult:answer name:name ignoredAnswers:_ignoredAnswers];
    return YES;
}
- (void)getResult:(NSString *)answer name:(NSString *)name ignoredAnswers:(NSArray*)ignoredAnswers{
    BOOL isIgnoredAnswer;
    NSMutableArray *arr = [@[] mutableCopy];
    for (int i = 0; i < answer.length; i++) {
        isIgnoredAnswer = NO;
        for (NSNumber *num in ignoredAnswers) {
            if ([num intValue] == i + 1) {
                isIgnoredAnswer = YES;
                break;
            }
        }
        if ([answer characterAtIndex:i] != [self.standardAnswer characterAtIndex:i] && !isIgnoredAnswer){
            [arr addObject:@(i +1 )];
        }
    }
    StudentScore *score = [[StudentScore alloc] initWithWrongAnswers:arr];
    [self.results setObject:score forKey:name];
}

@end
