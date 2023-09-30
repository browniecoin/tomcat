<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.tfnlab.mysql.User"%>
<%@ page import="com.tfnlab.mysql.UserDao" %>
<%@ page import="java.net.URLDecoder" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>Home Renovation Nation - Sign-up</title>
  <meta content="" name="description">
  <meta content="" name="keywords">
  <%@ include file="lib.jsp" %>
  <script>
    function callGeo(sk, fNameLink) {
        document.getElementById(fNameLink.substring(0,fNameLink.length-2)).value = sk;
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
          if (this.readyState == 4 && this.status == 200) {
            let items = this.responseText.split('<ITEM>');
            fNamenew = items[items.length-1];
            fNamenew = removeTrailingSpaces(fNamenew);
            document.getElementById(fNamenew+"lat").value = items[0];
            document.getElementById(fNamenew+"lng").value = items[1];


          }
        };
        const encodedString = encodeURIComponent(sk);
        var urlString = "GeocodingExample.jsp?search=" + encodedString + "&sfor=" + fNameLink;
        xhttp.open("GET", urlString, true);
        xhttp.send();
    }
    function removeTrailingSpaces(str) {
            return str.replace(/\s+$/g, "");
    }
    function callAC(sfor) {
      var xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
          let items = this.responseText.split('<ITEM>');
          fName = items[items.length-1];
          fName = removeTrailingSpaces(fName);
          for (let i = 0; i < items.length-1; i++) {
            if (items[i].length > 5) {
              let newL = "<li>" + "<a href=\"javascript:void(0)\" onclick=\"callGeo('" + items[i] +"' , '" + fName+ "')\" >" + items[i] + "</a>" + "</li>";
              document.getElementById(fName).innerHTML = document.getElementById(fName).innerHTML  + newL;
            }
          }
        }
      };
      let elName = sfor.name + "ac";
      let search = document.getElementById(sfor.name).value;

      if (search.length > 5) {
        document.getElementById(elName).innerHTML = "";
        var urlString = "GoogleAutocomplete.jsp?search=" + search + "&sfor=" + sfor.name;
        xhttp.open("GET", urlString, true);
        xhttp.send();
      }
    }

  </script>
</head>

