(
Ndef(\heavyMetal).fadeTime = 2.0;
Ndef(\heavyMetal,{
	var f,sig;
	f = ([67,63-12,65,69,71]-12).midicps / 0.5pi;
	sig = Gendy1.ar(0.5,0.5,minfreq:f,maxfreq:f*2,initCPs:SinOsc.kr([0.03,0.04]).range(4,110)) * LFSaw.ar(1/4/[4,1]).squared;

	Splay.ar(
		(sig + LFPar.ar(f,mul:0.5) * Decay.ar(Impulse.ar(4/[1,2,5,8,13,21]),1.75)) +
		HPF.ar((WhiteNoise.ar(0.75!4) * Decay.ar(Impulse.ar(8/[1,2,5,8,13,21]),0.1)),12000)
	)
}).play;


Ndef(\heavyMetal)[1] = \filter -> {|in| Pan2.ar(in,SinOsc.kr(0.3).range(-0.5,0.5))};
Ndef(\heavyMetal)[2] = \filter -> {|in| CombN.ar(in,2,0.333,2,0.5,in)};
Ndef(\heavyMetal)[3] = \filter -> {|in| FreeVerb.ar(in,0.33,2,0.5,1,in)};


)