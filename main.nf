nextflow.enable.dsl=1
seq_qch = Channel.fromPath(params.inputFilePath).splitFasta( by:1, file:true  )

process psipred {
    
    input:
    path 'subset.fa' from seq_qch
    output:
    path 'subset.horiz' into horiz_qch
    path 'subset.ss' into ss_qch
    path 'subset.ss2' into ss2_qch

    """
    cat $params.databaseFasta > newdb.fasta
    makeblastdb -in newdb.fasta -dbtype $params.dbType
    runpsipred_single subset.fa newdb.fasta 
    """
}

results_horiz = horiz_qch.collectFile(storeDir: params.outputDir, name: "output.horiz")
results_ss = ss_qch.collectFile(storeDir: params.outputDir, name: "output.ss")
results_ss2 = ss2_qch.collectFile(storeDir: params.outputDir, name: "output.ss2")