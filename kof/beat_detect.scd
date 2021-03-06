

Kolektiv(\kof)

(
    p=ProxySpace.push(s.reboot);
    p.makeTempoClock;
);


(
    p.clock.tempo_(60/60);

    ~offset = (0..7)/8;

    ~tick.quant = 1;
    ~tick = {Mix(Impulse.kr( ~tempo / 2 , ~offset ))};

    ~counter = {PulseCount.kr(~tick.kr)};
);


s.scope;
// bpm synth ///////////////////////////////////////

(
    ~bpm.kr(1);
    ~bpm.quant=2;
    ~bpm.fadeTime=0.2;
    ~bpm={
        //         |       |       |       |       |  
        var z = Buffer.alloc(s, 512);
        var sig = Mix.ar(AudioIn.ar([1,2]));
        var chain = FFT(z,sig);
        var imp = PulseDivider.kr(Onsets.kr(chain, 0.33 , \rcomplex), 4);
        var env = EnvGen.ar(Env([0.001,1],[0.002,0.5],[3,1],curve:'exp'),imp);


        imp;
    };
);
~bpm.stop(7);
~bpm.clear;

// cklick synth ///////////////////////////////////////

(
~cklick.ar(2);
~cklick.quant=2;
~cklick.fadeTime=0.2;
~cklick={
  //         |       |       |       |       |  
  var pat = [1,1,1,1].rotate(1);
  var imp = ~bpm.kr;
  var hit = Select.kr(PulseCount.kr(imp)%pat.size,pat);
  var env = EnvGen.ar(Env([0.001,1,0.0001],[0.002,1.5],[3,-3],curve:'exp'),imp * hit);
  var sig = SinOsc.ar(50!2+(env**50*500));
  sig = sig * env;
  Splay.ar(sig,0.75,0.95);
};
~cklick.play;
);
~cklick.stop(4);
~cklick.clear;
~cklick.pause;
~cklick.resume;


// ff filter ///////////////////////////////////////

(
    ~ff.quant=1;
    ~ff.fadeTime=1;
    ~ff={
        var high,mid,low;
        var sig = ~bpm;

        sig = GVerb.ar(LPF.ar(sig,5000)+HPF.ar(sig,500),40,[3,4,5,6],spread:[40,90])/8 + sig;
        low = CompanderD.ar(LPF.ar(sig,400),3/4,1/2,1/2);
        mid = CompanderD.ar(BPF.ar(sig,600,2),3/4,1/2,1/2);
        high = CompanderD.ar(HPF.ar(sig,900),3/4,1/2,1/2);
        sig = CompanderD.ar((high+mid+low).flat,3/4,1/1.1,1/1.1);
        Splay.ar(sig,0.75,0.25);
    };
    ~ff.play;
);
~ff.stop(7);
~ff.clear;
