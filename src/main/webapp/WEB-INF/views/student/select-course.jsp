<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>学生选课</title>
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
            <a href="${pageContext.request.contextPath}/student/select-course" class="nav-item active">
                <i class="fas fa-plus-circle"></i> 选课
            </a>
            <a href="${pageContext.request.contextPath}/student/schedule" class="nav-item">
                <i class="fas fa-calendar-alt"></i> 我的课表
            </a>
            <a href="${pageContext.request.contextPath}/student-score-analysis/" class="nav-item">
                <i class="fas fa-chart-bar"></i> 成绩分析
            </a>
        </div>
    </div>

    <h2 class="mb-4">学生选课</h2>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/student/select-course">
        <div class="mb-3">
            <label for="courseId" class="form-label">选择课程</label>
            <select class="form-select" id="courseId" name="courseId" required>
                <option value="">请选择课程</option>
                <c:forEach items="${availableCourses}" var="course">
                    <option value="${course.courseId}">
                        ${course.courseName} - 学分：${course.credit}，学时：${course.hour}，类型：${course.type}，考核：${course.testType}
                    </option>
                </c:forEach>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">提交选课</button>
        <a href="${pageContext.request.contextPath}/student/schedule" class="btn btn-secondary ms-2">查看课表</a>
    </form>
</div>
</body>
</html> 