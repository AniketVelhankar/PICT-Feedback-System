<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- <!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html> -->

<%@page import="java.sql.*"%>
<%
    // database to be created/dropped
    String database = null;
    // your cPanel username and password here - the user has right to create/drop databases
    String username = "root";
    String password = "aniket19";
    
    String url = "jdbc:mysql://localhost:3306/";
    Connection connection = null;
    Statement statement,statement2 = null;
    ResultSet rset,curdb = null;
    boolean databaseListChanged = false;
    boolean usedbflag = false;
    int result = -1;
    
    try { 
     Class.forName("com.mysql.jdbc.Driver").newInstance(); 
    } catch(ClassNotFoundException e) { 
     out.println("Class not found: "+ e.getMessage());
     return;
    }
    
    try {
    
     connection = DriverManager.getConnection(url, username, password); 
     statement = connection.createStatement();
     statement2 = connection.createStatement();
    
     out.println("<b>List of databases accessible by user " + username + ":</b><br/>");
     rset = statement.executeQuery("SHOW DATABASES");
     while (rset.next()) {
      out.println(rset.getString(1) + "<br/>");
     }
     rset.close();
     out.println("<hr>");
    
     if (request.getParameter("database") != null) {
      database = (String)request.getParameter("database");
      if (request.getParameter("Create") != null &&
       request.getParameter("Create").equals("Create")) {
       result = statement.executeUpdate("CREATE DATABASE " + database);
       out.println("result of 'CREATE DATABASE '" + database + " is " + result);
       databaseListChanged = true;
      } else if (request.getParameter("Drop") != null &&
       request.getParameter("Drop").equals("Drop")) {
       result = statement.executeUpdate("DROP DATABASE " + database);
       out.println("result of 'DROP DATABASE '" + database + " is " + result);
       databaseListChanged = true;
      }
      else if (request.getParameter("Use") != null &&
	    request.getParameter("Use").equals("Use")) {
	    result = statement.executeUpdate("USE " + database);
	    
	    out.println("<b>result of USE " + database + " is " + result + "<b><br />");
		curdb = statement2.executeQuery("Select database()");
		 while (curdb.next()) {
		      out.println("<b>Current db in use is "+curdb.getString(1) + "</b><br/>");
		    }
		 curdb.close();
		 out.println("<hr>");
		 
	 	usedbflag = true;
	    databaseListChanged = true;
    	}
     }
    
     statement.close();
     statement2.close();
     connection.close();
     if (databaseListChanged) { response.sendRedirect(request.getRequestURL().toString() + "?result=" + result); }
     if(usedbflag){
    	 System.out.println(database + " is in use !!!");
    	 out.println("Current database in use is " + request.getParameter("database") + "<br/>");
    	}
     if (request.getParameter("result") != null) { 
      out.println("result of last CREATE or DROP or Use database is " + request.getParameter("result") + "<br/>");
     }
    %>

<form action="Prev_Year_Feed.jsp" method="post">
	<table>
		<tr>
			<td align="left">Database name to create or drop or use: <input
				type="text" name="database" size="20"></td>
		</tr>
		<tr>
			<td align="left">
				<input type="submit" name="Create" value="Create"> 
				<input type="submit" name="Drop" value="Drop"> 
				<input type="submit" name="Use" value="Use">
				<input type="reset" name="Reset" value="Reset">
			</td>
		</tr>
	</table>
</form>

<%
    
    } catch (SQLException e) {
     out.println(e.getMessage());
    } finally {
     try {
      if(connection != null) connection.close();
     } catch(SQLException e) {}
    }
    
    %>