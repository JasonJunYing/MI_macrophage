# MI_macrophage
## Macrophages in cardiac repair and regeneration after myocardial infarction

  1. Single cell sequencing data combined analysis:  
     To investigate the roles of macrophages in cardiac repair after myocardial infarction, we integrated 7 published mice (neonatal/adult) single-cell RNA sequencing datasets containing steady-state and infarcted heart samples at different timepoints: 1) [EMTAB7365](https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-7365) and [EMTAB7376](https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-7376) (Farbehi); 2) [EMTAB7895](https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-7895) (Forte); 3) [EMTAB9816](https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-9816) and [EMTAB9817](https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-9817) (Tombor); 4) [GSE102048](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE102048) (Kretzschmar); 5) [GSE132146](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE132146) (Ruiz); 6) [GSE146285](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE146285) (Molenaar); and 7) [GSE153480](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE153480) (Wang)
     
     To compare the roles of macrophages between regenerative and non-regenerative models, we also integrated 6 published zebrafish single-cell RNA sequencing datasets containing steady-state and injured heart samples at different post-injury timepoints: 1) [GSE138181](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE138181) (Koth); 2) [GSE153170](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE153170) (Bakker); 3) [GSE172511](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE172511) (Sun); 4) [GSE159032](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE159032) and [GSE158919](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE158919) (Hu); 5) [GSE188511](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE188511) (Kapuria); and 6) [GSE145980](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE145980) (Ma).
     
     These datasets were first preprocessed and analysed separatedly [(pre-analysis)](./preanalysis). Main steps included: 1)Quality control; 2)Normalization (10000 final counts, log-transformed); 3)Cell Cycle Assignment; 4)Select highly variable genes; 5)PCA and UMAP calculation
     
     Then, these datasets were integrated by normalized counts and used to conduct [(Combined_analysis_mice.ipynb, ](./annotation/Combined_analysis_mice.ipynb),[Combined_analysis_zebrafish.ipynb)](./annotation/Combined_analysis_zebrafish.ipynb):    
  (1) Highly variable genes selection (min_mean=0.02, max_mean=3, min_disp=0.3)  
  (2) PCA calculation  
  (3) Harmony integration (top 50 PCA)  
  (4) UMAP calculation  
  (5) Cell type definition

  2. Macrophage subset analysis:  
     Mice myeloid cells (macrophages, monocytes and dendritic cells) were defined by well-known markers (Plac8, Saa3, Arg1, C1qa, Cd68, Itgam, Cd74). The UMAP of the extracted myeloid was recalculated and subjected to leiden clustering. The clusters were further annotated according to gene expression. 12 macrophage clusters were named after their main marker genes. Cells from adult mice were extracted for downstream analysis [(Macrophages_mice.ipynb)](./annotation/Macrophages_mice.ipynb).
       
     For zebrafish the cell types were defined according to the annotation from Hu et al (GSE159032). Each non-Hu cell was assigned to the 15 closest neighbouring cells from the Hu data based on Euclidean distance calculated using the top 50 principle components and the cell type was assigned based on the most frequently occurring type. Wild-type zebrafish macrophages without DMSO/IWR/morphine treatment were extracted and annotated by scoring of the top 100 differentially expressed marker genes in mice macrophage subsets [(TransedMouse100Marker_Outer.csv)](./Files/TransedMouse100Marker_Outer.csv). Cells with scores > 0.05 were used for downstream analysis [(Macrophages_zebrafish.ipynb)](./annotation/Macrophages_zebrafish.ipynb).  
     
     
