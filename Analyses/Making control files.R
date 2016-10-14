# Create control files for foram project
# Assumes a set up where working directory has the following folders: 
# Functions, Data, ControlFiles, 
# Natalie Cooper

# Source functions needed
source("Functions/control_file_functions.R")
source("Functions/generateControlFile_fossils.R")

# Add BAMMtools library
library(BAMMtools)

# Read in trees 
tree <- read.tree("Data/bimorph.tre")

#--------------------------------------------------
# Define variables - this is the important bit!
#--------------------------------------------------

# Name of the tree or trees to use
treefile <- tree

#--------------------------------------------------
# Sampling
#--------------------------------------------------
# There are two options here:
# 1 - Use a "global" sampling probability, with a sampling probability.
useGlobalSamplingProbability <- 1        
globalSamplingFraction <- 1.0            

# 2 - Use species-specific sampling fractions from a file
# useGlobalSamplingProbability <- 0
# sampleProbsFilename = sample_probs.txt

#--------------------------------------------------
# Event configuration
#--------------------------------------------------

validateEventConfiguration <- c(0, 1)
# If 1, rejects proposals that cause a branch and both of its direct descendants to have 
# at least one event. Such an event configuration may cause the parameters of the parent 
# event to change to unrealistic values. If 0, no such proposals are immediately rejected.
# The default value is 0

#--------------------------------------------------
# BAMM priors
#--------------------------------------------------
# Requires several options to assess whether results are robust to the prior
expectedNumberOfShifts <- c(1:10, 25, 50, 100)

# Extract appropriate priors using BAMMtools
priors <- setBAMMpriors(treefile, outfile = NULL)

lambdaInit <- as.numeric(priors['lambdaInitPrior']),
lambdaShift <- as.numeric(priors['lambdaShiftPrior']),
muInit <- as.numeric(priors['muInitPrior'])

# Select a set of ten priors ranging from half the recommended value to twice 
# the recommended value, in ten steps. This is arbitrary but give a variety
# of values for the priors
lambdaInitPrior <- seq(from = lambdaInit/2, to = lambdaInit*2, length = 10)
lambdaShiftPrior <- seq(from = lambdaShift/2, to = lambdaShift*2, length = 10)
muInitPrior <- seq(from = muInit/2, to = muInit*2, length = 10)

#--------------------------------------------------
# MCMC settings
#--------------------------------------------------
# I've gone for high numbers here to help ensure convergence
# Number of generations to perform MCMC simulation
numberOfGenerations <- 10^9

# Frequency in which to write the MCMC output to a file
mcmcWriteFreq <- 10^6

# Frequency in which to write the event data to a file
eventDataWriteFreq <- 10^6

# Frequency in which to print MCMC status to the screen
printFreq <- 10^5

# Frequency in which to reset the acceptance rate calculation
# The acceptance rate is output to both the MCMC data file and the screen
acceptanceResetFreq <- 10^6

#-----------------------------------
# OPERATORS: MCMC SCALING OPERATORS
#-----------------------------------
# I have chosen an arbitrary range of these to determine effects on convergence etc.

# Scale parameter for updating the initial speciation rate for each process
updateLambdaInitScale <- 1:3 # default = 2.0

# Scale parameter for the exponential change parameter for speciation
updateLambdaShiftScale = c(0.1, 0.2, 0.5) # default = 0.1

# Scale parameter for updating initial extinction rate for each process
updateMuInitScale <- 1:3 # default = 2.0

# Scale parameter for updating LOCAL moves of events on the tree
# This defines the width of the sliding window proposal
# This parameter is specified in units of “total tree depth” to minimize scale
# dependence. 
updateEventLocationScale <- c(0.01, 0.05, 0.1) # default = 0.05

# Scale parameter (proportional shrinking/expanding) for updating
# the rate parameter of the Poisson process
updateEventRateScale <- c(2.0, 4.0, 6.0) # default = 4
 
