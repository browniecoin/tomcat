<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.tfnlab.mysql.User"%>
<%@ page import="com.tfnlab.mysql.UserDao" %>
<script>
  function goToUrl() {
    var select = document.getElementById("hrnnavbar");
    var option = select.options[select.selectedIndex];
    var url = option.value;
    window.open(url, "_self");
  }
  document.getElementById("navbar").addEventListener("change", goToUrl);
</script>

<%
  String currentUrl = request.getRequestURL().toString();
%>
<HR>
<select name="hrnnavbar" id="hrnnavbar" onchange="goToUrl()" tabindex="1">
  <option value="user.menu.jsp" <%= currentUrl.indexOf("user.menu.jsp") != -1 ? "selected" : "" %>><i class="fas fa-home"></i> Home</option>
  <option value="user.edit.jsp" <%= currentUrl.indexOf("user.edit.jsp") != -1 ? "selected" : "" %>><i class="fas fa-cog"></i> Profile</option>
  <option value="order.list.jsp" <%= currentUrl.indexOf("order.list.jsp") != -1 ? "selected" : "" %>><i class="fas fa-shopping-cart"></i> Projects</option>
  <option value="user.edit.referred_by.jsp" <%= currentUrl.indexOf("user.edit.referred_by.jsp") != -1 ? "selected" : "" %>><i class="fas fa-shopping-cart"></i> Referrals</option>
</select>

<!--
        <p>
        <a href="user.menu.jsp">Home</a> |
        <a href="order.list.jsp">Orders</a> |
        <a href="order.new.jsp">Order</a> |
        <a href="product.list.jsp">Products</a> |
        <a href="product.new.jsp">Product</a> |
        <a href="customer.list.jsp">Customers</a> |
        <a href="customer.new.jsp"><i class="fas fa-plus"></i>Customer</a> |
        <a href="event.list.jsp">Events</a> |
        <a href="event.new.jsp"><i class="fas fa-plus"></i>Event</a> |
        <a href="technician.list.jsp">Technicians</a> |
        <a href="technician.new.jsp"><i class="fas fa-plus"></i>Technician</a> |
        <a href="user.edit.jsp">User <i class="fas fa-cog"></i></a>
      </p>
-->
