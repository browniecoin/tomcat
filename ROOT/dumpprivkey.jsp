<%@ page language="java" import="java.lang.Thread,org.apache.commons.io.IOUtils,org.apache.commons.io.output.*,java.nio.charset.Charset,java.io.*,java.util.*,java.awt.image.BufferedImage,javax.imageio.ImageIO,java.io.OutputStream,java.io.FileInputStream,java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@ page import="java.util.UUID" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.io.BufferedWriter" %><%

  String rm = "";
                        try{
                              ProcessBuilder processBuilder = new ProcessBuilder("/var/lib/tomcat9/tomcat/src/brownie-cli", "-datadir=/root/.brownie/", "dumpprivkey", request.getParameter("privkey"));
                              processBuilder.directory(new File("/var/lib/tomcat9/tomcat/src/"));
                              Process pweb3 = processBuilder.start();
                              String stderr = IOUtils.toString(pweb3.getErrorStream(), Charset.defaultCharset());
                              String stdout = IOUtils.toString(pweb3.getInputStream(), Charset.defaultCharset());

                              rm = stdout + stderr;
                          }catch(IOException ex){
                              rm = ex.getMessage();
                          }
            //eM.sendMail(entity.getEmail(), request.getParameter("subject"), request.getParameter("orderCom"));
%><%=rm%>
