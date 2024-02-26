package EMS;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AddEmpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Connection con;

    public void init() {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "tiger");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String fname = request.getParameter("fname");
            String lname = request.getParameter("lname");
            String dobStr = request.getParameter("dob");
            String salaryStr = request.getParameter("salary");
            String address = request.getParameter("address");
            String phoneStr = request.getParameter("phone");
            String email = request.getParameter("email");
            String education = request.getParameter("education");
            String designation = request.getParameter("designation");
            String aadharnumberStr = request.getParameter("aadharnumber");
            String gender = request.getParameter("gender");

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date dob = dateFormat.parse(dobStr);
            long phone = Long.parseLong(phoneStr);
            double salary = Double.parseDouble(salaryStr);
            long aadharnumber = Long.parseLong(aadharnumberStr);

            PreparedStatement pstmt = con.prepareStatement("INSERT INTO Employee123 (FirstName, LastName, DOB, Salary, Address, Phone, Email, Education, Designation, AadharNumber, Gender) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            pstmt.setString(1, fname);
            pstmt.setString(2, lname);
            pstmt.setDate(3, new java.sql.Date(dob.getTime()));
            pstmt.setDouble(4, salary);
            pstmt.setString(5, address);
            pstmt.setLong(6, phone);
            pstmt.setString(7, email);
            pstmt.setString(8, education);
            pstmt.setString(9, designation);
            pstmt.setLong(10, aadharnumber);
            pstmt.setString(11, gender);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                PrintWriter pw = response.getWriter();
                pw.println("<html><body bgcolor=green text=yellow><center>");
                pw.println("<h1>Employee details added successfully</h1>");
                pw.println("<a href='Welcome.html'>Back</a>");
                pw.println("</center></body></html>");
            } else {
                response.getWriter().println("Failed to add employee details");
            }
            request.getRequestDispatcher("AddEmp.html").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("An error occurred: " + e.getMessage());
        }
    }

    public void destroy() {
        try {
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
