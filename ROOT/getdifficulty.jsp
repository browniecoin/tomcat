<%@ page language="java" import="java.lang.Thread,org.apache.commons.io.IOUtils,org.apache.commons.io.output.*,java.nio.charset.Charset,java.io.*,java.util.*,java.awt.image.BufferedImage,javax.imageio.ImageIO,java.io.OutputStream,java.io.FileInputStream,java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@ page import="java.util.UUID" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.io.BufferedWriter" %><%

  String rm = "getHashRate: ";
                        try{
                              Process pweb3 = new ProcessBuilder("/root/browniecoins/src/brownie-cli", "getdifficulty").start();
                              String stderr = IOUtils.toString(pweb3.getErrorStream(), Charset.defaultCharset());
                              String stdout = IOUtils.toString(pweb3.getInputStream(), Charset.defaultCharset());
                              rm = stdout + stderr + " TEST ";
                          }catch(IOException ex){
                              rm = ex.getMessage();
                          }
            //eM.sendMail(entity.getEmail(), request.getParameter("subject"), request.getParameter("orderCom"));
%>TEST UPDATE :  - DONE <%=rm%> DONE
