<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户管理 - 教务管理系统</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .user-card {
            transition: transform 0.2s;
        }
        .user-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .status-badge {
            font-size: 0.8em;
        }
        .trigger-info {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- 侧边栏 -->
            <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/dashboard">
                                <i class="fas fa-tachometer-alt"></i> 管理面板
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white active" href="${pageContext.request.contextPath}/admin/users">
                                <i class="fas fa-users"></i> 用户管理
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/student/list">
                                <i class="fas fa-user-graduate"></i> 学生管理
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/list">
                                <i class="fas fa-chalkboard-teacher"></i> 教师管理
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/users/trigger-status">
                                <i class="fas fa-cogs"></i> 触发器状态
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/password/change">
                                <i class="fas fa-key"></i> 修改密码
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- 主内容区 -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="fas fa-users"></i> 用户管理
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/users/stats" class="btn btn-info">
                            <i class="fas fa-chart-bar"></i> 用户统计
                        </a>
                    </div>
                </div>

                <!-- 触发器信息提示 -->
                <div class="trigger-info">
                    <h5><i class="fas fa-info-circle"></i> 自动用户创建功能</h5>
                    <p class="mb-0">
                        系统已启用触发器功能，当添加新学生或教师时，会自动创建对应的登录账户。
                        学生默认密码：<strong>Student@123</strong>，教师默认密码：<strong>Teacher@123</strong>
                    </p>
                </div>

                <!-- 消息提示 -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- 筛选器 -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <form class="d-flex" method="get">
                            <select name="type" class="form-select me-2">
                                <option value="">所有用户类型</option>
                                <option value="student" ${userType == 'student' ? 'selected' : ''}>学生</option>
                                <option value="teacher" ${userType == 'teacher' ? 'selected' : ''}>教师</option>
                                <option value="admin" ${userType == 'admin' ? 'selected' : ''}>管理员</option>
                            </select>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-filter"></i> 筛选
                            </button>
                        </form>
                    </div>
                </div>

                <!-- 用户列表 -->
                <div class="row">
                    <c:forEach items="${users}" var="user">
                        <div class="col-md-6 col-lg-4 mb-3">
                            <div class="card user-card h-100">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h6 class="card-title mb-0">
                                            <c:choose>
                                                <c:when test="${user.userType == 'student'}">
                                                    <i class="fas fa-user-graduate text-primary"></i>
                                                </c:when>
                                                <c:when test="${user.userType == 'teacher'}">
                                                    <i class="fas fa-chalkboard-teacher text-success"></i>
                                                </c:when>
                                                <c:when test="${user.userType == 'admin'}">
                                                    <i class="fas fa-user-shield text-danger"></i>
                                                </c:when>
                                            </c:choose>
                                            ${user.username}
                                        </h6>
                                        <span class="badge bg-${user.userType == 'student' ? 'primary' : user.userType == 'teacher' ? 'success' : 'danger'} status-badge">
                                            ${user.userType}
                                        </span>
                                    </div>
                                    <p class="card-text small text-muted mb-2">
                                        <i class="fas fa-envelope"></i> ${user.email}<br>
                                        <i class="fas fa-phone"></i> ${empty user.phone ? '未设置' : user.phone}
                                    </p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted">
                                            <i class="fas fa-clock"></i> 创建时间: ${user.createdAt}
                                        </small>
                                        <div class="btn-group btn-group-sm">
                                            <c:if test="${user.userType != 'admin'}">
                                                <form method="post" action="${pageContext.request.contextPath}/admin/users/reset-password" style="display: inline;">
                                                    <input type="hidden" name="username" value="${user.username}">
                                                    <input type="hidden" name="userType" value="${user.userType}">
                                                    <button type="submit" class="btn btn-outline-warning btn-sm" 
                                                            onclick="return confirm('确定要重置该用户的密码吗？')">
                                                        <i class="fas fa-key"></i> 重置密码
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- 空状态 -->
                <c:if test="${empty users}">
                    <div class="text-center py-5">
                        <i class="fas fa-users fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">暂无用户数据</h5>
                        <p class="text-muted">请先添加学生或教师，系统会自动创建对应的用户账户。</p>
                    </div>
                </c:if>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 自动隐藏消息提示
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html> 