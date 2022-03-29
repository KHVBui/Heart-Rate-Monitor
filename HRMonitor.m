clear %Clears variables so arduino can run properly.

HRVariables; %Loads in variables to the workspace. Does preallocate rawsignalvector, looptime, HeartBPM, and BPMtime

%%
a = arduino('com5','uno'); %Initialize Arduino. You should change COM number if different computer.
writeDigitalPin(a,'D2',1); %Turn LED on

%%
save('HeartbeatData.mat','BPMtime','HeartBPM') %Creates/overwrites file for heartrate data
%^Name of file can be changed to create different data file. Make sure to
%change name below at the end of the code.

%%
for counter = 1:(Maxcounter)
    t0 = clock; %Start timing the signal acquisition
    
    for i = signalsizevector
        rawsignalvector(i) = readVoltage(a,'A0'); %Reads in voltages into the raw signal vector
    end

    looptime(counter) = etime(clock,t0); %The time it takes to acqure the signal with indices defined by samplesize. Creates a vector of these values.
    
    %%
    [dt,f_samp,timevector] = signaltime(timezero,signalsize,looptime(counter)); %Variables for the time vector defined. Varies each loop.
    
    %%
    figure(1)
    plot(timevector,rawsignalvector); %Plots raw signal vs. time
    axis([0,looptime(counter),-inf,inf]);
    title('Raw Signal vs. Time');
    xlabel('Time(s)')
    ylabel('Signal(mV)')
    drawnow
    
    %%
    [curvefit,curvefitindex] = BestCurveFit(maxdegree,signalsizevector,rawsignalvector); %Finds the best fitting curve out of a number of curvefits according to maxdegree
    detrendsignal = rawsignalvector - curvefit{1,curvefitindex}; %Takes the best fitting curve to detrend and center raw signal around 0
    
    figure(2)
    plot(timevector,detrendsignal); %Plots the detrended signal vs. time
    axis([0,looptime(counter),-inf,inf]);
    title('Detrended Signal vs. Time');
    xlabel('Time(s)')
    ylabel('Signal(mV)')
    drawnow
    
    %%
    [detrendfftvector,detrendfreqvector] = timetofreqdomain(detrendsignal,timevector); %Takes the FFT of the detrended signal
    
    figure(3)
    plot(detrendfreqvector,detrendfftvector); %Plots the magnitude of the FFT of the detrended signal vs. frequency
    axis([-5,5,0,inf]);
    title('Detrended FFT Signal vs. Frequency');
    xlabel('Frequency(Hz)')
    ylabel('Magnitude of FFT')
    drawnow
    
    %%
    BandPass = BandPassHR;
    filteredsignal = filter(BandPass,detrendsignal); %Applies a Band Pass filter, allowing frequencies from 0.9 to 2.9 Hz.
    
    figure(4)
    plot(timevector,filteredsignal); %Plots the filtered and detrended signal vs. time
    axis([0,looptime(counter),-inf,inf]);
    title('Filtered and Detrended Signal vs. Time');
    xlabel('Time(s)')
    ylabel('Signal(mV)')
    drawnow
    
    %%
    [filterfftvector,filterfreqvector] = timetofreqdomain(filteredsignal,timevector); %Takes the FFT of the filtered and detrended signal
    
    figure(5)
    plot(filterfreqvector,filterfftvector); %Plots the magnitude of the FFT of the filtered and detrended signal vs. frequency
    axis([-3,3,0,inf]); %X-axis will be fitted differently from the detrended FFT due to filtering cutting out the higher frequencies
    title('Filtered FFT Signal vs. Frequency');
    xlabel('Frequency(Hz)')
    ylabel('Magnitude of FFT')
    drawnow
    
    %%
    [MaxFFTAmp,FreqIndex] = max(filterfftvector); %Finds the amplitude and the index location of the frequency with the largest amplitude
    HRFreq = filterfreqvector(FreqIndex); %Finds the frequency that has the largest amplitude. Because of the filtering, this should be the frequency of the heart rate.
    HeartBPM(counter) = abs(HRFreq*60); %Converts the frequency to beats per minute and puts the value into a vector of hearts beat data
    
    %%
    if counter == 1 %Will create a vector BPMtime that stores the times at which the heart beat is recorded so we can plot heart beats over time.
        BPMtime(counter) = looptime(1); %The time interval used to find the first heart beat
    else
        BPMtime(counter) = BPMtime(counter - 1) + looptime(counter); %Adds the time needed to find the following heart beats for each successive loop
    end
    
    %%
    fprintf('Your heart rate is %.2f BPM\n',HeartBPM(counter)) %Allows you to see the current heart rate in the command window
    
    %%
    save('HeartbeatData.mat','BPMtime','-append','HeartBPM','-append') %Updates the file with the latest heart beat data. Can still save data if need to terminate loop early.
    %^Change name of file to add data to different file.
    
end

writeDigitalPin(a,'D2',0); %Turn LED off