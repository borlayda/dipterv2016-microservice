package hu.bme.mit.borlay.microservice.reserve;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import org.json.JSONException;
import org.json.JSONObject;

@Path("/reserve")
class Reserve {

    private ResultSet rs = null;
    private Connection conn = null;

    Reserve() {
        try {
            conn =
                DriverManager.getConnection("jdbc:mysql://database/bookstore", "store", "store");
        } catch (SQLException ex) {
            System.out.println("SQLException: " + ex.getMessage());
        }
    }

    @POST
    @Produces("application/json")
    public Response buySomeBooks(String nameOfBook, int number) throws JSONException {
        PreparedStatement selectStmt = null;
        PreparedStatement updateStmt = null;
        PreparedStatement insertStmt = null;
        JSONObject jsonObject = new JSONObject();
        try {
            selectStmt = this.conn.prepareStatement(
                "SELECT count FROM store WHERE book_name LIKE '?'"
            );
            updateStmt = this.conn.prepareStatement(
                "UPDATE store SET count=? WHERE book_name LIKE '?'"
            );
            insertStmt = this.conn.prepareStatement(
                "INSERT INTO reservation (username, book_name, count, res_date)" +
                "VALUES ('?', '?', ?, ?)"
            );
            this.conn.setAutoCommit(true);
            selectStmt.setString(1, nameOfBook);
            if (selectStmt.execute()) {
               rs = selectStmt.getResultSet();
               rs.next();
               int count = rs.getInt("COUNT");
               count = count - number;
               updateStmt.setInt(1, count);
               updateStmt.setString(2, nameOfBook);
               updateStmt.executeUpdate();
               insertStmt.setString(1, "test");
               insertStmt.setString(2, nameOfBook);
               insertStmt.setInt(3, number);
               insertStmt.setString(4, new Date().toString());
               insertStmt.executeUpdate();
            }
        } catch(Exception ex) {
            System.out.println("Something went wrong on updating database: " + ex.getMessage());
        }
        finally {
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
        jsonObject.put("status", 0);
        jsonObject.put("message", "The reservation has been prooceeded!");
        String result = "@Produces(\"application/json\") Output: \n\nF to C Converter Output: \n\n" + jsonObject;
        return Response.status(200).entity(result).build();
    }
}
