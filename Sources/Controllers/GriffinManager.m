//
//  GriffinManager.m
//  Volume Control
//

#import "GriffinManager.h"

@interface GriffinManager () {
    IOHIDManagerRef _hidManager;
}
@end

@implementation GriffinManager

- (id)init {
    if (self = [super init]) {
        _hidManager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
        NSDictionary *match = @{
                                @(kIOHIDProductIDKey): @(0x0410),
                                @(kIOHIDVendorIDKey): @(0x077d),
                                };
        IOHIDManagerSetDeviceMatching(_hidManager, (__bridge CFDictionaryRef)match);
        IOHIDManagerRegisterDeviceMatchingCallback(_hidManager, connect, (__bridge void*)self);
        IOHIDManagerRegisterDeviceRemovalCallback(_hidManager, disconnect, (__bridge void*)self);
        IOHIDManagerRegisterInputValueCallback(_hidManager, event, (__bridge void*)self);
        IOHIDManagerScheduleWithRunLoop(_hidManager, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);

        // Errors are ignored here
        IOHIDManagerOpen(_hidManager, kIOHIDOptionsTypeNone);
    }
    return self;
}

- (void)dealloc {
    IOHIDManagerClose(_hidManager, kIOHIDOptionsTypeNone);
    CFRelease(_hidManager);
}

#pragma mark - IOHIDManager callbacks

static void connect(void *context, IOReturn result, void *sender, IOHIDDeviceRef device) {
    GriffinManager *self = (__bridge GriffinManager *)context;
    if (self.delegate && [self.delegate respondsToSelector:@selector(deviceDidConnect:)]) {
        [self.delegate deviceDidConnect:device];
    }
}

static void disconnect(void *context, IOReturn result, void *sender, IOHIDDeviceRef device) {
    GriffinManager *self = (__bridge GriffinManager *)context;
    if (self.delegate && [self.delegate respondsToSelector:@selector(deviceDidDisconnect:)]) {
        [self.delegate deviceDidDisconnect:device];
    }
}

static void event(void *context, IOReturn result, void *sender, IOHIDValueRef value) {
    GriffinManager *self = (__bridge GriffinManager *)context;
    if (self.delegate && [self.delegate respondsToSelector:@selector(deviceDidChange:)]) {
        [self.delegate deviceDidChange:value];
    }
}


@end
