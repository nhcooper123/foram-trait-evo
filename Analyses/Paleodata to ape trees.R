# Create ape phylogenies that can be used in other applications

rm(list = ls())

# To install (not on CRAN)
# install.packages("paleoPhylo", repos="http://R-Forge.R-project.org")

# For ease of analysis setwd, this will be different for each user
# but with same folder structure as GitHub repo this will then work 
# in the same way for anyone.
# i.e. /Data should contain data
# setwd("~/Projects/foram-trait-evo")

# Load libraries
library(paleoPhylo)

# Read in data
bilineage <- read.csv("Data/BifurcatingLineageTree.csv")   
bimorph <- read.csv("Data/BifurcatingMorphoTree.csv")   
lineage <- read.csv("Data/LineageTree.csv")             
morph <- read.csv("Data/MorphoTree.csv")

# Create paleoPhylo objects
bilineage.pp<- with(bilineage, as.paleoPhylo(nm = Lineage.code, pn = Ancestor.code, 
	                                st = Start.date, en = End.date, label = Species.in.lineage))
bimorph.pp<- with(bimorph, as.paleoPhylo(nm = Species.code, pn = Ancestor.code, 
	                                st = Start.date, en = End.date, label = Species.code))	                               
lineage.pp<- with(lineage, as.paleoPhylo(nm = Lineage.code, pn = Ancestor.code, 
	                                st = Start.date, en = End.date, label = Lineage.code))
morph.pp<- with(morph, as.paleoPhylo(nm = Species, pn = Ancestor, 
	                                st = Start.date, en = End.date, label = Species))

# Draw phylogenies
drawPhylo(bilineage.pp)
drawPhylo(bimorph.pp)
drawPhylo(lineage.pp)
drawPhylo(morph.pp)

# Convert to ape format
bilineage.ape <- buildApe(createBifurcate(bilineage.pp))
bimorph.ape <- buildApe(createBifurcate(bimorph.pp))
lineage.ape <- buildApe(createBifurcate(lineage.pp))
morph.ape <- buildApe(createBifurcate(morph.pp))

# Write out to Data folder
write.tree(phy = bilineage.ape, file = "Data/bilineage.tre")
write.tree(phy = bimorph.ape, file = "Data/bimorph.tre")
write.tree(phy = lineage.ape, file = "Data/lineage.tre")
write.tree(phy = morph.ape, file = "Data/morph.tre")