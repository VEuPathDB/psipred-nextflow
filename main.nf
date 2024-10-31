#!/usr/bin/env nextflow
nextflow.enable.dsl=2

//--------------------------------------------------------------------------
// Param Checking
//--------------------------------------------------------------------------

if (params.inputFilePath) {
  seqs = channel.fromPath(params.inputFilePath)
    .splitFasta(by:params.fastaSubsetSize, file: true)
}
else {
  throw new Exception("Missing params.inputFilePath")
}

//--------------------------------------------------------------------------
// Main Workflow
//--------------------------------------------------------------------------

workflow {

  psipredInput = filterAndMakeIndividualFiles(seqs)
  psipred(psipredInput.seq)
  bed = psipred2bedgraph(psipred.out)

  bedgraph2bigwig(bed.coil.collectFile(), psipredInput.proteinSizes)
  //bed.out.helix.collectFile()
  //bed.out.extended.collectFile()

}

//TODO make this a module
process bedgraph2bigwig {
  container 'quay.io/biocontainers/ucsc-bedgraphtobigwig:469--h9b8f530_0'

  input:
  path bed
  path sizes

  output:
  path "output.bw"

  script:
  """
  sort -k1,1 -k2,2n $bed > sorted_input.bedgraph

  bedGraphToBigWig sorted_input.bedgraph $sizes output.bw
  """

}
//

process psipred2bedgraph {
  container 'bioperl/bioperl:stable'

  input:
  path x

  output:
  path 'psipred_coil.bed', emit: coil
  path 'psipred_helix.bed', emit: helix
  path 'psipred_extended.bed', emit: extended

  script:
  """
  psipred2bedgraph.pl *.ss2
  """
}





process filterAndMakeIndividualFiles {
  container 'bioperl/bioperl:stable'

  input:
  path subset

  output:
  path '*.seq', emit: seq
  path 'protein.sizes', emit: proteinSizes

  script:
  """
  filterAndMakeIndividualFiles.pl \
    --inputFile $subset \
    --maxSequenceLength $task.ext.max_sequence_length
  """
}


process psipred {
  //publishDir params.outputDir, mode: 'copy'
  container = 'veupathdb/psipred:latest'
  input:
     path x

  output:
    path '*.ss2'

  script:
    """
    for fn in *.seq; do
      runpsipred_single \$fn;
    done
    """
}
