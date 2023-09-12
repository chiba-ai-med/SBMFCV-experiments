library("Seurat")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]

# Loading
load(infile1)
U <- read.delim(infile2, header=FALSE)

# Assign Labels
for(i in seq_len(ncol(U))){
     cmd <- paste0("seurat.dapt$bindata_", i, " <- U[, i]")
     eval(parse(text=cmd))
}

# Plot dapt
for(i in seq_len(ncol(U))){
     filename1 <- paste0(outfile, "_", i, ".png")
     filename2 <- paste0(outfile, "_", i, "_splitby.png")
     groupname <- paste0("bindata_", i)
     # Plot
     g <- DimPlot(seurat.dapt, reduction = "umap", group.by=groupname, label=TRUE, pt.size=2, label.size=6, cols=c(4,2)) + NoLegend()
     png(file=filename1, width=600, height=600)
     print(g)
     dev.off()
     # Plot
     g <- DimPlot(seurat.dapt, reduction = "umap", group.by=groupname, split.by="sample",
         ncol=5, label=TRUE, pt.size=2, label.size=6, cols=c(4,2)) + NoLegend()
     png(file=filename2, width=2400, height=600)
     print(g)
     dev.off()
}

# Save
file.create(outfile)
