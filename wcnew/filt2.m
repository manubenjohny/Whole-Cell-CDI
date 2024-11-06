function [lowydata] = filt2(xdata, ydata ,fcutoff)

%nkids=length(kids)			%number of traces
%newkids(1:nkids)=kids			
%xdata 					%= get(kids(1),'xdata');

%zeropad the beginning of the trace
	Npad = round(length(xdata)/10);

	ydatapad = zeros(Npad,1);
	ydata = [ydatapad;ydata];

%calculate inputs to GAUSS filter

T = (xdata(2)-xdata(1))/1000;		% sampling interval in sec
fmax = 1/T;			  	% this is the maximum freq (hz)
N = length(xdata) + Npad;		% number of points
N2=2^ceil(log(N)/log(2));	




% pgp's GAUSS filter.
wc = 2*pi*fcutoff;
w=0:2*pi/(N2*T):2*pi*(N2-1)/(N2*T);				% radians/sec 0:2*pi/T
w(N2/2+2:N2)=-2*pi/(2*T)+2*pi/(N2*T):2*pi/(N2*T):-2*pi/(N2*T);	% Adjust so +/- 2*pi/2T
lfilt=gauss(w,wc,T);	

%n = round(N2*fcutoff/fmax)			% end of square pulse
%lfilt = zeros(1,N2);
%lfilt(1:n) = ones(1,n);
%lfilt(N2-n+1:N2) = ones(1,n);		% this is the crude filter

%ydata = get(kids(j),'ydata');
ydata = real(ifft(fft(ydata,N2).*lfilt'));
lowydata = ydata(1+Npad:length(xdata)+Npad);


