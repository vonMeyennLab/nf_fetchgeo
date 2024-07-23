#!/usr/bin/env nextflow
nextflow.enable.dsl=2


/* ========================================================================================
    INPUT
======================================================================================== */
params.geo_acc = null

if (!params.geo_acc) {
    error "GEO accession not provided. Please provide a GEO accession using the --geo_acc parameter."
}

geoaccession = Channel.of(params.geo_acc).splitCsv().flatten()


/* ========================================================================================
    OUTPUT DIRECTORY
======================================================================================== */
params.outdir = false

if(params.outdir){
    outdir = params.outdir
} else {
    outdir = '.'
}


/* ========================================================================================
    CONDITIONAL PARAMETERS
======================================================================================== */
params.output_type            = 'FastQ data'
params.download_fastq         = true
params.download_sra           = false
params.download_processed     = false
params.download_just_metadata = false

download_fastq         = params.download_fastq     
download_sra           = params.download_sra       
download_processed     = params.download_processed
download_just_metadata = params.download_just_metadata

if(params.output_type == 'FastQ data'){
    download_fastq         = true
    download_sra           = false
    download_processed     = false
    download_just_metadata = true
} 

else if (params.output_type == 'SRA data'){
    download_fastq         = false
    download_sra           = true
    download_processed     = false
    download_just_metadata = false
}

else if (params.output_type == 'FastQ + SRA data'){
    download_fastq         = true
    download_sra           = true
    download_processed     = false
    download_just_metadata = false
}

else if (params.output_type == 'Processed data'){
    download_fastq         = false
    download_sra           = false
    download_processed     = true
    download_just_metadata = false
}

else if (params.output_type == 'SRA metadata'){
    download_fastq         = false
    download_sra           = false
    download_processed     = false
    download_just_metadata = true
}

else if (params.output_type == 'Processed metadata'){
    download_fastq         = false
    download_sra           = false
    download_processed     = true
    download_just_metadata = true
}


/* ========================================================================================
    PARAMETERS
======================================================================================== */
params.data_source        = 'samples' 
// geofetch --data_source 'samples':
// Specifies the source of data on the GEO record to retrieve processed data,
// which may be attached to the collective series entity, or to individual samples.
// Allowable values are: samples, series or both (all). Ignored unless 'processed' flag is set.
// [Default: samples]

params.geofetch_args      = ''
params.sradownloader_args = '--wget'

/* ========================================================================================
    WORKFLOW
======================================================================================== */
include { GEOFETCH }       from './modules/geofetch.mod.nf' params(download_sra: download_sra, data_source: params.data_source, download_processed: download_processed, download_just_metadata: download_just_metadata)
include { SRADOWNLOADER }  from './modules/sradownloader.mod.nf'

workflow {
    main:

        if (download_fastq){

            GEOFETCH       (geoaccession, outdir, params.geofetch_args)
            SRADOWNLOADER  (GEOFETCH.out.sra_metadata, geoaccession, outdir, params.sradownloader_args)

        } else {

            GEOFETCH       (geoaccession, outdir, params.geofetch_args)

        }    
}
