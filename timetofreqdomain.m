function [fftvector,freqvector] = timetofreqdomain(signalvector,timevector)
%Take in a signal vector in mV and a time vector in seconds
%Make the fast fourier transform of the signal vector
%Output the magnitude of the fft 
%and the frequency vector based on the Nyquist frequency

%Find magnitude of the fft of the signal vector, and shift so f=0 at center.
fftvector = fftshift(abs(fft(signalvector))); 

%Now build the frequency vector based on the timevector to plot the fft
N = length(fftvector); %The size of the FFT vector
dt = (timevector(end)-timevector(1))/(N-1); 
f_samp = 1/dt; %Sampling frequency
f_nyq = f_samp/2; %Nyquist frequency
df = f_nyq/(N/2);

halfpoint = N/2; %Divides the size of the FFT vector by 2
oddoreven = halfpoint == int32(halfpoint); %Detects whether the FFT vector is odd or even

%Frequency vector will depend on whether the signal vector is odd or even
if oddoreven == 0
    freqvector = linspace(-f_nyq,f_nyq,N); %Case odd
else
    freqvector = (-f_nyq:df:f_nyq-df); %Case even
end
end

