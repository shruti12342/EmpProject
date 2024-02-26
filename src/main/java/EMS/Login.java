package EMS;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Connection con;

    public void init() throws ServletException {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "tiger");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String s1 = request.getParameter("uname");
            String s2 = request.getParameter("pword");

            PreparedStatement pstmt = con.prepareStatement("select * from adminup where uname=? and pword=?");
            pstmt.setString(1, s1);
            pstmt.setString(2, s2);

            ResultSet rs = pstmt.executeQuery();
            PrintWriter pw = response.getWriter();
            response.setContentType("text/html");
            pw.println("<html><head><style> .error{"
                    + "width: 50%;\r\n"
                    + "height: 40%;\r\n"
                    + "padding: 5% 5%;\r\n"
                    + "align-items: center;\r\n"
                    + "text-align: center;\r\n"
                    + "display: flex;\r\n"
                    + "flex-direction: column;\r\n"
                    + "margin: 0 auto;\r\n"
                    + "margin-top: 1%;\r\n"
                    + "color: white;\r\n"
                    + "margin-left: 40%;\r\n"
                    + "font-size: 150%;\r\n"
                    + "margin-bottom: -20%;\r\n"
                    + "</style></head> <body bgcolor = cyan text = blue><center><div class=error>");

            if (rs.next()) {
                RequestDispatcher rd = request.getRequestDispatcher("/Welcome123.html");
                rd.forward(request, response);
            } else {
                pw.println("<h3 style=\"color: red; \"\"position:fixed;\">Invalid username/password</h3>");
                pw.println("<p>Only admins can login.</p></center></h1></body></html>");
                RequestDispatcher rd = request.getRequestDispatcher("/login.html");
                rd.include(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void destroy() {
        try {
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
