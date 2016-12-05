package hu.bme.mit.borlay.microservice.order;

import java.sql.*;
import java.io.*;
import java.util.*;
import java.util.Date;
import java.util.logging.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.net.URLDecoder;
import org.json.*;

public class Reserve extends HttpServlet{

    private ResultSet rs = null;
    private Connection conn = null;
    private Logger logger = null;

    public void init() throws ServletException
    {
        this.logger = Logger.getLogger("OrderLog");
        try {
            FileHandler fh = new FileHandler("/var/log/tomcat/order.log");
            this.logger.addHandler(fh);
            SimpleFormatter formatter = new SimpleFormatter();
            fh.setFormatter(formatter);
        } catch (Exception ex) {
            System.out.println("Failed to create logger.");
        }
        try {
          try {
             Class.forName("com.mysql.jdbc.Driver");
           }
           catch (ClassNotFoundException e) {
             // TODO Auto-generated catch block
             e.printStackTrace();
           }
            conn =
                DriverManager.getConnection("jdbc:mysql://database/bookstore", "store", "store");
        } catch (SQLException ex) {
            this.logger.info("SQLException: " + ex.getMessage());
        }
    }

    public void doGet(HttpServletRequest request,
          HttpServletResponse response) throws ServletException, IOException {
           response.setContentType("text/html");
           PrintWriter out = response.getWriter();
           out.println("<html> <title>Check Order Service</title>"
               + "<body><h1>Check Order Service</body></h1></html> ");
    }

    public void doPost(HttpServletRequest request,
          HttpServletResponse response) throws ServletException, IOException {
        this.logger.info("New request received!");
        PreparedStatement selectStmt = null;
        PreparedStatement updateStmt = null;
        PreparedStatement insertStmt = null;
        String nameOfBook = URLDecoder.decode(request.getParameter("nameOfBook"), "UTF-8");
        int number = Integer.parseInt(request.getParameter("number"));
        this.logger.info("Name of book: "+nameOfBook+" Number of book: "+new Integer(number).toString());
        JSONObject jsonObject = new JSONObject();
        int status = 200;
        try {
            selectStmt = this.conn.prepareStatement(
                "SELECT count FROM store WHERE book_name LIKE ?"
            );
            updateStmt = this.conn.prepareStatement(
                "UPDATE store SET count = ? WHERE book_name LIKE ?"
            );
            insertStmt = this.conn.prepareStatement(
                "INSERT INTO reservation (username, book_name, count, res_date)" +
                "VALUES (?, ?, ?, ?)"
            );
            this.logger.info("Get book list");
            this.conn.setAutoCommit(true);
            selectStmt.setString(1, nameOfBook);
            if (selectStmt.execute()) {
               rs = selectStmt.getResultSet();
               rs.next();
               int count = rs.getInt("COUNT");
               count = count - number;
               if (count > 0) {
                  this.logger.info("Update books in database");
                  updateStmt.setInt(1, count);
                  updateStmt.setString(2, nameOfBook);
                  updateStmt.executeUpdate();
                  this.logger.info("Save the executed order");
                  insertStmt.setString(1, "test");
                  insertStmt.setString(2, nameOfBook);
                  insertStmt.setInt(3, number);
                  insertStmt.setString(4, new Date().toString());
                  insertStmt.executeUpdate();
               } else {
                 this.logger.info("Not enough book in the store!");
                 status = 500;
               }
            }
        } catch(Exception ex) {
            this.logger.info("Something went wrong on updating database: " + ex.getMessage());
            status = 500;
        }
        finally {
            this.logger.info("Releasing Database resources ...");
            if (this.rs != null) {
                try {
                    this.rs.close();
                } catch (SQLException sqlEx) { } // ignore
                this.rs = null;
            }
            if (selectStmt != null) {
                try {
                    selectStmt.close();
                } catch (SQLException sqlEx) { } // ignore
                selectStmt = null;
            }
            if (updateStmt != null) {
                try {
                    updateStmt.close();
                } catch (SQLException sqlEx) { } // ignore
                updateStmt = null;
            }
        }
        this.logger.info("Sending JSON response ...");
        jsonObject.put("status", 0);
        jsonObject.put("message", "The reservation has been prooceeded!");
        response.setContentType("application/json");
        // Get the printwriter object from response to write the required json object to the output stream
        PrintWriter out = response.getWriter();
        // Assuming your json object is **jsonObject**, perform the following, it will return your json object
        out.print(jsonObject);
        out.flush();
    }

    public void destroy()
    {
        // do nothing.
    }
}
