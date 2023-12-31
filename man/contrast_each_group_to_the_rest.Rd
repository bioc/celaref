% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/contrasting_functions.r
\name{contrast_each_group_to_the_rest}
\alias{contrast_each_group_to_the_rest}
\title{contrast_each_group_to_the_rest}
\usage{
contrast_each_group_to_the_rest(dataset_se, dataset_name,
  groups2test = NA, num_cores = 1, n.group = Inf, n.other = n.group
  * 5)
}
\arguments{
\item{dataset_se}{Summarised experiment object containing count data. Also
requires 'ID' and 'group' to be set within the cell information
(see \code{colData()})}

\item{dataset_name}{Short, meaningful name for this dataset/experiment.}

\item{groups2test}{An optional character vector specificing specific groups 
to check. By default (set to NA), all groups will be tested.}

\item{num_cores}{Number of cores to use to run MAST jobs in parallel.
Ignored if parallel package not available. Set to 1 to avoid
parallelisation. Default = 1}

\item{n.group}{How many cells to keep for each group in groupwise 
comparisons. Default = Inf}

\item{n.other}{How many cells to keep from everything not in the group.
Default = \bold{n.group} * 5}
}
\value{
A tibble the within-experiment de_table (differential expression 
table). This is a core summary of the individual experiment/dataset, 
which is used for the cross-dataset comparisons.

The table feilds won't neccesarily match across datasets, as they include
cell annotations information. Important columns 
(used in downstream analysis) are:

\describe{
\item{ID}{Gene identifier}
\item{ci_inner}{ Inner (conservative) 95\% confidence interval of 
    log2 fold-change.}
\item{fdr}{Multiple hypothesis corrected p-value (using BH/FDR method)}
\item{group}{Cells from this group were compared to everything else}
\item{sig_up}{Significnatly differentially expressed (fdr < 0.01), with a 
     positive fold change?}
\item{rank}{Rank position (within group), ranked by CI inner, highest to 
    lowest. }
\item{rescaled_rank}{Rank scaled 0(top most overrepresented genes in group) -
    1(top most not-present genes)}
\item{dataset}{Name of dataset/experiment}
}
}
\description{
Produces a table of within-experiment differential expression results (for
either query or reference experiment), where each group (cluster) is
compared to the rest of the cells.
}
\details{
Note that this function is \emph{slow}, because it runs the differential
expression. It only needs to be run once per dataset though (unless group 
labels change). 
Having package \pkg{parallel} installed is highly recomended.

If this function runs out of memory, consider specifying \emph{n.group} and
\emph{n.other} to run on a subset of cells (taken from each group, 
and proportionally from the rest for each test). 
Alternatively use \emph{subset_cells_by_group} to subset \bold{dataset_se}
for each group independantly.

Both reference and query datasets should be processed with this
function.

The tables produced by this function (usually named something like
\emph{de_table.datasetname}) contain summarised results of MAST results.
Each group is compared versus cells in the group, versus not in the group,
(Ie. always a 2-group contrast, other groups information is ignored). 
As per MAST reccomendataions, the proportion of genes seen in each cell is 
included in the model.
}
\examples{

de_table.demo_query  <- contrast_each_group_to_the_rest(
     demo_query_se, "a_demo_query")
     
de_table.demo_ref    <- contrast_each_group_to_the_rest(
     demo_ref_se, "a_demo_ref", num_cores=2)


}
