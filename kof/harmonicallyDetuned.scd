

p.push();

(
    ~master.quant=2;
    ~master.play;
    ~master.fadeTime = 0.01;
    ~master = {|wet=0.5,lp=2500,hp=100,len=8,rev = 1.5|
        var sig = In.ar([0,1]);
        var orig = sig;
        var fx;
        //fx = Limiter.ar(sig,0.95);
        sig = Compander.ar([]++LPF.ar(sig,500)++HPF.ar(50),3/4,1/1.1,1/3);
        fx = LPF.ar(sig,lp);
        fx = HPF.ar(fx,hp);
        fx = DWGReverb.ar(NumChannels.ar(fx,2),[5000,5010],1/len)/rev;
        sig = SelectX.ar(wet,[orig,fx]);
        sig = NumChannels.ar(sig,2);
        ReplaceOut.ar(0,sig);
    };
);
p.moveNodeToTail(\master);

(
    p.clock.sched(p.clock.timeToNextBeat(1 * 16),{ 

        p.bpm(120);
    });
);

(
    s.latency=0.4;
    //p.clock.tempo_(120/60);
    p.arProxyNames.do({|synth| if(synth.asSymbol!=\master){p[synth.asSymbol].rebuild;};});
    ~tick.kr(1);
    ~tick.clock = p.clock;
    ~tick.quant = 16;
    ~counter.clock = p.clock;
    ~counter.quant = 16;
    ~counter = {PulseCount.kr(~tick.kr);};
    ~tick = { Impulse.kr( ~tempo * 4 ); };
);

// sineperl synth ///////////////////////////////////////

(
    ~idiom.ar(2);
    ~idiom.clock = p.clock;
    ~idiom.quant=2;
    ~idiom.fadeTime=2;
    ~idiom={|x=1,y=1,z=1|
        var sm = 50;
        var x = x.lag(1/sm);
        var y = y.lag(1/sm);
        var z = z.lag(1/sm);
        var mod2 = TChoose.kr(Impulse.kr(1/64/(1..8)),[1,2]).lag(16);
        var mod = TChoose.kr(Impulse.kr(1/64/(1..8)),[1,2,4/3,3/2,1,1,1]).lag(16);
        var f = TChoose.kr(Impulse.kr(1/64/(1..8)),([60,48,72,36] +.x [0,4,7]).midicps).lag(16) / mod / mod2;
        var carriage = SinOsc.ar([f,1/f/16/((1..8)**2),1/16/f],SinOsc.kr(f/[10.001,10.0010333] /.x [1,100])/8 + ([x,y,z]/256*8pi),mul:1/(1..8)) * LFTri.ar(f/100000,mul:4) + LFDNoise1.kr(1/4000!8) + ([x,y,z]/10);
        var perlin = Perlin3.ar(carriage[0],carriage[1],carriage[2]) * carriage;
        var sig;

        sig = Resonz.ar(perlin,f*[1,2,4,1.5,1/2],0.02);
        sig = Normalizer.ar(LeakDC.ar(perlin))/8 * (LFTri.ar(1/64/(1..8))**1.2);
        sig = LPF.ar(sig,2500);
        sig = CompanderD.ar(sig,3/4,1/2,1);
        sig = Vibrato.ar(sig,[3,4,5,6],0.02);
        Splay.ar(sig,0.85,0.15);
    };
    ~idiom.play;
);
~idiom.stop(4);
~idiom.clear;
~idiom.pause;
~idiom.resume;



(
    //////////////////////////  FADE -> OUT ///////////////////////////////////////////////////////
    {
        p.arProxyNames.do({|synth| if(synth.asSymbol!=\master){p[synth.asSymbol].clear(60);};});
    }.fork;  
)
