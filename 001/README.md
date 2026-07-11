# 001 - Fully Differential MDAC OTA

This directory is a self-contained transistor-level reference design for a
fully differential, two-stage OTA intended for a 14-bit pipeline-ADC MDAC.
It includes the final fixed-size DUT and standalone Spectre decks for AC,
stability, noise, operating-point, and residue-settling verification.

## Requirements

- Cadence Spectre 21.1 or a compatible newer release.
- A licensed TSMC 28 nm PDK containing `nch_ulvt_mac` and `pch_ulvt_mac`.
- Bash for `run-spectre.sh`.

The proprietary PDK and its model files are not distributed in this repository.

## Set the PDK path

Edit the five `include` statements near the top of both `ac.scs` and
`tran.scs`. Replace only the path inside quotation marks:

```spectre
include "/path/to/your/TSMC28_PDK/models/spectre/crn28ull_1d8_elk_v1d8_2p2_shrink0d9_embedded_usage.scs" section=pre_simu
```

Use the master Spectre model deck from your PDK revision. It must define the
`pre_simu`, `noise_worst`, `TTMacro_MOS_MOSCAP`,
`TT_RES_BIP_DIO_DISRES`, and `TT_MOM` sections.

## Run

Load the Cadence environment so that `spectre` is available in `PATH`, then:

```bash
./run-spectre.sh ac
./run-spectre.sh tran
```

The default solver mode is Spectre X `cx`. Select another mode explicitly when
needed:

```bash
./run-spectre.sh tran aps
./run-spectre.sh ac ax
```

Results are written below `results/<analysis>_<mode>/` and are excluded from
Git. The committed reference condition is TT, 27 C, and 0.9 V.

## Reference CX verification

The committed decks were rerun with `+preset=cx +mt` before release. The
reference run completed all requested analyses and produced:

| Metric | Result |
| --- | ---: |
| Open-loop DC gain | 99.23 dB |
| Open-loop unity-gain bandwidth | 1.89 GHz |
| Differential-loop phase margin | 75.19 deg |
| CMFB1 / CMFB2 phase margin | 68.64 / 74.43 deg |
| Gain-boost-loop phase margin | 63.93 deg |
| Integrated output noise | 458.54 uV |
| Worst eight-cycle residue-settling error | 0.0499% |

Exact values can vary with PDK revision and simulator version.

## DUT ports

```spectre
subckt ota_core (vdd vss in_p in_n out_p out_n i_bias reset)
```

`i_bias` accepts a 20 uA reference current. `reset` is active high.
