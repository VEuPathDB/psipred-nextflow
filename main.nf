nextflow.enable.dsl=2

process psipred {
  publishDir params.outputDir, mode: 'copy'

  input:
    tuple val(id), val(seq)
    val (fix)

  output:
    path '*.horiz'
    path '*.ss' 
    path '*.ss2'

  script:  
    """
    echo '$seq' >  '$id$fix'
    runpsipred_single '$id$fix'
    """
}

workflow {
  seqs = channel.fromPath(params.inputFilePath)
           .splitFasta(record:[id:true,sequence:true])
  psipred( seqs, ".fasta" )
}