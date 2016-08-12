# BAMM: Bayesian Analysis of Macroevolutionary Mixtures

### What does BAMM do?

Often in evolutionary biology we are interested in how clades (and their traits) diversify. 
The simplest models for looking at this are birth death models, where there is a rate of speciation (birth) and a rate of extinction (death) and these combine to get a rate of diversification (speciation - extinction). If diversification rates are high we tend to find phylogenies with lots of species.

The problem with these simple models is that they estimate a single rate of speciation and extinction across a whole tree.
Obviously this is a huge oversimplification; we expect lots of changes in rates through time, especially across fairly large trees (e.g. at points where a clade experiences an adaptive radiation, or where the climate changes).
BAMM deals with this issue by allowing rates to vary across the tree. 

More precisely, BAMM identifies discrete shifts in rate at nodes of a tree (either of speciation or of trait evolution), i.e places where rates speed up or slow down. BAMM looks for shifts across the whole tree, so it can find 1, 2, 3 or more shifts in rate. It is biased towards simpler models (a common tactic in most evolutionary models - remember parsimony?) so rarely results in lots of rate shifts.

### What does BAMM output?

#### Marginal shift probabilities
These are the probability of a shift occurring on a particular branch, ignoring everything else on the tree. This means that if you have more than one branch with a marginal probability, these are not independent of one another. In fact it is quite likely that they can't occur on the same tree. Care is needed in interpreting these. They tell you very little about rate heterogenity in your dataset.

#### Distinct shift configurations
These are the most probable configuration of shifts on one tree from the posterior. For example, a shift configuration may be a speed up at node 34 and a slow down at node 22. These are independent. Each tree in the posterior might have a different shift configuration, or they might all be very similar. 

### Credible shift sets
The number of possible distinct shift configurations is huge. Eventually if you looked for long enough you'd find a shift on every branch (because the branches can show shifts due to the effect of the prior alone). Not all these shifts are going to be significant. BAMM splits shifts into important ones that help explain the data (core shifts) and ones that are just due to priors using the marginal odds ratios. Specifically, BAMM computes the marginal odds ratio for each a rate shift for every branch in the phylogeny. It then excludes all shifts that are unimportant using a pre-determined threshold value. The remaining shifts are the credible shift set. Usually the threshold is 5. In R you get this using the function:

```r
credibleShiftSet
```

### Overall best shift configuration
You can get this by looking at the maximum a posteriori (MAP) probability shift configuration, i.e. the one that was sampled the most often. There are other ways to estimate this but MAP is preferred.

### Macroevolutionary cohorts
The cohort matrix depicts the pairwise probability that any two lineages share the same macroevolutionary rate dynamics. This makes pretty coloured block diagrams.

### Assumptions and issues

  1. Assumes that evolutionary dynamics are described by _discrete_ shifts at nodes. It could equally be gradual changes along branches. BAMM cannot detect this, but neither can any other method.
  2. The prior for the number of expected shifts will have a large effect on how many shifts are detected, particularly for long branches as the probability of seeing a shift due to the prior alone increases with branch length. To solve this BAMM 2.0 and above estimate marginal odds ratios, scaling each marginal shift probability by the prior and branch length.


### More detailed BAMM

