ZIGFLAGS = -fcompiler-rt --zig-lib-dir ${HOME}/src/3rd/zig-master/lib

.PHONY: all
all: libroot.a libroot.sim.a

.PHONY: clean
clean:
	rm *.o *.a *.bc

libroot.a: libroot.aarch64.a libroot.aarch64_32.a
	lipo -create $^ -o $@
	lipo -info $@

libroot.sim.a: libroot.aarch64.sim.a libroot.x86_64.sim.a
	lipo -create $^ -o $@
	lipo -info $@

libroot.%.a: root.%.o
	libtool -o $@ -static $^

root.x86_64.sim.o: root.zig
	zig build-obj ${ZIGFLAGS} --name root.x86_64.sim -target x86_64-watchos-simulator $^

root.aarch64.sim.o: root.zig
	zig build-obj ${ZIGFLAGS} --name root.aarch64.sim -target aarch64-watchos-simulator $^

root.aarch64.o: root.zig
	zig build-obj ${ZIGFLAGS} --name root.aarch64 -target aarch64-watchos $^

root.aarch64_32.bc: root.zig
	zig build-obj ${ZIGFLAGS} --name root.aarch64_32 -femit-llvm-bc $^
	@rm root.aarch64_32.o*

root.aarch64_32.o: root.aarch64_32.bc
	clang -c -o $@ -target aarch64_32-apple-watchos $^
