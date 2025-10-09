####
#!/bin/sh

#### Coverage over states 
# written by Anna Malkowska 
# 13/07/2023

# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Coverage over states uses the bedtools coverage function to calculate a read coverage of a bam file over chromatin state bed file and generate a heatmap."
   echo
   echo "Syntax: coverage_over_states.sh -s statefile.bed -f bamfile.bam [-b|-o|-g|-r|-h]"
   echo "options:"
   echo "h     Print this Help."
   echo "s     Specify state file. Need to be bed format"
   echo "f     Specify bam file to map"
   echo "g     Specify chromosome sizes genome to map. Default is dm6.chrom.sizes"
   echo "b     Determine bin size. Default is 300bp."
   echo "o     Add a prefix to output files." 
   echo "r     Specify a custom order txt file with one column delineating the order of rows" 
   echo
}


# Set variables
Size="300"
Prefix=""
bedgraph=""
state=""
genome="dm6.chrom.sizes"
order=""

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts "hb:f:s:o:g:r:" option; do
   case $option in
	h) #Print help
	Help
	exit;;
        b) # Enter size
         Size=$OPTARG;;
        f) #Enter bam 
	  bam=$OPTARG;;
	s) #Enter state file 
	  state=$OPTARG;;
        o) # Enter prefix
	 Prefix=$OPTARG;;
	g) #Enter chromosome sizes file 
	genome=$OPTARG;;
	r) #enter custom order text file
	order=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

echo "Preparing files..."

####
#make a binned file   
bedtools makewindows -g $genome -w $Size > bins.bed.tmp

#remove header
tail -n +2 $state > state.bed.tmp

# sort both files
sort -k1,1 -k2,2n bins.bed.tmp > bins.sorted.bed.tmp
sort -k1,1 -k2,2n state.bed.tmp > state2.bed.tmp

#map bed onto bins
bedtools map -a bins.sorted.bed.tmp -b state2.bed.tmp -c 4 > state_binned.bed.tmp

#remove 'chr'
sed -e 's/...//' state_binned.bed.tmp > state_binned_nochr.bed.tmp

echo "Calculating coverage..."

#calculate coverage
bedtools coverage -a state_binned_nochr.bed.tmp -b $bam -sorted > $Prefix.coverage_bed.txt

#get no. of counts
samtools view -c $bam > $Prefix.count.txt

# remove tmp files 
rm -r *tmp* 

echo "Generating heatmap..."

### move to R
Rscript --vanilla ~/Brand/coverage_over/heatmap.R $Prefix.coverage_bed.txt $Prefix.count.txt $order

mv coverage.txt $Prefix.coverage.txt
