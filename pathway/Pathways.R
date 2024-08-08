library(splines)
library(ggplot2)
library(reshape2)
library(stringr)
set.seed(0)

# Prefilter
samp='Adult_Mice'
data<-read.csv(paste0(samp,'_Day_BM_agg.csv'),row.names = 1)
colnames(data)<-gsub("X","",colnames(data))
thres = 0.05
data['value_ok'] <- rowSums(data>=thres)
data_ok <- data[!data$value_ok<3,]
data_ok <- data_ok[,colnames(data_ok)!="value_ok"]
data_ok <- data_ok[!is.na(data_ok[,1]),]
write.csv(data_ok,paste0(samp,'_Day_BM_agg_filtered.csv'))

samp='Zebrafish'
data<-read.csv(paste0(samp,'_Day_BM_agg.csv'),row.names = 1)
colnames(data)<-gsub("X","",colnames(data))
thres = 0.05
data['value_ok'] <- rowSums(data>=thres)
data_ok <- data[!data$value_ok<3,]
data_ok <- data_ok[,colnames(data_ok)!="value_ok"]
data_ok <- data_ok[!is.na(data_ok[,1]),]
write.csv(data_ok,paste0(samp,'_Day_BM_agg_filtered.csv'))

############ ANOVA ##############
samp1 <- 'Adult_Mice'
samp2 <- 'Zebrafish'
raw1 <- read.csv(paste0(samp1,'_Day_BM_agg_filtered.csv'),row.names = 1)
colnames(raw1)<-gsub("X","",colnames(raw1))
x1 = as.numeric(colnames(raw1))
y_all1 = data.matrix(raw1)
raw2 <- read.csv(paste0(samp2,'_Day_BM_agg_filtered.csv'),row.names = 1)
colnames(raw2)<-gsub("X","",colnames(raw2))
x2 = as.numeric(colnames(raw2))
y_all2 = data.matrix(raw2)

y_all1 <- y_all1[intersect(rownames(y_all1),rownames(y_all2)),]
y_all2 <- y_all2[intersect(rownames(y_all1),rownames(y_all2)),]
print(paste0('Rownames matched: ',all(rownames(y_all1)==rownames(y_all2))))

write.csv(y_all1,paste0(samp1,'_Day_BM_agg_matched.csv'))
write.csv(y_all2,paste0(samp2,'_Day_BM_agg_matched.csv'))

p_mat <- data.frame(p.ns=rep(-1,nrow(y_all1)),row.names = rownames(y_all1))
p_mat$term <- rownames(p_mat)

ptype = 'ns_group'
for(i in 1:nrow(y_all1)){
    y1 = y_all1[i,]
    y2 = y_all2[i,]
    comb_data = data.frame(y=c(y1, y2),
                           x=c(x1, x2),
                           group = factor(c(rep("m",length(x1)),rep("z",length(x2)))))
    model_int = lm(y~ns(x, df=3)*group, data=comb_data)
    
    p.ns <- anova(model_int)[3,'Pr(>F)'] # p.ns:group
    p_mat[i,'p.ns']=p.ns
  }
write.csv(p_mat,paste0('compare_Day_BM_',ptype,'_ANOVA.csv'))

#select
p_mat = read.csv(paste0('compare_Day_BM_',ptype,'_ANOVA.csv'),row.names = 1)

# Compare species
nb = 10
for(pselection in c('sig1','sig2')){
  for(ptype in c('ns_group')){
    p_mat = read.csv(paste0('compare_Day_BM_',ptype,'_ANOVA.csv'),row.names = 1)
    
    thres_p = 0.05
    p_mat_sig = p_mat[p_mat$p.ns<thres_p,]
    p_mat_sig = p_mat_sig[order(p_mat_sig$p.ns),]
    write.csv(p_mat_sig,'ANOVA_p_sig.csv')
    
    # p_mat_sig2 = p_mat_sig[11:nrow(p_mat_sig),]
    # write.csv(p_mat_sig2,'ANOVA_p_sig2.csv')
    
    # thres_p_unsig = 0.95
    # p_mat_unsig = p_mat[p_mat$p.ns>thres_p_unsig,]
    # p_mat_unsig = p_mat_unsig[order(p_mat_unsig$p.ns,decreasing = T),]
    # write.csv(p_mat_sig,'ANOVA_p_unsig.csv')
    
    if(pselection=='sig2'){
      p_data <- p_mat_sig2
      ptitle = paste0('ANOVA p.',ptype,'<',thres_p,' Top11-20')
    }else if(pselection=='sig1'){
      p_data <- p_mat_sig
      ptitle = paste0('ANOVA p.',ptype,'<',thres_p,' Top1-10')
    }else if(pselection=='unsig'){
      p_data <- p_mat_unsig
      ptitle = paste0('ANOVA p.',ptype,'>',thres_p_unsig,' Top1-10')
    }
    
    if(pselection=='sig_all'){
      p_data <- p_mat_sig
      nb=nrow(p_mat_sig)
      ptitle = paste0('ANOVA p.',ptype,'<',thres_p,' All')
    }
    
    datadf1 <- t(y_all1[p_data$term[1:nb],])
    rownames(datadf1) <- gsub("X","",rownames(datadf1))
    df1 <- melt(datadf1,varnames = c('day','term'))
    df1$species <- samp1
    datadf2 <- t(y_all2[p_data$term[1:nb],])
    rownames(datadf2) <- gsub("X","",rownames(datadf2))
    df2 <- melt(datadf2,varnames = c('day','term'))
    df2$species <- samp2
    
    ## Separated comparison
    df <- rbind(df1,df2)
    df$term <- str_to_sentence(gsub("GOBP_","",df$term))
    df$mean_expression <- df$value
    width_plot <- ifelse(pselection=='sig_all',20,11)
    height_plot <- ifelse(pselection=='sig_all',100,4)
    
    ggplot(df, aes(x=day, y=mean_expression,group=species)) +
      facet_wrap(~term,ncol = 5) +
      theme(strip.text = element_blank()) + 
      geom_line(aes(color=term))+
      #geom_line()+
      geom_point(aes(shape=species,color=term),size=1.5)+
      #geom_point(aes(shape=species),size=1.5)+
      #theme(legend.position = "bottom right") +
      ggtitle(ptitle)
    ggsave(paste0('p_',ptype,'./ANOVA_p.',ptype,'_',pselection,'.pdf'),
           height = height_plot,width = width_plot, limitsize = F)
  }
}


