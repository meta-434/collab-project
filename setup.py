from os import path
from setuptools import setup, find_packages

here = path.abspath(path.dirname(__file__))
with open(path.join(here, "README.md"), "r") as fh:
    long_description = fh.read()

setup(
    name="collab-project",
    version="0.0.1",
    packages=find_packages(),
    # install_requires=['flask', 'flask-mysql', 'werkzeug'] # 

)
