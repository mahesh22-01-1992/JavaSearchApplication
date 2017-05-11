import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SearchKeyword")
public class SearchKeyword extends HttpServlet {
	public static String connectionString = "jdbc:mysql://localhost:3306/searchengine";
	public static String driver = "com.mysql.jdbc.Driver";
	Connection con = null;
	Statement statement, statement1, statement2;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html");
		try {
			Class.forName(driver).newInstance();
			con = DriverManager.getConnection(connectionString, "root", "root");
			String keyWord = request.getParameter("keyId");
			String fetchQuery = "select * from keywords where Names='" + keyWord + "';";
			ArrayList arrayList = null;
			ArrayList keyIdList = new ArrayList();
			System.out.println("Query :" + fetchQuery);
			statement = con.createStatement();
			statement1 = con.createStatement();
			statement2 = con.createStatement();
			ResultSet results = statement.executeQuery(fetchQuery);
			if (results != null) {
				while (results.next()) {
					int id = Integer.parseInt(results.getString(1));
					String name = results.getString(2);
					int count = Integer.parseInt(results.getString(3)) + 1;
					System.out.println("Id:" + id + " Name:" + name + " Count:" + count);
					String UpdateQuery = "UPDATE keywords set countTracker=" + count + " WHERE id=" + id + ";";
					System.out.println("Update Query :" + UpdateQuery);
					arrayList = new ArrayList();
					arrayList.add(id);
					arrayList.add(name);
					arrayList.add(count);
					keyIdList.add(arrayList);
					System.out.println("Array List ::" + arrayList);
					statement1.executeUpdate(UpdateQuery);
				}
				System.out.println("KeyId List ::" + arrayList);
				request.setAttribute("keyIdList", keyIdList);
				RequestDispatcher dispatcher = request.getRequestDispatcher("/index.jsp");
				dispatcher.forward(request, response);
			}
			con.close();
			System.out.println("Connection Closed..!!");
		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

}
