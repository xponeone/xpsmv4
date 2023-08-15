#include <iostream>
#include <fstream>
#include <cstring>
#include <vector>
#include <string>
using namespace std;

// vector<char*> split(vector<char> &buffer) {
//     vector<char*> res;
//     char* start = &buffer[0];
//     char* end = start + buffer.size();
//     for (char* ptr = start; ptr != end; ptr++) {
//         if(*ptr == '\0') {
//             res.push_back(start);
//             start = ptr + 1;
//         }
//     }
//     return res;
// }

string main() {
    ifstream fin;
    string TERT;
    string OBJT;
    string POLY;
    string NETW;
    string DEMN;

    fin.open("test.dsf", ios::binary);

    //read HEAD
    fin.seekg(16, ios::beg);
    int32_t HEADLength;
    fin.read(reinterpret_cast<char*>(&HEADLength), 4);

    //read DEFN
    fin.seekg(HEADLength + 16, ios::beg);
    int32_t DEFNLength;
    fin.read(reinterpret_cast<char*>(&DEFNLength), 4);
    cout << "DEFN Size : " << DEFNLength -8 << " Bytes" << endl;

    //read TERT
    fin.seekg(HEADLength + 24, ios::beg);
    int32_t TERTLength;
    fin.read(reinterpret_cast<char*>(&TERTLength), 4);
    cout << "TERT Size : " << TERTLength - 8 << " Bytes" << endl;
    if(TERTLength > 8) {
        fin.seekg(HEADLength + 28, ios::beg);
        vector<char> TERT_raw(TERTLength - 8);
        fin.read(TERT_raw.data(), TERTLength - 8);
        string TERT(TERT_raw.begin(), TERT_raw.end());
    }
    char* arr[10];
    //read OBJT
    fin.seekg(HEADLength + TERTLength + 24, ios::beg);
    int32_t OBJTLength;
    fin.read(reinterpret_cast<char*>(&OBJTLength), 4);
    cout << "OBJT Size : " << OBJTLength - 8 <<  " Bytes" << endl;
    if(OBJTLength > 8) {
        fin.seekg(HEADLength + TERTLength + 28, ios::beg);
        vector<char> OBJT_raw(OBJTLength - 8);
        fin.read(OBJT_raw.data(), OBJTLength - 8);
        string OBJT(OBJT_raw.begin(), OBJT_raw.end());
    }

    //read POLY
    fin.seekg(HEADLength + TERTLength + OBJTLength + 24, ios::beg);
    int32_t POLYLength;
    fin.read(reinterpret_cast<char*>(&POLYLength), 4);
    cout << "POLY Size : " << POLYLength - 8 <<  " Bytes" << endl;
    if(POLYLength > 8) {
        fin.seekg(HEADLength + TERTLength + OBJTLength + 28, ios::beg);
        vector<char> POLY_raw(POLYLength - 8);
        fin.read(POLY_raw.data(), POLYLength - 8);
        string POLY(POLY_raw.begin(), POLY_raw.end());
    }

    //read NETW
    fin.seekg(HEADLength + TERTLength + OBJTLength + POLYLength + 24, ios::beg);
    int32_t NETWLength;
    fin.read(reinterpret_cast<char*>(&NETWLength), 4);
    cout << "NETW Size : " << NETWLength - 8 <<  " Bytes" << endl;
    if(NETWLength > 8) {
        fin.seekg(HEADLength + TERTLength + OBJTLength + POLYLength + 28, ios::beg);
        vector<char> NETW_raw(NETWLength - 8);
        fin.read(NETW_raw.data(), NETWLength - 8);
        string NETW(NETW_raw.begin(), NETW_raw.end());
    }

    //read DEMN
    fin.seekg(HEADLength + TERTLength + OBJTLength + POLYLength + NETWLength + 24, ios::beg);
    int32_t DEMNLength;
    fin.read(reinterpret_cast<char*>(&DEMNLength), 4);
    cout << "DEMN Size : " << DEMNLength - 8 <<  " Bytes" << endl;
    if(DEMNLength > 8) {
        fin.seekg(HEADLength + TERTLength + OBJTLength + POLYLength + NETWLength + 28, ios::beg);
        vector<char> DEMN_raw(DEMNLength - 8);
        fin.read(DEMN_raw.data(), DEMNLength - 8);
        string DEMN(DEMN_raw.begin(), DEMN_raw.end());
    }

    return TERT + OBJT + POLY + NETW + DEMN;
}