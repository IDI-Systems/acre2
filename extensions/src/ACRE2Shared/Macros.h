#pragma once

#include "_CONSTANTS.h"
#include "Types.h"

#define STR(x) #x

#ifdef _LOCKING_ENABLED

#ifdef _LOCK_TRACE
    #define LOCK(x) TRACE("Locking ["#x"]");x->lock();
    #define UNLOCK(x) TRACE("Unlocking ["#x"]");x->unlock();
    #define LOCK_WRITE(x) TRACE("WRITE Locking ["#x"]");x->lock();
    #define UNLOCK_WRITE(x) TRACE("WRITE Unlocking ["#x"]");x->unlock();
#else
    #define LOCK(x) x->lock();
    #define UNLOCK(x) x->unlock();
    #define LOCK_WRITE(x) x->lock_write();
    #define UNLOCK_WRITE(x) x->unlock_write();
#endif

#else
    #define LOCK(x)
    #define UNLOCK(x)

#endif

#ifndef RELEASE
#define RELEASE(p)      { if (p) { (p)->Release(); (p)=NULL; } }
#endif

#ifndef ARNE_RELEASE
#define ARNE_RELEASE(p)  { if (p) { p->release(); delete p; (p)=NULL; }  }
#endif


#define DECLARE_MEMBER_SET(type, name)                            \
    virtual __inline void set##name(##type value) { this->m_##name = value; }

#define DECLARE_MEMBER_GET(type, name)                            \
    virtual __inline type get##name() { return this->m_##name; }

#define DECLARE_MEMBER_PRIVATE(type, name)                        \
    type m_##name;


#define DECLARE_MEMBER(type, name)                     \
public:                                                \
    DECLARE_MEMBER_SET(type, name)                    \
    DECLARE_MEMBER_GET(type, name)                    \
protected:                                            \
    DECLARE_MEMBER_PRIVATE(type, name)


#define DECLARE_GET_FLAG_MEMBER(type, name)         \
public:                                                \
    type name##() { return this->m_##name; }            \
protected:                                            \
    DECLARE_MEMBER_PRIVATE(type, name)


#define DECLARE_GET_MEMBER(type, name)                \
public:                                                \
    DECLARE_MEMBER_GET(type, name)                    \
protected:                                            \
    DECLARE_MEMBER_PRIVATE(type, name)

#define DECLARE_SET_MEMBER(type, name)                \
public:                                                \
    DECLARE_MEMBER_SET(type, name)                    \
protected:                                            \
    DECLARE_MEMBER_PRIVATE(type, name)


#define DECLARE_INTERFACE_MEMBER_SET(type, name)                \
    virtual void set##name(##type value) = 0;

#define DECLARE_INTERFACE_MEMBER_GET(type, name)                \
    virtual type get##name() = 0;


#define DECLARE_INTERFACE_MEMBER(type, name)                     \
public:                                                            \
    DECLARE_INTERFACE_MEMBER_SET(type, name)                    \
    DECLARE_INTERFACE_MEMBER_GET(type, name)


#define DECLARE_INTERFACE_GET_MEMBER(type, name)    \
public:                                                \
    DECLARE_INTERFACE_MEMBER_GET(type, name)


#define RPC_FUNCTION(name) class name## : public IRpcFunction {                \
public:                                                                        \
    name##(){ this->m_Name = STR(name); }                                    \
    ~##name(){ }                                                            \
    ACRE_RESULT call(IServer *vServer, IMessage *vMessage)


#define CREATE_ITERATOR(type, name, from)                \
    type name = from;                                    \
    type##::iterator iter_##name;

#define DO_ITERATOR(type,name,from)                        \
    CREATE_ITERATOR(type,name,from)                        \
    for (iter_##name = name##.begin();                    \
        iter_##name != name##.end();                    \
        iter_##name++ )

#define WAIT_IF_VALID(handle, wait)        if (handle != INVALID_HANDLE_VALUE) {        \
                                            WaitForSingleObject(handle, wait);        \
                                        }
