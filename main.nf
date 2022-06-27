nextflow.enable.dsl=2

process psipred {
    publishDir params.outputDir, mode: 'copy'

    input:
    path 'subset.fa'
    
    output:
    path 'subset.horiz'
    path 'subset.ss' 
    path 'subset.ss2'

    """
    runpsipred_single subset.fa 
    """
}

workflow {
  seqs = channel.fromPath(params.inputFilePath).splitFasta( by:1,file:true)
  psipred(seqs)
}