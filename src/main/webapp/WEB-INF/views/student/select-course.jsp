<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

        .course-card {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            background-color: #f8f9fa;
            transition: box-shadow 0.3s;
        }

        .course-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .course-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .course-title {
            font-size: 1.2em;
            font-weight: bold;
            color: #333;
        }

        .course-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 10px;
            margin-bottom: 10px;
        }

        .info-item {
            font-size: 0.9em;
            color: #666;
        }

        .info-label {
            font-weight: bold;
            color: #333;
        }

        .capacity-info {
            color: #28a745;
            font-weight: bold;
        }

        .capacity-full {
            color: #dc3545;
        }

        .enrolled-section {
            background-color: #e8f5e8;
            border-color: #c3e6cb;
        }

        .available-section {
            background-color: #f8f9fa;
            border-color: #dee2e6;
        }

        .btn-enroll {
            background-color: #28a745;
            border-color: #28a745;
        }

        .btn-drop {
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .weekday-map {
            display: none;
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
            <a href="${pageContext.request.contextPath}/student-score-analysis/" class="nav-item">
                <i class="fas fa-user-edit"></i> 个人信息修改
            </a>
        </div>
    </div>

    <h2 class="mb-4">学生选课系统</h2>

    <!-- 成功和错误消息 -->
    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle"></i> ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle"></i> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- 已选课程部分 -->
    <div class="row mb-4">
        <div class="col-12">
            <h4><i class="fas fa-book-open text-success"></i> 已选课程 (${enrolledClasses.size()}门)</h4>
            
            <c:choose>
                <c:when test="${empty enrolledClasses}">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i> 您还没有选择任何课程。
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="course" items="${enrolledClasses}">
                        <div class="course-card enrolled-section">
                            <div class="course-header">
                                <div class="course-title">
                                    <i class="fas fa-book"></i> ${course.courseName}
                                </div>
                                <div>
                                    <span class="badge bg-success">已选</span>
                                </div>
                            </div>
                            <div class="course-info">
                                <div class="info-item">
                                    <span class="info-label">教学班:</span> ${course.tcname}
                                </div>
                                <div class="info-item">
                                    <span class="info-label">学年学期:</span> ${course.year}年第${course.term}学期
                                </div>
                                <div class="info-item">
                                    <span class="info-label">学分:</span> ${course.credit}
                                </div>
                                <div class="info-item">
                                    <span class="info-label">学时:</span> ${course.hour}
                                </div>
                                <div class="info-item">
                                    <span class="info-label">考核方式:</span> ${course.testType}
                                </div>
                                <div class="info-item">
                                    <span class="info-label">授课教师:</span> ${course.teacherName}
                                </div>
                                <div class="info-item">
                                    <span class="info-label">选课时间:</span> 
                                    <fmt:formatDate value="${course.enrollDate}" pattern="yyyy-MM-dd HH:mm"/>
                                </div>
                            </div>
                            <div class="mt-3">
                                <form method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="drop">
                                    <input type="hidden" name="teachingClassId" value="${course.tcno}">
                                    <button type="submit" class="btn btn-drop btn-sm" 
                                            onclick="return confirm('确定要退选《${course.courseName}》吗？')">
                                        <i class="fas fa-times"></i> 退选
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 可选课程部分 -->
    <div class="row">
        <div class="col-12">
            <h4><i class="fas fa-plus-circle text-primary"></i> 可选课程 (${availableClasses.size()}门)</h4>
            
            <c:choose>
                <c:when test="${empty availableClasses}">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i> 当前没有可选的课程。
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="course" items="${availableClasses}">
                        <div class="course-card available-section">
                            <div class="course-header">
                                <div class="course-title">
                                    <i class="fas fa-book"></i> ${course.courseName}
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${course.currentStudents < course.maxStudents}">
                                            <span class="badge bg-success">可选</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">已满</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="course-info">
                                <div class="info-item">
                                    <span class="info-label">教学班:</span> ${course.tcname}
                                </div>
                                <div class="info-item">
                                    <span class="info-label">学年学期:</span> ${course.year}年第${course.term}学期
                                </div>
                                <div class="info-item">
                                    <span class="info-label">课程类型:</span> ${course.courseType}
                                </div>
                                <div class="info-item">
                                    <span class="info-label">学分:</span> ${course.credit}
                                </div>
                                <div class="info-item">
                                    <span class="info-label">学时:</span> ${course.hour}
                                </div>
                                <div class="info-item">
                                    <span class="info-label">考核方式:</span> ${course.testType}
                                </div>
                                <div class="info-item">
                                    <span class="info-label">授课教师:</span> ${course.teacherName}
                                </div>
                                <div class="info-item">
                                    <span class="info-label">班次:</span> ${course.batch}
                                </div>
                                <div class="info-item">
                                    <span class="info-label">选课人数:</span> 
                                    <span class="${course.currentStudents < course.maxStudents ? 'capacity-info' : 'capacity-full'}">
                                        ${course.currentStudents}/${course.maxStudents}
                                    </span>
                                </div>
                                <c:if test="${not empty course.classroom}">
                                    <div class="info-item">
                                        <span class="info-label">上课地点:</span> ${course.classroom}
                                    </div>
                                </c:if>
                                <c:if test="${not empty course.startTime}">
                                    <div class="info-item">
                                        <span class="info-label">上课时间:</span> 
                                        星期${course.weekday} ${course.startTime} - ${course.endTime}
                                    </div>
                                </c:if>
                            </div>
                            <div class="mt-3">
                                <c:choose>
                                    <c:when test="${course.currentStudents < course.maxStudents}">
                                        <form method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="enroll">
                                            <input type="hidden" name="teachingClassId" value="${course.tcno}">
                                            <button type="submit" class="btn btn-enroll btn-sm"
                                                    onclick="return confirm('确定要选择《${course.courseName}》吗？')">
                                                <i class="fas fa-plus"></i> 选课
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn btn-secondary btn-sm" disabled>
                                            <i class="fas fa-times"></i> 已满员
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 返回按钮 -->
    <div class="row mt-4">
        <div class="col-12 text-center">
            <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> 返回首页
            </a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 