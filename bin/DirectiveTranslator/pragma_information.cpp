#include <cassert>
#include <cstdlib>
#include <sstream>
#include <cstring>

#include "pragma_information.h"

#define CHECK(def,first,second,key)             \
  {                                             \
    if (res -> key == second -> key)            \
      res -> key = first -> key;                \
    else                                        \
      res -> key = second -> key;               \
  }

extern "C" options_t default_options ()
{
  options_t o = {{false,(align_t)-1,(temp_t)-1,false},false,-1,{-1,-1,false,false}};
  return o;
}

extern "C" options_t* default_options_ptr ()
{
  options_t* o = (options_t*)malloc(sizeof(options_t));
  *o = default_options();
  return o;
}

extern "C" options_t* merge_options (options_t* first, options_t* second)
{
  options_t* res = default_options_ptr();

  CHECK(res, first, second, vector.always);
  CHECK(res, first, second, vector.align_value);
  CHECK(res, first, second, vector.temp_value);
  CHECK(res, first, second, vector.novector);
  CHECK(res, first, second, ignoreDep);
  CHECK(res, first, second, vsize);
  CHECK(res, first, second, loop.dist);
  CHECK(res, first, second, loop.nofusion);

  bool unroll = false;
  if (res->loop.unroll == first->loop.unroll ||
      res->loop.unroll != second->loop.unroll)
  {
    unroll = (res->loop.unroll != second->loop.unroll);
    res->loop.unroll = second->loop.unroll;
  }
  else
  {
    unroll = (res->loop.unroll == first->loop.unroll);
    res->loop.unroll = first->loop.unroll;
  }

  bool jam = false;
  if (res->loop.jam == first->loop.jam ||
      res->loop.jam != second->loop.jam)
  {
    jam = (res->loop.jam != second->loop.jam);
    res->loop.jam = second->loop.jam;
  }
  else
  {
    jam = (res->loop.jam == first->loop.jam);
    res->loop.jam = first->loop.jam;
  }
  
  if (unroll && jam)
  {
    if (second->loop.jam == res->loop.jam)
      res->loop.unroll = DEFAULT_VALUE;
    else
      res->loop.jam = DEFAULT_VALUE;
  }
  
  return res;
}

extern "C" options_t* merge_options_free (options_t* first, options_t* second)
{
  options_t* res = merge_options(first, second);
  free (first);
  free (second);
  first = second = NULL;
  return res;
}

extern "C" char* print_options (options_t* options)
{
  std::ostringstream out;
  if (!options->vector.novector) {
    if (options->vector.always)
    {
      out << "#pragma vector always\n";
    }
    switch (options->vector.align_value)
    {
    case ALIGNED_:
      out << "#pragma vector aligned\n";
      break;
    case UNALIGNED_:
      out << "#pragma vector unaligned\n";
      break;
    default:
      break;
    }
    switch (options->vector.temp_value)
    {
    case NONTEMP_:
      out << "#pragma vector nontemporal\n";
      break;
    case TEMP_:
      out << "#pragma vector temporal\n";
      break;
    default:
      break;
    }
    if (options->ignoreDep)
    {
      out << "#pragma ivdep\n";
    }
    if (options->vsize != DEFAULT_VALUE && options->vsize != ERROR_VALUE)
    {
      int x = options->vsize;
      assert (!(x & (x - 1)) && x); // ensures power of 2
      out << "#pragma simd vectorlength(" << options->vsize << ")\n";
    }
  }
  else
  {
    out << "#pragma novector\n";
  }
  if (options->loop.jam != DEFAULT_VALUE && options->vsize != ERROR_VALUE)
  {
    if (options->loop.jam > 0)
      out << "#pragma unroll_and_jam(" << options->loop.jam << ")\n";
    else
      out << "#pragma unroll_and_jam\n";
  }
  else if (options->loop.unroll != DEFAULT_VALUE && options->loop.unroll != ERROR_VALUE)
  {
    if (options->loop.unroll > 0)
      out << "#pragma unroll(" << options->loop.unroll << ")\n";
    else
      out << "#pragma unroll\n";
  }
  if (options->loop.dist)
  {
    out << "#pragma distribute_point\n";
  }
  if (options->loop.nofusion)
  {
    out << "#pragma nofusion\n";
  }
  return strdup (out.str().c_str());
}
