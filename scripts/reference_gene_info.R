library(biomaRt)

# loading Ensembl database
ensembl = useEnsembl(biomart = "ensembl", dataset = "mmusculus_gene_ensembl")

# extracting target information
attributes = listAttributes(ensembl)

target_info = c("Gene stable ID", "Gene % GC content", "Chromosome/scaffold name", 
                "Gene start (bp)", "Gene end (bp)", "Gene name", "NCBI gene ID", 
                "Transcript length (including UTRs and CDS)", "Transcript support level (TSL)")
table_ensembl = getBM(attributes = attributes$name[match(target_info, attributes$description)], mart = ensembl)
write.table(table_ensembl, "~/HPC/turing/pipelines/CNVkit_RNAseq/ensembl-gene-info.mm10.tsv", col.names = T, row.names = F, sep = "\t", quote = F)
