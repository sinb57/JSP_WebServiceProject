<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="User.User"%>
<%@ page import="User.UserDAO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.io.PrintWriter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!doctype html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta name="viewport"
		content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>IDEARIA</title>
	
	<link rel="shortcut icon" href="/img/favicon/ecology.png">
	<link rel="stylesheet" href="/css/myPage/myPage1.css">
	<link rel="stylesheet" href="/css/bootstrap.min.css">
	<link rel="stylesheet" href="/css/googleFont.css">
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500&display=swap" rel="stylesheet">
	<style>
		.table td { text-align: center; }
	</style>
</head>
<body>

	<!-- Navigation -->
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
		<div class="container">
			<a class="navbar-brand" href="#" style="color:#FFCE1E;" class="a_500">WEB SERVICE PJ</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse"
				data-target="#navbarResponsive" aria-controls="navbarResponsive"
				aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarResponsive">
				<ul class="navbar-nav ml-auto">
					<li class="nav-item active">
						<a class="nav-link a_400" href="#">��ŷ ����
							<span class="sr-only">(current)</span>
						</a>
					</li>
					<li class="nav-item active">
						<a class="nav-link a_400" href="#">���̵�� ����
							<span class="sr-only">(current)</span>
						</a>
					</li>
					<li class="nav-item active">
						<a class="nav-link a_400" href="#">������Ʈ �����ϱ�
							<span class="sr-only">(current)</span>
						</a>
					</li>
					<li class="nav-item active">
						<a class="nav-link a_400" data-toggle="modal" data-target="#guideModal">�̿밡�̵�
						</a>
					</li>
					<!-- <li class="nav-item"><a class="nav-link" href="#">ȸ������</a></li> -->
					<li class="nav-item"><a class="nav-link a_400" href="#">�α׾ƿ�</a></li>
					<li class="nav-item"><a class="nav-link a_400" href="#">����������</a></li>
				</ul>
			</div>
		</div>
	</nav>
	
	<div style="height:80px; background-color:#FFCE1E; margin-bottom:30px;	">
	</div>


	<%
		String type = request.getParameter("type");
		String search = request.getParameter("search");
		String order = request.getParameter("order");
		int curPageNum = (Integer)request.getAttribute("curPageNum");
		int pageCount = (Integer)request.getAttribute("PageCount");
			
		
		String src = "ideas.do?";
		
		if (search != null) {
			if (!search.equals("")) {
				src += "type=" + type + "&";
				src += "search=" + search + "&";
			}
		}

	%>

	
	<!-- Page Content -->
  <div class="container" style="padding:80px; background-color:#ffffff; border:1px solid #a6a6a6; margin-bottom:50px;">

  
	  <!-- Nav tabs -->
	  <ul class="nav nav-tabs" role="tablist">
	    <li class="nav-item">
	      <a class="nav-link a_500" style="color:#FFCE1E;" href="main.do">Home</a>
	    </li>
	    <li class="nav-item">
	      <a class="nav-link a_500" style="color:#FFCE1E;" href="users.do">ȸ������</a>
	    </li>
	    <li class="nav-item">
	      <a class="nav-link active a_500" style="color:#FFCE1E;" href="ideas.do">���̵�����</a>
	    </li>
	  </ul>
	
	  <!-- Tab panes -->
	  <div class="tab-content">
	    <div id="home" class="container tab-pane active" ><br>
				<table class="table">
					<thead>
						<tr>
							<th style="background-color: #eeeeee; text-align: center;">
								<a href="<%=src%>order=registration_date">��� ����</a>
							</th>
							<th style="background-color: #eeeeee; text-align: center;">
								<a href="<%=src%>order=writer">�ۼ���</a>
							</th>
							<th style="background-color: #eeeeee; text-align: center;">
								<a href="<%=src%>order=title">����</a>
							</th>
							<th style="background-color: #eeeeee; text-align: center;">
								<a href="<%=src%>order=state">����</a>
							</th>
							<th style="background-color: #eeeeee; text-align: center;">��ȸ/����</th>
							<th style="background-color: #eeeeee; text-align: center;">���</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="idea" items="${IdeaList}">
							<tr>
								<td><c:out value="${idea.registration_date}"/></td>
								<td><c:out value="${idea.writer}"/></td>
								<td><c:out value="${idea.title}"/></td>
								<td><c:out value="${idea.state}"/></td>
								<td><a href='#id=<c:out value="${idea.id}"/>'/>����</td>
								<td><input type="checkbox" id='<c:out value="${idea.id}"/>'/></td>							
							</tr>					
						</c:forEach>	
					</tbody>
				</table>

				<div>
					<form class="form" method="post" action="users.do">
		            	<div class="form-group" style="display: inline-block;">
		                    <select id="search_type" class="form-control a_400" style="width:100px;" name="type">
		                        <option value="writer">�ۼ���</option>
		                        <option value="title">����</option>
		                        <option value="state">����</option>
		                    </select>
		                </div>
			            <input style="width:200px; display:inline-block;" type="text" class="form-control" name="search" value='${search}'>
			            <button type="submit" class="btn btn-outline-dark">�˻�</button>
		            	<div class="form-group" style="display: inline-block;">
		                    <select id="filtered" class="form-control a_400" onchange="location.href='<%=src%>filter='+(this.value);" style="width:150px;" >
		                        <option value="-1">��ü����</option>
		                        <option value="0">���� ��</option>
		                        <option value="1">���� �Ϸ�</option>
		                        <option value="2">���� �Ϸ�</option>
		                        <option value="3">���� �ߴ�</option>
		                        <option value="4">�ܺ� ������Ʈ</option>
		                    </select>
	                    </div>
			            <button type="button" onclick="groupDel();" class="btn btn-outline-dark" style="float:right;margin-right:10px;">����</button>
		            </form>
		         </div>

         
			<ul class="pagination justify-content-center">
			  <li class="page-item"><a class="page-link" href="<%=src + (curPageNum-1)%>">Previous</a></li>
			  <%

			  if (order != null) {
				  src += "order=" + order + "&";
			  }
			  src += "pageNum=";
			  

			  int pageNum = 0;
			  
			  	for (int i=0; i<5; i++) {
					pageNum = curPageNum + i - 2;						
					if (0 < pageNum && pageNum <= pageCount)
					{
				%>
			  <li class="page-item"><a class="page-link" href="<%=src + pageNum%>"><%=pageNum%></a></li>
				<%
					}
			  	}
			  %>
			  <li class="page-item"><a class="page-link" href="<%=src + (curPageNum+1)%>">Next</a></li>
			</ul>
	    </div>
	  </div>
  </div>
  <!-- /.container -->



	<!-- Footer -->
	<footer class="py-5 bg-dark">
		<div class="container">
			<p class="m-0 text-center text-white a_500">Copyright &copy;
				Web-Service 2020</p>
		</div>
		<!-- /.container -->
	</footer>
	
	
	
	
	
	<!-- MODAL  -->
	
	<!-- GUIDE -->
  <div class="modal fade" id="guideModal">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
      
        <!-- Modal Header -->
        <div class="modal-header">
          <h4 class="modal-title">Modal Heading</h4>
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        
        <!-- Modal body -->
        <div class="modal-body">
          Modal body..
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
        
      </div>
    </div>
  </div>
  
  <!-- ���� MODAL -->
  <div class="modal fade" id="mailModal">
    <div class="modal-dialog modal-xl">
      <div class="modal-content">
      
        <!-- Modal Header -->
        <div class="modal-header">
          <h4 class="modal-title">Modal Heading</h4>
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        
        <!-- Modal body -->
        <div class="modal-body">
          Modal body..
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
        
      </div>
    </div>
  </div>

	<!-- Bootstrap core JavaScript -->
	<script src="/vendor/jquery/jquery.min.js"></script>
	<script src="/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

	<script>
	
	function groupDel() {
		
		if (!confirm("������ �����Ͻðڽ��ϱ�?"))
			return;
		
		var array = [];
		
		var id = '';
		 $('input:checkbox').each(function() {
		     if(this.checked){
		    	 id = this.id;
		    	 array.push(id);
		    	 console.log(id);
		      }
		 });
		 
		 console.log(array);
		 
		$.ajax({
			url: "ideaDelete.do",
			data: { 'idArray' : array },
			type: "post",
			success: function(data) {
				alert("�����Ǿ����ϴ�.");
			},
			error: function(request, status, error) {
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
		location.reload();

	}
	
	
	window.onload = function () {
		$("#search_type").val("${type}").attr("selected", "selected");
		$("#filtered").val("${filter}").attr("selected", "selected");
	}
	
	</script>
</body>
</html>



