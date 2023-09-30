<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.tfnlab.mysql.User"%>
<%@ page import="com.tfnlab.mysql.UserDao" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.tfnlab.mysql.Order" %>
<%@ page import="com.tfnlab.mysql.OrderDao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.StringJoiner" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.Duration" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.Period" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.Instant" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>Home Renovation Nation - Order List</title>
  <meta content="" name="description">
  <meta content="" name="keywords">
  <%@ include file="lib.jsp" %>
  <script>
    function callTFNLab() {
      var xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
          document.getElementById("status").innerHTML = this.responseText;
          const el = document.createElement('textarea');
          el.value =  this.responseText;
          el.setAttribute('readonly', '');
          el.style.position = 'absolute';
          el.style.left = '-9999px';
          document.body.appendChild(el);
          el.select();
          document.execCommand('copy');
          document.body.removeChild(el);

        }
      };
      var urlString = "gennft.jsp?walletid=" + document.getElementById("walletid").value
      document.getElementById("start").style.display="none";
      document.getElementById("status").innerHTML = "Started Avatar Generation, give it a minute. <img src=\"assets/img/wait.gif\" />";
      xhttp.open("GET", urlString, true);
      xhttp.send();
    }

    function callCopy() {
      const el = document.createElement('textarea');
      el.value =  document.getElementById("status").innerHTML;
      el.setAttribute('readonly', '');
      el.style.position = 'absolute';
      el.style.left = '-9999px';
      document.body.appendChild(el);
      el.select();
      document.execCommand('copy');
      document.body.removeChild(el);
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
          <li>Projects</li>
        </ol>
        <h2>Projects</h2>
      </div>
    </section><!-- End Breadcrumbs -->

    <!-- ======= Blog Section ======= -->
    <section id="blog" class="blog">
      <div class="container px-4 px-lg-5">
        <h2>Projects</h2>
        <%@ include file="user.menu.nav.jsp" %>
          <HR>
            <a href="order.new.jsp" tabindex="2" ><i class="fas fa-plus"></i> Project</a>
          <HR>
        <%
                String searchKey = request.getParameter("searchKey");
                OrderDao orderDao = new OrderDao();
                String username = (String) session.getAttribute("username");

                List<Order> orders = null;

                if (searchKey != null && searchKey.trim().length() > 0) {
                    orders = orderDao.getCustomerOrdersSearchKey(searchKey, username);
                }else{
                    searchKey = "";
                    orders = orderDao.getCustomerOrders(username);
                }
                %>
                <form action="order.list.jsp" method="post">
                  <div class="form-group">
                    <label for="firstName">Search Key</label>
                    <input type="text" class="form-control" id="searchKey" name="searchKey" value="<%= searchKey %>" tabindex="3">
                  </div>
                  <HR>
                  <button type="submit" class="btn btn-primary" tabindex="4" >Search</button>
                </form>
                <HR>

                <%
                    SimpleDateFormat longFormat = new SimpleDateFormat("MMMM dd, yyyy hh:mm a");
                    int tabindex = 4;
                    BigDecimal invTotal  = new BigDecimal("0");
                    Duration totalDuration = Duration.ZERO;
                %>
              <% for (Order order : orders) { %>
                <%

                    Instant startInstant = order.getOrderDate().toInstant();
                    Instant endInstant = order.getShipDate().toInstant();
                    Duration duration = Duration.between(startInstant, endInstant);
                    StringJoiner durationString = new StringJoiner(", ");
                    long days = duration.toDays();
                    long hours = duration.toHours() % 24;
                    long minutes = duration.toMinutes() % 60;
                    long seconds = duration.getSeconds() % 60;
                    if (days > 0) {
                        durationString.add(days + " day" + (days > 1 ? "s" : ""));
                    }
                    if (hours > 0) {
                        durationString.add(hours + " hour" + (hours > 1 ? "s" : ""));
                    }
                    if (minutes > 0) {
                        durationString.add(minutes + " minute" + (minutes > 1 ? "s" : ""));
                    }
                    if (seconds > 0) {
                        durationString.add(seconds + " second" + (seconds > 1 ? "s" : ""));
                    }

                    totalDuration = totalDuration.plus(duration);

                    invTotal = invTotal.add(order.getOrderTotal());
                %>

                <div class="container-fluid p-5" >
                    <div class="card p-3">
                Name: <%= order.getOrderName() %><br>
                <HR>
                Description: <%= order.getOrderDescription() %><br>
                <HR>
                Starts: <%= longFormat.format(order.getOrderDate()) %><br>
                <HR>
                Ends: <%= longFormat.format(order.getShipDate()) %><br>
                <HR>
                Duration : <%=durationString%>
                <HR>
                Project Address: <%= order.getShippingAddress() %><br>
                <HR>
                Total: <%= order.getOrderTotal() %>
                <HR>
                <a class="btn btn-primary" tabindex="<%=tabindex+""%>" href="order.edit.jsp?orderId=<%= order.getOrderId() %>" >More</a>
                    </div>
                </div>
                <hr>
                <%
                  tabindex +=1;
                %>
              <% } %>

              <%if (!orders.isEmpty()) { %>
                    <H4>Total Money: <%=invTotal%></h4>
                <HR>
                  <%
                  StringJoiner durationString = new StringJoiner(", ");
                  long days = totalDuration.toDays();
                  long hours = totalDuration.toHours() % 24;
                  long minutes = totalDuration.toMinutes() % 60;
                  long seconds = totalDuration.getSeconds() % 60;
                  if (days > 0) {
                      durationString.add(days + " day" + (days > 1 ? "s" : ""));
                  }
                  if (hours > 0) {
                      durationString.add(hours + " hour" + (hours > 1 ? "s" : ""));
                  }
                  if (minutes > 0) {
                      durationString.add(minutes + " minute" + (minutes > 1 ? "s" : ""));
                  }
                  if (seconds > 0) {
                      durationString.add(seconds + " second" + (seconds > 1 ? "s" : ""));
                  }
                  %>
                    <h4>Total Time: <%=durationString%></h4>
                <%}%>
                <%if (orders.isEmpty()) { %>
                  <p>Sorry, we could not find any projects matching your criteria.</p>
                  <p>You may want to try modifying your search parameters or creating a new project.</p>
                  <p><a href="order.new.jsp" class="btn btn-primary" >Create a new project</a></p>

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

  <%@ include file="lib.bottom.jsp" %>
  </body>
  </html>
