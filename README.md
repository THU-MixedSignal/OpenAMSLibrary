# OpenAMSLibrary

An open library of transistor-level analog and mixed-signal circuits with
reproducible testbenches and simulation flows.

Each numbered directory is self-contained: it carries its own DUT, testbenches,
run entry point, dependency notes, and PDK placeholders. No circuit depends on
files from another numbered directory.

| Number | Circuit | Technology | Entry point |
| --- | --- | --- | --- |
| [`001`](001/) | Fully differential MDAC OTA | TSMC 28 nm, 0.9 V | `001/run-spectre.sh` |

Proprietary PDK files are never included. Users must supply model files from
their own licensed PDK installation.
