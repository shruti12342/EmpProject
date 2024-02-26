<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            border-radius: 8px;
        }
        th, td {
            border: 1px solid #dddddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
            font-weight: bold;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #dddddd;
        }
        .btn-container {
            display: flex;
            justify-content: space-between;
        }
        .btn {
            background-color: #f44336;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 20px;
            transition: background-color 0.3s ease;
            text-decoration: none;
            font-weight: bold;
        }
        
        input[type="button"]{
        	font-weight: bold;
        	font-size: 15px;
        }
        .btn:hover {
            background-color: #d32f2f;
        }
        
        
        
        .header{
        	display: inline;
        	margin-left: 50%;
        }
        
        @media screen and (orientation: portrait){
        	.header{
        		display: inline;
        	}
        }
        
        .employeeid{
        	font-weight: bold;
        	color: black;
        	margin-left: 5%;
        }
        
        .txtid{
        	width: 10%;
        	padding: 8px;
        }
        
        #otherbtn{
        	margin-left: 30%;
        }
        
        
        /* Styles for modal dialog */
        .modal{
                display: none;
                position: fixed;
                top: -100%;
                left:0;
                right:0;
                width:100%;
                height:100%;
                z-index: 1;
                transition: top 0.5s ease;
            }

            .modal-content{
            	margin: 10px auto;
                padding: 20px;
                border: 1px solid  #595151bc;
                border-radius: 5px;
                width: 40%;
                font-weight: bold;
                background-color: white;
            }

            .close{
                float: right;
                font-size: 30px;
                font-weight: bold;
                color:rgb(114, 114, 114);
            }

            .close:hover,
            .close:focus{
                color: black;
                text-decoration: none;
                cursor: pointer;
            }

            .modelinp{
                width: 80%;
                margin-left: 5%;
                padding: 2%;
                font-size: medium;
                
            }
            
            
            
            

            input[type="submit"]{
                width: 85%;
                margin-left: 5%;
                padding: 2%;
                font-size: medium;
                background-color: rgb(91, 182, 91);
                border: none;
                border-radius: 5px;
                color: white;
            }
            
             .new-modal{
        display: none;
        background-color: rgb(235, 216, 216);
        position: fixed;
        color: green;
        margin: 10% 10%;
        border: none;
        border-radius: 10px;
        width:40% ;
        align-items: center;
        text-align: center;
      }

      .new-close{
        float: right;
        padding: 5% 7%;
        font-size: 200%;
        color: black;
      }

      #new-h1{
        margin: 0 auto;
        padding: 20% 10%;
        
      }

      .new-close:hover{
        font-weight: bold;
        cursor: pointer;

      }
    </style>
    <script>
        function searchclick(){
            var empid = document.getElementById("txtid").value;
            var rows = document.querySelectorAll("table tr:not(:first-child)");
            for(var i=0; i<rows.length; i++){
                var row = rows[i];
                var idCell = row.cells[0];
                if(idCell.textContent.trim() === empid){
                    row.style.display = "table-row";
                }else{
                    row.style.display = "none";
                }
            }
        }
        
        function refreshclick(){
            var rows = document.querySelectorAll("table tr:not(:first-child)");
            for(var i=0; i<rows.length; i++){
                rows[i].style.display = "table-row";
            }
        }
        
        
        function printclick(){
            var printwindow = window.open();
            var content = "<html><head><title>Employees Details</title></head><body>";
            content+= "<table border='1'>";
            var table = document.querySelector("table");
            var rows = table.querySelectorAll("tr");
            rows.forEach(function(row){
                var cells = row.querySelectorAll("td:not(:last-child), th:not(:last-child)");
                content+= "<tr>"
                cells.forEach(function(cell){
                        content+= "<td>"  + cell.textContent + "</td>";
                });
                content+= "</tr>";
            });
            content+="</body>";
            content+="</html>";
            
            printwindow.document.open();
            printwindow.document.write(content);
            printwindow.document.close();
            printwindow.print();
        }
        
        function openUpdateDialog(employeeId) {
        	document.getElementById('editEmployeeId').value = employeeId;
            var dialog = document.getElementById("modalid").style.display="block";
            setTimeout(function(){
            	document.getElementById('modalid').style.top='0';
            }, 100 );
            
        }

        function closemodal() {
            var dialog = document.getElementById("modalid").style.top='-100%';
            setTimeout(function(){
            	document.getElementById("modalid").style.display='none';
            }, 500);
        }
        
        function openNewmodal() {
            var salary = document.getElementsByName('salary')[0].value.trim();
            var address = document.getElementsByName('address')[0].value.trim();
            var phone = document.getElementsByName('phone')[0].value.trim();
            var email = document.getElementsByName('email')[0].value.trim();
            var designation = document.getElementsByName('designation')[0].value.trim();
            
            if (salary === "" || address === "" || phone === "" || email === "" || designation === "") {
                alert("Please fill out all fields");

            }

            if (salary.length > 8) {
                alert("Salary must be less than or equal to 8 digits");
                return false;
            }

            if (address.length > 100) {
                alert("Address must be less than or equal to 100 characters");
                return false;
            }

            if (phone.length !== 10) {
                alert("Phone number must be exactly 10 digits");
                return false;
            }

            if (designation.length > 50) {
                alert("Designation must be less than or equal to 50 characters");
                return false;
            }

            // Show alert message for confirmation
            var confirmUpdate = confirm("Are you sure you want to update the details?");
            if (confirmUpdate) {
                // Submit the form if user confirms
                document.forms["myform"].submit();
            }
        }


        function closeNewmodal(){
          var closeid = document.getElementById("new-modal").style.display="none";
        }
        
        function openRemoveDialog(employeeId) {
            var confirmRemove = confirm("Are you sure you want to remove Employee ID " + employeeId + "?");
            if (confirmRemove) {
                // If user confirms, proceed with the removal
                var removeUrl = "RemoveEmp.jsp?removeEmployeeId=" + employeeId;
                window.location.href = removeUrl; // Redirect to remove employee page
            } else {
                // If user cancels, do nothing
                return false;
            }
        }


        

        
    </script>

