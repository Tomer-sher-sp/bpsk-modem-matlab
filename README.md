# BPSK Modem Simulation — MATLAB

End-to-end MATLAB simulation of a BPSK digital communication link with pulse
shaping, AWGN, synchronization, matched filtering, coherent demodulation, and
BER evaluation.

## Highlights

- Implemented BPSK symbol mapping and transmitter pulse shaping.
- Compared rectangular and sinc pulse shapes.
- Modeled an AWGN channel with configurable SNR.
- Implemented coherent carrier modulation/demodulation.
- Implemented matched-filter reception and symbol decisions.
- Used a synchronization sequence to estimate timing.
- Estimated received amplitude from the synchronization correlation peak.
- Evaluated BER across a range of SNR values.

## Repository structure

- `src/TX.m` — transmitter
- `src/ChannelTXRX.m` — AWGN channel
- `src/RX.m` — synchronization, demodulation, matched filtering, and detection
- `src/bpsk_system_demo.m` — experiment/demo script
- `data/` — configuration/reference files needed by the original experiment

## Technologies

MATLAB, Digital Communications, BPSK, AWGN, Matched Filtering, Synchronization,
Pulse Shaping, Coherent Detection, BER Analysis

## Reproducibility note

The uploaded ZIP did not include all referenced `.mat`/helper files. See
`data/README.md` before publishing the repository as a fully runnable project.
