nextflow.enable.dsl=2

process createDatabase {
    output:
    path 'newdb.fasta'
    """
    cat $params.databaseFasta > newdb.fasta
    makeblastdb -in newdb.fasta -dbtype $params.dbType
    """
}

process psipred {
    input:
    path 'subset.fa'
    path 'newdb.fasta'
    output:
    path 'subset.horiz'
    path 'subset.ss' 
    path 'subset.ss2'
    """
    runpsipred_single subset.fa newdb.fasta 
    """
}

workflow {
  database = createDatabase()
  seqs = channel.fromPath(params.inputFilePath).splitFasta( by:1,file:true)
  psipred(database, seqs)
}