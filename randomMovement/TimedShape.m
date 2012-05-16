//
//  TimedShape.m
//  timedAnimations
//
//  Created by Travis Kirton on 12-05-10.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "TimedShape.h"
#import "MySample.h"
#import "SampleRecorder.h"

@interface TimedShape ()
-(void)startDying;
-(void)newSize;
-(void)startRecord;
-(void)stopRecord;
-(void)startPlay;
-(void)stopPlay;
-(void)volumePanLoop;


@property (readwrite, strong) C4Sample *audioSample;
@property (readwrite, strong) SampleRecorder *sampleRecorder;
@end

@implementation TimedShape {
    BOOL isDying;
    CGFloat myVol;
}
@synthesize audioSample, sampleRecorder;

-(id)initWithTimedShape:(TimedShape *)ts {
    
    self = [super initWithFrame:ts.frame];
    if(self) {
        isDying = NO;
        self.animationDuration = 0.0f;
        [self ellipse: self.frame];
        [self performSelector:@selector(changePosition) withObject:nil afterDelay:0.5];
        [self performSelector:@selector(newSize) withObject:nil afterDelay:0.5];
        self.fillColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.strokeColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.lineWidth = 2.0f;
        self.animationOptions = EASEINOUT;
        CGFloat lifeSpan = ((CGFloat)[C4Math randomInt:100])/5.0f+5.0f;
        [self performSelector:@selector(startDying) withObject:self afterDelay:lifeSpan];
        sampleRecorder = [SampleRecorder new];
        [self performSelector:@selector(startRecord)];
        //[self volumePanLoop];
        
    }
    return self;
}

-(void) newSize {
    int s = (int)[C4Math randomIntBetweenA:10 andB:50];
    [self ellipse:CGRectMake(self.frame.origin.x, self.frame.origin.y, s, s)];
}

-(void)changePosition {
    if([C4Math randomInt:15] < 2 && isDying == NO) {
        [self postNotification:@"timedShapeShouldDivide"];
    }
    
    
    CGFloat time = ((CGFloat) [C4Math randomIntBetweenA:100 andB:400]/100);
    self.animationDuration = time;
    
    NSInteger r = [C4Math randomIntBetweenA:-300 andB:300];
    CGFloat theta = DegreesToRadians([C4Math randomInt:360]);
    self.center = CGPointMake(r*[C4Math cos:theta] + 384, r*[C4Math sin:theta] + 512);
    
    
    [self performSelector:@selector(changePosition) withObject:self afterDelay:time];
}

-(id)copyWithZone:(NSZone *)zone {
   return [[TimedShape alloc] initWithTimedShape:self];
}

-(void)startDying {
    isDying = YES;
    self.animationDuration = ((CGFloat)[C4Math randomInt:70])/10.0f + 2.0f;
    self.fillColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.0f];
    self.strokeColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.0f];
    [self performSelector:@selector(removeFromSuperview) 
               withObject:nil 
               afterDelay:self.animationDuration];
    [self performSelector:@selector(stopPlay) 
               withObject:nil 
               afterDelay:self.animationDuration - 0.5f];
}




-(void)startRecord {
    [sampleRecorder recordSample];
    [self performSelector:@selector(stopRecord) withObject:nil afterDelay:self.frame.size.width/10];    
}

-(void)stopRecord {
    [sampleRecorder stopRecording];
    [self performSelector:@selector(startPlay)];
}

-(void)startPlay {
    self.audioSample = nil;
    self.audioSample = sampleRecorder.sample;
    if(self.audioSample != nil)
        [self.audioSample play];
    self.audioSample.loops = YES;
}

-(void)stopPlay {
    self.audioSample.loops = NO;
}

-(void)volumePanLoop {
    
    if (isDying == NO && myVol < 1.0f){
        myVol = myVol + 0.01f;
    }
    if (isDying == YES && myVol > 0.0f){
        myVol = myVol - 0.01f;
    }
    
    C4Log(@"%d", myVol);
    self.audioSample.volume = myVol;
    self.audioSample.pan = self.center.x;
    [self performSelector:@selector(startRecord) withObject:nil afterDelay:0.1f];
}

@end
