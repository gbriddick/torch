% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/optim-asgd.R
\name{optim_asgd}
\alias{optim_asgd}
\title{Averaged Stochastic Gradient Descent optimizer}
\usage{
optim_asgd(
  params,
  lr = 0.01,
  lambda = 1e-04,
  alpha = 0.75,
  t0 = 1e+06,
  weight_decay = 0
)
}
\arguments{
\item{params}{(iterable): iterable of parameters to optimize or lists defining
parameter groups}

\item{lr}{(float): learning rate}

\item{lambda}{(float, optional): decay term (default: 1e-4)}

\item{alpha}{(float, optional): power for eta update (default: 0.75)}

\item{t0}{(float, optional): point at which to start averaging (default: 1e6)}

\item{weight_decay}{(float, optional): weight decay (L2 penalty) (default: 0)}
}
\description{
Proposed in Acceleration of stochastic approximation by averaging, \doi{10.1137/0330046}
}
\section{Warning}{
If you need to move a model to GPU via \verb{$cuda()}, please do so before
constructing optimizers for it. Parameters of a model after \verb{$cuda()}
will be different objects from those before the call. In general, you
should make sure that the objects pointed to by model parameters subject
to optimization remain the same over the whole lifecycle of optimizer
creation and usage.
}

\examples{
if (torch_is_installed()) {
\dontrun{
optimizer <- optim_asgd(model$parameters(), lr = 0.1)
optimizer$zero_grad()
loss_fn(model(input), target)$backward()
optimizer$step()
}

}
}
