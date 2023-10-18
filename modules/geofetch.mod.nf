#!/usr/bin/env nextflow
nextflow.enable.dsl=2


/* ========================================================================================
    DEFAULT PARAMETERS
======================================================================================== */
params.download_sra           = true
params.download_processed     = false
params.download_just_metadata = false
params.data_source            = 'samples'


/* ========================================================================================
    PROCESSES
======================================================================================== */
process GEOFETCH {

	label 'geofetch'
	tag "$geoaccession" // Adds name to job submission

	input:
        val(geoaccession)
		val(outputdir)
		val(geofetch_args)

	output:
        path "metadata/GSE*/GSE*_SRA.csv",       emit: sra_metadata,       optional: true
		path "metadata/GSE*/GSE*.soft",          emit: soft_metadata,      optional: true
		path "metadata/GSE*/GSE*_file_list.txt", emit: file_list_metadata, optional: true
		path "metadata/GSE*/GSE*_samples/*",     emit: samples_metadata,   optional: true
		path "metadata/GSE*/GSE*_PEP/*",         emit: pep_metadata,       optional: true
		path "SRR*/*.sra",                       emit: sra_files,          optional: true
		path "processed/GSE*/*",                 emit: processed_files,    optional: true

		publishDir "$outputdir/sra/$geoaccession", mode: "link", pattern: "SRR*/*.sra",                   overwrite: true, enabled: params.download_sra
		publishDir "$outputdir",                   mode: "link", pattern: "metadata/GSE*/GSE*",           overwrite: true
		publishDir "$outputdir",                   mode: "link", pattern: "metadata/GSE*/GSE*_PEP/*",     overwrite: true
		publishDir "$outputdir",                   mode: "link", pattern: "metadata/GSE*/GSE*_samples/*", overwrite: true, enabled: params.download_processed
		publishDir "$outputdir",                   mode: "link", pattern: "processed/GSE*/*",             overwrite: true, enabled: params.download_processed

	script:
		/* ==========
			Metadata
		========== */
        if (params.download_just_metadata){
            geofetch_args += " --just-metadata "
		}

		/* ==========
			Processed data
		========== */
		if (params.download_processed && !params.download_sra){
            geofetch_args += " --processed -g processed "
		}

		/* ==========
			Data source
		========== */
		// Specifies the source of data on the GEO record to retrieve processed data,
		// which may be attached to the collective series entity, or to individual samples.
		// Allowable values are: samples, series or both (all). Ignored unless 'processed' flag is set.
		// [Default: samples]
		if (params.data_source && params.download_processed){
            geofetch_args += " --data-source " + params.data_source + " "
		}

		"""
		module load geofetch

		geofetch -i ${geoaccession} ${geofetch_args} --metadata-folder metadata
		"""
}
