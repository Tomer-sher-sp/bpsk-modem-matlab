clear;
clc;        
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create the information bits : infobits

load('config.mat');
config.K = 1e4;
infobits = rand(1,config.K)>0.5; % ~ber(1/2)
config.pulsetype = 0; % 0 = rect, 1 = sinc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Transmitter
ChannelInVec = TX(config,infobits);

%2a
figure;
plot(config.tpulserect, 'LineWidth', 1.5);
title('Rectangular Transmission Pulse');
xlabel('Samples');
ylabel('Amplitude');
grid on;

L2_norm_rect = sum(config.tpulserect.^2);
disp(['The L2 norm of the rectangular pulse is: ', num2str(L2_norm_rect)]);

% %2b
infobits_32 = infobits(1:32);
BPSKbits_32 = 1 - 2.*infobits_32; 
PulseTrain_32 = upsample(BPSKbits_32, config.Ts); 
TXFiltout_32 = conv(config.tpulserect, PulseTrain_32);

figure;
subplot(2,1,1);
plot(PulseTrain_32);
title('Pulse Train (First 32 bits)');
xlabel('Samples');
ylabel('Amplitude');
axis tight; 
ylim([-1.2 1.2]);
grid on;

subplot(2,1,2);
plot(TXFiltout_32);
title('Transmission Filter Output (TXFiltout)');
xlabel('Samples');
ylabel('Amplitude');
axis tight;
ylim([-0.06 0.06]);
grid on;

%2c
config.pulsetype = 1; % 0 = rect, 1 = sinc
figure;
plot(config.tpulsesinc, 'LineWidth', 1.5);
title('Rectangular Transmission Pulse');
xlabel('Samples');
ylabel('Amplitude');
grid on;

L2_norm_sinc = sum(config.tpulsesinc.^2);
disp(['The L2 norm of the sinc pulse is: ', num2str(L2_norm_sinc)]);

%2d
infobits_32 = infobits(1:32);
BPSKbits_32 = 1 - 2.*infobits_32; 
PulseTrain_32 = upsample(BPSKbits_32, config.Ts); 
TXFiltout_32 = conv(config.tpulsesinc, PulseTrain_32);

figure;
subplot(2,1,1);
plot(PulseTrain_32);
title('Pulse Train (First 32 bits)');
xlabel('Samples');
ylabel('Amplitude');
axis tight; 
ylim([-1.2 1.2]);
grid on;

subplot(2,1,2);
plot(TXFiltout_32);
title('Transmission Filter Output (TXFiltout)');
xlabel('Samples');
ylabel('Amplitude');
axis tight;
ylim([-0.1 0.1]);
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Channel
config.pulsetype = 1; % 0 = rect, 1 = sinc
ChannelInVec = TX(config,infobits);

SNRvec = [120, 80, 30, 10];
for snr = SNRvec
    config.snrdB = snr;
    ChannelOutVec = ChannelTXRX(config,ChannelInVec);
    index_to_plot = 1 : 4*config.Fs;
    figure;
    subplot(2,1,1);
    plot(ChannelInVec(index_to_plot));
    title(['Channel Input (First 4Fs samples)']);
    xlabel('Samples');
    ylabel('Amplitude');
    axis tight;
    ylim([-0.1 0.1]); 
    grid on;

    subplot(2,1,2);
    plot(ChannelOutVec(index_to_plot));
    title(['Channel Output (SNR = ', num2str(snr), ' dB)']);
    xlabel('Samples');
    ylabel('Amplitude');
    axis tight;
    grid on;
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Receiver
config.pulsetype = 0; % 0 = rect, 1 = sinc
ChannelInVec = TX(config,infobits);
config.snrdB = 100;
ChannelOutVec = ChannelTXRX(config,ChannelInVec);
rxbits = RX(config,ChannelOutVec);


% 4a
short_vec_for_plot = ChannelOutVec(1 : 4*config.Fs); 
matched_filter_out = conv(short_vec_for_plot, flip(config.tpulserect));% like at RX function
optimal_idx = config.Fs + length(config.tpulserect);
index_to_plot = (optimal_idx - 5000) : (optimal_idx + 5000);

figure;
plot(index_to_plot, matched_filter_out(index_to_plot), 'b', 'LineWidth', 1.2);
hold on; 
plot(optimal_idx, matched_filter_out(optimal_idx), 'rx', 'MarkerSize', 12, 'LineWidth', 2);

