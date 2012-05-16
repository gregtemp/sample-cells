//
//  C4WorkSpace.m
//  randomMovement
//
//  Created by Travis Kirton on 12-05-10.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"
#import "TimedShape.h"
#import "MySample.h"
#import "SampleRecorder.h"

@interface C4WorkSpace ()
-(void)divideTimedShape:(NSNotification *)notification;
@end

@implementation C4WorkSpace {
    TimedShape *t;
}

-(void)setup {
    t = [TimedShape new];
    t.fillColor = [UIColor colorWithWhite:0 alpha:0.2];
    t.strokeColor = [UIColor colorWithWhite:0 alpha:0.7];
    t.lineWidth = 2.0f;
    [t ellipse:CGRectMake(self.canvas.frame.size.width/2, self.canvas.frame.size.height/2, 30, 30)];
    [self.canvas addShape:t];
    [t changePosition];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(divideTimedShape:) 
                                                 name:@"timedShapeShouldDivide"
                                               object:nil];
}

-(void)divideTimedShape:(NSNotification *)notification {
    TimedShape *ts = [((TimedShape *)[notification object]) copy];
    [self.canvas addShape:ts];
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    t = [TimedShape new];
    t.fillColor = [UIColor colorWithWhite:0 alpha:0.2];
    t.strokeColor = [UIColor colorWithWhite:0 alpha:0.7];
    t.lineWidth = 2.0f;
    [t ellipse:CGRectMake(self.canvas.frame.size.width/2, self.canvas.frame.size.height/2, 30, 30)];
    [self.canvas addShape:t];
    [t changePosition];
}

@end
