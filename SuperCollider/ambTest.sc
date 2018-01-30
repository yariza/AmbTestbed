s.boot;

{Out.ar(0, [0, 0, SinOsc.ar(440), 0])}.play

a = {Pan4.ar(SinOsc.ar(440, 0, 0.2))}.scope(4);
(
var decoder = FoaDecoderMatrix.newQuad;
var encoder = FoaEncoderMatrix.newOmni;
var sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Pampin-On_Space.wav");
decoder.dirChannels.raddeg.postln;
a = {
	var out, src, sndbu;
	var fl, fr, bl, br;
	src = SinOsc.ar(SinOsc.ar(1.0, 0, 500, 400), 0);
	src = FoaTransform.ar(src, 'zoom', MouseY.kr(0,pi/2), MouseX.kr(pi,-pi), 0);
	out = FoaDecode.ar(src, decoder);
	#fl, bl, br, fr = out;
	Out.ar(0, [fl, fr, bl, br]);
}.scope(4)
)

(
var cond, encoder, decoder, sndbuf, synth;

// boot the server
s.boot;

// wait for the server to boot
cond = Condition.new;
s.waitForBoot({

    Routine.run({

        // define an HRTF decoder
		decoder = FoaDecoderMatrix.newQuad;

        // load a b-format sound file into a buffer
        sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Pampin-On_Space.wav");


        s.sync(cond);

        // synth to encode a UHJ file and decode using an HRTF
        SynthDef(\kernelEncodeDecode, {arg buffer;
            var out, src;

            // our stereo source signal
            src = PlayBuf.ar(sndbuf.numChannels, buffer, BufRateScale.kr(buffer));

			// src = FoaTransform.ar(src, 'zoomX', MouseY.kr(0, pi/2));
			src = FoaTransform.ar(src, 'focus', MouseY.kr(0,pi/2), MouseX.kr(pi/2,-pi/2), 0);

            //  decode using an HRTF decoder
            out = FoaDecode.ar(src, decoder);

            Out.ar(0, out);
        }).add;

        s.sync(cond);

        // play the synth
		synth = Synth(\kernelEncodeDecode, [\buffer, sndbuf]);
		s.scope;

        // press command period when done
        CmdPeriod.doOnce({
            synth.free;
            encoder.free;
            decoder.free;
            sndbuf.free});
    })
})
)