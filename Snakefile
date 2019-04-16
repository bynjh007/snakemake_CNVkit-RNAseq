from os import path

import numpy as np
import pandas as pd

################################################################################
# Globals                                                                      #
################################################################################

samples = pd.read_csv(config['samples'], sep='\t')

# default path for analysis
data_path = config["path"]["data"]
pipe_path = config["path"]["pipeline"]

# directory for output files
cnv_input_dir = config["path"]["input"]
cnv_output_dir = path.join(data_path, 'cnv_output')
log_dir = path.join(data_path, 'log')

################################################################################
# Functions                                                                    #
################################################################################

def get_samples():
    return set(samples['sample'])


def format_options(options):
    return ' '.join(options or [])


################################################################################
# Rules                                                                        #
################################################################################
rule all:
     input:
         expand(path.join(cnv_output_dir, '{sample}.pdf'), 
         	sample = get_samples())


rule cnvkit_RNAseq:
    input:
        expand(path.join(cnv_input_dir, '{sample}.txt'),
            sample = get_samples())        
    output:
        summary = path.join(cnv_output_dir, 'output.txt'),
        cnr = expand(path.join(cnv_output_dir, '{sample}.cnr'),
            sample = get_samples()) 
    params:
        options = format_options(config['cnvkit']['options']),
        out_dir = cnv_output_dir
    log:
        path.join(log_dir, 'cnvkit.log')
    shell:
        'cnvkit.py import-rna {params.options} -o {output.summary} '
        '--output-dir {params.out_dir} {input}'


rule cnvkit_segment:
    input:
        path.join(cnv_output_dir, '{sample}.cnr')
    output:
        path.join(cnv_output_dir, '{sample}.cns')
    shell:
        'cnvkit.py segment {input} -o {output}'


rule cnvkit_plot:
    input:
        cns = path.join(cnv_output_dir, '{sample}.cns'),
        cnr = path.join(cnv_output_dir, '{sample}.cnr')
    output:
        path.join(cnv_output_dir, '{sample}.pdf')
    shell:
        'cnvkit.py scatter {input.cnr} -s {input.cns} -o {output}'







