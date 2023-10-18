<%@ page language="java" import="java.lang.Thread,org.apache.commons.io.IOUtils,org.apache.commons.io.output.*,java.nio.charset.Charset,java.io.*,java.util.*,java.awt.image.BufferedImage,javax.imageio.ImageIO,java.io.OutputStream,java.io.FileInputStream,java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@ page import="java.util.UUID" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.io.BufferedWriter" %><%

  String rm = "";
  String networkhashpsValue = "0.0";
                        try{
                              ProcessBuilder processBuilder = new ProcessBuilder("/var/lib/tomcat9/tomcat/src/brownie-cli", "-datadir=/root/.brownie/", "getmininginfo");
                              processBuilder.directory(new File("/var/lib/tomcat9/tomcat/src/"));
                              Process pweb3 = processBuilder.start();
                              String stderr = IOUtils.toString(pweb3.getErrorStream(), Charset.defaultCharset());
                              String stdout = IOUtils.toString(pweb3.getInputStream(), Charset.defaultCharset());

                              rm = stdout + stderr;
                          }catch(IOException ex){
                              rm = ex.getMessage();
                          }

                          String targetKey = "\"networkhashps\":";
                          int startIndex = rm.indexOf(targetKey);

                          if (startIndex != -1) {
                              // Calculate the starting index for the value
                              startIndex += targetKey.length();

                              // Find the ending index of the value
                              int endIndex = rm.indexOf(",", startIndex);

                              if (endIndex == -1) {
                                  // If there's no comma, assume it's the end of the JSON object
                                  endIndex = rm.indexOf("}", startIndex);
                              }

                              if (endIndex != -1) {
                                  // Extract the "networkhashps" value
                                  networkhashpsValue = rm.substring(startIndex, endIndex).trim();
                                  System.out.println("networkhashps: " + networkhashpsValue);
                              } else {
                                  System.out.println("Failed to find the end of the value for 'networkhashps'");
                              }
                          } else {
                              System.out.println("Key 'networkhashps' not found in the JSON string.");
                          }
            //eM.sendMail(entity.getEmail(), request.getParameter("subject"), request.getParameter("orderCom"));
%><%=networkhashpsValue%>
