#include "ruby.h"
#include "extconf.h"
#include "geohash.h"
#include <stdio.h>

void Init_geohash_wrapper();
VALUE wrap_geohash_encode(VALUE self, VALUE lat, VALUE lng, VALUE precision);
VALUE wrap_geohash_decode(VALUE self, VALUE hash);
VALUE wrap_geohash_neighbours(VALUE self, VALUE hash);
VALUE wrap_geohash_neighbour(VALUE self, VALUE hash, VALUE direction);
VALUE wrap_geohash_dimensions_for_precision(VALUE self, VALUE precision);


void Init_geohash_wrapper()
{
  VALUE Geohash;
  Geohash = rb_define_class("Geohash", rb_cObject);

  rb_define_singleton_method(Geohash, "encode",                   wrap_geohash_encode, 3);
  rb_define_singleton_method(Geohash, "wrap_decode",              wrap_geohash_decode, 1);
  rb_define_singleton_method(Geohash, "neighbours",               wrap_geohash_neighbours, 1);
  rb_define_singleton_method(Geohash, "neighbour",                wrap_geohash_neighbour, 2);
  rb_define_singleton_method(Geohash, "dimensions_for_precision", wrap_geohash_dimensions_for_precision, 1);
}

VALUE wrap_geohash_encode(VALUE self, VALUE lat, VALUE lng, VALUE precision) {
  return rb_str_new_cstr(geohash_encode(NUM2DBL(lat), NUM2DBL(lng), NUM2INT(precision)));
}

VALUE wrap_geohash_decode(VALUE self, VALUE hash) {
  GeoCoord decode;
  VALUE r_hash      = rb_hash_new();
  VALUE r_dimension = rb_hash_new();

  decode = geohash_decode(StringValueCStr(hash));

  rb_hash_aset(r_dimension, rb_str_new2("height"), DBL2NUM(decode.dimension.height));
  rb_hash_aset(r_dimension, rb_str_new2("width"),  DBL2NUM(decode.dimension.width));

  rb_hash_aset(r_hash, rb_str_new2("latitude"),  DBL2NUM(decode.latitude));
  rb_hash_aset(r_hash, rb_str_new2("longitude"), DBL2NUM(decode.longitude));
  rb_hash_aset(r_hash, rb_str_new2("north"),     DBL2NUM(decode.north));
  rb_hash_aset(r_hash, rb_str_new2("south"),     DBL2NUM(decode.south));
  rb_hash_aset(r_hash, rb_str_new2("east"),      DBL2NUM(decode.east));
  rb_hash_aset(r_hash, rb_str_new2("west"),      DBL2NUM(decode.west));
  rb_hash_aset(r_hash, rb_str_new2("dimension"), r_dimension);

  return r_hash;
}

VALUE wrap_geohash_neighbours(VALUE self, VALUE hash) {
  char** hashed_neighbours = geohash_neighbors(StringValueCStr(hash));
  VALUE neighbours = rb_ary_new2(8);
  int i;

  for (i = 0; i <= 7; i++) {
    rb_ary_store(neighbours, i, rb_str_new_cstr(hashed_neighbours[i]));
  }
  return neighbours;
}

VALUE wrap_geohash_neighbour(VALUE self, VALUE hash, VALUE direction) {
  return rb_str_new_cstr(get_neighbor(StringValueCStr(hash), NUM2INT(direction)));
}

VALUE wrap_geohash_dimensions_for_precision(VALUE self, VALUE precision) {
  GeoBoxDimension dimension;
  VALUE r_hash = rb_hash_new();

  dimension = geohash_dimensions_for_precision(NUM2INT(precision));

  rb_hash_aset(r_hash, rb_str_new2("height"), DBL2NUM(dimension.height));
  rb_hash_aset(r_hash, rb_str_new2("width"),  DBL2NUM(dimension.width));

  return r_hash;
}
