<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page import="java.sql.*"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html ng-app="myApp">
<head>
<script type="text/javascript">
function validation(){
	re = /^[A-Za-z]+$/;
    if(re.test(document.searchForm.keyId.value)){return false;}
	 else
    {alert('Invalid..!');
    document.searchForm.keyId.value="";}
}
</script>
<link href=”bootstrap/css/bootstrap.min.css” rel=”stylesheet”
	type=”text/css” />
<script type=”text/javascript” src=”bootstrap/js/bootstrap.min.js”></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/SearchStyle.css"
	type="text/css">
<script
	src="http://ajax.googleapis.com/ajax/libs/angularjs/1.2.26/angular.min.js"></script>
<script>
// JS code 
myApp = angular.module('myApp',[]);
<%String driver = "com.mysql.jdbc.Driver";
			Class.forName(driver).newInstance();
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/searchengine", "root", "root");
			Statement stmt = conn.createStatement();
			String sql = "select * from keywords";
			ResultSet rs = stmt.executeQuery(sql);
			try {
				if (rs != null) {%> 
// JS code 
myApp.controller('myControllers',function($scope) 
   {
    $scope.keywords = [
<%rs.next();
					while (true) {%> 
     {"id":"<%=rs.getString(1)%>","name":"<%=rs.getString(2)%>","count":"<%=rs.getString(3)%>"}
   
     <%if (rs.next()) {%> , <%} else
							break;
					}
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			stmt.close();
			rs.close();
			conn.close();
			stmt = null;
			rs = null;
			conn = null;%>
         ];
 $scope.sortField='id';
 $scope.reverse=true;
}); 
</script>
<title>KeyWord Search</title>
</head>
<body ng-controller="myControllers">
	<div>
		<div class="button_box2 center">
			<form class="form-wrapper-2 cf" method="get" name="searchForm"
				action="./SearchKeyword">
				<p>
					<input ng-model="query.name" onkeyup="validation()" type="text" id="keyId" name="keyId" />
					<button class="button">
						<span>Search </span>
					</button>
					<br />
				<ul ng-repeat="emp in keywords | filter:query">
					<li id="res">{{emp.name}}</li>
				</ul>
				</p>
		</div>
		<div id="div2" class="form-group">
		<p> Output:</p>
			<ul>
				<%
					int count = 0;
					if (request.getAttribute("keyIdList") != null) {
						ArrayList arrayList = (ArrayList) request.getAttribute("keyIdList");
						//System.out.println("Result :"+arrayList);
						Iterator iterator = arrayList.iterator();
						while (iterator.hasNext()) {
							ArrayList keyList = (ArrayList) iterator.next();
				%>
				<li>Name : <%=keyList.get(1)%><br /> Count : <%=keyList.get(2)%>
				</li>
				<%
					}
					}
				%>

			</ul>
		</div>
	</div>
	</form>
</body>
</html>