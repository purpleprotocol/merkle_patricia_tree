#[macro_use] extern crate rustler;
#[macro_use] extern crate rustler_codegen;
#[macro_use] extern crate lazy_static;

extern crate blake2;

use rustler::{NifEnv, NifTerm, NifResult, NifEncoder};
use rustler::types::binary::NifBinary;
use blake2::Blake2b;
use blake2::digest::{Input, VariableOutput};

rustler_export_nifs! {
  "Elixir.MerklePatriciaTree.Hash",
  [("_blake2", 1, blake2)],
  None
}

fn blake2<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
  let arg: NifBinary = try!(args[0].decode());
  let mut hasher = Blake2b::new(32).unwrap();
  let mut buf = [0u8; 32];
  let val = arg.as_slice();

  hasher.process(val);
  hasher.variable_result(&mut buf).unwrap();

  let mut result: Vec<u8> = Vec::with_capacity(32);

  for byte in buf.iter() {
    result.push(*byte);
  }

  Ok(result.encode(env))
}
