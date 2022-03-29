function [dt,f_samp,timevector] = signaltime(timezero,signalsize,looptime)
%Takes in the initial time, the sample size of the signal each acquisition, and the time it
%took to acquire the signal

dt = (looptime-timezero)/(signalsize-1); %Time between samples in seconds
f_samp = 1/dt; %The sampling frequency in Hz or samples/second
timeend = ((signalsize-1)*dt) + timezero; %in seconds
timevector = (timezero:dt:timeend); %The time vector in seconds

end

