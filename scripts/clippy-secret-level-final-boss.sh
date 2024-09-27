#!/bin/sh
cargo clippy --all-features -- -W clippy::correctness -W clippy::complexity -W clippy::pedantic -W clippy::nursery  -W clippy::perf -W clippy::cargo -W clippy::all

