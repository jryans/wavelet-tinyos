#define dbg(mode, format, ...) ((void)0)
#define dbg_clear(mode, format, ...) ((void)0)
#define dbg_active(mode) 0
# 60 "/usr/local/avr/include/inttypes.h"
typedef signed char int8_t;




typedef unsigned char uint8_t;
# 83 "/usr/local/avr/include/inttypes.h" 3
typedef int int16_t;




typedef unsigned int uint16_t;










typedef long int32_t;




typedef unsigned long uint32_t;
#line 117
typedef long long int64_t;




typedef unsigned long long uint64_t;
#line 134
typedef int16_t intptr_t;




typedef uint16_t uintptr_t;
# 213 "/usr/local/lib/gcc-lib/avr/3.3-tinyos/include/stddef.h" 3
typedef unsigned int size_t;
#line 325
typedef int wchar_t;
# 60 "/usr/local/avr/include/stdlib.h"
typedef struct __nesc_unnamed4242 {
  int quot;
  int rem;
} div_t;


typedef struct __nesc_unnamed4243 {
  long quot;
  long rem;
} ldiv_t;


typedef int (*__compar_fn_t)(const void *, const void *);
# 151 "/usr/local/lib/gcc-lib/avr/3.3-tinyos/include/stddef.h" 3
typedef int ptrdiff_t;
# 91 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/tos.h"
typedef unsigned char bool;






enum __nesc_unnamed4244 {
  FALSE = 0, 
  TRUE = 1
};

uint16_t TOS_LOCAL_ADDRESS = 1;

enum __nesc_unnamed4245 {
  FAIL = 0, 
  SUCCESS = 1
};
static inline 

uint8_t rcombine(uint8_t r1, uint8_t r2);
typedef uint8_t  result_t;
static inline 






result_t rcombine(result_t r1, result_t r2);
#line 140
enum __nesc_unnamed4246 {
  NULL = 0x0
};
# 81 "/usr/local/avr/include/avr/pgmspace.h"
typedef void __attribute((__progmem__)) prog_void;
typedef char __attribute((__progmem__)) prog_char;
typedef unsigned char __attribute((__progmem__)) prog_uchar;
typedef int __attribute((__progmem__)) prog_int;
typedef long __attribute((__progmem__)) prog_long;
typedef long long __attribute((__progmem__)) prog_long_long;
# 138 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/avrmote/avrhardware.h"
enum __nesc_unnamed4247 {
  TOSH_period16 = 0x00, 
  TOSH_period32 = 0x01, 
  TOSH_period64 = 0x02, 
  TOSH_period128 = 0x03, 
  TOSH_period256 = 0x04, 
  TOSH_period512 = 0x05, 
  TOSH_period1024 = 0x06, 
  TOSH_period2048 = 0x07
};
static inline 
void TOSH_wait(void);







typedef uint8_t __nesc_atomic_t;

__nesc_atomic_t __nesc_atomic_start(void );
void __nesc_atomic_end(__nesc_atomic_t oldSreg);



__inline __nesc_atomic_t  __nesc_atomic_start(void );






__inline void  __nesc_atomic_end(__nesc_atomic_t oldSreg);
static 





__inline void __nesc_atomic_sleep(void);
static 






__inline void __nesc_enable_interrupt(void);
# 58 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Const.h"
enum __nesc_unnamed4248 {
  CC2420_TIME_BIT = 4, 
  CC2420_TIME_BYTE = CC2420_TIME_BIT << 3, 
  CC2420_TIME_SYMBOL = 16
};









enum __nesc_unnamed4249 {
  CC2420_MIN_CHANNEL = 11, 
  CC2420_MAX_CHANNEL = 26
};
#line 257
enum __nesc_unnamed4250 {
  CP_MAIN = 0, 
  CP_MDMCTRL0, 
  CP_MDMCTRL1, 
  CP_RSSI, 
  CP_SYNCWORD, 
  CP_TXCTRL, 
  CP_RXCTRL0, 
  CP_RXCTRL1, 
  CP_FSCTRL, 
  CP_SECCTRL0, 
  CP_SECCTRL1, 
  CP_BATTMON, 
  CP_IOCFG0, 
  CP_IOCFG1
};
static 
# 101 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
void __inline TOSH_uwait(int u_sec);
#line 116
static __inline void TOSH_SET_RED_LED_PIN(void);
#line 116
static __inline void TOSH_CLR_RED_LED_PIN(void);
#line 116
static __inline void TOSH_MAKE_RED_LED_OUTPUT(void);
static __inline void TOSH_SET_GREEN_LED_PIN(void);
#line 117
static __inline void TOSH_CLR_GREEN_LED_PIN(void);
#line 117
static __inline void TOSH_MAKE_GREEN_LED_OUTPUT(void);
static __inline void TOSH_SET_YELLOW_LED_PIN(void);
#line 118
static __inline void TOSH_CLR_YELLOW_LED_PIN(void);
#line 118
static __inline void TOSH_MAKE_YELLOW_LED_OUTPUT(void);

static __inline void TOSH_CLR_SERIAL_ID_PIN(void);
#line 120
static __inline void TOSH_MAKE_SERIAL_ID_INPUT(void);
static 









void __inline CC2420_FIFOP_INT_MODE(bool LowToHigh);









static __inline void TOSH_SET_CC_RSTN_PIN(void);
#line 141
static __inline void TOSH_CLR_CC_RSTN_PIN(void);
#line 141
static __inline void TOSH_MAKE_CC_RSTN_OUTPUT(void);
static __inline void TOSH_SET_CC_VREN_PIN(void);
#line 142
static __inline void TOSH_MAKE_CC_VREN_OUTPUT(void);

static __inline int TOSH_READ_CC_FIFOP_PIN(void);
static __inline void TOSH_MAKE_CC_FIFOP1_INPUT(void);

static __inline int TOSH_READ_CC_CCA_PIN(void);
#line 147
static __inline void TOSH_MAKE_CC_CCA_INPUT(void);
static __inline int TOSH_READ_CC_SFD_PIN(void);
#line 148
static __inline void TOSH_MAKE_CC_SFD_INPUT(void);
static __inline void TOSH_SET_CC_CS_PIN(void);
#line 149
static __inline void TOSH_CLR_CC_CS_PIN(void);
#line 149
static __inline void TOSH_MAKE_CC_CS_OUTPUT(void);
#line 149
static __inline void TOSH_MAKE_CC_CS_INPUT(void);
static __inline int TOSH_READ_CC_FIFO_PIN(void);
#line 150
static __inline void TOSH_MAKE_CC_FIFO_INPUT(void);

static __inline int TOSH_READ_RADIO_CCA_PIN(void);
#line 152
static __inline void TOSH_MAKE_RADIO_CCA_INPUT(void);


static __inline void TOSH_SET_FLASH_SELECT_PIN(void);
#line 155
static __inline void TOSH_MAKE_FLASH_SELECT_OUTPUT(void);
static __inline void TOSH_MAKE_FLASH_CLK_OUTPUT(void);
static __inline void TOSH_MAKE_FLASH_OUT_OUTPUT(void);




static __inline void TOSH_SET_INT1_PIN(void);
#line 162
static __inline void TOSH_CLR_INT1_PIN(void);
#line 162
static __inline void TOSH_MAKE_INT1_OUTPUT(void);
#line 162
static __inline void TOSH_MAKE_INT1_INPUT(void);
static __inline void TOSH_SET_INT2_PIN(void);
#line 163
static __inline void TOSH_CLR_INT2_PIN(void);
#line 163
static __inline void TOSH_MAKE_INT2_OUTPUT(void);
#line 163
static __inline void TOSH_MAKE_INT2_INPUT(void);



static __inline void TOSH_MAKE_MOSI_OUTPUT(void);
static __inline void TOSH_MAKE_MISO_INPUT(void);

static __inline void TOSH_MAKE_SPI_SCK_OUTPUT(void);


static __inline void TOSH_MAKE_PW0_OUTPUT(void);
static __inline void TOSH_MAKE_PW1_OUTPUT(void);
static __inline void TOSH_MAKE_PW2_OUTPUT(void);
static __inline void TOSH_MAKE_PW3_OUTPUT(void);
static __inline void TOSH_MAKE_PW4_OUTPUT(void);
static __inline void TOSH_MAKE_PW5_OUTPUT(void);
static __inline void TOSH_MAKE_PW6_OUTPUT(void);
static __inline void TOSH_MAKE_PW7_OUTPUT(void);
static inline 
#line 196
void TOSH_SET_PIN_DIRECTIONS(void );
#line 249
enum __nesc_unnamed4251 {
  TOSH_ADC_PORTMAPSIZE = 12
};

enum __nesc_unnamed4252 {


  TOSH_ACTUAL_VOLTAGE_PORT = 30, 
  TOSH_ACTUAL_BANDGAP_PORT = 30, 
  TOSH_ACTUAL_GND_PORT = 31
};

enum __nesc_unnamed4253 {


  TOS_ADC_VOLTAGE_PORT = 7, 
  TOS_ADC_BANDGAP_PORT = 10, 
  TOS_ADC_GND_PORT = 11
};
# 54 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/types/dbg_modes.h"
typedef long long TOS_dbg_mode;



enum __nesc_unnamed4254 {
  DBG_ALL = ~0ULL, 


  DBG_BOOT = 1ULL << 0, 
  DBG_CLOCK = 1ULL << 1, 
  DBG_TASK = 1ULL << 2, 
  DBG_SCHED = 1ULL << 3, 
  DBG_SENSOR = 1ULL << 4, 
  DBG_LED = 1ULL << 5, 
  DBG_CRYPTO = 1ULL << 6, 


  DBG_ROUTE = 1ULL << 7, 
  DBG_AM = 1ULL << 8, 
  DBG_CRC = 1ULL << 9, 
  DBG_PACKET = 1ULL << 10, 
  DBG_ENCODE = 1ULL << 11, 
  DBG_RADIO = 1ULL << 12, 


  DBG_LOG = 1ULL << 13, 
  DBG_ADC = 1ULL << 14, 
  DBG_I2C = 1ULL << 15, 
  DBG_UART = 1ULL << 16, 
  DBG_PROG = 1ULL << 17, 
  DBG_SOUNDER = 1ULL << 18, 
  DBG_TIME = 1ULL << 19, 
  DBG_POWER = 1ULL << 20, 



  DBG_SIM = 1ULL << 21, 
  DBG_QUEUE = 1ULL << 22, 
  DBG_SIMRADIO = 1ULL << 23, 
  DBG_HARD = 1ULL << 24, 
  DBG_MEM = 1ULL << 25, 



  DBG_USR1 = 1ULL << 27, 
  DBG_USR2 = 1ULL << 28, 
  DBG_USR3 = 1ULL << 29, 
  DBG_TEMP = 1ULL << 30, 

  DBG_ERROR = 1ULL << 31, 
  DBG_NONE = 0, 

  DBG_DEFAULT = DBG_ALL
};
# 59 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/sched.c"
typedef struct __nesc_unnamed4255 {
  void (*tp)(void);
} TOSH_sched_entry_T;

enum __nesc_unnamed4256 {






  TOSH_MAX_TASKS = 8, 

  TOSH_TASK_BITMASK = TOSH_MAX_TASKS - 1
};

volatile TOSH_sched_entry_T TOSH_queue[TOSH_MAX_TASKS];
uint8_t TOSH_sched_full;
volatile uint8_t TOSH_sched_free;
static inline 
void TOSH_sched_init(void );








bool TOS_post(void (*tp)(void));
#line 102
bool  TOS_post(void (*tp)(void));
static inline 
#line 136
bool TOSH_run_next_task(void);
static inline 
#line 159
void TOSH_run_task(void);
static inline 
# 159 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/tos.h"
void *nmemset(void *to, int val, size_t n);
# 28 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/Ident.h"
enum __nesc_unnamed4257 {

  IDENT_MAX_PROGRAM_NAME_LENGTH = 16
};

typedef struct __nesc_unnamed4258 {

  uint32_t unix_time;
  uint32_t user_hash;
  char program_name[IDENT_MAX_PROGRAM_NAME_LENGTH];
} Ident_t;
# 50 "SensorMsg.h"
typedef struct SensorMsg {
  uint16_t val[5];
  uint16_t next_addr;
  uint16_t dest_addr;
  uint16_t src;
  uint16_t hops;
  uint16_t msg_type;
} SensorMsg;

enum __nesc_unnamed4259 {
  AM_SENSORMSG = 4
};

enum __nesc_unnamed4260 {
  WAVELET_MSG = 0x0003, 
  SENSOR_MSG = 0x0004
};
# 40 "SimpleCmdMsg.h"
enum __nesc_unnamed4261 {

  AM_SIMPLECMDMSG = 8, 
  AM_LOGMSG = 9
};

enum __nesc_unnamed4262 {

  YELLOW_LED_ON = 1, 
  YELLOW_LED_OFF = 2, 
  GREEN_LED_ON = 3, 
  GREEN_LED_OFF = 4, 
  START_SENSING = 5, 
  WAVELET = 6
};

typedef struct __nesc_unnamed4263 {

  int nsamples;
  uint32_t interval;
} start_sense_args;

typedef struct __nesc_unnamed4264 {

  uint16_t destaddr;
  uint16_t secondarg;
} read_log_args;


typedef struct SimpleCmdMsg {

  int8_t seqno;
  int8_t action;
  uint16_t source;
  uint8_t hop_count;

  union __nesc_unnamed4265 {

    start_sense_args ss_args;
    read_log_args rl_args;
    uint8_t untyped_args[0];
  } args;
} SimpleCmdMsg;


typedef struct LogMsg {

  uint16_t sourceaddr;
  uint8_t log[16];
} LogMsg;
# 50 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/AM.h"
enum __nesc_unnamed4266 {
  TOS_BCAST_ADDR = 0xffff, 
  TOS_UART_ADDR = 0x007e
};
#line 66
enum __nesc_unnamed4267 {
  TOS_DEFAULT_AM_GROUP = 0x7d
};

uint8_t TOS_AM_GROUP = TOS_DEFAULT_AM_GROUP;
#line 92
typedef struct TOS_Msg {


  uint8_t length;
  uint8_t fcfhi;
  uint8_t fcflo;
  uint8_t dsn;
  uint16_t destpan;
  uint16_t addr;
  uint8_t type;
  uint8_t group;
  int8_t data[29];







  uint8_t strength;
  uint8_t lqi;
  bool crc;
  uint8_t ack;
  uint16_t time;
} TOS_Msg;

typedef struct TinySec_Msg {

  uint8_t invalid;
} TinySec_Msg;







enum __nesc_unnamed4268 {

  MSG_HEADER_SIZE = (size_t )& ((struct TOS_Msg *)0)->data - 1, 

  MSG_FOOTER_SIZE = 2, 

  MSG_DATA_SIZE = (size_t )& ((struct TOS_Msg *)0)->strength + sizeof(uint16_t ), 

  DATA_LENGTH = 29, 

  LENGTH_BYTE_NUMBER = (size_t )& ((struct TOS_Msg *)0)->length + 1, 

  TOS_HEADER_SIZE = 5
};

typedef TOS_Msg *TOS_MsgPtr;
# 39 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Timer.h"
enum __nesc_unnamed4269 {
  TIMER_REPEAT = 0, 
  TIMER_ONE_SHOT = 1, 
  NUM_TIMERS = 6
};
# 35 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.h"
enum __nesc_unnamed4270 {
  TOS_ADCSample3750ns = 0, 
  TOS_ADCSample7500ns = 1, 
  TOS_ADCSample15us = 2, 
  TOS_ADCSample30us = 3, 
  TOS_ADCSample60us = 4, 
  TOS_ADCSample120us = 5, 
  TOS_ADCSample240us = 6, 
  TOS_ADCSample480us = 7
};
# 33 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica128/Clock.h"
enum __nesc_unnamed4271 {
  TOS_I1000PS = 32, TOS_S1000PS = 1, 
  TOS_I100PS = 40, TOS_S100PS = 2, 
  TOS_I10PS = 101, TOS_S10PS = 3, 
  TOS_I1024PS = 0, TOS_S1024PS = 3, 
  TOS_I512PS = 1, TOS_S512PS = 3, 
  TOS_I256PS = 3, TOS_S256PS = 3, 
  TOS_I128PS = 7, TOS_S128PS = 3, 
  TOS_I64PS = 15, TOS_S64PS = 3, 
  TOS_I32PS = 31, TOS_S32PS = 3, 
  TOS_I16PS = 63, TOS_S16PS = 3, 
  TOS_I8PS = 127, TOS_S8PS = 3, 
  TOS_I4PS = 255, TOS_S4PS = 3, 
  TOS_I2PS = 15, TOS_S2PS = 7, 
  TOS_I1PS = 31, TOS_S1PS = 7, 
  TOS_I0PS = 0, TOS_S0PS = 0
};
enum __nesc_unnamed4272 {
  DEFAULT_SCALE = 3, DEFAULT_INTERVAL = 127
};
# 45 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/sensorboard.h"
enum __nesc_unnamed4273 {
  TOSH_ACTUAL_PHOTO_PORT = 1, 
  TOSH_ACTUAL_TEMP_PORT = 1, 
  TOSH_ACTUAL_MIC_PORT = 2, 
  TOSH_ACTUAL_ACCEL_X_PORT = 3, 
  TOSH_ACTUAL_ACCEL_Y_PORT = 4, 
  TOSH_ACTUAL_MAG_X_PORT = 6, 
  TOSH_ACTUAL_MAG_Y_PORT = 5
};

enum __nesc_unnamed4274 {
  TOS_ADC_PHOTO_PORT = 1, 
  TOS_ADC_TEMP_PORT = 2, 
  TOS_ADC_MIC_PORT = 3, 
  TOS_ADC_ACCEL_X_PORT = 4, 
  TOS_ADC_ACCEL_Y_PORT = 5, 
  TOS_ADC_MAG_X_PORT = 6, 

  TOS_ADC_MAG_Y_PORT = 8
};

enum __nesc_unnamed4275 {
  TOS_MAG_POT_ADDR = 0, 
  TOS_MIC_POT_ADDR = 1
};



static __inline void TOSH_SET_PHOTO_CTL_PIN(void);
#line 73
static __inline void TOSH_CLR_PHOTO_CTL_PIN(void);
#line 73
static __inline void TOSH_MAKE_PHOTO_CTL_OUTPUT(void);
#line 73
static __inline void TOSH_MAKE_PHOTO_CTL_INPUT(void);
static __inline void TOSH_SET_TEMP_CTL_PIN(void);
#line 74
static __inline void TOSH_CLR_TEMP_CTL_PIN(void);
#line 74
static __inline void TOSH_MAKE_TEMP_CTL_OUTPUT(void);
#line 74
static __inline void TOSH_MAKE_TEMP_CTL_INPUT(void);
# 31 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/avrmote/crc.h"
uint16_t __attribute((__progmem__)) crcTable[256] = { 
0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50a5, 0x60c6, 0x70e7, 
0x8108, 0x9129, 0xa14a, 0xb16b, 0xc18c, 0xd1ad, 0xe1ce, 0xf1ef, 
0x1231, 0x0210, 0x3273, 0x2252, 0x52b5, 0x4294, 0x72f7, 0x62d6, 
0x9339, 0x8318, 0xb37b, 0xa35a, 0xd3bd, 0xc39c, 0xf3ff, 0xe3de, 
0x2462, 0x3443, 0x0420, 0x1401, 0x64e6, 0x74c7, 0x44a4, 0x5485, 
0xa56a, 0xb54b, 0x8528, 0x9509, 0xe5ee, 0xf5cf, 0xc5ac, 0xd58d, 
0x3653, 0x2672, 0x1611, 0x0630, 0x76d7, 0x66f6, 0x5695, 0x46b4, 
0xb75b, 0xa77a, 0x9719, 0x8738, 0xf7df, 0xe7fe, 0xd79d, 0xc7bc, 
0x48c4, 0x58e5, 0x6886, 0x78a7, 0x0840, 0x1861, 0x2802, 0x3823, 
0xc9cc, 0xd9ed, 0xe98e, 0xf9af, 0x8948, 0x9969, 0xa90a, 0xb92b, 
0x5af5, 0x4ad4, 0x7ab7, 0x6a96, 0x1a71, 0x0a50, 0x3a33, 0x2a12, 
0xdbfd, 0xcbdc, 0xfbbf, 0xeb9e, 0x9b79, 0x8b58, 0xbb3b, 0xab1a, 
0x6ca6, 0x7c87, 0x4ce4, 0x5cc5, 0x2c22, 0x3c03, 0x0c60, 0x1c41, 
0xedae, 0xfd8f, 0xcdec, 0xddcd, 0xad2a, 0xbd0b, 0x8d68, 0x9d49, 
0x7e97, 0x6eb6, 0x5ed5, 0x4ef4, 0x3e13, 0x2e32, 0x1e51, 0x0e70, 
0xff9f, 0xefbe, 0xdfdd, 0xcffc, 0xbf1b, 0xaf3a, 0x9f59, 0x8f78, 
0x9188, 0x81a9, 0xb1ca, 0xa1eb, 0xd10c, 0xc12d, 0xf14e, 0xe16f, 
0x1080, 0x00a1, 0x30c2, 0x20e3, 0x5004, 0x4025, 0x7046, 0x6067, 
0x83b9, 0x9398, 0xa3fb, 0xb3da, 0xc33d, 0xd31c, 0xe37f, 0xf35e, 
0x02b1, 0x1290, 0x22f3, 0x32d2, 0x4235, 0x5214, 0x6277, 0x7256, 
0xb5ea, 0xa5cb, 0x95a8, 0x8589, 0xf56e, 0xe54f, 0xd52c, 0xc50d, 
0x34e2, 0x24c3, 0x14a0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405, 
0xa7db, 0xb7fa, 0x8799, 0x97b8, 0xe75f, 0xf77e, 0xc71d, 0xd73c, 
0x26d3, 0x36f2, 0x0691, 0x16b0, 0x6657, 0x7676, 0x4615, 0x5634, 
0xd94c, 0xc96d, 0xf90e, 0xe92f, 0x99c8, 0x89e9, 0xb98a, 0xa9ab, 
0x5844, 0x4865, 0x7806, 0x6827, 0x18c0, 0x08e1, 0x3882, 0x28a3, 
0xcb7d, 0xdb5c, 0xeb3f, 0xfb1e, 0x8bf9, 0x9bd8, 0xabbb, 0xbb9a, 
0x4a75, 0x5a54, 0x6a37, 0x7a16, 0x0af1, 0x1ad0, 0x2ab3, 0x3a92, 
0xfd2e, 0xed0f, 0xdd6c, 0xcd4d, 0xbdaa, 0xad8b, 0x9de8, 0x8dc9, 
0x7c26, 0x6c07, 0x5c64, 0x4c45, 0x3ca2, 0x2c83, 0x1ce0, 0x0cc1, 
0xef1f, 0xff3e, 0xcf5d, 0xdf7c, 0xaf9b, 0xbfba, 0x8fd9, 0x9ff8, 
0x6e17, 0x7e36, 0x4e55, 0x5e74, 0x2e93, 0x3eb2, 0x0ed1, 0x1ef0 };
static inline 

uint16_t crcByte(uint16_t oldCrc, uint8_t byte);
# 39 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.h"
enum __nesc_unnamed4276 {
  RADIO = 0, 
  UART = 1
};
static 
# 12 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/byteorder.h"
__inline int is_host_lsb(void);
static 




__inline uint16_t toLSB16(uint16_t a);
static 



__inline uint16_t fromLSB16(uint16_t a);
# 31 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer1.h"
enum __nesc_unnamed4277 {
  TCLK_CPU_OFF = 0, 
  TCLK_CPU_DIV1 = 1, 
  TCLK_CPU_DIV8 = 2, 
  TCLK_CPU_DIV64 = 3, 
  TCLK_CPU_DIV256 = 4, 
  TCLK_CPU_DIV1024 = 5
};
enum __nesc_unnamed4278 {
  TIMER1_DEFAULT_SCALE = TCLK_CPU_DIV64, 
  TIMER1_DEFAULT_INTERVAL = 255
};
# 43 "CPUMsg.h"
enum __nesc_unnamed4279 {

  BUFFER_SIZE = 3
};

struct CPUMsg {

  uint16_t sourceMoteID;
  uint16_t hops;
  uint16_t data[BUFFER_SIZE];
};

struct CPUResetMsg {
};



enum __nesc_unnamed4280 {
  AM_CPUMSG = 10, 
  AM_CPURESETMSG = 32
};
static  result_t PotM$Pot$init(uint8_t arg_0xa2f8ee8);
static  result_t HPLPotC$Pot$finalise(void);
static  result_t HPLPotC$Pot$decrease(void);
static  result_t HPLPotC$Pot$increase(void);
static  result_t HPLInit$init(void);
static   result_t BasicRoutingM$VoltageADC$dataReady(uint16_t arg_0xa35fe08);
static  TOS_MsgPtr BasicRoutingM$Transceiver$receiveRadio(TOS_MsgPtr arg_0xa33e878);
static  TOS_MsgPtr BasicRoutingM$Transceiver$receiveUart(TOS_MsgPtr arg_0xa33ed28);
static  result_t BasicRoutingM$Transceiver$uartSendDone(TOS_MsgPtr arg_0xa33e248, result_t arg_0xa33e398);
static  result_t BasicRoutingM$Transceiver$radioSendDone(TOS_MsgPtr arg_0xa33bbf8, result_t arg_0xa33bd48);
static  result_t BasicRoutingM$SensorTimer$fired(void);
static  result_t BasicRoutingM$LedOut$outputComplete(result_t arg_0xa323ba0);
static  result_t BasicRoutingM$ProcessCmd$default$done(TOS_MsgPtr arg_0xa35c370, result_t arg_0xa35c4c0);
static  result_t BasicRoutingM$ProcessCmd$execute(TOS_MsgPtr arg_0xa359e58);
static  result_t BasicRoutingM$TempIn$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, uint16_t arg_0xa323568, uint16_t arg_0xa3236c0);
static  result_t BasicRoutingM$RadioIn$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, uint16_t arg_0xa323568, uint16_t arg_0xa3236c0);
static  result_t BasicRoutingM$StdControl$init(void);
static  result_t BasicRoutingM$StdControl$start(void);
static  result_t BasicRoutingM$LightIn$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, uint16_t arg_0xa323568, uint16_t arg_0xa3236c0);
static  result_t SensorToLedsM$SensorOutput$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, uint16_t arg_0xa323568, uint16_t arg_0xa3236c0);
static  result_t SensorToLedsM$StdControl$init(void);
static  result_t SensorToLedsM$StdControl$start(void);
static   result_t LedsC$Leds$yellowOff(void);
static   result_t LedsC$Leds$yellowOn(void);
static   result_t LedsC$Leds$init(void);
static   result_t LedsC$Leds$greenOff(void);
static   result_t LedsC$Leds$redOff(void);
static   result_t LedsC$Leds$redOn(void);
static   result_t LedsC$Leds$greenOn(void);
static   result_t SenseToSensor$LightADC$dataReady(uint16_t arg_0xa35fe08);
static  result_t SenseToSensor$Timer$fired(void);
static  result_t SenseToSensor$StdControl$init(void);
static  result_t SenseToSensor$StdControl$start(void);
static   result_t SenseToSensor$TempADC$dataReady(uint16_t arg_0xa35fe08);
static   result_t TimerM$Clock$fire(void);
static  result_t TimerM$StdControl$init(void);
static  result_t TimerM$StdControl$start(void);
static  result_t TimerM$Timer$default$fired(uint8_t arg_0xa42c588);
static  result_t TimerM$Timer$start(uint8_t arg_0xa42c588, char arg_0xa3459e8, uint32_t arg_0xa345b40);
static  result_t TimerM$Timer$stop(uint8_t arg_0xa42c588);
static   void HPLClock$Clock$setInterval(uint8_t arg_0xa43ab10);
static   uint8_t HPLClock$Clock$readCounter(void);
static   result_t HPLClock$Clock$setRate(char arg_0xa43a010, char arg_0xa43a150);
static   uint8_t HPLClock$Clock$getInterval(void);
static   uint8_t HPLPowerManagementM$PowerManagement$adjustPower(void);
static  result_t PhotoTempM$PhotoTempTimer$fired(void);
static  result_t PhotoTempM$PhotoStdControl$init(void);
static  result_t PhotoTempM$PhotoStdControl$stop(void);
static   result_t PhotoTempM$InternalTempADC$dataReady(uint16_t arg_0xa35fe08);
static  result_t PhotoTempM$TempStdControl$init(void);
static  result_t PhotoTempM$TempStdControl$stop(void);
static   result_t PhotoTempM$ExternalTempADC$getData(void);
static   result_t PhotoTempM$ExternalPhotoADC$getData(void);
static   result_t PhotoTempM$InternalPhotoADC$dataReady(uint16_t arg_0xa35fe08);
static   result_t ADCREFM$HPLADC$dataReady(uint16_t arg_0xa4ebc40);
static   result_t ADCREFM$CalADC$default$dataReady(uint8_t arg_0xa4f09d8, uint16_t arg_0xa35fe08);
static  result_t ADCREFM$ADCControl$bindPort(uint8_t arg_0xa4cbf58, uint8_t arg_0xa4c20b0);
static  result_t ADCREFM$ADCControl$init(void);
static   result_t ADCREFM$ADCControl$manualCalibrate(void);
static   result_t ADCREFM$ADC$getData(uint8_t arg_0xa4f0350);
static   result_t ADCREFM$ADC$default$dataReady(uint8_t arg_0xa4f0350, uint16_t arg_0xa35fe08);
static  result_t ADCREFM$Timer$fired(void);
static   result_t HPLADCM$ADC$bindPort(uint8_t arg_0xa4eaae8, uint8_t arg_0xa4eac30);
static   result_t HPLADCM$ADC$init(void);
static   result_t HPLADCM$ADC$samplePort(uint8_t arg_0xa4eb118);
static  TOS_MsgPtr AMStandard$ReceiveMsg$default$receive(uint8_t arg_0xa5326d0, TOS_MsgPtr arg_0xa54e5d8);
static  result_t AMStandard$ActivityTimer$fired(void);
static  result_t AMStandard$UARTSend$sendDone(TOS_MsgPtr arg_0xa54a868, result_t arg_0xa54a9b8);
static  result_t AMStandard$default$sendDone(void);
static  result_t AMStandard$SendMsg$default$sendDone(uint8_t arg_0xa532118, TOS_MsgPtr arg_0xa536e48, result_t arg_0xa536f98);
static  TOS_MsgPtr AMStandard$UARTReceive$receive(TOS_MsgPtr arg_0xa54e5d8);
static   result_t FramerM$ByteComm$txDone(void);
static   result_t FramerM$ByteComm$txByteReady(bool arg_0xa57d2e0);
static   result_t FramerM$ByteComm$rxByteReady(uint8_t arg_0xa57cb10, bool arg_0xa57cc58, uint16_t arg_0xa57cdb0);
static  result_t FramerM$BareSendMsg$send(TOS_MsgPtr arg_0xa54a350);
static  result_t FramerM$StdControl$init(void);
static  result_t FramerM$StdControl$start(void);
static  result_t FramerM$TokenReceiveMsg$ReflectToken(uint8_t arg_0xa57ea30);
static  TOS_MsgPtr FramerAckM$ReceiveMsg$receive(TOS_MsgPtr arg_0xa54e5d8);
static  TOS_MsgPtr FramerAckM$TokenReceiveMsg$receive(TOS_MsgPtr arg_0xa57e2d0, uint8_t arg_0xa57e418);
static   result_t UARTM$HPLUART$get(uint8_t arg_0xa5e1940);
static   result_t UARTM$HPLUART$putDone(void);
static   result_t UARTM$ByteComm$txByte(uint8_t arg_0xa57c680);
static  result_t UARTM$Control$init(void);
static  result_t UARTM$Control$start(void);
static   result_t HPLUART0M$UART$init(void);
static   result_t HPLUART0M$UART$put(uint8_t arg_0xa5e1440);
static  TOS_MsgPtr TransceiverM$Transceiver$default$receiveRadio(uint8_t arg_0xa5ff370, TOS_MsgPtr arg_0xa33e878);
static  TOS_MsgPtr TransceiverM$Transceiver$requestWrite(uint8_t arg_0xa5ff370);
static  TOS_MsgPtr TransceiverM$Transceiver$default$receiveUart(uint8_t arg_0xa5ff370, TOS_MsgPtr arg_0xa33ed28);
static  result_t TransceiverM$Transceiver$sendUart(uint8_t arg_0xa5ff370, uint8_t arg_0xa33aed0);
static  result_t TransceiverM$Transceiver$default$uartSendDone(uint8_t arg_0xa5ff370, TOS_MsgPtr arg_0xa33e248, result_t arg_0xa33e398);
static  result_t TransceiverM$Transceiver$default$radioSendDone(uint8_t arg_0xa5ff370, TOS_MsgPtr arg_0xa33bbf8, result_t arg_0xa33bd48);
static  result_t TransceiverM$Transceiver$sendRadio(uint8_t arg_0xa5ff370, uint16_t arg_0xa33a780, uint8_t arg_0xa33a8d0);
static  result_t TransceiverM$SendUart$sendDone(TOS_MsgPtr arg_0xa54a868, result_t arg_0xa54a9b8);
static  result_t TransceiverM$SendRadio$sendDone(TOS_MsgPtr arg_0xa54a868, result_t arg_0xa54a9b8);
static  TOS_MsgPtr TransceiverM$ReceiveUart$receive(TOS_MsgPtr arg_0xa54e5d8);
static  TOS_MsgPtr TransceiverM$ReceiveRadio$receive(TOS_MsgPtr arg_0xa54e5d8);
static  result_t TransceiverM$StdControl$init(void);
static  result_t TransceiverM$StdControl$start(void);
static  result_t StateM$State$toIdle(uint8_t arg_0xa61d438);
static  result_t StateM$State$requestState(uint8_t arg_0xa61d438, uint8_t arg_0xa616b08);
static  result_t StateM$StdControl$init(void);
static  result_t StateM$StdControl$start(void);
static  bool PacketFilterM$PacketFilter$filterPacket(TOS_MsgPtr arg_0xa5fb558, uint8_t arg_0xa5fb6a8);
static  result_t CC2420RadioM$SplitControl$default$initDone(void);
static  result_t CC2420RadioM$SplitControl$init(void);
static  result_t CC2420RadioM$SplitControl$default$startDone(void);
static  result_t CC2420RadioM$SplitControl$start(void);
static   result_t CC2420RadioM$FIFOP$fired(void);
static   result_t CC2420RadioM$BackoffTimerJiffy$fired(void);
static  result_t CC2420RadioM$Send$send(TOS_MsgPtr arg_0xa54a350);
static   void CC2420RadioM$RadioReceiveCoordinator$default$startSymbol(uint8_t arg_0xa661070, uint8_t arg_0xa6611b8, TOS_MsgPtr arg_0xa661308);
static   result_t CC2420RadioM$SFD$captured(uint16_t arg_0xa6b0eb0);
static   void CC2420RadioM$RadioSendCoordinator$default$startSymbol(uint8_t arg_0xa661070, uint8_t arg_0xa6611b8, TOS_MsgPtr arg_0xa661308);
static   result_t CC2420RadioM$HPLChipconFIFO$TXFIFODone(uint8_t arg_0xa6934c8, uint8_t *arg_0xa693628);
static   result_t CC2420RadioM$HPLChipconFIFO$RXFIFODone(uint8_t arg_0xa692e38, uint8_t *arg_0xa692f98);
static  result_t CC2420RadioM$StdControl$init(void);
static  result_t CC2420RadioM$StdControl$start(void);
static   int16_t CC2420RadioM$MacBackoff$default$initialBackoff(TOS_MsgPtr arg_0xa685888);
static   int16_t CC2420RadioM$MacBackoff$default$congestionBackoff(TOS_MsgPtr arg_0xa685cb0);
static  result_t CC2420RadioM$CC2420SplitControl$initDone(void);
static  result_t CC2420RadioM$CC2420SplitControl$startDone(void);
static  result_t CC2420ControlM$SplitControl$init(void);
static  result_t CC2420ControlM$SplitControl$start(void);
static   result_t CC2420ControlM$CCA$fired(void);
static   result_t CC2420ControlM$HPLChipconRAM$writeDone(uint16_t arg_0xa6cd938, uint8_t arg_0xa6cda80, uint8_t *arg_0xa6cdbe0);
static   result_t CC2420ControlM$CC2420Control$VREFOn(void);
static   result_t CC2420ControlM$CC2420Control$RxMode(void);
static  result_t CC2420ControlM$CC2420Control$TuneManual(uint16_t arg_0xa666908);
static  result_t CC2420ControlM$CC2420Control$setShortAddress(uint16_t arg_0xa662418);
static   result_t CC2420ControlM$CC2420Control$OscillatorOn(void);
static   uint16_t HPLCC2420M$HPLCC2420$read(uint8_t arg_0xa672bf0);
static   uint8_t HPLCC2420M$HPLCC2420$write(uint8_t arg_0xa6725f8, uint16_t arg_0xa672748);
static   uint8_t HPLCC2420M$HPLCC2420$cmd(uint8_t arg_0xa6721a0);
static   result_t HPLCC2420M$HPLCC2420RAM$write(uint16_t arg_0xa6cd210, uint8_t arg_0xa6cd358, uint8_t *arg_0xa6cd4b8);
static  result_t HPLCC2420M$StdControl$init(void);
static  result_t HPLCC2420M$StdControl$start(void);
static   result_t HPLCC2420FIFOM$HPLCC2420FIFO$writeTXFIFO(uint8_t arg_0xa6927b8, uint8_t *arg_0xa692918);
static   result_t HPLCC2420FIFOM$HPLCC2420FIFO$readRXFIFO(uint8_t arg_0xa692080, uint8_t *arg_0xa6921e0);
static   result_t HPLCC2420InterruptM$FIFO$default$fired(void);
static   result_t HPLCC2420InterruptM$FIFOP$disable(void);
static   result_t HPLCC2420InterruptM$FIFOP$startWait(bool arg_0xa694cc0);
static  result_t HPLCC2420InterruptM$CCATimer$fired(void);
static  result_t HPLCC2420InterruptM$FIFOTimer$fired(void);
static   void HPLCC2420InterruptM$SFDCapture$captured(uint16_t arg_0xa75fea8);
static   result_t HPLCC2420InterruptM$CCA$startWait(bool arg_0xa694cc0);
static   result_t HPLCC2420InterruptM$SFD$disable(void);
static   result_t HPLCC2420InterruptM$SFD$enableCapture(bool arg_0xa6b0988);
static   result_t HPLTimer1M$Timer1$setRate(uint16_t arg_0xa7774a0, char arg_0xa7775e0);
static   result_t HPLTimer1M$Timer1$default$fire(void);
static   uint16_t HPLTimer1M$CaptureT1$getEvent(void);
static   void HPLTimer1M$CaptureT1$enableEvents(void);
static   void HPLTimer1M$CaptureT1$disableEvents(void);
static   void HPLTimer1M$CaptureT1$clearOverflow(void);
static   bool HPLTimer1M$CaptureT1$isOverflowPending(void);
static   void HPLTimer1M$CaptureT1$setEdge(uint8_t arg_0xa75e2f0);
static  result_t HPLTimer1M$StdControl$init(void);
static  result_t HPLTimer1M$StdControl$start(void);
static   uint16_t RandomLFSR$Random$rand(void);
static   result_t RandomLFSR$Random$init(void);
static   result_t TimerJiffyAsyncM$TimerJiffyAsync$setOneShot(uint32_t arg_0xa68cb78);
static   bool TimerJiffyAsyncM$TimerJiffyAsync$isSet(void);
static   result_t TimerJiffyAsyncM$TimerJiffyAsync$stop(void);
static  result_t TimerJiffyAsyncM$StdControl$init(void);
static  result_t TimerJiffyAsyncM$StdControl$start(void);
static   result_t TimerJiffyAsyncM$Timer$fire(void);
static   result_t HPLTimer2$Timer2$setIntervalAndScale(uint8_t arg_0xa43be90, uint8_t arg_0xa438010);
static   void HPLTimer2$Timer2$intDisable(void);
static  TOS_MsgPtr SensorToUARTM$DataMsg$receiveRadio(TOS_MsgPtr arg_0xa33e878);
static  TOS_MsgPtr SensorToUARTM$DataMsg$receiveUart(TOS_MsgPtr arg_0xa33ed28);
static  result_t SensorToUARTM$DataMsg$uartSendDone(TOS_MsgPtr arg_0xa33e248, result_t arg_0xa33e398);
static  result_t SensorToUARTM$DataMsg$radioSendDone(TOS_MsgPtr arg_0xa33bbf8, result_t arg_0xa33bd48);
static  result_t SensorToUARTM$SensorOutput$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, uint16_t arg_0xa323568, uint16_t arg_0xa3236c0);
static  TOS_MsgPtr SensorToUARTM$ResetCounterMsg$receiveRadio(TOS_MsgPtr arg_0xa33e878);
static  TOS_MsgPtr SensorToUARTM$ResetCounterMsg$receiveUart(TOS_MsgPtr arg_0xa33ed28);
static  result_t SensorToUARTM$ResetCounterMsg$uartSendDone(TOS_MsgPtr arg_0xa33e248, result_t arg_0xa33e398);
static  result_t SensorToUARTM$ResetCounterMsg$radioSendDone(TOS_MsgPtr arg_0xa33bbf8, result_t arg_0xa33bd48);
static  result_t SensorToUARTM$StdControl$init(void);
static  result_t SensorToUARTM$StdControl$start(void);
static  result_t SensorToRfmM$SensorOutput$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, uint16_t arg_0xa323568, uint16_t arg_0xa3236c0);
static  TOS_MsgPtr SensorToRfmM$Send$receiveRadio(TOS_MsgPtr arg_0xa33e878);
static  TOS_MsgPtr SensorToRfmM$Send$receiveUart(TOS_MsgPtr arg_0xa33ed28);
static  result_t SensorToRfmM$Send$uartSendDone(TOS_MsgPtr arg_0xa33e248, result_t arg_0xa33e398);
static  result_t SensorToRfmM$Send$radioSendDone(TOS_MsgPtr arg_0xa33bbf8, result_t arg_0xa33bd48);
static  result_t SensorToRfmM$StdControl$init(void);
static  result_t SensorToRfmM$StdControl$start(void);
static  TOS_MsgPtr RfmToSensorM$ReceiveSensorMsg$receiveRadio(TOS_MsgPtr arg_0xa33e878);
static  TOS_MsgPtr RfmToSensorM$ReceiveSensorMsg$receiveUart(TOS_MsgPtr arg_0xa33ed28);
static  result_t RfmToSensorM$ReceiveSensorMsg$uartSendDone(TOS_MsgPtr arg_0xa33e248, result_t arg_0xa33e398);
static  result_t RfmToSensorM$ReceiveSensorMsg$radioSendDone(TOS_MsgPtr arg_0xa33bbf8, result_t arg_0xa33bd48);
static  result_t RfmToSensorM$StdControl$init(void);
static  result_t RfmToSensorM$StdControl$start(void);
static  result_t VoltageM$StdControl$init(void);
static  result_t VoltageM$StdControl$start(void);
static  result_t VoltageM$StdControl$stop(void);
static  
# 47 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/RealMain.nc"
result_t RealMain$hardwareInit(void);
static  
# 78 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Pot.nc"
result_t RealMain$Pot$init(uint8_t arg_0xa2f8ee8);
static  
# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
result_t RealMain$StdControl$init(void);
static  





result_t RealMain$StdControl$start(void);
# 54 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/RealMain.nc"
int   main(void);
static  
# 74 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLPot.nc"
result_t PotM$HPLPot$finalise(void);
static  
#line 59
result_t PotM$HPLPot$decrease(void);
static  






result_t PotM$HPLPot$increase(void);
# 91 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/PotM.nc"
uint8_t PotM$potSetting;
static inline 
void PotM$setPot(uint8_t value);
static inline  
#line 106
result_t PotM$Pot$init(uint8_t initialSetting);
static inline  
# 57 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/HPLPotC.nc"
result_t HPLPotC$Pot$decrease(void);
static inline  







result_t HPLPotC$Pot$increase(void);
static inline  







result_t HPLPotC$Pot$finalise(void);
static inline  
# 57 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/avrmote/HPLInit.nc"
result_t HPLInit$init(void);
static   
# 52 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
result_t BasicRoutingM$VoltageADC$getData(void);
static  
# 61 "SensorOutput.nc"
result_t BasicRoutingM$RadioOut$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, 
uint16_t arg_0xa323568, uint16_t arg_0xa3236c0);
static  
# 61 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
TOS_MsgPtr BasicRoutingM$Transceiver$requestWrite(void);
static  
#line 84
result_t BasicRoutingM$Transceiver$sendRadio(uint16_t arg_0xa33a780, uint8_t arg_0xa33a8d0);
static  
# 61 "SensorOutput.nc"
result_t BasicRoutingM$UARTOut$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, 
uint16_t arg_0xa323568, uint16_t arg_0xa3236c0);
static  
#line 61
result_t BasicRoutingM$LedOut$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, 
uint16_t arg_0xa323568, uint16_t arg_0xa3236c0);
static  
# 53 "ProcessCmd.nc"
result_t BasicRoutingM$ProcessCmd$done(TOS_MsgPtr arg_0xa35c370, result_t arg_0xa35c4c0);
static  
# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
result_t BasicRoutingM$VoltageControl$init(void);
static  





result_t BasicRoutingM$VoltageControl$start(void);
static  






result_t BasicRoutingM$VoltageControl$stop(void);
# 81 "BasicRoutingM.nc"
uint16_t BasicRoutingM$routing_table[21][21] = { { -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }, { 0, -1, 2, 3, 4, 4, 4, 4, 8, 8, 8, 8, 8, 8, 4, 4, 4, 4, 4, 4, 4 }, 
{ 1, 1, -1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }, { 2, 2, 2, -1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2 }, { 1, 1, 1, 1, -1, 5, 6, 6, 1, 1, 1, 1, 1, 1, 6, 6, 6, 6, 6, 6, 6 }, 
{ 1, 1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }, { 4, 4, 4, 4, 4, 4, -1, 7, 4, 4, 4, 4, 4, 4, 7, 7, 7, 7, 7, 7, 7 }, { 6, 6, 6, 6, 6, 6, 6, -1, 6, 6, 6, 6, 6, 6, 14, 14, 14, 14, 14, 14, 14 }, 
{ 1, 1, 1, 1, 1, 1, 1, 1, -1, 9, 9, 9, 9, 9, 1, 1, 1, 1, 1, 1, 1 }, { 8, 8, 8, 8, 8, 8, 8, 8, 8, -1, 10, 11, 11, 11, 8, 8, 8, 8, 8, 8, 8 }, { 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, -1, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9 }, 
{ 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, -1, 12, 12, 8, 8, 8, 8, 8, 8, 8 }, { 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, -1, 13, 11, 11, 11, 11, 11, 11, 11 }, 
{ 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, -1, 12, 12, 12, 12, 12, 12, 12 }, { 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, -1, 15, 15, 15, 15, 15, 15 }, 
{ 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, -1, 16, 16, 16, 16, 16 }, { 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, -1, 17, 17, 17, 17 }, 
{ 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, -1, 18, 18, 18 }, { 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, -1, 19, 19 }, 
{ 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, -1, 20 }, { 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, -1 } };
#line 116
uint16_t BasicRoutingM$node5[3][7][4] = { { { 2, 0, 0, 0 }, { 2, 0, 0, 0 }, { 4, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 } }, { { 2, 0, 0, 0 }, { 3, 0, 0, 0 }, { 15, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 } }, { { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 } } };
double BasicRoutingM$node5_coeff[3][7] = { { 2.000000, 0.128581, 0.128581, 0, 0, 0, 0 }, { 2.000000, 0.079716, 0.123437, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0, 0, 0 } };
#line 131
uint16_t BasicRoutingM$node10[3][7][4] = { { { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 } }, { { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 } }, { { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 }, { 0, 0, 0, 0 } } };
double BasicRoutingM$node10_coeff[3][7] = { { 0, 0, 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0, 0, 0 } };
#line 165
uint16_t BasicRoutingM$wav_dec[21] = { 0, 100, 1, 2, 1, 100, 2, 3, 1, 100, 100, 2, 100, 2, 3, 2, 100, 100, 100, 100, 100 };
double BasicRoutingM$wav_val[21][2] = { { 0, 0 }, { 1, 1 }, { 2, 2 }, { 3, 3 }, { 4, 4 }, { 5, 5 }, { 6, 6 }, { 7, 7 }, { 8, 8 }, { 9, 9 }, { 10, 10 }, { 11, 11 }, { 12, 12 }, { 13, 13 }, { 14, 14 }, { 15, 15 }, { 16, 16 }, { 17, 17 }, { 18, 18 }, { 19, 19 }, { 20, 20 } };


uint16_t BasicRoutingM$local_table[3][7][4];
double BasicRoutingM$local_table_coeff[3][7];

uint8_t BasicRoutingM$wavelet_level = 1;
uint8_t BasicRoutingM$max_wavelet_level = 3;
uint16_t BasicRoutingM$curr_volt;


TOS_MsgPtr BasicRoutingM$tosPtr;
SimpleCmdMsg *BasicRoutingM$cmdMsg;



uint16_t BasicRoutingM$MessagesPending[20][7];
uint16_t BasicRoutingM$MessagesPendingData[20][5];

uint16_t BasicRoutingM$MsgsAlreadySent[5] = { 0, 0, 0, 0, 0 };
uint16_t BasicRoutingM$MsgsAlreadySentLength = 5;
uint16_t BasicRoutingM$CounterTilNextWavelet = 0;

uint16_t BasicRoutingM$CurrentLightVal = 0;
uint16_t BasicRoutingM$CurrentTempVal = 1;

uint16_t BasicRoutingM$SnapshotLightVal = 0;
uint16_t BasicRoutingM$SnapshotTempVal = 0;
static inline 


void BasicRoutingM$assignWavTable(void);
static void BasicRoutingM$arrayAssign(uint16_t assignFrom[3][7][4], uint16_t assignTo[3][7][4]);
static void BasicRoutingM$arrayAssignDouble(double assignFrom[3][7], double assignTo[3][7]);
static result_t BasicRoutingM$newMessage(void);
static void BasicRoutingM$startWaveletLevel(void);
static uint8_t BasicRoutingM$hasReceivedAllValues(void);
static void BasicRoutingM$addWaveletValueToTable(uint16_t hops, uint16_t source, uint16_t measurements0, uint16_t measurements1);
static void BasicRoutingM$delaySendMessage(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type);
static void BasicRoutingM$calculateCoefficient(uint16_t numNeighbors, uint16_t addVal);
static void BasicRoutingM$clearTable(uint16_t numNeighbors);
static inline  void BasicRoutingM$voltTask(void);
static inline  




result_t BasicRoutingM$SensorTimer$fired(void);
static inline  
#line 310
result_t BasicRoutingM$ProcessCmd$execute(TOS_MsgPtr pmsg);
static inline   
#line 398
result_t BasicRoutingM$ProcessCmd$default$done(TOS_MsgPtr pmsg, result_t status);
static inline   









result_t BasicRoutingM$VoltageADC$dataReady(uint16_t data);
static inline  









result_t BasicRoutingM$RadioIn$output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type);
static inline  
#line 519
result_t BasicRoutingM$LightIn$output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type);
static inline  





result_t BasicRoutingM$TempIn$output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type);
static inline  






result_t BasicRoutingM$StdControl$init(void);
static inline  





result_t BasicRoutingM$StdControl$start(void);
static inline  
#line 559
result_t BasicRoutingM$LedOut$outputComplete(result_t success);
static inline  
#line 581
result_t BasicRoutingM$Transceiver$radioSendDone(TOS_MsgPtr m, result_t result);
static inline  









result_t BasicRoutingM$Transceiver$uartSendDone(TOS_MsgPtr m, result_t result);
static inline  








TOS_MsgPtr BasicRoutingM$Transceiver$receiveRadio(TOS_MsgPtr m);
static inline  
#line 654
TOS_MsgPtr BasicRoutingM$Transceiver$receiveUart(TOS_MsgPtr m);
static 
#line 680
result_t BasicRoutingM$newMessage(void);
static 
#line 693
void BasicRoutingM$arrayAssign(uint16_t assignFrom[3][7][4], uint16_t assignTo[3][7][4]);
static 
#line 710
void BasicRoutingM$arrayAssignDouble(double assignFrom[3][7], double assignTo[3][7]);
static inline  
#line 724
void BasicRoutingM$voltTask(void);
static inline 
#line 741
void BasicRoutingM$assignWavTable(void);
static 
#line 855
void BasicRoutingM$startWaveletLevel(void);
static 
#line 892
uint8_t BasicRoutingM$hasReceivedAllValues(void);
static 
#line 910
void BasicRoutingM$addWaveletValueToTable(uint16_t hops, uint16_t source, uint16_t measurements0, uint16_t measurements1);
static 
#line 929
void BasicRoutingM$delaySendMessage(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type);
static 
#line 958
void BasicRoutingM$calculateCoefficient(uint16_t numNeighbors, uint16_t addVal);
static 
#line 991
void BasicRoutingM$clearTable(uint16_t numNeighbors);
static  
# 69 "SensorOutput.nc"
result_t SensorToLedsM$SensorOutput$outputComplete(result_t arg_0xa323ba0);
static   
# 122 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Leds.nc"
result_t SensorToLedsM$Leds$yellowOff(void);
static   
#line 114
result_t SensorToLedsM$Leds$yellowOn(void);
static   
#line 56
result_t SensorToLedsM$Leds$init(void);
static   
#line 97
result_t SensorToLedsM$Leds$greenOff(void);
static   
#line 72
result_t SensorToLedsM$Leds$redOff(void);
static   
#line 64
result_t SensorToLedsM$Leds$redOn(void);
static   
#line 89
result_t SensorToLedsM$Leds$greenOn(void);
static inline  
# 60 "SensorToLedsM.nc"
result_t SensorToLedsM$StdControl$init(void);
static inline  







result_t SensorToLedsM$StdControl$start(void);
static inline  







void SensorToLedsM$outputDone(void);
static  




result_t SensorToLedsM$SensorOutput$output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type);
# 50 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/LedsC.nc"
uint8_t LedsC$ledsOn;

enum LedsC$__nesc_unnamed4281 {
  LedsC$RED_BIT = 1, 
  LedsC$GREEN_BIT = 2, 
  LedsC$YELLOW_BIT = 4
};
static inline   
result_t LedsC$Leds$init(void);
static inline   
#line 72
result_t LedsC$Leds$redOn(void);
static inline   







result_t LedsC$Leds$redOff(void);
static inline   
#line 101
result_t LedsC$Leds$greenOn(void);
static inline   







result_t LedsC$Leds$greenOff(void);
static inline   
#line 130
result_t LedsC$Leds$yellowOn(void);
static inline   







result_t LedsC$Leds$yellowOff(void);
static   
# 52 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
result_t SenseToSensor$LightADC$getData(void);
static  
# 73 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Timer.nc"
result_t SenseToSensor$SensorTimer$fired(void);
static  
# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
result_t SenseToSensor$LightControl$init(void);
static  
#line 78
result_t SenseToSensor$LightControl$stop(void);
static  
# 59 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Timer.nc"
result_t SenseToSensor$Timer$start(char arg_0xa3459e8, uint32_t arg_0xa345b40);
static  
# 61 "SensorOutput.nc"
result_t SenseToSensor$TempOutput$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, 
uint16_t arg_0xa323568, uint16_t arg_0xa3236c0);
static  
# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
result_t SenseToSensor$TempControl$init(void);
static  
#line 78
result_t SenseToSensor$TempControl$stop(void);
static  
# 61 "SensorOutput.nc"
result_t SenseToSensor$LightOutput$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, 
uint16_t arg_0xa323568, uint16_t arg_0xa3236c0);
static   
# 52 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
result_t SenseToSensor$TempADC$getData(void);
# 78 "SenseToSensor.nc"
uint16_t SenseToSensor$curr_temp;
uint16_t SenseToSensor$curr_light;
uint8_t SenseToSensor$lsb_data;
uint8_t SenseToSensor$msb_data;
uint16_t SenseToSensor$counter = 0;
static inline  
result_t SenseToSensor$StdControl$init(void);
static inline  








result_t SenseToSensor$StdControl$start(void);
static inline  
#line 108
void SenseToSensor$tempTask(void);
static inline  








void SenseToSensor$lightTask(void);
static inline  








result_t SenseToSensor$Timer$fired(void);
static inline   
#line 147
result_t SenseToSensor$TempADC$dataReady(uint16_t data);
static inline   
#line 162
result_t SenseToSensor$LightADC$dataReady(uint16_t data);
static   
# 41 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/PowerManagement.nc"
uint8_t TimerM$PowerManagement$adjustPower(void);
static   
# 105 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Clock.nc"
void TimerM$Clock$setInterval(uint8_t arg_0xa43ab10);
static   
#line 153
uint8_t TimerM$Clock$readCounter(void);
static   
#line 96
result_t TimerM$Clock$setRate(char arg_0xa43a010, char arg_0xa43a150);
static   
#line 121
uint8_t TimerM$Clock$getInterval(void);
static  
# 73 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Timer.nc"
result_t TimerM$Timer$fired(
# 49 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/TimerM.nc"
uint8_t arg_0xa42c588);









uint32_t TimerM$mState;
uint8_t TimerM$setIntervalFlag;
uint8_t TimerM$mScale;
#line 61
uint8_t TimerM$mInterval;
int8_t TimerM$queue_head;
int8_t TimerM$queue_tail;
uint8_t TimerM$queue_size;
uint8_t TimerM$queue[NUM_TIMERS];
volatile uint16_t TimerM$interval_outstanding;

struct TimerM$timer_s {
  uint8_t type;
  int32_t ticks;
  int32_t ticksLeft;
} TimerM$mTimerList[NUM_TIMERS];

enum TimerM$__nesc_unnamed4282 {
  TimerM$maxTimerInterval = 230
};
static  result_t TimerM$StdControl$init(void);
static inline  








result_t TimerM$StdControl$start(void);
static  









result_t TimerM$Timer$start(uint8_t id, char type, 
uint32_t interval);
#line 129
static void TimerM$adjustInterval(void);
static  
#line 168
result_t TimerM$Timer$stop(uint8_t id);
static inline   
#line 182
result_t TimerM$Timer$default$fired(uint8_t id);
static inline 


void TimerM$enqueue(uint8_t value);
static inline 






uint8_t TimerM$dequeue(void);
static inline  








void TimerM$signalOneTimer(void);
static inline  




void TimerM$HandleFire(void);
static inline   
#line 253
result_t TimerM$Clock$fire(void);
static   
# 180 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Clock.nc"
result_t HPLClock$Clock$fire(void);
# 54 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica/HPLClock.nc"
uint8_t HPLClock$set_flag;
uint8_t HPLClock$mscale;
#line 55
uint8_t HPLClock$nextScale;
#line 55
uint8_t HPLClock$minterval;
static inline   
#line 87
void HPLClock$Clock$setInterval(uint8_t value);
static inline   








uint8_t HPLClock$Clock$getInterval(void);
static inline   
#line 134
uint8_t HPLClock$Clock$readCounter(void);
static inline   
#line 149
result_t HPLClock$Clock$setRate(char interval, char scale);
#line 167
void __attribute((interrupt))   __vector_15(void);
 
# 51 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/HPLPowerManagementM.nc"
int8_t HPLPowerManagementM$disableCount = 1;
uint8_t HPLPowerManagementM$powerLevel;

enum HPLPowerManagementM$__nesc_unnamed4283 {
  HPLPowerManagementM$IDLE = 0, 
  HPLPowerManagementM$ADC_NR = 1 << 3, 
  HPLPowerManagementM$POWER_DOWN = 1 << 4, 
  HPLPowerManagementM$POWER_SAVE = (1 << 3) + (1 << 4), 
  HPLPowerManagementM$STANDBY = (1 << 2) + (1 << 4), 
  HPLPowerManagementM$EXT_STANDBY = (1 << 3) + (1 << 4) + (1 << 2)
};
static inline 

uint8_t HPLPowerManagementM$getPowerLevel(void);
static inline  
#line 85
void HPLPowerManagementM$doAdjustment(void);
static   
#line 102
uint8_t HPLPowerManagementM$PowerManagement$adjustPower(void);
static  
# 59 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Timer.nc"
result_t PhotoTempM$PhotoTempTimer$start(char arg_0xa3459e8, uint32_t arg_0xa345b40);
static  







result_t PhotoTempM$PhotoTempTimer$stop(void);
static   
# 52 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
result_t PhotoTempM$InternalTempADC$getData(void);
static  
# 116 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCControl.nc"
result_t PhotoTempM$ADCControl$bindPort(uint8_t arg_0xa4cbf58, uint8_t arg_0xa4c20b0);
static  
#line 77
result_t PhotoTempM$ADCControl$init(void);
static  
# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
result_t PhotoTempM$TimerControl$init(void);
static   
# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
result_t PhotoTempM$ExternalTempADC$dataReady(uint16_t arg_0xa35fe08);
static   
#line 70
result_t PhotoTempM$ExternalPhotoADC$dataReady(uint16_t arg_0xa35fe08);
static   
#line 52
result_t PhotoTempM$InternalPhotoADC$getData(void);
# 117 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/PhotoTempM.nc"
enum PhotoTempM$__nesc_unnamed4284 {
  PhotoTempM$sensorIdle = 0, 
  PhotoTempM$sensorPhotoStarting, 
  PhotoTempM$sensorPhotoReady, 
  PhotoTempM$sensorTempStarting, 
  PhotoTempM$sensorTempReady
} PhotoTempM$hardwareStatus;



typedef enum PhotoTempM$__nesc_unnamed4285 {
  PhotoTempM$stateIdle = 0, 
  PhotoTempM$stateReadOnce, 
  PhotoTempM$stateContinuous
} PhotoTempM$SensorState_t;
PhotoTempM$SensorState_t PhotoTempM$photoSensor;
PhotoTempM$SensorState_t PhotoTempM$tempSensor;




bool PhotoTempM$waitingForSample;

uint8_t PhotoTempM$gDDRE;
#line 140
uint8_t PhotoTempM$gPORTE;
static inline  
result_t PhotoTempM$PhotoStdControl$init(void);
static inline  
#line 162
result_t PhotoTempM$PhotoStdControl$stop(void);
static inline  








result_t PhotoTempM$TempStdControl$init(void);
static inline  
#line 193
result_t PhotoTempM$TempStdControl$stop(void);
static  









void PhotoTempM$getSample(void);
static inline  
#line 312
result_t PhotoTempM$PhotoTempTimer$fired(void);
static inline   
#line 350
result_t PhotoTempM$ExternalPhotoADC$getData(void);
static inline   






result_t PhotoTempM$ExternalTempADC$getData(void);
static inline   
#line 378
result_t PhotoTempM$InternalPhotoADC$dataReady(uint16_t data);
static inline   
#line 400
result_t PhotoTempM$InternalTempADC$dataReady(uint16_t data);
static   
# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLADC.nc"
result_t ADCREFM$HPLADC$bindPort(uint8_t arg_0xa4eaae8, uint8_t arg_0xa4eac30);
static   
#line 54
result_t ADCREFM$HPLADC$init(void);
static   
#line 77
result_t ADCREFM$HPLADC$samplePort(uint8_t arg_0xa4eb118);
static   
# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
result_t ADCREFM$CalADC$dataReady(
# 67 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCREFM.nc"
uint8_t arg_0xa4f09d8, 
# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
uint16_t arg_0xa35fe08);
static   
#line 70
result_t ADCREFM$ADC$dataReady(
# 66 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCREFM.nc"
uint8_t arg_0xa4f0350, 
# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
uint16_t arg_0xa35fe08);
# 80 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCREFM.nc"
enum ADCREFM$__nesc_unnamed4286 {
  ADCREFM$IDLE = 0, 
  ADCREFM$SINGLE_CONVERSION = 1, 
  ADCREFM$CONTINUOUS_CONVERSION = 2
};

uint16_t ADCREFM$ReqPort;
uint16_t ADCREFM$ReqVector;
uint16_t ADCREFM$ContReqMask;
uint16_t ADCREFM$CalReqMask;
uint32_t ADCREFM$RefVal;
static inline  
void ADCREFM$CalTask(void);
static  





result_t ADCREFM$ADCControl$init(void);
static inline  
#line 114
result_t ADCREFM$ADCControl$bindPort(uint8_t port, uint8_t adcPort);
static inline    


result_t ADCREFM$ADC$default$dataReady(uint8_t port, uint16_t data);
static inline    


result_t ADCREFM$CalADC$default$dataReady(uint8_t port, uint16_t data);
static inline  


result_t ADCREFM$Timer$fired(void);
static inline   





result_t ADCREFM$HPLADC$dataReady(uint16_t data);
static 
#line 197
result_t ADCREFM$startGet(uint8_t port);
static inline   
#line 220
result_t ADCREFM$ADC$getData(uint8_t port);
static inline   
#line 282
result_t ADCREFM$ADCControl$manualCalibrate(void);
static   
# 99 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLADC.nc"
result_t HPLADCM$ADC$dataReady(uint16_t arg_0xa4ebc40);
# 60 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLADCM.nc"
bool HPLADCM$init_portmap_done;
uint8_t HPLADCM$TOSH_adc_portmap[TOSH_ADC_PORTMAPSIZE];
static 
void HPLADCM$init_portmap(void);
static inline   
#line 90
result_t HPLADCM$ADC$init(void);
static   
#line 110
result_t HPLADCM$ADC$bindPort(uint8_t port, uint8_t adcPort);
static   
#line 122
result_t HPLADCM$ADC$samplePort(uint8_t port);
#line 144
void __attribute((signal))   __vector_21(void);
static  
# 75 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
TOS_MsgPtr AMStandard$ReceiveMsg$receive(
# 56 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/AMStandard.nc"
uint8_t arg_0xa5326d0, 
# 75 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
TOS_MsgPtr arg_0xa54e5d8);
static  
# 65 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/AMStandard.nc"
result_t AMStandard$sendDone(void);
static  
# 49 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
result_t AMStandard$SendMsg$sendDone(
# 55 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/AMStandard.nc"
uint8_t arg_0xa532118, 
# 49 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
TOS_MsgPtr arg_0xa536e48, result_t arg_0xa536f98);
# 81 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/AMStandard.nc"
bool AMStandard$state;

uint16_t AMStandard$lastCount;
uint16_t AMStandard$counter;
static inline 
#line 132
void AMStandard$dbgPacket(TOS_MsgPtr data);
static inline 









result_t AMStandard$reportSendDone(TOS_MsgPtr msg, result_t success);
static inline  






result_t AMStandard$ActivityTimer$fired(void);
static inline   




result_t AMStandard$SendMsg$default$sendDone(uint8_t id, TOS_MsgPtr msg, result_t success);
static inline   

result_t AMStandard$default$sendDone(void);
static inline  
#line 207
result_t AMStandard$UARTSend$sendDone(TOS_MsgPtr msg, result_t success);







TOS_MsgPtr   received(TOS_MsgPtr packet);
static inline   
#line 242
TOS_MsgPtr AMStandard$ReceiveMsg$default$receive(uint8_t id, TOS_MsgPtr msg);
static  


TOS_MsgPtr AMStandard$UARTReceive$receive(TOS_MsgPtr packet);
static  
# 75 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
TOS_MsgPtr FramerM$ReceiveMsg$receive(TOS_MsgPtr arg_0xa54e5d8);
static   
# 55 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
result_t FramerM$ByteComm$txByte(uint8_t arg_0xa57c680);
static  
# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
result_t FramerM$ByteControl$init(void);
static  





result_t FramerM$ByteControl$start(void);
static  
# 67 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
result_t FramerM$BareSendMsg$sendDone(TOS_MsgPtr arg_0xa54a868, result_t arg_0xa54a9b8);
static  
# 75 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/TokenReceiveMsg.nc"
TOS_MsgPtr FramerM$TokenReceiveMsg$receive(TOS_MsgPtr arg_0xa57e2d0, uint8_t arg_0xa57e418);
# 82 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/FramerM.nc"
enum FramerM$__nesc_unnamed4287 {
  FramerM$HDLC_QUEUESIZE = 2, 

  FramerM$HDLC_MTU = sizeof(TOS_Msg ) - 5, 



  FramerM$HDLC_FLAG_BYTE = 0x7e, 
  FramerM$HDLC_CTLESC_BYTE = 0x7d, 
  FramerM$PROTO_ACK = 64, 
  FramerM$PROTO_PACKET_ACK = 65, 
  FramerM$PROTO_PACKET_NOACK = 66, 
  FramerM$PROTO_UNKNOWN = 255
};

enum FramerM$__nesc_unnamed4288 {
  FramerM$RXSTATE_NOSYNC, 
  FramerM$RXSTATE_PROTO, 
  FramerM$RXSTATE_TOKEN, 
  FramerM$RXSTATE_INFO, 
  FramerM$RXSTATE_ESC
};

enum FramerM$__nesc_unnamed4289 {
  FramerM$TXSTATE_IDLE, 
  FramerM$TXSTATE_PROTO, 
  FramerM$TXSTATE_INFO, 
  FramerM$TXSTATE_ESC, 
  FramerM$TXSTATE_FCS1, 
  FramerM$TXSTATE_FCS2, 
  FramerM$TXSTATE_ENDFLAG, 
  FramerM$TXSTATE_FINISH, 
  FramerM$TXSTATE_ERROR
};

enum FramerM$__nesc_unnamed4290 {
  FramerM$FLAGS_TOKENPEND = 0x2, 
  FramerM$FLAGS_DATAPEND = 0x4, 
  FramerM$FLAGS_UNKNOWN = 0x8
};

TOS_Msg FramerM$gMsgRcvBuf[FramerM$HDLC_QUEUESIZE];

typedef struct FramerM$_MsgRcvEntry {
  uint8_t Proto;
  uint8_t Token;
  uint16_t Length;
  TOS_MsgPtr pMsg;
} FramerM$MsgRcvEntry_t;

FramerM$MsgRcvEntry_t FramerM$gMsgRcvTbl[FramerM$HDLC_QUEUESIZE];

uint8_t *FramerM$gpRxBuf;
uint8_t *FramerM$gpTxBuf;

uint8_t FramerM$gFlags;
 

uint8_t FramerM$gTxState;
 uint8_t FramerM$gPrevTxState;
 uint8_t FramerM$gTxProto;
 uint16_t FramerM$gTxByteCnt;
 uint16_t FramerM$gTxLength;
 uint16_t FramerM$gTxRunningCRC;


uint8_t FramerM$gRxState;
uint8_t FramerM$gRxHeadIndex;
uint8_t FramerM$gRxTailIndex;
uint16_t FramerM$gRxByteCnt;

uint16_t FramerM$gRxRunningCRC;

TOS_MsgPtr FramerM$gpTxMsg;
uint8_t FramerM$gTxTokenBuf;
uint8_t FramerM$gTxUnknownBuf;
 uint8_t FramerM$gTxEscByte;
static  
void FramerM$PacketSent(void);
static 
uint8_t FramerM$fRemapRxPos(uint8_t InPos);
static 





uint8_t FramerM$fRemapRxPos(uint8_t InPos);
static 
#line 184
result_t FramerM$StartTx(void);
static inline  
#line 244
void FramerM$PacketUnknown(void);
static inline  






void FramerM$PacketRcvd(void);
static  
#line 291
void FramerM$PacketSent(void);
static 
#line 313
void FramerM$HDLCInitialize(void);
static inline  
#line 336
result_t FramerM$StdControl$init(void);
static inline  



result_t FramerM$StdControl$start(void);
static inline  








result_t FramerM$BareSendMsg$send(TOS_MsgPtr pMsg);
static inline  
#line 373
result_t FramerM$TokenReceiveMsg$ReflectToken(uint8_t Token);
static   
#line 393
result_t FramerM$ByteComm$rxByteReady(uint8_t data, bool error, uint16_t strength);
static 
#line 520
result_t FramerM$TxArbitraryByte(uint8_t inByte);
static inline   
#line 533
result_t FramerM$ByteComm$txByteReady(bool LastByteSuccess);
static inline   
#line 611
result_t FramerM$ByteComm$txDone(void);
static  
# 75 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
TOS_MsgPtr FramerAckM$ReceiveCombined$receive(TOS_MsgPtr arg_0xa54e5d8);
static  
# 88 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/TokenReceiveMsg.nc"
result_t FramerAckM$TokenReceiveMsg$ReflectToken(uint8_t arg_0xa57ea30);
# 72 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/FramerAckM.nc"
uint8_t FramerAckM$gTokenBuf;
static inline  
void FramerAckM$SendAckTask(void);
static inline  



TOS_MsgPtr FramerAckM$TokenReceiveMsg$receive(TOS_MsgPtr Msg, uint8_t token);
static inline  
#line 91
TOS_MsgPtr FramerAckM$ReceiveMsg$receive(TOS_MsgPtr Msg);
static   
# 62 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLUART.nc"
result_t UARTM$HPLUART$init(void);
static   
#line 80
result_t UARTM$HPLUART$put(uint8_t arg_0xa5e1440);
static   
# 83 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
result_t UARTM$ByteComm$txDone(void);
static   
#line 75
result_t UARTM$ByteComm$txByteReady(bool arg_0xa57d2e0);
static   
#line 66
result_t UARTM$ByteComm$rxByteReady(uint8_t arg_0xa57cb10, bool arg_0xa57cc58, uint16_t arg_0xa57cdb0);
# 58 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/UARTM.nc"
bool UARTM$state;
static inline  
result_t UARTM$Control$init(void);
static inline  






result_t UARTM$Control$start(void);
static inline   







result_t UARTM$HPLUART$get(uint8_t data);
static   








result_t UARTM$HPLUART$putDone(void);
static   
#line 110
result_t UARTM$ByteComm$txByte(uint8_t data);
static   
# 88 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLUART.nc"
result_t HPLUART0M$UART$get(uint8_t arg_0xa5e1940);
static   






result_t HPLUART0M$UART$putDone(void);
static   
# 60 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/HPLUART0M.nc"
result_t HPLUART0M$UART$init(void);
#line 90
void __attribute((signal))   __vector_18(void);









void __attribute((interrupt))   __vector_20(void);
static inline   



result_t HPLUART0M$UART$put(uint8_t data);
static  
# 133 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
TOS_MsgPtr TransceiverM$Transceiver$receiveRadio(
# 96 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
uint8_t arg_0xa5ff370, 
# 133 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
TOS_MsgPtr arg_0xa33e878);
static  





TOS_MsgPtr TransceiverM$Transceiver$receiveUart(
# 96 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
uint8_t arg_0xa5ff370, 
# 140 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
TOS_MsgPtr arg_0xa33ed28);
static  
#line 126
result_t TransceiverM$Transceiver$uartSendDone(
# 96 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
uint8_t arg_0xa5ff370, 
# 126 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
TOS_MsgPtr arg_0xa33e248, result_t arg_0xa33e398);
static  
#line 118
result_t TransceiverM$Transceiver$radioSendDone(
# 96 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
uint8_t arg_0xa5ff370, 
# 118 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
TOS_MsgPtr arg_0xa33bbf8, result_t arg_0xa33bd48);
static  
# 42 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/PacketFilter.nc"
bool TransceiverM$PacketFilter$filterPacket(TOS_MsgPtr arg_0xa5fb558, uint8_t arg_0xa5fb6a8);
static  
# 58 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
result_t TransceiverM$SendUart$send(TOS_MsgPtr arg_0xa54a350);
static  
#line 58
result_t TransceiverM$SendRadio$send(TOS_MsgPtr arg_0xa54a350);
static  
# 50 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/State/State.nc"
result_t TransceiverM$SendState$toIdle(void);
static  
#line 39
result_t TransceiverM$SendState$requestState(uint8_t arg_0xa616b08);
static  









result_t TransceiverM$WriteState$toIdle(void);
static  
#line 39
result_t TransceiverM$WriteState$requestState(uint8_t arg_0xa616b08);
# 112 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
struct TransceiverM$msg {

  TOS_Msg tosMsg;


  uint8_t sendMethod;


  uint8_t state;
} TransceiverM$msg[6];


uint8_t TransceiverM$nextWriteMsg;


uint8_t TransceiverM$nextSendMsg;



enum TransceiverM$__nesc_unnamed4291 {

  TransceiverM$S_IDLE = 0, 


  TransceiverM$S_WRITING = 10, 


  TransceiverM$S_SENDING = 20
};


enum TransceiverM$__nesc_unnamed4292 {

  TransceiverM$MSG_S_CANWRITE, 


  TransceiverM$MSG_S_WRITING, 


  TransceiverM$MSG_S_CANSEND, 


  TransceiverM$MSG_S_SENDING
};
static 


result_t TransceiverM$pack(uint8_t type, uint16_t dest, uint8_t payloadSize, 
uint8_t outMethod);
static 

void TransceiverM$requestNextSend(void);
static inline 




void TransceiverM$advanceSendIndex(void);
static inline 

void TransceiverM$advanceWriteIndex(void);
static 

void TransceiverM$sendDone(void);
static  


void TransceiverM$sendMsg(void);
static  

result_t TransceiverM$StdControl$init(void);
static inline  








result_t TransceiverM$StdControl$start(void);
static  
#line 218
TOS_MsgPtr TransceiverM$Transceiver$requestWrite(uint8_t type);
static inline  
#line 268
result_t TransceiverM$Transceiver$sendRadio(uint8_t type, uint16_t dest, 
uint8_t payloadSize);
static inline  









result_t TransceiverM$Transceiver$sendUart(uint8_t type, uint8_t payloadSize);
static  
#line 369
result_t TransceiverM$SendRadio$sendDone(TOS_MsgPtr m, result_t result);
static inline  






TOS_MsgPtr TransceiverM$ReceiveRadio$receive(TOS_MsgPtr m);
static inline  






result_t TransceiverM$SendUart$sendDone(TOS_MsgPtr m, result_t result);
static  






TOS_MsgPtr TransceiverM$ReceiveUart$receive(TOS_MsgPtr m);
static  
#line 406
void TransceiverM$sendMsg(void);
static 
#line 428
result_t TransceiverM$pack(uint8_t type, uint16_t dest, uint8_t payloadSize, 
uint8_t outMethod);
static 
#line 456
void TransceiverM$sendDone(void);
static 









void TransceiverM$requestNextSend(void);
static inline 
#line 479
void TransceiverM$advanceWriteIndex(void);
static inline 






void TransceiverM$advanceSendIndex(void);
static inline   





result_t TransceiverM$Transceiver$default$radioSendDone(uint8_t type, TOS_MsgPtr m, 
result_t result);
static inline   


result_t TransceiverM$Transceiver$default$uartSendDone(uint8_t type, TOS_MsgPtr m, 
result_t result);
static inline   


TOS_MsgPtr TransceiverM$Transceiver$default$receiveRadio(uint8_t type, TOS_MsgPtr m);
static inline   


TOS_MsgPtr TransceiverM$Transceiver$default$receiveUart(uint8_t type, TOS_MsgPtr m);
# 58 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/State/StateM.nc"
uint8_t StateM$state[2];

enum StateM$__nesc_unnamed4293 {
  StateM$S_IDLE
};
static inline  

result_t StateM$StdControl$init(void);
static inline  



result_t StateM$StdControl$start(void);
static  
#line 84
result_t StateM$State$requestState(uint8_t id, uint8_t reqState);
static inline  
#line 107
result_t StateM$State$toIdle(uint8_t id);
static  
# 50 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/PacketFilterM.nc"
bool PacketFilterM$PacketFilter$filterPacket(TOS_MsgPtr packet, uint8_t inMethod);
static  
# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
result_t CC2420RadioM$SplitControl$initDone(void);
static  
#line 85
result_t CC2420RadioM$SplitControl$startDone(void);
static   
# 59 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
result_t CC2420RadioM$FIFOP$disable(void);
static   
#line 43
result_t CC2420RadioM$FIFOP$startWait(bool arg_0xa694cc0);
static   
# 6 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
result_t CC2420RadioM$BackoffTimerJiffy$setOneShot(uint32_t arg_0xa68cb78);
static   


bool CC2420RadioM$BackoffTimerJiffy$isSet(void);
static   
#line 8
result_t CC2420RadioM$BackoffTimerJiffy$stop(void);
static  
# 67 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
result_t CC2420RadioM$Send$sendDone(TOS_MsgPtr arg_0xa54a868, result_t arg_0xa54a9b8);
static   
# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Random.nc"
uint16_t CC2420RadioM$Random$rand(void);
static   
#line 57
result_t CC2420RadioM$Random$init(void);
static  
# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
result_t CC2420RadioM$TimerControl$init(void);
static  





result_t CC2420RadioM$TimerControl$start(void);
static  
# 75 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
TOS_MsgPtr CC2420RadioM$Receive$receive(TOS_MsgPtr arg_0xa54e5d8);
static   
# 61 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
uint16_t CC2420RadioM$HPLChipcon$read(uint8_t arg_0xa672bf0);
static   
#line 47
uint8_t CC2420RadioM$HPLChipcon$cmd(uint8_t arg_0xa6721a0);
static   
# 33 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/RadioCoordinator.nc"
void CC2420RadioM$RadioReceiveCoordinator$startSymbol(uint8_t arg_0xa661070, uint8_t arg_0xa6611b8, TOS_MsgPtr arg_0xa661308);
static   
# 60 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
result_t CC2420RadioM$SFD$disable(void);
static   
#line 43
result_t CC2420RadioM$SFD$enableCapture(bool arg_0xa6b0988);
static   
# 33 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/RadioCoordinator.nc"
void CC2420RadioM$RadioSendCoordinator$startSymbol(uint8_t arg_0xa661070, uint8_t arg_0xa6611b8, TOS_MsgPtr arg_0xa661308);
static   
# 29 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
result_t CC2420RadioM$HPLChipconFIFO$writeTXFIFO(uint8_t arg_0xa6927b8, uint8_t *arg_0xa692918);
static   
#line 19
result_t CC2420RadioM$HPLChipconFIFO$readRXFIFO(uint8_t arg_0xa692080, uint8_t *arg_0xa6921e0);
static   
# 163 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
result_t CC2420RadioM$CC2420Control$RxMode(void);
static   
# 74 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/MacBackoff.nc"
int16_t CC2420RadioM$MacBackoff$initialBackoff(TOS_MsgPtr arg_0xa685888);
static   int16_t CC2420RadioM$MacBackoff$congestionBackoff(TOS_MsgPtr arg_0xa685cb0);
static  
# 64 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
result_t CC2420RadioM$CC2420SplitControl$init(void);
static  
#line 77
result_t CC2420RadioM$CC2420SplitControl$start(void);
# 76 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
enum CC2420RadioM$__nesc_unnamed4294 {
  CC2420RadioM$DISABLED_STATE = 0, 
  CC2420RadioM$IDLE_STATE, 
  CC2420RadioM$TX_STATE, 
  CC2420RadioM$TX_WAIT, 
  CC2420RadioM$PRE_TX_STATE, 
  CC2420RadioM$POST_TX_STATE, 
  CC2420RadioM$POST_TX_ACK_STATE, 
  CC2420RadioM$RX_STATE, 
  CC2420RadioM$POWER_DOWN_STATE, 
  CC2420RadioM$WARMUP_STATE, 

  CC2420RadioM$TIMER_INITIAL = 0, 
  CC2420RadioM$TIMER_BACKOFF, 
  CC2420RadioM$TIMER_ACK
};
 


uint8_t CC2420RadioM$countRetry;
uint8_t CC2420RadioM$stateRadio;
 uint8_t CC2420RadioM$stateTimer;
 uint8_t CC2420RadioM$currentDSN;
 bool CC2420RadioM$bAckEnable;
bool CC2420RadioM$bPacketReceiving;
uint8_t CC2420RadioM$txlength;
 TOS_MsgPtr CC2420RadioM$txbufptr;
 TOS_MsgPtr CC2420RadioM$rxbufptr;
TOS_Msg CC2420RadioM$RxBuf;

volatile uint16_t CC2420RadioM$LocalAddr;
static 




void CC2420RadioM$sendFailed(void);
static 




void CC2420RadioM$flushRXFIFO(void);
static 







__inline result_t CC2420RadioM$setInitialTimer(uint16_t jiffy);
static 






__inline result_t CC2420RadioM$setBackoffTimer(uint16_t jiffy);
static 






__inline result_t CC2420RadioM$setAckTimer(uint16_t jiffy);
static inline  







void CC2420RadioM$PacketRcvd(void);
static  
#line 167
void CC2420RadioM$PacketSent(void);
static inline  
#line 185
result_t CC2420RadioM$StdControl$init(void);
static  



result_t CC2420RadioM$SplitControl$init(void);
static inline  
#line 207
result_t CC2420RadioM$CC2420SplitControl$initDone(void);
static inline   


result_t CC2420RadioM$SplitControl$default$initDone(void);
static inline  
#line 239
result_t CC2420RadioM$StdControl$start(void);
static  



result_t CC2420RadioM$SplitControl$start(void);
static inline  
#line 261
result_t CC2420RadioM$CC2420SplitControl$startDone(void);
static inline   
#line 279
result_t CC2420RadioM$SplitControl$default$startDone(void);
static inline 







void CC2420RadioM$sendPacket(void);
static inline   
#line 311
result_t CC2420RadioM$SFD$captured(uint16_t time);
static  
#line 360
void CC2420RadioM$startSend(void);
static 
#line 377
void CC2420RadioM$tryToSend(void);
static inline   
#line 416
result_t CC2420RadioM$BackoffTimerJiffy$fired(void);
static inline  
#line 458
result_t CC2420RadioM$Send$send(TOS_MsgPtr pMsg);
static 
#line 501
void CC2420RadioM$delayedRXFIFO(void);
static inline  
void CC2420RadioM$delayedRXFIFOtask(void);
static 


void CC2420RadioM$delayedRXFIFO(void);
static inline   
#line 558
result_t CC2420RadioM$FIFOP$fired(void);
static inline   
#line 595
result_t CC2420RadioM$HPLChipconFIFO$RXFIFODone(uint8_t length, uint8_t *data);
static inline   
#line 688
result_t CC2420RadioM$HPLChipconFIFO$TXFIFODone(uint8_t length, uint8_t *data);
static inline    
#line 711
int16_t CC2420RadioM$MacBackoff$default$initialBackoff(TOS_MsgPtr m);
static inline    





int16_t CC2420RadioM$MacBackoff$default$congestionBackoff(TOS_MsgPtr m);
static inline    






void CC2420RadioM$RadioSendCoordinator$default$startSymbol(uint8_t bitsPerBlock, uint8_t offset, TOS_MsgPtr msgBuff);
static inline    
void CC2420RadioM$RadioReceiveCoordinator$default$startSymbol(uint8_t bitsPerBlock, uint8_t offset, TOS_MsgPtr msgBuff);
static  
# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
result_t CC2420ControlM$SplitControl$initDone(void);
static  
#line 85
result_t CC2420ControlM$SplitControl$startDone(void);
static   
# 61 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
uint16_t CC2420ControlM$HPLChipcon$read(uint8_t arg_0xa672bf0);
static   
#line 54
uint8_t CC2420ControlM$HPLChipcon$write(uint8_t arg_0xa6725f8, uint16_t arg_0xa672748);
static   
#line 47
uint8_t CC2420ControlM$HPLChipcon$cmd(uint8_t arg_0xa6721a0);
static   
# 43 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
result_t CC2420ControlM$CCA$startWait(bool arg_0xa694cc0);
static  
# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
result_t CC2420ControlM$HPLChipconControl$init(void);
static  





result_t CC2420ControlM$HPLChipconControl$start(void);
static   
# 47 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
result_t CC2420ControlM$HPLChipconRAM$write(uint16_t arg_0xa6cd210, uint8_t arg_0xa6cd358, uint8_t *arg_0xa6cd4b8);
# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
enum CC2420ControlM$__nesc_unnamed4295 {
  CC2420ControlM$IDLE_STATE = 0, 
  CC2420ControlM$INIT_STATE, 
  CC2420ControlM$INIT_STATE_DONE, 
  CC2420ControlM$START_STATE, 
  CC2420ControlM$START_STATE_DONE, 
  CC2420ControlM$STOP_STATE
};

uint8_t CC2420ControlM$state = 0;
 uint16_t CC2420ControlM$gCurrentParameters[14];
static inline 





bool CC2420ControlM$SetRegs(void);
static inline  
#line 108
void CC2420ControlM$taskInitDone(void);
static inline  






void CC2420ControlM$PostOscillatorOn(void);
static inline  
#line 129
result_t CC2420ControlM$SplitControl$init(void);
static inline  
#line 227
result_t CC2420ControlM$SplitControl$start(void);
static inline  
#line 286
result_t CC2420ControlM$CC2420Control$TuneManual(uint16_t DesiredFreq);
static inline   
#line 343
result_t CC2420ControlM$CC2420Control$RxMode(void);
static inline   
#line 368
result_t CC2420ControlM$CC2420Control$OscillatorOn(void);
static inline   
#line 400
result_t CC2420ControlM$CC2420Control$VREFOn(void);
static inline  
#line 432
result_t CC2420ControlM$CC2420Control$setShortAddress(uint16_t addr);
static inline   







result_t CC2420ControlM$HPLChipconRAM$writeDone(uint16_t addr, uint8_t length, uint8_t *buffer);
static inline   


result_t CC2420ControlM$CCA$fired(void);
static  
# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
result_t HPLCC2420M$TimerControl$init(void);
static   
# 49 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
result_t HPLCC2420M$HPLCC2420RAM$writeDone(uint16_t arg_0xa6cd938, uint8_t arg_0xa6cda80, uint8_t *arg_0xa6cdbe0);
 
# 55 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420M.nc"
bool HPLCC2420M$bSpiAvail;
 uint8_t *HPLCC2420M$rambuf;
 uint8_t HPLCC2420M$ramlen;
 uint16_t HPLCC2420M$ramaddr;
static inline  





result_t HPLCC2420M$StdControl$init(void);
static inline  
#line 95
result_t HPLCC2420M$StdControl$start(void);
static   






uint8_t HPLCC2420M$HPLCC2420$cmd(uint8_t addr);
static   
#line 128
result_t HPLCC2420M$HPLCC2420$write(uint8_t addr, uint16_t data);
static   
#line 159
uint16_t HPLCC2420M$HPLCC2420$read(uint8_t addr);
static inline  
#line 197
void HPLCC2420M$signalRAMWr(void);
static inline   









result_t HPLCC2420M$HPLCC2420RAM$write(uint16_t addr, uint8_t length, uint8_t *buffer);
static   
# 50 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
result_t HPLCC2420FIFOM$HPLCC2420FIFO$TXFIFODone(uint8_t arg_0xa6934c8, uint8_t *arg_0xa693628);
static   
#line 39
result_t HPLCC2420FIFOM$HPLCC2420FIFO$RXFIFODone(uint8_t arg_0xa692e38, uint8_t *arg_0xa692f98);
 
# 51 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420FIFOM.nc"
bool HPLCC2420FIFOM$bSpiAvail;
 uint8_t *HPLCC2420FIFOM$txbuf;
#line 52
uint8_t *HPLCC2420FIFOM$rxbuf;
 uint8_t HPLCC2420FIFOM$txlength;
 
#line 53
uint8_t HPLCC2420FIFOM$rxlength;
bool HPLCC2420FIFOM$rxbufBusy;
#line 54
bool HPLCC2420FIFOM$txbufBusy;
static inline  

void HPLCC2420FIFOM$signalTXdone(void);
static inline  
#line 74
void HPLCC2420FIFOM$signalRXdone(void);
static inline   
#line 95
result_t HPLCC2420FIFOM$HPLCC2420FIFO$writeTXFIFO(uint8_t len, uint8_t *msg);
static inline   
#line 146
result_t HPLCC2420FIFOM$HPLCC2420FIFO$readRXFIFO(uint8_t len, uint8_t *msg);
static   
# 51 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
result_t HPLCC2420InterruptM$FIFO$fired(void);
static   
#line 51
result_t HPLCC2420InterruptM$FIFOP$fired(void);
static  
# 59 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Timer.nc"
result_t HPLCC2420InterruptM$CCATimer$start(char arg_0xa3459e8, uint32_t arg_0xa345b40);
static  
#line 59
result_t HPLCC2420InterruptM$FIFOTimer$start(char arg_0xa3459e8, uint32_t arg_0xa345b40);
static   
# 62 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/TimerCapture.nc"
void HPLCC2420InterruptM$SFDCapture$enableEvents(void);
static   void HPLCC2420InterruptM$SFDCapture$disableEvents(void);
static   
#line 52
void HPLCC2420InterruptM$SFDCapture$clearOverflow(void);
static   
#line 47
bool HPLCC2420InterruptM$SFDCapture$isOverflowPending(void);
static   
#line 40
void HPLCC2420InterruptM$SFDCapture$setEdge(uint8_t arg_0xa75e2f0);
static   
# 51 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
result_t HPLCC2420InterruptM$CCA$fired(void);
static   
# 53 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
result_t HPLCC2420InterruptM$SFD$captured(uint16_t arg_0xa6b0eb0);
 
# 57 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420InterruptM.nc"
uint8_t HPLCC2420InterruptM$FIFOWaitForState;
 uint8_t HPLCC2420InterruptM$FIFOLastState;
 
uint8_t HPLCC2420InterruptM$CCAWaitForState;
 uint8_t HPLCC2420InterruptM$CCALastState;
static inline   
#line 78
result_t HPLCC2420InterruptM$FIFOP$startWait(bool low_to_high);
static inline   









result_t HPLCC2420InterruptM$FIFOP$disable(void);







void __attribute((signal))   __vector_7(void);
static inline  
#line 125
result_t HPLCC2420InterruptM$FIFOTimer$fired(void);
static inline    
#line 150
result_t HPLCC2420InterruptM$FIFO$default$fired(void);
static inline   






result_t HPLCC2420InterruptM$CCA$startWait(bool low_to_high);
static inline  
#line 175
result_t HPLCC2420InterruptM$CCATimer$fired(void);
static inline   
#line 200
result_t HPLCC2420InterruptM$SFD$enableCapture(bool low_to_high);
static inline   









result_t HPLCC2420InterruptM$SFD$disable(void);
static   








void HPLCC2420InterruptM$SFDCapture$captured(uint16_t time);
static   
# 177 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/Clock16.nc"
result_t HPLTimer1M$Timer1$fire(void);
static   
# 72 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/TimerCapture.nc"
void HPLTimer1M$CaptureT1$captured(uint16_t arg_0xa75fea8);
# 43 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer1M.nc"
uint8_t HPLTimer1M$set_flag;
uint8_t HPLTimer1M$mscale;
#line 44
uint8_t HPLTimer1M$nextScale;
uint16_t HPLTimer1M$minterval;
static inline  
result_t HPLTimer1M$StdControl$init(void);
static inline  






result_t HPLTimer1M$StdControl$start(void);
static inline   
#line 129
result_t HPLTimer1M$Timer1$setRate(uint16_t interval, char scale);
static inline    
#line 168
result_t HPLTimer1M$Timer1$default$fire(void);

void __attribute((interrupt))   __vector_12(void);
static   
#line 194
void HPLTimer1M$CaptureT1$setEdge(uint8_t LowToHigh);
static inline   
#line 219
bool HPLTimer1M$CaptureT1$isOverflowPending(void);
static inline   






uint16_t HPLTimer1M$CaptureT1$getEvent(void);
static inline   







void HPLTimer1M$CaptureT1$clearOverflow(void);
static inline   
#line 252
void HPLTimer1M$CaptureT1$enableEvents(void);
static inline   








void HPLTimer1M$CaptureT1$disableEvents(void);
#line 278
void __attribute((signal))   __vector_11(void);
# 54 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/RandomLFSR.nc"
uint16_t RandomLFSR$shiftReg;
uint16_t RandomLFSR$initSeed;
uint16_t RandomLFSR$mask;
static inline   

result_t RandomLFSR$Random$init(void);
static   









uint16_t RandomLFSR$Random$rand(void);
static   
# 12 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
result_t TimerJiffyAsyncM$TimerJiffyAsync$fired(void);
static   
# 148 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Clock.nc"
result_t TimerJiffyAsyncM$Timer$setIntervalAndScale(uint8_t arg_0xa43be90, uint8_t arg_0xa438010);
static   
#line 168
void TimerJiffyAsyncM$Timer$intDisable(void);
# 18 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/TimerJiffyAsyncM.nc"
uint32_t TimerJiffyAsyncM$jiffy;
bool TimerJiffyAsyncM$bSet;
static inline  

result_t TimerJiffyAsyncM$StdControl$init(void);
static inline  




result_t TimerJiffyAsyncM$StdControl$start(void);
static inline   
#line 44
result_t TimerJiffyAsyncM$Timer$fire(void);
static   
#line 61
result_t TimerJiffyAsyncM$TimerJiffyAsync$setOneShot(uint32_t _jiffy);
static inline   
#line 76
bool TimerJiffyAsyncM$TimerJiffyAsync$isSet(void);
static inline   



result_t TimerJiffyAsyncM$TimerJiffyAsync$stop(void);
static   
# 180 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Clock.nc"
result_t HPLTimer2$Timer2$fire(void);
# 56 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer2.nc"
uint8_t HPLTimer2$set_flag;
uint8_t HPLTimer2$mscale;
#line 57
uint8_t HPLTimer2$nextScale;
#line 57
uint8_t HPLTimer2$minterval;
static   
#line 118
result_t HPLTimer2$Timer2$setIntervalAndScale(uint8_t interval, uint8_t scale);
static inline   
#line 165
void HPLTimer2$Timer2$intDisable(void);






void __attribute((interrupt))   __vector_9(void);
static  
# 61 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
TOS_MsgPtr SensorToUARTM$DataMsg$requestWrite(void);
static  
#line 93
result_t SensorToUARTM$DataMsg$sendUart(uint8_t arg_0xa33aed0);
static  
# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
result_t SensorToUARTM$SubControl$init(void);
static  





result_t SensorToUARTM$SubControl$start(void);
# 69 "SensorToUARTM.nc"
uint8_t SensorToUARTM$packetReadingNumber;
uint16_t SensorToUARTM$readingNumber;
TOS_MsgPtr SensorToUARTM$msg[2];
uint8_t SensorToUARTM$currentMsg;
uint16_t SensorToUARTM$hop;
uint16_t SensorToUARTM$src;
struct CPUMsg *SensorToUARTM$message;
uint16_t SensorToUARTM$wav_val_light;
uint16_t SensorToUARTM$wav_val_temp;
uint16_t SensorToUARTM$voltage;
static inline 



result_t SensorToUARTM$newMessage(void);
static inline  



result_t SensorToUARTM$StdControl$init(void);
static inline  
#line 107
result_t SensorToUARTM$StdControl$start(void);
static inline  
#line 123
void SensorToUARTM$dataTask(void);
static inline  
#line 167
result_t SensorToUARTM$SensorOutput$output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type);
static inline  
#line 199
result_t SensorToUARTM$DataMsg$uartSendDone(TOS_MsgPtr sent, result_t success);
static inline  
#line 213
TOS_MsgPtr SensorToUARTM$ResetCounterMsg$receiveUart(TOS_MsgPtr m);
static inline  
#line 225
result_t SensorToUARTM$DataMsg$radioSendDone(TOS_MsgPtr m, result_t result);
static inline  



TOS_MsgPtr SensorToUARTM$DataMsg$receiveRadio(TOS_MsgPtr m);
static inline  



TOS_MsgPtr SensorToUARTM$DataMsg$receiveUart(TOS_MsgPtr m);
static inline  




result_t SensorToUARTM$ResetCounterMsg$radioSendDone(TOS_MsgPtr m, result_t result);
static inline  



result_t SensorToUARTM$ResetCounterMsg$uartSendDone(TOS_MsgPtr m, result_t result);
static inline  



TOS_MsgPtr SensorToUARTM$ResetCounterMsg$receiveRadio(TOS_MsgPtr m);
static inline 



result_t SensorToUARTM$newMessage(void);
static  
# 61 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
TOS_MsgPtr SensorToRfmM$Send$requestWrite(void);
static  
#line 84
result_t SensorToRfmM$Send$sendRadio(uint16_t arg_0xa33a780, uint8_t arg_0xa33a8d0);
# 68 "SensorToRfmM.nc"
bool SensorToRfmM$pending;


TOS_MsgPtr SensorToRfmM$tosPtr;
SensorMsg *SensorToRfmM$message;
static inline 
result_t SensorToRfmM$newMessage(void);
static inline  

result_t SensorToRfmM$StdControl$init(void);
static inline  





result_t SensorToRfmM$StdControl$start(void);
static inline  
#line 98
result_t SensorToRfmM$SensorOutput$output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type);
static inline  
#line 128
result_t SensorToRfmM$Send$radioSendDone(TOS_MsgPtr msg, result_t success);
static inline  








TOS_MsgPtr SensorToRfmM$Send$receiveUart(TOS_MsgPtr m);
static inline  



result_t SensorToRfmM$Send$uartSendDone(TOS_MsgPtr m, result_t result);
static inline  



TOS_MsgPtr SensorToRfmM$Send$receiveRadio(TOS_MsgPtr m);
static inline 





result_t SensorToRfmM$newMessage(void);
static  
# 61 "SensorOutput.nc"
result_t RfmToSensorM$SensorOutput$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, 
uint16_t arg_0xa323568, uint16_t arg_0xa3236c0);
# 64 "RfmToSensorM.nc"
TOS_Msg RfmToSensorM$localTosMsg;


TOS_MsgPtr RfmToSensorM$receiveMsgPtr;
static inline  

result_t RfmToSensorM$StdControl$init(void);
static inline  



result_t RfmToSensorM$StdControl$start(void);
static inline  








TOS_MsgPtr RfmToSensorM$ReceiveSensorMsg$receiveRadio(TOS_MsgPtr m);
static inline  
#line 117
TOS_MsgPtr RfmToSensorM$ReceiveSensorMsg$receiveUart(TOS_MsgPtr m);
static inline  




result_t RfmToSensorM$ReceiveSensorMsg$radioSendDone(TOS_MsgPtr m, result_t result);
static inline  



result_t RfmToSensorM$ReceiveSensorMsg$uartSendDone(TOS_MsgPtr m, result_t result);
static  
# 116 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCControl.nc"
result_t VoltageM$ADCControl$bindPort(uint8_t arg_0xa4cbf58, uint8_t arg_0xa4c20b0);
static  
#line 77
result_t VoltageM$ADCControl$init(void);
# 47 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/VoltageM.nc"
enum VoltageM$__nesc_unnamed4296 {
  VoltageM$ERROR_VOLTAGE = 0xffff
};

enum VoltageM$__nesc_unnamed4297 {
  VoltageM$S_IDLE, 
  VoltageM$S_GET_DATA
};

uint8_t VoltageM$state;
static inline  

result_t VoltageM$StdControl$init(void);
static inline  



result_t VoltageM$StdControl$start(void);
static inline  







result_t VoltageM$StdControl$stop(void);
# 117 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_SET_GREEN_LED_PIN(void)
#line 117
{
#line 117
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1B + 0x20) |= 1 << 1;
}

#line 118
static __inline void TOSH_SET_YELLOW_LED_PIN(void)
#line 118
{
#line 118
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1B + 0x20) |= 1 << 0;
}

#line 116
static __inline void TOSH_SET_RED_LED_PIN(void)
#line 116
{
#line 116
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1B + 0x20) |= 1 << 2;
}

#line 155
static __inline void TOSH_SET_FLASH_SELECT_PIN(void)
#line 155
{
#line 155
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1B + 0x20) |= 1 << 3;
}

#line 156
static __inline void TOSH_MAKE_FLASH_CLK_OUTPUT(void)
#line 156
{
#line 156
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x11 + 0x20) |= 1 << 5;
}

#line 157
static __inline void TOSH_MAKE_FLASH_OUT_OUTPUT(void)
#line 157
{
#line 157
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x11 + 0x20) |= 1 << 3;
}

#line 155
static __inline void TOSH_MAKE_FLASH_SELECT_OUTPUT(void)
#line 155
{
#line 155
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1A + 0x20) |= 1 << 3;
}

#line 120
static __inline void TOSH_CLR_SERIAL_ID_PIN(void)
#line 120
{
#line 120
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1B + 0x20) &= ~(1 << 4);
}

#line 120
static __inline void TOSH_MAKE_SERIAL_ID_INPUT(void)
#line 120
{
#line 120
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1A + 0x20) &= ~(1 << 4);
}

#line 152
static __inline void TOSH_MAKE_RADIO_CCA_INPUT(void)
#line 152
{
#line 152
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x11 + 0x20) &= ~(1 << 6);
}

#line 150
static __inline void TOSH_MAKE_CC_FIFO_INPUT(void)
#line 150
{
#line 150
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x17 + 0x20) &= ~(1 << 7);
}

#line 148
static __inline void TOSH_MAKE_CC_SFD_INPUT(void)
#line 148
{
#line 148
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x11 + 0x20) &= ~(1 << 4);
}

#line 147
static __inline void TOSH_MAKE_CC_CCA_INPUT(void)
#line 147
{
#line 147
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x11 + 0x20) &= ~(1 << 6);
}

#line 145
static __inline void TOSH_MAKE_CC_FIFOP1_INPUT(void)
#line 145
{
#line 145
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x02 + 0x20) &= ~(1 << 6);
}


static __inline void TOSH_MAKE_CC_CS_INPUT(void)
#line 149
{
#line 149
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x17 + 0x20) &= ~(1 << 0);
}

#line 142
static __inline void TOSH_MAKE_CC_VREN_OUTPUT(void)
#line 142
{
#line 142
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1A + 0x20) |= 1 << 5;
}

#line 141
static __inline void TOSH_MAKE_CC_RSTN_OUTPUT(void)
#line 141
{
#line 141
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1A + 0x20) |= 1 << 6;
}

#line 170
static __inline void TOSH_MAKE_SPI_SCK_OUTPUT(void)
#line 170
{
#line 170
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x17 + 0x20) |= 1 << 1;
}

#line 167
static __inline void TOSH_MAKE_MOSI_OUTPUT(void)
#line 167
{
#line 167
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x17 + 0x20) |= 1 << 2;
}

#line 168
static __inline void TOSH_MAKE_MISO_INPUT(void)
#line 168
{
#line 168
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x17 + 0x20) &= ~(1 << 3);
}



static __inline void TOSH_MAKE_PW0_OUTPUT(void)
#line 173
{
#line 173
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x14 + 0x20) |= 1 << 0;
}

#line 174
static __inline void TOSH_MAKE_PW1_OUTPUT(void)
#line 174
{
#line 174
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x14 + 0x20) |= 1 << 1;
}

#line 175
static __inline void TOSH_MAKE_PW2_OUTPUT(void)
#line 175
{
#line 175
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x14 + 0x20) |= 1 << 2;
}

#line 176
static __inline void TOSH_MAKE_PW3_OUTPUT(void)
#line 176
{
#line 176
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x14 + 0x20) |= 1 << 3;
}

#line 177
static __inline void TOSH_MAKE_PW4_OUTPUT(void)
#line 177
{
#line 177
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x14 + 0x20) |= 1 << 4;
}

#line 178
static __inline void TOSH_MAKE_PW5_OUTPUT(void)
#line 178
{
#line 178
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x14 + 0x20) |= 1 << 5;
}

#line 179
static __inline void TOSH_MAKE_PW6_OUTPUT(void)
#line 179
{
#line 179
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x14 + 0x20) |= 1 << 6;
}

#line 180
static __inline void TOSH_MAKE_PW7_OUTPUT(void)
#line 180
{
#line 180
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x14 + 0x20) |= 1 << 7;
}

#line 117
static __inline void TOSH_MAKE_GREEN_LED_OUTPUT(void)
#line 117
{
#line 117
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1A + 0x20) |= 1 << 1;
}

#line 118
static __inline void TOSH_MAKE_YELLOW_LED_OUTPUT(void)
#line 118
{
#line 118
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1A + 0x20) |= 1 << 0;
}

#line 116
static __inline void TOSH_MAKE_RED_LED_OUTPUT(void)
#line 116
{
#line 116
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1A + 0x20) |= 1 << 2;
}

static inline 
#line 196
void TOSH_SET_PIN_DIRECTIONS(void )
{







  TOSH_MAKE_RED_LED_OUTPUT();
  TOSH_MAKE_YELLOW_LED_OUTPUT();
  TOSH_MAKE_GREEN_LED_OUTPUT();


  TOSH_MAKE_PW7_OUTPUT();
  TOSH_MAKE_PW6_OUTPUT();
  TOSH_MAKE_PW5_OUTPUT();
  TOSH_MAKE_PW4_OUTPUT();
  TOSH_MAKE_PW3_OUTPUT();
  TOSH_MAKE_PW2_OUTPUT();
  TOSH_MAKE_PW1_OUTPUT();
  TOSH_MAKE_PW0_OUTPUT();


  TOSH_MAKE_MISO_INPUT();
  TOSH_MAKE_MOSI_OUTPUT();
  TOSH_MAKE_SPI_SCK_OUTPUT();
  TOSH_MAKE_CC_RSTN_OUTPUT();
  TOSH_MAKE_CC_VREN_OUTPUT();
  TOSH_MAKE_CC_CS_INPUT();
  TOSH_MAKE_CC_FIFOP1_INPUT();
  TOSH_MAKE_CC_CCA_INPUT();
  TOSH_MAKE_CC_SFD_INPUT();
  TOSH_MAKE_CC_FIFO_INPUT();

  TOSH_MAKE_RADIO_CCA_INPUT();



  TOSH_MAKE_SERIAL_ID_INPUT();
  TOSH_CLR_SERIAL_ID_PIN();

  TOSH_MAKE_FLASH_SELECT_OUTPUT();
  TOSH_MAKE_FLASH_OUT_OUTPUT();
  TOSH_MAKE_FLASH_CLK_OUTPUT();
  TOSH_SET_FLASH_SELECT_PIN();

  TOSH_SET_RED_LED_PIN();
  TOSH_SET_YELLOW_LED_PIN();
  TOSH_SET_GREEN_LED_PIN();
}

static inline  
# 57 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/avrmote/HPLInit.nc"
result_t HPLInit$init(void)
#line 57
{
  TOSH_SET_PIN_DIRECTIONS();
  return SUCCESS;
}

# 47 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/RealMain.nc"
inline static  result_t RealMain$hardwareInit(void){
#line 47
  unsigned char result;
#line 47

#line 47
  result = HPLInit$init();
#line 47

#line 47
  return result;
#line 47
}
#line 47
static inline  
# 75 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/HPLPotC.nc"
result_t HPLPotC$Pot$finalise(void)
#line 75
{


  return SUCCESS;
}

# 74 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLPot.nc"
inline static  result_t PotM$HPLPot$finalise(void){
#line 74
  unsigned char result;
#line 74

#line 74
  result = HPLPotC$Pot$finalise();
#line 74

#line 74
  return result;
#line 74
}
#line 74
static inline  
# 66 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/HPLPotC.nc"
result_t HPLPotC$Pot$increase(void)
#line 66
{





  return SUCCESS;
}

# 67 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLPot.nc"
inline static  result_t PotM$HPLPot$increase(void){
#line 67
  unsigned char result;
#line 67

#line 67
  result = HPLPotC$Pot$increase();
#line 67

#line 67
  return result;
#line 67
}
#line 67
static inline  
# 57 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/HPLPotC.nc"
result_t HPLPotC$Pot$decrease(void)
#line 57
{





  return SUCCESS;
}

# 59 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLPot.nc"
inline static  result_t PotM$HPLPot$decrease(void){
#line 59
  unsigned char result;
#line 59

#line 59
  result = HPLPotC$Pot$decrease();
#line 59

#line 59
  return result;
#line 59
}
#line 59
static inline 
# 93 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/PotM.nc"
void PotM$setPot(uint8_t value)
#line 93
{
  uint8_t i;

#line 95
  for (i = 0; i < 151; i++) 
    PotM$HPLPot$decrease();

  for (i = 0; i < value; i++) 
    PotM$HPLPot$increase();

  PotM$HPLPot$finalise();

  PotM$potSetting = value;
}

static inline  result_t PotM$Pot$init(uint8_t initialSetting)
#line 106
{
  PotM$setPot(initialSetting);
  return SUCCESS;
}

# 78 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Pot.nc"
inline static  result_t RealMain$Pot$init(uint8_t arg_0xa2f8ee8){
#line 78
  unsigned char result;
#line 78

#line 78
  result = PotM$Pot$init(arg_0xa2f8ee8);
#line 78

#line 78
  return result;
#line 78
}
#line 78
static inline 
# 79 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/sched.c"
void TOSH_sched_init(void )
{
  int i;

#line 82
  TOSH_sched_free = 0;
  TOSH_sched_full = 0;
  for (i = 0; i < TOSH_MAX_TASKS; i++) 
    TOSH_queue[i].tp = (void *)0;
}

static inline 
# 120 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/tos.h"
result_t rcombine(result_t r1, result_t r2)



{
  return r1 == FAIL ? FAIL : r2;
}

static inline  
# 60 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/UARTM.nc"
result_t UARTM$Control$init(void)
#line 60
{
  {
  }
#line 61
  ;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 62
    {
      UARTM$state = FALSE;
    }
#line 64
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t FramerM$ByteControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = UARTM$Control$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
static inline  
# 336 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/FramerM.nc"
result_t FramerM$StdControl$init(void)
#line 336
{
  FramerM$HDLCInitialize();
  return FramerM$ByteControl$init();
}

static inline  
# 185 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
result_t CC2420RadioM$StdControl$init(void)
#line 185
{
  return CC2420RadioM$SplitControl$init();
}

static inline 
# 159 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/tos.h"
void *nmemset(void *to, int val, size_t n)
{
  char *cto = to;

  while (n--) * cto++ = val;

  return to;
}

static inline  
# 65 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/State/StateM.nc"
result_t StateM$StdControl$init(void)
#line 65
{
  nmemset(&StateM$state, StateM$S_IDLE, 2);
  return SUCCESS;
}

# 77 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCControl.nc"
inline static  result_t PhotoTempM$ADCControl$init(void){
#line 77
  unsigned char result;
#line 77

#line 77
  result = ADCREFM$ADCControl$init();
#line 77

#line 77
  return result;
#line 77
}
#line 77
# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t PhotoTempM$TimerControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = TimerM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLADC.nc"
inline static   result_t ADCREFM$HPLADC$bindPort(uint8_t arg_0xa4eaae8, uint8_t arg_0xa4eac30){
#line 70
  unsigned char result;
#line 70

#line 70
  result = HPLADCM$ADC$bindPort(arg_0xa4eaae8, arg_0xa4eac30);
#line 70

#line 70
  return result;
#line 70
}
#line 70
static inline  
# 114 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCREFM.nc"
result_t ADCREFM$ADCControl$bindPort(uint8_t port, uint8_t adcPort)
#line 114
{
  return ADCREFM$HPLADC$bindPort(port, adcPort);
}

# 116 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCControl.nc"
inline static  result_t PhotoTempM$ADCControl$bindPort(uint8_t arg_0xa4cbf58, uint8_t arg_0xa4c20b0){
#line 116
  unsigned char result;
#line 116

#line 116
  result = ADCREFM$ADCControl$bindPort(arg_0xa4cbf58, arg_0xa4c20b0);
#line 116

#line 116
  return result;
#line 116
}
#line 116
static inline  
# 142 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/PhotoTempM.nc"
result_t PhotoTempM$PhotoStdControl$init(void)
#line 142
{
  PhotoTempM$ADCControl$bindPort(TOS_ADC_PHOTO_PORT, TOSH_ACTUAL_PHOTO_PORT);
  PhotoTempM$TimerControl$init();
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 145
    {
      PhotoTempM$photoSensor = PhotoTempM$stateIdle;
    }
#line 147
    __nesc_atomic_end(__nesc_atomic); }
#line 147
  ;
  {
  }
#line 148
  ;
  return PhotoTempM$ADCControl$init();
}

# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SenseToSensor$LightControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = PhotoTempM$PhotoStdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
static inline  
# 172 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/PhotoTempM.nc"
result_t PhotoTempM$TempStdControl$init(void)
#line 172
{
  PhotoTempM$ADCControl$bindPort(TOS_ADC_TEMP_PORT, TOSH_ACTUAL_TEMP_PORT);
  PhotoTempM$TimerControl$init();
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 175
    {
      PhotoTempM$tempSensor = PhotoTempM$stateIdle;
    }
#line 177
    __nesc_atomic_end(__nesc_atomic); }
#line 177
  ;
  {
  }
#line 178
  ;
  return PhotoTempM$ADCControl$init();
}

# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SenseToSensor$TempControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = PhotoTempM$TempStdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
static inline  
# 84 "SenseToSensor.nc"
result_t SenseToSensor$StdControl$init(void)
{

  SenseToSensor$TempControl$init();
  SenseToSensor$LightControl$init();


  return SUCCESS;
}

static inline  
# 70 "RfmToSensorM.nc"
result_t RfmToSensorM$StdControl$init(void)
#line 70
{
  return SUCCESS;
}

static inline  
# 77 "SensorToRfmM.nc"
result_t SensorToRfmM$StdControl$init(void)
{
  SensorToRfmM$pending = FALSE;
  return SUCCESS;
}

# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SensorToUARTM$SubControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = SensorToRfmM$StdControl$init();
#line 63
  result = rcombine(result, RfmToSensorM$StdControl$init());
#line 63
  result = rcombine(result, TransceiverM$StdControl$init());
#line 63
  result = rcombine(result, StateM$StdControl$init());
#line 63
  result = rcombine(result, CC2420RadioM$StdControl$init());
#line 63
  result = rcombine(result, FramerM$StdControl$init());
#line 63

#line 63
  return result;
#line 63
}
#line 63
static inline  
# 88 "SensorToUARTM.nc"
result_t SensorToUARTM$StdControl$init(void)
{
  SensorToUARTM$SubControl$init();

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      SensorToUARTM$currentMsg = 0;
      SensorToUARTM$packetReadingNumber = 0;
      SensorToUARTM$readingNumber = 0;
    }
#line 97
    __nesc_atomic_end(__nesc_atomic); }

  {
  }
#line 99
  ;
  return SUCCESS;
}

static inline   
# 110 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/LedsC.nc"
result_t LedsC$Leds$greenOff(void)
#line 110
{
  {
  }
#line 111
  ;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 112
    {
      TOSH_SET_GREEN_LED_PIN();
      LedsC$ledsOn &= ~LedsC$GREEN_BIT;
    }
#line 115
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 97 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t SensorToLedsM$Leds$greenOff(void){
#line 97
  unsigned char result;
#line 97

#line 97
  result = LedsC$Leds$greenOff();
#line 97

#line 97
  return result;
#line 97
}
#line 97
static inline   
# 139 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/LedsC.nc"
result_t LedsC$Leds$yellowOff(void)
#line 139
{
  {
  }
#line 140
  ;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 141
    {
      TOSH_SET_YELLOW_LED_PIN();
      LedsC$ledsOn &= ~LedsC$YELLOW_BIT;
    }
#line 144
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 122 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t SensorToLedsM$Leds$yellowOff(void){
#line 122
  unsigned char result;
#line 122

#line 122
  result = LedsC$Leds$yellowOff();
#line 122

#line 122
  return result;
#line 122
}
#line 122
static inline   
# 81 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/LedsC.nc"
result_t LedsC$Leds$redOff(void)
#line 81
{
  {
  }
#line 82
  ;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 83
    {
      TOSH_SET_RED_LED_PIN();
      LedsC$ledsOn &= ~LedsC$RED_BIT;
    }
#line 86
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 72 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t SensorToLedsM$Leds$redOff(void){
#line 72
  unsigned char result;
#line 72

#line 72
  result = LedsC$Leds$redOff();
#line 72

#line 72
  return result;
#line 72
}
#line 72
static inline   
# 58 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/LedsC.nc"
result_t LedsC$Leds$init(void)
#line 58
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 59
    {
      LedsC$ledsOn = 0;
      {
      }
#line 61
      ;
      TOSH_MAKE_RED_LED_OUTPUT();
      TOSH_MAKE_YELLOW_LED_OUTPUT();
      TOSH_MAKE_GREEN_LED_OUTPUT();
      TOSH_SET_RED_LED_PIN();
      TOSH_SET_YELLOW_LED_PIN();
      TOSH_SET_GREEN_LED_PIN();
    }
#line 68
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 56 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t SensorToLedsM$Leds$init(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = LedsC$Leds$init();
#line 56

#line 56
  return result;
#line 56
}
#line 56
static inline  
# 60 "SensorToLedsM.nc"
result_t SensorToLedsM$StdControl$init(void)
{
  SensorToLedsM$Leds$init();
  SensorToLedsM$Leds$redOff();
  SensorToLedsM$Leds$yellowOff();
  SensorToLedsM$Leds$greenOff();
  return SUCCESS;
}

static inline  
# 59 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/VoltageM.nc"
result_t VoltageM$StdControl$init(void)
#line 59
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 60
    VoltageM$state = VoltageM$S_IDLE;
#line 60
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t BasicRoutingM$VoltageControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = VoltageM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
static inline 
# 741 "BasicRoutingM.nc"
void BasicRoutingM$assignWavTable(void)
{
  switch (TOS_LOCAL_ADDRESS) {
#line 765
      case 5: 
        BasicRoutingM$arrayAssign(BasicRoutingM$node5, BasicRoutingM$local_table);
      BasicRoutingM$arrayAssignDouble(BasicRoutingM$node5_coeff, BasicRoutingM$local_table_coeff);
      break;
#line 790
      case 10: 
        BasicRoutingM$arrayAssign(BasicRoutingM$node10, BasicRoutingM$local_table);
      BasicRoutingM$arrayAssignDouble(BasicRoutingM$node10_coeff, BasicRoutingM$local_table_coeff);
      break;
#line 845
      default: 
        break;
    }
}

static inline  
#line 536
result_t BasicRoutingM$StdControl$init(void)
{
  BasicRoutingM$assignWavTable();
  BasicRoutingM$VoltageControl$init();
  return SUCCESS;
}

# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t RealMain$StdControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = TimerM$StdControl$init();
#line 63
  result = rcombine(result, BasicRoutingM$StdControl$init());
#line 63
  result = rcombine(result, SensorToLedsM$StdControl$init());
#line 63
  result = rcombine(result, SensorToUARTM$StdControl$init());
#line 63
  result = rcombine(result, SenseToSensor$StdControl$init());
#line 63
  result = rcombine(result, TransceiverM$StdControl$init());
#line 63
  result = rcombine(result, StateM$StdControl$init());
#line 63
  result = rcombine(result, CC2420RadioM$StdControl$init());
#line 63
  result = rcombine(result, FramerM$StdControl$init());
#line 63
  result = rcombine(result, TimerM$StdControl$init());
#line 63

#line 63
  return result;
#line 63
}
#line 63
static inline   
# 149 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica/HPLClock.nc"
result_t HPLClock$Clock$setRate(char interval, char scale)
#line 149
{
  scale &= 0x7;
  scale |= 0x8;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 152
    {
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x37 + 0x20) &= ~(1 << 0);
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x37 + 0x20) &= ~(1 << 1);
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x30 + 0x20) |= 1 << 3;


      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x33 + 0x20) = scale;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x32 + 0x20) = 0;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x31 + 0x20) = interval;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x37 + 0x20) |= 1 << 1;
    }
#line 162
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 96 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Clock.nc"
inline static   result_t TimerM$Clock$setRate(char arg_0xa43a010, char arg_0xa43a150){
#line 96
  unsigned char result;
#line 96

#line 96
  result = HPLClock$Clock$setRate(arg_0xa43a010, arg_0xa43a150);
#line 96

#line 96
  return result;
#line 96
}
#line 96
static inline  
# 22 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/TimerJiffyAsyncM.nc"
result_t TimerJiffyAsyncM$StdControl$init(void)
{

  return SUCCESS;
}

# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t CC2420RadioM$TimerControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = TimerJiffyAsyncM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
static inline   
# 59 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/RandomLFSR.nc"
result_t RandomLFSR$Random$init(void)
#line 59
{
  {
  }
#line 60
  ;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 61
    {
      RandomLFSR$shiftReg = 119 * 119 * (TOS_LOCAL_ADDRESS + 1);
      RandomLFSR$initSeed = RandomLFSR$shiftReg;
      RandomLFSR$mask = 137 * 29 * (TOS_LOCAL_ADDRESS + 1);
    }
#line 65
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 57 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Random.nc"
inline static   result_t CC2420RadioM$Random$init(void){
#line 57
  unsigned char result;
#line 57

#line 57
  result = RandomLFSR$Random$init();
#line 57

#line 57
  return result;
#line 57
}
#line 57
static inline   
# 211 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
result_t CC2420RadioM$SplitControl$default$initDone(void)
#line 211
{
  return SUCCESS;
}

# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
inline static  result_t CC2420RadioM$SplitControl$initDone(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = CC2420RadioM$SplitControl$default$initDone();
#line 70

#line 70
  return result;
#line 70
}
#line 70
static inline  
# 207 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
result_t CC2420RadioM$CC2420SplitControl$initDone(void)
#line 207
{
  return CC2420RadioM$SplitControl$initDone();
}

# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
inline static  result_t CC2420ControlM$SplitControl$initDone(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = CC2420RadioM$CC2420SplitControl$initDone();
#line 70

#line 70
  return result;
#line 70
}
#line 70
static inline  
# 108 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
void CC2420ControlM$taskInitDone(void)
#line 108
{
  CC2420ControlM$SplitControl$initDone();
}

static inline  
# 47 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer1M.nc"
result_t HPLTimer1M$StdControl$init(void)
#line 47
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 48
    {
      HPLTimer1M$mscale = TCLK_CPU_DIV256;
      HPLTimer1M$minterval = TIMER1_DEFAULT_INTERVAL;
    }
#line 51
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t HPLCC2420M$TimerControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = TimerM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 149 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_MAKE_CC_CS_OUTPUT(void)
#line 149
{
#line 149
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x17 + 0x20) |= 1 << 0;
}

static inline  
# 65 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420M.nc"
result_t HPLCC2420M$StdControl$init(void)
#line 65
{

  HPLCC2420M$bSpiAvail = TRUE;
  TOSH_MAKE_MISO_INPUT();
  TOSH_MAKE_MOSI_OUTPUT();
  TOSH_MAKE_SPI_SCK_OUTPUT();
  TOSH_MAKE_CC_RSTN_OUTPUT();
  TOSH_MAKE_CC_VREN_OUTPUT();
  TOSH_MAKE_CC_CS_OUTPUT();
  TOSH_MAKE_CC_FIFOP1_INPUT();
  TOSH_MAKE_CC_CCA_INPUT();
  TOSH_MAKE_CC_SFD_INPUT();
  TOSH_MAKE_CC_FIFO_INPUT();
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 78
    {
      TOSH_MAKE_SPI_SCK_OUTPUT();
      TOSH_MAKE_MISO_INPUT();
      TOSH_MAKE_MOSI_OUTPUT();
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) |= 1 << 0;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0D + 0x20) |= 1 << 4;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0D + 0x20) &= ~(1 << 3);
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0D + 0x20) &= ~(1 << 2);
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0D + 0x20) &= ~(1 << 1);
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0D + 0x20) &= ~(1 << 0);

      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0D + 0x20) |= 1 << 6;
    }
#line 90
    __nesc_atomic_end(__nesc_atomic); }
  HPLCC2420M$TimerControl$init();
  return SUCCESS;
}

# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t CC2420ControlM$HPLChipconControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = HPLCC2420M$StdControl$init();
#line 63
  result = rcombine(result, HPLTimer1M$StdControl$init());
#line 63

#line 63
  return result;
#line 63
}
#line 63
static inline  
# 129 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
result_t CC2420ControlM$SplitControl$init(void)
#line 129
{

  uint8_t _state = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 133
    {
      if (CC2420ControlM$state == CC2420ControlM$IDLE_STATE) {
          CC2420ControlM$state = CC2420ControlM$INIT_STATE;
          _state = TRUE;
        }
    }
#line 138
    __nesc_atomic_end(__nesc_atomic); }
  if (!_state) {
    return FAIL;
    }
  CC2420ControlM$HPLChipconControl$init();


  CC2420ControlM$gCurrentParameters[CP_MAIN] = 0xf800;
  CC2420ControlM$gCurrentParameters[CP_MDMCTRL0] = ((((0 << 11) | (
  2 << 8)) | (3 << 6)) | (
  1 << 5)) | (2 << 0);

  CC2420ControlM$gCurrentParameters[CP_MDMCTRL1] = 20 << 6;

  CC2420ControlM$gCurrentParameters[CP_RSSI] = 0xE080;
  CC2420ControlM$gCurrentParameters[CP_SYNCWORD] = 0xA70F;
  CC2420ControlM$gCurrentParameters[CP_TXCTRL] = ((((1 << 14) | (
  1 << 13)) | (3 << 6)) | (
  1 << 5)) | (0x1F << 0);

  CC2420ControlM$gCurrentParameters[CP_RXCTRL0] = (((((1 << 12) | (
  2 << 8)) | (3 << 6)) | (
  2 << 4)) | (1 << 2)) | (
  1 << 0);

  CC2420ControlM$gCurrentParameters[CP_RXCTRL1] = (((((1 << 11) | (
  1 << 9)) | (1 << 6)) | (
  1 << 4)) | (1 << 2)) | (
  2 << 0);

  CC2420ControlM$gCurrentParameters[CP_FSCTRL] = (1 << 14) | ((
  357 + 5 * (11 - 11)) << 0);

  CC2420ControlM$gCurrentParameters[CP_SECCTRL0] = (((1 << 8) | (
  1 << 7)) | (1 << 6)) | (
  1 << 2);

  CC2420ControlM$gCurrentParameters[CP_SECCTRL1] = 0;
  CC2420ControlM$gCurrentParameters[CP_BATTMON] = 0;



  CC2420ControlM$gCurrentParameters[CP_IOCFG0] = (127 << 0) | (
  1 << 9);

  CC2420ControlM$gCurrentParameters[CP_IOCFG1] = 0;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 185
    CC2420ControlM$state = CC2420ControlM$INIT_STATE_DONE;
#line 185
    __nesc_atomic_end(__nesc_atomic); }
  TOS_post(CC2420ControlM$taskInitDone);
  return SUCCESS;
}

# 64 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
inline static  result_t CC2420RadioM$CC2420SplitControl$init(void){
#line 64
  unsigned char result;
#line 64

#line 64
  result = CC2420ControlM$SplitControl$init();
#line 64

#line 64
  return result;
#line 64
}
#line 64
static inline   
# 90 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLADCM.nc"
result_t HPLADCM$ADC$init(void)
#line 90
{
  HPLADCM$init_portmap();



  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 95
    {
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x06 + 0x20) = (1 << 3) | (6 << 0);

      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x07 + 0x20) = 0;
    }
#line 99
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 54 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLADC.nc"
inline static   result_t ADCREFM$HPLADC$init(void){
#line 54
  unsigned char result;
#line 54

#line 54
  result = HPLADCM$ADC$init();
#line 54

#line 54
  return result;
#line 54
}
#line 54
static inline  
# 87 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/TimerM.nc"
result_t TimerM$StdControl$start(void)
#line 87
{
  return SUCCESS;
}

# 62 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLUART.nc"
inline static   result_t UARTM$HPLUART$init(void){
#line 62
  unsigned char result;
#line 62

#line 62
  result = HPLUART0M$UART$init();
#line 62

#line 62
  return result;
#line 62
}
#line 62
static inline  
# 68 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/UARTM.nc"
result_t UARTM$Control$start(void)
#line 68
{
  return UARTM$HPLUART$init();
}

# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t FramerM$ByteControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = UARTM$Control$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
static inline  
# 341 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/FramerM.nc"
result_t FramerM$StdControl$start(void)
#line 341
{
  FramerM$HDLCInitialize();
  return FramerM$ByteControl$start();
}

static inline  
# 239 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
result_t CC2420RadioM$StdControl$start(void)
#line 239
{
  return CC2420RadioM$SplitControl$start();
}

static inline  
# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/State/StateM.nc"
result_t StateM$StdControl$start(void)
#line 70
{
  return SUCCESS;
}

static inline  
# 192 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
result_t TransceiverM$StdControl$start(void)
#line 192
{
  return SUCCESS;
}

# 59 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t SenseToSensor$Timer$start(char arg_0xa3459e8, uint32_t arg_0xa345b40){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(0, arg_0xa3459e8, arg_0xa345b40);
#line 59

#line 59
  return result;
#line 59
}
#line 59
static inline  
# 94 "SenseToSensor.nc"
result_t SenseToSensor$StdControl$start(void)
{

  SenseToSensor$Timer$start(TIMER_REPEAT, 100);

  return SUCCESS;
}

static inline  
# 75 "RfmToSensorM.nc"
result_t RfmToSensorM$StdControl$start(void)
#line 75
{
  return SUCCESS;
}

static inline  
# 84 "SensorToRfmM.nc"
result_t SensorToRfmM$StdControl$start(void)
{
  return SUCCESS;
}

# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SensorToUARTM$SubControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = SensorToRfmM$StdControl$start();
#line 70
  result = rcombine(result, RfmToSensorM$StdControl$start());
#line 70
  result = rcombine(result, TransceiverM$StdControl$start());
#line 70
  result = rcombine(result, StateM$StdControl$start());
#line 70
  result = rcombine(result, CC2420RadioM$StdControl$start());
#line 70
  result = rcombine(result, FramerM$StdControl$start());
#line 70

#line 70
  return result;
#line 70
}
#line 70
static inline  
# 107 "SensorToUARTM.nc"
result_t SensorToUARTM$StdControl$start(void)
{
  SensorToUARTM$SubControl$start();
  return SUCCESS;
}

static inline  
# 69 "SensorToLedsM.nc"
result_t SensorToLedsM$StdControl$start(void)
#line 69
{
  return SUCCESS;
}

static inline  
# 543 "BasicRoutingM.nc"
result_t BasicRoutingM$StdControl$start(void)
{
  return SUCCESS;
}

# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t RealMain$StdControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = TimerM$StdControl$start();
#line 70
  result = rcombine(result, BasicRoutingM$StdControl$start());
#line 70
  result = rcombine(result, SensorToLedsM$StdControl$start());
#line 70
  result = rcombine(result, SensorToUARTM$StdControl$start());
#line 70
  result = rcombine(result, SenseToSensor$StdControl$start());
#line 70
  result = rcombine(result, TransceiverM$StdControl$start());
#line 70
  result = rcombine(result, StateM$StdControl$start());
#line 70
  result = rcombine(result, CC2420RadioM$StdControl$start());
#line 70
  result = rcombine(result, FramerM$StdControl$start());
#line 70
  result = rcombine(result, TimerM$StdControl$start());
#line 70

#line 70
  return result;
#line 70
}
#line 70
static inline  
# 28 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/TimerJiffyAsyncM.nc"
result_t TimerJiffyAsyncM$StdControl$start(void)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 30
    TimerJiffyAsyncM$bSet = FALSE;
#line 30
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t CC2420RadioM$TimerControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = TimerJiffyAsyncM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 47 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
inline static   uint8_t CC2420ControlM$HPLChipcon$cmd(uint8_t arg_0xa6721a0){
#line 47
  unsigned char result;
#line 47

#line 47
  result = HPLCC2420M$HPLCC2420$cmd(arg_0xa6721a0);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 59 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t HPLCC2420InterruptM$CCATimer$start(char arg_0xa3459e8, uint32_t arg_0xa345b40){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(5, arg_0xa3459e8, arg_0xa345b40);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 147 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline int TOSH_READ_CC_CCA_PIN(void)
#line 147
{
#line 147
  return (* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x10 + 0x20) & (1 << 6)) != 0;
}

static inline   
# 158 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420InterruptM.nc"
result_t HPLCC2420InterruptM$CCA$startWait(bool low_to_high)
#line 158
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 159
    HPLCC2420InterruptM$CCAWaitForState = low_to_high;
#line 159
    __nesc_atomic_end(__nesc_atomic); }
  HPLCC2420InterruptM$CCALastState = TOSH_READ_CC_CCA_PIN();
  return HPLCC2420InterruptM$CCATimer$start(TIMER_ONE_SHOT, 1);
}

# 43 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t CC2420ControlM$CCA$startWait(bool arg_0xa694cc0){
#line 43
  unsigned char result;
#line 43

#line 43
  result = HPLCC2420InterruptM$CCA$startWait(arg_0xa694cc0);
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 54 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
inline static   uint8_t CC2420ControlM$HPLChipcon$write(uint8_t arg_0xa6725f8, uint16_t arg_0xa672748){
#line 54
  unsigned char result;
#line 54

#line 54
  result = HPLCC2420M$HPLCC2420$write(arg_0xa6725f8, arg_0xa672748);
#line 54

#line 54
  return result;
#line 54
}
#line 54
static inline   
# 368 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
result_t CC2420ControlM$CC2420Control$OscillatorOn(void)
#line 368
{
  uint16_t i;
  uint8_t status;

  i = 0;
#line 384
  CC2420ControlM$HPLChipcon$write(0x1D, 24);


  CC2420ControlM$CCA$startWait(TRUE);


  status = CC2420ControlM$HPLChipcon$cmd(0x01);

  return SUCCESS;
}

static inline 
# 149 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/avrmote/avrhardware.h"
void TOSH_wait(void)
{
   __asm volatile ("nop");
   __asm volatile ("nop");}

# 141 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_SET_CC_RSTN_PIN(void)
#line 141
{
#line 141
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1B + 0x20) |= 1 << 6;
}

#line 141
static __inline void TOSH_CLR_CC_RSTN_PIN(void)
#line 141
{
#line 141
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1B + 0x20) &= ~(1 << 6);
}

static 
#line 101
void __inline TOSH_uwait(int u_sec)
#line 101
{
  while (u_sec > 0) {
       __asm volatile ("nop");
       __asm volatile ("nop");
       __asm volatile ("nop");
       __asm volatile ("nop");
       __asm volatile ("nop");
       __asm volatile ("nop");
       __asm volatile ("nop");
       __asm volatile ("nop");
      u_sec--;
    }
}

#line 142
static __inline void TOSH_SET_CC_VREN_PIN(void)
#line 142
{
#line 142
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1B + 0x20) |= 1 << 5;
}

static inline   
# 400 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
result_t CC2420ControlM$CC2420Control$VREFOn(void)
#line 400
{
  TOSH_SET_CC_VREN_PIN();

  TOSH_uwait(600);
  return SUCCESS;
}

static inline   
# 129 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer1M.nc"
result_t HPLTimer1M$Timer1$setRate(uint16_t interval, char scale)
#line 129
{


  scale &= 0x7;
  scale |= 0x8;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 134
    {
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x2F + 0x20) = 0;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x37 + 0x20) &= ~(1 << 4);
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x37 + 0x20) &= ~(1 << 2);
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x37 + 0x20) &= ~(1 << 5);
      * (volatile unsigned int *)(unsigned int )& * (volatile unsigned char *)(0x2C + 0x20) = 0;
      * (volatile unsigned int *)(unsigned int )& * (volatile unsigned char *)(0x2A + 0x20) = interval;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x36 + 0x20) |= 1 << 4;

      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x2E + 0x20) = scale;
    }
#line 144
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

static inline  
#line 55
result_t HPLTimer1M$StdControl$start(void)
#line 55
{
  uint16_t mi;
  uint8_t ms;

#line 58
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 58
    {
      mi = HPLTimer1M$minterval;
      ms = HPLTimer1M$mscale;
    }
#line 61
    __nesc_atomic_end(__nesc_atomic); }
  HPLTimer1M$Timer1$setRate(mi, ms);
  return SUCCESS;
}

static inline  
# 95 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420M.nc"
result_t HPLCC2420M$StdControl$start(void)
#line 95
{
#line 95
  return SUCCESS;
}

# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t CC2420ControlM$HPLChipconControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = HPLCC2420M$StdControl$start();
#line 70
  result = rcombine(result, HPLTimer1M$StdControl$start());
#line 70

#line 70
  return result;
#line 70
}
#line 70
static inline  
# 227 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
result_t CC2420ControlM$SplitControl$start(void)
#line 227
{
  result_t status;
  uint8_t _state = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 231
    {
      if (CC2420ControlM$state == CC2420ControlM$INIT_STATE_DONE) {
          CC2420ControlM$state = CC2420ControlM$START_STATE;
          _state = TRUE;
        }
    }
#line 236
    __nesc_atomic_end(__nesc_atomic); }
  if (!_state) {
    return FAIL;
    }
  CC2420ControlM$HPLChipconControl$start();

  CC2420ControlM$CC2420Control$VREFOn();

  TOSH_CLR_CC_RSTN_PIN();
  TOSH_wait();
  TOSH_SET_CC_RSTN_PIN();
  TOSH_wait();


  status = CC2420ControlM$CC2420Control$OscillatorOn();

  return status;
}

# 77 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
inline static  result_t CC2420RadioM$CC2420SplitControl$start(void){
#line 77
  unsigned char result;
#line 77

#line 77
  result = CC2420ControlM$SplitControl$start();
#line 77

#line 77
  return result;
#line 77
}
#line 77
static inline 
# 64 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/HPLPowerManagementM.nc"
uint8_t HPLPowerManagementM$getPowerLevel(void)
#line 64
{
  uint8_t diff;

#line 66
  if (* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x37 + 0x20) & ~((1 << 1) | (1 << 0))) {

      return HPLPowerManagementM$IDLE;
    }
  else {
#line 69
    if (* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0D + 0x20) & (1 << 7)) {
        return HPLPowerManagementM$IDLE;
      }
    else {
      if (* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x06 + 0x20) & (1 << 7)) {
          return HPLPowerManagementM$ADC_NR;
        }
      else {
#line 75
        if (* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x37 + 0x20) & ((1 << 1) | (1 << 0))) {
            diff = * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x31 + 0x20) - * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x32 + 0x20);
            if (diff < 16) {
              return HPLPowerManagementM$EXT_STANDBY;
              }
#line 79
            return HPLPowerManagementM$POWER_SAVE;
          }
        else 
#line 80
          {
            return HPLPowerManagementM$POWER_DOWN;
          }
        }
      }
    }
}

static inline  
#line 85
void HPLPowerManagementM$doAdjustment(void)
#line 85
{
  uint8_t foo;
#line 86
  uint8_t mcu;

#line 87
  HPLPowerManagementM$powerLevel = foo = HPLPowerManagementM$getPowerLevel();
  mcu = * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x35 + 0x20);
  mcu &= 0xe3;
  if (foo == HPLPowerManagementM$EXT_STANDBY || foo == HPLPowerManagementM$POWER_SAVE) {
      mcu |= HPLPowerManagementM$IDLE;
      while ((* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x30 + 0x20) & 0x7) != 0) {
           __asm volatile ("nop");}

      mcu &= 0xe3;
    }
  mcu |= foo;
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x35 + 0x20) = mcu;
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x35 + 0x20) |= 1 << 5;
}

static 
# 186 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/avrmote/avrhardware.h"
__inline void __nesc_enable_interrupt(void)
#line 186
{
   __asm volatile ("sei");}

#line 171
__inline void  __nesc_atomic_end(__nesc_atomic_t oldSreg)
{
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x3F + 0x20) = oldSreg;
}

static 

__inline void __nesc_atomic_sleep(void)
{

   __asm volatile ("sei");
   __asm volatile ("sleep");
  TOSH_wait();
}

#line 164
__inline __nesc_atomic_t  __nesc_atomic_start(void )
{
  __nesc_atomic_t result = * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x3F + 0x20);

#line 167
   __asm volatile ("cli");
  return result;
}

static inline 
# 136 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/sched.c"
bool TOSH_run_next_task(void)
{
  __nesc_atomic_t fInterruptFlags;
  uint8_t old_full;
  void (*func)(void );

  fInterruptFlags = __nesc_atomic_start();
  old_full = TOSH_sched_full;
  func = TOSH_queue[old_full].tp;
  if (func == (void *)0) 
    {
      __nesc_atomic_sleep();
      return 0;
    }

  TOSH_queue[old_full].tp = (void *)0;
  TOSH_sched_full = (old_full + 1) & TOSH_TASK_BITMASK;
  __nesc_atomic_end(fInterruptFlags);
  func();

  return 1;
}

static inline void TOSH_run_task(void)
#line 159
{
  for (; ; ) 
    TOSH_run_next_task();
}

static inline   
# 97 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica/HPLClock.nc"
uint8_t HPLClock$Clock$getInterval(void)
#line 97
{
  return * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x31 + 0x20);
}

# 121 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Clock.nc"
inline static   uint8_t TimerM$Clock$getInterval(void){
#line 121
  unsigned char result;
#line 121

#line 121
  result = HPLClock$Clock$getInterval();
#line 121

#line 121
  return result;
#line 121
}
#line 121
# 41 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/PowerManagement.nc"
inline static   uint8_t TimerM$PowerManagement$adjustPower(void){
#line 41
  unsigned char result;
#line 41

#line 41
  result = HPLPowerManagementM$PowerManagement$adjustPower();
#line 41

#line 41
  return result;
#line 41
}
#line 41
static inline   
# 87 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica/HPLClock.nc"
void HPLClock$Clock$setInterval(uint8_t value)
#line 87
{
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x31 + 0x20) = value;
}

# 105 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Clock.nc"
inline static   void TimerM$Clock$setInterval(uint8_t arg_0xa43ab10){
#line 105
  HPLClock$Clock$setInterval(arg_0xa43ab10);
#line 105
}
#line 105
static inline   
# 134 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica/HPLClock.nc"
uint8_t HPLClock$Clock$readCounter(void)
#line 134
{
  return * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x32 + 0x20);
}

# 153 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Clock.nc"
inline static   uint8_t TimerM$Clock$readCounter(void){
#line 153
  unsigned char result;
#line 153

#line 153
  result = HPLClock$Clock$readCounter();
#line 153

#line 153
  return result;
#line 153
}
#line 153
# 129 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/TimerM.nc"
static void TimerM$adjustInterval(void)
#line 129
{
  uint8_t i;
#line 130
  uint8_t val = TimerM$maxTimerInterval;

#line 131
  if (TimerM$mState) {
      for (i = 0; i < NUM_TIMERS; i++) {
          if (TimerM$mState & (0x1L << i) && TimerM$mTimerList[i].ticksLeft < val) {
              val = TimerM$mTimerList[i].ticksLeft;
            }
        }
#line 148
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 148
        {
          i = TimerM$Clock$readCounter() + 3;
          if (val < i) {
              val = i;
            }
          TimerM$mInterval = val;
          TimerM$Clock$setInterval(TimerM$mInterval);
          TimerM$setIntervalFlag = 0;
        }
#line 156
        __nesc_atomic_end(__nesc_atomic); }
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 159
        {
          TimerM$mInterval = TimerM$maxTimerInterval;
          TimerM$Clock$setInterval(TimerM$mInterval);
          TimerM$setIntervalFlag = 0;
        }
#line 163
        __nesc_atomic_end(__nesc_atomic); }
    }
  TimerM$PowerManagement$adjustPower();
}

static inline 
#line 186
void TimerM$enqueue(uint8_t value)
#line 186
{
  if (TimerM$queue_tail == NUM_TIMERS - 1) {
    TimerM$queue_tail = -1;
    }
#line 189
  TimerM$queue_tail++;
  TimerM$queue_size++;
  TimerM$queue[(uint8_t )TimerM$queue_tail] = value;
}

static inline  
# 268 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
result_t TransceiverM$Transceiver$sendRadio(uint8_t type, uint16_t dest, 
uint8_t payloadSize)
#line 269
{
  return TransceiverM$pack(type, dest, payloadSize, RADIO);
}

# 84 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
inline static  result_t BasicRoutingM$Transceiver$sendRadio(uint16_t arg_0xa33a780, uint8_t arg_0xa33a8d0){
#line 84
  unsigned char result;
#line 84

#line 84
  result = TransceiverM$Transceiver$sendRadio(AM_SIMPLECMDMSG, arg_0xa33a780, arg_0xa33a8d0);
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 84 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
inline static  result_t SensorToRfmM$Send$sendRadio(uint16_t arg_0xa33a780, uint8_t arg_0xa33a8d0){
#line 84
  unsigned char result;
#line 84

#line 84
  result = TransceiverM$Transceiver$sendRadio(AM_SENSORMSG, arg_0xa33a780, arg_0xa33a8d0);
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 61 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
inline static  TOS_MsgPtr SensorToRfmM$Send$requestWrite(void){
#line 61
  struct TOS_Msg *result;
#line 61

#line 61
  result = TransceiverM$Transceiver$requestWrite(AM_SENSORMSG);
#line 61

#line 61
  return result;
#line 61
}
#line 61
static inline 
# 155 "SensorToRfmM.nc"
result_t SensorToRfmM$newMessage(void)
#line 155
{
  if ((SensorToRfmM$tosPtr = SensorToRfmM$Send$requestWrite()) != (void *)0) {
      SensorToRfmM$message = (SensorMsg *)SensorToRfmM$tosPtr->data;
      return SUCCESS;
    }
  return FAIL;
}

static inline  
#line 98
result_t SensorToRfmM$SensorOutput$output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type)
{

  uint16_t LCV = 0;

  if (SensorToRfmM$newMessage()) {





      for (LCV; LCV < 5; LCV++) 
        SensorToRfmM$message->val[LCV] = measurements[LCV];

      SensorToRfmM$message->next_addr = next_addr;
      SensorToRfmM$message->dest_addr = dest_addr;
      SensorToRfmM$message->src = source;
      SensorToRfmM$message->hops = hops;
      SensorToRfmM$message->msg_type = msg_type;

      if (SensorToRfmM$Send$sendRadio(next_addr, sizeof(SensorMsg ))) {
        return SUCCESS;
        }
    }


  return FAIL;
}

# 61 "SensorOutput.nc"
inline static  result_t BasicRoutingM$RadioOut$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, uint16_t arg_0xa323568, uint16_t arg_0xa3236c0){
#line 61
  unsigned char result;
#line 61

#line 61
  result = SensorToRfmM$SensorOutput$output(arg_0xa323008, arg_0xa323158, arg_0xa3232b0, arg_0xa323408, arg_0xa323568, arg_0xa3236c0);
#line 61

#line 61
  return result;
#line 61
}
#line 61
static inline  
# 214 "BasicRoutingM.nc"
result_t BasicRoutingM$SensorTimer$fired(void)
{
  uint16_t LCV = 0;

#line 217
  for (LCV; LCV < 20; LCV++) 
    {
      if (BasicRoutingM$MessagesPending[LCV][0] == 1) 
        {
          BasicRoutingM$MessagesPending[LCV][1] = BasicRoutingM$MessagesPending[LCV][1] - 1;
          if (BasicRoutingM$MessagesPending[LCV][1] == 0) 
            {
              uint16_t display_array[5];

#line 225
              display_array[0] = BasicRoutingM$MessagesPendingData[LCV][0];
              display_array[1] = BasicRoutingM$MessagesPendingData[LCV][1];
              display_array[2] = BasicRoutingM$MessagesPendingData[LCV][2];
              display_array[3] = BasicRoutingM$MessagesPendingData[LCV][3];
              display_array[4] = BasicRoutingM$MessagesPendingData[LCV][4];
              BasicRoutingM$RadioOut$output(display_array, BasicRoutingM$MessagesPending[LCV][2], BasicRoutingM$MessagesPending[LCV][3], BasicRoutingM$MessagesPending[LCV][4], BasicRoutingM$MessagesPending[LCV][5], BasicRoutingM$MessagesPending[LCV][6]);
              BasicRoutingM$MessagesPending[LCV][0] = 0;
            }
        }
    }

  if (TOS_LOCAL_ADDRESS == 0) 
    {
#line 262
      if (BasicRoutingM$CounterTilNextWavelet < 1499) 
        {
          BasicRoutingM$CounterTilNextWavelet = BasicRoutingM$CounterTilNextWavelet + 1;
        }
      else {
#line 266
        if (BasicRoutingM$CounterTilNextWavelet == 1499) 
          {
            BasicRoutingM$CounterTilNextWavelet = BasicRoutingM$CounterTilNextWavelet + 1;

            if (BasicRoutingM$newMessage()) {

                uint16_t LCV = BasicRoutingM$MsgsAlreadySentLength - 1;

#line 273
                for (LCV; LCV > 0; LCV--) 

                  BasicRoutingM$MsgsAlreadySent[LCV] = BasicRoutingM$MsgsAlreadySent[LCV - 1];

                BasicRoutingM$MsgsAlreadySent[0] = BasicRoutingM$MsgsAlreadySent[0] + 1;
                BasicRoutingM$cmdMsg->seqno = BasicRoutingM$MsgsAlreadySent[0];
                BasicRoutingM$cmdMsg->action = 0x0004;
                BasicRoutingM$Transceiver$sendRadio(TOS_BCAST_ADDR, sizeof(SimpleCmdMsg ));
              }
          }
        else {
          if (BasicRoutingM$CounterTilNextWavelet < 2999) 
            {
              BasicRoutingM$CounterTilNextWavelet = BasicRoutingM$CounterTilNextWavelet + 1;
            }
          else 
            {
              BasicRoutingM$CounterTilNextWavelet = 0;

              if (BasicRoutingM$newMessage()) {

                  uint16_t LCV = BasicRoutingM$MsgsAlreadySentLength - 1;

#line 295
                  for (LCV; LCV > 0; LCV--) 

                    BasicRoutingM$MsgsAlreadySent[LCV] = BasicRoutingM$MsgsAlreadySent[LCV - 1];

                  BasicRoutingM$MsgsAlreadySent[0] = BasicRoutingM$MsgsAlreadySent[0] + 1;
                  BasicRoutingM$cmdMsg->seqno = BasicRoutingM$MsgsAlreadySent[0];
                  BasicRoutingM$cmdMsg->action = 0x0003;
                  BasicRoutingM$Transceiver$sendRadio(TOS_BCAST_ADDR, sizeof(SimpleCmdMsg ));
                }
            }
          }
        }
    }
#line 306
  return SUCCESS;
}

# 73 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t SenseToSensor$SensorTimer$fired(void){
#line 73
  unsigned char result;
#line 73

#line 73
  result = BasicRoutingM$SensorTimer$fired();
#line 73

#line 73
  return result;
#line 73
}
#line 73
static inline   
# 358 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/PhotoTempM.nc"
result_t PhotoTempM$ExternalTempADC$getData(void)
#line 358
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 359
    {
      PhotoTempM$tempSensor = PhotoTempM$stateReadOnce;
    }
#line 361
    __nesc_atomic_end(__nesc_atomic); }
#line 361
  ;
  TOS_post(PhotoTempM$getSample);
  return SUCCESS;
}

# 52 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
inline static   result_t SenseToSensor$TempADC$getData(void){
#line 52
  unsigned char result;
#line 52

#line 52
  result = PhotoTempM$ExternalTempADC$getData();
#line 52

#line 52
  return result;
#line 52
}
#line 52
static inline  
# 128 "SenseToSensor.nc"
result_t SenseToSensor$Timer$fired(void)
{
  if (SenseToSensor$counter < 599) 
    {
      SenseToSensor$counter = SenseToSensor$counter + 1;
    }
  else 
    {
      if (TOS_LOCAL_ADDRESS != 0) 
        {
          SenseToSensor$TempADC$getData();
        }
      SenseToSensor$counter = 0;
    }
  SenseToSensor$SensorTimer$fired();

  return SUCCESS;
}

static inline   
# 220 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCREFM.nc"
result_t ADCREFM$ADC$getData(uint8_t port)
#line 220
{
  result_t Result;

#line 222
  if (port > TOSH_ADC_PORTMAPSIZE) {
      return FAIL;
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 226
    {
      Result = ADCREFM$startGet(port);
    }
#line 228
    __nesc_atomic_end(__nesc_atomic); }
  return Result;
}

# 52 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
inline static   result_t PhotoTempM$InternalTempADC$getData(void){
#line 52
  unsigned char result;
#line 52

#line 52
  result = ADCREFM$ADC$getData(TOS_ADC_TEMP_PORT);
#line 52

#line 52
  return result;
#line 52
}
#line 52
# 52 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
inline static   result_t PhotoTempM$InternalPhotoADC$getData(void){
#line 52
  unsigned char result;
#line 52

#line 52
  result = ADCREFM$ADC$getData(TOS_ADC_PHOTO_PORT);
#line 52

#line 52
  return result;
#line 52
}
#line 52
static inline  
# 312 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/PhotoTempM.nc"
result_t PhotoTempM$PhotoTempTimer$fired(void)
#line 312
{
  switch (PhotoTempM$hardwareStatus) {
      case PhotoTempM$sensorIdle: 
        case PhotoTempM$sensorTempReady: 
          case PhotoTempM$sensorPhotoReady: 

            break;
      case PhotoTempM$sensorPhotoStarting: 
        PhotoTempM$hardwareStatus = PhotoTempM$sensorPhotoReady;
      if (PhotoTempM$InternalPhotoADC$getData() == SUCCESS) {

          return SUCCESS;
        }
#line 324
      ;
      break;
      case PhotoTempM$sensorTempStarting: 
        PhotoTempM$hardwareStatus = PhotoTempM$sensorTempReady;
      if (PhotoTempM$InternalTempADC$getData() == SUCCESS) {

          return SUCCESS;
        }
#line 331
      ;
      break;
    }
#line 333
  ;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 335
    {
      PhotoTempM$waitingForSample = FALSE;
    }
#line 337
    __nesc_atomic_end(__nesc_atomic); }
#line 337
  ;
  TOS_post(PhotoTempM$getSample);
  return SUCCESS;
}

static inline   
# 282 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCREFM.nc"
result_t ADCREFM$ADCControl$manualCalibrate(void)
#line 282
{
  result_t Result;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 285
    {
      Result = ADCREFM$startGet(TOS_ADC_BANDGAP_PORT);
    }
#line 287
    __nesc_atomic_end(__nesc_atomic); }

  return Result;
}

static inline  
#line 92
void ADCREFM$CalTask(void)
#line 92
{

  ADCREFM$ADCControl$manualCalibrate();

  return;
}

static inline  
#line 126
result_t ADCREFM$Timer$fired(void)
#line 126
{

  TOS_post(ADCREFM$CalTask);

  return SUCCESS;
}

static inline  
# 151 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/AMStandard.nc"
result_t AMStandard$ActivityTimer$fired(void)
#line 151
{
  AMStandard$lastCount = AMStandard$counter;
  AMStandard$counter = 0;
  return SUCCESS;
}

static inline   
# 279 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
result_t CC2420RadioM$SplitControl$default$startDone(void)
#line 279
{
  return SUCCESS;
}

# 85 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
inline static  result_t CC2420RadioM$SplitControl$startDone(void){
#line 85
  unsigned char result;
#line 85

#line 85
  result = CC2420RadioM$SplitControl$default$startDone();
#line 85

#line 85
  return result;
#line 85
}
#line 85
static inline   
# 252 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer1M.nc"
void HPLTimer1M$CaptureT1$enableEvents(void)
#line 252
{

  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x2E + 0x20) &= ~(1 << 4);
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x2E + 0x20) &= ~(1 << 3);
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x37 + 0x20) |= 1 << 5;
}

# 62 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/TimerCapture.nc"
inline static   void HPLCC2420InterruptM$SFDCapture$enableEvents(void){
#line 62
  HPLTimer1M$CaptureT1$enableEvents();
#line 62
}
#line 62
static inline   
# 236 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer1M.nc"
void HPLTimer1M$CaptureT1$clearOverflow(void)
#line 236
{
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x36 + 0x20) |= 1 << 2;
  return;
}

# 52 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/TimerCapture.nc"
inline static   void HPLCC2420InterruptM$SFDCapture$clearOverflow(void){
#line 52
  HPLTimer1M$CaptureT1$clearOverflow();
#line 52
}
#line 52
#line 40
inline static   void HPLCC2420InterruptM$SFDCapture$setEdge(uint8_t arg_0xa75e2f0){
#line 40
  HPLTimer1M$CaptureT1$setEdge(arg_0xa75e2f0);
#line 40
}
#line 40
static inline   
# 262 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer1M.nc"
void HPLTimer1M$CaptureT1$disableEvents(void)
#line 262
{
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x37 + 0x20) &= ~(1 << 5);
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x36 + 0x20) |= 1 << 5;
}

# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/TimerCapture.nc"
inline static   void HPLCC2420InterruptM$SFDCapture$disableEvents(void){
#line 63
  HPLTimer1M$CaptureT1$disableEvents();
#line 63
}
#line 63
static inline   
# 200 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420InterruptM.nc"
result_t HPLCC2420InterruptM$SFD$enableCapture(bool low_to_high)
#line 200
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 201
    {

      HPLCC2420InterruptM$SFDCapture$disableEvents();
      HPLCC2420InterruptM$SFDCapture$setEdge(low_to_high);
      HPLCC2420InterruptM$SFDCapture$clearOverflow();
      HPLCC2420InterruptM$SFDCapture$enableEvents();
    }
#line 207
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 43 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
inline static   result_t CC2420RadioM$SFD$enableCapture(bool arg_0xa6b0988){
#line 43
  unsigned char result;
#line 43

#line 43
  result = HPLCC2420InterruptM$SFD$enableCapture(arg_0xa6b0988);
#line 43

#line 43
  return result;
#line 43
}
#line 43
static 
# 131 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
void __inline CC2420_FIFOP_INT_MODE(bool LowToHigh)
#line 131
{
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x3A + 0x20) |= 1 << 5;
  if (LowToHigh) {
    * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x3A + 0x20) |= 1 << 4;
    }
  else {
#line 136
    * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x3A + 0x20) &= ~(1 << 4);
    }
}

static inline   
# 78 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420InterruptM.nc"
result_t HPLCC2420InterruptM$FIFOP$startWait(bool low_to_high)
#line 78
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 79
    {
      CC2420_FIFOP_INT_MODE(low_to_high);
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x39 + 0x20) |= 1 << 6;
    }
#line 82
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 43 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t CC2420RadioM$FIFOP$startWait(bool arg_0xa694cc0){
#line 43
  unsigned char result;
#line 43

#line 43
  result = HPLCC2420InterruptM$FIFOP$startWait(arg_0xa694cc0);
#line 43

#line 43
  return result;
#line 43
}
#line 43
static inline   
# 343 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
result_t CC2420ControlM$CC2420Control$RxMode(void)
#line 343
{
  CC2420ControlM$HPLChipcon$cmd(0x03);
  return SUCCESS;
}

# 163 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
inline static   result_t CC2420RadioM$CC2420Control$RxMode(void){
#line 163
  unsigned char result;
#line 163

#line 163
  result = CC2420ControlM$CC2420Control$RxMode();
#line 163

#line 163
  return result;
#line 163
}
#line 163
static inline  
# 261 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
result_t CC2420RadioM$CC2420SplitControl$startDone(void)
#line 261
{
  uint8_t chkstateRadio;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 264
    chkstateRadio = CC2420RadioM$stateRadio;
#line 264
    __nesc_atomic_end(__nesc_atomic); }

  if (chkstateRadio == CC2420RadioM$WARMUP_STATE) {
      CC2420RadioM$CC2420Control$RxMode();

      CC2420RadioM$FIFOP$startWait(FALSE);

      CC2420RadioM$SFD$enableCapture(TRUE);

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 273
        CC2420RadioM$stateRadio = CC2420RadioM$IDLE_STATE;
#line 273
        __nesc_atomic_end(__nesc_atomic); }
    }
  CC2420RadioM$SplitControl$startDone();
  return SUCCESS;
}

# 85 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
inline static  result_t CC2420ControlM$SplitControl$startDone(void){
#line 85
  unsigned char result;
#line 85

#line 85
  result = CC2420RadioM$CC2420SplitControl$startDone();
#line 85

#line 85
  return result;
#line 85
}
#line 85
static inline  
# 286 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
result_t CC2420ControlM$CC2420Control$TuneManual(uint16_t DesiredFreq)
#line 286
{
  int fsctrl;
  uint8_t status;

  fsctrl = DesiredFreq - 2048;
  CC2420ControlM$gCurrentParameters[CP_FSCTRL] = (CC2420ControlM$gCurrentParameters[CP_FSCTRL] & 0xfc00) | (fsctrl << 0);
  status = CC2420ControlM$HPLChipcon$write(0x18, CC2420ControlM$gCurrentParameters[CP_FSCTRL]);


  if (status & (1 << 6)) {
    CC2420ControlM$HPLChipcon$cmd(0x03);
    }
#line 297
  return SUCCESS;
}

static inline   
#line 441
result_t CC2420ControlM$HPLChipconRAM$writeDone(uint16_t addr, uint8_t length, uint8_t *buffer)
#line 441
{
  return SUCCESS;
}

# 49 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
inline static   result_t HPLCC2420M$HPLCC2420RAM$writeDone(uint16_t arg_0xa6cd938, uint8_t arg_0xa6cda80, uint8_t *arg_0xa6cdbe0){
#line 49
  unsigned char result;
#line 49

#line 49
  result = CC2420ControlM$HPLChipconRAM$writeDone(arg_0xa6cd938, arg_0xa6cda80, arg_0xa6cdbe0);
#line 49

#line 49
  return result;
#line 49
}
#line 49
static inline  
# 197 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420M.nc"
void HPLCC2420M$signalRAMWr(void)
#line 197
{
  HPLCC2420M$HPLCC2420RAM$writeDone(HPLCC2420M$ramaddr, HPLCC2420M$ramlen, HPLCC2420M$rambuf);
}

# 149 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_CLR_CC_CS_PIN(void)
#line 149
{
#line 149
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x18 + 0x20) &= ~(1 << 0);
}

static inline   
# 208 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420M.nc"
result_t HPLCC2420M$HPLCC2420RAM$write(uint16_t addr, uint8_t length, uint8_t *buffer)
#line 208
{
  uint8_t i = 0;
  uint8_t status;

  if (!HPLCC2420M$bSpiAvail) {
    return FALSE;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 215
    {
      HPLCC2420M$bSpiAvail = FALSE;
      HPLCC2420M$ramaddr = addr;
      HPLCC2420M$ramlen = length;
      HPLCC2420M$rambuf = buffer;
      TOSH_CLR_CC_CS_PIN();
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = (HPLCC2420M$ramaddr & 0x7F) | 0x80;
      while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
        }
#line 222
      ;
      status = * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20);
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = (HPLCC2420M$ramaddr >> 1) & 0xC0;
      while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
        }
#line 225
      ;
      status = * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20);

      for (i = 0; i < HPLCC2420M$ramlen; i++) {
          * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = HPLCC2420M$rambuf[i];

          while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
            }
#line 231
          ;
        }
    }
#line 233
    __nesc_atomic_end(__nesc_atomic); }
  HPLCC2420M$bSpiAvail = TRUE;
  return TOS_post(HPLCC2420M$signalRAMWr);
}

# 47 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
inline static   result_t CC2420ControlM$HPLChipconRAM$write(uint16_t arg_0xa6cd210, uint8_t arg_0xa6cd358, uint8_t *arg_0xa6cd4b8){
#line 47
  unsigned char result;
#line 47

#line 47
  result = HPLCC2420M$HPLCC2420RAM$write(arg_0xa6cd210, arg_0xa6cd358, arg_0xa6cd4b8);
#line 47

#line 47
  return result;
#line 47
}
#line 47
static 
# 12 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/byteorder.h"
__inline int is_host_lsb(void)
{
  const uint8_t n[2] = { 1, 0 };

#line 15
  return * (uint16_t *)n == 1;
}

static __inline uint16_t toLSB16(uint16_t a)
{
  return is_host_lsb() ? a : (a << 8) | (a >> 8);
}

static inline  
# 432 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
result_t CC2420ControlM$CC2420Control$setShortAddress(uint16_t addr)
#line 432
{
  addr = toLSB16(addr);
  return CC2420ControlM$HPLChipconRAM$write(0x16A, 2, (uint8_t *)&addr);
}

# 61 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
inline static   uint16_t CC2420ControlM$HPLChipcon$read(uint8_t arg_0xa672bf0){
#line 61
  unsigned int result;
#line 61

#line 61
  result = HPLCC2420M$HPLCC2420$read(arg_0xa672bf0);
#line 61

#line 61
  return result;
#line 61
}
#line 61
static inline 
# 80 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
bool CC2420ControlM$SetRegs(void)
#line 80
{
  uint16_t data;

  CC2420ControlM$HPLChipcon$write(0x10, CC2420ControlM$gCurrentParameters[CP_MAIN]);
  CC2420ControlM$HPLChipcon$write(0x11, CC2420ControlM$gCurrentParameters[CP_MDMCTRL0]);
  data = CC2420ControlM$HPLChipcon$read(0x11);
  if (data != CC2420ControlM$gCurrentParameters[CP_MDMCTRL0]) {
#line 86
    return FALSE;
    }
  CC2420ControlM$HPLChipcon$write(0x12, CC2420ControlM$gCurrentParameters[CP_MDMCTRL1]);
  CC2420ControlM$HPLChipcon$write(0x13, CC2420ControlM$gCurrentParameters[CP_RSSI]);
  CC2420ControlM$HPLChipcon$write(0x14, CC2420ControlM$gCurrentParameters[CP_SYNCWORD]);
  CC2420ControlM$HPLChipcon$write(0x15, CC2420ControlM$gCurrentParameters[CP_TXCTRL]);
  CC2420ControlM$HPLChipcon$write(0x16, CC2420ControlM$gCurrentParameters[CP_RXCTRL0]);
  CC2420ControlM$HPLChipcon$write(0x17, CC2420ControlM$gCurrentParameters[CP_RXCTRL1]);
  CC2420ControlM$HPLChipcon$write(0x18, CC2420ControlM$gCurrentParameters[CP_FSCTRL]);

  CC2420ControlM$HPLChipcon$write(0x19, CC2420ControlM$gCurrentParameters[CP_SECCTRL0]);
  CC2420ControlM$HPLChipcon$write(0x1A, CC2420ControlM$gCurrentParameters[CP_SECCTRL1]);
  CC2420ControlM$HPLChipcon$write(0x1C, CC2420ControlM$gCurrentParameters[CP_IOCFG0]);
  CC2420ControlM$HPLChipcon$write(0x1D, CC2420ControlM$gCurrentParameters[CP_IOCFG1]);

  CC2420ControlM$HPLChipcon$cmd(0x09);
  CC2420ControlM$HPLChipcon$cmd(0x08);

  return TRUE;
}

static inline  








void CC2420ControlM$PostOscillatorOn(void)
#line 116
{

  CC2420ControlM$SetRegs();
  CC2420ControlM$CC2420Control$setShortAddress(TOS_LOCAL_ADDRESS);
  CC2420ControlM$CC2420Control$TuneManual(((CC2420ControlM$gCurrentParameters[CP_FSCTRL] << 0) & 0x1FF) + 2048);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 121
    CC2420ControlM$state = CC2420ControlM$START_STATE_DONE;
#line 121
    __nesc_atomic_end(__nesc_atomic); }
  CC2420ControlM$SplitControl$startDone();
}

static inline   
#line 445
result_t CC2420ControlM$CCA$fired(void)
#line 445
{

  CC2420ControlM$HPLChipcon$write(0x1D, 0);
  TOS_post(CC2420ControlM$PostOscillatorOn);
  return FAIL;
}

# 51 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t HPLCC2420InterruptM$CCA$fired(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = CC2420ControlM$CCA$fired();
#line 51

#line 51
  return result;
#line 51
}
#line 51
static inline  
# 175 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420InterruptM.nc"
result_t HPLCC2420InterruptM$CCATimer$fired(void)
#line 175
{
  uint8_t CCAState;
  result_t val = SUCCESS;

  CCAState = TOSH_READ_CC_CCA_PIN();

  if (HPLCC2420InterruptM$CCALastState != HPLCC2420InterruptM$CCAWaitForState && CCAState == HPLCC2420InterruptM$CCAWaitForState) {
      val = HPLCC2420InterruptM$CCA$fired();
      if (val == FAIL) {
        return SUCCESS;
        }
    }
  HPLCC2420InterruptM$CCALastState = CCAState;
  return HPLCC2420InterruptM$CCATimer$start(TIMER_ONE_SHOT, 1);
}

# 59 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t HPLCC2420InterruptM$FIFOTimer$start(char arg_0xa3459e8, uint32_t arg_0xa345b40){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(4, arg_0xa3459e8, arg_0xa345b40);
#line 59

#line 59
  return result;
#line 59
}
#line 59
static inline    
# 150 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420InterruptM.nc"
result_t HPLCC2420InterruptM$FIFO$default$fired(void)
#line 150
{
#line 150
  return FAIL;
}

# 51 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t HPLCC2420InterruptM$FIFO$fired(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = HPLCC2420InterruptM$FIFO$default$fired();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 150 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline int TOSH_READ_CC_FIFO_PIN(void)
#line 150
{
#line 150
  return (* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x16 + 0x20) & (1 << 7)) != 0;
}

static inline  
# 125 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420InterruptM.nc"
result_t HPLCC2420InterruptM$FIFOTimer$fired(void)
#line 125
{
  uint8_t FIFOState;
  result_t val = SUCCESS;

  FIFOState = TOSH_READ_CC_FIFO_PIN();
  if (HPLCC2420InterruptM$FIFOLastState != HPLCC2420InterruptM$FIFOWaitForState && FIFOState == HPLCC2420InterruptM$FIFOWaitForState) {

      val = HPLCC2420InterruptM$FIFO$fired();
      if (val == FAIL) {
        return SUCCESS;
        }
    }
  HPLCC2420InterruptM$FIFOLastState = FIFOState;
  return HPLCC2420InterruptM$FIFOTimer$start(TIMER_ONE_SHOT, 1);
}

static inline   
# 182 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/TimerM.nc"
result_t TimerM$Timer$default$fired(uint8_t id)
#line 182
{
  return SUCCESS;
}

# 73 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t TimerM$Timer$fired(uint8_t arg_0xa42c588){
#line 73
  unsigned char result;
#line 73

#line 73
  switch (arg_0xa42c588) {
#line 73
    case 0:
#line 73
      result = SenseToSensor$Timer$fired();
#line 73
      break;
#line 73
    case 1:
#line 73
      result = PhotoTempM$PhotoTempTimer$fired();
#line 73
      break;
#line 73
    case 2:
#line 73
      result = ADCREFM$Timer$fired();
#line 73
      break;
#line 73
    case 3:
#line 73
      result = AMStandard$ActivityTimer$fired();
#line 73
      break;
#line 73
    case 4:
#line 73
      result = HPLCC2420InterruptM$FIFOTimer$fired();
#line 73
      break;
#line 73
    case 5:
#line 73
      result = HPLCC2420InterruptM$CCATimer$fired();
#line 73
      break;
#line 73
    default:
#line 73
      result = TimerM$Timer$default$fired(arg_0xa42c588);
#line 73
    }
#line 73

#line 73
  return result;
#line 73
}
#line 73
static inline 
# 194 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/TimerM.nc"
uint8_t TimerM$dequeue(void)
#line 194
{
  if (TimerM$queue_size == 0) {
    return NUM_TIMERS;
    }
#line 197
  if (TimerM$queue_head == NUM_TIMERS - 1) {
    TimerM$queue_head = -1;
    }
#line 199
  TimerM$queue_head++;
  TimerM$queue_size--;
  return TimerM$queue[(uint8_t )TimerM$queue_head];
}

static inline  void TimerM$signalOneTimer(void)
#line 204
{
  uint8_t itimer = TimerM$dequeue();

#line 206
  if (itimer < NUM_TIMERS) {
    TimerM$Timer$fired(itimer);
    }
}

static inline  
#line 210
void TimerM$HandleFire(void)
#line 210
{
  uint8_t i;
  uint16_t int_out;

#line 213
  TimerM$setIntervalFlag = 1;


  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 216
    {
      int_out = TimerM$interval_outstanding;
      TimerM$interval_outstanding = 0;
    }
#line 219
    __nesc_atomic_end(__nesc_atomic); }
  if (TimerM$mState) {
      for (i = 0; i < NUM_TIMERS; i++) {
          if (TimerM$mState & (0x1L << i)) {
              TimerM$mTimerList[i].ticksLeft -= int_out;
              if (TimerM$mTimerList[i].ticksLeft <= 2) {


                  if (TOS_post(TimerM$signalOneTimer)) {
                      if (TimerM$mTimerList[i].type == TIMER_REPEAT) {
                          TimerM$mTimerList[i].ticksLeft += TimerM$mTimerList[i].ticks;
                        }
                      else 
#line 230
                        {
                          TimerM$mState &= ~(0x1L << i);
                        }
                      TimerM$enqueue(i);
                    }
                  else {
                      {
                      }
#line 236
                      ;


                      TimerM$mTimerList[i].ticksLeft = TimerM$mInterval;
                    }
                }
            }
        }
    }


  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 247
    int_out = TimerM$interval_outstanding;
#line 247
    __nesc_atomic_end(__nesc_atomic); }
  if (int_out == 0) {
    TimerM$adjustInterval();
    }
}

static inline   result_t TimerM$Clock$fire(void)
#line 253
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 254
    {



      if (TimerM$interval_outstanding == 0) {
        TOS_post(TimerM$HandleFire);
        }
      else {
        }
#line 261
      ;

      TimerM$interval_outstanding += TimerM$Clock$getInterval() + 1;
    }
#line 264
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 180 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Clock.nc"
inline static   result_t HPLClock$Clock$fire(void){
#line 180
  unsigned char result;
#line 180

#line 180
  result = TimerM$Clock$fire();
#line 180

#line 180
  return result;
#line 180
}
#line 180
# 162 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_SET_INT1_PIN(void)
#line 162
{
#line 162
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x03 + 0x20) |= 1 << 5;
}

# 73 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/sensorboard.h"
static __inline void TOSH_SET_PHOTO_CTL_PIN(void)
#line 73
{
#line 73
  TOSH_SET_INT1_PIN();
}

# 162 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_MAKE_INT1_OUTPUT(void)
#line 162
{
#line 162
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x02 + 0x20) |= 1 << 5;
}

# 73 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/sensorboard.h"
static __inline void TOSH_MAKE_PHOTO_CTL_OUTPUT(void)
#line 73
{
#line 73
  TOSH_MAKE_INT1_OUTPUT();
}

# 163 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_CLR_INT2_PIN(void)
#line 163
{
#line 163
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x03 + 0x20) &= ~(1 << 6);
}

# 74 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/sensorboard.h"
static __inline void TOSH_CLR_TEMP_CTL_PIN(void)
#line 74
{
#line 74
  TOSH_CLR_INT2_PIN();
}

# 163 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_MAKE_INT2_INPUT(void)
#line 163
{
#line 163
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x02 + 0x20) &= ~(1 << 6);
}

# 74 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/sensorboard.h"
static __inline void TOSH_MAKE_TEMP_CTL_INPUT(void)
#line 74
{
#line 74
  TOSH_MAKE_INT2_INPUT();
}

# 68 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t PhotoTempM$PhotoTempTimer$stop(void){
#line 68
  unsigned char result;
#line 68

#line 68
  result = TimerM$Timer$stop(1);
#line 68

#line 68
  return result;
#line 68
}
#line 68
# 59 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t PhotoTempM$PhotoTempTimer$start(char arg_0xa3459e8, uint32_t arg_0xa345b40){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(1, arg_0xa3459e8, arg_0xa345b40);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 162 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_CLR_INT1_PIN(void)
#line 162
{
#line 162
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x03 + 0x20) &= ~(1 << 5);
}

# 73 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/sensorboard.h"
static __inline void TOSH_CLR_PHOTO_CTL_PIN(void)
#line 73
{
#line 73
  TOSH_CLR_INT1_PIN();
}

# 162 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_MAKE_INT1_INPUT(void)
#line 162
{
#line 162
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x02 + 0x20) &= ~(1 << 5);
}

# 73 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/sensorboard.h"
static __inline void TOSH_MAKE_PHOTO_CTL_INPUT(void)
#line 73
{
#line 73
  TOSH_MAKE_INT1_INPUT();
}

# 163 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_SET_INT2_PIN(void)
#line 163
{
#line 163
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x03 + 0x20) |= 1 << 6;
}

# 74 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/sensorboard.h"
static __inline void TOSH_SET_TEMP_CTL_PIN(void)
#line 74
{
#line 74
  TOSH_SET_INT2_PIN();
}

# 163 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_MAKE_INT2_OUTPUT(void)
#line 163
{
#line 163
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x02 + 0x20) |= 1 << 6;
}

# 74 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/sensorboard.h"
static __inline void TOSH_MAKE_TEMP_CTL_OUTPUT(void)
#line 74
{
#line 74
  TOSH_MAKE_INT2_OUTPUT();
}

# 39 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/State/State.nc"
inline static  result_t TransceiverM$WriteState$requestState(uint8_t arg_0xa616b08){
#line 39
  unsigned char result;
#line 39

#line 39
  result = StateM$State$requestState(0, arg_0xa616b08);
#line 39

#line 39
  return result;
#line 39
}
#line 39
static inline 
# 479 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
void TransceiverM$advanceWriteIndex(void)
#line 479
{
  TransceiverM$nextWriteMsg++;
  TransceiverM$nextWriteMsg %= 6;
}

static inline  
# 107 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/State/StateM.nc"
result_t StateM$State$toIdle(uint8_t id)
#line 107
{
  StateM$state[id] = StateM$S_IDLE;
  return SUCCESS;
}

# 50 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/State/State.nc"
inline static  result_t TransceiverM$WriteState$toIdle(void){
#line 50
  unsigned char result;
#line 50

#line 50
  result = StateM$State$toIdle(0);
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 39 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/State/State.nc"
inline static  result_t TransceiverM$SendState$requestState(uint8_t arg_0xa616b08){
#line 39
  unsigned char result;
#line 39

#line 39
  result = StateM$State$requestState(1, arg_0xa616b08);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 63 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Random.nc"
inline static   uint16_t CC2420RadioM$Random$rand(void){
#line 63
  unsigned int result;
#line 63

#line 63
  result = RandomLFSR$Random$rand();
#line 63

#line 63
  return result;
#line 63
}
#line 63
static inline    
# 711 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
int16_t CC2420RadioM$MacBackoff$default$initialBackoff(TOS_MsgPtr m)
#line 711
{
  return (CC2420RadioM$Random$rand() & 0xF) + 1;
}

# 74 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/MacBackoff.nc"
inline static   int16_t CC2420RadioM$MacBackoff$initialBackoff(TOS_MsgPtr arg_0xa685888){
#line 74
  int result;
#line 74

#line 74
  result = CC2420RadioM$MacBackoff$default$initialBackoff(arg_0xa685888);
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 6 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
inline static   result_t CC2420RadioM$BackoffTimerJiffy$setOneShot(uint32_t arg_0xa68cb78){
#line 6
  unsigned char result;
#line 6

#line 6
  result = TimerJiffyAsyncM$TimerJiffyAsync$setOneShot(arg_0xa68cb78);
#line 6

#line 6
  return result;
#line 6
}
#line 6
static 
# 127 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
__inline result_t CC2420RadioM$setInitialTimer(uint16_t jiffy)
#line 127
{
  CC2420RadioM$stateTimer = CC2420RadioM$TIMER_INITIAL;
  if (jiffy == 0) {

    return CC2420RadioM$BackoffTimerJiffy$setOneShot(2);
    }
#line 132
  return CC2420RadioM$BackoffTimerJiffy$setOneShot(jiffy);
}

static inline  
#line 458
result_t CC2420RadioM$Send$send(TOS_MsgPtr pMsg)
#line 458
{
  uint8_t currentstate;

#line 460
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 460
    currentstate = CC2420RadioM$stateRadio;
#line 460
    __nesc_atomic_end(__nesc_atomic); }

  if (currentstate == CC2420RadioM$IDLE_STATE) {

      pMsg->fcflo = 0x08;
      if (CC2420RadioM$bAckEnable) {
        pMsg->fcfhi = 0x21;
        }
      else {
#line 468
        pMsg->fcfhi = 0x01;
        }
      pMsg->destpan = TOS_BCAST_ADDR;

      pMsg->addr = toLSB16(pMsg->addr);

      pMsg->length = pMsg->length + MSG_HEADER_SIZE + MSG_FOOTER_SIZE;

      pMsg->dsn = ++CC2420RadioM$currentDSN;

      pMsg->time = 0;

      CC2420RadioM$txlength = pMsg->length - MSG_FOOTER_SIZE;
      CC2420RadioM$txbufptr = pMsg;
      CC2420RadioM$countRetry = 8;

      if (CC2420RadioM$setInitialTimer(CC2420RadioM$MacBackoff$initialBackoff(CC2420RadioM$txbufptr) * 10)) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 485
            CC2420RadioM$stateRadio = CC2420RadioM$PRE_TX_STATE;
#line 485
            __nesc_atomic_end(__nesc_atomic); }
          return SUCCESS;
        }
    }
  return FAIL;
}

# 58 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
inline static  result_t TransceiverM$SendRadio$send(TOS_MsgPtr arg_0xa54a350){
#line 58
  unsigned char result;
#line 58

#line 58
  result = CC2420RadioM$Send$send(arg_0xa54a350);
#line 58

#line 58
  return result;
#line 58
}
#line 58
static inline  
# 351 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/FramerM.nc"
result_t FramerM$BareSendMsg$send(TOS_MsgPtr pMsg)
#line 351
{
  result_t Result = SUCCESS;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 354
    {
      if (!(FramerM$gFlags & FramerM$FLAGS_DATAPEND)) {
          FramerM$gFlags |= FramerM$FLAGS_DATAPEND;
          FramerM$gpTxMsg = pMsg;
        }
      else 

        {
          Result = FAIL;
        }
    }
#line 364
    __nesc_atomic_end(__nesc_atomic); }

  if (Result == SUCCESS) {
      Result = FramerM$StartTx();
    }

  return Result;
}

# 58 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
inline static  result_t TransceiverM$SendUart$send(TOS_MsgPtr arg_0xa54a350){
#line 58
  unsigned char result;
#line 58

#line 58
  result = FramerM$BareSendMsg$send(arg_0xa54a350);
#line 58

#line 58
  return result;
#line 58
}
#line 58
static inline   
# 105 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/HPLUART0M.nc"
result_t HPLUART0M$UART$put(uint8_t data)
#line 105
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 106
    {
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0C + 0x20) = data;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0B + 0x20) |= 1 << 6;
    }
#line 109
    __nesc_atomic_end(__nesc_atomic); }

  return SUCCESS;
}

# 80 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLUART.nc"
inline static   result_t UARTM$HPLUART$put(uint8_t arg_0xa5e1440){
#line 80
  unsigned char result;
#line 80

#line 80
  result = HPLUART0M$UART$put(arg_0xa5e1440);
#line 80

#line 80
  return result;
#line 80
}
#line 80
static inline   
# 160 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/AMStandard.nc"
result_t AMStandard$default$sendDone(void)
#line 160
{
  return SUCCESS;
}

#line 65
inline static  result_t AMStandard$sendDone(void){
#line 65
  unsigned char result;
#line 65

#line 65
  result = AMStandard$default$sendDone();
#line 65

#line 65
  return result;
#line 65
}
#line 65
static inline   
#line 157
result_t AMStandard$SendMsg$default$sendDone(uint8_t id, TOS_MsgPtr msg, result_t success)
#line 157
{
  return SUCCESS;
}

# 49 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
inline static  result_t AMStandard$SendMsg$sendDone(uint8_t arg_0xa532118, TOS_MsgPtr arg_0xa536e48, result_t arg_0xa536f98){
#line 49
  unsigned char result;
#line 49

#line 49
    result = AMStandard$SendMsg$default$sendDone(arg_0xa532118, arg_0xa536e48, arg_0xa536f98);
#line 49

#line 49
  return result;
#line 49
}
#line 49
static inline 
# 143 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/AMStandard.nc"
result_t AMStandard$reportSendDone(TOS_MsgPtr msg, result_t success)
#line 143
{
  AMStandard$state = FALSE;
  AMStandard$SendMsg$sendDone(msg->type, msg, success);
  AMStandard$sendDone();

  return SUCCESS;
}

static inline  
#line 207
result_t AMStandard$UARTSend$sendDone(TOS_MsgPtr msg, result_t success)
#line 207
{
  return AMStandard$reportSendDone(msg, success);
}

static inline  
# 592 "BasicRoutingM.nc"
result_t BasicRoutingM$Transceiver$uartSendDone(TOS_MsgPtr m, result_t result)
{
  return SUCCESS;
}

static inline  
# 128 "RfmToSensorM.nc"
result_t RfmToSensorM$ReceiveSensorMsg$uartSendDone(TOS_MsgPtr m, result_t result)
{
  return SUCCESS;
}

static inline  
# 143 "SensorToRfmM.nc"
result_t SensorToRfmM$Send$uartSendDone(TOS_MsgPtr m, result_t result)
{
  return SUCCESS;
}

static inline  
# 199 "SensorToUARTM.nc"
result_t SensorToUARTM$DataMsg$uartSendDone(TOS_MsgPtr sent, result_t success)
{
  return SUCCESS;
}

static inline  
#line 246
result_t SensorToUARTM$ResetCounterMsg$uartSendDone(TOS_MsgPtr m, result_t result)
{
  return SUCCESS;
}

static inline   
# 499 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
result_t TransceiverM$Transceiver$default$uartSendDone(uint8_t type, TOS_MsgPtr m, 
result_t result)
#line 500
{
  return SUCCESS;
}

# 126 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
inline static  result_t TransceiverM$Transceiver$uartSendDone(uint8_t arg_0xa5ff370, TOS_MsgPtr arg_0xa33e248, result_t arg_0xa33e398){
#line 126
  unsigned char result;
#line 126

#line 126
  switch (arg_0xa5ff370) {
#line 126
    case AM_SENSORMSG:
#line 126
      result = SensorToRfmM$Send$uartSendDone(arg_0xa33e248, arg_0xa33e398);
#line 126
      result = rcombine(result, RfmToSensorM$ReceiveSensorMsg$uartSendDone(arg_0xa33e248, arg_0xa33e398));
#line 126
      break;
#line 126
    case AM_SIMPLECMDMSG:
#line 126
      result = BasicRoutingM$Transceiver$uartSendDone(arg_0xa33e248, arg_0xa33e398);
#line 126
      break;
#line 126
    case AM_CPUMSG:
#line 126
      result = SensorToUARTM$DataMsg$uartSendDone(arg_0xa33e248, arg_0xa33e398);
#line 126
      break;
#line 126
    case AM_CPURESETMSG:
#line 126
      result = SensorToUARTM$ResetCounterMsg$uartSendDone(arg_0xa33e248, arg_0xa33e398);
#line 126
      break;
#line 126
    default:
#line 126
      result = TransceiverM$Transceiver$default$uartSendDone(arg_0xa5ff370, arg_0xa33e248, arg_0xa33e398);
#line 126
    }
#line 126

#line 126
  return result;
#line 126
}
#line 126
static inline  
# 385 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
result_t TransceiverM$SendUart$sendDone(TOS_MsgPtr m, result_t result)
#line 385
{
  if (m == & TransceiverM$msg[TransceiverM$nextSendMsg].tosMsg) {
      TransceiverM$Transceiver$uartSendDone(m->type, m, result);
      TransceiverM$sendDone();
    }
  return SUCCESS;
}

# 67 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
inline static  result_t FramerM$BareSendMsg$sendDone(TOS_MsgPtr arg_0xa54a868, result_t arg_0xa54a9b8){
#line 67
  unsigned char result;
#line 67

#line 67
  result = TransceiverM$SendUart$sendDone(arg_0xa54a868, arg_0xa54a9b8);
#line 67
  result = rcombine(result, AMStandard$UARTSend$sendDone(arg_0xa54a868, arg_0xa54a9b8));
#line 67

#line 67
  return result;
#line 67
}
#line 67
static inline 
# 487 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
void TransceiverM$advanceSendIndex(void)
#line 487
{
  TransceiverM$nextSendMsg++;
  TransceiverM$nextSendMsg %= 6;
}

# 50 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/State/State.nc"
inline static  result_t TransceiverM$SendState$toIdle(void){
#line 50
  unsigned char result;
#line 50

#line 50
  result = StateM$State$toIdle(1);
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 61 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
inline static  TOS_MsgPtr BasicRoutingM$Transceiver$requestWrite(void){
#line 61
  struct TOS_Msg *result;
#line 61

#line 61
  result = TransceiverM$Transceiver$requestWrite(AM_SIMPLECMDMSG);
#line 61

#line 61
  return result;
#line 61
}
#line 61
static inline  
# 527 "BasicRoutingM.nc"
result_t BasicRoutingM$TempIn$output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type)
{
  BasicRoutingM$CurrentTempVal = measurements[0];

  return SUCCESS;
}

# 61 "SensorOutput.nc"
inline static  result_t SenseToSensor$TempOutput$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, uint16_t arg_0xa323568, uint16_t arg_0xa3236c0){
#line 61
  unsigned char result;
#line 61

#line 61
  result = BasicRoutingM$TempIn$output(arg_0xa323008, arg_0xa323158, arg_0xa3232b0, arg_0xa323408, arg_0xa323568, arg_0xa3236c0);
#line 61

#line 61
  return result;
#line 61
}
#line 61
static inline  
# 108 "SenseToSensor.nc"
void SenseToSensor$tempTask(void)
{
  uint16_t tCopy[5] = { 0, 0, 0, 0, 0 };

#line 111
  tCopy[0] = SenseToSensor$curr_temp;



  SenseToSensor$TempOutput$output(tCopy, 0x0000, 0x0000, 0x0000, 0x0000, SENSOR_MSG);
}

static inline   
# 350 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/PhotoTempM.nc"
result_t PhotoTempM$ExternalPhotoADC$getData(void)
#line 350
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 351
    {
      PhotoTempM$photoSensor = PhotoTempM$stateReadOnce;
    }
#line 353
    __nesc_atomic_end(__nesc_atomic); }
#line 353
  ;
  TOS_post(PhotoTempM$getSample);
  return SUCCESS;
}

# 52 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
inline static   result_t SenseToSensor$LightADC$getData(void){
#line 52
  unsigned char result;
#line 52

#line 52
  result = PhotoTempM$ExternalPhotoADC$getData();
#line 52

#line 52
  return result;
#line 52
}
#line 52
static inline  
# 193 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/PhotoTempM.nc"
result_t PhotoTempM$TempStdControl$stop(void)
#line 193
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 194
    {
      PhotoTempM$tempSensor = PhotoTempM$stateIdle;

      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x02 + 0x20) = PhotoTempM$gDDRE;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x03 + 0x20) = PhotoTempM$gPORTE;
    }
#line 199
    __nesc_atomic_end(__nesc_atomic); }
#line 199
  ;
  return SUCCESS;
}

# 78 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SenseToSensor$TempControl$stop(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = PhotoTempM$TempStdControl$stop();
#line 78

#line 78
  return result;
#line 78
}
#line 78
static inline   
# 147 "SenseToSensor.nc"
result_t SenseToSensor$TempADC$dataReady(uint16_t data)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      SenseToSensor$lsb_data = (uint8_t )data;
      SenseToSensor$msb_data = (uint8_t )(data >> 8);
      SenseToSensor$curr_temp = data;
    }
#line 154
    __nesc_atomic_end(__nesc_atomic); }
  SenseToSensor$TempControl$stop();
  SenseToSensor$LightADC$getData();
  TOS_post(SenseToSensor$tempTask);

  return SUCCESS;
}

# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
inline static   result_t PhotoTempM$ExternalTempADC$dataReady(uint16_t arg_0xa35fe08){
#line 70
  unsigned char result;
#line 70

#line 70
  result = SenseToSensor$TempADC$dataReady(arg_0xa35fe08);
#line 70

#line 70
  return result;
#line 70
}
#line 70
static inline   
# 400 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/PhotoTempM.nc"
result_t PhotoTempM$InternalTempADC$dataReady(uint16_t data)
#line 400
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 401
    {
      PhotoTempM$waitingForSample = FALSE;
      switch (PhotoTempM$tempSensor) {
          default: 
            case PhotoTempM$stateIdle: 

              case PhotoTempM$stateReadOnce: 
                PhotoTempM$tempSensor = PhotoTempM$stateIdle;
          break;
          case PhotoTempM$stateContinuous: 
            break;
        }
#line 412
      ;
    }
#line 413
    __nesc_atomic_end(__nesc_atomic); }
#line 413
  ;
  TOS_post(PhotoTempM$getSample);
  return PhotoTempM$ExternalTempADC$dataReady(data);
}

static inline  
# 519 "BasicRoutingM.nc"
result_t BasicRoutingM$LightIn$output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type)
{
  BasicRoutingM$CurrentLightVal = measurements[0];

  return SUCCESS;
}

# 61 "SensorOutput.nc"
inline static  result_t SenseToSensor$LightOutput$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, uint16_t arg_0xa323568, uint16_t arg_0xa3236c0){
#line 61
  unsigned char result;
#line 61

#line 61
  result = BasicRoutingM$LightIn$output(arg_0xa323008, arg_0xa323158, arg_0xa3232b0, arg_0xa323408, arg_0xa323568, arg_0xa3236c0);
#line 61

#line 61
  return result;
#line 61
}
#line 61
static inline  
# 118 "SenseToSensor.nc"
void SenseToSensor$lightTask(void)
{
  uint16_t lCopy[5] = { 0, 0, 0, 0, 0 };

#line 121
  lCopy[0] = SenseToSensor$curr_light;



  SenseToSensor$LightOutput$output(lCopy, 0x0000, 0x0000, 0x0000, 0x0000, SENSOR_MSG);
}

static inline  
# 162 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/PhotoTempM.nc"
result_t PhotoTempM$PhotoStdControl$stop(void)
#line 162
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 163
    {
      PhotoTempM$photoSensor = PhotoTempM$stateIdle;

      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x02 + 0x20) = PhotoTempM$gDDRE;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x03 + 0x20) = PhotoTempM$gPORTE;
    }
#line 168
    __nesc_atomic_end(__nesc_atomic); }
#line 168
  ;
  return SUCCESS;
}

# 78 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SenseToSensor$LightControl$stop(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = PhotoTempM$PhotoStdControl$stop();
#line 78

#line 78
  return result;
#line 78
}
#line 78
static inline   
# 162 "SenseToSensor.nc"
result_t SenseToSensor$LightADC$dataReady(uint16_t data)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      SenseToSensor$lsb_data = (uint8_t )data;
      SenseToSensor$msb_data = (uint8_t )(data >> 8);
      SenseToSensor$curr_light = data;
    }
#line 169
    __nesc_atomic_end(__nesc_atomic); }
  SenseToSensor$LightControl$stop();
  TOS_post(SenseToSensor$lightTask);

  return SUCCESS;
}

# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
inline static   result_t PhotoTempM$ExternalPhotoADC$dataReady(uint16_t arg_0xa35fe08){
#line 70
  unsigned char result;
#line 70

#line 70
  result = SenseToSensor$LightADC$dataReady(arg_0xa35fe08);
#line 70

#line 70
  return result;
#line 70
}
#line 70
static inline   
# 378 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/PhotoTempM.nc"
result_t PhotoTempM$InternalPhotoADC$dataReady(uint16_t data)
#line 378
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 379
    {
      PhotoTempM$waitingForSample = FALSE;
      switch (PhotoTempM$photoSensor) {
          default: 
            case PhotoTempM$stateIdle: 

              case PhotoTempM$stateReadOnce: 
                PhotoTempM$photoSensor = PhotoTempM$stateIdle;
          break;
          case PhotoTempM$stateContinuous: 
            break;
        }
#line 390
      ;
    }
#line 391
    __nesc_atomic_end(__nesc_atomic); }
#line 391
  ;
  TOS_post(PhotoTempM$getSample);
  return PhotoTempM$ExternalPhotoADC$dataReady(data);
}

static inline  
# 724 "BasicRoutingM.nc"
void BasicRoutingM$voltTask(void)
{
  uint16_t display_array[5] = { 0, 0, 0, 0, 0 };
  uint16_t dest_addr = 0x0000;
  uint16_t next_addr = BasicRoutingM$routing_table[TOS_LOCAL_ADDRESS][dest_addr];

  display_array[0] = BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][0];
  display_array[1] = BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][1];
  display_array[2] = BasicRoutingM$curr_volt;

  BasicRoutingM$delaySendMessage(display_array, TOS_LOCAL_ADDRESS, next_addr, dest_addr, 0, SENSOR_MSG);
}

static inline  
# 73 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/VoltageM.nc"
result_t VoltageM$StdControl$stop(void)
#line 73
{
  return SUCCESS;
}

# 78 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t BasicRoutingM$VoltageControl$stop(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = VoltageM$StdControl$stop();
#line 78

#line 78
  return result;
#line 78
}
#line 78
static inline   
# 409 "BasicRoutingM.nc"
result_t BasicRoutingM$VoltageADC$dataReady(uint16_t data)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      BasicRoutingM$curr_volt = data;
    }
#line 414
    __nesc_atomic_end(__nesc_atomic); }
  BasicRoutingM$VoltageControl$stop();
  TOS_post(BasicRoutingM$voltTask);

  return SUCCESS;
}

static inline    
# 118 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCREFM.nc"
result_t ADCREFM$ADC$default$dataReady(uint8_t port, uint16_t data)
#line 118
{
  return FAIL;
}

# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
inline static   result_t ADCREFM$ADC$dataReady(uint8_t arg_0xa4f0350, uint16_t arg_0xa35fe08){
#line 70
  unsigned char result;
#line 70

#line 70
  switch (arg_0xa4f0350) {
#line 70
    case TOS_ADC_PHOTO_PORT:
#line 70
      result = PhotoTempM$InternalPhotoADC$dataReady(arg_0xa35fe08);
#line 70
      break;
#line 70
    case TOS_ADC_TEMP_PORT:
#line 70
      result = PhotoTempM$InternalTempADC$dataReady(arg_0xa35fe08);
#line 70
      break;
#line 70
    case TOS_ADC_VOLTAGE_PORT:
#line 70
      result = BasicRoutingM$VoltageADC$dataReady(arg_0xa35fe08);
#line 70
      break;
#line 70
    default:
#line 70
      result = ADCREFM$ADC$default$dataReady(arg_0xa4f0350, arg_0xa35fe08);
#line 70
    }
#line 70

#line 70
  return result;
#line 70
}
#line 70
static inline    
# 122 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCREFM.nc"
result_t ADCREFM$CalADC$default$dataReady(uint8_t port, uint16_t data)
#line 122
{
  return FAIL;
}

# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
inline static   result_t ADCREFM$CalADC$dataReady(uint8_t arg_0xa4f09d8, uint16_t arg_0xa35fe08){
#line 70
  unsigned char result;
#line 70

#line 70
    result = ADCREFM$CalADC$default$dataReady(arg_0xa4f09d8, arg_0xa35fe08);
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 77 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLADC.nc"
inline static   result_t ADCREFM$HPLADC$samplePort(uint8_t arg_0xa4eb118){
#line 77
  unsigned char result;
#line 77

#line 77
  result = HPLADCM$ADC$samplePort(arg_0xa4eb118);
#line 77

#line 77
  return result;
#line 77
}
#line 77
static inline   
# 133 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCREFM.nc"
result_t ADCREFM$HPLADC$dataReady(uint16_t data)
#line 133
{
  uint16_t doneValue = data;
  uint8_t donePort;
  uint8_t nextPort = 0xff;
  bool fCalResult = FALSE;
  result_t Result = SUCCESS;

#line 139
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 139
    {
      if (ADCREFM$ReqPort == TOS_ADC_BANDGAP_PORT) {
          ADCREFM$RefVal = data;
        }
      donePort = ADCREFM$ReqPort;

      if (((1 << donePort) & ADCREFM$ContReqMask) == 0) {
          ADCREFM$ReqVector ^= 1 << donePort;
        }


      if ((1 << donePort) & ADCREFM$CalReqMask) {
          fCalResult = TRUE;
          if (((1 << donePort) & ADCREFM$ContReqMask) == 0) {
              ADCREFM$CalReqMask ^= 1 << donePort;
            }
        }

      if (ADCREFM$ReqVector) {


          do {
              ADCREFM$ReqPort++;
              ADCREFM$ReqPort = ADCREFM$ReqPort == TOSH_ADC_PORTMAPSIZE ? 0 : ADCREFM$ReqPort;
            }
          while (((
#line 163
          1 << ADCREFM$ReqPort) & ADCREFM$ReqVector) == 0);
          nextPort = ADCREFM$ReqPort;
        }

      if (donePort != TOS_ADC_BANDGAP_PORT && fCalResult) {
          uint32_t tmp = (uint32_t )data;

#line 169
          tmp = tmp << 10;
          tmp = tmp / ADCREFM$RefVal;
          doneValue = (uint16_t )tmp;
        }
    }
#line 173
    __nesc_atomic_end(__nesc_atomic); }

  if (nextPort != 0xff) {
      ADCREFM$HPLADC$samplePort(nextPort);
    }

  {
  }
#line 179
  ;
  if (donePort != TOS_ADC_BANDGAP_PORT) {
      if (fCalResult) {
        Result = ADCREFM$CalADC$dataReady(donePort, doneValue);
        }
      else {
#line 184
        Result = ADCREFM$ADC$dataReady(donePort, doneValue);
        }
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 187
    {
      if (ADCREFM$ContReqMask & (1 << donePort) && Result == FAIL) {
          ADCREFM$ContReqMask ^= 1 << donePort;
        }
    }
#line 191
    __nesc_atomic_end(__nesc_atomic); }

  return SUCCESS;
}

# 99 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLADC.nc"
inline static   result_t HPLADCM$ADC$dataReady(uint16_t arg_0xa4ebc40){
#line 99
  unsigned char result;
#line 99

#line 99
  result = ADCREFM$HPLADC$dataReady(arg_0xa4ebc40);
#line 99

#line 99
  return result;
#line 99
}
#line 99
static inline   
# 242 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/AMStandard.nc"
TOS_MsgPtr AMStandard$ReceiveMsg$default$receive(uint8_t id, TOS_MsgPtr msg)
#line 242
{
  return msg;
}

# 75 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
inline static  TOS_MsgPtr AMStandard$ReceiveMsg$receive(uint8_t arg_0xa5326d0, TOS_MsgPtr arg_0xa54e5d8){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
    result = AMStandard$ReceiveMsg$default$receive(arg_0xa5326d0, arg_0xa54e5d8);
#line 75

#line 75
  return result;
#line 75
}
#line 75
static inline 
# 132 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/AMStandard.nc"
void AMStandard$dbgPacket(TOS_MsgPtr data)
#line 132
{
  uint8_t i;

  for (i = 0; i < sizeof(TOS_Msg ); i++) 
    {
      {
      }
#line 137
      ;
    }
  {
  }
#line 139
  ;
}

#line 215
TOS_MsgPtr   received(TOS_MsgPtr packet)
#line 215
{
  uint16_t addr = TOS_LOCAL_ADDRESS;

#line 217
  AMStandard$counter++;
  {
  }
#line 218
  ;


  if (
#line 220
  packet->crc == 1 && 
  packet->group == TOS_AM_GROUP && (
  packet->addr == TOS_BCAST_ADDR || 
  packet->addr == addr)) 
    {

      uint8_t type = packet->type;
      TOS_MsgPtr tmp;

      {
      }
#line 229
      ;
      AMStandard$dbgPacket(packet);
      {
      }
#line 231
      ;


      tmp = AMStandard$ReceiveMsg$receive(type, packet);
      if (tmp) {
        packet = tmp;
        }
    }
#line 238
  return packet;
}

# 66 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
inline static   result_t UARTM$ByteComm$rxByteReady(uint8_t arg_0xa57cb10, bool arg_0xa57cc58, uint16_t arg_0xa57cdb0){
#line 66
  unsigned char result;
#line 66

#line 66
  result = FramerM$ByteComm$rxByteReady(arg_0xa57cb10, arg_0xa57cc58, arg_0xa57cdb0);
#line 66

#line 66
  return result;
#line 66
}
#line 66
static inline   
# 77 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/UARTM.nc"
result_t UARTM$HPLUART$get(uint8_t data)
#line 77
{




  UARTM$ByteComm$rxByteReady(data, FALSE, 0);
  {
  }
#line 83
  ;
  return SUCCESS;
}

# 88 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLUART.nc"
inline static   result_t HPLUART0M$UART$get(uint8_t arg_0xa5e1940){
#line 88
  unsigned char result;
#line 88

#line 88
  result = UARTM$HPLUART$get(arg_0xa5e1940);
#line 88

#line 88
  return result;
#line 88
}
#line 88
# 90 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/HPLUART0M.nc"
void __attribute((signal))   __vector_18(void)
#line 90
{
  if (* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0B + 0x20) & (1 << 7)) {
    HPLUART0M$UART$get(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0C + 0x20));
    }
}

static inline  
# 244 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/FramerM.nc"
void FramerM$PacketUnknown(void)
#line 244
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 245
    {
      FramerM$gFlags |= FramerM$FLAGS_UNKNOWN;
    }
#line 247
    __nesc_atomic_end(__nesc_atomic); }

  FramerM$StartTx();
}

# 75 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
inline static  TOS_MsgPtr FramerAckM$ReceiveCombined$receive(TOS_MsgPtr arg_0xa54e5d8){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  result = TransceiverM$ReceiveUart$receive(arg_0xa54e5d8);
#line 75
  result = AMStandard$UARTReceive$receive(arg_0xa54e5d8);
#line 75

#line 75
  return result;
#line 75
}
#line 75
static inline  
# 91 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/FramerAckM.nc"
TOS_MsgPtr FramerAckM$ReceiveMsg$receive(TOS_MsgPtr Msg)
#line 91
{
  TOS_MsgPtr pBuf;

  pBuf = FramerAckM$ReceiveCombined$receive(Msg);

  return pBuf;
}

# 75 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
inline static  TOS_MsgPtr FramerM$ReceiveMsg$receive(TOS_MsgPtr arg_0xa54e5d8){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  result = FramerAckM$ReceiveMsg$receive(arg_0xa54e5d8);
#line 75

#line 75
  return result;
#line 75
}
#line 75
static inline  
# 373 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/FramerM.nc"
result_t FramerM$TokenReceiveMsg$ReflectToken(uint8_t Token)
#line 373
{
  result_t Result = SUCCESS;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 376
    {
      if (!(FramerM$gFlags & FramerM$FLAGS_TOKENPEND)) {
          FramerM$gFlags |= FramerM$FLAGS_TOKENPEND;
          FramerM$gTxTokenBuf = Token;
        }
      else {
          Result = FAIL;
        }
    }
#line 384
    __nesc_atomic_end(__nesc_atomic); }

  if (Result == SUCCESS) {
      Result = FramerM$StartTx();
    }

  return Result;
}

# 88 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/TokenReceiveMsg.nc"
inline static  result_t FramerAckM$TokenReceiveMsg$ReflectToken(uint8_t arg_0xa57ea30){
#line 88
  unsigned char result;
#line 88

#line 88
  result = FramerM$TokenReceiveMsg$ReflectToken(arg_0xa57ea30);
#line 88

#line 88
  return result;
#line 88
}
#line 88
static inline  
# 74 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/FramerAckM.nc"
void FramerAckM$SendAckTask(void)
#line 74
{

  FramerAckM$TokenReceiveMsg$ReflectToken(FramerAckM$gTokenBuf);
}

static inline  TOS_MsgPtr FramerAckM$TokenReceiveMsg$receive(TOS_MsgPtr Msg, uint8_t token)
#line 79
{
  TOS_MsgPtr pBuf;

  FramerAckM$gTokenBuf = token;

  TOS_post(FramerAckM$SendAckTask);

  pBuf = FramerAckM$ReceiveCombined$receive(Msg);

  return pBuf;
}

# 75 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/TokenReceiveMsg.nc"
inline static  TOS_MsgPtr FramerM$TokenReceiveMsg$receive(TOS_MsgPtr arg_0xa57e2d0, uint8_t arg_0xa57e418){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  result = FramerAckM$TokenReceiveMsg$receive(arg_0xa57e2d0, arg_0xa57e418);
#line 75

#line 75
  return result;
#line 75
}
#line 75
static inline  
# 252 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/FramerM.nc"
void FramerM$PacketRcvd(void)
#line 252
{
  FramerM$MsgRcvEntry_t *pRcv = &FramerM$gMsgRcvTbl[FramerM$gRxTailIndex];
  TOS_MsgPtr pBuf = pRcv->pMsg;



  if (pRcv->Length >= 5) {



      switch (pRcv->Proto) {
          case FramerM$PROTO_ACK: 
            break;
          case FramerM$PROTO_PACKET_ACK: 
            pBuf->crc = 1;
          pBuf = FramerM$TokenReceiveMsg$receive(pBuf, pRcv->Token);
          break;
          case FramerM$PROTO_PACKET_NOACK: 
            pBuf->crc = 1;
          pBuf = FramerM$ReceiveMsg$receive(pBuf);
          break;
          default: 
            FramerM$gTxUnknownBuf = pRcv->Proto;
          TOS_post(FramerM$PacketUnknown);
          break;
        }
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 280
    {
      if (pBuf) {
          pRcv->pMsg = pBuf;
        }
      pRcv->Length = 0;
      pRcv->Token = 0;
      FramerM$gRxTailIndex++;
      FramerM$gRxTailIndex %= FramerM$HDLC_QUEUESIZE;
    }
#line 288
    __nesc_atomic_end(__nesc_atomic); }
}

static inline  
# 654 "BasicRoutingM.nc"
TOS_MsgPtr BasicRoutingM$Transceiver$receiveUart(TOS_MsgPtr m)
{
  if (BasicRoutingM$newMessage()) {

      SimpleCmdMsg *cmdMsgFrom = (SimpleCmdMsg *)m->data;

#line 659
      BasicRoutingM$cmdMsg->seqno = cmdMsgFrom->seqno;
      BasicRoutingM$cmdMsg->action = cmdMsgFrom->action;
      BasicRoutingM$cmdMsg->source = cmdMsgFrom->source;
      BasicRoutingM$cmdMsg->hop_count = cmdMsgFrom->hop_count;
      BasicRoutingM$cmdMsg->args = cmdMsgFrom->args;

      BasicRoutingM$Transceiver$sendRadio(TOS_BCAST_ADDR, sizeof(SimpleCmdMsg ));
    }

  return m;
}

static inline  
# 117 "RfmToSensorM.nc"
TOS_MsgPtr RfmToSensorM$ReceiveSensorMsg$receiveUart(TOS_MsgPtr m)
{
  return m;
}

static inline  
# 138 "SensorToRfmM.nc"
TOS_MsgPtr SensorToRfmM$Send$receiveUart(TOS_MsgPtr m)
{
  return m;
}

static inline  
# 235 "SensorToUARTM.nc"
TOS_MsgPtr SensorToUARTM$DataMsg$receiveUart(TOS_MsgPtr m)
{
  return m;
}

static inline  
#line 213
TOS_MsgPtr SensorToUARTM$ResetCounterMsg$receiveUart(TOS_MsgPtr m)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      SensorToUARTM$readingNumber = 0;
    }
#line 218
    __nesc_atomic_end(__nesc_atomic); }
  return m;
}

static inline   
# 508 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
TOS_MsgPtr TransceiverM$Transceiver$default$receiveUart(uint8_t type, TOS_MsgPtr m)
#line 508
{
  return m;
}

# 140 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
inline static  TOS_MsgPtr TransceiverM$Transceiver$receiveUart(uint8_t arg_0xa5ff370, TOS_MsgPtr arg_0xa33ed28){
#line 140
  struct TOS_Msg *result;
#line 140

#line 140
  switch (arg_0xa5ff370) {
#line 140
    case AM_SENSORMSG:
#line 140
      result = SensorToRfmM$Send$receiveUart(arg_0xa33ed28);
#line 140
      result = RfmToSensorM$ReceiveSensorMsg$receiveUart(arg_0xa33ed28);
#line 140
      break;
#line 140
    case AM_SIMPLECMDMSG:
#line 140
      result = BasicRoutingM$Transceiver$receiveUart(arg_0xa33ed28);
#line 140
      break;
#line 140
    case AM_CPUMSG:
#line 140
      result = SensorToUARTM$DataMsg$receiveUart(arg_0xa33ed28);
#line 140
      break;
#line 140
    case AM_CPURESETMSG:
#line 140
      result = SensorToUARTM$ResetCounterMsg$receiveUart(arg_0xa33ed28);
#line 140
      break;
#line 140
    default:
#line 140
      result = TransceiverM$Transceiver$default$receiveUart(arg_0xa5ff370, arg_0xa33ed28);
#line 140
    }
#line 140

#line 140
  return result;
#line 140
}
#line 140
# 96 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/HPLUART.nc"
inline static   result_t HPLUART0M$UART$putDone(void){
#line 96
  unsigned char result;
#line 96

#line 96
  result = UARTM$HPLUART$putDone();
#line 96

#line 96
  return result;
#line 96
}
#line 96
# 100 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/HPLUART0M.nc"
void __attribute((interrupt))   __vector_20(void)
#line 100
{
  HPLUART0M$UART$putDone();
}

static inline   
# 611 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/FramerM.nc"
result_t FramerM$ByteComm$txDone(void)
#line 611
{

  if (FramerM$gTxState == FramerM$TXSTATE_FINISH) {
      FramerM$gTxState = FramerM$TXSTATE_IDLE;
      TOS_post(FramerM$PacketSent);
    }

  return SUCCESS;
}

# 83 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
inline static   result_t UARTM$ByteComm$txDone(void){
#line 83
  unsigned char result;
#line 83

#line 83
  result = FramerM$ByteComm$txDone();
#line 83

#line 83
  return result;
#line 83
}
#line 83
#line 55
inline static   result_t FramerM$ByteComm$txByte(uint8_t arg_0xa57c680){
#line 55
  unsigned char result;
#line 55

#line 55
  result = UARTM$ByteComm$txByte(arg_0xa57c680);
#line 55

#line 55
  return result;
#line 55
}
#line 55
static inline 
# 66 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/avrmote/crc.h"
uint16_t crcByte(uint16_t oldCrc, uint8_t byte)
{

  uint16_t *table = crcTable;
  uint16_t newCrc;

   __asm ("eor %1,%B3\n"
  "\tlsl %1\n"
  "\tadc %B2, __zero_reg__\n"
  "\tadd %A2, %1\n"
  "\tadc %B2, __zero_reg__\n"
  "\tlpm\n"
  "\tmov %B0, %A3\n"
  "\tmov %A0, r0\n"
  "\tadiw r30,1\n"
  "\tlpm\n"
  "\teor %B0, r0" : 
  "=r"(newCrc), "+r"(byte), "+z"(table) : "r"(oldCrc));
  return newCrc;
}

static inline   
# 533 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/FramerM.nc"
result_t FramerM$ByteComm$txByteReady(bool LastByteSuccess)
#line 533
{
  result_t TxResult = SUCCESS;
  uint8_t nextByte;

  if (LastByteSuccess != TRUE) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 538
        FramerM$gTxState = FramerM$TXSTATE_ERROR;
#line 538
        __nesc_atomic_end(__nesc_atomic); }
      TOS_post(FramerM$PacketSent);
      return SUCCESS;
    }

  switch (FramerM$gTxState) {

      case FramerM$TXSTATE_PROTO: 
        FramerM$gTxState = FramerM$TXSTATE_INFO;
      FramerM$gTxRunningCRC = crcByte(FramerM$gTxRunningCRC, FramerM$gTxProto);
      TxResult = FramerM$ByteComm$txByte(FramerM$gTxProto);
      break;

      case FramerM$TXSTATE_INFO: 
        if (FramerM$gTxProto == FramerM$PROTO_ACK) {
          nextByte = FramerM$gpTxBuf[0];
          }
        else {
#line 555
          nextByte = FramerM$gpTxBuf[FramerM$gTxByteCnt];
          }
#line 556
      FramerM$gTxRunningCRC = crcByte(FramerM$gTxRunningCRC, nextByte);
      FramerM$gTxByteCnt++;

      if (FramerM$gTxByteCnt == 10) {
        FramerM$gTxByteCnt = 0;
        }
#line 561
      if (FramerM$gTxByteCnt == 1) {
        FramerM$gTxByteCnt = 10;
        }
      if (FramerM$gTxByteCnt >= FramerM$gTxLength) {
          FramerM$gTxState = FramerM$TXSTATE_FCS1;
        }

      TxResult = FramerM$TxArbitraryByte(nextByte);
      break;

      case FramerM$TXSTATE_ESC: 

        TxResult = FramerM$ByteComm$txByte(FramerM$gTxEscByte ^ 0x20);
      FramerM$gTxState = FramerM$gPrevTxState;
      break;

      case FramerM$TXSTATE_FCS1: 
        nextByte = (uint8_t )(FramerM$gTxRunningCRC & 0xff);
      FramerM$gTxState = FramerM$TXSTATE_FCS2;
      TxResult = FramerM$TxArbitraryByte(nextByte);
      break;

      case FramerM$TXSTATE_FCS2: 
        nextByte = (uint8_t )((FramerM$gTxRunningCRC >> 8) & 0xff);
      FramerM$gTxState = FramerM$TXSTATE_ENDFLAG;
      TxResult = FramerM$TxArbitraryByte(nextByte);
      break;

      case FramerM$TXSTATE_ENDFLAG: 
        FramerM$gTxState = FramerM$TXSTATE_FINISH;
      TxResult = FramerM$ByteComm$txByte(FramerM$HDLC_FLAG_BYTE);

      break;

      case FramerM$TXSTATE_FINISH: 
        case FramerM$TXSTATE_ERROR: 

          default: 
            break;
    }


  if (TxResult != SUCCESS) {
      FramerM$gTxState = FramerM$TXSTATE_ERROR;
      TOS_post(FramerM$PacketSent);
    }

  return SUCCESS;
}

# 75 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
inline static   result_t UARTM$ByteComm$txByteReady(bool arg_0xa57d2e0){
#line 75
  unsigned char result;
#line 75

#line 75
  result = FramerM$ByteComm$txByteReady(arg_0xa57d2e0);
#line 75

#line 75
  return result;
#line 75
}
#line 75
static inline   
# 89 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420InterruptM.nc"
result_t HPLCC2420InterruptM$FIFOP$disable(void)
#line 89
{
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x39 + 0x20) &= ~(1 << 6);
  return SUCCESS;
}

# 59 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t CC2420RadioM$FIFOP$disable(void){
#line 59
  unsigned char result;
#line 59

#line 59
  result = HPLCC2420InterruptM$FIFOP$disable();
#line 59

#line 59
  return result;
#line 59
}
#line 59
static inline  
# 503 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
void CC2420RadioM$delayedRXFIFOtask(void)
#line 503
{
  CC2420RadioM$delayedRXFIFO();
}

static inline    
#line 718
int16_t CC2420RadioM$MacBackoff$default$congestionBackoff(TOS_MsgPtr m)
#line 718
{
  return (CC2420RadioM$Random$rand() & 0x3F) + 1;
}

# 75 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/MacBackoff.nc"
inline static   int16_t CC2420RadioM$MacBackoff$congestionBackoff(TOS_MsgPtr arg_0xa685cb0){
#line 75
  int result;
#line 75

#line 75
  result = CC2420RadioM$MacBackoff$default$congestionBackoff(arg_0xa685cb0);
#line 75

#line 75
  return result;
#line 75
}
#line 75
static inline   
# 165 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer2.nc"
void HPLTimer2$Timer2$intDisable(void)
#line 165
{
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x37 + 0x20) &= ~(1 << 7);
}

# 168 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Clock.nc"
inline static   void TimerJiffyAsyncM$Timer$intDisable(void){
#line 168
  HPLTimer2$Timer2$intDisable();
#line 168
}
#line 168
static inline   
# 81 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/TimerJiffyAsyncM.nc"
result_t TimerJiffyAsyncM$TimerJiffyAsync$stop(void)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 83
    {
      TimerJiffyAsyncM$bSet = FALSE;
      TimerJiffyAsyncM$Timer$intDisable();
    }
#line 86
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 8 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
inline static   result_t CC2420RadioM$BackoffTimerJiffy$stop(void){
#line 8
  unsigned char result;
#line 8

#line 8
  result = TimerJiffyAsyncM$TimerJiffyAsync$stop();
#line 8

#line 8
  return result;
#line 8
}
#line 8
static inline   
# 76 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/TimerJiffyAsyncM.nc"
bool TimerJiffyAsyncM$TimerJiffyAsync$isSet(void)
{
  return TimerJiffyAsyncM$bSet;
}

# 10 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
inline static   bool CC2420RadioM$BackoffTimerJiffy$isSet(void){
#line 10
  unsigned char result;
#line 10

#line 10
  result = TimerJiffyAsyncM$TimerJiffyAsync$isSet();
#line 10

#line 10
  return result;
#line 10
}
#line 10
static inline   
# 558 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
result_t CC2420RadioM$FIFOP$fired(void)
#line 558
{






  if (CC2420RadioM$bAckEnable && CC2420RadioM$stateRadio == CC2420RadioM$PRE_TX_STATE) {
      if (CC2420RadioM$BackoffTimerJiffy$isSet()) {
          CC2420RadioM$BackoffTimerJiffy$stop();
          CC2420RadioM$BackoffTimerJiffy$setOneShot(CC2420RadioM$MacBackoff$congestionBackoff(CC2420RadioM$txbufptr) * 10 + 75);
        }
    }


  if (!TOSH_READ_CC_FIFO_PIN()) {
      CC2420RadioM$flushRXFIFO();
      return SUCCESS;
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 578
    {
      if (TOS_post(CC2420RadioM$delayedRXFIFOtask)) {
          CC2420RadioM$FIFOP$disable();
        }
      else {
          CC2420RadioM$flushRXFIFO();
        }
    }
#line 585
    __nesc_atomic_end(__nesc_atomic); }


  return SUCCESS;
}

# 51 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t HPLCC2420InterruptM$FIFOP$fired(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = CC2420RadioM$FIFOP$fired();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 61 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
inline static   uint16_t CC2420RadioM$HPLChipcon$read(uint8_t arg_0xa672bf0){
#line 61
  unsigned int result;
#line 61

#line 61
  result = HPLCC2420M$HPLCC2420$read(arg_0xa672bf0);
#line 61

#line 61
  return result;
#line 61
}
#line 61
# 144 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline int TOSH_READ_CC_FIFOP_PIN(void)
#line 144
{
#line 144
  return (* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x01 + 0x20) & (1 << 6)) != 0;
}

static inline   
# 398 "BasicRoutingM.nc"
result_t BasicRoutingM$ProcessCmd$default$done(TOS_MsgPtr pmsg, result_t status)
{
  return status;
}

# 53 "ProcessCmd.nc"
inline static  result_t BasicRoutingM$ProcessCmd$done(TOS_MsgPtr arg_0xa35c370, result_t arg_0xa35c4c0){
#line 53
  unsigned char result;
#line 53

#line 53
  result = BasicRoutingM$ProcessCmd$default$done(arg_0xa35c370, arg_0xa35c4c0);
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 52 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ADC.nc"
inline static   result_t BasicRoutingM$VoltageADC$getData(void){
#line 52
  unsigned char result;
#line 52

#line 52
  result = ADCREFM$ADC$getData(TOS_ADC_VOLTAGE_PORT);
#line 52

#line 52
  return result;
#line 52
}
#line 52
# 116 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCControl.nc"
inline static  result_t VoltageM$ADCControl$bindPort(uint8_t arg_0xa4cbf58, uint8_t arg_0xa4c20b0){
#line 116
  unsigned char result;
#line 116

#line 116
  result = ADCREFM$ADCControl$bindPort(arg_0xa4cbf58, arg_0xa4c20b0);
#line 116

#line 116
  return result;
#line 116
}
#line 116
#line 77
inline static  result_t VoltageM$ADCControl$init(void){
#line 77
  unsigned char result;
#line 77

#line 77
  result = ADCREFM$ADCControl$init();
#line 77

#line 77
  return result;
#line 77
}
#line 77
static inline  
# 64 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/VoltageM.nc"
result_t VoltageM$StdControl$start(void)
#line 64
{
  result_t result;

#line 66
  result = VoltageM$ADCControl$init();
  result = rcombine(VoltageM$ADCControl$bindPort(TOS_ADC_VOLTAGE_PORT, 
  TOSH_ACTUAL_VOLTAGE_PORT), 
  result);
  return result;
}

# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t BasicRoutingM$VoltageControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = VoltageM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 61 "SensorOutput.nc"
inline static  result_t BasicRoutingM$LedOut$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, uint16_t arg_0xa323568, uint16_t arg_0xa3236c0){
#line 61
  unsigned char result;
#line 61

#line 61
  result = SensorToLedsM$SensorOutput$output(arg_0xa323008, arg_0xa323158, arg_0xa3232b0, arg_0xa323408, arg_0xa323568, arg_0xa3236c0);
#line 61

#line 61
  return result;
#line 61
}
#line 61
static inline  
# 310 "BasicRoutingM.nc"
result_t BasicRoutingM$ProcessCmd$execute(TOS_MsgPtr pmsg)
{
  uint16_t led_display[5] = { 0, 0, 0, 0, 0 };
  uint16_t next_addr = 0;
  uint16_t dest_addr = 0;

  struct SimpleCmdMsg *cmd = (struct SimpleCmdMsg *)pmsg->data;


  cmd->hop_count++;
  cmd->source = TOS_LOCAL_ADDRESS;


  switch (cmd->action) 
    {
      case YELLOW_LED_ON: 
        led_display[0] = 4;
      BasicRoutingM$LedOut$output(led_display, TOS_LOCAL_ADDRESS, 0, 0, 0, WAVELET_MSG);


      break;

      case YELLOW_LED_OFF: 
        led_display[0] = 0;
      BasicRoutingM$LedOut$output(led_display, TOS_LOCAL_ADDRESS, 0, 0, 0, WAVELET_MSG);
      break;

      case GREEN_LED_ON: 





        BasicRoutingM$VoltageControl$start();
      BasicRoutingM$VoltageADC$getData();
#line 366
      break;

      case GREEN_LED_OFF: 
        BasicRoutingM$wavelet_level = 1;








      BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][0] = BasicRoutingM$CurrentLightVal;
      BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][1] = BasicRoutingM$CurrentTempVal;
      BasicRoutingM$SnapshotLightVal = BasicRoutingM$CurrentLightVal;
      BasicRoutingM$SnapshotTempVal = BasicRoutingM$CurrentTempVal;
      BasicRoutingM$startWaveletLevel();
      break;

      case WAVELET: 
        break;
    }

  BasicRoutingM$ProcessCmd$done(pmsg, SUCCESS);
  return SUCCESS;
}

static inline  
#line 602
TOS_MsgPtr BasicRoutingM$Transceiver$receiveRadio(TOS_MsgPtr m)
{
  uint16_t led_display_cmd[5] = { 0, 0, 0, 0, 0 };


  SimpleCmdMsg *cmdMsgFrom = (SimpleCmdMsg *)m->data;
  uint16_t alreadySent = 0;
  uint16_t LCV = 0;
  uint16_t msgID = cmdMsgFrom->seqno;

  if (!(TOS_LOCAL_ADDRESS == 0)) 
    {
      for (LCV; LCV < BasicRoutingM$MsgsAlreadySentLength; LCV++) 
        {
          if (BasicRoutingM$MsgsAlreadySent[LCV] == msgID) {
            alreadySent = 1;
            }
        }
      if (alreadySent == 0) 
        {

          LCV = BasicRoutingM$MsgsAlreadySentLength - 1;
          for (LCV; LCV > 0; LCV--) 

            BasicRoutingM$MsgsAlreadySent[LCV] = BasicRoutingM$MsgsAlreadySent[LCV - 1];
          BasicRoutingM$MsgsAlreadySent[0] = msgID;


          if (BasicRoutingM$newMessage()) {

              SimpleCmdMsg *cmdMsgFrom = (SimpleCmdMsg *)m->data;

#line 633
              BasicRoutingM$cmdMsg->seqno = cmdMsgFrom->seqno;
              BasicRoutingM$cmdMsg->action = cmdMsgFrom->action;
              BasicRoutingM$cmdMsg->source = cmdMsgFrom->source;
              BasicRoutingM$cmdMsg->hop_count = cmdMsgFrom->hop_count;
              BasicRoutingM$cmdMsg->args = cmdMsgFrom->args;

              BasicRoutingM$Transceiver$sendRadio(TOS_BCAST_ADDR, sizeof(SimpleCmdMsg ));
            }

          BasicRoutingM$ProcessCmd$execute(m);
        }
    }
  return m;
}

static inline  
# 280 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
result_t TransceiverM$Transceiver$sendUart(uint8_t type, uint8_t payloadSize)
#line 280
{
  return TransceiverM$pack(type, TOS_UART_ADDR, payloadSize, UART);
}

# 93 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
inline static  result_t SensorToUARTM$DataMsg$sendUart(uint8_t arg_0xa33aed0){
#line 93
  unsigned char result;
#line 93

#line 93
  result = TransceiverM$Transceiver$sendUart(AM_CPUMSG, arg_0xa33aed0);
#line 93

#line 93
  return result;
#line 93
}
#line 93
# 61 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
inline static  TOS_MsgPtr SensorToUARTM$DataMsg$requestWrite(void){
#line 61
  struct TOS_Msg *result;
#line 61

#line 61
  result = TransceiverM$Transceiver$requestWrite(AM_CPUMSG);
#line 61

#line 61
  return result;
#line 61
}
#line 61
static inline 
# 256 "SensorToUARTM.nc"
result_t SensorToUARTM$newMessage(void)
{
  if ((SensorToUARTM$msg[SensorToUARTM$currentMsg] = SensorToUARTM$DataMsg$requestWrite()) != (void *)0) 
    {

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
        {
          SensorToUARTM$message = (struct CPUMsg *)SensorToUARTM$msg[SensorToUARTM$currentMsg]->data;
          SensorToUARTM$packetReadingNumber = 0;
        }
#line 265
        __nesc_atomic_end(__nesc_atomic); }

      return SUCCESS;
    }
  return FAIL;
}

static inline  
#line 123
void SensorToUARTM$dataTask(void)
{

  if (SensorToUARTM$newMessage()) 
    {

      SensorToUARTM$message->hops = SensorToUARTM$hop;
      SensorToUARTM$message->sourceMoteID = SensorToUARTM$src;
      SensorToUARTM$message->data[0] = SensorToUARTM$wav_val_light;
      SensorToUARTM$message->data[1] = SensorToUARTM$wav_val_temp;
      SensorToUARTM$message->data[2] = SensorToUARTM$voltage;
#line 145
      if (SensorToUARTM$DataMsg$sendUart(sizeof(struct CPUMsg ))) 
        {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
            {
              SensorToUARTM$currentMsg ^= 0x1;
            }
#line 150
            __nesc_atomic_end(__nesc_atomic); }
        }

      return SUCCESS;
    }
}

static inline  









result_t SensorToUARTM$SensorOutput$output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type)
{
  struct CPUMsg *pack;

#line 171
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {






      SensorToUARTM$src = source;
      SensorToUARTM$hop = hops;
      SensorToUARTM$wav_val_light = measurements[0];
      SensorToUARTM$wav_val_temp = measurements[1];
      SensorToUARTM$voltage = measurements[2];




      TOS_post(SensorToUARTM$dataTask);
    }
#line 189
    __nesc_atomic_end(__nesc_atomic); }


  return SUCCESS;
}

# 61 "SensorOutput.nc"
inline static  result_t BasicRoutingM$UARTOut$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, uint16_t arg_0xa323568, uint16_t arg_0xa3236c0){
#line 61
  unsigned char result;
#line 61

#line 61
  result = SensorToUARTM$SensorOutput$output(arg_0xa323008, arg_0xa323158, arg_0xa3232b0, arg_0xa323408, arg_0xa323568, arg_0xa3236c0);
#line 61

#line 61
  return result;
#line 61
}
#line 61
static inline  
# 420 "BasicRoutingM.nc"
result_t BasicRoutingM$RadioIn$output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type)
{
  uint16_t display_array[5] = { 0, 0, 0, 0, 0 };
  uint8_t LCV = 0;
  uint16_t numNeighbors = 0;

  if (source == 0x0007) 
    {
      display_array[0] = hops;
      BasicRoutingM$LedOut$output(display_array, source, next_addr, dest_addr, hops, msg_type);
    }

  if (dest_addr == TOS_LOCAL_ADDRESS) 
    {
      if (msg_type == SENSOR_MSG) 
        {
          BasicRoutingM$UARTOut$output(measurements, source, next_addr, dest_addr, hops, msg_type);
          BasicRoutingM$LedOut$output(measurements, source, next_addr, dest_addr, hops, msg_type);
        }
      else 
        {
          if (hops == BasicRoutingM$wavelet_level) 
            {
              if (BasicRoutingM$wav_dec[TOS_LOCAL_ADDRESS] == BasicRoutingM$wavelet_level) 
                {
                  BasicRoutingM$addWaveletValueToTable(hops, source, measurements[0], measurements[1]);

                  if (BasicRoutingM$hasReceivedAllValues() == 1) 
                    {
                      numNeighbors = BasicRoutingM$local_table[BasicRoutingM$wavelet_level - 1][0][0];
                      BasicRoutingM$calculateCoefficient(numNeighbors, 0);
                      BasicRoutingM$clearTable(numNeighbors);

                      LCV = 0;
                      for (LCV; LCV < numNeighbors; LCV++) 
                        {
                          uint16_t neighbor = BasicRoutingM$local_table[BasicRoutingM$wavelet_level - 1][LCV + 1][0];

#line 458
                          display_array[0] = BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][0];
                          display_array[1] = BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][1];
                          BasicRoutingM$delaySendMessage(display_array, TOS_LOCAL_ADDRESS, BasicRoutingM$routing_table[TOS_LOCAL_ADDRESS][neighbor], neighbor, BasicRoutingM$wavelet_level, WAVELET_MSG);
                        }
                    }
                  else 
                    {
                    }
                }
              else 
#line 478
                {
                  BasicRoutingM$addWaveletValueToTable(hops, source, measurements[0], measurements[1]);

                  if (BasicRoutingM$hasReceivedAllValues() == 1) 
                    {
                      numNeighbors = BasicRoutingM$local_table[BasicRoutingM$wavelet_level - 1][0][0];
                      BasicRoutingM$calculateCoefficient(numNeighbors, 1);
                      BasicRoutingM$clearTable(numNeighbors);


                      if (BasicRoutingM$wavelet_level < BasicRoutingM$max_wavelet_level) 
                        {
                          BasicRoutingM$wavelet_level = BasicRoutingM$wavelet_level + 1;
                          BasicRoutingM$startWaveletLevel();
                        }
                    }
                  else 
                    {
                    }

                  display_array[0] = BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][0];
                  display_array[1] = BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][1];
                }
            }
          else 

            {
              BasicRoutingM$addWaveletValueToTable(hops, source, measurements[0], measurements[1]);
              display_array[0] = 7;
              BasicRoutingM$LedOut$output(display_array, TOS_LOCAL_ADDRESS, 0, 0, 0, msg_type);
            }
        }
    }
  else 
    {
      next_addr = BasicRoutingM$routing_table[TOS_LOCAL_ADDRESS][dest_addr];
      BasicRoutingM$delaySendMessage(measurements, source, next_addr, dest_addr, hops, msg_type);
    }
}

# 61 "SensorOutput.nc"
inline static  result_t RfmToSensorM$SensorOutput$output(uint16_t arg_0xa323008[], uint16_t arg_0xa323158, uint16_t arg_0xa3232b0, uint16_t arg_0xa323408, uint16_t arg_0xa323568, uint16_t arg_0xa3236c0){
#line 61
  unsigned char result;
#line 61

#line 61
  result = BasicRoutingM$RadioIn$output(arg_0xa323008, arg_0xa323158, arg_0xa3232b0, arg_0xa323408, arg_0xa323568, arg_0xa3236c0);
#line 61

#line 61
  return result;
#line 61
}
#line 61
static inline  
# 85 "RfmToSensorM.nc"
TOS_MsgPtr RfmToSensorM$ReceiveSensorMsg$receiveRadio(TOS_MsgPtr m)
#line 85
{
  TOS_MsgPtr returnPtr;
  SensorMsg *message = (SensorMsg *)m->data;






  if (m == &RfmToSensorM$localTosMsg) 
    {

      returnPtr = RfmToSensorM$receiveMsgPtr;
    }
  else 
    {

      returnPtr = &RfmToSensorM$localTosMsg;
    }

  RfmToSensorM$receiveMsgPtr = m;

  RfmToSensorM$SensorOutput$output(message->val, message->src, message->next_addr, message->dest_addr, message->hops, message->msg_type);

  return returnPtr;
}

static inline  
# 148 "SensorToRfmM.nc"
TOS_MsgPtr SensorToRfmM$Send$receiveRadio(TOS_MsgPtr m)
{
  return m;
}

static inline  
# 230 "SensorToUARTM.nc"
TOS_MsgPtr SensorToUARTM$DataMsg$receiveRadio(TOS_MsgPtr m)
{
  return m;
}

static inline  
#line 251
TOS_MsgPtr SensorToUARTM$ResetCounterMsg$receiveRadio(TOS_MsgPtr m)
{
  return m;
}

static inline   
# 504 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
TOS_MsgPtr TransceiverM$Transceiver$default$receiveRadio(uint8_t type, TOS_MsgPtr m)
#line 504
{
  return m;
}

# 133 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
inline static  TOS_MsgPtr TransceiverM$Transceiver$receiveRadio(uint8_t arg_0xa5ff370, TOS_MsgPtr arg_0xa33e878){
#line 133
  struct TOS_Msg *result;
#line 133

#line 133
  switch (arg_0xa5ff370) {
#line 133
    case AM_SENSORMSG:
#line 133
      result = SensorToRfmM$Send$receiveRadio(arg_0xa33e878);
#line 133
      result = RfmToSensorM$ReceiveSensorMsg$receiveRadio(arg_0xa33e878);
#line 133
      break;
#line 133
    case AM_SIMPLECMDMSG:
#line 133
      result = BasicRoutingM$Transceiver$receiveRadio(arg_0xa33e878);
#line 133
      break;
#line 133
    case AM_CPUMSG:
#line 133
      result = SensorToUARTM$DataMsg$receiveRadio(arg_0xa33e878);
#line 133
      break;
#line 133
    case AM_CPURESETMSG:
#line 133
      result = SensorToUARTM$ResetCounterMsg$receiveRadio(arg_0xa33e878);
#line 133
      break;
#line 133
    default:
#line 133
      result = TransceiverM$Transceiver$default$receiveRadio(arg_0xa5ff370, arg_0xa33e878);
#line 133
    }
#line 133

#line 133
  return result;
#line 133
}
#line 133
# 42 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/PacketFilter.nc"
inline static  bool TransceiverM$PacketFilter$filterPacket(TOS_MsgPtr arg_0xa5fb558, uint8_t arg_0xa5fb6a8){
#line 42
  unsigned char result;
#line 42

#line 42
  result = PacketFilterM$PacketFilter$filterPacket(arg_0xa5fb558, arg_0xa5fb6a8);
#line 42

#line 42
  return result;
#line 42
}
#line 42
static inline  
# 377 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
TOS_MsgPtr TransceiverM$ReceiveRadio$receive(TOS_MsgPtr m)
#line 377
{
  if (TransceiverM$PacketFilter$filterPacket(m, RADIO)) {
      return TransceiverM$Transceiver$receiveRadio(m->type, m);
    }
  return m;
}

# 75 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
inline static  TOS_MsgPtr CC2420RadioM$Receive$receive(TOS_MsgPtr arg_0xa54e5d8){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  result = TransceiverM$ReceiveRadio$receive(arg_0xa54e5d8);
#line 75

#line 75
  return result;
#line 75
}
#line 75
static inline  
# 152 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
void CC2420RadioM$PacketRcvd(void)
#line 152
{
  TOS_MsgPtr pBuf;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 155
    {
      pBuf = CC2420RadioM$rxbufptr;
    }
#line 157
    __nesc_atomic_end(__nesc_atomic); }
  pBuf = CC2420RadioM$Receive$receive((TOS_MsgPtr )pBuf);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 159
    {
      if (pBuf) {
#line 160
        CC2420RadioM$rxbufptr = pBuf;
        }
#line 161
      CC2420RadioM$rxbufptr->length = 0;
      CC2420RadioM$bPacketReceiving = FALSE;
    }
#line 163
    __nesc_atomic_end(__nesc_atomic); }
}

static 
# 23 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/byteorder.h"
__inline uint16_t fromLSB16(uint16_t a)
{
  return is_host_lsb() ? a : (a << 8) | (a >> 8);
}

static inline   
# 595 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
result_t CC2420RadioM$HPLChipconFIFO$RXFIFODone(uint8_t length, uint8_t *data)
#line 595
{





  uint8_t currentstate;

#line 602
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 602
    {
      currentstate = CC2420RadioM$stateRadio;
    }
#line 604
    __nesc_atomic_end(__nesc_atomic); }




  if (((
#line 608
  !TOSH_READ_CC_FIFO_PIN() && !TOSH_READ_CC_FIFOP_PIN())
   || length == 0) || length > MSG_DATA_SIZE) {
      CC2420RadioM$flushRXFIFO();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 611
        CC2420RadioM$bPacketReceiving = FALSE;
#line 611
        __nesc_atomic_end(__nesc_atomic); }
      return SUCCESS;
    }

  CC2420RadioM$rxbufptr = (TOS_MsgPtr )data;




  if (
#line 618
  CC2420RadioM$bAckEnable && currentstate == CC2420RadioM$POST_TX_STATE && (
  CC2420RadioM$rxbufptr->fcfhi & 0x07) == 0x02 && 
  CC2420RadioM$rxbufptr->dsn == CC2420RadioM$currentDSN && 
  data[length - 1] >> 7 == 1) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 622
        {
          CC2420RadioM$txbufptr->ack = 1;
          CC2420RadioM$txbufptr->strength = data[length - 2];
          CC2420RadioM$txbufptr->lqi = data[length - 1] & 0x7F;

          CC2420RadioM$stateRadio = CC2420RadioM$POST_TX_ACK_STATE;
          CC2420RadioM$bPacketReceiving = FALSE;
        }
#line 629
        __nesc_atomic_end(__nesc_atomic); }
      if (!TOS_post(CC2420RadioM$PacketSent)) {
        CC2420RadioM$sendFailed();
        }
#line 632
      return SUCCESS;
    }




  if ((CC2420RadioM$rxbufptr->fcfhi & 0x07) != 0x01 || 
  CC2420RadioM$rxbufptr->fcflo != 0x08) {
      CC2420RadioM$flushRXFIFO();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 641
        CC2420RadioM$bPacketReceiving = FALSE;
#line 641
        __nesc_atomic_end(__nesc_atomic); }
      return SUCCESS;
    }

  CC2420RadioM$rxbufptr->length = CC2420RadioM$rxbufptr->length - MSG_HEADER_SIZE - MSG_FOOTER_SIZE;

  if (CC2420RadioM$rxbufptr->length > 29) {
      CC2420RadioM$flushRXFIFO();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 649
        CC2420RadioM$bPacketReceiving = FALSE;
#line 649
        __nesc_atomic_end(__nesc_atomic); }
      return SUCCESS;
    }


  CC2420RadioM$rxbufptr->addr = fromLSB16(CC2420RadioM$rxbufptr->addr);


  CC2420RadioM$rxbufptr->crc = data[length - 1] >> 7;

  CC2420RadioM$rxbufptr->strength = data[length - 2];

  CC2420RadioM$rxbufptr->lqi = data[length - 1] & 0x7F;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 663
    {
      if (!TOS_post(CC2420RadioM$PacketRcvd)) {
          CC2420RadioM$bPacketReceiving = FALSE;
        }
    }
#line 667
    __nesc_atomic_end(__nesc_atomic); }

  if (!TOSH_READ_CC_FIFO_PIN() && !TOSH_READ_CC_FIFOP_PIN()) {
      CC2420RadioM$flushRXFIFO();
      return SUCCESS;
    }

  if (!TOSH_READ_CC_FIFOP_PIN()) {
      if (TOS_post(CC2420RadioM$delayedRXFIFOtask)) {
        return SUCCESS;
        }
    }
#line 678
  CC2420RadioM$flushRXFIFO();


  return SUCCESS;
}

# 39 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
inline static   result_t HPLCC2420FIFOM$HPLCC2420FIFO$RXFIFODone(uint8_t arg_0xa692e38, uint8_t *arg_0xa692f98){
#line 39
  unsigned char result;
#line 39

#line 39
  result = CC2420RadioM$HPLChipconFIFO$RXFIFODone(arg_0xa692e38, arg_0xa692f98);
#line 39

#line 39
  return result;
#line 39
}
#line 39
static inline  
# 74 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420FIFOM.nc"
void HPLCC2420FIFOM$signalRXdone(void)
#line 74
{
  uint8_t _rxlen;
  uint8_t *_rxbuf;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 78
    {
      _rxlen = HPLCC2420FIFOM$rxlength;
      _rxbuf = HPLCC2420FIFOM$rxbuf;
      HPLCC2420FIFOM$rxbufBusy = FALSE;
    }
#line 82
    __nesc_atomic_end(__nesc_atomic); }

  HPLCC2420FIFOM$HPLCC2420FIFO$RXFIFODone(_rxlen, _rxbuf);
}

# 149 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_SET_CC_CS_PIN(void)
#line 149
{
#line 149
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x18 + 0x20) |= 1 << 0;
}

static inline   
# 146 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420FIFOM.nc"
result_t HPLCC2420FIFOM$HPLCC2420FIFO$readRXFIFO(uint8_t len, uint8_t *msg)
#line 146
{
  uint8_t status;
#line 147
  uint8_t i;
  bool returnFail = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 150
    {
      if (HPLCC2420FIFOM$rxbufBusy) {
        returnFail = TRUE;
        }
      else {
#line 154
        HPLCC2420FIFOM$rxbufBusy = TRUE;
        }
    }
#line 156
    __nesc_atomic_end(__nesc_atomic); }
  if (returnFail) {
    return FAIL;
    }


  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 162
    {
      HPLCC2420FIFOM$bSpiAvail = FALSE;
      HPLCC2420FIFOM$rxbuf = msg;
      TOSH_CLR_CC_CS_PIN();
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = 0x3F | 0x40;
      while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
        }
#line 167
      ;
      status = * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20);
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = 0;
      while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
        }
#line 170
      ;
      HPLCC2420FIFOM$rxlength = * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20);
      if (HPLCC2420FIFOM$rxlength > 0) {
          HPLCC2420FIFOM$rxbuf[0] = HPLCC2420FIFOM$rxlength;

          HPLCC2420FIFOM$rxlength++;

          if (HPLCC2420FIFOM$rxlength > len) {
#line 177
            HPLCC2420FIFOM$rxlength = len;
            }
          for (i = 1; i < HPLCC2420FIFOM$rxlength; i++) {
              * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = 0;
              while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
                }
#line 181
              ;
              HPLCC2420FIFOM$rxbuf[i] = * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20);
            }
        }

      HPLCC2420FIFOM$bSpiAvail = TRUE;
    }
#line 187
    __nesc_atomic_end(__nesc_atomic); }
  TOSH_SET_CC_CS_PIN();
  if (TOS_post(HPLCC2420FIFOM$signalRXdone) == FAIL) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 190
        HPLCC2420FIFOM$rxbufBusy = FALSE;
#line 190
        __nesc_atomic_end(__nesc_atomic); }
      return FAIL;
    }
  return SUCCESS;
}

# 19 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
inline static   result_t CC2420RadioM$HPLChipconFIFO$readRXFIFO(uint8_t arg_0xa692080, uint8_t *arg_0xa6921e0){
#line 19
  unsigned char result;
#line 19

#line 19
  result = HPLCC2420FIFOM$HPLCC2420FIFO$readRXFIFO(arg_0xa692080, arg_0xa6921e0);
#line 19

#line 19
  return result;
#line 19
}
#line 19
# 67 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
inline static  result_t CC2420RadioM$Send$sendDone(TOS_MsgPtr arg_0xa54a868, result_t arg_0xa54a9b8){
#line 67
  unsigned char result;
#line 67

#line 67
  result = TransceiverM$SendRadio$sendDone(arg_0xa54a868, arg_0xa54a9b8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
static inline  
# 581 "BasicRoutingM.nc"
result_t BasicRoutingM$Transceiver$radioSendDone(TOS_MsgPtr m, result_t result)
{
  return SUCCESS;
}

static inline  
# 123 "RfmToSensorM.nc"
result_t RfmToSensorM$ReceiveSensorMsg$radioSendDone(TOS_MsgPtr m, result_t result)
{
  return SUCCESS;
}

static inline  
# 128 "SensorToRfmM.nc"
result_t SensorToRfmM$Send$radioSendDone(TOS_MsgPtr msg, result_t success)
{





  return SUCCESS;
}

static inline  
# 225 "SensorToUARTM.nc"
result_t SensorToUARTM$DataMsg$radioSendDone(TOS_MsgPtr m, result_t result)
{
  return SUCCESS;
}

static inline  
#line 241
result_t SensorToUARTM$ResetCounterMsg$radioSendDone(TOS_MsgPtr m, result_t result)
{
  return SUCCESS;
}

static inline   
# 494 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
result_t TransceiverM$Transceiver$default$radioSendDone(uint8_t type, TOS_MsgPtr m, 
result_t result)
#line 495
{
  return SUCCESS;
}

# 118 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/Transceiver.nc"
inline static  result_t TransceiverM$Transceiver$radioSendDone(uint8_t arg_0xa5ff370, TOS_MsgPtr arg_0xa33bbf8, result_t arg_0xa33bd48){
#line 118
  unsigned char result;
#line 118

#line 118
  switch (arg_0xa5ff370) {
#line 118
    case AM_SENSORMSG:
#line 118
      result = SensorToRfmM$Send$radioSendDone(arg_0xa33bbf8, arg_0xa33bd48);
#line 118
      result = rcombine(result, RfmToSensorM$ReceiveSensorMsg$radioSendDone(arg_0xa33bbf8, arg_0xa33bd48));
#line 118
      break;
#line 118
    case AM_SIMPLECMDMSG:
#line 118
      result = BasicRoutingM$Transceiver$radioSendDone(arg_0xa33bbf8, arg_0xa33bd48);
#line 118
      break;
#line 118
    case AM_CPUMSG:
#line 118
      result = SensorToUARTM$DataMsg$radioSendDone(arg_0xa33bbf8, arg_0xa33bd48);
#line 118
      break;
#line 118
    case AM_CPURESETMSG:
#line 118
      result = SensorToUARTM$ResetCounterMsg$radioSendDone(arg_0xa33bbf8, arg_0xa33bd48);
#line 118
      break;
#line 118
    default:
#line 118
      result = TransceiverM$Transceiver$default$radioSendDone(arg_0xa5ff370, arg_0xa33bbf8, arg_0xa33bd48);
#line 118
    }
#line 118

#line 118
  return result;
#line 118
}
#line 118
# 116 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_CLR_RED_LED_PIN(void)
#line 116
{
#line 116
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1B + 0x20) &= ~(1 << 2);
}

static inline   
# 72 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/LedsC.nc"
result_t LedsC$Leds$redOn(void)
#line 72
{
  {
  }
#line 73
  ;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 74
    {
      TOSH_CLR_RED_LED_PIN();
      LedsC$ledsOn |= LedsC$RED_BIT;
    }
#line 77
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 64 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t SensorToLedsM$Leds$redOn(void){
#line 64
  unsigned char result;
#line 64

#line 64
  result = LedsC$Leds$redOn();
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 117 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_CLR_GREEN_LED_PIN(void)
#line 117
{
#line 117
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1B + 0x20) &= ~(1 << 1);
}

static inline   
# 101 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/LedsC.nc"
result_t LedsC$Leds$greenOn(void)
#line 101
{
  {
  }
#line 102
  ;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 103
    {
      TOSH_CLR_GREEN_LED_PIN();
      LedsC$ledsOn |= LedsC$GREEN_BIT;
    }
#line 106
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 89 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t SensorToLedsM$Leds$greenOn(void){
#line 89
  unsigned char result;
#line 89

#line 89
  result = LedsC$Leds$greenOn();
#line 89

#line 89
  return result;
#line 89
}
#line 89
# 118 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline void TOSH_CLR_YELLOW_LED_PIN(void)
#line 118
{
#line 118
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x1B + 0x20) &= ~(1 << 0);
}

static inline   
# 130 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/LedsC.nc"
result_t LedsC$Leds$yellowOn(void)
#line 130
{
  {
  }
#line 131
  ;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 132
    {
      TOSH_CLR_YELLOW_LED_PIN();
      LedsC$ledsOn |= LedsC$YELLOW_BIT;
    }
#line 135
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 114 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t SensorToLedsM$Leds$yellowOn(void){
#line 114
  unsigned char result;
#line 114

#line 114
  result = LedsC$Leds$yellowOn();
#line 114

#line 114
  return result;
#line 114
}
#line 114
static inline  
# 559 "BasicRoutingM.nc"
result_t BasicRoutingM$LedOut$outputComplete(result_t success)
{
  return SUCCESS;
}

# 69 "SensorOutput.nc"
inline static  result_t SensorToLedsM$SensorOutput$outputComplete(result_t arg_0xa323ba0){
#line 69
  unsigned char result;
#line 69

#line 69
  result = BasicRoutingM$LedOut$outputComplete(arg_0xa323ba0);
#line 69

#line 69
  return result;
#line 69
}
#line 69
static inline  
# 78 "SensorToLedsM.nc"
void SensorToLedsM$outputDone(void)
{
  SensorToLedsM$SensorOutput$outputComplete(1);
}

static inline    
# 168 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer1M.nc"
result_t HPLTimer1M$Timer1$default$fire(void)
#line 168
{
#line 168
  return SUCCESS;
}

# 177 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/Clock16.nc"
inline static   result_t HPLTimer1M$Timer1$fire(void){
#line 177
  unsigned char result;
#line 177

#line 177
  result = HPLTimer1M$Timer1$default$fire();
#line 177

#line 177
  return result;
#line 177
}
#line 177
static inline   
# 227 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer1M.nc"
uint16_t HPLTimer1M$CaptureT1$getEvent(void)
#line 227
{
  uint16_t i;

#line 229
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 229
    i = * (volatile unsigned int *)(unsigned int )& * (volatile unsigned char *)(0x26 + 0x20);
#line 229
    __nesc_atomic_end(__nesc_atomic); }
  return i;
}

# 72 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/TimerCapture.nc"
inline static   void HPLTimer1M$CaptureT1$captured(uint16_t arg_0xa75fea8){
#line 72
  HPLCC2420InterruptM$SFDCapture$captured(arg_0xa75fea8);
#line 72
}
#line 72
# 278 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer1M.nc"
void __attribute((signal))   __vector_11(void)
{
  HPLTimer1M$CaptureT1$captured(HPLTimer1M$CaptureT1$getEvent());
}

static inline    
# 728 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
void CC2420RadioM$RadioReceiveCoordinator$default$startSymbol(uint8_t bitsPerBlock, uint8_t offset, TOS_MsgPtr msgBuff)
#line 728
{
}

# 33 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/RadioCoordinator.nc"
inline static   void CC2420RadioM$RadioReceiveCoordinator$startSymbol(uint8_t arg_0xa661070, uint8_t arg_0xa6611b8, TOS_MsgPtr arg_0xa661308){
#line 33
  CC2420RadioM$RadioReceiveCoordinator$default$startSymbol(arg_0xa661070, arg_0xa6611b8, arg_0xa661308);
#line 33
}
#line 33
static 
# 143 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
__inline result_t CC2420RadioM$setAckTimer(uint16_t jiffy)
#line 143
{
  CC2420RadioM$stateTimer = CC2420RadioM$TIMER_ACK;
  return CC2420RadioM$BackoffTimerJiffy$setOneShot(jiffy);
}

static inline   
# 211 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420InterruptM.nc"
result_t HPLCC2420InterruptM$SFD$disable(void)
#line 211
{
  HPLCC2420InterruptM$SFDCapture$disableEvents();

  return SUCCESS;
}

# 60 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
inline static   result_t CC2420RadioM$SFD$disable(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = HPLCC2420InterruptM$SFD$disable();
#line 60

#line 60
  return result;
#line 60
}
#line 60
static inline    
# 726 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
void CC2420RadioM$RadioSendCoordinator$default$startSymbol(uint8_t bitsPerBlock, uint8_t offset, TOS_MsgPtr msgBuff)
#line 726
{
}

# 33 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/RadioCoordinator.nc"
inline static   void CC2420RadioM$RadioSendCoordinator$startSymbol(uint8_t arg_0xa661070, uint8_t arg_0xa6611b8, TOS_MsgPtr arg_0xa661308){
#line 33
  CC2420RadioM$RadioSendCoordinator$default$startSymbol(arg_0xa661070, arg_0xa6611b8, arg_0xa661308);
#line 33
}
#line 33
# 148 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline int TOSH_READ_CC_SFD_PIN(void)
#line 148
{
#line 148
  return (* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x10 + 0x20) & (1 << 4)) != 0;
}

static inline   
# 311 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
result_t CC2420RadioM$SFD$captured(uint16_t time)
#line 311
{
  switch (CC2420RadioM$stateRadio) {
      case CC2420RadioM$TX_STATE: 

        CC2420RadioM$SFD$enableCapture(FALSE);


      if (!TOSH_READ_CC_SFD_PIN()) {
          CC2420RadioM$SFD$disable();
        }
      else {
          CC2420RadioM$stateRadio = CC2420RadioM$TX_WAIT;
        }

      CC2420RadioM$txbufptr->time = time;
      CC2420RadioM$RadioSendCoordinator$startSymbol(8, 0, CC2420RadioM$txbufptr);


      if (CC2420RadioM$stateRadio == CC2420RadioM$TX_WAIT) {
          break;
        }
      case CC2420RadioM$TX_WAIT: 

        CC2420RadioM$stateRadio = CC2420RadioM$POST_TX_STATE;
      CC2420RadioM$SFD$disable();

      CC2420RadioM$SFD$enableCapture(TRUE);

      if (CC2420RadioM$bAckEnable && CC2420RadioM$txbufptr->addr != TOS_BCAST_ADDR) {
          if (!CC2420RadioM$setAckTimer(75)) {
            CC2420RadioM$sendFailed();
            }
        }
      else {
          if (!TOS_post(CC2420RadioM$PacketSent)) {
            CC2420RadioM$sendFailed();
            }
        }
#line 348
      break;
      default: 

        CC2420RadioM$rxbufptr->time = time;
      CC2420RadioM$RadioReceiveCoordinator$startSymbol(8, 0, CC2420RadioM$rxbufptr);
    }
  return SUCCESS;
}

# 53 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
inline static   result_t HPLCC2420InterruptM$SFD$captured(uint16_t arg_0xa6b0eb0){
#line 53
  unsigned char result;
#line 53

#line 53
  result = CC2420RadioM$SFD$captured(arg_0xa6b0eb0);
#line 53

#line 53
  return result;
#line 53
}
#line 53
static inline   
# 219 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer1M.nc"
bool HPLTimer1M$CaptureT1$isOverflowPending(void)
#line 219
{
  return * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x36 + 0x20) & 2;
}

# 47 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/TimerCapture.nc"
inline static   bool HPLCC2420InterruptM$SFDCapture$isOverflowPending(void){
#line 47
  unsigned char result;
#line 47

#line 47
  result = HPLTimer1M$CaptureT1$isOverflowPending();
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 148 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Clock.nc"
inline static   result_t TimerJiffyAsyncM$Timer$setIntervalAndScale(uint8_t arg_0xa43be90, uint8_t arg_0xa438010){
#line 148
  unsigned char result;
#line 148

#line 148
  result = HPLTimer2$Timer2$setIntervalAndScale(arg_0xa43be90, arg_0xa438010);
#line 148

#line 148
  return result;
#line 148
}
#line 148
static inline   
# 416 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
result_t CC2420RadioM$BackoffTimerJiffy$fired(void)
#line 416
{
  uint8_t currentstate;

#line 418
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 418
    currentstate = CC2420RadioM$stateRadio;
#line 418
    __nesc_atomic_end(__nesc_atomic); }

  switch (CC2420RadioM$stateTimer) {
      case CC2420RadioM$TIMER_INITIAL: 
        if (!TOS_post(CC2420RadioM$startSend)) {
            CC2420RadioM$sendFailed();
          }
      break;
      case CC2420RadioM$TIMER_BACKOFF: 
        CC2420RadioM$tryToSend();
      break;
      case CC2420RadioM$TIMER_ACK: 
        if (currentstate == CC2420RadioM$POST_TX_STATE) {





            { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 436
              {
                CC2420RadioM$txbufptr->ack = 0;
                CC2420RadioM$stateRadio = CC2420RadioM$POST_TX_ACK_STATE;
              }
#line 439
              __nesc_atomic_end(__nesc_atomic); }
            if (!TOS_post(CC2420RadioM$PacketSent)) {
              CC2420RadioM$sendFailed();
              }
          }
#line 443
      break;
    }
  return SUCCESS;
}

# 12 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
inline static   result_t TimerJiffyAsyncM$TimerJiffyAsync$fired(void){
#line 12
  unsigned char result;
#line 12

#line 12
  result = CC2420RadioM$BackoffTimerJiffy$fired();
#line 12

#line 12
  return result;
#line 12
}
#line 12
static inline   
# 44 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/TimerJiffyAsyncM.nc"
result_t TimerJiffyAsyncM$Timer$fire(void)
#line 44
{
  uint16_t localjiffy;

#line 46
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 46
    localjiffy = TimerJiffyAsyncM$jiffy;
#line 46
    __nesc_atomic_end(__nesc_atomic); }
  if (localjiffy < 0xFF) {
      TimerJiffyAsyncM$Timer$intDisable();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 49
        TimerJiffyAsyncM$bSet = FALSE;
#line 49
        __nesc_atomic_end(__nesc_atomic); }
      TimerJiffyAsyncM$TimerJiffyAsync$fired();
    }
  else {

      localjiffy = localjiffy >> 8;
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 55
        TimerJiffyAsyncM$jiffy = localjiffy;
#line 55
        __nesc_atomic_end(__nesc_atomic); }
      TimerJiffyAsyncM$Timer$setIntervalAndScale(localjiffy, 0x4);
    }
  return SUCCESS;
}

# 180 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/interfaces/Clock.nc"
inline static   result_t HPLTimer2$Timer2$fire(void){
#line 180
  unsigned char result;
#line 180

#line 180
  result = TimerJiffyAsyncM$Timer$fire();
#line 180

#line 180
  return result;
#line 180
}
#line 180
static inline   
# 688 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
result_t CC2420RadioM$HPLChipconFIFO$TXFIFODone(uint8_t length, uint8_t *data)
#line 688
{
  CC2420RadioM$tryToSend();
  return SUCCESS;
}

# 50 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
inline static   result_t HPLCC2420FIFOM$HPLCC2420FIFO$TXFIFODone(uint8_t arg_0xa6934c8, uint8_t *arg_0xa693628){
#line 50
  unsigned char result;
#line 50

#line 50
  result = CC2420RadioM$HPLChipconFIFO$TXFIFODone(arg_0xa6934c8, arg_0xa693628);
#line 50

#line 50
  return result;
#line 50
}
#line 50
static inline  
# 57 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420FIFOM.nc"
void HPLCC2420FIFOM$signalTXdone(void)
#line 57
{
  uint8_t _txlen;
  uint8_t *_txbuf;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 61
    {
      _txlen = HPLCC2420FIFOM$txlength;
      _txbuf = HPLCC2420FIFOM$txbuf;
      HPLCC2420FIFOM$txbufBusy = FALSE;
    }
#line 65
    __nesc_atomic_end(__nesc_atomic); }

  HPLCC2420FIFOM$HPLCC2420FIFO$TXFIFODone(_txlen, _txbuf);
}

static inline   
#line 95
result_t HPLCC2420FIFOM$HPLCC2420FIFO$writeTXFIFO(uint8_t len, uint8_t *msg)
#line 95
{
  uint8_t i = 0;
  uint8_t status;
  bool returnFail = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 100
    {
      if (HPLCC2420FIFOM$txbufBusy) {
        returnFail = TRUE;
        }
      else {
#line 104
        HPLCC2420FIFOM$txbufBusy = TRUE;
        }
    }
#line 106
    __nesc_atomic_end(__nesc_atomic); }
  if (returnFail) {
    return FAIL;
    }


  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 112
    {
      HPLCC2420FIFOM$bSpiAvail = FALSE;
      HPLCC2420FIFOM$txlength = len;
      HPLCC2420FIFOM$txbuf = msg;
      TOSH_CLR_CC_CS_PIN();
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = 0x3E;
      while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
        }
#line 118
      ;
      status = * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20);
      for (i = 0; i < HPLCC2420FIFOM$txlength; i++) {
          * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = *HPLCC2420FIFOM$txbuf;
          HPLCC2420FIFOM$txbuf++;
          while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
            }
#line 123
          ;
        }
      HPLCC2420FIFOM$bSpiAvail = TRUE;
    }
#line 126
    __nesc_atomic_end(__nesc_atomic); }
  TOSH_SET_CC_CS_PIN();
  if (TOS_post(HPLCC2420FIFOM$signalTXdone) == FAIL) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 129
        HPLCC2420FIFOM$txbufBusy = FALSE;
#line 129
        __nesc_atomic_end(__nesc_atomic); }
      return FAIL;
    }
  return status;
}

# 29 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
inline static   result_t CC2420RadioM$HPLChipconFIFO$writeTXFIFO(uint8_t arg_0xa6927b8, uint8_t *arg_0xa692918){
#line 29
  unsigned char result;
#line 29

#line 29
  result = HPLCC2420FIFOM$HPLCC2420FIFO$writeTXFIFO(arg_0xa6927b8, arg_0xa692918);
#line 29

#line 29
  return result;
#line 29
}
#line 29
# 152 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/hardware.h"
static __inline int TOSH_READ_RADIO_CCA_PIN(void)
#line 152
{
#line 152
  return (* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x10 + 0x20) & (1 << 6)) != 0;
}

static 
# 135 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
__inline result_t CC2420RadioM$setBackoffTimer(uint16_t jiffy)
#line 135
{
  CC2420RadioM$stateTimer = CC2420RadioM$TIMER_BACKOFF;
  if (jiffy == 0) {

    return CC2420RadioM$BackoffTimerJiffy$setOneShot(2);
    }
#line 140
  return CC2420RadioM$BackoffTimerJiffy$setOneShot(jiffy);
}

# 47 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
inline static   uint8_t CC2420RadioM$HPLChipcon$cmd(uint8_t arg_0xa6721a0){
#line 47
  unsigned char result;
#line 47

#line 47
  result = HPLCC2420M$HPLCC2420$cmd(arg_0xa6721a0);
#line 47

#line 47
  return result;
#line 47
}
#line 47
static inline 
# 288 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
void CC2420RadioM$sendPacket(void)
#line 288
{
  uint8_t status;

  CC2420RadioM$HPLChipcon$cmd(0x05);
  status = CC2420RadioM$HPLChipcon$cmd(0x00);
  if ((status >> 3) & 0x01) {

      CC2420RadioM$SFD$enableCapture(TRUE);
    }
  else {

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 299
        CC2420RadioM$stateRadio = CC2420RadioM$PRE_TX_STATE;
#line 299
        __nesc_atomic_end(__nesc_atomic); }
      if (!CC2420RadioM$setBackoffTimer(CC2420RadioM$MacBackoff$congestionBackoff(CC2420RadioM$txbufptr) * 10)) {
          CC2420RadioM$sendFailed();
        }
    }
}

# 102 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/sched.c"
bool  TOS_post(void (*tp)(void))
#line 102
{
  __nesc_atomic_t fInterruptFlags;
  uint8_t tmp;



  fInterruptFlags = __nesc_atomic_start();

  tmp = TOSH_sched_free;

  if (TOSH_queue[tmp].tp == (void *)0) {
      TOSH_sched_free = (tmp + 1) & TOSH_TASK_BITMASK;
      TOSH_queue[tmp].tp = tp;
      __nesc_atomic_end(fInterruptFlags);

      return TRUE;
    }
  else {
      __nesc_atomic_end(fInterruptFlags);

      return FALSE;
    }
}

# 54 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/RealMain.nc"
int   main(void)
#line 54
{
  RealMain$hardwareInit();
  RealMain$Pot$init(10);
  TOSH_sched_init();

  RealMain$StdControl$init();
  RealMain$StdControl$start();
  __nesc_enable_interrupt();

  while (1) {
      TOSH_run_task();
    }
}

static  
# 77 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/TimerM.nc"
result_t TimerM$StdControl$init(void)
#line 77
{
  TimerM$mState = 0;
  TimerM$setIntervalFlag = 0;
  TimerM$queue_head = TimerM$queue_tail = -1;
  TimerM$queue_size = 0;
  TimerM$mScale = 3;
  TimerM$mInterval = TimerM$maxTimerInterval;
  return TimerM$Clock$setRate(TimerM$mInterval, TimerM$mScale);
}

static 
# 693 "BasicRoutingM.nc"
void BasicRoutingM$arrayAssign(uint16_t assignFrom[3][7][4], uint16_t assignTo[3][7][4])
{
  uint16_t r;
#line 695
  uint16_t c;
#line 695
  uint16_t level;

  for (level = 0; level < 3; level++) 
    {
      for (r = 0; r < 7; r++) 
        {
          for (c = 0; c < 4; c++) 
            {
              assignTo[level][r][c] = assignFrom[level][r][c];
            }
        }
    }
}

static 
void BasicRoutingM$arrayAssignDouble(double assignFrom[3][7], double assignTo[3][7])
{
  uint16_t r;
#line 712
  uint16_t level;

  for (level = 0; level < 3; level++) 
    {
      for (r = 0; r < 7; r++) 
        {
          assignTo[level][r] = assignFrom[level][r];
        }
    }
}

static  
# 182 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
result_t TransceiverM$StdControl$init(void)
#line 182
{
  int i;

#line 184
  TransceiverM$nextWriteMsg = 0;
  TransceiverM$nextSendMsg = 0;
  for (i = 0; i < 6; i++) {
      TransceiverM$msg[i].state = TransceiverM$MSG_S_CANWRITE;
    }
  return SUCCESS;
}

static  
# 190 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
result_t CC2420RadioM$SplitControl$init(void)
#line 190
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 192
    {
      CC2420RadioM$stateRadio = CC2420RadioM$DISABLED_STATE;
      CC2420RadioM$currentDSN = 0;
      CC2420RadioM$bAckEnable = FALSE;
      CC2420RadioM$bPacketReceiving = FALSE;
      CC2420RadioM$rxbufptr = &CC2420RadioM$RxBuf;
      CC2420RadioM$rxbufptr->length = 0;
    }
#line 199
    __nesc_atomic_end(__nesc_atomic); }

  CC2420RadioM$TimerControl$init();
  CC2420RadioM$Random$init();
  CC2420RadioM$LocalAddr = TOS_LOCAL_ADDRESS;
  return CC2420RadioM$CC2420SplitControl$init();
}

static 
# 313 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/FramerM.nc"
void FramerM$HDLCInitialize(void)
#line 313
{
  int i;

#line 315
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 315
    {
      for (i = 0; i < FramerM$HDLC_QUEUESIZE; i++) {
          FramerM$gMsgRcvTbl[i].pMsg = &FramerM$gMsgRcvBuf[i];
          FramerM$gMsgRcvTbl[i].Length = 0;
          FramerM$gMsgRcvTbl[i].Token = 0;
        }
      FramerM$gTxState = FramerM$TXSTATE_IDLE;
      FramerM$gTxByteCnt = 0;
      FramerM$gTxLength = 0;
      FramerM$gTxRunningCRC = 0;
      FramerM$gpTxMsg = (void *)0;

      FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
      FramerM$gRxHeadIndex = 0;
      FramerM$gRxTailIndex = 0;
      FramerM$gRxByteCnt = 0;
      FramerM$gRxRunningCRC = 0;
      FramerM$gpRxBuf = (uint8_t *)FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].pMsg;
    }
#line 333
    __nesc_atomic_end(__nesc_atomic); }
}

static   
# 110 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLADCM.nc"
result_t HPLADCM$ADC$bindPort(uint8_t port, uint8_t adcPort)
#line 110
{

  if (
#line 111
  port < TOSH_ADC_PORTMAPSIZE && 
  port != TOS_ADC_BANDGAP_PORT && 
  port != TOS_ADC_GND_PORT) {
      HPLADCM$init_portmap();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 115
        HPLADCM$TOSH_adc_portmap[port] = adcPort;
#line 115
        __nesc_atomic_end(__nesc_atomic); }
      return SUCCESS;
    }
  else {
    return FAIL;
    }
}

static 
#line 63
void HPLADCM$init_portmap(void)
#line 63
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 65
    {
      if (HPLADCM$init_portmap_done == FALSE) {
          int i;

#line 68
          for (i = 0; i < TOSH_ADC_PORTMAPSIZE; i++) 
            HPLADCM$TOSH_adc_portmap[i] = i;


          HPLADCM$TOSH_adc_portmap[TOS_ADC_BANDGAP_PORT] = TOSH_ACTUAL_BANDGAP_PORT;
          HPLADCM$TOSH_adc_portmap[TOS_ADC_GND_PORT] = TOSH_ACTUAL_GND_PORT;
          HPLADCM$init_portmap_done = TRUE;
        }
    }
#line 76
    __nesc_atomic_end(__nesc_atomic); }
}

static  
# 99 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCREFM.nc"
result_t ADCREFM$ADCControl$init(void)
#line 99
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 100
    {
      ADCREFM$ReqPort = 0;
      ADCREFM$ReqVector = ADCREFM$ContReqMask = ADCREFM$CalReqMask = 0;
      ADCREFM$RefVal = 381;
    }
#line 104
    __nesc_atomic_end(__nesc_atomic); }
  {
  }
#line 105
  ;

  return ADCREFM$HPLADC$init();
}

static  
# 244 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
result_t CC2420RadioM$SplitControl$start(void)
#line 244
{
  uint8_t chkstateRadio;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 247
    chkstateRadio = CC2420RadioM$stateRadio;
#line 247
    __nesc_atomic_end(__nesc_atomic); }

  if (chkstateRadio == CC2420RadioM$DISABLED_STATE) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 250
        {
          CC2420RadioM$stateRadio = CC2420RadioM$WARMUP_STATE;
          CC2420RadioM$countRetry = 0;
          CC2420RadioM$rxbufptr->length = 0;
        }
#line 254
        __nesc_atomic_end(__nesc_atomic); }
      CC2420RadioM$TimerControl$start();
      return CC2420RadioM$CC2420SplitControl$start();
    }
  return FAIL;
}

static   
# 128 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420M.nc"
result_t HPLCC2420M$HPLCC2420$write(uint8_t addr, uint16_t data)
#line 128
{
  uint8_t status;



  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 133
    {
      HPLCC2420M$bSpiAvail = FALSE;
      TOSH_CLR_CC_CS_PIN();
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = addr;
      while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
        }
#line 137
      ;
      status = * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20);
      if (addr > 0x0E) {
          * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = data >> 8;
          while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
            }
#line 141
          ;
          * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = data & 0xff;
          while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
            }
#line 143
          ;
        }
      HPLCC2420M$bSpiAvail = TRUE;
    }
#line 146
    __nesc_atomic_end(__nesc_atomic); }
  TOSH_SET_CC_CS_PIN();
  return status;
}

static  
# 98 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/TimerM.nc"
result_t TimerM$Timer$start(uint8_t id, char type, 
uint32_t interval)
#line 99
{
  uint8_t diff;

#line 101
  if (id >= NUM_TIMERS) {
#line 101
    return FAIL;
    }
#line 102
  if (type > TIMER_ONE_SHOT) {
#line 102
    return FAIL;
    }





  if (type == TIMER_REPEAT && interval <= 2) {
#line 109
    return FAIL;
    }
  TimerM$mTimerList[id].ticks = interval;
  TimerM$mTimerList[id].type = type;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 114
    {
      diff = TimerM$Clock$readCounter();
      interval += diff;
      TimerM$mTimerList[id].ticksLeft = interval;
      TimerM$mState |= 0x1L << id;
      if (interval < TimerM$mInterval) {
          TimerM$mInterval = interval;
          TimerM$Clock$setInterval(TimerM$mInterval);
          TimerM$setIntervalFlag = 0;
          TimerM$PowerManagement$adjustPower();
        }
    }
#line 125
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

static   
# 102 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/HPLPowerManagementM.nc"
uint8_t HPLPowerManagementM$PowerManagement$adjustPower(void)
#line 102
{
  uint8_t mcu;

#line 104
  if (HPLPowerManagementM$disableCount <= 0) {
    TOS_post(HPLPowerManagementM$doAdjustment);
    }
  else 
#line 106
    {
      mcu = * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x35 + 0x20);
      mcu &= 0xe3;
      mcu |= HPLPowerManagementM$IDLE;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x35 + 0x20) = mcu;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x35 + 0x20) |= 1 << 5;
    }
  return 0;
}

static   
# 103 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420M.nc"
uint8_t HPLCC2420M$HPLCC2420$cmd(uint8_t addr)
#line 103
{
  uint8_t status;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 106
    {
      TOSH_CLR_CC_CS_PIN();
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = addr;
      while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
        }
#line 109
      ;
      status = * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20);
    }
#line 111
    __nesc_atomic_end(__nesc_atomic); }
  TOSH_SET_CC_CS_PIN();
  return status;
}

static   
# 60 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/HPLUART0M.nc"
result_t HPLUART0M$UART$init(void)
#line 60
{





  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)0x90 = 0;
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x09 + 0x20) = 15;


  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0B + 0x20) = 1 << 1;


  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)0x95 = (1 << 2) | (1 << 1);


  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0A + 0x20) = (((1 << 7) | (1 << 6)) | (1 << 4)) | (1 << 3);


  return SUCCESS;
}

# 167 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica/HPLClock.nc"
void __attribute((interrupt))   __vector_15(void)
#line 167
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 168
    {
      if (HPLClock$set_flag) {
          HPLClock$mscale = HPLClock$nextScale;
          HPLClock$nextScale |= 0x8;
          * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x33 + 0x20) = HPLClock$nextScale;

          * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x31 + 0x20) = HPLClock$minterval;
          HPLClock$set_flag = 0;
        }
    }
#line 177
    __nesc_atomic_end(__nesc_atomic); }
  HPLClock$Clock$fire();
}

static   
# 159 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420M.nc"
uint16_t HPLCC2420M$HPLCC2420$read(uint8_t addr)
#line 159
{

  uint16_t data = 0;
  uint8_t status;


  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 165
    {
      HPLCC2420M$bSpiAvail = FALSE;
      TOSH_CLR_CC_CS_PIN();
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = addr | 0x40;
      while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
        }
#line 169
      ;
      status = * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20);
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = 0;
      while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
        }
#line 172
      ;
      data = * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20);
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20) = 0;
      while (!(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0E + 0x20) & 0x80)) {
        }
#line 175
      ;
      data = (data << 8) | * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x0F + 0x20);
      TOSH_SET_CC_CS_PIN();
      HPLCC2420M$bSpiAvail = TRUE;
    }
#line 179
    __nesc_atomic_end(__nesc_atomic); }
  return data;
}

static   
# 194 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer1M.nc"
void HPLTimer1M$CaptureT1$setEdge(uint8_t LowToHigh)
#line 194
{


  if (LowToHigh) {
    * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x2E + 0x20) |= 1 << 6;
    }
  else {
#line 200
    * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x2E + 0x20) &= ~(1 << 6);
    }



  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x36 + 0x20) |= 1 << 5;
  return;
}

static 
# 197 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/mica2/ADCREFM.nc"
result_t ADCREFM$startGet(uint8_t port)
#line 197
{
  uint16_t PortMask;
#line 198
  uint16_t oldReqVector = 1;
  result_t Result = SUCCESS;

  PortMask = 1 << port;

  if ((PortMask & ADCREFM$ReqVector) != 0) {

      Result = FAIL;
    }
  else {
      oldReqVector = ADCREFM$ReqVector;
      ADCREFM$ReqVector |= PortMask;
      if (oldReqVector == 0) {
          ADCREFM$HPLADC$samplePort(port);
          ADCREFM$ReqPort = port;
        }
    }

  return Result;
}

static   
# 122 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLADCM.nc"
result_t HPLADCM$ADC$samplePort(uint8_t port)
#line 122
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 123
    {
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x07 + 0x20) = HPLADCM$TOSH_adc_portmap[port] & 0x1F;
    }
#line 125
    __nesc_atomic_end(__nesc_atomic); }
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x06 + 0x20) |= 1 << 7;
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x06 + 0x20) |= 1 << 6;

  return SUCCESS;
}

static  
# 204 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/sensorboards/micasb/PhotoTempM.nc"
void PhotoTempM$getSample(void)
#line 204
{
  static bool photoIsNext;
  bool isDone;

#line 207
  isDone = FALSE;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 208
    {
      if (PhotoTempM$waitingForSample) {


          isDone = TRUE;
        }
#line 213
      ;
      if (PhotoTempM$photoSensor == PhotoTempM$stateIdle && PhotoTempM$tempSensor == PhotoTempM$stateIdle) {

          isDone = TRUE;
        }
#line 217
      ;


      if (PhotoTempM$photoSensor == PhotoTempM$stateIdle) {
#line 220
        photoIsNext = FALSE;
        }
#line 221
      if (PhotoTempM$tempSensor == PhotoTempM$stateIdle) {
#line 221
        photoIsNext = TRUE;
        }
    }
#line 223
    __nesc_atomic_end(__nesc_atomic); }
#line 222
  ;
  if (isDone) {
      return;
    }
#line 225
  ;
  if (photoIsNext) {

      switch (PhotoTempM$hardwareStatus) {
          case PhotoTempM$sensorIdle: 
            case PhotoTempM$sensorTempReady: 
              PhotoTempM$hardwareStatus = PhotoTempM$sensorPhotoStarting;
          TOSH_SET_PHOTO_CTL_PIN();
          TOSH_MAKE_PHOTO_CTL_OUTPUT();
          TOSH_CLR_TEMP_CTL_PIN();
          TOSH_MAKE_TEMP_CTL_INPUT();
          PhotoTempM$PhotoTempTimer$stop();
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 237
            {
              PhotoTempM$waitingForSample = TRUE;
            }
#line 239
            __nesc_atomic_end(__nesc_atomic); }
#line 239
          ;
          photoIsNext = FALSE;
          if (PhotoTempM$PhotoTempTimer$start(TIMER_ONE_SHOT, 10) != SUCCESS) {
              PhotoTempM$hardwareStatus = PhotoTempM$sensorIdle;
              TOS_post(PhotoTempM$getSample);
            }
#line 244
          ;
          return;
          case PhotoTempM$sensorPhotoReady: 
            { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 247
              {
                PhotoTempM$waitingForSample = TRUE;
              }
#line 249
              __nesc_atomic_end(__nesc_atomic); }
#line 249
          ;
          if (PhotoTempM$InternalPhotoADC$getData() == SUCCESS) {
              photoIsNext = FALSE;
            }
          else 
#line 252
            {
              TOS_post(PhotoTempM$getSample);
            }
#line 254
          ;
          return;
          case PhotoTempM$sensorPhotoStarting: 



            case PhotoTempM$sensorTempStarting: 


              return;
        }
#line 264
      ;
    }
#line 265
  ;
  if (!photoIsNext) {

      switch (PhotoTempM$hardwareStatus) {
          case PhotoTempM$sensorIdle: 
            case PhotoTempM$sensorPhotoReady: 
              PhotoTempM$hardwareStatus = PhotoTempM$sensorTempStarting;
          TOSH_CLR_PHOTO_CTL_PIN();
          TOSH_MAKE_PHOTO_CTL_INPUT();
          TOSH_SET_TEMP_CTL_PIN();
          TOSH_MAKE_TEMP_CTL_OUTPUT();
          PhotoTempM$PhotoTempTimer$stop();
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 277
            {
              PhotoTempM$waitingForSample = TRUE;
            }
#line 279
            __nesc_atomic_end(__nesc_atomic); }
#line 279
          ;
          photoIsNext = TRUE;
          if (PhotoTempM$PhotoTempTimer$start(TIMER_ONE_SHOT, 10) != SUCCESS) {
              PhotoTempM$hardwareStatus = PhotoTempM$sensorIdle;
              TOS_post(PhotoTempM$getSample);
            }
#line 284
          ;
          return;
          case PhotoTempM$sensorTempReady: 
            { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 287
              {
                PhotoTempM$waitingForSample = TRUE;
              }
#line 289
              __nesc_atomic_end(__nesc_atomic); }
#line 289
          ;
          if (PhotoTempM$InternalTempADC$getData() == SUCCESS) {
              photoIsNext = TRUE;
            }
          else 
#line 292
            {
              TOS_post(PhotoTempM$getSample);
            }
#line 294
          ;
          return;
          case PhotoTempM$sensorTempStarting: 



            case PhotoTempM$sensorPhotoStarting: 


              return;
        }
#line 304
      ;
    }
#line 305
  ;
  photoIsNext = !photoIsNext;
  return;
}

static  
# 168 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/TimerM.nc"
result_t TimerM$Timer$stop(uint8_t id)
#line 168
{

  if (id >= NUM_TIMERS) {
#line 170
    return FAIL;
    }
#line 171
  if (TimerM$mState & (0x1L << id)) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 172
        TimerM$mState &= ~(0x1L << id);
#line 172
        __nesc_atomic_end(__nesc_atomic); }
      if (!TimerM$mState) {
          TimerM$setIntervalFlag = 1;
        }
      return SUCCESS;
    }
  return FAIL;
}

static  
# 218 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
TOS_MsgPtr TransceiverM$Transceiver$requestWrite(uint8_t type)
#line 218
{
  int i;
  TOS_MsgPtr returnPtr = (void *)0;

  for (i = 0; i < 6; i++) {
      if (TransceiverM$msg[i].tosMsg.type == type && TransceiverM$msg[i].state == TransceiverM$MSG_S_WRITING) {
          returnPtr = & TransceiverM$msg[i].tosMsg;
          break;
        }
    }



  if (
#line 229
  returnPtr == (void *)0
   && TransceiverM$msg[TransceiverM$nextWriteMsg].state == TransceiverM$MSG_S_CANWRITE
   && TransceiverM$WriteState$requestState(TransceiverM$S_WRITING)) {
      TransceiverM$msg[TransceiverM$nextWriteMsg].tosMsg.type = type;
      TransceiverM$msg[TransceiverM$nextWriteMsg].state = TransceiverM$MSG_S_WRITING;
      returnPtr = & TransceiverM$msg[TransceiverM$nextWriteMsg].tosMsg;
      TransceiverM$advanceWriteIndex();
      TransceiverM$WriteState$toIdle();
    }

  return returnPtr;
}

static  
# 84 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/State/StateM.nc"
result_t StateM$State$requestState(uint8_t id, uint8_t reqState)
#line 84
{
  result_t returnVal = FAIL;

#line 86
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 86
    {
      if (reqState == StateM$S_IDLE || StateM$state[id] == StateM$S_IDLE) {
          StateM$state[id] = reqState;
          returnVal = SUCCESS;
        }
    }
#line 91
    __nesc_atomic_end(__nesc_atomic); }
  return returnVal;
}

static 
# 428 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
result_t TransceiverM$pack(uint8_t type, uint16_t dest, uint8_t payloadSize, 
uint8_t outMethod)
#line 429
{
  int i;

#line 431
  for (i = 0; i < 6; i++) {
      if (TransceiverM$msg[i].tosMsg.type == type && TransceiverM$msg[i].state == TransceiverM$MSG_S_WRITING) {
          if (payloadSize > 29) {
              payloadSize = 29;
            }

          TransceiverM$msg[i].state = TransceiverM$MSG_S_CANSEND;
          TransceiverM$msg[i].sendMethod = outMethod;
          TransceiverM$msg[i].tosMsg.length = payloadSize;
          TransceiverM$msg[i].tosMsg.group = TOS_AM_GROUP;
          if (outMethod == RADIO) {
              TransceiverM$msg[i].tosMsg.addr = dest;
            }

          TransceiverM$requestNextSend();
          return SUCCESS;
        }
    }
  return FAIL;
}

static 
#line 467
void TransceiverM$requestNextSend(void)
#line 467
{
  if (TransceiverM$msg[TransceiverM$nextSendMsg].state == TransceiverM$MSG_S_CANSEND) {
      if (TransceiverM$SendState$requestState(TransceiverM$S_SENDING)) {
          TransceiverM$msg[TransceiverM$nextSendMsg].state = TransceiverM$MSG_S_SENDING;
          TOS_post(TransceiverM$sendMsg);
        }
    }
}

static  
#line 406
void TransceiverM$sendMsg(void)
#line 406
{
  if (TransceiverM$msg[TransceiverM$nextSendMsg].sendMethod == RADIO) {
      if (!TransceiverM$SendRadio$send(& TransceiverM$msg[TransceiverM$nextSendMsg].tosMsg)) {
          TOS_post(TransceiverM$sendMsg);
        }
    }
  else 
#line 411
    {
      if (!TransceiverM$SendUart$send(& TransceiverM$msg[TransceiverM$nextSendMsg].tosMsg)) {
          TOS_post(TransceiverM$sendMsg);
        }
    }
}

static   
# 61 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/TimerJiffyAsyncM.nc"
result_t TimerJiffyAsyncM$TimerJiffyAsync$setOneShot(uint32_t _jiffy)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 63
    {
      TimerJiffyAsyncM$jiffy = _jiffy;
      TimerJiffyAsyncM$bSet = TRUE;
    }
#line 66
    __nesc_atomic_end(__nesc_atomic); }
  if (_jiffy > 0xFF) {
      TimerJiffyAsyncM$Timer$setIntervalAndScale(0xFF, 0x4);
    }
  else {
      TimerJiffyAsyncM$Timer$setIntervalAndScale(_jiffy, 0x4);
    }
  return SUCCESS;
}

static   
# 118 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer2.nc"
result_t HPLTimer2$Timer2$setIntervalAndScale(uint8_t interval, uint8_t scale)
#line 118
{

  if (scale > 7) {
#line 120
    return FAIL;
    }
#line 121
  scale |= 0x8;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 122
    {
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x25 + 0x20) = 0;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x37 + 0x20) &= ~(1 << 7);
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x37 + 0x20) &= ~(1 << 6);
      HPLTimer2$mscale = scale;
      HPLTimer2$minterval = interval;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x24 + 0x20) = 0;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x23 + 0x20) = interval;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x36 + 0x20) |= 1 << 7;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x37 + 0x20) |= 1 << 7;
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x25 + 0x20) = scale;
    }
#line 133
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

static   
# 70 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/RandomLFSR.nc"
uint16_t RandomLFSR$Random$rand(void)
#line 70
{
  bool endbit;
  uint16_t tmpShiftReg;

#line 73
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 73
    {
      tmpShiftReg = RandomLFSR$shiftReg;
      endbit = (tmpShiftReg & 0x8000) != 0;
      tmpShiftReg <<= 1;
      if (endbit) {
        tmpShiftReg ^= 0x100b;
        }
#line 79
      tmpShiftReg++;
      RandomLFSR$shiftReg = tmpShiftReg;
      tmpShiftReg = tmpShiftReg ^ RandomLFSR$mask;
    }
#line 82
    __nesc_atomic_end(__nesc_atomic); }
  return tmpShiftReg;
}

static 
# 184 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/FramerM.nc"
result_t FramerM$StartTx(void)
#line 184
{
  result_t Result = SUCCESS;
  bool fInitiate = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 188
    {
      if (FramerM$gTxState == FramerM$TXSTATE_IDLE) {
          if (FramerM$gFlags & FramerM$FLAGS_TOKENPEND) {

              FramerM$gpTxBuf = (uint8_t *)&FramerM$gTxTokenBuf;




              FramerM$gTxProto = FramerM$PROTO_ACK;
              FramerM$gTxLength = sizeof FramerM$gTxTokenBuf;
              fInitiate = TRUE;
              FramerM$gTxState = FramerM$TXSTATE_PROTO;
            }
          else {
#line 202
            if (FramerM$gFlags & FramerM$FLAGS_DATAPEND) {
                FramerM$gpTxBuf = (uint8_t *)FramerM$gpTxMsg;
                FramerM$gTxProto = FramerM$PROTO_PACKET_NOACK;


                FramerM$gTxLength = FramerM$gpTxMsg->length + TOS_HEADER_SIZE + 2 + 3;



                fInitiate = TRUE;
                FramerM$gTxState = FramerM$TXSTATE_PROTO;
              }
            else {
#line 214
              if (FramerM$gFlags & FramerM$FLAGS_UNKNOWN) {
                  FramerM$gpTxBuf = (uint8_t *)&FramerM$gTxUnknownBuf;
                  FramerM$gTxProto = FramerM$PROTO_UNKNOWN;
                  FramerM$gTxLength = sizeof FramerM$gTxUnknownBuf;
                  fInitiate = TRUE;
                  FramerM$gTxState = FramerM$TXSTATE_PROTO;
                }
              }
            }
        }
    }
#line 224
    __nesc_atomic_end(__nesc_atomic); }
#line 224
  if (fInitiate) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 225
        {

          FramerM$gTxRunningCRC = 0;
          FramerM$gTxByteCnt = (size_t )& ((struct TOS_Msg *)0)->addr;
        }
#line 229
        __nesc_atomic_end(__nesc_atomic); }




      Result = FramerM$ByteComm$txByte(FramerM$HDLC_FLAG_BYTE);
      if (Result != SUCCESS) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 236
            FramerM$gTxState = FramerM$TXSTATE_ERROR;
#line 236
            __nesc_atomic_end(__nesc_atomic); }
          TOS_post(FramerM$PacketSent);
        }
    }

  return Result;
}

static   
# 110 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/UARTM.nc"
result_t UARTM$ByteComm$txByte(uint8_t data)
#line 110
{
  bool oldState;

  {
  }
#line 113
  ;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 115
    {
      oldState = UARTM$state;
      UARTM$state = TRUE;
    }
#line 118
    __nesc_atomic_end(__nesc_atomic); }
  if (oldState) {
    return FAIL;
    }
  UARTM$HPLUART$put(data);

  return SUCCESS;
}

static  
# 291 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/FramerM.nc"
void FramerM$PacketSent(void)
#line 291
{
  result_t TxResult = SUCCESS;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 294
    {
      if (FramerM$gTxState == FramerM$TXSTATE_ERROR) {
          TxResult = FAIL;
          FramerM$gTxState = FramerM$TXSTATE_IDLE;
        }
    }
#line 299
    __nesc_atomic_end(__nesc_atomic); }
  if (FramerM$gTxProto == FramerM$PROTO_ACK) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 301
        FramerM$gFlags ^= FramerM$FLAGS_TOKENPEND;
#line 301
        __nesc_atomic_end(__nesc_atomic); }
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 304
        FramerM$gFlags ^= FramerM$FLAGS_DATAPEND;
#line 304
        __nesc_atomic_end(__nesc_atomic); }
      FramerM$BareSendMsg$sendDone((TOS_MsgPtr )FramerM$gpTxMsg, TxResult);
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 306
        FramerM$gpTxMsg = (void *)0;
#line 306
        __nesc_atomic_end(__nesc_atomic); }
    }


  FramerM$StartTx();
}

static 
# 456 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
void TransceiverM$sendDone(void)
#line 456
{
  TransceiverM$msg[TransceiverM$nextSendMsg].state = TransceiverM$MSG_S_CANWRITE;
  TransceiverM$advanceSendIndex();
  TransceiverM$SendState$toIdle();
  TransceiverM$requestNextSend();
}

static 
# 680 "BasicRoutingM.nc"
result_t BasicRoutingM$newMessage(void)
#line 680
{
  if ((BasicRoutingM$tosPtr = BasicRoutingM$Transceiver$requestWrite()) != (void *)0) 
    {
      BasicRoutingM$cmdMsg = (SimpleCmdMsg *)BasicRoutingM$tosPtr->data;
      return SUCCESS;
    }
  return FAIL;
}

# 144 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLADCM.nc"
void __attribute((signal))   __vector_21(void)
#line 144
{
  uint16_t data = * (volatile unsigned int *)(unsigned int )& * (volatile unsigned char *)(0x04 + 0x20);

#line 146
  data &= 0x3ff;
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x06 + 0x20) |= 1 << 4;
  * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x06 + 0x20) &= ~(1 << 7);
  __nesc_enable_interrupt();
  HPLADCM$ADC$dataReady(data);
}

static 
# 929 "BasicRoutingM.nc"
void BasicRoutingM$delaySendMessage(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type)
{
  uint16_t LCV = 0;

#line 933
  while (BasicRoutingM$MessagesPending[LCV][0] == 1) 
    {
      LCV = LCV + 1;
    }

  BasicRoutingM$MessagesPending[LCV][0] = 1;
  BasicRoutingM$MessagesPending[LCV][1] = source;
  BasicRoutingM$MessagesPending[LCV][2] = source;
  BasicRoutingM$MessagesPending[LCV][3] = next_addr;
  BasicRoutingM$MessagesPending[LCV][4] = dest_addr;
  BasicRoutingM$MessagesPending[LCV][5] = hops;
  BasicRoutingM$MessagesPending[LCV][6] = msg_type;

  BasicRoutingM$MessagesPendingData[LCV][0] = measurements[0];
  BasicRoutingM$MessagesPendingData[LCV][1] = measurements[1];
  BasicRoutingM$MessagesPendingData[LCV][2] = measurements[2];
  BasicRoutingM$MessagesPendingData[LCV][3] = measurements[3];
  BasicRoutingM$MessagesPendingData[LCV][4] = measurements[4];
}

static   
# 393 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/FramerM.nc"
result_t FramerM$ByteComm$rxByteReady(uint8_t data, bool error, uint16_t strength)
#line 393
{

  switch (FramerM$gRxState) {

      case FramerM$RXSTATE_NOSYNC: 
        if (data == FramerM$HDLC_FLAG_BYTE && FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Length == 0) {

            FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token = 0;
            FramerM$gRxByteCnt = FramerM$gRxRunningCRC = 0;
            FramerM$gpRxBuf = (uint8_t *)FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].pMsg;
            FramerM$gRxState = FramerM$RXSTATE_PROTO;
          }
      break;

      case FramerM$RXSTATE_PROTO: 
        if (data == FramerM$HDLC_FLAG_BYTE) {
            break;
          }
      FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Proto = data;
      FramerM$gRxRunningCRC = crcByte(FramerM$gRxRunningCRC, data);
      switch (data) {
          case FramerM$PROTO_PACKET_ACK: 
            FramerM$gRxState = FramerM$RXSTATE_TOKEN;
          break;
          case FramerM$PROTO_PACKET_NOACK: 
            FramerM$gRxState = FramerM$RXSTATE_INFO;
          break;
          default: 
            FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
          break;
        }
      break;

      case FramerM$RXSTATE_TOKEN: 
        if (data == FramerM$HDLC_FLAG_BYTE) {
            FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
          }
        else {
#line 430
          if (data == FramerM$HDLC_CTLESC_BYTE) {
              FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token = 0x20;
            }
          else {
              FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token ^= data;
              FramerM$gRxRunningCRC = crcByte(FramerM$gRxRunningCRC, FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token);
              FramerM$gRxState = FramerM$RXSTATE_INFO;
            }
          }
#line 438
      break;


      case FramerM$RXSTATE_INFO: 
        if (FramerM$gRxByteCnt > FramerM$HDLC_MTU) {
            FramerM$gRxByteCnt = FramerM$gRxRunningCRC = 0;
            FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Length = 0;
            FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token = 0;
            FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
          }
        else {
#line 448
          if (data == FramerM$HDLC_CTLESC_BYTE) {
              FramerM$gRxState = FramerM$RXSTATE_ESC;
            }
          else {
#line 451
            if (data == FramerM$HDLC_FLAG_BYTE) {
                if (FramerM$gRxByteCnt >= 2) {

                    uint16_t usRcvdCRC = FramerM$gpRxBuf[FramerM$fRemapRxPos(FramerM$gRxByteCnt - 1)] & 0xff;

#line 455
                    usRcvdCRC = (usRcvdCRC << 8) | FramerM$fRemapRxPos(FramerM$gpRxBuf[FramerM$gRxByteCnt - 2] & 0xff);


                    FramerM$gRxRunningCRC = usRcvdCRC;

                    if (usRcvdCRC == FramerM$gRxRunningCRC) {
                        FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Length = FramerM$gRxByteCnt - 2;
                        TOS_post(FramerM$PacketRcvd);
                        FramerM$gRxHeadIndex++;
#line 463
                        FramerM$gRxHeadIndex %= FramerM$HDLC_QUEUESIZE;
                      }
                    else {
                        FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Length = 0;
                        FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token = 0;
                      }
                    if (FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Length == 0) {
                        FramerM$gpRxBuf = (uint8_t *)FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].pMsg;
                        FramerM$gRxState = FramerM$RXSTATE_PROTO;
                      }
                    else {
                        FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
                      }
                  }
                else {
                    FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Length = 0;
                    FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token = 0;
                    FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
                  }
                FramerM$gRxByteCnt = FramerM$gRxRunningCRC = 0;
              }
            else {
                FramerM$gpRxBuf[FramerM$fRemapRxPos(FramerM$gRxByteCnt)] = data;
                if (FramerM$gRxByteCnt >= 2) {
                    FramerM$gRxRunningCRC = crcByte(FramerM$gRxRunningCRC, FramerM$gpRxBuf[FramerM$gRxByteCnt - 2]);
                  }
                FramerM$gRxByteCnt++;
              }
            }
          }
#line 491
      break;

      case FramerM$RXSTATE_ESC: 
        if (data == FramerM$HDLC_FLAG_BYTE) {

            FramerM$gRxByteCnt = FramerM$gRxRunningCRC = 0;
            FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Length = 0;
            FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token = 0;
            FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
          }
        else {
            data = data ^ 0x20;
            FramerM$gpRxBuf[FramerM$fRemapRxPos(FramerM$gRxByteCnt)] = data;
            if (FramerM$gRxByteCnt >= 2) {
                FramerM$gRxRunningCRC = crcByte(FramerM$gRxRunningCRC, FramerM$gpRxBuf[FramerM$gRxByteCnt - 2]);
              }
            FramerM$gRxByteCnt++;
            FramerM$gRxState = FramerM$RXSTATE_INFO;
          }
      break;

      default: 
        FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
      break;
    }

  return SUCCESS;
}

static 
#line 169
uint8_t FramerM$fRemapRxPos(uint8_t InPos)
#line 169
{


  if (InPos < 4) {
    return InPos + (size_t )& ((struct TOS_Msg *)0)->addr;
    }
  else {
#line 174
    if (InPos == 4) {
      return (size_t )& ((struct TOS_Msg *)0)->length;
      }
    else {
#line 177
      return InPos + (size_t )& ((struct TOS_Msg *)0)->addr - 1;
      }
    }
}

static  
# 393 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
TOS_MsgPtr TransceiverM$ReceiveUart$receive(TOS_MsgPtr m)
#line 393
{
  m->group = TOS_AM_GROUP;
  if (TransceiverM$PacketFilter$filterPacket(m, UART)) {
      return TransceiverM$Transceiver$receiveUart(m->type, m);
    }
  return m;
}

static  
# 50 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/PacketFilterM.nc"
bool PacketFilterM$PacketFilter$filterPacket(TOS_MsgPtr packet, uint8_t inMethod)
#line 50
{
  bool result = packet->crc == 1 && packet->group == TOS_AM_GROUP;

#line 52
  if (inMethod == RADIO) {
      result &= packet->addr == TOS_BCAST_ADDR
       || packet->addr == TOS_LOCAL_ADDRESS;
    }
  return result;
}

static  
# 246 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/AMStandard.nc"
TOS_MsgPtr AMStandard$UARTReceive$receive(TOS_MsgPtr packet)
#line 246
{


  packet->group = TOS_AM_GROUP;
  return received(packet);
}

static   
# 87 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/system/UARTM.nc"
result_t UARTM$HPLUART$putDone(void)
#line 87
{
  bool oldState;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 90
    {
      {
      }
#line 91
      ;
      oldState = UARTM$state;
      UARTM$state = FALSE;
    }
#line 94
    __nesc_atomic_end(__nesc_atomic); }








  if (oldState) {
      UARTM$ByteComm$txDone();
      UARTM$ByteComm$txByteReady(TRUE);
    }
  return SUCCESS;
}

static 
# 520 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/FramerM.nc"
result_t FramerM$TxArbitraryByte(uint8_t inByte)
#line 520
{
  if (inByte == FramerM$HDLC_FLAG_BYTE || inByte == FramerM$HDLC_CTLESC_BYTE) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 522
        {
          FramerM$gPrevTxState = FramerM$gTxState;
          FramerM$gTxState = FramerM$TXSTATE_ESC;
          FramerM$gTxEscByte = inByte;
        }
#line 526
        __nesc_atomic_end(__nesc_atomic); }
      inByte = FramerM$HDLC_CTLESC_BYTE;
    }

  return FramerM$ByteComm$txByte(inByte);
}

# 97 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420InterruptM.nc"
void __attribute((signal))   __vector_7(void)
#line 97
{
  result_t val = SUCCESS;

#line 99
  val = HPLCC2420InterruptM$FIFOP$fired();
  if (val == FAIL) {
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x39 + 0x20) &= ~(1 << 6);
      * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x38 + 0x20) |= 1 << 6;
    }
}

static 
# 118 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
void CC2420RadioM$flushRXFIFO(void)
#line 118
{
  CC2420RadioM$FIFOP$disable();
  CC2420RadioM$HPLChipcon$read(0x3F);
  CC2420RadioM$HPLChipcon$cmd(0x08);
  CC2420RadioM$HPLChipcon$cmd(0x08);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 123
    CC2420RadioM$bPacketReceiving = FALSE;
#line 123
    __nesc_atomic_end(__nesc_atomic); }
  CC2420RadioM$FIFOP$startWait(FALSE);
}

static 
#line 507
void CC2420RadioM$delayedRXFIFO(void)
#line 507
{
  uint8_t len = MSG_DATA_SIZE;
  uint8_t _bPacketReceiving;

  if (!TOSH_READ_CC_FIFO_PIN() && !TOSH_READ_CC_FIFOP_PIN()) {
      CC2420RadioM$flushRXFIFO();
      return;
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 516
    {
      _bPacketReceiving = CC2420RadioM$bPacketReceiving;

      if (_bPacketReceiving) {
          if (!TOS_post(CC2420RadioM$delayedRXFIFOtask)) {
            CC2420RadioM$flushRXFIFO();
            }
        }
      else 
#line 522
        {
          CC2420RadioM$bPacketReceiving = TRUE;
        }
    }
#line 525
    __nesc_atomic_end(__nesc_atomic); }





  if (!_bPacketReceiving) {
      if (!CC2420RadioM$HPLChipconFIFO$readRXFIFO(len, (uint8_t *)CC2420RadioM$rxbufptr)) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 533
            CC2420RadioM$bPacketReceiving = FALSE;
#line 533
            __nesc_atomic_end(__nesc_atomic); }
          if (!TOS_post(CC2420RadioM$delayedRXFIFOtask)) {
              CC2420RadioM$flushRXFIFO();
            }
          return;
        }
    }
  CC2420RadioM$flushRXFIFO();
}

static  
#line 167
void CC2420RadioM$PacketSent(void)
#line 167
{
  TOS_MsgPtr pBuf;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 170
    {
      CC2420RadioM$stateRadio = CC2420RadioM$IDLE_STATE;
      pBuf = CC2420RadioM$txbufptr;
      pBuf->length = pBuf->length - MSG_HEADER_SIZE - MSG_FOOTER_SIZE;
    }
#line 174
    __nesc_atomic_end(__nesc_atomic); }

  CC2420RadioM$Send$sendDone(pBuf, SUCCESS);
}

static  
# 369 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/Transceiver/TransceiverM.nc"
result_t TransceiverM$SendRadio$sendDone(TOS_MsgPtr m, result_t result)
#line 369
{
  if (m == & TransceiverM$msg[TransceiverM$nextSendMsg].tosMsg) {
      TransceiverM$Transceiver$radioSendDone(m->type, m, result);
      TransceiverM$sendDone();
    }
  return SUCCESS;
}

static 
# 112 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
void CC2420RadioM$sendFailed(void)
#line 112
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 113
    CC2420RadioM$stateRadio = CC2420RadioM$IDLE_STATE;
#line 113
    __nesc_atomic_end(__nesc_atomic); }
  CC2420RadioM$txbufptr->length = CC2420RadioM$txbufptr->length - MSG_HEADER_SIZE - MSG_FOOTER_SIZE;
  CC2420RadioM$Send$sendDone(CC2420RadioM$txbufptr, FAIL);
}

static  
# 84 "SensorToLedsM.nc"
result_t SensorToLedsM$SensorOutput$output(uint16_t measurements[], uint16_t source, uint16_t next_addr, uint16_t dest_addr, 
uint16_t hops, uint16_t msg_type)
{
  uint16_t intVal = measurements[0];

#line 88
  if (intVal & 1) {
    SensorToLedsM$Leds$redOn();
    }
  else {
#line 91
    SensorToLedsM$Leds$redOff();
    }
  if (intVal & 2) {
    SensorToLedsM$Leds$greenOn();
    }
  else {
#line 96
    SensorToLedsM$Leds$greenOff();
    }
  if (intVal & 4) {
    SensorToLedsM$Leds$yellowOn();
    }
  else {
#line 101
    SensorToLedsM$Leds$yellowOff();
    }
  TOS_post(SensorToLedsM$outputDone);

  return SUCCESS;
}

static 
# 910 "BasicRoutingM.nc"
void BasicRoutingM$addWaveletValueToTable(uint16_t hops, uint16_t source, uint16_t measurements0, uint16_t measurements1)
{
  uint16_t lcv = 0;

#line 913
  for (lcv; lcv < BasicRoutingM$local_table[hops - 1][0][0]; lcv++) 
    {
      if (BasicRoutingM$local_table[hops - 1][lcv + 1][0] == source) 
        {
          BasicRoutingM$local_table[hops - 1][lcv + 1][1] = measurements0;
          BasicRoutingM$local_table[hops - 1][lcv + 1][2] = measurements1;
          BasicRoutingM$local_table[hops - 1][lcv + 1][3] = 1;
        }
    }
}

static 
#line 892
uint8_t BasicRoutingM$hasReceivedAllValues(void)
{
  uint8_t LCV = 0;
  uint8_t noEmptySpotsFlag = 1;

  for (LCV; LCV < BasicRoutingM$local_table[BasicRoutingM$wavelet_level - 1][0][0]; LCV++) 
    {
      if (BasicRoutingM$local_table[BasicRoutingM$wavelet_level - 1][LCV + 1][3] == 0) {
        noEmptySpotsFlag = 0;
        }
    }
#line 902
  return noEmptySpotsFlag;
}

static 
#line 958
void BasicRoutingM$calculateCoefficient(uint16_t numNeighbors, uint16_t addVal)
{
  uint16_t LCV = 0;

#line 961
  for (LCV; LCV < numNeighbors; LCV++) 
    {
      double coeff = BasicRoutingM$local_table_coeff[BasicRoutingM$wavelet_level - 1][LCV + 1];
      double value0 = BasicRoutingM$local_table[BasicRoutingM$wavelet_level - 1][LCV + 1][1];
      double value1 = BasicRoutingM$local_table[BasicRoutingM$wavelet_level - 1][LCV + 1][2];

      if (value0 > 32768) {
        value0 = value0 - 65536;
        }
#line 969
      if (value1 > 32768) {
        value1 = value1 - 65536;
        }

      if (addVal == 0) 
        {
          BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][0] = BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][0] - value0 * coeff;
          BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][1] = BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][1] - value1 * coeff;
        }
      else 
        {
          BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][0] = BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][0] + value0 * coeff;
          BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][1] = BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][1] + value1 * coeff;
        }
    }
}

static 




void BasicRoutingM$clearTable(uint16_t numNeighbors)
{
  uint16_t LCV = 0;

#line 994
  for (LCV; LCV < numNeighbors; LCV++) 
    {
      BasicRoutingM$local_table[BasicRoutingM$wavelet_level - 1][LCV + 1][1] = 0;
      BasicRoutingM$local_table[BasicRoutingM$wavelet_level - 1][LCV + 1][2] = 0;
      BasicRoutingM$local_table[BasicRoutingM$wavelet_level - 1][LCV + 1][3] = 0;
    }
}

static 
#line 855
void BasicRoutingM$startWaveletLevel(void)
{
  uint16_t led_display[5] = { 0, 0, 0, 0, 0 };
  uint16_t numNeighbors;
  uint16_t LCV;

  if (BasicRoutingM$wav_dec[TOS_LOCAL_ADDRESS] > BasicRoutingM$wavelet_level) 
    {
      numNeighbors = BasicRoutingM$local_table[BasicRoutingM$wavelet_level - 1][0][0];
      led_display[0] = BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][0];
      led_display[1] = BasicRoutingM$wav_val[TOS_LOCAL_ADDRESS][1];
      LCV = 0;

      for (LCV; LCV < numNeighbors; LCV++) 
        {
          uint16_t neighbor = BasicRoutingM$local_table[BasicRoutingM$wavelet_level - 1][LCV + 1][0];

#line 871
          BasicRoutingM$delaySendMessage(led_display, TOS_LOCAL_ADDRESS, BasicRoutingM$routing_table[TOS_LOCAL_ADDRESS][neighbor], neighbor, BasicRoutingM$wavelet_level, WAVELET_MSG);
        }

      if (numNeighbors == 0) 
        {
          if (BasicRoutingM$wavelet_level < BasicRoutingM$max_wavelet_level) 
            {
              BasicRoutingM$wavelet_level = BasicRoutingM$wavelet_level + 1;
              BasicRoutingM$startWaveletLevel();
            }
        }

      BasicRoutingM$LedOut$output(led_display, TOS_LOCAL_ADDRESS, 0, 0, 0, WAVELET_MSG);
    }
}

# 170 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer1M.nc"
void __attribute((interrupt))   __vector_12(void)
#line 170
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 171
    {
      if (HPLTimer1M$set_flag) {
          HPLTimer1M$mscale = HPLTimer1M$nextScale;
          HPLTimer1M$nextScale |= 0x8;
          * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x2E + 0x20) = HPLTimer1M$nextScale;
          * (volatile unsigned int *)(unsigned int )& * (volatile unsigned char *)(0x2A + 0x20) = HPLTimer1M$minterval;
          HPLTimer1M$set_flag = 0;
        }
    }
#line 179
    __nesc_atomic_end(__nesc_atomic); }
  HPLTimer1M$Timer1$fire();
}

static   
# 221 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLCC2420InterruptM.nc"
void HPLCC2420InterruptM$SFDCapture$captured(uint16_t time)
#line 221
{
  result_t val = SUCCESS;

  val = HPLCC2420InterruptM$SFD$captured(time);
  if (val == FAIL) {
      HPLCC2420InterruptM$SFDCapture$disableEvents();
    }
  else 
    {
      if (HPLCC2420InterruptM$SFDCapture$isOverflowPending()) {
        HPLCC2420InterruptM$SFDCapture$clearOverflow();
        }
    }
}

# 172 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/platform/micaz/HPLTimer2.nc"
void __attribute((interrupt))   __vector_9(void)
#line 172
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 173
    {
      if (HPLTimer2$set_flag) {
          HPLTimer2$nextScale |= 0x8;
          -(* (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x25 + 0x20) = HPLTimer2$nextScale);
          * (volatile unsigned char *)(unsigned int )& * (volatile unsigned char *)(0x23 + 0x20) = HPLTimer2$minterval;
          HPLTimer2$set_flag = 0;
        }
    }
#line 180
    __nesc_atomic_end(__nesc_atomic); }
  HPLTimer2$Timer2$fire();
}

static  
# 360 "C:/tinyos/cygwin/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
void CC2420RadioM$startSend(void)
#line 360
{

  if (!CC2420RadioM$HPLChipcon$cmd(0x09)) {
      CC2420RadioM$sendFailed();
      return;
    }

  if (!CC2420RadioM$HPLChipconFIFO$writeTXFIFO(CC2420RadioM$txlength + 1, (uint8_t *)CC2420RadioM$txbufptr)) {
      CC2420RadioM$sendFailed();
      return;
    }
}

static 



void CC2420RadioM$tryToSend(void)
#line 377
{
  uint8_t currentstate;

#line 379
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 379
    currentstate = CC2420RadioM$stateRadio;
#line 379
    __nesc_atomic_end(__nesc_atomic); }


  if (currentstate == CC2420RadioM$PRE_TX_STATE) {



      if (!TOSH_READ_CC_FIFO_PIN() && !TOSH_READ_CC_FIFOP_PIN()) {
          CC2420RadioM$flushRXFIFO();
        }

      if (TOSH_READ_RADIO_CCA_PIN()) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 391
            CC2420RadioM$stateRadio = CC2420RadioM$TX_STATE;
#line 391
            __nesc_atomic_end(__nesc_atomic); }
          CC2420RadioM$sendPacket();
        }
      else {



          if (CC2420RadioM$countRetry-- <= 0) {
              CC2420RadioM$flushRXFIFO();
              CC2420RadioM$countRetry = 8;
              if (!TOS_post(CC2420RadioM$startSend)) {
                CC2420RadioM$sendFailed();
                }
#line 403
              return;
            }
          if (!CC2420RadioM$setBackoffTimer(CC2420RadioM$MacBackoff$congestionBackoff(CC2420RadioM$txbufptr) * 10)) {
              CC2420RadioM$sendFailed();
            }
        }
    }
}

