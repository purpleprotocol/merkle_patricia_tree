#[macro_use] extern crate rustler;
#[macro_use] extern crate rustler_codegen;
#[macro_use] extern crate lazy_static;

extern crate blake2;

use rustler::{NifEnv, NifTerm, NifResult, NifEncoder};
use rustler::types::binary::NifBinary;
use blake2::{Blake2s, Digest};
rustler_export_nifs! {
  "Elixir.MerklePatriciaTree.Hash",
  [("_blake2", 1, blake2)],
  None
}

fn blake2<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
  let arg: NifBinary = try!(args[0].decode());
  let mut hasher = Blake2s::new();

  hasher.input(arg.as_slice());
  let output = hasher.result();

  Ok(output.encode(env))
}
