require(ggplot2)

# Prepare data
Douglas <- read.csv("data/DF Plot Data (Norm_6190 Climate).csv")
Douglas$PPT_sm[which(Douglas$PPT_sm == -1)] <- NA # remove incorrect value 
Douglas <- na.omit(Douglas)
row.names(Douglas) <- NULL # reset the rownames to index

Douglas <- Douglas[,c(1:5,7, 9, 11, 15, 17)]
Douglas$TD2 <- Douglas$TD^2
Douglas$MWMT2 <- Douglas$MWMT^2
Douglas$PPT_sm2 <- Douglas$PPT_sm^2


# Load Optima caluclations
load("Rdata/Proj_Opts2.Rdata") # note: load either Opts or Proj_Opts: Proj Opts are additionally projected to closest points in true data by euclidean distance.
Opts <- as.data.frame(Proj_Opts)
names(Opts) <- c("TD", "PPT_sm", "MWMT")

load("Rdata/clusters2.Rdata")
useCluster <- clusters2[[6]]$cluster

Opts <- as.data.frame(cbind(Opts, useCluster))

Opts$TD[which(Opts$useCluster==4)] <- Opts$TD[which(Opts$useCluster==4)]+0.5 
Opts$TD[which(Opts$useCluster==3)] <- Opts$TD[which(Opts$useCluster==3)]-0.5 
Opts$MWMT[which(Opts$useCluster==4)] <- Opts$MWMT[which(Opts$useCluster==4)]+0.5 
Opts$MWMT[which(Opts$useCluster==3)] <- Opts$MWMT[which(Opts$useCluster==3)]-0.5 
Opts$PPT_sm[which(Opts$useCluster==1)] <- Opts$PPT_sm[which(Opts$useCluster==1)]+0.5 


### Geom Count Plot ###
#######################

pp1 <- ggplot()+ xlim(c(0,45)) + ylim(0,45) +
  geom_point(data=Douglas[Douglas$PRES==0,], aes(x=TD, y=sqrt(PPT_sm), col=PRES), color ="grey80", alpha=0.5)+
  geom_point(data=Douglas[Douglas$PRES==1,], aes(x=TD, y=sqrt(PPT_sm), col=PRES), color ="grey70", alpha=0.5 )+
  geom_count(data=Opts, aes(x=TD, y=sqrt(PPT_sm), col=as.factor(useCluster))) +
  labs(y=expression(sqrt(PPT_sm)* ' [mm]'), x=expression("TD ["*~degree*C*"]")) +
  ggsci::scale_color_d3(name="Cluster") +
  theme_bw() + theme(aspect.ratio = 1, axis.title.x = element_text(size = 14),
                     axis.title.y = element_text(size=14), legend.position = "none",
                     axis.text  = element_text(size=12),
                     panel.grid = element_blank(), plot.margin = margin(4.5,5.5,4.5,5.5, "pt"))


pp2 <- ggplot()+ xlim(c(0,45)) + ylim(0,45) +
  geom_point(data=Douglas[Douglas$PRES==0,], aes(x=MWMT, y=TD, col=PRES), color ="grey80", alpha=0.5 )+
  geom_point(data=Douglas[Douglas$PRES==1,], aes(x=MWMT, y=TD, col=PRES), color ="grey70", alpha=0.5 )+
  geom_count(data=Opts, aes(x=MWMT, y=TD, col=as.factor(useCluster)), alpha=0.9 ) +
  labs(y=expression("TD ["*~degree*C*"]"), x=expression("MWMT ["*~degree*C*"]")) +
  ggsci::scale_color_d3(name="Cluster") +
  theme_bw() + theme(aspect.ratio = 1, axis.title.x = element_text(size = 14),
                     axis.title.y = element_text(size=14), legend.position = "none",
                     axis.text = element_text(size=12),
                     panel.grid = element_blank(), plot.margin = margin(4.5,5.5,4.5,5.5, "pt"))


