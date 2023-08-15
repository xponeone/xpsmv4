#include <iostream>
#include <fstream>
using namespace std;

extern "C" const char* ResolveLnkPath(const char* lnk) {
    ifstream fin;
    fin.open(lnk, ios::binary);
    fin.seekg(76, ios::beg);
    int16_t IDListSize;
    fin.read(reinterpret_cast<char*>(&IDListSize), 2);
    fin.seekg(IDListSize + 94, ios::beg);
    int32_t LocalBasePathOffset;
    fin.read(reinterpret_cast<char*>(&LocalBasePathOffset), 4);
    fin.seekg(IDListSize + 102, ios::beg);
    int32_t CommonPathSuffixOffset;
    fin.read(reinterpret_cast<char*>(&CommonPathSuffixOffset), 4);
    char* path = (char*)malloc(CommonPathSuffixOffset - LocalBasePathOffset - 1);
    fin.seekg(IDListSize + LocalBasePathOffset + 78);
    fin.read(path, CommonPathSuffixOffset - LocalBasePathOffset - 1);
    fin.close();
    return path;
}

//g++ -shared -o shortcut_resolver.dll shortcut_resolver.cpp -lole32 -luuid -lshlwapi