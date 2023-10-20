#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process removeSeqsOver10K {

  input:
    path unfiltered

  output:
    path 'filtered.fasta'

  script:  
    template 'removeSeqsOver10K.bash'
}

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
    inputFile

  main:

    filtered = removeSeqsOver10K(inputFile)

    seqs = filtered.splitFasta(record:[id:true,sequence:true])

    runPsipred(seqs, ".fasta")
}
