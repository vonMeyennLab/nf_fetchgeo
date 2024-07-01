#!/usr/bin/env nextflow
nextflow.enable.dsl=2


/* ========================================================================================
    PROCESSES
======================================================================================== */
process SRADOWNLOADER {

	tag "$geoaccession" // Adds name to job submission
    label 'sradownloader'

	container 'docker://josousa/sradownloader:3.11'
	
	input:
	  	file(sra_metadata)
        val(geoaccession)
		val(outputdir)
		val(sradownloader_args)

	output:
	  	path "*gz", emit: fastq
		publishDir "$outputdir/fastq/$geoaccession", mode: "link", overwrite: true

	script:
		"""
		sradownloader ${sradownloader_args} ${sra_metadata}
		"""
}
