
// LFSaw con LFO + o - LFTri * @_yect -

(
SynthDef(\lfsaw, {
	|out, n 33, attack 0.01, decay, sustain, release 10, lfo 2, gate 1, amp 0|
	var senal, envolvente;
	senal = LFSaw.ar(LFPulse.kr(lfo, 1, 0.5, n.midicps,
		n.midicps*Array.geom(2.105, 1.0004, 1.0005)), 0, amp);
    // senal = senal + LFTri.ar(n.midicps+2, mul:0.4)!2;
	envolvente = EnvGen.kr(Env.adsr(attack, decay, sustain, release), doneAction:2);
    OffsetOut.ar(out, senal * envolvente);
}).add;
)

// El clásico LFPulse con LFO * @_yect - basado en  el 'lfsaw' -
// amp1 es una forma ñera de nivelar el gain, lo siento, ¡pero funciona!

(
SynthDef(\lfpulse, {
	|out, n 33, attack 0.01, decay, sustain, release 10, lfo 2, gate 1, amp 0, amp1 100|
	var senal, envolvente;
	senal = LFPulse.ar(LFPulse.kr(lfo, 1, 0.5, n.midicps, n.midicps/2), 0, 0.4, amp*amp1);
    //senal = senal + LFTri.ar(n.midicps+2, mul:0.4)!2;
	envolvente = EnvGen.kr(Env.adsr(attack, decay, sustain, release), doneAction:2);
    OffsetOut.ar(out, senal * envolvente);
}).add;
)

// SinOsc + LFPulse con una rara especie de drywet en el LFPulse * @_yect -

(
SynthDef(\sinosc, {
	|out, n 33, attack, release, amp, drywet|
	var senal, envolvente;
	senal = SinOsc.ar(n.midicps, 0, 0.5, amp);
    senal = senal + LFPulse.ar(n.midicps*drywet, mul:0.1)!2;
	envolvente = EnvGen.kr(Env.perc(attack, release), doneAction:2);
	OffsetOut.ar(out, senal * envolvente);
}).add;
)

// SynthDef "organ" * Juan A. Romero, @rukano -

(
SynthDef(\organ, { |out, n=33, amp=0.1, gate=1, attack, release, feedback=0.5|
    var snd;
	h = SinOsc;
	snd = Splay.ar(h.ar(n.midicps*Array.geom(4,1,2), feedback, mul:0.3));
    snd = snd + LFNoise2.ar(n/2, mul:0.1)!2;
    snd = snd * EnvGen.ar(Env.perc(attack, release), gate, doneAction:2);
    OffsetOut.ar(out, snd * amp*1.25);
}).add;
)

// SynthDef \lead * Juan A. Romero, @rukano -

(
SynthDef(\lead, { |out, n=0, amp=0.1, gate=1, bps=2, attack, release, sustain|
    var snd;
    var seq = Demand.kr(Impulse.kr(bps*4), 0, Dseq(n.midicps*[1,3,2], inf)).lag(0.01);
    snd = LFSaw.ar(n.midicps*{rrand(0.995, 1.005)}!4);
    snd = Splay.ar(snd);
    snd = MoogFF.ar(snd, seq, 0.5);
    snd = snd * EnvGen.ar(Env.asr(attack, sustain, release), gate, doneAction:2);
    OffsetOut.ar(out, snd * amp);
}).add;
)

// SynthDef  \moog * Thor Magnusson @thormagnusson para ixiLang -

(
SynthDef(\moog, {arg out=0, n=33, amp=0.3, sustain=0.3, gate=1, lfo, attack, decay, release, pan=0;
	var signal;
	var env = EnvGen.kr(Env.adsr(attack, decay, amp*0.8, release), gate, doneAction:2);
	signal = MoogFF.ar(Saw.ar([n.midicps, n.midicps+2], 1), lfo*n.midicps, 3.3) * env;
	Out.ar(out, Balance2.ar(signal[0], signal[1], pan));
}).add;
)

// SynthDef \acidbass * Juan A. Romero @rukano -

(
SynthDef("acidbass", {|out=0, gate=1, n=31, amp=0.1, pan=0, decay, attack=0.01, release=0.8|
	var env1, env2, son, pitch;
	pitch = n;
	pitch = Lag.kr(pitch, 0.4 * (1-Trig.kr(gate, 0.001)) * gate);
	env1 = EnvGen.ar(Env.new([0, 1.0, 0, 0], [0.001, 2, 0.04], [0, -4, -4], 2), gate, amp);
	env2 = EnvGen.ar(Env.adsr(attack, decay, 0, release, 75, -2), gate, doneAction:2);
	son = LFPulse.ar(pitch.midicps, 0.0, 0.41, 2, -1);
	son = RLPF.ar(son, (pitch + env2).midicps, 1);
	son = son * env1;
	OffsetOut.ar(out, Pan2.ar(son, pan));
}).add;
)
