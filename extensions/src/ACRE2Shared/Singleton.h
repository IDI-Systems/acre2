#pragma once

template<class T> class TSingleton {
public:
    static T *getInstance() {
        static T obj;
        
        return &obj;
    }
};
