%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% See http://en.wikipedia.org/wiki/Modified_discrete_cosine_transform %
% for more information on MDCT and windowing functions                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;
close all;

%Time vector
timeDiscrete = [0:pi/100:pi*0.99];

%Window
window = zeros(1,length( timeDiscrete ));
window2 = window;
window3 = window;

%Compute value of window
for n = 0:(length( timeDiscrete )-1)
   window(n+1) = sin( (pi/(length( timeDiscrete )))*(n+0.5));
end

%Verify symmetry
for n = 0:(length( timeDiscrete )-1)
   window2(n+1) = window(n+1)- window(length( timeDiscrete )-n);
end

%verify Princen-Bradley condition:
for n = 0:(length( timeDiscrete ) /2)
   window3(n+1) = window(n+1)^2 + window(n+(length( timeDiscrete ) /2))^2 ;
end

%Plot signal
figure(1)
plot(timeDiscrete,window,'b');
hold on;
plot(timeDiscrete,window2,'g');
hold on;
plot(timeDiscrete,window3,'c');
xlabel('Angle in radian','FontSize',16);
ylabel('window value (no unit)','FontSize',16);
title('\it{ Window value used for lapped MDCT transform }','FontSize',16);
legend('Window value', 'symmetry cond (0)', 'Princen-Bradley cond (1)');

