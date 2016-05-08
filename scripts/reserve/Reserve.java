package hu.bme.mit.borlay.microservice.reserve

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

class Reserve {
  Reserve() {
    Statement stmt = null;
    ResultSet rs = null;
    Connection conn = null;
    try {
      conn =
        DriverManager.getConnection("jdbc:mysql://database/store?user=rooty");
      stmt = conn.createStatement();
      if (stmt.execute("SELECT foo FROM bar")) {
         rs = stmt.getResultSet();
      }
    } catch (SQLException ex) {
        System.out.println("SQLException: " + ex.getMessage());
    }
    finally {
      if (rs != null) {
          try {
              rs.close();
          } catch (SQLException sqlEx) { } // ignore
          rs = null;
      }

      if (stmt != null) {
          try {
              stmt.close();
          } catch (SQLException sqlEx) { } // ignore
          stmt = null;
      }
    }

  }
}
