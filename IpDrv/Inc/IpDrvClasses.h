/*===========================================================================
    C++ class definitions exported from UnrealScript.
    This is automatically generated by the tools.
    DO NOT modify this manually! Edit the corresponding .uc files instead!
===========================================================================*/
#if _MSC_VER
#pragma pack (push,4)
#endif

#ifndef IPDRV_API
#define IPDRV_API DLL_IMPORT
#endif

#ifndef NAMES_ONLY
#define AUTOGENERATE_NAME(name) extern IPDRV_API FName IPDRV_##name;
#define AUTOGENERATE_FUNCTION(cls,idx,name)
#endif

AUTOGENERATE_NAME(ReceivedText)
AUTOGENERATE_NAME(ReceivedLine)
AUTOGENERATE_NAME(ReceivedBinary)
AUTOGENERATE_NAME(Resolved)
AUTOGENERATE_NAME(ResolveFailed)
AUTOGENERATE_NAME(Accepted)
AUTOGENERATE_NAME(Opened)
AUTOGENERATE_NAME(Closed)

#ifndef NAMES_ONLY

enum EReceiveMode
{
    RMODE_Manual            =0,
    RMODE_Event             =1,
    RMODE_MAX               =2,
};
enum ELinkMode
{
    MODE_Text               =0,
    MODE_Line               =1,
    MODE_Binary             =2,
    MODE_MAX                =3,
};

struct AInternetLink_eventResolveFailed_Parms
{
};
struct AInternetLink_eventResolved_Parms
{
    FIpAddr Addr;
};
class IPDRV_API AInternetLink : public AInternetInfo
{
public:
    BYTE LinkMode;
    INT Socket;
    INT Port;
    INT RemoteSocket;
    INT PrivateResolveInfo;
    INT DataPending;
    BYTE ReceiveMode;
    DECLARE_FUNCTION(execGetLocalIP);
    DECLARE_FUNCTION(execValidate);
    DECLARE_FUNCTION(execStringToIpAddr);
    DECLARE_FUNCTION(execIpAddrToString);
    DECLARE_FUNCTION(execGetLastError);
    DECLARE_FUNCTION(execResolve);
    DECLARE_FUNCTION(execParseURL);
    DECLARE_FUNCTION(execIsDataPending);
    void eventResolveFailed()
    {
        ProcessEvent(FindFunctionChecked(IPDRV_ResolveFailed),NULL);
    }
    void eventResolved(FIpAddr Addr)
    {
        AInternetLink_eventResolved_Parms Parms;
        Parms.Addr=Addr;
        ProcessEvent(FindFunctionChecked(IPDRV_Resolved),&Parms);
    }
    DECLARE_CLASS(AInternetLink,AInternetInfo,0|CLASS_Transient,IpDrv)
    #include "AInternetLink.h"
};


struct AUdpLink_eventReceivedBinary_Parms
{
    FIpAddr Addr;
    INT Count;
    BYTE B[255];
};
struct AUdpLink_eventReceivedLine_Parms
{
    FIpAddr Addr;
    FString line;
};
struct AUdpLink_eventReceivedText_Parms
{
    FIpAddr Addr;
    FString Text;
};
class IPDRV_API AUdpLink : public AInternetLink
{
public:
    INT BroadcastAddr;
    DECLARE_FUNCTION(execReadBinary);
    DECLARE_FUNCTION(execReadText);
    DECLARE_FUNCTION(execSendBinary);
    DECLARE_FUNCTION(execSendText);
    DECLARE_FUNCTION(execBindPort);
    void eventReceivedBinary(FIpAddr Addr, INT Count, BYTE* B)
    {
        AUdpLink_eventReceivedBinary_Parms Parms;
        Parms.Addr=Addr;
        Parms.Count=Count;
        appMemcpy(&Parms.B,&B,sizeof(Parms.B));
        ProcessEvent(FindFunctionChecked(IPDRV_ReceivedBinary),&Parms);
    }
    void eventReceivedLine(FIpAddr Addr, const FString& line)
    {
        AUdpLink_eventReceivedLine_Parms Parms;
        Parms.Addr=Addr;
        Parms.line=line;
        ProcessEvent(FindFunctionChecked(IPDRV_ReceivedLine),&Parms);
    }
    void eventReceivedText(FIpAddr Addr, const FString& Text)
    {
        AUdpLink_eventReceivedText_Parms Parms;
        Parms.Addr=Addr;
        Parms.Text=Text;
        ProcessEvent(FindFunctionChecked(IPDRV_ReceivedText),&Parms);
    }
    DECLARE_CLASS(AUdpLink,AInternetLink,0|CLASS_Transient,IpDrv)
    #include "AUdpLink.h"
};

