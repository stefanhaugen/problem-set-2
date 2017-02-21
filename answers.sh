#problem-set-2

fasta="$HOME/temp/data-sets/fasta"
bed="$HOME/temp/data-sets/bed"
bedtools="$HOME/temp/data-sets/bedtools"

# question 1
# use BEDtools intersect to identify the size of the largest overlap
# between CTCF and H3K4me3 locations

answer_1=$( gzcat $bed/encode.tfbs.chr22.bed.gz | awk '($4 == "CTCF")' | bedtools intersect -a $bed/encode.tfbs.chr22.bed.gz -b $bed/encode.h3k4me3.hela.chr22.bed.gz -wo | cut -f15 | sort -n | tail -n1 )

echo "answer-1= $answer_1"

# question 2
# Use BEDtools to calculate the GC content of
# nucleotides 19,000,000 to 19,000,500 on chr22 of hg19 genome build
# Report the GC content as a fraction (e.g., 0.50).

answer_2=$( bedtools nuc -fi $fasta/hg19.chr22.fa -bed $bed/interval.bed | cut -f5 | tail -n1)

echo "answer-2= $answer_2"

# question 3
# Use BEDtools to identify the length of the CTCF ChIP-seq peak (i.e., interval) that has the largest mean signal in ctcf.hela.chr22.bg.gz

answer_3=$( bedtools map -c 4 -o mean -a $bed/encode.tfbs.chr22.bed.gz -b $bedtools/ctcf.hela.chr22.bg.gz | awk 'BEGIN {FS="\t"} ($5 !=".")' | sort -k5g | awk 'BEGIN {OFS="\t"} {print $0, $3 -$2}' | cut -f6 | tail -1 )

echo "answer-3= $answer_3"


# question 4
#Use BEDtools to identify the gene promoter (defined as 1000 bp upstream of a TSS) with the highest median signal in ctcf.hela.chr22.bg.gz. Report the gene name (e.g., 'ABC123')

answer_4=$( bedtools map -c 4 -o median -a $bed/tss.hg19.chr22.bed.gz -b $bedtools/ctcf.hela.chr22.bg.gz | awk 'BEGIN {OFS="\t"} ($7 !=".")' | sort -k7g | cut -f4 | tail -n1 )

echo "answer-4= $answer_4"

# question 5
# Use BEDtools to identify the longest interval on chr22 that is not
# covered by genes.hg19.bed.gz. Report the interval like chr1:100-500.

answer_5=$( bedtools intersect -v -a $bedtools/ctcf.hela.chr22.bg.gz -b $bed/genes.hg19.bed.gz | awk 'BEGIN {OFS="\t"} {print $0, $3 - $2}' | sort -k5n | awk '{print $1 ":" $2 "-" $3}' | tail -1 )

echo "answer-5= $answer_5"

# extra credit question 6: use a bedtools feature we haven't yet used
# creatively
#Here is the longest interval that exists in genes.hg19.bed.gz and not in
# lamina.bed 
answer_6=$( bedtools subtract -A -a $bed/lamina.bed -b $bed/genes.hg19.bed.gz | awk 'BEGIN {OFS="\t"} {print $1, $3 - $2}' | sort -k2n | tail -n1 )

echo "answer-6= $answer_6"

