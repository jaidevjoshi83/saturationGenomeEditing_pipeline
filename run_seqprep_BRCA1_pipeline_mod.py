 #run_seqprep_BRCA1_pipeline.py
#to be run in the folder for the experiment with all the reads split by sample as fastq.gz files
#generates a shell script to run
#requires no underscores to be in sample names (later script will switch from dashes to underscores)
#outputs the stats from each seqprep call to a file called seqprep_stats.txt

import os
import glob
import sys
import subprocess

working_dir = os.getcwd()
print(working_dir)
#command_file_name = working_dir+"/run_seqprep.sh"
#command_file = open(command_file_name, 'w')

################### Initial path #########################
path_to_fq_files = working_dir +'/test'
path_to_out_files = working_dir + '/outputs'
print(path_to_out_files)

############# Creating Directories ###############################################
if not os.path.exists(path_to_out_files):
    os.makedirs(path_to_out_files)

R1s = glob.glob(path_to_fq_files+'/*_1.fastq')
R2s = glob.glob(path_to_fq_files+'/*_2.fastq')


for i,n in enumerate(R1s):
    n.split('/')[len(n.split('/'))-1].split('_')[len(n.split('/')[len(n.split('/'))-1].split('_'))-2]
    print(n)
    #print n.split('/')[len(n.split('/'))-1].split('_')[len(n.split('/')[len(n.split('/'))-1].split('_'))-2]

    for r in R2s:
        if n.split('/')[len(n.split('/'))-1].split('_')[len(n.split('/')[len(n.split('/'))-1].split('_'))-2] in r:
                print(r)
                os.environ['R1'] = n
                os.environ['R2'] = r
                os.environ['R1_out'] = path_to_out_files+'/'+n.split('/')[len(n.split('/'))-1].strip('.fastq')+'_out.fastq'
                os.environ['R2_out'] = path_to_out_files+'/'+r.split('/')[len(n.split('/'))-1].strip('.fastq')+'_out.fastq'
                os.environ['merged'] = path_to_out_files+'/'+r.split('/')[len(n.split('/'))-1].strip('.fastq')+'_merged.fastq'
                os.system('SeqPrep -f $R1 -r $R2 -1 $R1_out -2 $R2_out -A GGTTTGGAGCGAGATTGATAAAGT -B CTGAGCTCTCTCACAGCCATTTAG -M 0.1 -s $merged -m 0.001 -q 20 -o 20')

#notes for seqprep
'''
adapter trimming for A and B param's:
-A GGTTTGGAGCGAGATTGATAAAGT #if PU1R is used (as seen in R1):  
-B CTGAGCTCTCTCACAGCCATTTAG #if PU1L is used (as seen in R2): 
-M 0.1
'''