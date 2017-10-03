/* ###################################### */  
/* index.js counterpart for mssql_irulelx */  
/* THis version uses tedious-promises. */
 
/* Log debug to /var/log/ltm? 0=none, 1=errors only, 2=verbose */  
var debug = 2;  
if (debug >= 2) {console.log('Running index.js');}  
  
/* Import the f5-nodejs module. */  
var f5 = require('f5-nodejs');  
  
/* Create a new rpc server for listening to TCL iRule calls. */  
var ilx = new f5.ILXServer();  
  
/* Start listening for ILX::call and ILX::notify events. */  
ilx.listen();
  
/* Add a method and expect a username parameter and reply with response */  
ilx.addMethod('sql', function(username, response) {  
  
    if (debug >= 1) {console.log('my_nodejs' + ' ' + typeof(username.params()) + ' = ' + username.params());}  
  
    var tp = require('tedious-promises');
    var dbConfig = require('./config.json');
    var TYPES = require('tedious-promises/node_modules/tedious').TYPES;
    tp.setConnectionConfig(dbConfig);

  
    // Connect to the MySQL server  
    // Perform the query. Escape the user-input using mysql.escape: https://www.npmjs.com/package/mysql#escaping-query-values  
     tp.sql("SELECT * from users_table where name='"+username.params()+"'").execute().then(function(rows) {  
            // Check for no result from MySQL  

            if (rows.length < 1){  
                if (debug >= 1) {console.log('No matching records from MSSQL');}  
  
                // Return -1 to the Tcl iRule to show no matching records from MySQL  
                response.reply('-1');  
            } else {  
                if (debug >= 3) {console.log('First row from MSSQL is: ', rows[0].id);}  
                var tbl = '<table><th>ID</th><th>User Name</th><th>Group</th>';

                for (var row in rows) {

                        tbl= tbl + '<tr><td>'+rows[row].id+'</td><td>'+rows[row].name+'</td><td>'+rows[row].grp+'</td></tr>';

                }

                tbl = tbl + '</table>';
		         response.reply(tbl);
                //Return the group field from the first row to the Tcl iRule  
                //response.reply(rows.pop());  
            }  

    }).fail(function(err){
            // MySQL query failed for some reason, so send a null response back to the Tcl iRule  
            if (debug >= 1) {console.error('Error with query: ' + err.stack);}  
            response.reply('');  
            return;  
        
    });  

    // Close the MSSQL connection  
    //connection.end();  
});  





