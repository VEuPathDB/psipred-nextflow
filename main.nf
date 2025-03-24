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
// Modules
//--------------------------------------------------------------------------



include { bedgraph2bigwig as bedgraph2bigwig_coil } from './modules/utils.nf'
include { bedgraph2bigwig as bedgraph2bigwig_helix } from './modules/utils.nf'
include { bedgraph2bigwig as bedgraph2bigwig_extended } from './modules/utils.nf'

//--------------------------------------------------------------------------
// Main Workflow
//--------------------------------------------------------------------------



workflow {

  psipredInput = filterAndMakeIndividualFiles(seqs)
  psipred(psipredInput.seq)
  bed = psipred2bedgraph(psipred.out)

  proteinSizes = psipredInput.proteinSizes.collectFile()
  bedgraph2bigwig_coil(bed.coil.collectFile(), proteinSizes, "coil")
  bedgraph2bigwig_helix(bed.helix.collectFile(), proteinSizes, "helix")
  bedgraph2bigwig_extended(bed.extended.collectFile(), proteinSizes, "extended")
}


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

  container = 'veupathdb/psipred:v1.0.0'
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