#-----------------------------------
# OPERATORS: MCMC MOVE FREQUENCIES
#-----------------------------------

# Relative frequency of MCMC moves that change the number of events
updateRateEventNumber = 0.1

# Relative frequency of MCMC moves that change the location of an event on the
# tree. 
updateRateEventPosition = 1


updateRateEventRate = 1
# Relative frequency of MCMC moves that change the rate at which events occur 

updateRateLambda0 = 1
# Relative frequency of MCMC moves that change the initial speciation rate
# associated with an event

updateRateLambdaShift = 1
# Relative frequency of MCMC moves that change the exponential shift parameter
# of the speciation rate associated with an event

updateRateMu0 = 1
# Relative frequency of MCMC moves that change the extinction rate for a given
# event

updateRateLambdaTimeMode = 0
# Relative frequency of MCMC moves that flip the time mode
# (time-constant <=> time-variable)

localGlobalMoveRatio = 10.0
# Ratio of local to global moves of events 


################################################################################
# INITIAL PARAMETER VALUES
################################################################################

lambdaInit0 = 0.032
# Initial speciation rate (at the root of the tree)

lambdaShift0 = 0
# Initial shift parameter for the root process

muInit0 = 0.005
# Initial value of extinction (at the root)

initialNumberEvents = 0
# Initial number of non-root processes
 

#-------------------------------------------------------------
# METROPOLIS COUPLED MCMC
#-------------------------------------------------------------
# For now using defaults for number of chains and swap period
# Number of Markov chains to run
# numberOfChains <- 4
# Number of generations in which to propose a chain swap
# swapPeriod <- 1000

# Temperature increment parameter. This value should be > 0
# The temperature for the i-th chain is computed as 1 / [1 + deltaT * (i - 1)]
# Can use code to optimise this
deltaT <- c(0.01, 0.05, 0.1, 0.2) # default for small trees = 0.1

#--------------------------------
# NUMERICAL AND OTHER PARAMETERS
#--------------------------------

minCladeSizeForShift = 1
# Allows you to constrain location of possible rate-change events to occur
# only on branches with at least this many descendant tips. A value of 1
# allows shifts to occur on all branches. 

segLength = 0.02
# Controls the "grain" of the likelihood calculations. Approximates the
# continuous-time change in diversification rates by breaking each branch into
# a constant-rate diversification segments, with each segment given a length
# determined by segLength. segLength is in units of the root-to-tip distance of
# the tree. So, if the segLength parameter is 0.01, and the crown age of your
# tree is 50, the "step size" of the constant rate approximation will be 0.5.
# If the value is greater than the branch length (e.g., you have a branch of
# length < 0.5 in the preceding example) BAMM will not break the branch into
# segments but use the mean rate across the entire branch.
# ??? TINKER ???

#--------------------------------
# FOSSIL BAMM PRIORS & PARAMETERS
#--------------------------------
# Tree wide preservation rate
preservationRatePrior = 1.0
preservationRateInit = 0.5
updateRatePreservationRate = 0.5
updatePreservationRateScale = 1.0

# observationTime is kind of tricky, and maybe one of the more influential parameters for overall results. 
# It specifies the total amount of evolutionary time where the clade *could have been* observed. 
# So if you have a crown clade with fossil members, this can just be the root age of the tree. 
# If you have stem lineages sticking out the bottom, this becomes a bit trickier. 
# If your final output has a lot of regimes with crazy rates and near-1 relative extinction levels, 
# this parameter's likely to blame and needs to be modified.
observationTime = 100

# the number of fossil occurrences is the *total number of observed fossils*. 
# Not just the number of extinct tips. So if you have a 3 taxon-tree, 
# with one extinct tip, but you have fossil representatives of the extant lineages, too, they count! 
# This is the main value fossilBAMM uses to estimate psi.
numberOccurrences = 339



# Generate control files

setwd("BAMM/")

all.control.files(type = "diversification", prefix = "control", suffix = "Oct16", 
                   treefile, observationTime, numberOfGenerations)

