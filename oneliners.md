1.  [File logistics](#datatrans)
2.  [Useful bash](#bash)
3.  [Handling text files](#txt)
4.  [Handling .fa files](#fasta)
5.  [Handling .fq files](#fastq)
6.  [Handling .sam files](#sam)
7.  [Handling .vcf files](#vcf)
8.  [Server on local Network](#serverStuff)
9.  [Bits and pieces](#bitsNpieces)

File logistics <a name="datatrans"></a>
=======================================

Check md5sums:

    md5sum -c MD5.txt

Compressing directory

    tar -zcvf archive-name.tar.gz directory-name
    tar -cJf foo.tar.xz foo/
    tar cf - paths-to-archive | pigz -9 -p 32 > archive.tar.gz
    tar cf - test/ | pxz -T 3 > test.tar.xz

Uncompressing directory

    tar -xvf {file.tar}
    tar -zxvf {foo.tar.gz}
    tar xvjf filename.tar.bz2
    tar xvfJ filename.tar.xz

List content of compressed directory

    tar -tvf foo.tar.gz

Encrypt/Decrypt a folder

    tar -cz phenotypes | openssl enc -aes-256-cbc -e > phenotypes.tar.gz.enc
    openssl enc -aes-256-cbc -d -in phenotypes.tar.gz.enc | tar xz
    openssl enc -aes-256-cbc -d -in 00_README.tar.xz.enc | tar -xvJ

Useful bash <a name="bash"></a>
===============================

Check *what's going on* [using htop](https://hisham.hm/htop/) (kill
jobs)

    htop # quit by pressing q, needs to be istalled by user

Checking free disk space

    df -h ./

List of files/ show the combined size of directory

    du -a -h --max-depth=1 | sort -hr
    du  -sh

Ommiting terminal standard output

    > /dev/null

Make a script executable

    chmod 755 <script.sh>

Fancy colors

    RED='\033[0;31m'
    NC='\033[0m' # No Color
    echo -e "I ${RED}love${NC} Stack Overflow"

    ## I [0;31mlove[0m Stack Overflow

0-pad numbers

    for k in 1 45 142; do
        q=$(printf "%03d\n" $k) ;
        echo "$k: $q";
    done

    ## 1: 001
    ## 45: 045
    ## 142: 142

echo to stderr

    (>&2 echo "--- test ---")

    ## --- test ---

Textfile handling: <a name="txt"></a>
=====================================

Extracting lines from file

    sed -n '2,3p' test1.txt > test2.txt

    echo -e "1\n2\n3\n4\n5" | sed -n '2,3p'

    ## 2
    ## 3

Deleting a character from textfile

    sed 's/[|]//g' in_file.txt

    echo  "A|BCD|E" | sed 's/[|]//g'

    ## ABCDE

remove every other linebreak

    cat in_file.fa | paste - - > out_file.txt

    echo -e ">head1\nATGCG\n>head2\nTGCGT" | paste - -

    ## >head1   ATGCG
    ## >head2   TGCGT

Remove lines containing pattern

    sed '/ PATTERN/d' in_file.txt
    #or
    grep -v  'PATTERN' in_file.txt

Add linebreack after pattern (Mac)

    sed 's/>* /\'$'\n/g'

`awk` number format

    echo -e "1\t3" | \
    awk -v OFS="\t" '{print sprintf( "%.0f",($1/$2)),sprintf( "%.3f",$1/$2)}' 

    ## 0    0.333

Extract text between "textsw{text}"

    echo '... analysis was done using \textsw{R} and  \textsw{Nextflow}.' | \
    perl -lne 'print $1 while (/textsw\{(.*?)\}/g)'

    ## R
    ## Nextflow

Extract lines based on index file

    awk 'FNR==NR{a[$1];next}FNR in a' line_index.txt data.txt 

Use awk with multiple output (separate header from body)

    awk '{ if (substr($1,1,1) ~ /^[#]/ ){ print $0 > "in_file.rewrite.txt"} else {print $0 > "in_file.body.txt"}}' in_file.txt

fasta handling <a name="fasta"></a>
===================================

Basic stats (using [seqkit](https://github.com/shenwei356/seqkit))

    seqkit stat [file.fa/file.fa.gz/file.fq.gz] > stats.txt

Splitting a fastq file

    split -l (4*n) in_file.fq segment

Merging fasta files

    zcat dat1.fa.gz dat2.fa.gz dat3.fa.gz | \
    gzip > dat_combined.fa.gz
    # or
    zcat dat*.fa.gz | \
    gzip > dat_combined.fa.gz

Linebreak every 80 chars (fasta formatting)

    fold -w 80 -s in_file.fa > out_file.fa

Unmask fasta files

    sed '/[>*]/!s/[atgcn]/\u&/g' in_file.fa

Hard-mask soft-masked fasta

    sed '/[>*]/!s/[atgcn]/N/g' in_file.fa

Filter fasta for min seqlength of 500 bp (using
[samtools](http://www.htslib.org/) &
[bedtools](https://bedtools.readthedocs.io/en/latest/))

    samtools faidx in_file.fa
    awk -v OFS='\t' '{if($2 > 500) print $1,"0",$2,$1}' in_file.fa.fai > select_seq.bed
    fastaFromBed -fi in_file.fa -bed select_seq.bed -name -fo  select_seq.fa

fastq handling <a name="fastq"></a>
===================================

Get fastq sizes

    awk '{if(NR%4==2) print length($1)}' in_file.fq | \
    sort -n | \
    uniq -c > read_length.txt

Get total bps of fq.gz file

    zcat in_file.fq.gz | \
    paste - - - - | \
    cut -f 2 | \
    tr -d '\n' | \
    wc -c

fastq -&gt; fasta

    gunzip -c in_file.fq.gz | \
    paste - - - - | \
    cut -f 1,2 | \
    sed 's/^@/>/' | \
    tr "\t" "\n" | \
    gzip > out_file.fa.gz

sam handling <a name="sam"></a>
===============================

Sort sam (only mapped - unmapped = -f, bam: add -b )

    samtools view -F 4 in_file.sam > in_file.mapped.sam

Sort bam

    samtools sort in_file.bam in_file.sorted

samtools -filter for mapping quality:

    samtools view -b -q 10 in_file.bam > in_file.filtered.bam

sam -&gt; bam (header there)

    samtools view -bS in_file.sam > in_file.bam

Directly to sorted bam

    samtools view -bS in_file.sam | \
    samtools sort -o in_file.sorted

bam to wig (coverage overview with
[IGV](http://software.broadinstitute.org/software/igv/))

    samtools depth in_file.bam | \
    perl -ne 'BEGIN{ print "track type=print wiggle_0 name=fileName description=fileName\n"}; ($c, $start, $depth) = split; if ($c ne $lastC) { print "variableStep chrom=$c span=10\n"; };$lastC=$c; next unless $. % 10 ==0;print "$start\t$depth\n" unless $depth<3' \
    > in_file.wig

vcf handling: <a name="vcf"></a>
================================

Get sample names from vcf file (alternative using
[vcflib](https://github.com/vcflib/vcflib))

    grep "#CHROM" in_file.vcf | \
    cut -f 10-
    # or quicker
    vcfsamplenames in_file.vcf

Index bam file

    samtools index in_file.sorted.bam

Serving on local network <a name="serverStuff"></a>
===================================================

Serve current folder acessible to other computers (port 80 requires sudo)

    sudo python3 -m http.server 80

Find own IP

    hostname -I

Video editing using ffmpeg
==========================

Strip audio from mp4 (mute)

    ffmpeg -i in.mp4 -map 0:0 -vcodec copy out.mp4

Crop video (start-time - end-time)

    ffmpeg -i in.mp4 -ss 00:00:12 -t 00:01:19 -async 1 out.mp4

Crop video (width:height:hoizontal_start:vertical_start)

    ffmpeg -i in.mp4 -filter:v "crop=out_w:out_h:x:y" out.mp4

Bits and pieces <a name="bitsNpieces"></a>
==========================================

Reformat vcftools HWE output for R input

    cat in_file.hwe | \
    tr '/' '\t' > in_file.hwe_t

Merging pdf (using [ghost script](https://www.ghostscript.com/))

    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=full_signed.pdf pages1-8.pdf page9_signed.pdf pages10-11pdf.pdf
    
Transforming pdf text into paths (copy-protect)
   
    gs -o file_out_paths.pdf -dNoOutputFonts -sDEVICE=pdfwrite file_in_text.pdf

Collpsing library notes for TOC
    
    grep -A 1 "^#" notes_file.md | sed 's/###\(.*\){\(.*\)}/- [\1](\2):/g;' | grep -v "^--" | paste - - | sed 's/[[:space:]]/ /g; s/\([\(\[]\) /\1/g; s/ \]/]/'
