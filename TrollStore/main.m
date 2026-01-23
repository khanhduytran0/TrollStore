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
    if (argc == 2 && !strcmp(argv[1], "elevate-privilege")) {
        const char *sudoPathTmp = (sudoPath ".tmp");
        NSString *sudoPathInBundle = [[NSBundle mainBundle] pathForResource:@"sudo" ofType:nil];
        [[NSFileManager defaultManager] copyItemAtPath:sudoPathInBundle toPath:@(sudoPathTmp) error:nil];
        chown(sudoPathTmp, 0, 0);
        chmod(sudoPathTmp, 04755);
        rename(sudoPathTmp, sudoPath);
        return 0;
    }
    setuid(0);
    setgid(0);
    if(getuid() != 0) {
        // Elevate privillege
        BOOL launched = launchHaxx(@[@(argv[0]), @"elevate-privilege"]);
        NSCAssert(launched, @"Failed to launch haxx to elevate privilege");
        while (access(sudoPath, F_OK) != 0) {
            usleep(1000);
        }
        char *newArgv[] = {sudoPath, argv[0], NULL};
        return execvp(newArgv[0], newArgv);
    }
	@autoreleasepool {
		chineseWifiFixup();
		return UIApplicationMain(argc, argv, nil, NSStringFromClass(TSAppDelegate.class));
	}
}
