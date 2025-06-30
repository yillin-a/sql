<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户统计 - 教务管理系统</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .stats-card {
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .stats-card:hover {
            transform: translateY(-5px);
        }
        .stats-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        .stats-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        .stats-label {
            font-size: 1.1rem;
            opacity: 0.8;
        }
        .bg-gradient-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .bg-gradient-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        .bg-gradient-info {
            background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%);
        }
        .bg-gradient-warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
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
                            <a class="nav-link text-white active" href="${pageContext.request.contextPath}/admin/users/stats">
                                <i class="fas fa-chart-bar"></i> 用户统计
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- 主内容区 -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="fas fa-chart-bar"></i> 用户统计
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary">
                            <i class="fas fa-arrow-left"></i> 返回用户管理
                        </a>
                    </div>
                </div>

                <!-- 统计信息 -->
                <div class="row">
                    <div class="col-md-6 col-lg-3 mb-4">
                        <div class="card stats-card bg-gradient-primary text-white">
                            <div class="card-body text-center">
                                <div class="stats-icon">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="stats-number" id="totalUsers">-</div>
                                <div class="stats-label">总用户数</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-6 col-lg-3 mb-4">
                        <div class="card stats-card bg-gradient-success text-white">
                            <div class="card-body text-center">
                                <div class="stats-icon">
                                    <i class="fas fa-user-graduate"></i>
                                </div>
                                <div class="stats-number" id="studentUsers">-</div>
                                <div class="stats-label">学生用户</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-6 col-lg-3 mb-4">
                        <div class="card stats-card bg-gradient-info text-white">
                            <div class="card-body text-center">
                                <div class="stats-icon">
                                    <i class="fas fa-chalkboard-teacher"></i>
                                </div>
                                <div class="stats-number" id="teacherUsers">-</div>
                                <div class="stats-label">教师用户</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-6 col-lg-3 mb-4">
                        <div class="card stats-card bg-gradient-warning text-white">
                            <div class="card-body text-center">
                                <div class="stats-icon">
                                    <i class="fas fa-user-shield"></i>
                                </div>
                                <div class="stats-number" id="adminUsers">-</div>
                                <div class="stats-label">管理员</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 详细统计信息 -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-info-circle"></i> 详细统计信息
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6>用户分布</h6>
                                        <div id="userDistribution">
                                            <p class="text-muted">正在加载统计数据...</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <h6>触发器状态</h6>
                                        <div id="triggerStatus">
                                            <p class="text-muted">正在检查触发器状态...</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 统计说明 -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-question-circle"></i> 统计说明
                                </h5>
                            </div>
                            <div class="card-body">
                                <ul>
                                    <li><strong>总用户数：</strong>系统中所有用户账户的总数</li>
                                    <li><strong>学生用户：</strong>通过触发器自动创建的学生登录账户</li>
                                    <li><strong>教师用户：</strong>通过触发器自动创建的教师登录账户</li>
                                    <li><strong>管理员：</strong>系统管理员账户</li>
                                    <li><strong>触发器状态：</strong>自动用户创建功能的运行状态</li>
                                </ul>
                                
                                <div class="alert alert-info mt-3">
                                    <h6><i class="fas fa-lightbulb"></i> 提示：</h6>
                                    <p class="mb-0">
                                        统计数据反映了触发器功能的运行效果。当添加新学生或教师时，
                                        系统会自动创建对应的用户账户，这些账户会在此统计中显示。
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 解析统计信息
        function parseStats(statsText) {
            const stats = {};
            const regex = /总用户数: (\d+), 学生: (\d+), 教师: (\d+), 管理员: (\d+)/;
            const match = statsText.match(regex);
            
            if (match) {
                stats.total = parseInt(match[1]);
                stats.students = parseInt(match[2]);
                stats.teachers = parseInt(match[3]);
                stats.admins = parseInt(match[4]);
            }
            
            return stats;
        }
        
        // 更新统计显示
        function updateStats() {
            const statsText = '${stats}';
            const stats = parseStats(statsText);
            
            if (stats.total !== undefined) {
                document.getElementById('totalUsers').textContent = stats.total;
                document.getElementById('studentUsers').textContent = stats.students;
                document.getElementById('teacherUsers').textContent = stats.teachers;
                document.getElementById('adminUsers').textContent = stats.admins;
                
                // 更新用户分布
                const distribution = document.getElementById('userDistribution');
                distribution.innerHTML = `
                    <ul class="list-unstyled">
                        <li><i class="fas fa-user-graduate text-primary"></i> 学生用户：${stats.students} 人 (${((stats.students/stats.total)*100).toFixed(1)}%)</li>
                        <li><i class="fas fa-chalkboard-teacher text-success"></i> 教师用户：${stats.teachers} 人 (${((stats.teachers/stats.total)*100).toFixed(1)}%)</li>
                        <li><i class="fas fa-user-shield text-danger"></i> 管理员：${stats.admins} 人 (${((stats.admins/stats.total)*100).toFixed(1)}%)</li>
                    </ul>
                `;
                
                // 更新触发器状态
                const triggerStatus = document.getElementById('triggerStatus');
                triggerStatus.innerHTML = `
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> 触发器工作正常
                        <br><small>自动用户创建功能已启用</small>
                    </div>
                `;
            } else {
                document.getElementById('userDistribution').innerHTML = '<p class="text-danger">统计数据解析失败</p>';
                document.getElementById('triggerStatus').innerHTML = '<p class="text-danger">触发器状态检查失败</p>';
            }
        }
        
        // 页面加载完成后更新统计
        document.addEventListener('DOMContentLoaded', updateStats);
    </script>
</body>
</html> 