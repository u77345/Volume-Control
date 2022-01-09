//
//  GriffinManager.h
//  Volume Control
//

#import <Foundation/Foundation.h>
#import <IOKit/hid/IOHIDLib.h>

@protocol GriffinManagerDelegate <NSObject>
@optional
- (void)deviceDidConnect:(IOHIDDeviceRef)device;
- (void)deviceDidDisconnect:(IOHIDDeviceRef)device;
- (void)deviceDidChange:(IOHIDValueRef)value;
@end

@interface GriffinManager : NSObject
@property (nonatomic, weak) id<GriffinManagerDelegate> delegate;
@end
