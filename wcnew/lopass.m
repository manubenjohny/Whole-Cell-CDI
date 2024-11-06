function lopass

% 	LOPASS.M 	Program Takes a Trace and Lopass (Gaussian) Filters it.


%	T: sampling interval in seconds, 
%	N: number of points in the trace
%	fc: desired cutoff frequency in hz
%	trace: a row vector containing the data
% 	returns a row vector also



% Get the Trace and Important Variables


FInfo = get(gcf,'UserData');			% Get UserData Matrix (handles for GUI and traces)

% Get Information for the current sweep

HIDline = FInfo.Hlines(2);

S = get(HIDline, 'UserData');

ydata = get(HIDline,'YData');
xdata = get(HIDline,'XData');
	


% Initialize Variables

T = (xdata(2)-xdata(1))/1000;
N = length(ydata);

% Calculate Important Intermediate Variables

fc = input('Enter Cutoff Frequency: ');
%display('Automatically selected 500 Hz');
%fc = 500;

wc=2*pi*fc;							% Lopass cutoff
% t=0:T:T*(N-1);							% time vector

N2=2^ceil(log(N)/log(2));					% next power of 2

w=0:2*pi/(N2*T):2*pi*(N2-1)/(N2*T);				% radians/sec 0:2*pi/T
w(N2/2+2:N2)=-2*pi/(2*T)+2*pi/(N2*T):2*pi/(N2*T):-2*pi/(N2*T);	% Adjust so +/- 2*pi/2T
% f=w./(2*pi);							% Hz

% Calculate Fourier Transform of trace

spectrum1=fft(ydata,N2);		

% Do Filter Calculation X(w)/H(w)

H3=gauss(w,wc,T);			% Gaussian Filter
% H3=H3';
trace3=real(ifft(H3.*spectrum1));
ftrace=trace3(1:N);
% what used in filt2.m (instead of last line), not suitable here
% Npad = round(length(time)/10);
% ftrace = trace3(1+Npad:length(time)+Npad);

S.ydata = ftrace;
set(HIDline,'YData',ftrace);	

