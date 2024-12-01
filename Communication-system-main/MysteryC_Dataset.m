
% Load Dataset C (mysteryC)
load('mysteryC');

% Parameters for Dataset C Configuration
SRRCLength = 6;                 % Length of the Square-Root Raised Cosine Filter
SRRCrolloff = 0.32;             % Roll-off factor for the Square-Root Raised Cosine Filter
T_t = 8.14e-6;                   % Symbol time
f_if = 2.2e6;                   % Intermediate frequency
f_s = 819e3;                    % Sampling frequency
