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
  results = psipred(seqs)
  results[0] | collectFile(storeDir: params.outputDir)
  results[1] | collectFile(storeDir: params.outputDir)
  results[2] | collectFile(storeDir: params.outputDir)
}