.PHONY: all
all: libroot.a libroot.sim.a

libroot.a: libroot.aarch64.a libroot.aarch64_32.a
	lipo -create $^ -o $@
	lipo -info $@

libroot.sim.a: libroot.aarch64.sim.a libroot.x86_64.sim.a
	lipo -create $^ -o $@
	lipo -info $@

libroot.%.a: root.%.o
	libtool -o $@ -static $^

root.x86_64.sim.o: root.zig
	zig build-obj --name root.x86_64.sim -fcompiler-rt -target x86_64-watchos-simulator $^

root.aarch64.sim.o: root.zig
	zig build-obj --name root.aarch64.sim -fcompiler-rt -target aarch64-watchos-simulator $^

root.aarch64.o: root.zig
	zig build-obj --name root.aarch64 -fcompiler-rt -target aarch64-watchos $^

root.aarch64_32.bc: root.zig
	zig build-obj --name root.aarch64_32 -femit-llvm-bc $^
	@rm root.aarch64_32.o*

root.aarch64_32.o: root.aarch64_32.bc
	clang -c -o $@ -target aarch64_32-watchos $^