title('Matched Filter Output & Optimal Sampling Point');
xlabel('Samples');
ylabel('Amplitude');
legend('Matched Filter Output', 'Optimal First Sample');
grid on;
hold off;


rxbits = RX(config, ChannelOutVec);
BER = mean(infobits ~= rxbits);
disp(['The Bit Error Rate (BER) is: ', num2str(BER)]);

% 4c
SNR_vec = -15: 2: 15;
BER_vec = zeros(1, length(SNR_vec));
for i = 1:length(SNR_vec)
    config.snrdB = SNR_vec(i);
    ChannelOutVec = ChannelTXRX(config, ChannelInVec);
    rxbits = RX(config, ChannelOutVec);
    BER_vec(i) = mean(infobits ~= rxbits);
end
figure;
semilogy(SNR_vec, BER_vec, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 6);
title('Question 4c: BER vs. SNR');
xlabel('SNR [dB]');
ylabel('Bit Error Rate (BER)');
grid on;


% 4e

config.pulsetype = 1; % 0 = rect, 1 = sinc
ChannelInVec = TX(config,infobits);
BER_vec = zeros(1, length(SNR_vec));
for i = 1:length(SNR_vec)
    config.snrdB = SNR_vec(i);
    ChannelOutVec = ChannelTXRX(config, ChannelInVec);
    rxbits = RX(config, ChannelOutVec);
    BER_vec(i) = mean(infobits ~= rxbits);
end
figure;
semilogy(SNR_vec, BER_vec, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 6);
title('Question 4e: BER vs. SNR');
xlabel('SNR [dB]');
ylabel('Bit Error Rate (BER)');
grid on;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% section 2.5
config.pulsetype = 1; 
config.snrdB = 100;
ChannelInVec_2_5 = TX(config,[config.synchbits,infobits]);
ChannelOutVec_2_5 = ChannelTXRX(config,ChannelInVec_2_5);

rxbits = RX(config, ChannelOutVec_2_5);
BER = mean(infobits ~= rxbits);
disp(['Question 5c - The Bit Error Rate (BER) is: ', num2str(BER)]);

%5e
SNR_vec = -15: 2: 15;
BER_vec = zeros(1, length(SNR_vec));
for i = 1:length(SNR_vec)
    config.snrdB = SNR_vec(i);
    ChannelOutVec = ChannelTXRX(config, ChannelInVec_2_5);
    rxbits = RX(config, ChannelOutVec);
    BER_vec(i) = mean(infobits ~= rxbits);
end
figure;
semilogy(SNR_vec, BER_vec, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 6);
title('Question 5e: BER vs. SNR');
xlabel('SNR [dB]');
ylabel('Bit Error Rate (BER)');
grid on;

%Q6
config.pulsetype = 1; 
%6a
ChannelInVec_6 = TX(config,[config.synchbits,infobits]);
ChannelOutVec_6 = ChannelTXRX(config,ChannelInVec_6);
config.snrdB = 100;
rxbits = RX(config, ChannelOutVec_6);
BER = mean(infobits ~= rxbits);
disp(['Question 6 - The Bit Error Rate (BER) is: ', num2str(BER)]);

%6b
config.snrdB = 100;
load('RefInputMod.mat');
rxbits = RX(config, ChannelOutVec);
BER = mean(infobits ~= rxbits(:));
disp(['Question 6b - The BER is: ', num2str(BER)]);

%6c
infobits = rand(1,config.K)>0.5; % ~ber(1/2)
ChannelInVec_6 = TX(config,[config.synchbits,infobits]);
SNR_vec = -15: 2: 15;
BER_vec = zeros(1, length(SNR_vec));
for i = 1:length(SNR_vec)
    config.snrdB = SNR_vec(i);
    ChannelOutVec = ChannelTXRX(config, ChannelInVec_6);
    rxbits = RX(config, ChannelOutVec);
    BER_vec(i) = mean(infobits ~= rxbits);
end
figure;
semilogy(SNR_vec, BER_vec, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 6);
title('Question 6c: BER vs. SNR');
xlabel('SNR [dB]');
ylabel('Bit Error Rate (BER)');
grid on;


%Q7b
load('RefInputAudio.mat'); 
config.pulsetype = 1; 

config.K = 200;
rxbits = RX(config, ChannelOutVec);

output = bitstream2text(rxbits);
disp(['Question 7b: ', output]);


