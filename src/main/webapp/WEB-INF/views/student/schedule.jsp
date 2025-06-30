<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的课表</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .nav-menu {
            background: #f8f9fa;
            padding: 10px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .nav-item {
            color: #666;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        
        .nav-item:hover {
            background-color: #e9ecef;
        }
        
        .nav-item.active {
            background-color: #667eea;
            color: white;
        }
    </style>
</head>
<body>
<div class="container mt-4">
    <!-- 导航菜单 -->
    <div class="nav-menu">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-item">
                <i class="fas fa-home"></i> 首页
            </a>
            <a href="${pageContext.request.contextPath}/student/select-course" class="nav-item">
                <i class="fas fa-plus-circle"></i> 选课
            </a>
            <a href="${pageContext.request.contextPath}/student/schedule" class="nav-item active">
                <i class="fas fa-calendar-alt"></i> 我的课表
            </a>
            <a href="${pageContext.request.contextPath}/student-score-analysis/" class="nav-item">
                <i class="fas fa-chart-bar"></i> 成绩分析
            </a>
        </div>
    </div>

    <h2 class="mb-4">我的课表</h2>
    <a href="${pageContext.request.contextPath}/student/select-course" class="btn btn-success mb-3">去选课</a>
    <table class="table table-bordered table-hover">
        <thead class="table-light">
        <tr>
            <th>课程名称</th>
            <th>教学班</th>
            <th>任课教师</th>
            <th>教室</th>
            <th>上课时间</th>
            <th>学分</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${schedule}" var="course">
            <tr>
                <td>${course.courseName}</td>
                <td>${course.className}</td>
                <td>${course.teacherName}</td>
                <td>${course.classroom != null ? course.classroom : '待安排'}</td>
                <td>
                    <c:choose>
                        <c:when test="${course.startTime != null && course.endTime != null}">
                            <c:choose>
                                <c:when test="${course.weekday == 1}">周一</c:when>
                                <c:when test="${course.weekday == 2}">周二</c:when>
                                <c:when test="${course.weekday == 3}">周三</c:when>
                                <c:when test="${course.weekday == 4}">周四</c:when>
                                <c:when test="${course.weekday == 5}">周五</c:when>
                                <c:when test="${course.weekday == 6}">周六</c:when>
                                <c:when test="${course.weekday == 7}">周日</c:when>
                                <c:otherwise>未知</c:otherwise>
                            </c:choose>
                            ${course.startTime} - ${course.endTime}
                        </c:when>
                        <c:otherwise>时间待安排</c:otherwise>
                    </c:choose>
                </td>
                <td>${course.credits}</td>
            </tr>
        </c:forEach>
        <c:if test="${empty schedule}">
            <tr><td colspan="6" class="text-center">暂无已选课程</td></tr>
        </c:if>
        </tbody>
    </table>
</div>
</body>
</html> 