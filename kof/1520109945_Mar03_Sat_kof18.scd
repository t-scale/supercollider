

p.push();
p.bpm(143.721/4.0);






// one synth ///////////////////////////////////////

(
~one.ar(2);
~one.clock = p.clock;
~one.quant=8;
~one.fadeTime=6;
~one={
  var tim = LFSaw.ar(~tempo/[1,2,[600,601,603]]).range(0,2pi);
  var perl = Perlin3.ar(tim[0],tim[1],tim[2]);
  var sig = RLPF.ar(LFSaw.ar([50,50.001],0,perl),perl.range(100,1500))*LFTri.ar(~tempo/[4,12,3]);
  sig = LeakDC.ar(sig);
  Splay.ar(sig,0.25,0.75);
};
~one.play;
);
~one.stop(4);
~one.clear;
~one.pause;
~one.resume;


// cingrlatko synth ///////////////////////////////////////

(
~cingrlatko.ar(2);
~cingrlatko.clock = p.clock;
~cingrlatko.quant=16;
~cingrlatko.fadeTime=4;
~cingrlatko={
  var sig = LFSaw.ar(~tempo/16)*BrownNoise.ar(0.1);
  Splay.ar(sig,0.5,0.25);
};
~cingrlatko.play;
);
~cingrlatko.stop(4);
~cingrlatko.clear;
~cingrlatko.pause;
~cingrlatko.resume;

(
  ~master.quant=2;
  ~master.play;
  ~master.fadeTime = 0.01;
  ~master = {|wet=0.15,lp=3500,hp=250,len=10,rev = 3|
  var sig = In.ar([0,1]);
  var orig = sig;
  var fx;
  //fx = Limiter.ar(sig,0.95);
  sig = CompanderD.ar(sig,3/4,1/1.1,1/3);
  fx = LPF.ar(sig,lp);
  fx = HPF.ar(fx,hp);
  fx = DWGReverbC1C3.ar(NumChannels.ar(fx,2),[5000,5010],1/len)/rev;
  sig = SelectX.ar(wet,[orig,fx]);
  sig = NumChannels.ar(sig,2);
  ReplaceOut.ar(0,sig);
  };
);
p.moveNodeToTail(\master);
