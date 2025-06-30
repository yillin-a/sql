<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>触发器状态 - 教务管理系统</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .status-card {
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .status-card:hover {
            transform: translateY(-5px);
        }
        .trigger-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        .status-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .status-warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
        }
        .status-danger {
            background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);
            color: white;
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
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/users">
                                <i class="fas fa-users"></i> 用户管理
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white active" href="${pageContext.request.contextPath}/admin/users/trigger-status">
                                <i class="fas fa-cogs"></i> 触发器状态
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- 主内容区 -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="fas fa-cogs"></i> 触发器状态检查
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary">
                            <i class="fas fa-arrow-left"></i> 返回用户管理
                        </a>
                    </div>
                </div>

                <!-- 状态卡片 -->
                <div class="row">
                    <div class="col-md-6 mb-4">
                        <div class="card status-card ${triggerStatus ? 'status-success' : 'status-danger'} h-100">
                            <div class="card-body text-center">
                                <div class="trigger-icon">
                                    <i class="fas ${triggerStatus ? 'fa-check-circle' : 'fa-exclamation-triangle'}"></i>
                                </div>
                                <h4 class="card-title">触发器状态</h4>
                                <p class="card-text">
                                    <c:choose>
                                        <c:when test="${triggerStatus}">
                                            触发器工作正常
                                        </c:when>
                                        <c:otherwise>
                                            触发器可能存在问题
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 mb-4">
                        <div class="card status-card status-warning h-100">
                            <div class="card-body text-center">
                                <div class="trigger-icon">
                                    <i class="fas fa-info-circle"></i>
                                </div>
                                <h4 class="card-title">功能说明</h4>
                                <p class="card-text">
                                    自动用户创建功能已启用
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 消息提示 -->
                <c:if test="${not empty message}">
                    <div class="alert alert-info alert-dismissible fade show" role="alert">
                        <i class="fas fa-info-circle"></i> ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- 触发器详细信息 -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-list"></i> 触发器详细信息
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6><i class="fas fa-user-graduate text-primary"></i> 学生触发器</h6>
                                        <ul class="list-unstyled">
                                            <li><strong>触发器名称：</strong>tr_Student_Insert</li>
                                            <li><strong>触发时机：</strong>学生表插入后</li>
                                            <li><strong>默认密码：</strong>Student@123</li>
                                            <li><strong>用户名：</strong>学号</li>
                                            <li><strong>用户类型：</strong>student</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6">
                                        <h6><i class="fas fa-chalkboard-teacher text-success"></i> 教师触发器</h6>
                                        <ul class="list-unstyled">
                                            <li><strong>触发器名称：</strong>tr_Teacher_Insert</li>
                                            <li><strong>触发时机：</strong>教师表插入后</li>
                                            <li><strong>默认密码：</strong>Teacher@123</li>
                                            <li><strong>用户名：</strong>工号</li>
                                            <li><strong>用户类型：</strong>teacher</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 使用说明 -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-question-circle"></i> 使用说明
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6>添加学生流程：</h6>
                                        <ol>
                                            <li>在"学生管理"页面添加新学生</li>
                                            <li>系统自动触发学生触发器</li>
                                            <li>自动创建用户账户（用户名=学号）</li>
                                            <li>默认密码设置为 Student@123</li>
                                            <li>学生可使用学号和默认密码登录</li>
                                        </ol>
                                    </div>
                                    <div class="col-md-6">
                                        <h6>添加教师流程：</h6>
                                        <ol>
                                            <li>在"教师管理"页面添加新教师</li>
                                            <li>系统自动触发教师触发器</li>
                                            <li>自动创建用户账户（用户名=工号）</li>
                                            <li>默认密码设置为 Teacher@123</li>
                                            <li>教师可使用工号和默认密码登录</li>
                                        </ol>
                                    </div>
                                </div>
                                
                                <div class="alert alert-warning mt-3">
                                    <h6><i class="fas fa-exclamation-triangle"></i> 重要提醒：</h6>
                                    <ul class="mb-0">
                                        <li>请通知新用户及时修改默认密码</li>
                                        <li>可在"用户管理"页面重置用户密码</li>
                                        <li>触发器功能确保用户账户的自动创建</li>
                                        <li>如遇问题，请检查数据库触发器配置</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 