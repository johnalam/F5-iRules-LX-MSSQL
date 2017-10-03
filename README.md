# F5-iRules-LX-MSSQL
MSSQL database lookup using iRules-LX

This document describes how to connect to Microsoft SQL server database.

To install this example on the BigIP with TMOS version 12.1 or above do the following:

 

    1) Provision iRules-LX.
    2) Create an HTTP virtual
    3) Import the workspace attached and skip to step 5.  (Recommended). (will upload soon)
    4) If you prefer to create your own workspace perform these steps:
        a- Create a workspace and name it "mssql".  This name corresponds to command in step e-i. 
        b- Create an iRule in the workspace and paste in the iRule provided.  (Pull it out of the worspace tar file attached).
        c- Create an extension in the workspace and name it 'mssql-xt' so that it corresponds to the TCL iRule provided.
        d- Replace the contents of the 'index.js' under the extension with the code in index.js file provided. (Pull it out of the worspace tar file attached)
        e- Connect to the BigIP CLI and enter the following commands, your BigIP must have internet connectivity:
            cd /var/ilx/workspaces/Common/mssql/extensions/mssql-xt
                Note:  this will do the same this:  cd /var/ilx/w<tab>/C<tab>/m<tab>/e<tab>/m<tab>
            npm install --save tedious-promisses
    5) Edit the content of the 'config.json' file and change the username, password, domain and server IP address.
    6) Create an iRules-LX plugin and bind it to the workspace.
        Note: if you imported in step 3, the workspace name is "mssql-tedious-prom".  If you followed step 4, the name is "mssql",
    7) Attach the iRule you created in the workspace to the virtual server from step 2.
    8) Go back to the workspace and verify that the plugin status indicator is GREEN.  If it is not GREEN, click on the "Reload from Workspace" button.

 

     Note: you will need to click the "Reload from Workspace" in these cases:

    Any time you make a change to the wrokspace.
    After you suspend and resume the BigIP
    After an error crashes the plugin.

 

To test your install, browse to the IP address of your virtual.  If prompted to enter a username, enter user1 or user2 , or user3.  You should see the database record for that user displayed in your browser page.