</head>
<body>

    <div class="header">
        <form>
            <label for="employeeid" class="employeeid">Search By Employee ID</label>
            <input type="text" class="txtid" id="txtid"> 
            <input type="button" value="Search" onclick="searchclick()" class="btn">
            <input type="reset" value="Refresh" class="btn" onclick="refreshclick()">
            <input type="button" value="Print" class="btn"  onclick=printclick()>
    		<a href="Welcome123.html" class="btn" >Back</a>
        </form>
    </div>
    
    <table id="employeeTable">
        <tr>
            <th>Employee ID</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>DOB</th>
            <th>Salary</th>
            <th>Address</th>
            <th>Phone</th>
            <th>Email</th>
            <th>Education</th>
            <th>Designation</th>
            <th>Aadhar Number</th>
            <th>Gender</th>
            <th>Action</th>
        </tr>
        
        <%!
            Connection con;
            public void jspInit() {
                try {
                    Class.forName("oracle.jdbc.driver.OracleDriver");
                    con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "tiger");
                } catch(Exception e) {
                    e.printStackTrace();
                    throw new RuntimeException("Failed to initialize database connection", e);
                }
            }
        %>
        
        <%
            try {
                if (con == null) {
                    throw new RuntimeException("Database connection is null");
                }
                
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM Employee123");
                
                while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("EMPLOYEEID") %></td>
            <td><%= rs.getString("FIrstName") %></td>
            <td><%= rs.getString("LASTNAME") %></td>
            <td><%= rs.getDate("DOB") %></td>
            <td><%= rs.getDouble("SALARY") %></td>
            <td><%= rs.getString("ADDRESS") %></td>
            <td><%= rs.getLong("PHONE") %></td>
            <td><%= rs.getString("EMAIL") %></td>
            <td><%= rs.getString("EDUCATION") %></td>
            <td><%= rs.getString("DESIGNATION") %></td>
            <td><%= rs.getLong("AADHARNUMBER") %></td>
            <td><%= rs.getString("GENDER") %></td>
            <td class="btn-container">
                <button onclick="openUpdateDialog('<%= rs.getInt("EMPLOYEEID") %>')" class="btn">Update</button>
                <button onclick="openRemoveDialog('<%= rs.getInt("EMPLOYEEID") %>')" class="btn">Remove</button>
                
            </td>
        </tr>
        <% 
                }
                rs.close();
                stmt.close();
            } catch (Exception e) {
                e.printStackTrace();
                throw new RuntimeException("Failed to fetch data from database", e);
            }
        %>
        
    </table>
    
    <!-- The Modal -->
    <div id="modalid" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closemodal()">&times;</span>
                <h1>Edit Employees Details</h1>
            <form id="editForm" action="edit" method="post" name="myform">
                <label for="salary">Salary:</label><br>
                <input type="number" id="salary" class="modelinp"  name="salary" required><br><br>

                <label for="address">Address:</label><br>
                <input type="text" id="address" class="modelinp" name="address" required><br><br>

                <label for="phone">Phone:</label><br>
                <input type="number" id="phone" class="modelinp" name="phone" required><br><br>

                <label for="email">Email:</label><br>
                <input type="email" id="email" class="modelinp" name="email" required><br><br>

                <label for="designation">Designation:</label><br>
                <input type="text" id="designation" class="modelinp" name="designation" required><br><br>

                <!-- Add a hidden input field to pass employee ID -->
                <input type="hidden" id="editEmployeeId" class="modelinp" name="editEmployeeId">
                
                <input type="submit" value="Save" id="new-inpid" onclick="openNewmodal()">
            </form>
            </div>
        </div>
        
        <div id="new-modal" class="new-modal">
      <div id="new-modalcontent" class="modal-content">
        <span id="new-close" onclick="closeNewmodal()" class="new-close">&times;</span>
        <h1 id="new-h1">Details updated successfully</h1>
      </div>
    </div>
        
       
    
        
    <!-- Displaying the message -->
    <% if (request.getAttribute("message") != null) { %>
        <p><%= request.getAttribute("message") %></p>
    <% } %>
</body>
</html>
