# psipred-nextflow

Nextflow pipeline that runs [PSIPRED](http://bioinf.cs.ucl.ac.uk/psipred/) protein secondary structure prediction over a set of protein sequences and produces genome-browser-ready BigWig tracks.

## Overview

PSIPRED predicts, per residue, whether a protein sequence forms a coil, helix, or extended (beta strand) secondary structure. This pipeline is VEuPathDB's Nextflow conversion of the legacy `PsipredTask.pm` workflow: it takes a FASTA file of protein sequences, runs PSIPRED on each sequence, converts the per-residue predictions into BED intervals for each structure class, and renders those intervals as BigWig tracks (one each for coil, helix, and extended) for display in the VEuPathDB genome browser.

## Requirements

- [Nextflow](https://www.nextflow.io/) (DSL2)
- A container engine — Docker or Singularity. `nextflow.config` includes `conf/docker.config` by default (`docker.enabled = true`); `conf/singularity.config` is available as an alternative profile (`singularity.enabled = true`) for Singularity-only environments such as HPC clusters.

## Usage

```
nextflow run VEuPathDB/psipred-nextflow -r main \
  --inputFilePath /path/to/proteins.fasta \
  --outputDir /path/to/output \
  --outputFilePrefix psipred \
  -resume -C my.config
```

To run under Singularity instead of Docker, include `conf/singularity.config` in your custom config (or pass `-C conf/singularity.config` in addition to your own config).

The pipeline has a single, unnamed entry point (`workflow { ... }` in `main.nf`), so no `-entry` flag is needed.

Steps performed:
1. The input FASTA is split into subsets of `params.fastaSubsetSize` sequences via `splitFasta`.
2. `filterAndMakeIndividualFiles` runs `filterAndMakeIndividualFiles.pl`, dropping sequences longer than `task.ext.max_sequence_length`, writing one `.seq` file per remaining sequence, and recording each protein's length in `protein.sizes`.
3. `psipred` runs `runpsipred_single` on each `.seq` file, producing a PSIPRED `.ss2` secondary-structure output per protein.
4. `psipred2bedgraph` runs `psipred2bedgraph.pl` to convert the `.ss2` files into three BED files — `psipred_coil.bed`, `psipred_helix.bed`, `psipred_extended.bed` — one per structure class.
5. `bedgraph2bigwig` (invoked once per structure class) sorts each BED file and runs `bedGraphToBigWig` against the collected `protein.sizes`, publishing `<outputFilePrefix>_coil.bw`, `<outputFilePrefix>_helix.bw`, and `<outputFilePrefix>_extended.bw` to `params.outputDir`.

## Key Parameters

| Parameter | Description | Default |
|---|---|---|
| `params.inputFilePath` | Path to the input protein FASTA file | `data/proteinFixedSubset.fsa` |
| `params.outputDir` | Directory the BigWig tracks are published to | `output` (relative to launch directory) |
| `params.fastaSubsetSize` | Number of sequences per split FASTA chunk, controlling parallelism | `50` |
| `params.outputFilePrefix` | Filename prefix for the published BigWig files | `psipred` |
| `process.ext.max_sequence_length` (set via `withName: filterAndMakeIndividualFiles`) | Maximum protein sequence length passed to PSIPRED; longer sequences are skipped | `10000` |

## Output

Three BigWig files published to `params.outputDir`, one per secondary structure class: `<outputFilePrefix>_coil.bw`, `<outputFilePrefix>_helix.bw`, and `<outputFilePrefix>_extended.bw`, each giving a per-residue confidence/coverage track suitable for genome browser display.
