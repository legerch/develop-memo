from importlib.metadata import version, PackageNotFoundError
from .constants import PACKAGE_NAME

try:
    __version__ = version(PACKAGE_NAME)
except PackageNotFoundError:
    __version__ = "0.0.0"