pp3 <- ggplot()+ xlim(c(0,45)) + ylim(0,45) +
  geom_point(data=Douglas[Douglas$PRES==0,], aes(x=sqrt(PPT_sm), y=MWMT, col=PRES), color ="grey80", alpha=0.5 )+
  geom_point(data=Douglas[Douglas$PRES==1,], aes(x=sqrt(PPT_sm), y=MWMT, col=PRES), color ="grey70", alpha=0.5 )+
  geom_count(data=Opts, aes(x=sqrt(PPT_sm), y=MWMT, col=as.factor(useCluster)), alpha=0.9) +
  labs(y=expression("MWMT ["*~degree*C*"]"), x=expression(sqrt(PPT_sm)* ' [mm]')) +
  ggsci::scale_color_d3(name="Cluster") +
  theme_bw() + theme(aspect.ratio = 1, axis.title.x = element_text(size = 14),
                     axis.title.y = element_text(size=14), legend.position = "none",axis.text = element_text(size=12), panel.grid = element_blank(), plot.margin = margin(4.5,5.5,4.5,5.5, "pt"))

###Violinplot###
################

v1 <- ggplot(Opts, aes(as.factor(useCluster), TD, fill=as.factor(useCluster)))+
  geom_violin() + ylim(0,45) + theme_bw() +
  ggsci::scale_fill_d3(name="Ecotype") +
  labs(x="Cluster", y=expression("TD ["*~degree*C*"]")) +
  theme(axis.title.x = element_text(size = 14), axis.text.x = element_text(size=12), axis.line.y = element_line(),axis.text.y = element_text(size=12),
        axis.title.y = element_text(size=14), 
        legend.position = "none", aspect.ratio = 1, plot.margin = margin(6,5.5,.5,5.5, "pt"), panel.background = element_blank(), panel.grid = element_blank()) + coord_flip() 
  
v2 <- ggplot(Opts, aes(as.factor(useCluster), MWMT, fill=as.factor(useCluster)))+
    geom_violin() + theme_bw() + ylim(0,45) +
    ggsci::scale_fill_d3(name="Ecotype") +
    labs(x="Cluster", y=expression("MWMT ["*~degree*C*"]"))+
    theme(axis.text.y = element_text(size=12), axis.line.y = element_line(),
          axis.title.y = element_text(size=14), axis.title.x = element_text(size = 14), legend.position = "none", aspect.ratio = 1, plot.margin = margin(6,5.5,.5,5.5, "pt"), axis.text.x = element_text(size=12), panel.background = element_blank(),panel.grid = element_blank())+coord_flip()

v3 <- ggplot(Opts, aes(as.factor(useCluster), sqrt(PPT_sm), fill=as.factor(useCluster)))+ theme_bw() + ylim(0,45) +
    geom_violin() +
    ggsci::scale_fill_d3(name="Ecotype") +
    labs(x="Cluster", y=expression(sqrt(PPT_sm)* ' [mm]'))+
    theme(axis.title.x = element_text(size = 14),
           axis.text.y = element_text(size=12), axis.title.y = element_text(size=14), axis.line.y = element_line(), plot.margin= margin(6,5.5,.5,5.5, "pt"),
          legend.position = "none", aspect.ratio = 1, axis.text.x = element_text(size=12), panel.background = element_blank(),panel.grid = element_blank())+coord_flip()

### Combine Geomcount and Violin Plots ###

# TO DO:

# 1. Align first and second row perfectly and more like a ggplot facet. Move labels of the x axis to the top row. That would in my opinion require ticks for the first row.

### Arranging and Saving the plot###

# with rotation, by colum
pdf("figures/Optima2.pdf", height=7.5, width = 10)
ggpubr::ggarrange(v1,v2, v3, pp1,pp2,pp3,
            ncol = 3, nrow = 2, align = "v", 
            widths = c(1,1,1), heights = c(1,1,1),
            common.legend = TRUE, legend = "bottom",
            vjust=.5)

dev.off()