<body>
  <%@ include file="nav.jsp" %>
  <main id="main">

    <!-- ======= Breadcrumbs ======= -->
    <section class="breadcrumbs">
      <div class="container">

        <ol>
          <li><a href="user.menu.jsp">Home</a></li>
          <li>Profile</li>
        </ol>
        <h2>Profile</h2>
      </div>
    </section><!-- End Breadcrumbs -->
    <%
    UserDao dao = new UserDao();
    String username = (String) session.getAttribute("username");
       String firstName = request.getParameter("firstName");

      User user = new User();
      if (firstName != null && firstName.trim().length() > 0) {
         String middleInitial = request.getParameter("middleInitial");
         String lastName = request.getParameter("lastName");
         String email = request.getParameter("email");
         String phone = request.getParameter("phone");
         String ogId = request.getParameter("ogId");
         String address = request.getParameter("address");
         String city = request.getParameter("city");
         String state = request.getParameter("state");
         String zipcode = request.getParameter("zipcode");
         String addressaclat = request.getParameter("addressaclat");
         String addressaclng = request.getParameter("addressaclng");

         email = email.toLowerCase();
         user = dao.getUserByUsername(username);
         user.setFirstName(firstName);
         user.setMiddleInitial(middleInitial);
         user.setLastName(lastName);
         user.setEmail(email);
         user.setPhone(phone);
         user.setAddress(address);
         user.setCity(city);
         user.setState(state);
         user.setZipcode(zipcode);
         user.setAddresslat(addressaclat);
         user.setAddresslng(addressaclng);
         dao.updateUser(user);

         session.setAttribute("usernameOBJ", user);
     }

    User usernameOBJ = (User) session.getAttribute("usernameOBJ");
    user = dao.getUserByUsername(username);
    %>
    <!-- ======= Blog Section ======= -->
    <section id="blog" class="blog">
      <div class="container px-4 px-lg-5">
        <h2>Pofile</h2>
        <%@ include file="user.menu.nav.jsp" %>
        <form method="post" action="user.edit.jsp">
            <div class="form-group mt-3">
              <label for="business_name" class="mr-2">Username:</label>
              <input type="text" class="form-control"  value="<%= user.getUsername() %>" disabled >
            </div>
           <div class="form-group  mt-3">
              <label for="firstName">First Name</label>
              <input type="text" class="form-control" id="firstName" name="firstName" value="<%= user.getFirstName() %>"  tabindex="6">
           </div>
           <div class="form-group mt-3">
              <label for="middleInitial">Middle Initial</label>
              <input type="text" class="form-control" id="middleInitial" name="middleInitial" value="<%= user.getMiddleInitial() %>"  tabindex="7">
           </div>
           <div class="form-group mt-3">
              <label for="lastName">Last Name</label>
              <input type="text" class="form-control" id="lastName" name="lastName" value="<%= user.getLastName() %>"  tabindex="8">
           </div>
           <div class="form-group mt-3">
              <label for="email">Email</label>
              <input type="email" class="form-control" id="email" name="email" value="<%= user.getEmail() %>"  tabindex="9">
           </div>
           <div class="form-group mt-3">
              <label for="phone">Phone</label>
              <input type="text" class="form-control" id="phone" name="phone" value="<%= user.getPhone() %>"  tabindex="10">
           </div>
           <div class="form-group mt-3">
              <label for="address">Address</label>
              <input type="text" class="form-control" id="address" name="address" value="<%= user.getAddress() %>" onkeypress="callAC(this)"  tabindex="12">
           </div>
           <input type="hidden" id="addressaclat" name="addressaclat" value="<%= user.getAddresslat() %>">
           <input type="hidden" id="addressaclng" name="addressaclng" value="<%= user.getAddresslng() %>">
           <div class="form-group mt-3">
             <ul id="addressac" name="addressac"></ul>
           </div>
           <%
           String address = usernameOBJ.getAddress();
           if (address != null && !address.isEmpty()) {

             String uAddSpc = usernameOBJ.getAddress().replace(" ", "-");
             String uAddPls = usernameOBJ.getAddress().replace(" ", "+");
             String uAddEnc = URLDecoder.decode(usernameOBJ.getAddress(), "UTF-8");
                   %>
             <div class="form-group mt-3">
               <hr>
               <a href="https://www.google.com/maps/search/?api=1&query=<%=uAddEnc%>">Google</a> |
               <a href="https://maps.apple.com/?address=<%=uAddEnc%>">Apple</a> |
               <a href="https://www.waze.com/en/directions?navigate=yes&latlng=<%=usernameOBJ.getAddresslat()%>,<%=usernameOBJ.getAddresslng()%>">Waze</a> |
               <a href="https://wego.here.com/directions/mix//<%=uAddSpc%>:e-eyJuYW1lIjoiMTMyNSBOLCBMYW1lciBBdmUsIEJ1cmJhaywgQ0EgOTA4NTAiLCJhZGRyZXNzIjoiMTMyNSBOLCBMYW1lciBBdmUsIEJ1cmJhaywgQ0EgOTA4NTAiLCJsYXRpdHVkZSI6MzQuMTgzNjYyLCJsb25naXR1ZGUiOi0xMTguMzI2MTAyfQ==?map=<%=usernameOBJ.getAddresslat()%>,<%=usernameOBJ.getAddresslng()%>,15,normal">HERE</a> |
               <a href="https://www.bing.com/maps?osid=a8d44b60-4f0c-4e4a-b9c7-3a3b3f597628&cp=<%=usernameOBJ.getAddresslat()%>~<%=usernameOBJ.getAddresslng()%>&lvl=15&style=r">Bing</a> |
               <a href="https://www.openstreetmap.org/search?query=<%=uAddEnc%>"#map=15/<%=usernameOBJ.getAddresslat()%>/<%=usernameOBJ.getAddresslng()%>">OSM</a> |
               <a href="https://www.tomtom.com/en_gb/maps/maps/point?lat=<%=usernameOBJ.getAddresslat()%>&lon=<%=usernameOBJ.getAddresslng()%>">TomTom</a>
               <hr>
             </div>

           <%}%>

           <div class="form-group mt-3">
              <label for="city">City</label>
              <input type="text" class="form-control" id="city" name="city" value="<%= user.getCity() %>" tabindex="13">
           </div>
           <div class="form-group mt-3">
              <label for="state">State</label>
              <input type="text" class="form-control" id="state" name="state" value="<%= user.getState() %>" tabindex="14">
           </div>
           <div class="form-group mt-3">
              <label for="zipcode">Zipcode</label>
              <input type="text" class="form-control" id="zipcode" name="zipcode" value="<%= user.getZipcode() %>" tabindex="15">
           </div>
           <div class="form-group mt-3">
             <label for="url_facebook">Referred by <a href="user.edit.referred_by.jsp"><i class="fas fa-check"></i></a></label>
             <input type="text" class="form-control" id="referred_by" name="referred_by" value="<%= user.getReferred_by() %>">
           </div>
           <div class="form-group mt-3">
             <button type="submit" class="btn btn-primary" tabindex="19">Submit</button>
           </div>
           </form>


      </div>

    </section><!-- End Blog Section -->

  </main><!-- End #main -->

  <!-- ======= Footer ======= -->
  <footer id="footer">

    <div class="footer-top">
      <div class="container">
        <div class="row">

          <div class="col-lg-3 col-md-6 footer-contact">
            <h3>Presento<span>.</span></h3>
            <p>
              A108 Adam Street <br>
              New York, NY 535022<br>
              United States <br><br>
              <strong>Phone:</strong> +1 5589 55488 55<br>
              <strong>Email:</strong> info@example.com<br>
            </p>
          </div>

          <div class="col-lg-2 col-md-6 footer-links">
            <h4>Useful Links</h4>
            <ul>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Home</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">About us</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Services</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Terms of service</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Privacy policy</a></li>
            </ul>
          </div>

          <div class="col-lg-3 col-md-6 footer-links">
            <h4>Our Services</h4>
            <ul>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Web Design</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Web Development</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Product Management</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Marketing</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Graphic Design</a></li>
            </ul>
          </div>

          <div class="col-lg-4 col-md-6 footer-newsletter">
            <h4>Join Our Newsletter</h4>
            <p>
              Sign up to learn more about technology and information management.
            </p>
            <form action="" method="post">
              <input type="email" name="email"><input type="submit" value="Subscribe">
            </form>
          </div>

        </div>
      </div>
    </div>

    <div class="container d-md-flex py-4">

      <div class="me-md-auto text-center text-md-start">
        <div class="copyright">
          &copy; Copyright <strong><span>Presento</span></strong>. All Rights Reserved
        </div>
        <div class="credits">
          <!-- All the links in the footer should remain intact. -->
          <!-- You can delete the links only if you purchased the pro version. -->
          <!-- Licensing information: https://bootstrapmade.com/license/ -->
          <!-- Purchase the pro version with working PHP/AJAX contact form: https://bootstrapmade.com/presento-bootstrap-corporate-template/ -->
          Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a>
        </div>
      </div>
      <div class="social-links text-center text-md-end pt-3 pt-md-0">
        <a href="#" class="twitter"><i class="bx bxl-twitter"></i></a>
        <a href="#" class="facebook"><i class="bx bxl-facebook"></i></a>
        <a href="#" class="instagram"><i class="bx bxl-instagram"></i></a>
        <a href="#" class="google-plus"><i class="bx bxl-skype"></i></a>
        <a href="#" class="linkedin"><i class="bx bxl-linkedin"></i></a>
      </div>
    </div>
  </footer><!-- End Footer -->

  <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>



<%@ include file="lib.bottom.jsp" %>
</body>
</html>
