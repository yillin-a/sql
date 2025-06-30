<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>生源地排名</title>
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/student-origin-analysis/ranking">
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
                    <h1 class="h2">生源地排名</h1>
                </div>

                <!-- 排名表格 -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">生源地成绩排名</h5>
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
                                                <th>最高成绩</th>
                                                <th>最低成绩</th>
                                                <th>及格率</th>
                                                <th>优秀率</th>
                                                <th>标准差</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${rankings}" var="ranking" varStatus="status">
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
                                                        <strong>${ranking.origin}</strong>
                                                    </td>
                                                    <td>${ranking.studentCount}</td>
                                                    <td>
                                                        <span class="fw-bold">
                                                            <fmt:formatNumber value="${ranking.averageScore}" pattern="#.##"/>
                                                        </span>
                                                    </td>
                                                    <td>${ranking.maxScore}</td>
                                                    <td>${ranking.minScore}</td>
                                                    <td>
                                                        <span class="text-success">
                                                            <fmt:formatNumber value="${ranking.passRate}" pattern="#.##"/>%
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="text-primary">
                                                            <fmt:formatNumber value="${ranking.excellentRate}" pattern="#.##"/>%
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${ranking.standardDeviation}" pattern="#.##"/>
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

                <!-- 排名统计 -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">排名统计</h5>
                            </div>
                            <div class="card-body">
                                <ul class="list-unstyled">
                                    <li><strong>参与排名地区：</strong> ${rankings.size()}</li>
                                    <li><strong>最高平均成绩：</strong> 
                                        <fmt:formatNumber value="${rankings[0].averageScore}" pattern="#.##"/>
                                    </li>
                                    <li><strong>最低平均成绩：</strong> 
                                        <fmt:formatNumber value="${rankings[rankings.size()-1].averageScore}" pattern="#.##"/>
                                    </li>
                                    <li><strong>成绩差距：</strong> 
                                        <fmt:formatNumber value="${rankings[0].averageScore - rankings[rankings.size()-1].averageScore}" pattern="#.##"/>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">成绩分布</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="rankingChart" width="400" height="200"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 排名图表
        const ctx = document.getElementById('rankingChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: [
                    <c:forEach items="${rankings}" var="ranking" varStatus="status">
                        '${ranking.origin}'<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                datasets: [{
                    label: '平均成绩',
                    data: [
                        <c:forEach items="${rankings}" var="ranking" varStatus="status">
                            ${ranking.averageScore}<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    backgroundColor: [
                        <c:forEach items="${rankings}" var="ranking" varStatus="status">
                            '${status.index == 0 ? "#ffc107" : status.index == 1 ? "#6c757d" : status.index == 2 ? "#fd7e14" : "#17a2b8"}'<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    borderColor: [
                        <c:forEach items="${rankings}" var="ranking" varStatus="status">
                            '${status.index == 0 ? "#e0a800" : status.index == 1 ? "#545b62" : status.index == 2 ? "#e8590c" : "#138496"}'<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    borderWidth: 1
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
                        display: false
                    }
                }
            }
        });
    </script>
</body>
</html> 