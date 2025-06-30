<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>生源地分析</title>
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/student-origin-analysis/analysis">
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
                    <h1 class="h2">生源地分析</h1>
                </div>

                <!-- 分析概览 -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card text-white bg-primary">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">生源地数量</h5>
                                        <h3 class="card-text">${analysis.totalOrigins}</h3>
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
                                        <h5 class="card-title">平均成绩</h5>
                                        <h3 class="card-text">
                                            <fmt:formatNumber value="${analysis.averageScore}" pattern="#.##"/>
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
                                        <h5 class="card-title">成绩差异</h5>
                                        <h3 class="card-text">
                                            <fmt:formatNumber value="${analysis.scoreVariance}" pattern="#.##"/>
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
                                        <h5 class="card-title">学生分布</h5>
                                        <h3 class="card-text">
                                            <fmt:formatNumber value="${analysis.studentDistribution}" pattern="#.##"/>
                                        </h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-users fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 详细分析 -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">成绩分析</h5>
                            </div>
                            <div class="card-body">
                                <ul class="list-unstyled">
                                    <li><strong>总体平均成绩：</strong> 
                                        <fmt:formatNumber value="${analysis.averageScore}" pattern="#.##"/>
                                    </li>
                                    <li><strong>成绩标准差：</strong> 
                                        <fmt:formatNumber value="${analysis.standardDeviation}" pattern="#.##"/>
                                    </li>
                                    <li><strong>成绩变异系数：</strong> 
                                        <fmt:formatNumber value="${analysis.coefficientOfVariation}" pattern="#.##"/>
                                    </li>
                                    <li><strong>最高地区成绩：</strong> 
                                        <fmt:formatNumber value="${analysis.maxScore}" pattern="#.##"/>
                                    </li>
                                    <li><strong>最低地区成绩：</strong> 
                                        <fmt:formatNumber value="${analysis.minScore}" pattern="#.##"/>
                                    </li>
                                    <li><strong>成绩差距：</strong> 
                                        <fmt:formatNumber value="${analysis.scoreRange}" pattern="#.##"/>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">分布分析</h5>
                            </div>
                            <div class="card-body">
                                <ul class="list-unstyled">
                                    <li><strong>生源地总数：</strong> ${analysis.totalOrigins}</li>
                                    <li><strong>有学生地区：</strong> ${analysis.originsWithStudents}</li>
                                    <li><strong>平均每地区学生：</strong> 
                                        <fmt:formatNumber value="${analysis.averageStudentsPerOrigin}" pattern="#.##"/>
                                    </li>
                                    <li><strong>学生最多地区：</strong> ${analysis.maxStudentsOrigin}</li>
                                    <li><strong>学生最少地区：</strong> ${analysis.minStudentsOrigin}</li>
                                    <li><strong>学生分布标准差：</strong> 
                                        <fmt:formatNumber value="${analysis.studentDistributionStd}" pattern="#.##"/>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 分析图表 -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">成绩分布图</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="scoreDistributionChart" width="400" height="200"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">学生分布图</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="studentDistributionChart" width="400" height="200"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 成绩分布图表
        const scoreCtx = document.getElementById('scoreDistributionChart').getContext('2d');
        new Chart(scoreCtx, {
            type: 'line',
            data: {
                labels: ['0-10', '10-20', '20-30', '30-40', '40-50', '50-60', '60-70', '70-80', '80-90', '90-100'],
                datasets: [{
                    label: '成绩分布',
                    data: [${analysis.scoreDistribution}],
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.1
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

        // 学生分布图表
        const studentCtx = document.getElementById('studentDistributionChart').getContext('2d');
        new Chart(studentCtx, {
            type: 'doughnut',
            data: {
                labels: ['1-5人', '6-10人', '11-15人', '16-20人', '20人以上'],
                datasets: [{
                    data: [${analysis.studentDistributionData}],
                    backgroundColor: [
                        '#FF6384',
                        '#36A2EB',
                        '#FFCE56',
                        '#4BC0C0',
                        '#9966FF'
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
    </script>
</body>
</html> 