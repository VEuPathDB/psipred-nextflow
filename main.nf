#!/usr/bin/env nextflow
nextflow.enable.dsl=2

//--------------------------------------------------------------------------
// Param Checking
//--------------------------------------------------------------------------

if (params.inputFilePath) {
  inputFile = channel.fromPath(params.inputFilePath)
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
  
  psipred( inputFile )
  
}