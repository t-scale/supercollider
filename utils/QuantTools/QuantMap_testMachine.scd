s.reboot;
p = ProxySpace.push(s).makeTempoClock;

~test = NodeProxy.audio(s, 2)
~test.play
~test.fadeTime = 0;
~test[0] = {|freq = 80, fplus = 0, amp = 0.2| SinOsc.ar((freq + fplus)!2 , mul:amp) }
~test[1] = \qmap -> { QuantNode(\amp, 1).env([0,1,0.2],[0.05, 1.95]) }
~test[2] = \qmap -> { QuantNode(\fplus, 8).env([0,10,0],[8.05, 1.95]) }
~test[19] = \qmap -> { QuantNode(\freq, 0.5).env([20,170,80],[0.005, 0.09]) }

~test.scope
QuantMap.print

~test.unmap(\amp)
~test.stop
