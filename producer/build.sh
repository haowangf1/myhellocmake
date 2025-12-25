rm -rf build
mkdir build
cd build
cmake -DCMAKE_PREFIX_PATH="C:/AMCAX" -DCMAKE_BUILD_TYPE=Debug  ..
cmake --build . --config Debug

cmake -DCMAKE_PREFIX_PATH="C:/AMCAX" -DCMAKE_BUILD_TYPE=Release  ..
cmake --build . --config Release

# conan install . -of build -s build_type=Debug 

# install the library to the install directory
cmake --install build --config Release --prefix "D:/workspace/hellocmake/producer/build/install"
#CMAKE_INSTALL_PREFIX：安装根目录（前缀）。install(TARGETS ... DESTINATION xxx) 里的 xxx 都是相对于它的。
#cmake --install <build_dir> --prefix <dir>：安装时把前缀改成 <dir>，不需要重新 cmake -S -B 配置
#-DCMAKE_INSTALL_PREFIX=...：在配置阶段写进构建目录的缓存里（CMakeCache.txt），之后默认安装就用它。
#--prefix ...：在安装命令这一次覆盖前缀（对这次生效），不一定改缓存。