enum ELinkState
{
    STATE_Initialized       =0,
    STATE_Ready             =1,
    STATE_Listening         =2,
    STATE_Connecting        =3,
    STATE_Connected         =4,
    STATE_ListenClosePending=5,
    STATE_ConnectClosePending=6,
    STATE_ListenClosing     =7,
    STATE_ConnectClosing    =8,
    STATE_MAX               =9,
};

struct ATcpLink_eventReceivedBinary_Parms
{
    INT Count;
    BYTE B[255];
};
struct ATcpLink_eventReceivedLine_Parms
{
    FString line;
};
struct ATcpLink_eventReceivedText_Parms
{
    FString Text;
};
struct ATcpLink_eventClosed_Parms
{
};
struct ATcpLink_eventOpened_Parms
{
};
struct ATcpLink_eventAccepted_Parms
{
};
class IPDRV_API ATcpLink : public AInternetLink
{
public:
    BYTE LinkState;
    FIpAddr RemoteAddr;
    class UClass* AcceptClass;
    TArray<BYTE> SendFIFO;
    DECLARE_FUNCTION(execReadBinary);
    DECLARE_FUNCTION(execReadText);
    DECLARE_FUNCTION(execSendBinary);
    DECLARE_FUNCTION(execSendText);
    DECLARE_FUNCTION(execIsConnected);
    DECLARE_FUNCTION(execClose);
    DECLARE_FUNCTION(execOpen);
    DECLARE_FUNCTION(execListen);
    DECLARE_FUNCTION(execBindPort);
    void eventReceivedBinary(INT Count, BYTE* B)
    {
        ATcpLink_eventReceivedBinary_Parms Parms;
        Parms.Count=Count;
        appMemcpy(&Parms.B,&B,sizeof(Parms.B));
        ProcessEvent(FindFunctionChecked(IPDRV_ReceivedBinary),&Parms);
    }
    void eventReceivedLine(const FString& line)
    {
        ATcpLink_eventReceivedLine_Parms Parms;
        Parms.line=line;
        ProcessEvent(FindFunctionChecked(IPDRV_ReceivedLine),&Parms);
    }
    void eventReceivedText(const FString& Text)
    {
        ATcpLink_eventReceivedText_Parms Parms;
        Parms.Text=Text;
        ProcessEvent(FindFunctionChecked(IPDRV_ReceivedText),&Parms);
    }
    void eventClosed()
    {
        ProcessEvent(FindFunctionChecked(IPDRV_Closed),NULL);
    }
    void eventOpened()
    {
        ProcessEvent(FindFunctionChecked(IPDRV_Opened),NULL);
    }
    void eventAccepted()
    {
        ProcessEvent(FindFunctionChecked(IPDRV_Accepted),NULL);
    }
    DECLARE_CLASS(ATcpLink,AInternetLink,0|CLASS_Transient,IpDrv)
    #include "ATcpLink.h"
};

#endif

AUTOGENERATE_FUNCTION(AUdpLink,-1,execReadBinary);
AUTOGENERATE_FUNCTION(AUdpLink,-1,execReadText);
AUTOGENERATE_FUNCTION(AUdpLink,-1,execSendBinary);
AUTOGENERATE_FUNCTION(AUdpLink,-1,execSendText);
AUTOGENERATE_FUNCTION(AUdpLink,-1,execBindPort);
AUTOGENERATE_FUNCTION(AInternetLink,-1,execGetLocalIP);
AUTOGENERATE_FUNCTION(AInternetLink,-1,execValidate);
AUTOGENERATE_FUNCTION(AInternetLink,-1,execStringToIpAddr);
AUTOGENERATE_FUNCTION(AInternetLink,-1,execIpAddrToString);
AUTOGENERATE_FUNCTION(AInternetLink,-1,execGetLastError);
AUTOGENERATE_FUNCTION(AInternetLink,-1,execResolve);
AUTOGENERATE_FUNCTION(AInternetLink,-1,execParseURL);
AUTOGENERATE_FUNCTION(AInternetLink,-1,execIsDataPending);
AUTOGENERATE_FUNCTION(ATcpLink,-1,execReadBinary);
AUTOGENERATE_FUNCTION(ATcpLink,-1,execReadText);
AUTOGENERATE_FUNCTION(ATcpLink,-1,execSendBinary);
AUTOGENERATE_FUNCTION(ATcpLink,-1,execSendText);
AUTOGENERATE_FUNCTION(ATcpLink,-1,execIsConnected);
AUTOGENERATE_FUNCTION(ATcpLink,-1,execClose);
AUTOGENERATE_FUNCTION(ATcpLink,-1,execOpen);
AUTOGENERATE_FUNCTION(ATcpLink,-1,execListen);
AUTOGENERATE_FUNCTION(ATcpLink,-1,execBindPort);

#ifndef NAMES_ONLY
#undef AUTOGENERATE_NAME
#undef AUTOGENERATE_FUNCTION
#endif NAMES_ONLY

#if _MSC_VER
#pragma pack (pop)
#endif
