<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.tfnlab.mysql.User"%>
<%@ page import="com.tfnlab.mysql.UserDao" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.tfnlab.mysql.Order" %>
<%@ page import="com.tfnlab.mysql.OrderDao" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>Home Renovation Nation - Project</title>
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
            document.getElementById(fNamenew).innerHTML = "Location identified. Gathering info for site. Will update soon. Our platform is powered by zero knowledge proofs, ensuring that your information remains private and secure.";
            document.getElementById(fNamenew+"lat").value = items[0];
            document.getElementById(fNamenew+"lng").value = items[1];


          }
        };
        const encodedString = encodeURIComponent(sk);
        var urlString = "../GeocodingExample.jsp?search=" + encodedString + "&sfor=" + fNameLink;
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
        var urlString = "../GoogleAutocomplete.jsp?search=" + search + "&sfor=" + sfor.name;
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
                long currentTimeMillis = System.currentTimeMillis();
                Timestamp currentTime = new Timestamp(currentTimeMillis);

                String username = (String) session.getAttribute("username");



                String shippingAddress = request.getParameter("shippingAddress");
                String billingAddress = request.getParameter("billingAddress");
                String paymentMethod = request.getParameter("paymentMethod");
                String orderName = request.getParameter("orderName");
                String orderDescription = request.getParameter("orderDescription");
                String shippingAddressaclat = request.getParameter("shippingAddressaclat");
                String shippingAddressaclng = request.getParameter("shippingAddressaclng");
                String billingAddressaclat = request.getParameter("billingAddressaclat");
                String billingAddressaclng = request.getParameter("billingAddressaclng");



                // Validate form data
                if (orderName != null && orderName.trim().length() > 0) {
                      int orderId = 0;
                      if (request.getParameter("orderId") != null && !request.getParameter("orderId").isEmpty()) {
                        orderId = Integer.parseInt(request.getParameter("orderId"));
                      }
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
                      Timestamp createdAt = currentTime;
                      Timestamp updatedAt = currentTime;
                      Timestamp deletedAt = currentTime;
                      Date orderDate = new Date();
                      Date shippingDate = new Date();
                      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                        try{
                           orderDate = dateFormat.parse(request.getParameter("orderDate"));
                           shippingDate = dateFormat.parse(request.getParameter("shipDate"));
                        } catch (Exception e) {
                          %><%="Error parsing date and time string: " + e.getMessage()%><%
                      }
                      Order order = new Order(orderId, username, orderDate, shippingDate, shippingAddress, billingAddress, paymentMethod, orderTotal, createdAt, updatedAt, deletedAt, orderName, orderDescription, shippingAddressaclat, shippingAddressaclng, billingAddressaclat, billingAddressaclng, "");
                      OrderDao dao = new OrderDao();
                      dao.insertOrder(order);
                      %>
                        <HR>
                        Your project information has been saved. You can find it under the 'Projects' section.
                      <%
                }else{

        %>
            <!-- ======= Contact Section ======= -->

                <form action="order.new.jsp" method="POST">

                <div class="form-group mt-3">
                <label for="orderId">Project Name:</label><br>
                <input class="form-control"  type="text" id="orderName" name="orderName" tabindex="2" >
                </div>
                <div class="form-group mt-3">
                <label class="form-label" for="orderDescription">Project Details</label>
                <textarea class="form-control" id="orderDescription" name="orderDescription" rows="5" tabindex="3" ></textarea>
                </div>

                <div class="form-group mt-3">
                <label for="orderDate">Start Date:</label><br>
                <input type="datetime-local" id="orderDate" name="orderDate" placeholder="yyyy-MM-dd" tabindex="4" ><br>
                </div>

                <div class="form-group mt-3">
                <label for="shipDate">End Date:</label><br>
                <input type="datetime-local" id="shipDate" name="shipDate" placeholder="yyyy-MM-dd" tabindex="5" ><br>
                </div>

                <div class="form-group mt-3">
                <label for="shippingAddress">Project Address:</label><br>
                <input class="form-control" type="text" id="shippingAddress" name="shippingAddress" onkeypress="callAC(this)" tabindex="6" ><br>
                <input type="hidden" id="shippingAddressaclat" name="shippingAddressaclat" >
                <input type="hidden" id="shippingAddressaclng" name="shippingAddressaclng" >
                </div>
                <hr>
                <ul id="shippingAddressac" name="shippingAddressac">
                  <small>Welcome to the Home Renovation Nation website! Here, you can easily search for information about your project site. Simply enter an address and our system will instantly display relevant Google search results. By clicking on an address, you can access even more detailed information, including GPS coordinates and cost estimates for labor and materials. With our easy-to-use platform, managing your home renovation project has never been easier!</small>
                </ul>
                <hr>

                <div class="form-group mt-3">
                <label for="orderTotal">Order Total:</label><br>
                <input type="text" id="orderTotal" name="orderTotal"  tabindex="7" ><br>
                </div>
                <hr>

                <div class="form-group mt-3">
                  <button type="submit" class="btn btn-primary" tabindex="8">Submit</button>
                </div>
                  	</form>

                 <%}%>
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
  <!-- Initialize the datepicker on the text input field -->
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
