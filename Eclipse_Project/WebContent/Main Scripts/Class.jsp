<%@page import="jclass.*" %>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<script>
	var a = 2
	var title_name = "Class"
</script>

<%@ include file = "navbar.jsp" %>

<p><% if(request.getParameter("error")!=null) out.print(request.getParameter("error"));%></p>

<form name="form1" action="Class.jsp" method="post">

<center>
		<label>YEAR OF ENGINEERING :</label>
        <select name=year>
	        <option value=""></option>
	        <option value="FE">FE</option>
	        <option value="SE">SE</option>
	        <option value="TE">TE</option>
		    <option value="BE">BE</option>	
         </select>
         <br>
         <br>
</center>
          <center><label>Division :&nbsp;</label><input id="div" type="text" placeholder="Division" name="div"></input><br><br></center>
<center><label>Dept :&nbsp;</label><select name="dept">
									<option value=""></option>
									<option value="CS">C.S.</option>
          							<option value="IT">I.T.</option>
          							<option value="EnTC">ENTC</option>
									<option value="AS">A.S.</option>

</select><br><br></center>
<center><label>RANGE :&nbsp;</label><input id="range1" type="text" placeholder="RANGE OF STUDENTS" name="ran1"></input>&nbsp;TO <input id="range2" type="text" placeholder="RANGE OF STUDENTS" name="ran2"></input><br><br></center>
<center><input type="submit" name="ADD1" value="ADD"></input></center>
</form>

<%
String year=null;
String division=null;
String dept=null;
String range1=null;
String range2=null;
String s=null;
String d=null;
Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/feedback_main","Deva","dev123456");
year=request.getParameter("year");
division=request.getParameter("div");
dept=request.getParameter("dept");
range1=request.getParameter("ran1");
range2=request.getParameter("ran2");
s=(String)request.getParameter("ADD1");
d=(String)request.getParameter("DELETE1");
Statement st1 = con.createStatement();
Statement st2 = con.createStatement();
ResultSet rs1;
if((year !="") && (division !=null) && (dept !="") && (range1 !=null) && (s!=null))
{
	st1.executeUpdate("insert into class values('"+year+"',"+division+",'"+dept+"',"+range1+","+range2+")");
	out.println("CLASS ADDED");
}
else if((year!="")&&(division!=null)&&(dept!="")&&(range1!=null)&&(d!=null))
{
	st2.executeUpdate("delete from class where division="+division+";");
	out.println("CLASS DELETED");
}
else 
{
	out.println("INVALID INPUTS");
}

%>
<br><br>
<center>
<form action="#" method=post>
<input type="submit" name="delete" value="delete">
<%
	if(request.getParameter("delete")!=null)
	{
		sammdao obj=new sammdao();
		String[] arr=(String[])request.getParameterValues("selected");
		obj.classdel(arr);
	}
%>
<div class="table-responsive">
<table class="table">
   <tr>
		<th>Delete</th>   
        <th>YEAR</th>
        <th>DIVISION</th>
        <th>DEPT</th>
        <th>FROM</th>
        <th>TO</th>
        <th>Edit</th>
   </tr>
   
<% 
ResultSet rs2= st2.executeQuery("select * from class");
out.println("\n");
int i = 0;
while(rs2.next())
{
%>
	<tr>
		<td><input type="checkbox" name="selected" value='<%=rs2.getString(1)%>#<%=rs2.getInt(2)%>'/></td>
  		<td><input type="text" disabled="true" id="<%=i+rs2.getString(1)%>" value="<%=rs2.getString(1)%>"/></td>
  		<td><input type="text" disabled="true" id="<%=i+rs2.getString(2)%>" value="<%=rs2.getString(2)%>"/></td>
  		<td><input type="text" disabled="true" id="<%=i+rs2.getString(3)%>" value="<%=rs2.getString(3)%>"/></td>
  		<td><input type="text" disabled="true" id="<%=i+rs2.getString(4)%>" value="<%=rs2.getString(4)%>"/></td>
  		<td><input type="text" disabled="true" id="<%=i+rs2.getString(5)%>" value="<%=rs2.getString(5)%>"/></td>
  		<td><input type="button" onclick="fun1(this,'<%=i+rs2.getString(1)%>','<%=i+rs2.getString(2)%>','<%=i+rs2.getString(3)%>','<%=i+rs2.getString(4)%>','<%=i+rs2.getString(5)%>')" value="EDIT"/></td>
  	</tr>
<% 
	i++;
}
%>
</center>
</table>
</div>
</form>
<%@ include file = "downbar.jsp" %>
<script>
var prev = []
var oyear = null
var odiv = null

function fun1(el,el_id1,el_id2,el_id3,el_id4,el_id5){
	if(el.value == "UPDATE"){
		var year = document.getElementById(el_id1).value
		var div = document.getElementById(el_id2).value
		var dept = document.getElementById(el_id3).value
		var ran1 = document.getElementById(el_id4).value
		var ran2 = document.getElementById(el_id5).value
		
		var urlstr = "edits/ClassEdit.jsp?oyear="+ oyear +"&odiv="+ odiv+"&year="+ year+"&div="+ div+"&dept="+ dept+"&ran1="+ ran1+"&ran2="+ ran2
		window.location.replace(urlstr)
		el.value = 'EDIT'
		
		for(var i; i < prev.length; i++)
			prev[i].disabled = true
			
		oyear = null
		odiv = null
	}
	else{	
		if(prev.length != 0){
			for(var i; i < prev.length; i++)
				prev[i].disabled = true	
		}
		oyear = document.getElementById(el_id1).value
		odiv = document.getElementById(el_id2).value
	
		var cur = []
			
		cur.push(document.getElementById(el_id1))
		cur.push(document.getElementById(el_id2))
		cur.push(document.getElementById(el_id3))
		cur.push(document.getElementById(el_id4))
		cur.push(document.getElementById(el_id5))

		for(var i=0; i < cur.length; i++){
			cur[i].disabled = false
		}
		
		el.value = "UPDATE"
		
		for(var i=0; i < cur.length; i++)
			prev.push(cur[i])
	}
}
</script>