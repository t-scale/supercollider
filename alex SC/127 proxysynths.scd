(
ProxySynthDef(\ju, {
	arg sustain, amp, f2;
	var sig, fenv,fenv2, env;

	env=EnvGen.kr(Env(),timeScale:sustain,doneAction:2);
	fenv= EnvGen.kr(Env([\freq.kr, \freq.kr*4],[sustain*0.5]),timeScale:sustain);
	fenv2= EnvGen.kr(Env([f2*2, f2],[sustain*0.7]),timeScale:sustain);

	sig=BPF.ar(WhiteNoise.ar(amp)+BrownNoise.ar(amp),fenv,rq:SinOsc.kr(fenv2).range(0.001,1));
	sig=FreeVerb.ar(sig,room:2,damp:0.1,add:sig);
	sig=Pan2.ar(sig*env,SinOsc.kr(fenv));
	sig=FreeVerb.ar(sig,room:2);

	sig=sig*env*amp;

}).add;


ProxySynthDef(\zit, {
	arg  sustain,  amp, pan, hpf, noise;
	var sig, env, fenv;

	env=EnvGen.kr(Env([0,1,0],[0.1,0.3]),timeScale:sustain,doneAction:2);
	sig=LFSaw.ar(\freq.kr+fib(10).reciprocal)+GrayNoise.ar(noise);
	sig=Clip.ar(Splay.ar(sig),0.5,1);
	sig=Pan2.ar(HPF.ar(sig,hpf), pan);
	sig=sig*env*amp;

}).add;



ProxySynthDef(\rrr2, {
	arg  sustain,  amp, pan, lag;
	var sig, env, lenv, fenv;

	lenv=EnvGen.kr(Env([lag, lag+0.02, lag+0.05],[0.01,4]),timeScale:sustain);
	env=EnvGen.kr(Env([0,1,0],[0.5,2]),timeScale:sustain,doneAction:2);
	fenv=EnvGen.kr(Env([4,6,2,3]/5*\freq.kr,[4,[0.2,5,1],1].convertRhythm),timeScale:sustain,doneAction:2);

	sig=LFSaw.ar([fenv, fenv+[1,2,3,5,8].reciprocal]).lag([0.01,0.02]);
	sig=CompanderD.ar(Pan2.ar(sig,SinOsc.ar(0.25/2)));
	sig=Limiter.ar(sig,0.5);
	sig=sig*env*amp;

}).add;


ProxySynthDef(\scr, {
	arg  sustain,  amp, pan, hpf,den;
	var sig, env, fenv;

	env=EnvGen.kr(Env([0,1,0.7,1,0],[0.01,0.1,0.05,0.2]),timeScale:sustain,doneAction:2);
	sig=Impulse.ar(den).lag(0.02);
	sig=AllpassL.ar(sig,0.02,0.2);
	sig=Pan2.ar(sig,SinOsc.kr(0.1));
	sig=sig*env*amp;

}).add;



ProxySynthDef(\dust, {
	arg  sustain,  amp, pan, hpf,den;
	var sig, env, fenv;

	env=EnvGen.kr(Env([0,1,0.7,1,0],[0.01,0.1,0.05,0.2]),timeScale:sustain,doneAction:2);
	sig=Dust.ar(den+[5,12]);
	sig=CombN.ar(sig,0.5,0.15,1);
	sig=sig*env*amp;

}).add;


ProxySynthDef(\noiselong, {
	arg  sustain,  amp, pan;
	var sig, env;

	env=EnvGen.kr(Env([0,1,0],[1,0.01]),timeScale:sustain,doneAction:2);
	sig=DFM1.ar(WhiteNoise.ar(0.7),\freq.kr,fib(10));
	sig=Pan2.ar(sig,SinOsc.kr(pan));
	sig=sig*env*amp;

}).add;

ProxySynthDef(\blow, {
	arg  sustain,  amp, pan;
	var sig, env, fenv;

	env=EnvGen.kr(Env([0,1,0],[0.1,4]),timeScale:sustain,doneAction:2);
	sig=WhiteNoise.ar(LFNoise1.kr(10).range(0.01,0.1))+PinkNoise.ar(LFNoise2.kr(4).range(0.01,0.1));
	sig=BPF.ar(sig,[\freq.kr.lag(0.2),\freq.kr.lag(0.02),\freq.kr.lag(2)]+fib(10),LFNoise2.kr(200).range(0.001,0.01),5);
	sig=Limiter.ar(sig*env*amp,0.8);

}).add;


ProxySynthDef(\mel, {
	arg  sustain,  amp;
	var sig, env, fenv;

	env=EnvGen.kr(Env([0,1,0],[0.01,0.5]),timeScale:sustain,doneAction:2);
	sig=LFSaw.ar([\freq.kr,\freq.kr.lag(0.2),\freq.kr.lag(0.4)]).lag([0.02,0.04]);
	sig=sig*LFPulse.ar([3,5]);
	sig=LPF.ar(sig,1800);
	sig=sig*env*amp;

}).add;

ProxySynthDef(\vrr, {
	arg  sustain, amp, lag;
	var sig, env, fenv;

	env=EnvGen.kr(Env([0,1,0],[1,0.001]),timeScale:sustain,doneAction:2);
	fenv= EnvGen.kr(Env([\freq.kr,\freq.kr*1.2, \freq.kr*2,\freq.kr],[0.8,0.05,0.001]),timeScale:sustain);
	sig=LFSaw.ar(fenv).lag(0.4);
	sig=Pan2.ar(sig,SinOsc.kr(sustain*4));
	sig=sig*env*amp*2;

}).add;

ProxySynthDef(\strange, {
	arg  sustain,  amp;
	var sig, env, fenv;

	env=EnvGen.kr(Env([0,1,0],[0.01,0.5]),timeScale:sustain,doneAction:2);
	sig=BPF.ar(WhiteNoise.ar(0.7),LFSaw.kr([4,3]).range(\freq.kr,\freq.kr+[200,202]),Saw.kr([5,8]).range(1,0.001));
	sig=sig*env*amp*2;

}).add;

ProxySynthDef(\aural, {
	arg  sustain,  amp;
	var sig, env, fenv;

	env=EnvGen.kr(Env([0,1,0],[1,6]),timeScale:sustain,doneAction:2);
	sig=SinOsc.ar(\freq.kr+LFNoise0.ar([100,160]).range(2,40).round(2));
	sig=sig+BPF.ar(PinkNoise.ar([0.4,0.6]),\freq.kr,0.1);
	sig=sig*env*amp;

}).add;

ProxySynthDef(\tum, {
	arg  sustain,  amp, pan, rq;
	var sig, env, fenv;

	env=EnvGen.kr(Env([0,1,0],[0.01,0.9]),timeScale:sustain,doneAction:2);
	fenv= EnvGen.kr(Env([\freq.kr,\freq.kr*\top.kr(6), \freq.kr],[0.001,0.05]));
	sig=SinOsc.ar(fenv)+BPF.ar(Clip.ar(GrayNoise.ar(1,1),0.9,1), fenv,rq);
	sig=Pan2.ar(Splay.ar(sig)*env*amp, pan);

}).add;

ProxySynthDef(\bum, {
	arg  sustain,  amp, noise;
	var sig, env, fenv;

	env=EnvGen.kr(Env([0,1,0],[0.01,1]),timeScale:sustain,doneAction:2);
	fenv= EnvGen.kr(Env([\freq.kr,\freq.kr*4, \freq.kr],[0.001,0.05]));
	sig=SinOsc.ar(fenv!2+fib(10).reciprocal)+HPF.ar(GrayNoise.ar(noise!2),800);
	sig=FreeVerb.ar(sig,mix:0.3,room:1,damp:1);
	sig=Splay.ar(sig)*env*amp;

}).add;



ProxySynthDef(\dribble, {
	arg  sustain,  amp,lag,f2;
	var sig, env;

	env=EnvGen.kr(Env(),timeScale:sustain,doneAction:2);
	sig=BPF.ar(BrownNoise.ar(amp),\freq.kr+SinOsc.kr(\freq.kr*2).range(80,20),
		rq:SinOsc.kr(f2).range(0.001,0.1));
	sig=sig+Mix.fill(4,{LFSaw.ar(\freq.kr!4,mul:0.5).lag(lag).clip(-1,0.2)});
	sig=Limiter.ar(Splay.ar(sig),0.7);
	sig=FreeVerb.ar(sig,room:1.5,damp:SinOsc.kr(f2),add:sig);

	sig=sig*env*amp;
}).add;

)