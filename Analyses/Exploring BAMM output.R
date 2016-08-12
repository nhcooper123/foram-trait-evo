
library(coda)
library(BAMMtools)

tree <- read.tree("Data/bimorph.tre")
edata <- getEventData(tree, eventdata = "BAMM/event_data.txt", burnin = 0.1)
plot.bammdata(edata, lwd = 2)

mcmcout <- read.csv("BAMM/mcmc_out.txt", header = TRUE)
plot(mcmcout$logLik ~ mcmcout$generation)

burnstart <- floor(0.1 * nrow(mcmcout))
postburn <- mcmcout[burnstart:nrow(mcmcout), ]


effectiveSize(postburn$N_shifts)
effectiveSize(postburn$logLik)

post_probs <- table(postburn$N_shifts) / nrow(postburn)
names(post_probs)
post_probs['X'] / post_probs['Y']

shift_probs <- summary(edata)


postfile <- "BAMM/post_mcmc_out.txt"
bfmat <- computeBayesFactors(postfile, expectedNumberOfShifts=1, burnin=0.1)

plotPrior(mcmc.whales, expectedNumberOfShifts=1)

library(viridis)

plot.bammdata(best, lwd = 2, pal = plasma(4))