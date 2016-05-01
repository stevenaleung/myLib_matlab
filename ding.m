function playDing()

[y, fs] = audioread('ding.wav');
soundsc(y, fs, [-10 10]);