<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>学生成绩分析</title>
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/student-score-analysis/">
                                <i class="fas fa-chart-line"></i> 总体成绩分析
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/student-score-analysis/by-major">
                                <i class="fas fa-graduation-cap"></i> 专业成绩分析
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/student-score-analysis/distribution">
                                <i class="fas fa-chart-pie"></i> 成绩分布
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/student-score-analysis/major-ranking">
                                <i class="fas fa-trophy"></i> 专业排名
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/student-score-analysis/major-stats">
                                <i class="fas fa-chart-bar"></i> 专业统计
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- 主内容区 -->
            <main class="col-md-10 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">学生成绩分析</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-sm btn-outline-secondary">
                                <i class="fas fa-list"></i> 学生列表
                            </a>
                        </div>
                    </div>
                </div>

                <!-- 总体统计卡片 -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card text-white bg-primary">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">总学生数</h5>
                                        <h3 class="card-text">${overallStats.totalStudents}</h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-users fa-2x"></i>
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
                                            <fmt:formatNumber value="${overallStats.averageScore}" pattern="#.##"/>
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
                                        <h5 class="card-title">最高成绩</h5>
                                        <h3 class="card-text">${overallStats.maxScore}</h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-trophy fa-2x"></i>
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
                                        <h5 class="card-title">最低成绩</h5>
                                        <h3 class="card-text">${overallStats.minScore}</h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-chart-area fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 成绩分布图表 -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">成绩分布</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="scoreDistributionChart" width="400" height="200"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">成绩统计</h5>
                            </div>
                            <div class="card-body">
                                <table class="table table-sm">
                                    <tbody>
                                        <tr>
                                            <td>优秀 (90-100)</td>
                                            <td>${overallAnalysis.excellentCount} 人</td>
                                            <td>
                                                <fmt:formatNumber value="${overallAnalysis.excellentPercentage}" pattern="#.##"/>%
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>良好 (80-89)</td>
                                            <td>${overallAnalysis.goodCount} 人</td>
                                            <td>
                                                <fmt:formatNumber value="${overallAnalysis.goodPercentage}" pattern="#.##"/>%
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>中等 (70-79)</td>
                                            <td>${overallAnalysis.averageCount} 人</td>
                                            <td>
                                                <fmt:formatNumber value="${overallAnalysis.averagePercentage}" pattern="#.##"/>%
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>及格 (60-69)</td>
                                            <td>${overallAnalysis.passCount} 人</td>
                                            <td>
                                                <fmt:formatNumber value="${overallAnalysis.passPercentage}" pattern="#.##"/>%
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>不及格 (<60)</td>
                                            <td>${overallAnalysis.failCount} 人</td>
                                            <td>
                                                <fmt:formatNumber value="${overallAnalysis.failPercentage}" pattern="#.##"/>%
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 详细统计表格 -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">详细统计信息</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6>成绩统计</h6>
                                        <ul class="list-unstyled">
                                            <li><strong>标准差：</strong> <fmt:formatNumber value="${overallStats.standardDeviation}" pattern="#.##"/></li>
                                            <li><strong>中位数：</strong> <fmt:formatNumber value="${overallStats.medianScore}" pattern="#.##"/></li>
                                            <li><strong>及格率：</strong> <fmt:formatNumber value="${overallStats.passRate}" pattern="#.##"/>%</li>
                                            <li><strong>优秀率：</strong> <fmt:formatNumber value="${overallStats.excellentRate}" pattern="#.##"/>%</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6">
                                        <h6>其他统计</h6>
                                        <ul class="list-unstyled">
                                            <li><strong>有成绩学生数：</strong> ${overallStats.studentsWithScores}</li>
                                            <li><strong>无成绩学生数：</strong> ${overallStats.studentsWithoutScores}</li>
                                            <li><strong>成绩录入率：</strong> <fmt:formatNumber value="${overallStats.scoreEntryRate}" pattern="#.##"/>%</li>
                                        </ul>
                                    </div>
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
        // 成绩分布图表
        const ctx = document.getElementById('scoreDistributionChart').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['优秀 (90-100)', '良好 (80-89)', '中等 (70-79)', '及格 (60-69)', '不及格 (<60)'],
                datasets: [{
                    data: [
                        ${overallAnalysis.excellentCount},
                        ${overallAnalysis.goodCount},
                        ${overallAnalysis.averageCount},
                        ${overallAnalysis.passCount},
                        ${overallAnalysis.failCount}
                    ],
                    backgroundColor: [
                        '#28a745',
                        '#17a2b8',
                        '#ffc107',
                        '#fd7e14',
                        '#dc3545'
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