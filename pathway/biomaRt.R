data<-read.csv('m5.gobp.csv')
genes_org<-data$SYMBOL
library(biomaRt)
library(xlsx)

mouse <- useMart('ensembl',dataset = "mmusculus_gene_ensembl",
                 host = "https://jan2020.archive.ensembl.org/"
                 )
fish <- useMart('ensembl',dataset = "drerio_gene_ensembl",
                 host = "https://jan2020.archive.ensembl.org/"
)

## Multirows
m5_gobp_T <- t(data)
data_source <- m5_gobp_T
res_all<-data.frame(matrix(nrow = 2100,ncol = 7796))
colnames(res_all)<-colnames(data_source)
for(l in 1:ncol(data_source)){
  res<-getLDS(attributes = "external_gene_name",
              filters = "external_gene_name",
              mart = mouse,
              attributesL = "external_gene_name",
              values = data_source[,i],
              martL = fish,
              uniqueRows = T)
  res<-res[!duplicated(res$Gene.name.1),]
  if(nrow(res)==0){next}
  res_all[1:nrow(res),l]<-res$Gene.name.1
}

write.csv(res_all,'D:\\Researches/MI/Final_Files/m5_gobp_dr.csv')

gmt <- t(res_all)
gmt <- gmt[!is.na(gmt[,1]),]
write.table(gmt,'D:\\Researches/MI/Final_Files/gobp_Zebrafish.gmt',sep = '\t',col.names = F,quote = F)
