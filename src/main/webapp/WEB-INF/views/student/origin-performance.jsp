<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>生源地表现</title>
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/student-origin-analysis/distribution">
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/student-origin-analysis/performance">
                                <i class="fas fa-chart-line"></i> 生源地表现
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- 主内容区 -->
            <main class="col-md-10 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">生源地表现</h1>
                </div>

                <!-- 表现概览 -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card text-white bg-primary">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">最高表现</h5>
                                        <h3 class="card-text">
                                            <fmt:formatNumber value="${performance[0].averageScore}" pattern="#.##"/>
                                        </h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-trophy fa-2x"></i>
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
                                        <h5 class="card-title">平均表现</h5>
                                        <h3 class="card-text">
                                            <fmt:formatNumber value="${performance[0].overallAverage}" pattern="#.##"/>
                                        </h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-chart-line fa-2x"></i>
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
                                        <h5 class="card-title">最低表现</h5>
                                        <h3 class="card-text">
                                            <fmt:formatNumber value="${performance[performance.size()-1].averageScore}" pattern="#.##"/>
                                        </h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-chart-area fa-2x"></i>
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
                                        <h5 class="card-title">表现差距</h5>
                                        <h3 class="card-text">
                                            <fmt:formatNumber value="${performance[0].averageScore - performance[performance.size()-1].averageScore}" pattern="#.##"/>
                                        </h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-chart-bar fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 表现趋势图 -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">生源地表现趋势</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="performanceTrendChart" width="800" height="400"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 表现详情表格 -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">生源地表现详情</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th>排名</th>
                                                <th>生源地</th>
                                                <th>学生人数</th>
                                                <th>平均成绩</th>
                                                <th>与总体平均差距</th>
                                                <th>及格率</th>
                                                <th>优秀率</th>
                                                <th>表现等级</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${performance}" var="item" varStatus="status">
                                                <tr>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${status.index == 0}">
                                                                <span class="badge bg-warning text-dark">
                                                                    <i class="fas fa-trophy"></i> 1
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${status.index == 1}">
                                                                <span class="badge bg-secondary">
                                                                    <i class="fas fa-medal"></i> 2
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${status.index == 2}">
                                                                <span class="badge bg-warning">
                                                                    <i class="fas fa-medal"></i> 3
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-light text-dark">${status.index + 1}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <strong>${item.origin}</strong>
                                                    </td>
                                                    <td>${item.studentCount}</td>
                                                    <td>
                                                        <span class="fw-bold">
                                                            <fmt:formatNumber value="${item.averageScore}" pattern="#.##"/>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:set var="difference" value="${item.averageScore - item.overallAverage}"/>
                                                        <c:choose>
                                                            <c:when test="${difference > 0}">
                                                                <span class="text-success">
                                                                    +<fmt:formatNumber value="${difference}" pattern="#.##"/>
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-danger">
                                                                    <fmt:formatNumber value="${difference}" pattern="#.##"/>
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
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
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${item.averageScore >= 85}">
                                                                <span class="badge bg-success">优秀</span>
                                                            </c:when>
                                                            <c:when test="${item.averageScore >= 75}">
                                                                <span class="badge bg-primary">良好</span>
                                                            </c:when>
                                                            <c:when test="${item.averageScore >= 65}">
                                                                <span class="badge bg-warning">中等</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-danger">需改进</span>
                                                            </c:otherwise>
                                                        </c:choose>
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
        // 生源地表现趋势图
        const trendCtx = document.getElementById('performanceTrendChart').getContext('2d');
        new Chart(trendCtx, {
            type: 'line',
            data: {
                labels: [
                    <c:forEach items="${performance}" var="item" varStatus="status">
                        '${item.origin}'<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                datasets: [{
                    label: '平均成绩',
                    data: [
                        <c:forEach items="${performance}" var="item" varStatus="status">
                            ${item.averageScore}<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.1,
                    fill: true
                }, {
                    label: '总体平均',
                    data: [
                        <c:forEach items="${performance}" var="item" varStatus="status">
                            ${item.overallAverage}<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    borderColor: 'rgb(255, 99, 132)',
                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
                    borderDash: [5, 5],
                    tension: 0.1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100
                    }
                },
                plugins: {
                    legend: {
                        position: 'top'
                    }
                }
            }
        });
    </script>
</body>
</html> 