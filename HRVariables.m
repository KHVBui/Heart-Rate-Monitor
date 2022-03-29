%List of variables needed in the HRMonitor script.
Maxcounter = 30; %Max amount of times the loop will run. Change if want to acquire data over a longer period of time.
signalsize = 300; %Number of indices in the signal and time vectors.
signalsizevector = (1:signalsize); %Create a vector of values from 1 to the signal size
timezero = 0; %Time at 0 s
rawsignalvector = zeros(0,signalsize); %Preallocating the raw signal vector
BPMtime = zeros(1,Maxcounter); %Number used to save heart BPM to a certain time
HeartBPM = zeros(1,Maxcounter); %Initialize variable of heart rate BPM to make a .mat file
looptime = zeros(1,Maxcounter); %The vector of how long it takes to acquire the signalsize each loop
maxdegree = 15; %The maximum degree polynomial we want to compare in our curvefitting function