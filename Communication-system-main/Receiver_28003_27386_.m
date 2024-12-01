%% A. Initialization of Mystery Signal for Receiver Input

% Clears the workspace and closes all figures to ensure a clean start.
clear;
close all;

% Define common formatting options for plot.
commonTitleColor = {'Color', 'red'};
img = 0;

% This preamble is used for frame synchronization.
preamble ='0x0 This is is the Frame Header 1y1';

% Prompt to select a mystery signal for decoding.
selectedMystery = input(['Select a mystery to decode: Input "a, A or mystery' ...
                        'A " for Mystery A, "b, B or mysteryB" for Mystery B, ' ...
                        'or "c, C or mysteryC" for Mystery C: '], 's');

% Loading the selected dataset based on user input.
[r, SRRCLength, SRRCrolloff, T_t, f_if, f_s] = loadMysteryDataset(selectedMystery);

% Compute required parameters for the received signal.
[Ts, M, t] = calculateReceivedParams(f_s, r, T_t);

% Plot the spectrum of the received signal.
img = img + 1;
figure(img),
plotspec(r, Ts);
grid on;
title('Magnitude Spectrum', commonTitleColor{:});

%% B. Carrier Recovery [Dual Costas Loop]
%--------------------------------------------------------------------------
% The algorithm, sourced from the Exercise Answer Book for Software Receiver
% Design by Qingxiong Deng et al. (February 7, 2011, page 118), tracks the
% carrier's frequency and phase offset in the received signal and calculates
% theta1 and theta2, which are essential for cosine computation during
% demodulation.
%--------------------------------------------------------------------------

% Calculation for the estimated carrier frequency based on intermediate frequency and sampling rate.
est_carrierFreq= cal_Carrier_freq(f_if, f_s);

% The parameters include filter length, frequency offsets, and loop gains.
params = struct('fl', 80, 'ff', [0 .01 .02 1], 'fa', [1 1 0 0], 'mu1', 0.03, 'mu2', 0.0009);

[theta1, theta2, f_0] = performCarrierRecovery(r, t, est_carrierFreq, params);

% Compution for the carrier signal.
carrier_signal = cos(2 * pi * f_0 * t' + theta1' + theta2');

% Plot for the results of the carrier recovery process.
img = img + 1;
figure(img);
data = {theta1, theta2};
titles = {'First Costa Loop', 'Second Costa Loop'};
ylabels = {'\theta_1', '\theta_2'};
for i = 1:2
    subplot(2, 1, i);
    plot(t, data{i});
    grid on;
    ylabel(ylabels{i}, commonTitleColor{:});
    xlabel('Time', commonTitleColor{:});
    title(titles{i}, commonTitleColor{:});
end

% Demodulate the received signal using the carrier signal.
dem_rec = r .* carrier_signal;

% Plot the spectrum of the demodulated signal.
img = img + 1;
figure(img)
plotspec(dem_rec, Ts);
grid on;
title('Downconverted Signal', commonTitleColor{:});

%% C. Matched Filtering
%--------------------------------------------------------------------------
% Implemented match filter to rapidly extract the baseband signal
% and eliminate intersymbol interference.
% The code for this filter was obtained from "matchfilt.m."
%--------------------------------------------------------------------------

% Generating a custom Square-Root Raised Cosine Filter
custom_SRRC_filter = srrc(SRRCLength, SRRCrolloff, M);
matchedFilteredSignal = filter(custom_SRRC_filter, 1, dem_rec);

% Plotting the Spectrum of the Custom Filtered Signal using plotspec
img = img + 1;
figure(img);
plotspec(matchedFilteredSignal, Ts);
grid on;
title('Spectrum of Match-Filtered Signal', commonTitleColor{:});

%% D. Timing Recovery [ClockrecDD.m]
%--------------------------------------------------------------------------
% This section of code implements the algorithm for timing recovery
% as described in the book "Software Receiver Design: Build Your Own Digital
% Communication System in Five Steps" by John Jr., C.R., Sethares, W.A.,
% and Klein, A.G. (Cambridge University Press, 2011, p. 263)
%--------------------------------------------------------------------------

% Calling the custom timing recovery function
[time_recovered_signal, tausave] = performTimingRecovery(matchedFilteredSignal, SRRCLength, M);

% Plotting the results
img = img + 1;
figure(img);
subplot(2, 1, 1), plot(time_recovered_signal, "b.")
grid on;
title("Constellation Diagram", commonTitleColor{:})
ylabel("Symbol Values", commonTitleColor{:})
subplot(2, 1, 2), plot(tausave)
grid on;
title("Tau's Development", commonTitleColor{:})
ylabel("Offset Estimates", commonTitleColor{:})
xlabel("Iterations", commonTitleColor{:})




%% E. Frame Synchronization [correx.m]

frame_input = time_recovered_signal;
 userDataLength =  125; 
  % Convert preamble to PAM representation
    preamblePAM = letters2pam(preamble);
    % Extract frames from the time-recovered signal using cross-correlation
    crossCorrelationResult = xcorr(preamblePAM, frame_input);

    % Setting the peak detection threshold to 68% of the maximum absolute value of the correlated signal
    peakThreshold = max(abs(crossCorrelationResult)) * 0.68;

% Call the frame synchronization function
[syncedFrames] = performFrameSynchronization(preamblePAM,peakThreshold,crossCorrelationResult ,frame_input, userDataLength);

% Visualize the cross-correlation and its absolute values
img = img + 1;
figure(img);

% Plotting Cross-Correlation Output
subplot(2,1,1); % Arrange two plots side by side
stem(crossCorrelationResult); % Using plot instead of stem
grid on;
title('Cross-Correlation Output', commonTitleColor{:});
xlabel('Sample Index', commonTitleColor{:});
ylabel('Correlation Value', commonTitleColor{:});

% Plotting Absolute Value of Cross-Correlation Output
subplot(2,1,2); % Second plot next to the first one
stem(abs(crossCorrelationResult)); % Changing color for distinction
grid on;
title('Absolute Value of Cross-Correlation Output', commonTitleColor{:});
xlabel('Sample Index', commonTitleColor{:});
ylabel('Absolute Correlation Value', commonTitleColor{:});



  
   %% F. Equalizer [Decision-Directed Equalizer , DDequalizer.m]  
%--------------------------------------------------------------------------
  % Reference: "Software Receiver Design: Build Your Own Digital Communication 
  % System in Five Easy Steps," Cambridge University Press, Page 289.
%--------------------------------------------------------------------------
% Parameters for the DD Equalizer
equalizerLength = 7;
mu = 0.000008;
f = [0 0 0 1 0 0 0]';  % Initial filter coefficients

% Apply the Decision-Directed Equalizer
filteredSignal = processSignalWithDDEqualizer(syncedFrames, equalizerLength, mu, f);

img = img + 1;
figure(img);
% Plotting the equalized signal with blue dots
plot(filteredSignal, 'b.'); 
grid on; 
ylim([-4 4]); % Set Y-axis limits to constrain the view
title('Equalizer Signal output', commonTitleColor{:});

%% G. Decoding Process

reconstructed_message = decodeAndSaveMessage(filteredSignal, selectedMystery);

% Display reconstructed_message
disp(reconstructed_message);
fprintf('Decoded Message for Mystery %s is saved as a text file\n', upper(selectedMystery));

%% END