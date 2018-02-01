
(

s = Server.internal;

Server.default = s;

s.boot;

)

s.sendMsg(\b_allocRead, 10, "sounds/a11wlk01.wav");


(

{

	var b = 10, trate, dur, rate;

	trate = MouseY.kr(2,200,1);

	dur = 4 / trate;

	rate = Dseq([10, 1, 1, 0.5, 0.5, 0.2, 0.1], inf);

	TGrains.ar(2, Impulse.ar(trate), b, rate, MouseX.kr(0,BufDur.kr(b)), dur, Dseq([-1, 1], inf), 0.1, 2);

}.scope(zoom: 4);

)

(

{

	var b = 10, trate, dur, clk, pos, pan;

	trate = MouseY.kr(8,120,1);

	dur = 12 / trate;

	clk = Impulse.kr(trate);

	pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);

	pan = WhiteNoise.kr(0.6);

	TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);

}.scope(4, zoom: 4);

)