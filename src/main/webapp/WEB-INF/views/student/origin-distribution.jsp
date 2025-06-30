<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>生源地分布</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- 侧边栏 -->
            <nav class="col-md-2 d-none d-md-block bg-light sidebar">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/student-origin-analysis/">
                                <i class="fas fa-globe"></i> 生源地总体分析
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/student-origin-analysis/distribution">
                                <i class="fas fa-chart-pie"></i> 生源地分布
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/student-origin-analysis/ranking">
                                <i class="fas fa-trophy"></i> 生源地排名
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/student-origin-analysis/analysis">
                                <i class="fas fa-chart-bar"></i> 生源地分析
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/student-origin-analysis/performance">
                                <i class="fas fa-chart-line"></i> 生源地表现
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- 主内容区 -->
            <main class="col-md-10 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">生源地分布</h1>
                </div>

                <!-- 分布概览 -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card text-white bg-primary">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">生源地总数</h5>
                                        <h3 class="card-text">${distribution.totalOrigins}</h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-map-marker-alt fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-white bg-success">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">总学生数</h5>
                                        <h3 class="card-text">${distribution.totalStudents}</h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-users fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-white bg-warning">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">平均每地区</h5>
                                        <h3 class="card-text">
                                            <fmt:formatNumber value="${distribution.averageStudentsPerOrigin}" pattern="#.##"/>
                                        </h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-chart-pie fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-white bg-info">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">分布密度</h5>
                                        <h3 class="card-text">
                                            <fmt:formatNumber value="${distribution.distributionDensity}" pattern="#.##"/>
                                        </h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-chart-area fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 分布图表 -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">生源地分布饼图</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="distributionPieChart" width="400" height="300"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">学生数量分布柱状图</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="distributionBarChart" width="400" height="300"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 详细分布表格 -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">生源地详细分布</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th>排名</th>
                                                <th>生源地</th>
                                                <th>学生人数</th>
                                                <th>占比</th>
                                                <th>平均成绩</th>
                                                <th>及格率</th>
                                                <th>优秀率</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${distributionList}" var="item" varStatus="status">
                                                <tr>
                                                    <td>
                                                        <span class="badge bg-light text-dark">${status.index + 1}</span>
                                                    </td>
                                                    <td>
                                                        <strong>${item.origin}</strong>
                                                    </td>
                                                    <td>${item.studentCount}</td>
                                                    <td>
                                                        <div class="progress" style="height: 20px;">
                                                            <div class="progress-bar" role="progressbar" 
                                                                 style="width: ${item.percentage}%;" 
                                                                 aria-valuenow="${item.percentage}" 
                                                                 aria-valuemin="0" 
                                                                 aria-valuemax="100">
                                                                <fmt:formatNumber value="${item.percentage}" pattern="#.##"/>%
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${item.averageScore}" pattern="#.##"/>
                                                    </td>
                                                    <td>
                                                        <span class="text-success">
                                                            <fmt:formatNumber value="${item.passRate}" pattern="#.##"/>%
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="text-primary">
                                                            <fmt:formatNumber value="${item.excellentRate}" pattern="#.##"/>%
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
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
        // 生源地分布饼图
        const pieCtx = document.getElementById('distributionPieChart').getContext('2d');
        new Chart(pieCtx, {
            type: 'pie',
            data: {
                labels: [
                    <c:forEach items="${distributionList}" var="item" varStatus="status">
                        '${item.origin}'<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                datasets: [{
                    data: [
                        <c:forEach items="${distributionList}" var="item" varStatus="status">
                            ${item.studentCount}<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    backgroundColor: [
                        '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF',
                        '#FF9F40', '#FF6384', '#C9CBCF', '#4BC0C0', '#FF6384'
                    ]
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // 学生数量分布柱状图
        const barCtx = document.getElementById('distributionBarChart').getContext('2d');
        new Chart(barCtx, {
            type: 'bar',
            data: {
                labels: [
                    <c:forEach items="${distributionList}" var="item" varStatus="status">
                        '${item.origin}'<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                datasets: [{
                    label: '学生人数',
                    data: [
                        <c:forEach items="${distributionList}" var="item" varStatus="status">
                            ${item.studentCount}<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html> 