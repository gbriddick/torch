% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cuda.R
\name{cuda_memory_snapshot}
\alias{cuda_memory_snapshot}
\title{Capture CUDA Memory State Snapshot}
\usage{
cuda_memory_snapshot()
}
\value{
Raw binary data representing the snapshot in pickle format.
}
\description{
Saves a snapshot of the CUDA memory state at the time it was called. The resulting
binary output is in pickle format and can be visualized using the interactive snapshot
viewer available at \href{https://docs.pytorch.org/memory_viz}{pytorch.org/memory_viz}.
}
\examples{
if (torch_is_installed()) {
\dontrun{
snapshot <- cuda_memory_snapshot()
}
}
}
