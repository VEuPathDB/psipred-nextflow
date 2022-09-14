#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process runPsipred {
  publishDir params.outputDir, mode: 'copy'

  input:
    tuple val(id), val(seq)
    val (fix)

  output:
    path '*.horiz'
    path '*.ss' 
    path '*.ss2'

  script:  
    template 'runPsipred.bash'
}

workflow psipred {
  take:
    seqs

  main:
    runPsipred(seqs, ".fasta")
}
