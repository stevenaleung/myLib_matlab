function success

[y, fs] = audioread('success.wav');
soundsc(y, fs, [-2 2])