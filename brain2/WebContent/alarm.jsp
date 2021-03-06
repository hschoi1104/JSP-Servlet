<%@ page language="java" contentType="text/html; charset=utf8" 
	pageEncoding="utf-8"%>%>
﻿<%@page import="vo.MemberVO"%>
<%@page import="dao.MemberDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="dao.AlarmDAO"%>
<%@ page import="vo.AlarmVO"%>
<%@ page import="dao.MatchDAO"%>
<%@ page import="vo.MatchVO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="vo.PeopleVO" %>
<%@ page import="dao.PeopleDAO" %>
<%
response.setHeader("Pragma", "no-cache"); //HTTP 1.0
response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
response.setHeader("Cache-Control", "no-store"); //HTTP 1.1
response.setDateHeader("Expires", 0L); // Do not cache in proxy server
%>
<!DOCTYPE html>
<%

	System.out.println("--------------------main.jsp--------------------");
	String id = (String) session.getAttribute("id");
	if (id == null) {
		System.out.println("로그인 미완료 \n");
	} else
		System.out.printf("Now User ID : %s\n", id);
	String result = request.getParameter("result");
	if (result != null) {
%>
<script language="javascript">
	alert("글 작성 성공!");
</script>
<%
	result = null;
	}

	//list View
	int pageNumber = 1;
	boolean bool = false;
	if (request.getParameter("pageNumber") != null) {
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
	}
%>
<%if(id == null){ %>
<script language="javascript">
            location.href="login.jsp";
            </script>
<%}%>

<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8" />
<link rel="stylesheet" type="text/css" href="style.css" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<title></title>
<style>
table { /* 이중 테두리 제거 */
	border-collpase: none;
}

td, th { /* 모든 셀에 적용 */
	text-align: left;
	padding: 5px;
	height: 15px;
	width: 100px;
}

thead, tfoot {
	background: darkgray;
	color: yellow;
}

tbody tr:nth-child(odd) {
	background: aliceblue;
}

tbody tr:nth-child(1) {
	border-right: 1px dashed red;
	border-left: 1px dashed darkgray;
}

tbody td:nth-child(3) {
	border-left: 1px dashed red;
	border-right: 1px dashed darkgray;
}

.alarmA:link {
	color: red;
	text-decoration: none;
}

.alarmA:visited {
	color: blue;
	text-decoration: none;
}

