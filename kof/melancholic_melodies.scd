
(
    p=ProxySpace.push(s.reboot);
    e=ProxySubmix.new(\filter);
);

// varnam synth ///////////////////////////////////////



(
    z = Tdef(\asd,{

        loop{
            ~arcitune.quant=2;
            ~arcitune.fadeTime=0.02;
            ~arcitune = {Select.kr({ExpRand(1.0001,6)}!8,[1,2,1.25,1.5,1/2,1,1/4])};
            ~arcitune.mold(8);

            ~notes.quant=2;
            ~notes.fadeTime=0.02;
            ~notes = {Select.kr({ExpRand(1.0001,3.1)}!3,[60,55,67,58].midicps)};
            ~notes.mold(3);


            ~varnam.quant=2;
            ~varnam.fadeTime=3;
            ~varnam={
                var mld = [1,2,1.5,1.25,4,8,16] * ~arcitune.kr;
                var puls = Decay.ar(Impulse.ar(1,(0..3)+[0.5,0.25]/4),0.85);
                var sig = LFSaw.ar((~notes.kr)*4/0.5pi/(mld)*[1,1.5,1,1.25,1,1.125]+(puls.range(0,2)**2.0),mul:{ExpRand(0.01,0.5)}!8);
                sig = RLPF.ar(sig,1400*LFTri.ar(1/4/fib(8)).exprange(0.001,1)+100);
                sig = sig * puls.range(0,1);
                sig = sig + (HPF.ar(WhiteNoise.ar(0.01!2),{ExpRand(1000.01,18000)}!8) * EnvGen.ar(Env([0,1,0],[0.002,0.24],[3,-3]),Impulse.ar(1/4,[1,2,3]/16)));
                sig = AllpassN.ar(sig,1,1/2/(1..8),[2,3])+sig;
                sig = GVerb.ar(sig,[4,5]*2)/4+sig;
                sig = CompanderD.ar(sig,4/3,1/2,1/2)/2+sig;
                Splay.ar(sig.flat,0.25,0.5);
            };
            ~varnam.play;

            8.wait;
        };

    });

    z.play;

);
~varnam.stop(7);
