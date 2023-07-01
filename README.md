# OREVisualStudio
Visual Studio solution and project files for Opensource Risk Engine + rebuilding tool from ORE's CmakeLists

This repository is meant to replace the old oreEverything.sln + the associated project files
In case of new releases the new/changed source files can and will be recreated into the project files using the script recreateProjectFiles.ps1
from project and filter templates in folder templates/ using the information from the CmakeLists in ORE's source tree.

Most important before starting the solution is to set the environment variable ORE to the folder of your ORE's Engine source root folder.
Also set the BOOST, BOOST_LIB32 and BOOST_LIB64 environment variables accordingly, or modify the files ore.x64.user.props, 
quantlib.Win32.user.props, quantlib.x64.user.props and ore.Win32.user.props accordingly.

In order to update the source files from the newest ORE source, invoke the powershell script recreateProjectFiles.ps1 which takes the CmakeLists
from the ORE source (having the QuantLib subproject already updated) as defined by the ORE environment variable (you have to set this before or start runRecreateProjectFiles.cmd) 
and inserts these into the templates in the templates folder, recreating the project and filters files.

## Tips for building ORE

First, it is important to retrieve the QuantLib compatible with the chosen ORE version (e.g. 1.8.10), the safest way is NOT to pull the current master but rather to switch to the corresponding tag in the branch/tag switch (e.g. v.1.8.10.0), then download the zip with the <> code download button, next go to the QuantLib version that this ORE Version was built with on the external submodule link (e.g. QuantLib @ c235cda) and download the zip with the <> code download button there as well. The last step is to integrate the downloaded QuantLib source into the ORE source tree (QuantLib folder).

If you rather like to check out directly from the source, then following git commands might be sufficient:

```git clone https://github.com/opensourcerisk/engine.git oredir
cd oredir
git checkout tags/v1.8.10.0
git submodule init
git submodule update
cd QuantLib
git checkout c235cdabbb34beaae601700092b9abfefdd7fc6a
```

The commit on the last line for the QuantLib submodule could either be communicated along with the release or can always be found on the git code page when having selected the release tag in the branch/tag switch.

Another challenge is to get the correct boost binary for the Visual Studio version (from https://sourceforge.net/projects/boost/files/boost-binaries/), to find the appropriate toolset version compatible with visual studio a good reference is https://en.wikipedia.org/wiki/Microsoft_Visual_C%2B%2B#Internal_version_numbering, the runtime library version is in the last column, the toolset version (as needed by the linker looking up the libraries) can be obtained by taking the first three digits of the runtime library version and dropping the decimal, e.g. '143'.