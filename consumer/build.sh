rm -rf build
mkdir build
cd build
cmake -DCMAKE_PREFIX_PATH="C:/AMCAX" -DCMAKE_BUILD_TYPE=Debug  ..
cmake --build . --config Debug

#告诉find_packge去哪里找config.cmake
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="D:/workspace/hellocmake/producer/build/install" ..
cmake --build . --config Release

