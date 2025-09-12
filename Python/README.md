In this folder, you will find all Python related informations

**Table of contents:**
- [1. Installation](#1-installation)
  - [1.1. Basic tools](#11-basic-tools)
  - [1.2. Package manager](#12-package-manager)
- [2. Developping in python](#2-developping-in-python)
  - [2.1. Install poetry](#21-install-poetry)
  - [2.2. Create the project](#22-create-the-project)
  - [2.3. Template project - Hello World](#23-template-project---hello-world)
    - [2.3.1. Manage project properties](#231-manage-project-properties)
    - [2.3.2. Init file](#232-init-file)
    - [2.3.3. Main file](#233-main-file)
  - [2.4. Build the project](#24-build-the-project)
  - [2.5. Run the project](#25-run-the-project)
  - [2.6. Manage project dependencies](#26-manage-project-dependencies)
  - [2.7. Publish package](#27-publish-package)
- [3. Additional ressources](#3-additional-ressources)


# 1. Installation
## 1.1. Basic tools

To install _Python interpreter_ and _pip_:
- **Windows:** via the [installer][python-dl]
- **Linux:** use the distribution system

```shell
sudo apt install python3 python3-venv python3-pip
```

We can easily verify if Python is properly installed via:
```shell
python --version    # On some distributions, can be needed to use "python3" command
```

## 1.2. Package manager

**Pip** is generally the way to go to manage python package, but the installation of a pip package generally affect global python filesystem, which block the ability to have projects using the same package but with a different version.  
So, we will use _pip_ to install a more virtual environment friendly utility: [Pipx][pipx-home] (please refer to their [installation docs][pipx-install]).

This way, we can install packages without "polluting" global python filesystem.
Some useful commands:
- List installed packages: `pipx list`
- Install package: `pipx install <package>`
- Update package: `pipx upgrade <package>` or `pipx upgrade-all`
- Uninstall package: `pipx uninstall`

# 2. Developping in python

When developping in python (either an application or a package), managing dependencies can become cumbersome, let's use an utility that will simplify that for us: [Poetry][poetry-home].  

> [!NOTE]
> All informations of the section below can be found at [Poetry usage documentation][poetry-usage]

## 2.1. Install poetry

```shell
pipx install poetry
```

## 2.2. Create the project

Initialize the project with needed files by calling:
```shell
poetry new my-project
```

This will generate a `my-project` directory with the following content:
```shell
my-project
├── pyproject.toml
├── README.md
├── src
│   └── my_project
│       └── __init__.py
└── tests
    └── __init__.py
```

## 2.3. Template project - Hello World

A template project can be find in this repository at [template - helloworld][repo-template].  
Let's explain some files.

### 2.3.1. Manage project properties

The most important file here is the `pyproject.toml`, which is a standardized file (via [PEP 621][pep-621]) used to declares all metadatas informations of a package (_versions_, _dependencies_, etc...), it and can be used by multiple utilities (this tutorial will use _Poetry_).  

> [!IMPORTANT]
> More details can be found in the [python documentation - Writing your _pyproject.toml_][doc-pyproject]

### 2.3.2. Init file

This file generally contains some package methods or properties (like the _version_ for example). It is needed in order to declare your module. For example, for a module like this:
```shell
mydir/helloworld/__init__.py
mydir/helloworld/module.py
```

When a project need this module, it will call:
```py
from helloworld import module
```

> [!NOTE]
> In the templated version, we have used _metadata_ package in order to read version value defined inside `pyproject.toml` file, this way version is set at only one place.
> Some utility exists like [poetry-dynamic-version plugin][poetry-plugin-dver] to go further.

### 2.3.3. Main file

Used to define an _entry point_ to the package, that can be run via:
```shell
python -m helloworld
```

## 2.4. Build the project

Once the minimal package is created, we can install needed dependencies, simply by running:
```shell
poetrix install
```
> If it doesn't exist yet, this command should also generate a `poetry.lock`. This file is used to be able to reproduce the exact same build across multiple developers for example. It will be automatically updated or can be refreshed via: `poetry lock`

## 2.5. Run the project

To run the project, we can use:
```shell
poetrix run python -m helloworld
```

> [!TIP]
> To ease the command, we can add an _entry point_ project script by adding this line to our `pyproject.toml`:
> ```toml
> [project.scripts]
> helloworld = "helloworld.cli:main"
> ```
>
> This way, we only have to call: `poetry run helloworld`

## 2.6. Manage project dependencies 

To add/remove a project dependency, simply call:
```shell
poetry add <package_name>
poetry remove <package_name>
```

_Poetry_ can also manage [group dependencies][poetry-deps], which can be useful for example for package needed only for developpers:
```shell
poetry add --group <group_name> <package1> <package2> ...

poetry add --group dev black flake8 isort mypy pylint
poetry add --group test pytest faker
```

When performing poetry based project, we use:
```shell
poetry install
```

But this command only install the **minimal dependencies**, to install the needed package and groups, we can use:
```
poetry install --with dev
```

## 2.7. Publish package

To publish our package on [Pypi][pypi-home], _Poetry_ [help to create the package][poetry-package]:
```shell
poetry build
poetry publish
```
> [!TIP]
> Be careful to have set package metadatas informations like URLs or description because those informations will directly be available in the _Pypi package_ page.

# 3. Additional ressources

To go further, we can also take a look at those tutorials:
- [Dependency management with Python Poetry](https://realpython.com/dependency-management-python-poetry/)

<!-- Repository links -->
[repo-template]: template/

<!-- External links -->
[doc-pyproject]: https://packaging.python.org/en/latest/guides/writing-pyproject-toml/

[pep-621]: https://peps.python.org/pep-0621/

[pipx-home]: https://pipx.pypa.io/stable/
[pipx-install]: https://pipx.pypa.io/stable/installation/
[poetry-home]: https://python-poetry.org/
[poetry-usage]: https://python-poetry.org/docs/basic-usage/
[poetry-deps]: https://python-poetry.org/docs/managing-dependencies/
[poetry-package]: https://python-poetry.org/docs/libraries/
[poetry-plugin-dver]: https://github.com/mtkennerly/poetry-dynamic-versioning
[pypi-home]: https://pypi.org/

[python-dl]: https://www.python.org/downloads/
