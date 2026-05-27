#import <Foundation/Foundation.h>
#import "TSAppDelegate.h"
#import "TSUtil.h"

#include <sys/stat.h>
#define sudoPath "/private/preboot/Cryptexes/sudo"
BOOL launchHaxx(NSArray *args);

NSUserDefaults* trollStoreUserDefaults(void)
{
	return [[NSUserDefaults alloc] initWithSuiteName:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Preferences/%@.plist", APP_ID]]];
}

int main(int argc, char *argv[]) {
    // Remount /var with suid
    launchHaxx(@[@"/sbin/mount", @"-uw", @"-o", @"suid", @"/var"]);
	@autoreleasepool {
		chineseWifiFixup();
		return UIApplicationMain(argc, argv, nil, NSStringFromClass(TSAppDelegate.class));
	}
}
