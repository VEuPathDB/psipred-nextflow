#!/usr/bin/env nextflow
nextflow.enable.dsl=2


process bedgraph2bigwig {
  container 'quay.io/biocontainers/ucsc-bedgraphtobigwig:469--h9b8f530_0'

  publishDir params.outputDir, mode: 'copy'

  input:
  path bed
  path sizes
  val type

  output:
  path "psipred_${type}.bw"

  script:
  """
  sort -k1,1 -k2,2n $bed > sorted_input.bedgraph

  bedGraphToBigWig sorted_input.bedgraph $sizes psipred_${type}.bw
  """

}
