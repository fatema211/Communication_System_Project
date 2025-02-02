% plotspec(x,Ts) plots the spectrum of the signal x
% Ts = time (in seconds) between adjacent samples in x
function plotspec(x,Ts)
N=length(x);                               % length of the signal x
t=Ts*(1:N);                                % define a time vector
ssf=(-N/2:N/2-1)/(Ts*N);                   % frequency vector
fx=fft(x(1:N));                            % do DFT/FFT
fxs=fftshift(fx);                          % shift it for plotting
subplot(2,1,1), plot(t,x)                  % plot the waveform
xlabel('seconds','Color', 'red'); ylabel('amplitude','Color', 'red')     % label the axes
subplot(2,1,2), plot(ssf,abs(fxs))         % plot magnitude spectrum 
xlabel('frequency','Color', 'red'); ylabel('magnitude','Color', 'red')   % label the axes
