#include <iostream>
#include <fstream>
using namespace std;

int main() {
    ifstream fin;
    fin.open("test.lnk", ios::binary);

    fin.seekg(76, ios::beg);
    int16_t IDListSize;
    fin.read(reinterpret_cast<char*>(&IDListSize), 2);
    cout << "IDListSize             : " << IDListSize << endl;

    fin.seekg(IDListSize + 94, ios::beg);
    int32_t LocalBasePathOffset;
    fin.read(reinterpret_cast<char*>(&LocalBasePathOffset), 4);
    cout << "LocalBasePathOffset    : " << LocalBasePathOffset << endl;

    fin.seekg(IDListSize + 102, ios::beg);
    int32_t CommonPathSuffixOffset;
    fin.read(reinterpret_cast<char*>(&CommonPathSuffixOffset), 4);
    cout << "CommonPathSuffixOffset : " << CommonPathSuffixOffset << endl;
    
    cout << "String Length          : " << CommonPathSuffixOffset - LocalBasePathOffset << endl;
    char* path = (char*)malloc(CommonPathSuffixOffset - LocalBasePathOffset);
    
    cout << "String Position        :" << IDListSize + LocalBasePathOffset + 78;
    fin.seekg(IDListSize + LocalBasePathOffset + 78);
    fin.read(path, CommonPathSuffixOffset - LocalBasePathOffset);
    cout << path;
    fin.close();
}
