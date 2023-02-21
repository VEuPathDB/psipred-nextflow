# Nextflow Conversion of PsipredTask.pm

***<p align=center>PsiPred</p>***  
```mermaid
flowchart TD
    p0((Channel.fromPath))
    p1([splitFasta])
    p2(( ))
    p3[psipred:runPsipred]
    p4(( ))
    p5(( ))
    p6(( ))
    p0 --> p1
    p1 -->|seqs| p3
    p2 -->|fix| p3
    p3 --> p6
    p3 --> p5
    p3 --> p4
```

Decription of nextflow configuration parameters:

| param         | value type        | description  |
| ------------- | ------------- | ------------ |
| inputFilePath  | string | Path to input file |
| outputDir | string | Path to where you would like output files stored |
| databaseFasta | string | Path to the fasta file that you would like to use a the database for Psipred |

### Get Started
  * Install Nextflow
    
    `curl https://get.nextflow.io | bash`
  
  * Run the script
    
    `nextflow run VEuPathDB/Psipred -with-trace -c  <config_file> -r main`
