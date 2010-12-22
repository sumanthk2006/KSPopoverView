//
//  KSPopoverViewButtonBase.m
//  KSPopoverView
//
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import "KSPopoverViewButtonBase.h"

@implementation KSPopoverViewButtonBase
@synthesize selected=_selected;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
	self.backgroundColor = [UIColor clearColor];
    if (self) {
		NSLog(@"initWithFrame:%@", NSStringFromCGRect(frame));
		_selected = NO;
		_objectsForState = [[NSMutableDictionary alloc] init];
	}
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	NSLog(@"dealloc");
	[_objectsForState release];
    [super dealloc];
}

- (BOOL)handleTouchAtPoint:(CGPoint)point withState:(KSPopoverEventType)type {
	BOOL isIn = [self containsPoint:point];
	BOOL handle = NO;
	if (isIn) {
		// ここでイベント処理
		switch (type) {
			case KSPopoverEventTouchesBegan:
				self.selected = YES;
				[self setNeedsDisplay];
				// Touch downイベントの発生
				handle = NO;
				break;

			case KSPopoverEventTouchesMoved:
				if (self.selected == NO) {
					self.selected = YES;
					[self setNeedsDisplay];
					// Touch downイベントの発生
					handle = NO;
				}
				break;
				
			case KSPopoverEventTouchesEnded:
				self.selected = NO;
				// Touch upイベントの発生
				[self setNeedsDisplay];
				handle = YES;
				break;
				
			default:
				break;
		}
	} else {
		if (type == KSPopoverEventTouchesMoved) {
			if (self.selected == YES) {
				self.selected = NO;
				// Touch cancelledイベントの発生
				[self setNeedsDisplay];
				handle = NO;
			}
		}
	}
	
	return handle;
}

- (void)resetSelected {
	_selected = NO;
}

#pragma mark -
#pragma mark -- protected methods
- (void)setObject:(id)obj forState:(KSPopoverEventType)type {
	[_objectsForState setObject:obj forKey:OBJ_OF(type)];
}
- (id)objectForState:(KSPopoverEventType)type {
	return [_objectsForState objectForKey:OBJ_OF(type)];
}

- (BOOL)containsPoint:(CGPoint)point {
    if (self.hidden==NO && CGRectContainsPoint(self.frame, point)) {
		return YES;
    } else {
		return NO;
	}
}

@end
