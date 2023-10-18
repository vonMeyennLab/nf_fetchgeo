#!/usr/bin/env nextflow
nextflow.enable.dsl=2


/* ========================================================================================
    PROCESSES
======================================================================================== */
process SRADOWNLOADER {

	tag "$geoaccession" // Adds name to job submission
    label 'sradownloader'

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
		module load sradownloader/3.8

		sradownloader_axel ${sradownloader_args} ${sra_metadata}
		"""
}
