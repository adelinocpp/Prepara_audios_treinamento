# freeverb-matlab
jezar at dreampoint's freeverb implemented in MATLAB

had to dig around to find the original source code, which unsurprisingly is a whole lot easier to grok than any of the other impelmentations i've read!

this script performans batch reverb. change the file to whatever you want. 

yes it is very, very slow. no pointers in matlab, and matrices are getting passed in and out like crazy, performance is not the point (of this particular exercise)! 

i wanted to see how the thing works. and now it does. it is slow but does the freeverb. 

for one channel. will update to add the stereospread and do the other channel.

HOW DO I USE THIS?

you would need matlab or gnu-octave (octave is free). it needs a few more commits for stereo. the idea is you just set your file you want to reverberate in freeverb.m and set f (feedback in the comb filter section) to your desired roomsize (0.0 to 0.98), hit f5 and let'r rip. it needs some tweaking for stereo, but that is comparatively easy.
