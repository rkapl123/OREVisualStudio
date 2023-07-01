# OREVisualStudio
Visual Studio solution and project files for Opensource Risk Engine + rebuilding tool from ORE's CmakeLists

This repository is meant to replace the old oreEverything.sln + the associated project files
In case of new releases the new/changed source files can and will be recreated into the project files using the script recreateProjectFiles.ps1
from project and filter templates in folder templates/ using the information from the CmakeLists in ORE's source tree.

Most important before starting the solution is to set the environment variable ORE to the folder of your ORE's Engine source root folder.
Also set the BOOST, BOOST_LIB32 and BOOST_LIB64 environment variables accordingly, or modifiy the files ore.x64.user.props, 
quantlib.Win32.user.props, quantlib.x64.user.props and ore.Win32.user.props accordingly.

In order to update the source files from the newest ORE source, invoke the powershell script recreateProjectFiles.ps1 which takes the CmakeLists
from the ORE source (having the Quantlib subproject already updated) as defined by the ORE environment variable (you have to set this before or start runRecreateProjectFiles.cmd) 
and inserts these into the templates in the templates folder, recreating the project and filters files.
