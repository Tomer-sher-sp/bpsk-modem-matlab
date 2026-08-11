function ChannelOutVec = ChannelTXRX(config,ChannelInVec)
    ChannelInVec = ChannelInVec(:)';% turn  to row vector
    sigma = 10^(-config.snrdB/20); % because Psignal = 1
    NoiseInVec = randn(1, length(ChannelInVec))*sigma; % The noise
    ChannelOutVec = ChannelInVec + NoiseInVec;
end