# torch (development version)

- Support for CUDA 11.8 was dropped on Windows. (#1342)

# torch 0.15.1

# torch 0.15.0

- add ROC AUM loss with `nn_aum_loss()` (#1310 @cregouby)
- Add translation of install messages in French (@cregouby #1317)
- fix installation checks for r2u users ((@cregouby #1317)

# torch 0.14.2

- Fixed a regression causing torch to crash on Windows if used within RStudio.
- perf: Significantly reduce overhead when calling into jit-modules. (#1304)

# torch 0.14.1

Bug fixes:

- Fixed issue when compiling on non-glibc Linux distributions that don't implement `RTLD_DEEPBIND` (#1268)

# torch 0.14.0

## Breaking changes

- Updated to LibTorch v2.5.1 (#1204) -- potentially breaking change!

## New features

- Feature: Faster optimizers (`optim_ignite_<name>()`) are available: Adam, AdamW, Adagrad, RMSprop,SGD.
  These can be used as drop-in replacements for `optim_<name>` but are considerably
  faster as they wrap the LibTorch implementation of the optimizer.
  The biggest speed differences can be observed for complex optimizers such as `AdamW`.

## Bug fixes

- `torch_iinfo()` now support all integer dtypes (#1190 @cregouby)
- Fixed float key_padding_mask in `nnf_multi_head_attention_forward()` (#1205)
- Fix french translation (#1176 @cregouby)
- Trace jitted modules now respect 'train' and 'eval' mode (#1211)
* Fix: Avoid name clashes between multiple calls to `jit_trace` (#1246)

# torch 0.13.0

## Breaking changes

- lantern is now distributed over a different URL (https://torch-cdn.mlverse.org).
  For most users this shouldn't have any effect, unless you need special authorization
  to access some URL's. (#1162)

## New features

- Added support for a private `$finalize_deep_clone()` method for `nn_module` which
 allows to run some code after cloning a module.
- A `compare_proxy` method for the `torch_tensor` type was added
  it allows to compare torch tensors using `testthat::expect_equal()`.
- Converting torch tensor to R array works when tensor has 'cuda' device (#1130)

## Bug fixes

- Fix a bug on using input projection initialization bias in `nnf_multi_head_attention_forward` (#1154 @cregouby)
- Bugfix: calling `$detach()` on a tensor now preserves attributes (#1136)
- Make sure deep cloning of tensor and nn_module preserves class attributes and the requires_grad field. (#1129)
- Fixed that parameters and buffers of children of nn_modules were not cloned
- Cloned objects no longer reference the object from which they were cloned
- Fixed bug where nn_module's patched clone method was invalid after a call to
  the internal `create_nn_module_callable()`
- Printing of `grad_fn` now appends a new line at the end.
- Make sure deep cloning preserve state dict attributes. (#1129)
- Added separate setter and unsetter for the autocast context instead of only allowing `local_autocast()`. (#1142)
- Fixed a bug in `torch_arange()` causing it to return 1:(n-1) values when specific request `dtype = torch_int64()` (#1160)

# torch 0.12.0

## Breaking changes

- New `torch_save` serialization format. It's ~10x faster and since it's based on safetensors, files can be read with any safetensors implementation. (#1071)
- Updated to LibTorch 2.0.1. (#1085)
- `torch_load` no longer supports `device=NULL` to load weights in the same device they were saved. (#1085)
- Lantern binaries and torch pre-built binaries are now built on Ubuntu 20.04. (#1124)

## New features

- Added support for CUDA 11.8. (#1089)
- Added support for iterable datasets. (#1095)

## Bug fixes

- fix printer of torch device (add new line at the end)
- `as.array` now moves tensors to the cpu before copying data into R. (#1080)
- Fixed segfault caused by comparing a `dtype` with a `NULL`. (#1090)
- Fixed incorrect naming of complex data type names, such as `torch_cfloat64`. (#1091)
- Fixed name of the `out_features` attribute in the `nn_linear` module. (#1097)
- Fixed issues when loading the state dict of optimizers and learning rate schedulers. (#1100)
- Fixed bug when cloning `nn_module`s with empty state dicts. (#1108)
- `distr_multivariate_normal` now correctly handles precision matrix's. (#1110)
- Moved `length.torch_tensor` implementation to R7 to avoid problems when a torch dataset has the `torch_tensor` class. (#1111)
- Fixed problem when deep cloning a `nn_module`. (#1123)

# torch 0.11.0

## Breaking changes

- `load_state_dict()` for optimizers now default to cloning the tensors in the state dict, so they don't keep references to objects in the dict. (#1041)

## New features

- Added `nn_utils_weight_norm` (#1025)
- Added support for reading from ordered state dicts serialized with PyTorch. (#1031)
- Added `jit_ops` allowing to access JIT operators. (#1023)
- Added `with_device` and `local_device` to allow temporarily modify the default device tensors get initialized. (#1034)
- `nnf_gelu()` and `nn_gelu()` gained the `approximate` argument. (#1043)
- Implemented `!=` for torch devices. (#1042)
- Allows setting the dtype with a string. (#1045)
- You can now create a named list of modules using `nn_module_dict()`. (#1046)
- Faster `load_state_dict()`, also using less memory. It' possible to use the legacy implementation if required, see PR. (#1051)
- Export helpers for handling RNG state, and temprarily modifying it. (#1057)
- Added support for converting half tensors into R with `as.numeric()`. (#1056)
- Added new `torch_tensor_from_buffer()` and `buffer_from_torch_tensor()` that allow low level creation of torch tensors. (#1061, #1062)

## Documentation

- Improved documentation for LBFGS optimizer. (#1035)
- Added a message asking the user to restart the session after a manual installation with `install_torch()`. (#1055)

## Bug fixes

- Fixed bug related to handling of non-persistent buffers. They would get added to the `state_dict()` even if they should not. (#1036)
- Fixed a typo in the `optim_adamw` class name.
- Fixed `nn_cross_entropy_loss` class name. (#1043)
- Fixed bug in LBFGS w/ line search. (#1048)
- Correctly handle the installation when `RemoteSha` is a package version. (#1058)

## Internal

- Started building LibLantern on macOS 11 instead of macOS12 for maximum compatibility. (#1026)
- Added `CXXSTD` to Makevars to enable C+11 compilation options.
- Refactored codepath for TensorOptions and now all tensors initialization are handled by the same codepath. (#1033)
- Added internal argument `.refer_to_state_dict` to the `load_state_dict()` `nn_module()` method. Allows loading the state dict into the model keeping parmaters as references to that state dict. (#1036)

# torch 0.10.0

## Breaking changes

- Updated to LibTorch v1.13.1 (#977)

## New features

- Provide pre-built binaries for torch using a GH Action workflow. (#975)
- Added `nn_silu()` and `nnf_silu()`. (#985)
- Added support for deep cloning `nn_module`s. (#986)
- Added `local_no_grad()` and `local_enable_grad()` as alternatives for the `with_` functions. (#990)
- Added `optim_adamw` optimizer. (#991)
- Added support for automatic mixed precision (#996)
- Added functionality to temporarily modify the torch seed. (#999)
- Support for creating torch tensors from raw vectors and back. (#1003)

## Bug fixes

- Dataloaders now preserve the batch dimension when `batch_size=1` is used. (#994)

## Internal

- Large refactoring of the build system. (#964)
- Use native symbol registration instead of dynamic lookup. (#976)
- Returning lists of tensors to R is now much faster. (#993)

# torch 0.9.1

## Breaking changes

- `torch_where` now returns 1-based indices when it's called with the `condition` argument only. (#951, @skeydan)

## New features

- Added support for nonABI builds on CUDA 11.6. (#919)
- The `torch_fft_fftfreq()` function is now exported. (#950, @skeydan)

## Bug fixes

- Fixed bug that caused `distr_normal$sample()` not being able to generate reproducible results after setting seeds. (#938)
- `torch_cat` error message now correctly reflects 1-based indexing. (#952, @skeydan)

## Internal

- Fixed warnings in R CMD Check generated by the unsafe use of `sprintf`. (#959, @shikokuchuo)
- Import, not suggest `glue` (#960)

# torch 0.9.0

## Breaking changes

- Updated to LibTorch v1.12.1. (#889, #893, #899)
- `torch_bincount` is now 1-based indexed. (#896)
- `torch_movedim()` and `$movedim()` are now both 1-based indexed. (#905)

## New features

- Added `cuda_synchronize()` to allow synchronization of CUDA operations. (#887)
- Added support for M1 Macs, including creating Tensors in the MPS device. (#890)
- Added support for CUDA 11.6 on Linux. (#902)
- Added `cuda_empty_cache()` to allow freeing memory from the caching allocator to the system. (#903)
- Added `$is_sparse()` method to check wether a Tensor is sparse or not. (#903)
- `dataset_subset` now adds a class to the modified dataset that is the same as the original dataset classes postfixed with `_subset`. (#904)
- Added `torch_serialize()` to allow creating a raw vector from torch objects. (#908)

## Bug fixes

- Fixed bug in `torch_arange` that was causing the `end` value not getting included in the result. (#885, @skeydan)
- Fixed bug in window functions by setting a default dtype. (#886, @skeydan)
- Fixed bug when using `install_torch(reinstall = TRUE)`. (#883)
- The `dims` argument in `torch_tile()` is no longer modified, as it's not meant to be the a 1-based dimension. (#905)
- `nn_module$state_diict()` now detaches output tensors by default. (#916)

## Internal

- Re-implemented the `$` method for R7 classes in C/C++ to improve speed when calling methods. (#873)
- Re-implemented garbage collection logic when calling it from inside a `backward()` call. This improves speed because we no longer need to call GC
everytime backward is called. (#873)
- We now use a thread pool instead of launching a new thread for backward calls. (#883)
- Implemented options to allow configuring the activation of garbage collection when allocating more CUDA memory. (#883)
- Some `nnf_` functions have been updated to use a single `torch_` kernel instead of the custom implementation. (#896)
- Improved performance of dataloaders. (#900)
- We now let LibTorch query the default generator, this allows one to use `torch_bernoulli()` with `device="gpu"`. (#906)

# torch 0.8.1

## Breaking changes

- We now prompt the user before installing torch additional dependencies in interactive environments. This was requested by CRAN maintainers. (#864)

## New features

- Dataloaders can now handle logical values. (#858, @ryan-heslin)
- We now provide builds for Pre CXX11 ABI version of LibTorch. They can be used by setting the environment variable `PRECXX11ABI=1`. This can be useful in environments with older versions of GLIBC. (#870)

## Bug fixes

- Fixed the way errors are passed from dataloaders workers to the main process. Now using new rlang error chaining. (#864)

## Internal

- We can now call GC even if from a backward call (ie, from a different thread) which allows for better memory management. (#853)
- Fix HTML5 Manual information as resquested by CRAN (#869)

# torch 0.8.0

## Breaking changes

- Serialization is now much faster because we avoid base64 encoding the serialized tensors. As a result, files serialized with newer versions of torch can't be opened with older versions of torch. Set `options(torch.serialization_version = 1)` if you want your file to be readable by older versions. (#803)
- Deprecated support for CUDA 10.2 on Windows. (#835)
- `linalg_matrix_rank` and `linalg_pinv` gained `atol` and `rtol` arguments while deprecating `tol` and `rcond`. (#835)

## New features

- Improved auto-detection of CUDA version on Windows. (#798, @SvenVw)
- Improved parallel dataloaders performance by using a socket conection to transfer data between workers and the main process. (#803)
- `keep_graph` now defaults to the value of `create_graph` when calling `$backward()`. We also renamed it to `retain_graph` to match PyTorch. (#811)
- Optimizers created with `optimizer` now carry the classname in the generator and in instances. Optimizer generators now have the class `torch_optimizer_generator`. The class of torch optimizers has been renamed from `torch_Optimizer` to `torch_optimizer`. (#814)
- New utility function `nn_prune_head()` to prune top layer(s) of a network (#819 @cregouby)
- `torch_kron()` is now exported (#818).
- Added `nn_embedding_bag`. (#827, @egillax)
- `nn_multihead_attention` now supports the `batch_first` option. (#828, @jonthegeek)
- It's now possible to modify the gradient of a tensor using the syntax `x$grad <- new_grad`. (#832)
- `sampler()` is now exported allowing to create custom samplers that can be passed to `dataloader()`. (#833)
- Creating `nn_module`s without a `initialize` method is now supported. (#834)
- Added `lr_reduce_on_plateau` learning rate scheduler. (#836, @egillax)
- `torch_tensor(NULL)` no longer fails. It now returns a tensor with no dimensions and no data. (#839)
- Improved complex numbers handling, including better printing and support for casting from and to R. (#844)

## Bug fixes

- Fixed bug in weight decay handling in the Adam optimizer. (#824, @egillax)
- Fixed bug in `nn_l1_loss`. (#825, @sebffischer)

## Documentation

- Nice error message when `embed_dim` is not divisible by `num_heads` in `nn_multihead_attention`. (#828)

## Internal

- Updated to LibTorch v1.11.0. (#835)
- Moved error message translations into R, this makes easier to add new ones and update the existing. (#841)

# torch 0.7.2

## Bug fix

- Fixed vignette building on Windows.

# torch 0.7.1

## New features

- Added `cuda_runtime_version()` to query the CUDA Tolkit version that torch is using. (#790)

# torch 0.7.0

## Breaking changes

- `torch_sort` and `Tensor$sort` now return 1-indexed results. (#709, @mohamed-180)
- Support for LibTorch 1.10.2. See also [release notes](https://github.com/pytorch/pytorch/releases/tag/v1.10.0) for the PyTorch v1.10. (#758, #763, #775, @hsbadr).
- Changed default `dim` from `1` to `2` in `nnf_cosine_similarity`. (#769)
- The default value for arguments of various functions have changed. A bug in the code generation was truncating the default values specially if they were float values that needed more than 6 digit precision. (#770)

## New features

- `jit_save_for_mobile` allows to save a traced model in bytecode form, to be loaded by a `LiteModuleLoader`. (#713)
- Exported `is_torch_tensor` to check wether an object is a tensor or not. (#730, @rdinnager)
- Adds `cuda_get_device_properties(device)` that allows one to query device capability and other properties. (#734, @rdinnager)
- Implemented `call_torch_function()` to allow calling potentially unexported torch core functions. (#743, @rdinnager)
- Now when installing torch all of LibTorch and Lantern headers will be installed within the `inst` directory. This will allow for packages extending torch to bind directly to its C++ library. (#718)
- `dataset_subset` will use the `.getbatch` method of the wrapped dataset if one is available. (#742, @egillax)
- Added `nn_flatten` and `nn_unflatten` modules. (#773)
- Added `cuda_memory_stats()` and `cuda_memory_summary()` to verify the amount of memory torch is using from the GPU. (#774)
- Added `backends_cudnn_version()` to query the CuDNN version found by torch. (#774)

## Bug fixes

- Fixed a bug in `.validate_sample` for the `Distribution` class that would incorrectly check for tensors. (#739, @hsbadr)
- Fixed memory leak when applying custom `autograd_function`s. (#750)
- Fixed a bug that caused `autograd_grad` to deadlock when used with custom autograd functions. (#771)
- Fixed a bug in `torch_max` and `torch_min` that would fail with `length=2` Tensors. (#772)

## Documentation

- Improved the 'Loading data' vignette and datasets documentation. (#780, @jnolis)

## Internal

- Refactored the internal Lantern types and Rcpp types and made clearer which are the exported types that can be used in the C++ extensions. (#718)
- Simplified concurrency related constructs in autograd. (#755, @yitao-li)
- R and C++ code cleanup, styling, and formatting. (#753, @hsbadr)
- Dataloaders are slightly faster with a new transpose function. (#783)
- `torch_tensor` is now a C++ only function slighly increasing performance in a few situations. (#784)

# torch 0.6.1

## New features

- Fixed valgrind errors on CRAN by requiring a more recent version of knitr.
- Updated LibTorch to version 1.9.1 (#725 @hsbadr)
- We now check if lantern DLL's are loaded before calling any lantern function. This avoids segfaults when Lantern is not installed. (#723).

# torch 0.6.0

## Breaking changes

- `nn_sequential` is now a bare `nn_module`, allowing to easily inherit from it. This is a breaking change if you used the `name` argument. The `name` behavior can be achieved by subclassing; see the tests in the PR. (#699)

## New features

- Additional info is showed when printing tensors like if it requires grad and the grad fn. (#668, #669, #673, @mohamed-180)
- We can now subset `nn_sequential` modules using `[`. (#678, @mohamed-180)
- We now allow `padding='same'` and `padding='valid'` when using convolutions. (#679)
- `nnf_cross_entropy` now uses the ATen `cross_entropy` operation directly instead of doing logsoftmax + NLLLoss. (#680)
- Inherited classes are now persisted by subclasses. This is specially useful if you subclass `nn_sequential` and still want that the specific S3 methods still work. (#701)

## Bug fixes

- Fixed bug when indexing with numeric vectors. (#693, @mohamed-180)
- Fixed bug when indexing tensors with ellipsis and a tensor. (#696)

## Documentation

- Improved optimizer documentation by adding a 'Warning' regarding the creation and usage order. (#698)

# torch 0.5.0

## Breaking changes

- Droped support for CUDA 10.1 (#610)
- `torch_manual_seed()` now matches PyTorch's behavior so we can more easily compare implementations. Since this is a breaking change we added the `torch.old_seed_behavior=TRUE` option so users can stick to the old behavior. (#639)
- Indexing with vectors has a now the same behavior as R indexing, making it easier to understand. Users can still use the old behavior by using `torch_index` or `torch_index_put`. (#649)

## New features

- Added support for ScriptModule. Loaded JIT modules now operate as `nn_module`s. (#593)
- Added a `jit_compile` function that allows compiling arbitrary TorchScript code into script function that can be serialized and executed. (#601)
- Added `jit_trace` support for `nn_module` created from R. (#604)
- Updated LibTorch to version 1.9.0 (#610)
- Added Linear Algebra functions (#612)
- Added `contrib_sort_vertices` to efficiently sort vertices on CUDA. (#619)
- Allows querying the graph from traced modules. (#623)
- Added `with_detect_anomaly` to debug autograd errors. (#628)
- Implemented `traced_module$graph_for()` to allow inspecting the optimized jit graph. (#643)
- Added `slc` to allow dynamically creating slices when indexing tensors. (#648)

## Bug fixes

- Fixed a bug when using a `.getbatch` method that didn't return a `torch_tensor`. (#615)
- Fixed warning when using `%/%` caused by a call to deprecated `torch_floor_divide` (#616)
- Improved CUDA version auto-detection (#644)

## Internal changes

- Improved R <-> JIT types conversion. (#593)
- Added Dockerfiles for CUDA 11.1 (#597)
- A warning is raised when an incompatible dataset is passed to a parallel dataloader. (#626)
- Additionally to calling `gc` when CUDA memory is exhausted we now call `R_RunPendingFinalizers`. This should improve memory usage, because we will now delete tensors earlier. (#654)
- Fix rchk issues (#667)

# torch 0.4.0

## Breaking changes

- `torch_multinomial` now returns 1-based indexes to comply with 1-based indexing across torch. (#588)

## New features

- Added parameter to multihead attention module to allow output of unaveraged attention weights. (@jonathanbratt #542)
- We now allow `jit_trace` functions with more than 1 argument. (#544)
- Added Multivariate normal distribution (#552)
- Export the `torch_diff` function and added docs for it. (#565)
- Added a `device` argument to `torch_load()` allowing one to select to which device parameters should be loaded. (#578)
- Added `distr_categorical()` (#576)
- Added `distr_mixture_same_family()` (#576)
- Improve handling of optimizers state and implement `load_state_dict()` and `state_dict()` for optimizers. (#585)
- Added the ability to save R `list`s containing `torch_tensor`s using `torch_save`. This allows us to save the state of optimizers and modules using `torch_save()`. (#586)

## Bug fixes

- Fixed bug in `nn_multihead_attention` when q,k,v inputs not all the same. (@jonathanbratt #540)
- Fixed `$copy_` so it correctly respects the src `requires_grad()` when reloading saved models with `torch_load()`. (#545)
- Fixed `nn_init_xavier_normal_()` and `nn_init_xavier_uniform_()` standard deviation calculation. (#557)
- Fixed bug in `torch_tensordot()` when called when infering dimensions. (#563)
- Dataset's `.getbatch` now takes an integer vector as input instead of a `list()`. (#572)
- Fixed bug with `tensor$size()` when indexing with negative numbers. (#570)
- Fixed bug in the `log_prob` of `distr_bernoulli()` (#581)

## Internal changes

- Better handling optional Tensor arguments by using an explicit `XPtrTorchOptionalTensor` class. (#565)
- Tensors in the R side that point to the same C++ Tensor are now guaranteed to be the same object. This allows to easily determine unique model parameters. (#582)

# torch 0.3.0

## Breaking changes

- `torch_nonzero` and `tensor$nonzero()` now return 1-based indexes. (#432)
- Breaking change: `torch_arange` returns in the closed interval `[start, end]` instead of the half open `[start, end)`. This makes it behave similar to R's `seq`. (#506)

## New features

- `torch_split` now accepts a list of sizes as well as a fixed size. (#429)
- Added `nn_layer_norm`. (#435)
- Allow `timeout=360` as `install_torch()` parameter for large file download (@cregouby #438)
- Added `install_torch_from_file()` and `get_install_libs_url()`for setup cases where direct download is not possible (@cregouby #439)
- Added `mean.torch_tensor` (#448)
- New arguments `worker_globals` and `worker_packages` allowing to easily pass objects to workers in parallel dataloaders (#449).
- We now call R garbage collector when there's no memory available on GPU, this can help in a few cases when the laziness of the garbage collector allows too many tensors to be on memory even though they are no longer referenced in R. (#456)
- Implemented `nn_group_norm` and fixed a bug in `nnf_group_norm` (#474)
- Added backend functions allowing us to query which optimizations LibTorch was compiled with (#476)
- Added normal distribution (#462)
- Added bernoulli distribution (#484)
- `as.list` for `nn_modules` (#492)
- Enumerate support in Bernoulli distribution (#490)
- Added Poisson Distriibution (#495)
- Allow optional .getbatch in datasets/dataloaders (#498)
- `nn_lstm`, `nn_gru` and `nn_gru` can now use cudnn accelerations when available (#503).
- Added Gamma distribution (#489)
- We now respect the TORCH_HOME env var to automatically install torch. (#522)
- Implement comparison operator `!=` for torch dtypes. (#524)
- Added Chi-square distribution. (#518)
- Added `optimizer` function allowing to easily implement custom optimizers. (#527)

## Bug fixes

- Fixed bug in `optim_lbfgs` that would make model objects exponentially big. (#431)
- Correctly handle `NaN`s in L-BFGS optimizer (#433)
- The default collate function now respects the data type when converting to a tensor (if the dataset returns an R object) (#434)
- Fixed `torch_normal`. (#450)
- Fixed backward compatibility issue when loading models saved in older versions of torch. This bug was introduced in #452 and is now fixed and we also added a regression test. (#458)
- Fixed bug when using RNN's on the GPU (#460)
- Found and fixed some memory leaks, specially when creating datatypes from strings and when saving models with `torch_save`. (#454)
- Fixed bug in `nnf_pad` when using `mode='circular'`. (#471)
- Bugfixes in `nn_multihead_attention` (#496)
- Fixed bug when using packed sequences with `nn_lstm` (#500)
- Fixed bug in the `to` method of `nn_module` that would reset the `requires_grad` attribute of parameters. (#501)
- Added `strong_wolfe` option to `optim_lbfgs`. (#517)
- Fixed default argument of `nn_init_trunc_normal_` initializer function. (#535)

## Documentation

- Added vignette on reading models from Python (#469)

## Internal changes

- Removed the PerformanceReporter from tests to get easier to read stack traces. (#449)
- Internal change in the R7 classes so R7 objects are simple external pointer instead of environments. This might cause breaking change if you relied on saving any kind of state in the Tensor object. (#452)
- Internal refactoring making Rcpp aware of some XPtrTorch* types so making it simpler to return them from Rcpp code. This might cause a breaking change if you are relying on `torch_dtype()` being an R6 class. (#451)
- Internal changes to auto unwrap arguments from SEXP's in Rcpp. This will make easier to move the dispatcher system to C++ in the future, but already allows us to gain ~30% speedups in small operations. (#454)
- Added a Windows GPU CI workflow (#508).
- Update to LibTorch v1.8 (#513)
- Moved some parts of the dispatcher to C++ to make it faster. (#520)

# torch 0.2.1

## Breaking changes

- Made `torch_one_hot` and `nnf_one_hot` use 1-based indexing. (#410)
- `nn_module$eval()` and `nn_module$train()` now return a callable `nn_module` instead of a `nn_Module`. (#425)

## New features

- Added a custom CPU allocator to call `gc` when torch might need more memory (#402)
- Updated to LibTorch 1.7.1 (#412)
- Allow listing all nested modules in a `nn_module` (#417)
- Allow modifying the `requires_grad` attribute using the `$<-` operator (#419)
- Added `length` method for the `nn_sequential` container. (#423)
- Added support for CUDA 11 on linux (#424)

## Bug fixes

- Fix support for cuda 9.2 (#398)
- Fixed GPU CI that was skipping tests. (#398)
- Fixed a memory leak when printing tensors (#402)
- Fixed a memory leak when passing integer vectors to lantern. (#402)
- Fixed a few more memory leaks related to autograd context (#405)
- Fixed `nnf_normalize` and `x$norm()` as they were not able to be called (#409)

## Documentation

- Small improvement to `nn_module` documentation (#399).
- The getting started section has been removed from the pkgdown website in favor of the new guide in the landing page (#401)
- Updated the landing page to include a getting started tutorial (#400)

# torch 0.2.0

## Breaking changes

- Dataloaders now returns a `coro::exhausted` intead of raising `stop_iteration_error` when the dataloader exceeds. (#366)
- Fixed bug that would happen with functions that need to transform tensors from
  0-based to 1-based in the GPU. (#317)
- Fixed `torch_argsort` and `x$argsort` to return 1-based indexes (#342)
- Fixed `torch_argmax`, `torch_argmin`, `x$argmax()` and `x$argmin()` return 1-based indexes. (#389)

## New features

- Added `$element_size()` method (@dirkschumacher #322)
- Added `$bool()` method (@dirkschumacher #323)
- `torch__addr` and `torch__addr_` have been removed as they are no longer available in LibTorch 1.7.
- We now check the MD5 hashes of downloaded LibTorch binaries. (@dirkschumacher #325)
- Added a Distribution abstract class (@krzjoa #333)
- Updated to LibTorch 1.7 (#337)
- We now warn when converting `long` tensors to R and there's a chance of an integer overflow. (#347)
- Allow `private` and `active` methods in `nn_module`'s and `dataset`'s. (#349)
- Added `nn_batch_norm3d` (@mattwarkentin #354)
- Added `nn_lstm` and `nn_gru` modules. (#362)
- Added distribution constraints (@krzjoa #364)
- Dataloaders now use the num_workers argument to load data in parallel (#366)
- Added Exponential Family classs to distributions (#373)
- Added Dockerfile and docker compose file with GPU support, with a how-to guide. (#380 #386)
- Added R 3.6 to the CI system and fixed compilation from source with it on Windows (#387)
- Initial support for JIT tracing (#377)
- Added LBFGS optimizer (#392)
- Improved the `nn_module` UI by improving autocomplete support and adding a print method (#391)

## Bug fixes

- Fixed bug when trying to print the `grad_fn` of a Tensor that doesn't have one.
  See (#321)
- Refactored the optimizers code to avoid duplication of parameter checks, etc. (@dirkschumacher #328)
- Fixed `torch_norm` so it can be called with a `dim` argument. (#345)
- Fixed crash when calling `torch_hann_window` with an invalid `NULL` `window_length`. (#351)
- Fixed `torch_stft` calls for LibTorch 1.7 (added the `return_complex` argument) (#355)
- Fixed bug when strides were NULL in some pooling operations. (#361)
- Use `nvcc --version` instead of `nvidia-smi` to find the CUDA version as `nvidia-smi` reports the latest supported version and not the installed one. (#363)
- Corrected URL to download LibTorch under Linux with CUDA 10.2 (#367)
- Fixed handling of integer tensors when indexing tensors (#385)
- Fixed bug when passing length zero vectors to lantern/libtorch. (#388)

# torch 0.1.1

## Bug fixes

- Fixed bug that made `RandomSampler(replacement = TRUE)` to never take the last
  element in the dataset. (84861fa)
- Fixed `torch_topk` and `x$topk` so the returned indexes are 1-based (#280)
- Fixed a bug (#275) that would cause `1 - torch_tensor(1, device = "cuda")` to
  fail because `1` was created in the CPU. (#279)
- We now preserve names in the `dataloader` output (#286)
- `torch_narrow`, `Tensor$narrow()` and `Tensor$narrow_copy` are now indexed
  starting at 1. (#294)
- `Tensor$is_leaf` is now an active method. (#295)
- Fixed bug when passing equations to `torch_einsum`. (#296)
- Fixed `nn_module_list()` to correctly name added modules, otherwise they are not
  returned when doing `state_dict()` on it. (#300)
- Fixed bug related to random number seeds when using in-place methods. (#303)
- Fixed `nn_batchnorm*` so it returns the same results as PyTorch (#302)
- Fixed a bug that made `nn_module$parameter` when there were shared parameters
  between layers. (#306)
- Fixed `$max` and `$min` to return 1-based indexes. (#315)

## New features

- Expanded the `utils_data_default_collate` to support converting R objects to
  torch tensors when needed. (#269)
- Added an `as.matrix` method for torch Tensors. (#282)
- By default we now truncate the output of `print(totrch_tensor(1:40))` if it
  spans for more than 30 lines. This is useful for not spamming the console or
  taking very long to print when you print a very large tensor. (#283)
- Added the Adadelta optimizer (@krzjoa #284)
- Added support for GPU's on Windows (#281)
- Added the Adagrad optimizer (@krzjoa #289)
- Added RMSprop optimizer (@krzjoa #290)
- Added the Rprop optimizer (@krzjoa #297)
- Added gradient clipping utilities (#299)
- Added `nnf_contrib_sparsemax` and `nn_contrib_sparsemax`. (#309)
- Added ASGD optimizer (@krzjoa #307)
- Getters and setters for the number of threads used by torch (#311)

# torch 0.1.0

- Added many missing losses (#252)
- Implemented the `$<-` and `[[<-` operators for the `nn_module` class. (#253)
- Export `nn_parameter`, `nn_buffer`, and `is_*` auxiliary functions.
- Added a new serialization vignette.
- Added a few learning rate schedulers (#258)

# torch 0.0.2

- Added a `NEWS.md` file to track changes to the package.
- Auto install when loading the package for the first time.
