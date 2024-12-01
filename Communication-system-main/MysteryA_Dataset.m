
% Load Dataset A (mysteryA)
load('mysteryA');

% Parameters for Dataset A Configuration
SRRCLength = 7;                 % Length of the Square-Root Raised Cosine Filter
SRRCrolloff = 0.24;             % Roll-off factor for the Square-Root Raised Cosine Filter
T_t = 8.9e-6;                   % Symbol time
f_if = 1.6e6;                   % Intermediate frequency
f_s = 700e3;                    % Sampling frequency

