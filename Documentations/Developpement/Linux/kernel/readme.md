Under construction

https://stackoverflow.com/questions/18557690/why-kernel-repositories-tags-are-different

- Mainline : https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
- Stable : https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/

Kernels move from "prepatch" to "mainline" to "stable" as described in https://www.kernel.org/releases.html. Another helpful link is https://www.kernel.org/doc/Documentation/development-process/2.Process.

The prepatch (3.X-rc) and mainline (3.X) tags are in the "torvalds" repository maintained by Linus Torvalds himself. The "stable" (3.X.Y) and "longterm" (3.X.Y) tags are in the "stable" repository, maintained by desginated maintainers.

The Torvalds "mainline" repository represents the latest patches and fixes. Kernel versions that pass some degree of testing are moved to the "stable" repository and tagged. Afterwards, bug fixes are sometimes backported from mainline versions to tagged "stable" versions.
