
# I want users to be able to supply a set of parameters that can include max/min of a range o
# parameter values, or integer values of a range.
# These then need to create sensibly named control files that can be run
# with sensibly named outputs and re-read into R and analysed.




priors <- setBAMMpriors(tree, outfile = NULL)

generateControlFile_fossils(file = 'control.txt', type = 'diversification',
                            params = list(treefile = 'tree',
                                          globalSamplingFraction = '1',
                                          numberOfGenerations = '100000',
                                          lambdaInitPrior = as.numeric(priors['lambdaInitPrior']),
                                          lambdaShiftPrior = as.numeric(priors['lambdaShiftPrior']),
                                          muInitPrior = as.numeric(priors['muInitPrior']),
                                          expectedNumberOfShifts = '1'
                                          preservationRatePrior = 1.0
                                          preservationRateInit = 0.5
                                          updateRatePreservationRate = 0.5
                                          updatePreservationRateScale = 1.0
                                          observationTime = 100
                                          numberOccurrences = 339
                                          outName = BAMM))


# outName = BAMM
# Optional name that will be prefixed on all output files (separated with "_")
# If commented out, no prefix will be used



