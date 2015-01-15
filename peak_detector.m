function peak_detector(Y)
%% peak_detection - peak detection using Savitzky-Golay filters
%  KHP  (03/12/13)

% input: Y             - vector to be analysed
%        Wpeak         - half-width of peaks to be detected
%        Wfactor       - estimated space between peaks in peak half-widths
%        PeakThreshold - threshold for peak detection

Wpeak=20;                             
Wfactor=2;                           
PeakThreshold=max(Y)/2;                     

Wsmooth=Wfactor*Wpeak;   

Ypeak=sgolayfilt(Y,2,2*Wpeak+1);
Ysmooth=sgolayfilt(Y,2,2*Wsmooth+1);

j=find((Ypeak-Ysmooth) > PeakThreshold);

% display results
figure;
plot(Y), grid on, hold on;
plot(j,Y(j),'r.','LineWidth',4);

% to find absolute peaks search for maxima in the Y(j)