.alarmA:hover {
	color: blue;
	text-decoration: underline;
}
</style>
</head>
<body>
	<header>
		<div id="HR">
			<%if (id == null) {%>
			<a href="login.jsp">로그인</a> | <a href="register.jsp">회원가입</a>
			<%} 
         else {
        	 ArrayList<PeopleVO> Plist = PeopleDAO.getList(pageNumber, id);
        	 SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd hh:mm:ss");
        	 Calendar cal = Calendar.getInstance();
        	 String today = null;
        	 today = formatter.format(cal.getTime());
        	 Timestamp ts = Timestamp.valueOf(today);
        	
        	 for (int i = 0; i < Plist.size(); i++) {
                MatchVO match = new MatchVO();
                MatchDAO matchdao = new MatchDAO();
                match = matchdao.getMatches(Plist.get(i).getMatchseqNo());
                AlarmVO av = new AlarmVO();	
                java.sql.Timestamp matchEt = java.sql.Timestamp.valueOf(match.getEtime());
                if(ts.compareTo(matchEt) > 0 && matchdao.MatchFull(match.getSeqNo()) == true){
                	System.out.printf("%s 글 종료되었습니다. \n",match.getTitle()) ;  
                	if(!AlarmDAO.getAlarmBytitle(match.getSeqNo()))
                       {
                	AlarmVO alarmvo = new AlarmVO();
    				alarmvo.setCreateman(match.getWriter());
    				alarmvo.setJoinman(session.getAttribute("id").toString());
    				 System.out.printf("%s\n",match.getTitle());
                	 System.out.println("알람 삽입 합니다.");
    				alarmvo.setFinishtime(java.sql.Timestamp.valueOf(match.getEtime()));
    				alarmvo.setFlag(0);
    				alarmvo.setMatchseqNo(match.getSeqNo());
    				alarmvo.setKind(3);
    				AlarmDAO.Insert(alarmvo);
                }
        	 }
        	}
         %>
			<a href="mypage.jsp"><%=id %></a> | <a href="LogoutProc">로그아웃</a>
			<%} %>
			| <a href="alarm.jsp">ALARM</a>
		</div>
		<div class="menu">
			<div id="HL">
				<img src="image/basketball.png" width="30" height="30" />&nbsp;<a
					href="main.jsp">CUKBM</a> <span
					style="font-color: gray; font-size: 10px; font-family: 고딕">가톨릭대학교
					Sports Matching Service</span>
				<div class="dropdown" style="float: right;">
					<button class="dropbtn">
						<img src="image/menubar.png" width="20" height="20" />
					</button>
					<div class="dropdown-content">
						<a href="login.jsp">로그인</a> <a href="register.jsp">회원 가입</a> <a
							href="alarm.jsp">알림</a> <a href="makethematch.jsp">매치 생성</a> <a
							href="jointhematch.jsp">매치 참가</a> <a href="mypage.jsp">마이 페이지</a>
					</div>
				</div>
			</div>
		</div>


	</header>
	<div style="background-color: #f3f3f3; height: 5px; width: 100%;">
	</div>
	<br>
	<br>

	<div class="shadow_eff2">
		<h2><%=id %>&nbsp;&nbsp;<span style="font-size: 15px;">님
				Alarm</span>
		</h2>
		<div style="background-color: #f3f3f3; height: 2px; width: 100%;">
		</div>
		<br /> <br />

		<%
				AlarmVO alarm = new AlarmVO();
				ArrayList<AlarmVO> list = AlarmDAO.getList(pageNumber, id);
				
				for (int i = 0; i < list.size(); i++) {
					if(list.get(i).getFlag() == 0){
					int asn = list.get(i).getSeqNo();
					String outs ="";
					String joinUser="";
					MatchVO match = new MatchVO();
					MatchDAO matchdao = new MatchDAO();
					match = matchdao.getMatches(list.get(i).getMatchseqNo());
					if(list.get(i).getKind() == 1){
						joinUser+=list.get(i).getJoinman();
						outs+="님이 참가했어요!";
					}
					if(list.get(i).getKind() == 2){
						outs += "필요한 참가자가 모두 모였어요!!";
					}
					if(list.get(i).getKind() == 3 ){
						outs += "참가자들의 참불여부를 알려주세요~ 매치가 종료되었어요!";
					}
					if(list.get(i).getKind() == 4){
						outs += "조건에 충족되지 않아 취소됬어요!";
					}
			%>
		<%
		//매치종료라면 평가페이지로이동
				if(list.get(i).getKind()==3){
			%>
		<div>
			<div style="background-color: #c0c0c0; height: 2px; width: 50%;">
			</div>
			<span style="font-size: 20px; color: blue;"> <a class="alarmA"
				href="matchresult.jsp?seqNo=<%=list.get(i).getMatchseqNo()%>&asn=<%=asn%>"> <%=match.getTitle() %></a>
			</span> <span>매치에 &nbsp;&nbsp;<span style="color: blue;"><%=joinUser%></span><%=outs %></span>
		</div>

		<br> <br>
		<%
		//아니라면 매치 게시글로이동
				}else{
		%>
		<%if(list.get(i).getJoinman().equals(id) == false && list.get(i).getKind() == 2){ }
		else if(list.get(i).getJoinman().equals(id) == false && list.get(i).getKind() == 4){ }
		else {%>	
		<div>
		<% %>
			<div style="background-color: #c0c0c0; height: 2px; width: 50%;">
			</div>
			<span style="font-size: 20px; color: blue;"> <a class="alarmA"
				href="viewmatch.jsp?seqNo=<%=list.get(i).getMatchseqNo()%>&asn=<%=asn%>"> <%=match.getTitle() %></a>
			</span> <span>매치에 &nbsp;&nbsp;<span style="color: blue;"><%=joinUser%></span><%=outs %></span>
		</div>
		<%%>
		<br> <br>
		<%
				}}}}
			%>
		<h2><span style="font-size: 15px;">이미 본 알람</span>
		</h2>
		<div style="background-color: #f3f3f3; height: 2px; width: 100%;">
		</div>
		<br /> <br />
		<%
				AlarmVO chkalarm = new AlarmVO();
				ArrayList<AlarmVO> chklist = AlarmDAO.getList(pageNumber, id);
			
				for (int i = 0; i < list.size(); i++) {
					if(list.get(i).getFlag() == 1){
						String outs ="";
						String joinUser="";
					MatchVO match = new MatchVO();
					MatchDAO matchdao = new MatchDAO();
					match = matchdao.getMatches(list.get(i).getMatchseqNo());
					if(list.get(i).getKind() == 1){
						joinUser+=list.get(i).getJoinman();
						outs+="님이 참가했어요!";
					}
					if(list.get(i).getKind() == 2 && list.get(i).getJoinman() == id){
						outs += "필요한 참가자가 모두 모였어요!!";
					}
					if(list.get(i).getKind() == 3){
						outs += "참가자들의 참불여부를 알려주세요~ 매치가 종료되었어요!";
					}
					if(list.get(i).getKind() == 4){
						outs += "조건에 충족되지 않아 취소됬어요!";
					}
					
					
			%>
		<%
		//매치종료라면 평가페이지로이동
				if(list.get(i).getKind()==3){
			%>
		<div>
			<div style="background-color: #c0c0c0; height: 2px; width: 50%;">
			</div>
			<span style="font-size: 20px; color: blue;"> <a class="alarmA"
				href="matchresult.jsp?seqNo=<%=list.get(i).getMatchseqNo()%>"> <%=match.getTitle() %></a>
			</span> <span>매치에 &nbsp;&nbsp;<span style="color: blue;"><%=joinUser%></span><%=outs %></span>
		</div>

		<br> <br>
		<%
		//아니라면 매치 게시글로이동
				}else{
		%>
		<div>
			<div style="background-color: #c0c0c0; height: 2px; width: 50%;">
			</div>
			<span style="font-size: 20px; color: blue;"> <a class="alarmA"
				href="viewmatch.jsp?seqNo=<%=list.get(i).getMatchseqNo()%>"> <%=match.getTitle() %></a>
			</span> <span>매치에 &nbsp;&nbsp;<span style="color: blue;"><%=joinUser%></span><%=outs %></span>
		</div>

		<br> <br>
		<%
				}}}
			%>
	</div>
	<Br>
	<br>
	<br>
	<br>
	<div class="foot">
		상호명 : CUKBM / 대표 : 가플리<br /> 전화 : 010 - 1234 - 5678<br /> Facebook :
		object-oriented paradime <br /> Address : Catholic University Of
		Korea<br /> Copyrightⓒ 2019 CUKBM. All rights reserved. E-mail :
		cukbm2@catholic.ac.kr
	</div>
</body>
</html>