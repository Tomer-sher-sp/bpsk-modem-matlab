# BPSK Modem Simulation — MATLAB

End-to-end MATLAB simulation of a BPSK digital communication link with pulse
shaping, AWGN, synchronization, matched filtering, coherent demodulation, and
BER evaluation.

This project was completed as part of university coursework in digital communications.
The communication-system requirements and experiment structure were defined by the
assignment; the MATLAB transmitter, channel, receiver, synchronization, detection,
and analysis code in this repository are my implementation.

## Highlights

- Implemented BPSK symbol mapping and transmitter pulse shaping.
- Compared rectangular and sinc pulse shapes.
- Modeled an AWGN channel with configurable SNR.
- Implemented coherent carrier modulation and demodulation.
- Implemented matched-filter reception and symbol decisions.
- Used a synchronization sequence to estimate symbol timing.
- Estimated received amplitude from the synchronization correlation peak.
- Evaluated BER across a range of SNR values.

## Repository Structure

- `src/TX.m` — BPSK transmitter and pulse shaping
- `src/ChannelTXRX.m` — AWGN channel model
- `src/RX.m` — synchronization, demodulation, matched filtering, and detection
- `src/bpsk_system_demo.m` — experiment and BER-analysis script
- `data/` — notes about support/reference files used by the original coursework

## Technologies

MATLAB, Digital Communications, BPSK, AWGN, Matched Filtering, Synchronization,
Pulse Shaping, Coherent Detection, BER Analysis

## Reproducibility

The core transmitter, channel, receiver, synchronization, and BER-analysis code is
included in this repository.

Some support files used by the original coursework are not included:

- `config.mat`
- `RefInputMod.mat`
- `RefInputAudio.mat`
- `bitstream2text.m`

These files are only required for the corresponding configuration/reference-data
and text-decoding portions of the original experiment. See `data/README.md` for details.
