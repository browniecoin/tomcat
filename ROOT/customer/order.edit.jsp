<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.tfnlab.mysql.User"%>
<%@ page import="com.tfnlab.mysql.UserDao" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.tfnlab.mysql.Order" %>
<%@ page import="com.tfnlab.mysql.OrderDao" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>Home Renovation Nation - Customer Project</title>
  <meta content="" name="description">
  <meta content="" name="keywords">
  <%@ include file="lib.jsp" %>
<%
  OrderDao dao = new OrderDao();

  int orderId = 0;
  String username = (String) session.getAttribute("username");
  User usernameOBJ = (User) session.getAttribute("usernameOBJ");
  if (request.getParameter("orderId") != null && !request.getParameter("orderId").isEmpty()) {
    orderId = Integer.parseInt(request.getParameter("orderId"));
  }
%>
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
    function getCom() {
      var select = document.getElementById("customer-touch-points");
      var selectedOption = select.options[select.selectedIndex];
      var com = selectedOption.value;
      var orderId = <%=orderId%>;
      var url = "order.edit.com.jsp?orderId=" + orderId +  "&comType=" + com;
      window.open(url, "_self");
    }
    function getSchedule() {
      var select = document.getElementById("customer-touch-points");
      var selectedOption = select.options[select.selectedIndex];
      var com = selectedOption.value;
      var orderId = <%=orderId%>;
      var url = "order.edit.schedule.jsp?orderId=" + orderId +  "&comType=" + com;
      window.open(url, "_self");
    }
    function getProducts() {
      var orderId = <%=orderId%>;
      var url = "order.edit.products.jsp?orderId=" + orderId ;
      window.open(url, "_self");
    }
    function getCustomers() {
      var orderId = <%=orderId%>;
      var url = "order.edit.customers.jsp?orderId=" + orderId ;
      window.open(url, "_self");
    }
    function getPayments() {
      var orderId = <%=orderId%>;
      var url = "order.edit.payments.jsp?orderId=" + orderId ;
      window.open(url, "_self");
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
          <li>Project</li>
        </ol>
        <h2>Project</h2>
      </div>
    </section><!-- End Breadcrumbs -->

    <!-- ======= Blog Section ======= -->
    <section id="blog" class="blog">
      <div class="container px-4 px-lg-5">
        <h2>Project</h2>
        <%@ include file="user.menu.nav.jsp" %>

        <%

                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                String shippingAddress = request.getParameter("shippingAddress");
                // Validate form data
                String orderName = request.getParameter("orderName");
                if (orderName != null && orderName.trim().length() > 0) {

                      long currentTimeMillis = System.currentTimeMillis();
                      Timestamp currentTime = new Timestamp(currentTimeMillis);
                      String shippingAddressaclat = request.getParameter("shippingAddressaclat");
                      String shippingAddressaclng = request.getParameter("shippingAddressaclng");
                      String billingAddress = request.getParameter("billingAddress");
                      String billingAddressaclat = request.getParameter("billingAddressaclat");
                      String billingAddressaclng = request.getParameter("billingAddressaclng");
                      String paymentMethod = request.getParameter("paymentMethod");
                      BigDecimal orderTotal = new BigDecimal("0");
                      if (request.getParameter("orderTotal") != null && !request.getParameter("orderTotal").isEmpty()) {
                        orderTotal = new BigDecimal(request.getParameter("orderTotal"));
                      }
                      if (request.getParameter("shippingAddressaclat") == null || request.getParameter("shippingAddressaclat").isEmpty()) {
                        shippingAddressaclat = "0.0";
                      }
                      if (request.getParameter("shippingAddressaclng") == null || request.getParameter("shippingAddressaclng").isEmpty()) {
                        shippingAddressaclng = "0.0";
                      }
                      if (request.getParameter("billingAddressaclat") == null || request.getParameter("billingAddressaclat").isEmpty()) {
                        billingAddressaclat = "0.0";
                      }
                      if (request.getParameter("billingAddressaclng") == null || request.getParameter("billingAddressaclng").isEmpty()) {
                        billingAddressaclng = "0.0";
                      }
                      Date orderDate = new Date();
                      Date shippingDate = new Date();
                        try{
                           orderDate = dateFormat.parse(request.getParameter("orderDate"));
                           shippingDate = dateFormat.parse(request.getParameter("shipDate"));
                        } catch (Exception e) {
                          %><%="Error parsing date and time string: " + e.getMessage()%><%
                      }
                      Timestamp createdAt = currentTime;
                      Timestamp updatedAt = currentTime;
                      Timestamp deletedAt = currentTime;
                      String orderDescription = request.getParameter("orderDescription");
                      Order order = new Order(orderId, username, orderDate, shippingDate, shippingAddress, billingAddress, paymentMethod, orderTotal, createdAt, updatedAt, deletedAt, orderName, orderDescription, shippingAddressaclat, shippingAddressaclng, billingAddressaclat, billingAddressaclng , "");
                      dao.updateOrder(order);

                }
        %>
        <%
          Order order = dao.getOrderByOrderId(orderId, username);

        %>
        <!-- ======= Contact Section ======= -->

        <form action="order.edit.jsp" method="POST">
                <div class="form-group mt-3">
          <label for="orderId">Project Name:</label><br>
          <input type="text" id="orderName" name="orderName" value="<%= order.getOrderName() %>"><br>
                <div class="form-group mt-3">
          <label for="orderId">Project Description:</label><br>
          <div class="form-group mt-3">
          <textarea class="form-control" id="orderDescription" name="orderDescription" rows="5"><%= order.getOrderDescription() %></textarea>
          <input type="hidden" id="orderId" name="orderId" value="<%= order.getOrderId() %>">
          </div>
          <div class="form-group mt-3">
            <label for="endTime">Start Date:</label>
            <input type="datetime-local" class="form-control" name="orderDate" value="<%= order.getOrderDate() %>" datepicker >
          </div>

          <div class="form-group mt-3">
          <label for="shipDate">End Date:</label><br>
          <input class="form-control" type="datetime-local" id="shipDate" name="shipDate" placeholder="yyyy-MM-dd" value="<%= order.getShipDate() %>"><br>
          </div>
          <div class="form-group mt-3">
          <label for="shippingAddress">Project Address:</label><br>
          <input class="form-control" type="text" id="shippingAddress" name="shippingAddress" value="<%= order.getShippingAddress() %>" onkeypress="callAC(this)"><br>
          <input type="hidden" id="shippingAddressaclat" name="shippingAddressaclat" value="<%= order.getShippingAddresslat() %>">
          <input type="hidden" id="shippingAddressaclng" name="shippingAddressaclng" value="<%= order.getShippingAddresslng() %>">
          </div>
          <ul id="shippingAddressac" name="shippingAddressac"></ul>
          <hr>
            <%
              String uAddPls = usernameOBJ.getAddress().replace(" ", "+");
            if(usernameOBJ!=null && usernameOBJ.getAddress() !=null){
              String sAddSpcS = order.getShippingAddress().replace(" ", "-");
              String sAddPlsS = order.getShippingAddress().replace(" ", "+");
              String sAddEncS = URLDecoder.decode(order.getShippingAddress(), "UTF-8");

              String uAddEnc = URLDecoder.decode(usernameOBJ.getAddress(), "UTF-8");
                    %>
                    <a href="https://www.google.com/maps/search/?api=1&query=<%=sAddEncS%>">Google</a> |
                    <a href="https://maps.apple.com/?address=<%=sAddEncS%>">Apple</a> |
                    <a href="https://www.waze.com/en/directions?navigate=yes&latlng=<%=order.getShippingAddresslat()%>,<%=order.getShippingAddresslng()%>">Waze</a> |
                    <a href="https://wego.here.com/directions/mix//<%=sAddSpcS%>:e-eyJuYW1lIjoiMTMyNSBOLCBMYW1lciBBdmUsIEJ1cmJhaywgQ0EgOTA4NTAiLCJhZGRyZXNzIjoiMTMyNSBOLCBMYW1lciBBdmUsIEJ1cmJhaywgQ0EgOTA4NTAiLCJsYXRpdHVkZSI6MzQuMTgzNjYyLCJsb25naXR1ZGUiOi0xMTguMzI2MTAyfQ==?map=<%=order.getShippingAddresslat()%>,<%=order.getShippingAddresslng()%>,15,normal">HERE</a> |
                    <a href="https://www.bing.com/maps?osid=a8d44b60-4f0c-4e4a-b9c7-3a3b3f597628&cp=<%=order.getShippingAddresslat()%>~<%=order.getShippingAddresslng()%>&lvl=15&style=r">Bing</a> |
                    <a href="https://www.openstreetmap.org/search?query=<%=sAddEncS%>"#map=15/<%=order.getShippingAddresslat()%>/<%=order.getShippingAddresslng()%>">OSM</a> |
                    <a href="https://www.tomtom.com/en_gb/maps/maps/point?lat=<%=order.getShippingAddresslat()%>&lon=<%=order.getShippingAddresslng()%>">TomTom</a>
                    <hr>
                    <a href="https://www.google.com/maps/dir/?api=1&origin=<%=uAddPls%>&destination=<%=sAddPlsS%>">Get directions</a>
              <%
                  }
              %>

          <hr>
          <div class="form-group mt-3">
            <label for="orderTotal">Project Total Cost:</label><br>
            <input type="text" id="orderTotal" name="orderTotal" value="<%= order.getOrderTotal() %>"><br>
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


  <script>
    $(function () {
     var bindDatePicker = function() {
  		$(".date").datetimepicker({
          format:'YYYY-MM-DD',
  			icons: {
  				time: "fa fa-clock-o",
  				date: "fa fa-calendar",
  				up: "fa fa-arrow-up",
  				down: "fa fa-arrow-down"
  			}
  		}).find('input:first').on("blur",function () {
  			// check if the date is correct. We can accept dd-mm-yyyy and yyyy-mm-dd.
  			// update the format if it's yyyy-mm-dd
  			var date = parseDate($(this).val());

  			if (! isValidDate(date)) {
  				//create date based on momentjs (we have that)
  				date = moment().format('YYYY-MM-DD');
  			}

  			$(this).val(date);
  		});
  	}

     var isValidDate = function(value, format) {
  		format = format || false;
  		// lets parse the date to the best of our knowledge
  		if (format) {
  			value = parseDate(value);
  		}

  		var timestamp = Date.parse(value);

  		return isNaN(timestamp) == false;
     }

     var parseDate = function(value) {
  		var m = value.match(/^(\d{1,2})(\/|-)?(\d{1,2})(\/|-)?(\d{4})$/);
  		if (m)
  			value = m[5] + '-' + ("00" + m[3]).slice(-2) + '-' + ("00" + m[1]).slice(-2);

  		return value;
     }

     bindDatePicker();
   });
  </script>
  <%@ include file="lib.bottom.jsp" %>
  </body>
  </html>

</body>

</html>
