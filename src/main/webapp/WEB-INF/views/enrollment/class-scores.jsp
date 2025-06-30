<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>班级成绩管理 - ${course.hylCname10}</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container { 
            max-width: 1000px; 
            margin: 20px auto; 
            background-color: white; 
            padding: 30px; 
            border-radius: 15px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        h2 { 
            text-align: center; 
            color: #333; 
            border-bottom: 3px solid #667eea; 
            padding-bottom: 15px; 
            margin-bottom: 10px;
        }
        .sub-header {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            font-size: 1.1em;
        }
        .table-container {
            overflow-x: auto;
        }
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 20px;
        }
        th, td { 
            padding: 15px; 
            text-align: center; 
            border-bottom: 1px solid #e9ecef;
            vertical-align: middle;
        }
        th { 
            background-color: #f8f9fa;
            font-weight: 600;
            color: #343a40;
        }
        tr:hover {
            background-color: #f1f3f5;
        }
        .btn { 
            padding: 8px 16px; 
            text-decoration: none; 
            border-radius: 8px; 
            font-size: 14px; 
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            color: white;
            display: inline-block;
        }
        .btn-warning { 
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
        }
         .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(255, 193, 7, 0.3);
        }
        .btn-secondary { 
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            margin-top: 20px;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            font-size: 1.2em;
            color: #6c757d;
        }
        .page-actions {
            text-align: center;
            margin-top: 30px;
        }
        .score-input {
            font-weight: bold;
            color: #007bff;
        }
         .score-input.not-set {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>✏️ 班级成绩管理</h2>
        <p class="sub-header">课程: <strong>${course.hylCname10}</strong> | 教学班编号: <strong>${teachingClassId}</strong></p>
        
        <c:choose>
            <c:when test="${not empty enrollments}">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>学号</th>
                                <th>学生姓名</th>
                                <th>当前成绩</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="enrollment" items="${enrollments}">
                                <tr>
                                    <td>${enrollment.hylSno10}</td>
                                    <td>${enrollment.studentName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty enrollment.hylEscore10}">
                                                <span class="score-input">${enrollment.hylEscore10}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="score-input not-set">未录入</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${enrollment.hylStatus10}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/enrollment/edit?studentId=${enrollment.hylSno10}&teachingClassId=${enrollment.hylTcno10}" class="btn btn-warning">
                                            编辑
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-data">
                    <p>该教学班当前没有学生选课。</p>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="page-actions">
            <a href="${pageContext.request.contextPath}/teacher/my-courses" class="btn btn-secondary">返回我的课程</a>
        </div>
    </div>
</body>
</html> 