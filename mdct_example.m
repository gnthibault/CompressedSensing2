clc;
clear all;
close all;


%Define the signal here (.wav file)
[signal0,Fe]=wavread('road.wav');
Te = 1/Fe;
 
%We will get the first channel of the array:
signal1=signal0(:,1);
signal=signal1(1:4096);

%Get number of Elements
Nech = length(signal);
% Make sure length is even
if (rem(Nech,2)~=0)
    error('MDCT is defined only for even lengths.');
end

%Time vector
time = [0:Te:(Nech-1)*Te];
timeDiscrete = [0:1:Nech-1];

%Define our MDCT space
mdctFrequencySize = Nech/2;
mdctTimeSize = 4;
mdctSpace = zeros(mdctTimeSize,mdctFrequencySize);
windowSize = Nech/mdctTimeSize;

%Perform projection on MDCT space
for n = 0:Nech-1 %Scan along the music vector
    for k = 0:mdctTimeSize-1 %scan along frequency dimension of mdct space
        for l = 0:mdctFrequencySize-1 %scan along time dimension of mdct space
            mdctSpace(k+1,l+1)= mdctSpace(k+1,l+1) + signal(n+1)*cos((pi/mdctFrequencySize)*(n-k*mdctFrequencySize)*(l+0.5));
        end
    end
end

reconstruction = zeros(1,Nech);
%Perform inverse MDCT
for n = 0:Nech-1 %Scan along the music vector
    for k = 0:mdctTimeSize-1 %scan along frequency dimension of mdct space
        for l = 0:mdctFrequencySize-1 %scan along time dimension of mdct space
            reconstruction(n+1) = reconstruction(n+1) + mdctSpace(k+1,l+1)*cos((pi/mdctFrequencySize)*(n-k*mdctFrequencySize)*(l+0.5));
        end
    end
end
reconstruction = 2*reconstruction / (mdctTimeSize*mdctFrequencySize);

%Plot signal
figure(1)
plot(time,signal,'g');
hold on;
plot(time,reconstruction,':r');
xlabel('Time in s','FontSize',16);
ylabel('Signal value (no unit)','FontSize',16);
title('\it{ Signal reconstruction from MDCT transform }','FontSize',16);
legend('True signal', 'Reconstruction from MDCT transform (mp3)');

%Plot reconstruction error
figure(2)
plot(time,signal-reconstruction','r');
xlabel('Time in s','FontSize',16);
ylabel('Error (no unit)','FontSize',16);
title('\it{ Signal reconstruction error from MDCT transform }','FontSize',16);
legend('Difference between original signal and reconstruction from MDCT transform (mp3)');

%Plot mdctSpace
figure(3)
image( mdctSpace )
colorbar
xlabel('Frequency related dimension','FontSize',16);
ylabel('Time related dimension','FontSize',16);
title('\it{ Sparse MDCT representation of the music }','FontSize',16);
legend('Each coefficient of this matrix represent a component of the original sound, in the MDCT basis');


%Play the music !
soundsc(signal,Fe);
soundsc(reconstruction,Fe);


