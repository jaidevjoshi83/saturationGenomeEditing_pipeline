#20170629_SGE2_Pipeline_X2X3X15X18X20X22_patch_from_sam_with_new_adds.sh
#use this patch AFTER running 20170722 script.
#L41N experiments are dubbed 'SGE2' for BRCA1


out_dir="/net/shendure/vol10/projects/SGE/nobackup/BRCA1/20170630_BRCA1_SGE2_X2X3X15X18X20X22"
#splits first on comma, then +
cigar_comparisons="X2rL41_pre+X2rL41_post,X2rL42_pre+X2rL42_post,X3rL41_pre+X3rL41_post,X3rL42_pre+X3rL42_post,X15rL41_pre+X15rL41_post,X15rL42_pre+X15rL42_post,X17rL41_pre+X17rL41_post,X17rL42_pre+X17rL42_post,X18rL41_pre+X18rL41_post,X18rL42_pre+X18rL42_post,X20rL41_pre+X20rL41_post,X20rL42_pre+X20rL42_post,X20rL43_pre+X20rL43_post,X22rL41_pre+X22rL41_post,X22rL42_pre+X22rL42_post"
amplicon_list="X2+X3+X15+X17+X18+X20+X22"
##first gets split on +'s for each experiment, and then split on commas for key and pairings.
exp_groupings="X2rL41,X2rL41_pre,X2rL41_post,X2_lib,X2_neg,X2rL41_rnagDNA+X2rL42,X2rL42_pre,X2rL42_post,X2_lib,X2_neg,X2rL42_rnagDNA+X3rL41,X3rL41_pre,X3rL41_post,X3_lib,X3_neg,X3rL41_rnagDNA+X3rL42,X3rL42_pre,X3rL42_post,X3_lib,X3_neg,X3rL42_rnagDNA+X15rL41,X15rL41_pre,X15rL41_post,X15_lib,X15_neg,X15rL41_rnagDNA+X15rL42,X15rL42_pre,X15rL42_post,X15_lib,X15_neg,X15rL42_rnagDNA+X17rL41,X17rL41_pre,X17rL41_post,X17_lib,X17_neg,X17rL41_rnagDNA+X17rL42,X17rL42_pre,X17rL42_post,X17_lib,X17_neg,X17rL42_rnagDNA+X18rL41,X18rL41_pre,X18rL41_post,X18_lib,X18_neg,X18rL41_rnagDNA+X18rL42,X18rL42_pre,X18rL42_post,X18_lib,X18_neg,X18rL42_rnagDNA+X20rL41,X20rL41_pre,X20rL41_post,X20_lib,X20_neg,X20rL41_rnagDNA+X20rL42,X20rL42_pre,X20rL42_post,X20_lib,X20_neg,X20rL42_rnagDNA+X20rL43,X20rL43_pre,X20rL43_post,X20_lib,X20_neg,X20rL43_rnagDNA+X22rL41,X22rL41_pre,X22rL41_post,X22_lib,X22_neg,X22rL41_rnagDNA+X22rL42,X22rL42_pre,X22rL42_post,X22_lib,X22_neg,X22rL42_rnagDNA"
#### end variables section
echo "Variables defined."
cd $out_dir/fastq #this only changes the reference in which the rest of the script is interpreted...
cd Seqprep/merged
cd no_Ns
cd sam

mkdir cigar_counts
python ~/bin/20170330_BRCA1_SGE_pipeline_cigar_analyzer.py $cigar_comparisons #not informative for RNA based on full length processing
head -15 cigar_counts/*.txt >> cigar_counts/combined_cigar_counts.txt
mkdir variant_counts_no_thresh
python ~/bin/sam_to_edits_wRNA_pipeline_20170517.py $amplicon_list $exp_groupings
#writes minimally thresholded output (set in hardcode (0.000001 in any) to variant_counts folder
cd variant_counts_no_thresh
#ALL CADD SCORES NOW IN SAME DIRECTORY FOR BRCA1 SGE project and scripts point there.
mkdir final
python ~/bin/annotate_variants_BRCA1_pipeline_20170622.py
cd final
head -6 *summary.txt >> combined_editing_data.txt
echo 'Pipeline finished, variants aligned, counted, and annotated.'
