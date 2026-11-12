lerp:
	vsub.f32 s1, s1, s0
	vmla.f32 s0, s1, s2
	bx lr

clamp_positive:
	vcmpe.f32 s0, #0
	vmrs APSR_nzcv, fpscr
	vmovlt.f32 s0, #0x00000000
	bx lr

scale_store:
	vldmia r1, {s0, s1, s2}
	vmul.f32 s0, s0, s3
	vmul.f32 s1, s1, s3
	vmul.f32 s2, s2, s3
	vstmia r0, {s0, s1, s2}
	bx lr

to_int:
	vldr s0, [r0, #8]
	vcvt.s32.f32 s0, s0
	vmov r0, s0
	uxth r0, r0
	bx lr

pair_copy:
	ldrd r2, r3, [r1, #4]
	strd r2, r3, [r0]
	vneg.f32 s0, s4
	vabs.f32 s1, s0
	vsqrt.f32 s0, s1
	bx lr
