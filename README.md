# Gene Expression Omnibus (GEO) database download Pipeline

<img width="30%" src="https://raw.githubusercontent.com/nextflow-io/trademark/master/nextflow-logo-bg-light.png" />

A Nextflow pipeline to download **FASTQ**, **SRA**, and **processed** files from the [Gene Expression Omnibus (GEO)](https://www.ncbi.nlm.nih.gov/geo/) database, a public functional genomics data repository supporting MIAME-compliant data submissions.

## Pipeline steps
1. [geofetch](https://geofetch.databio.org/en/latest/)
2. [sradownloader](https://github.com/s-andrews/sradownloader)

## Required parameters

A single or multiple GEO accession numbers separated by commas.

```bash
--geo_acc 'GSE129393,GSE208727,GSE54651'
```

Output directory where the files will be saved.

``` bash
--outdir /cluster/work/nme/data/josousa/project
```

## Optional parameters
- Option to choose the file types to download from the GEO database.

    ``` bash
    --output_type 'FastQ data' # Default
    --output_type 'SRA data'
    --output_type 'FastQ + SRA data'
    --output_type 'Processed data'
    --output_type 'SRA metadata'
    --output_type 'Processed metadata'
    ```

- Option to specify the source of data on the GEO record to retrieve processed data.

    ``` bash
    --data_source 'samples' # Default
    --data_source 'series'
    --data_source 'both'
    ```

    >_This option only applies for the processed data download. Specifies the source of data on the GEO record to retrieve processed data, which may be attached to the collective series entity, or to individual samples. Allowable values are: samples, series or both (all). Ignored unless 'processed' flag is set._

## Extra arguments
- Option to add extra arguments to the package [geofetch](https://geofetch.databio.org/en/latest/).

    `--geofetch_args`

- Option to add extra arguments to the package [sradownloader](https://github.com/s-andrews/sradownloader).

    `--sradownloader_args`

## Downloading Options
The [`sradownloader`](https://github.com/s-andrews/sradownloader) package has been enhanced to support downloading files using the [`Axel`](https://github.com/axel-download-accelerator/axel) download accelerator, [`wget`](https://www.gnu.org/software/wget), or FTP. This modification allows for faster and more flexible file downloads from the SRA database.

For detailed information and updates, visit the project's GitHub page: [sradownloader-axel](https://github.com/jpadesousa/sradownloader-axel).

To specify the download method, add one of the following arguments to `--sradownloader_args`:

- `--axel` for downloading with Axel.
- `--wget` for downloading with wget.
- `--ftp` for downloading via FTP.

## Acknowledgements
This pipeline was adapted from the Nextflow pipelines created by the [Babraham Institute Bioinformatics Group](https://github.com/s-andrews/nextflow_pipelines) and from the [nf-core](https://nf-co.re/) pipelines. We thank all the contributors for both projects. We also thank the [Nextflow community](https://nextflow.slack.com/join) and the [nf-core community](https://nf-co.re/join) for all the help and support.
