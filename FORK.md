# This fork (local, branch `armcc`)

A local fork of [m2c](https://github.com/matt-kempster/m2c) (GPL-3.0, like upstream) for the
matching decomp of the 3DS Pokémon games, whose code armcc built. It is run as an outside
program by `matching-decomp-tools/local/m2cref.py`, and nothing of it goes into that
repository. Its output is a reference for whoever writes the C, never a draft.

What it adds:

- **The `ctr` target** (`-t ctr`): ARM with the AAPCS-VFP calling convention (hard float):
  float arguments in `s0`-`s15` (doubles in `d0`-`d7`), named `fargN`/`dargN`, apart from the
  core registers; a float returned in `s0`. `ArmCtrArch` in `m2c/arch_arm.py`.
- **VFP, single precision**: `vadd vsub vmul vdiv vneg vabs vsqrt vnmul vmla vmls vnmla vnmls`,
  `vmov` (register, float immediate given as its bits `#0x3F800000`, core <-> VFP), `vcvt`/`vcvtr`
  between f32 and s32/u32, `vcmp`/`vcmpe` with the `vmrs APSR_nzcv, fpscr` after them (the
  flags are set at the compare; an unordered result is not modelled), conditional forms
  (`vmovgt.f32`), `vldm`/`vstm` (s and d registers, writeback). Double-precision arithmetic is
  not handled yet.
- **`ldrd`/`strd`** (split into two `ldr`/`str`, offsets and writeback kept) and
  **`uxtb uxth sxtb sxth`** (casts).
- **`M2C_UNK`** in a context file (`typedef int M2C_UNK;`): a type left to inference, so a
  prototype can say what is known and nothing more, e.g. `M2C_UNK Foo_Update(Foo *this, ...);`
  for a method whose `this` is known and whose other parameters and return are not. A return
  type of `M2C_UNK` is guessed as if no prototype were given (void included).
- A test: `tests/end_to_end/armcc-vfp/` (hand-written assembly, nothing from a game).

Run the tests with `python run_tests.py` (needs `coverage`; a `.venv` here has it).

Not done (seen in a sample of 400 functions of the game): `svc`, the SIMD byte instructions
(`sel`, `uadd8`, `uqsub8`...), `mrc`, VFP doubles, functions that never return (an assert's
call is taken as returning), a conditional branch out of the function.
