#!/usr/bin/env nextflow
nextflow.enable.dsl=2

//--------------------------------------------------------------------------
// Param Checking
//--------------------------------------------------------------------------

if (params.inputFilePath) {
  seqs = channel.fromPath(params.inputFilePath)
         .splitFasta(record:[id:true,sequence:true])
	 .filter { record -> record.sequence.length() <= 10000 }
}
else {
  throw new Exception("Missing params.inputFilePath")
}

//--------------------------------------------------------------------------
// Includes
//--------------------------------------------------------------------------

include { psipred } from './modules/psipred.nf'

//--------------------------------------------------------------------------
// Main Workflow
//--------------------------------------------------------------------------

workflow {
  
  psipred( seqs )
  
}