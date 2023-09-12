from snakemake.utils import min_version
import os

#################################
# Setting
#################################
# Minimum Version of Snakemake
min_version("7.30.1")

# Docker Container
container: 'docker://koki/urchin_workflow_seurat:20230111'

RANK_INDEX = [str(x) for x in list(range(2, 10 + 1))]
LAMBDA_INDEX = [str(x) for x in list(range(-5, 5 + 1))]
TRIAL_INDEX = [str(x) for x in list(range(1, 5 + 1))]

# All Rules
rule all:
	input:
		expand('plot/nmf/{rank}/{t}', rank=RANK_INDEX, t=TRIAL_INDEX),
		expand('plot/sbmf/{l}/{t}', l=LAMBDA_INDEX, t=TRIAL_INDEX),
		'plot/sbmf/b3'

rule dimplot_rank:
	input:
		'data/seurat.RData',
		'output_seurat/nmf/{rank}/{t}.RData'
	output:
		'plot/nmf/{rank}/{t}'
	benchmark:
		'benchmarks/dimplot_rank_{rank}_{t}.txt'
	log:
		'logs/dimplot_rank_{rank}_{t}.log'
	shell:
		'src/dimplot.sh {input} {output} >& {log}'

rule dimplot_lambda:
	input:
		'data/seurat.RData',
		'output_seurat/sbmf/{l}/{t}.RData'
	output:
		'plot/sbmf/{l}/{t}'
	benchmark:
		'benchmarks/dimplot_lambda_{l}_{t}.txt'
	log:
		'logs/dimplot_lambda_{l}_{t}.log'
	shell:
		'src/dimplot.sh {input} {output} >& {log}'

rule dimplot_b3:
	input:
		'data/seurat.RData',
		'output_seurat/BIN_DATA.tsv'
	output:
		'plot/sbmf/b3'
	benchmark:
		'benchmarks/dimplot_b3.txt'
	log:
		'logs/dimplot_b3.log'
	shell:
		'src/dimplot_b3.sh {input} {output} >& {log}'
