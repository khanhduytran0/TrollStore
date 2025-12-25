TARGET = sudo
CC = clang

CFLAGS = -isysroot $(shell xcrun --sdk iphoneos --show-sdk-path) -arch arm64 -arch arm64e -miphoneos-version-min=15.0 -O2

sign: $(TARGET)
	@ldid -Cadhoc -S../TrollStoreLite/entitlements.plist $^

$(TARGET): $(wildcard src/*.m)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

clean:
	@rm -f $(TARGET)
