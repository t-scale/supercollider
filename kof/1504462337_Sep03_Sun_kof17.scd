p.push();
p.clear;
s.reboot();
(
    OSCdef(\arrayIn, {| msg |
        b = Buffer.loadCollection(s,Array.newFrom([] ++ msg.remove(0)),1);
    }, '/array');
)



// player synth ///////////////////////////////////////

(
    ~sampl.ar(2);
    ~sampl.quant=2;
    ~sampl.fadeTime=2.02;
    ~sampl={
        var mod = 1;//[-1,0.25,-0.25,1/8,1/16];
        var spread = 0.0;
        var pos = [0,0.5];
        //         |       |       |       |       |  
        var pat = [1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0].rotate(1);
        var imp = PulseDivider.kr(~tick.kr,1,~counter.kr);
        var hit = Select.kr(PulseCount.kr(imp)%pat.size,pat);
  var env = EnvGen.ar(Env([0.001,1,0.001],[0.002,0.5],[3,-3],curve:'exp'),imp * hit);
        var sig = PlayBuf.ar(b.numChannels,b.bufnum,BufRateScale.kr(b.bufnum)*mod+(env*0.01),imp, (pos + BrownNoise.ar(1!8).range(spread * -1,spread)) * BufFrames.kr(b.bufnum),1);
        
  sig = sig * env;
        Splay.ar(sig.flat,0.5,0.5);
    };
    ~sampl.play;
);
~sampl.stop(7);
~sampl.clear;
