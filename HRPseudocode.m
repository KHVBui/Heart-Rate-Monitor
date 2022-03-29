%Pseudocode based on heart rate project experience using LabVIEW in BME60A.

%1)Initialize the Arduino
%2)Tell the Arduino to set a digital pin to Output

%3)Create large while loop that will contain the main HR code
%4)In the while loop, call a function that takes in the analog input
%pin, the sampling frequency, and the samples read per loop, and outputs
%waveform information, such as dt and the signal values
%5)Graph the raw signal data over time

%6)Use a function to normalize and filter the signal with a moving average filter
%7)Graph the normalized and filtered signal

%8)Use a function to find the best linear fit of the signal, and subtract
%it from the filtered signal to obtain the detrended signal
%9)Graph the detrended signal

%10)Find the arithmetic mean of the signal, and subtract it from the signal
%11)Use a function to find the autocorrelation data from the signal
%12)Divide the autocorrelation data in half and take a subarray containing
%only the right side of the autocorrelation data
%13)Graph the right-side autocorrelation data

%14)Use a peak detecting function to find the peak locations and amplitudes
%of the right-side autocorrelation data, according to a certain threshold
%and width

%15)If there aren't at least 2 peaks, do not display a heart rate
%16)If the peaks don't successively go smaller in amplitude, don't display
%a heart rate
%17)Divide the 2nd peak's location by 2 and divide it by the 1st peak's
%location. If the resulting number is not within a certain threshold, don't
%display a heart rate.

%If conditions allow a heart rate to be displayed, take the 1st peak's
%location, multiply it by dt, take the inverse, then multiply that by 60 to
%acquire the heart rate.

%Output data from the overall runs to an external file to allow past data
%to be viewed.

%Turn off pins and close connection to Arduino