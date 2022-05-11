nextflow.enable.dsl=1
seq_qch = Channel.fromPath(params.inputFilePath).splitFasta( by:1, file:true  )

process psipred {
    
    input:
    path 'subset.fa' from seq_qch
    output:
    path 'subset.horiz' into output_qch
        
    """
    cp -r /work/psipred/* ./
    runpsipred_single subset.fa 
    """
}

results = output_qch.collectFile(storeDir: params.outputDir, name: params.outputFileName)