(
{
    // 10 voices of a random sine percussion sound :
s = Mix.ar(Array.fill(10, { Resonz.ar(Dust.ar(0.2, 50), 200 + 3000.0.rand, 0.003)}) );
    // reverb predelay time :
z = DelayN.ar(s, 0.048);
    // 7 length modulated comb delays in parallel :
y = Mix.ar(Array.fill(7,{ CombL.ar(z, 0.1, LFNoise1.kr(0.1.rand, 0.04, 0.05), 15) }));
    // two parallel chains of 4 allpass delays (8 total) :
4.do({ y = AllpassN.ar(y, 0.050, [0.050.rand, 0.050.rand], 1) });
    // add original sound to reverb and play it :
s+(0.2*y)
}.play )

// 2 synthdefs - the 1st to make grains and the 2nd to delay them

// the synthdef that makes the grains is on the left channel
// the synthdef that delays the grains is on the right channel
(
SynthDef("someGrains", { arg centerFreq = 777, freqDev = 200, grainFreq = 2;
    var gate;
    gate = Impulse.kr(grainFreq);
    Out.ar(
        0,
        SinOsc.ar(
            LFNoise0.kr(4, freqDev, centerFreq),
            0,
            EnvGen.kr(Env.sine(0.1), gate, 0.1)
        )
    )
}).add;

SynthDef("aDelay", { arg delay = 0.25;
    Out.ar(
        1,
        DelayN.ar(
            In.ar(0, 1),
            delay,
            delay
        )
    )
}).add;
)

////////////////////////////////////////////////
// test the grains ... and then turn them off
// ... they're all on the left channel ... good!
Synth("someGrains");
////////////////////////////////////////////////

// make 2 groups, the 1st for sources and the 2nd for effects
(
~source = Group.head(s);
~effects = Group.tail(s);
)

// place grains into the delay ... source is on the left and delayed source is on the right
(
Synth.head(~source, "someGrains");
Synth.head(~effects, "aDelay");
)