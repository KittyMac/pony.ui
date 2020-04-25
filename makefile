build_dir=./build
lib_dir=./lib

yoga_lib_dir=../pony.yoga/lib
bitmap_lib_dir=../pony.bitmap/lib

native_cc=clang
native_ar=ar

all: stub-native copy-libs
	corral run -- ponyc --extfun -p $(lib_dir) -o ./build/ ./ui
	./build/ui

test: stub-native copy-libs
	corral run -- ponyc -V=0 --extfun -p $(lib_dir) -o ./build/ ./ui
	./build/ui


stub-native:
	@mkdir -p $(build_dir)
	@cd $(build_dir)
	@$(native_cc) -arch x86_64 -arch i386 -fPIC -Wall -Wextra -O3 -g -c -o $(build_dir)/renderengine.o stub/*.c
	@lipo -create -output $(lib_dir)/librenderengine-osx.a $(build_dir)/renderengine.o

clean:
	rm -rf $(build_dir)

copy-libs:
	@cp ${bitmap_lib_dir}/*.a $(lib_dir)
	@cp ${yoga_lib_dir}/*.a $(lib_dir)



corral-fetch:
	@corral clean -q
	@corral fetch -q

corral-local:
	-@rm corral.json
	-@rm lock.json
	@corral init -q
	@corral add /Volumes/Development/Development/pony/pony.ttimer -q
	@corral add /Volumes/Development/Development/pony/pony.stringext -q
	@corral add /Volumes/Development/Development/pony/pony.yoga -q
	@corral add /Volumes/Development/Development/pony/pony.utility -q
	@corral add /Volumes/Development/Development/pony/pony.bitmap -q
	@corral add /Volumes/Development/Development/pony/ponylang-linal -q
	@corral add /Volumes/Development/Development/pony/pony.easings -q

corral-git:
	-@rm corral.json
	-@rm lock.json
	@corral init -q
	@corral add github.com/KittyMac/pony.ttimer.git -q
	@corral add github.com/KittyMac/pony.stringext.git -q
	@corral add github.com/KittyMac/pony.yoga.git -q
	@corral add github.com/KittyMac/pony.utility.git -q
	@corral add github.com/KittyMac/pony.bitmap.git -q
	@corral add github.com/KittyMac/ponylang-linal.git -q
	@corral add github.com/KittyMac/pony.easings -q

ci: yoga_lib_dir = ./_corral/github_com_KittyMac_pony_yoga/lib/
ci: bitmap_lib_dir = ./_corral/github_com_KittyMac_pony_bitmap/lib/
ci: corral-git corral-fetch all
	
dev: corral-local corral-fetch all

