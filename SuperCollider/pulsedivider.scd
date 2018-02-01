(a = {
        var sig = Saw.ar(MouseX.kr(50, 1000, \exponential, 0.1) * [1, 1.003]).sum * 0.1,
        trig = Dust.ar(MouseY.kr(2, 20, \exponential, 0.1)),
        trigSplit = PulseDivider.ar(trig, 2, [0, 1]),
        delaytimes = Lag.ar(TRand.ar(0.005, 0.05, trigSplit), 0.07);
        sig = LPF.ar(sig, 9000);
        sig = sig + DelayL.ar(sig, 0.05, delaytimes);
        sig
}.play;
)

a.free;
