#include "pragma_information.h"

const int DEFAULT_VALUE = -1;

options_t
DEFAULT_OPTIONS () {
  options_t def = {
    { false, DEFAULT_VALUE, DEFAULT_VALUE, false },
    false,
    DEFAULT_VALUE,
    { DEFAULT_VALUE, DEFAULT_VALUE, false, false }};
    return def;
};

