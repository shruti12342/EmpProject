package EMS;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class EditEmpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Connection con;

    @Override
    public void init() throws ServletException {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "tiger");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            // Retrieve parameters from the form
            String salary = request.getParameter("salary");
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String designation = request.getParameter("designation");
            
            int employeeIdToEdit = Integer.parseInt(request.getParameter("editEmployeeId"));
            // Prepare SQL statement to update employee details
            String sql = "UPDATE Employee123 SET salary=?, address=?, phone=?, email=?, designation=? WHERE EMPLOYEEID=?";

            // Create PreparedStatement
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, salary);
            ps.setString(2, address);
            ps.setString(3, phone);
            ps.setString(4, email);
            ps.setString(5, designation);
            ps.setLong(6, employeeIdToEdit);

            // Execute the update operation
            int rowsAffected = ps.executeUpdate();
         // Inside doPost method
            if (rowsAffected > 0)
            request.getRequestDispatcher("ViewEmp.jsp").forward(request, response);

        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    }

    @Override
    public void destroy() {
        try {
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
