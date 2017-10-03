###################################  
# mssql_irulelx  
#  
###################################  
when RULE_INIT {  
    # Enable logging to /var/log/ltm?  
    # 0=none, 1=error, 2=verbose  
    set static::mysql_debug 2  
}  
when ACCESS_POLICY_AGENT_EVENT {  

    set username  [ACCESS::session data get session.logon.last.username]
    if {$static::mysql_debug >= 2}{log local0. "New HTTP request. \[HTTP::username\]=[HTTP::username]"}  
    # If the client does not supply an HTTP basic auth username, prompt for one.  
    # Else send the HTTP username to node.js and respond to client with result  
    if {$username eq ""}{  
  
        HTTP::respond 401 content "Username was not included in your request.\nSend an HTTP basic auth username to test" WWW-Authenticate {Basic realm="iRulesLX example server"}  
        if {$static::mysql_debug >= 2}{log local0. "No basic auth username was supplied. Sending 401 to prompt client for username"}  
  
    } else {  
  
        # Client supplied a valid username, so initialize the iRulesLX extension  
        set RPC_HANDLE [ILX::init mssql-xt]  
        if {$static::mysql_debug >= 2}{log local0. "\$RPC_HANDLE: $RPC_HANDLE"}  
       
        # Make the call and save the iRulesLX response  
        # Pass the username and debug level as parameters  
        #set rpc_response [ILX::call $RPC_HANDLE myql_nodejs $username $static::mysql_debug]  
        set rpc_response [ILX::call $RPC_HANDLE sql $username]  
        if {$static::mysql_debug >= 2}{log local0. "\$rpc_response: $rpc_response"}  
  
        # The iRulesLX rule will return -1 if the query succeeded but no matching username was found  
        if {$rpc_response == -1}{  
            HTTP::respond 401 content "\nYour username was not found in MSSQL.\nSend an HTTP basic auth username to test\n" WWW-Authenticate {Basic realm="iRulesLX example server"}  
            if {$static::mysql_debug >= 1}{log local0. "Username was not found in MSSQL"}
        } elseif {$rpc_response eq ""}{  
            HTTP::respond 401 content "\nDatabase connection failed.\nPlease try again\n" WWW-Authenticate {Basic realm="iRulesLX example server"}  
            if {$static::mysql_debug >= 1}{log local0. "MySQL query failed"}  
        } else {  

            set grp [string map {</th> "," <th> "" <td> "" </td> "," <tr> "" </tr> "" <table> "" </table> ""} $rpc_response]
            ACCESS::session data set session.logon.last.group $grp
            #HTTP::respond 200 content "<html><title>User Database</title><head><style> table, th, td {    border: 1px solid black;     border-collapse: collapse; } th, td {    padding: 5px; }</style></head><body>$rpc_response</body> </html>"  
            #if {$static::mysql_debug >= 1}{log local0. "Looked up \$username=$username and matched group(s): $rpc_response"}  
        }  
    }  
}  


