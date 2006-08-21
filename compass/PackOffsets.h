/**
 * Various data offsets and sizes in network packets.
 * @author Ryan Stinnett
 */

#ifndef _PACKOFFSETS_H
#define _PACKOFFSETS_H

enum {
  MSG_DATA_OFFSET = 5
};

enum {
  TOTAL_PACK_LENGTH = 29,
  UPACK_MSG_OFFSET = 1,
  UPACK_DATA_LEN = TOTAL_PACK_LENGTH - UPACK_MSG_OFFSET,
  UPACK_MSG_DATA_LEN = UPACK_DATA_LEN - MSG_DATA_OFFSET
};

#endif // _PACKOFFSETS_H
