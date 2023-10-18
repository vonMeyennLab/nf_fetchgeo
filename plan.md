# ENSEMBL FASTA
VERSION=110
wget -L ftp://ftp.ensembl.org/pub/release-$VERSION/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz

# NCBI FASTA

# UCSC FASTA




# fasta       
VERSION=110
wget -L ftp://ftp.ensembl.org/pub/release-$VERSION/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz

### FASTA index
samtools faidx Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa

# transcript_fasta
STAR --runMode genomeGenerate --genomeDir rsem/ --genomeFastaFiles $fasta --sjdbGTFfile $gtf --runThreadN $task.cpus $memory $args2
rsem-prepare-reference --gtf $gtf --num-threads $task.cpus ${args_list.join(' ')} $fasta rsem/genome

rsem-prepare-reference --gtf $gtf --num-threads $task.cpus $args $fasta rsem/genome

### chromosome names and sizes

# bwa
bwa index Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa

bwa index $args -p bwa/${fasta.baseName} $fasta

# bowtie2
bowtie2-build --thread 32 --seed 123 Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa Homo_sapiens.GRCh38.dna_sm.primary_assembly
bowtie2-build $args --threads $task.cpus $fasta bowtie2/${fasta.baseName}


# hisat2
hisat2-build -p 32 Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa Homo_sapiens.GRCh38.dna_sm.primary_assembly
hisat2-build -p $task.cpus $ss $exon $args $fasta hisat2/${fasta.baseName}

# hisat2 splicesites
hisat2_extract_splice_sites.py ../../Annotation/Genes/Homo_sapiens.GRCh38.110.gtf > Homo_sapiens.GRCh38.dna_sm.primary_assembly_splice_sites.txt
hisat2_extract_splice_sites.py $gtf > ${gtf.baseName}.splice_sites.txt

# star
STAR --runThreadN 32 --runMode genomeGenerate --genomeDir . --genomeFastaFiles ../WholeGenomeFasta/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa --sjdbGTFfile ../../Annotation/Genes/Homo_sapiens.GRCh38.110.gtf

STAR --runMode genomeGenerate --genomeDir star/ --genomeFastaFiles $fasta --sjdbGTFfile $gtf --runThreadN $task.cpus $memory ${args.join(' ')}

# bismark
bismark_genome_preparation --parallel 4 .

bismark_genome_preparation $args BismarkIndex

# gtf
VERSION=110
wget -L ftp://ftp.ensembl.org/pub/release-$VERSION/gtf/homo_sapiens/Homo_sapiens.GRCh38.$VERSION.gtf.gz

# gff
VERSION=110
wget -L ftp://ftp.ensembl.org/pub/release-$VERSION/gff3/homo_sapiens/Homo_sapiens.GRCh38.$VERSION.gff3.gz

# bed12
# readme
# blacklist
# salmon
salmon index --threads $task.cpus -t $gentrome -d decoys.txt $args -i salmon

# rsem
STAR --runMode genomeGenerate --genomeDir rsem/ --genomeFastaFiles $fasta --sjdbGTFfile $gtf --runThreadN $task.cpus $memory $args2
rsem-prepare-reference --gtf $gtf --num-threads $task.cpus ${args_list.join(' ')} $fasta rsem/genome

rsem-prepare-reference --gtf $gtf --num-threads $task.cpus $args $fasta rsem/genome

# bbsplit
bbsplit.sh -Xmx${avail_mem}M ref_primary=$primary_ref ${other_refs.join(' ')} path=bbsplit threads=$task.cpus $args
bbsplit.sh -Xmx${avail_mem}M $index_files threads=$task.cpus $fastq_in $fastq_out refstats=${prefix}.stats.txt $args
