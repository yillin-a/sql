<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>顶级生源地</title>
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/student-origin-analysis/performance">
                                <i class="fas fa-chart-line"></i> 生源地表现
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/student-origin-analysis/top-origins">
                                <i class="fas fa-star"></i> 顶级生源地
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- 主内容区 -->
            <main class="col-md-10 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">顶级生源地</h1>
                </div>

                <!-- 顶级生源地概览 -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card text-white bg-warning">
                            <div class="card-body text-center">
                                <i class="fas fa-trophy fa-3x mb-3"></i>
                                <h4>冠军生源地</h4>
                                <h2>${topOrigins.champion.origin}</h2>
                                <p class="mb-0">平均成绩: <fmt:formatNumber value="${topOrigins.champion.averageScore}" pattern="#.##"/></p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-white bg-secondary">
                            <div class="card-body text-center">
                                <i class="fas fa-medal fa-3x mb-3"></i>
                                <h4>亚军生源地</h4>
                                <h2>${topOrigins.runnerUp.origin}</h2>
                                <p class="mb-0">平均成绩: <fmt:formatNumber value="${topOrigins.runnerUp.averageScore}" pattern="#.##"/></p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-white bg-warning">
                            <div class="card-body text-center">
                                <i class="fas fa-medal fa-3x mb-3"></i>
                                <h4>季军生源地</h4>
                                <h2>${topOrigins.thirdPlace.origin}</h2>
                                <p class="mb-0">平均成绩: <fmt:formatNumber value="${topOrigins.thirdPlace.averageScore}" pattern="#.##"/></p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 顶级生源地详细列表 -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">顶级生源地排行榜</h5>
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
                                                <th>综合评分</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${topOriginsList}" var="origin" varStatus="status">
                                                <tr>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${status.index == 0}">
                                                                <span class="badge bg-warning text-dark">
                                                                    <i class="fas fa-crown"></i> 1
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
                                                            <c:when test="${status.index < 10}">
                                                                <span class="badge bg-primary">${status.index + 1}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-light text-dark">${status.index + 1}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <strong>${origin.origin}</strong>
                                                    </td>
                                                    <td>${origin.studentCount}</td>
                                                    <td>
                                                        <span class="fw-bold text-success">
                                                            <fmt:formatNumber value="${origin.averageScore}" pattern="#.##"/>
                                                        </span>
                                                    </td>
                                                    <td>${origin.maxScore}</td>
                                                    <td>${origin.minScore}</td>
                                                    <td>
                                                        <span class="text-success">
                                                            <fmt:formatNumber value="${origin.passRate}" pattern="#.##"/>%
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="text-primary">
                                                            <fmt:formatNumber value="${origin.excellentRate}" pattern="#.##"/>%
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="progress" style="height: 20px;">
                                                            <div class="progress-bar bg-success" role="progressbar" 
                                                                 style="width: ${origin.compositeScore}%;" 
                                                                 aria-valuenow="${origin.compositeScore}" 
                                                                 aria-valuemin="0" 
                                                                 aria-valuemax="100">
                                                                <fmt:formatNumber value="${origin.compositeScore}" pattern="#.##"/>
                                                            </div>
                                                        </div>
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

                <!-- 顶级生源地分析图表 -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">前10名生源地成绩对比</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="topOriginsChart" width="400" height="300"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">顶级生源地综合评分</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="compositeScoreChart" width="400" height="300"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 顶级生源地特点分析 -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">顶级生源地特点分析</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6>共同特点：</h6>
                                        <ul>
                                            <li>平均成绩普遍在85分以上</li>
                                            <li>及格率接近100%</li>
                                            <li>优秀率超过30%</li>
                                            <li>学生人数适中，便于管理</li>
                                            <li>成绩分布相对集中</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6">
                                        <h6>成功因素：</h6>
                                        <ul>
                                            <li>优质的教育资源</li>
                                            <li>良好的学习氛围</li>
                                            <li>有效的教学方法</li>
                                            <li>学生自主学习能力强</li>
                                            <li>家长重视教育</li>
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
        // 前10名生源地成绩对比图
        const topCtx = document.getElementById('topOriginsChart').getContext('2d');
        new Chart(topCtx, {
            type: 'bar',
            data: {
                labels: [
                    <c:forEach items="${topOriginsList}" var="origin" varStatus="status">
                        <c:if test="${status.index < 10}">
                            '${origin.origin}'<c:if test="${status.index < 9}">,</c:if>
                        </c:if>
                    </c:forEach>
                ],
                datasets: [{
                    label: '平均成绩',
                    data: [
                        <c:forEach items="${topOriginsList}" var="origin" varStatus="status">
                            <c:if test="${status.index < 10}">
                                ${origin.averageScore}<c:if test="${status.index < 9}">,</c:if>
                            </c:if>
                        </c:forEach>
                    ],
                    backgroundColor: [
                        '#FFD700', '#C0C0C0', '#CD7F32', '#4BC0C0', '#36A2EB',
                        '#FF6384', '#9966FF', '#FF9F40', '#FF6384', '#C9CBCF'
                    ],
                    borderColor: [
                        '#FFA500', '#A9A9A9', '#B8860B', '#20B2AA', '#1E90FF',
                        '#DC143C', '#8A2BE2', '#FF8C00', '#DC143C', '#A9A9A9'
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
                }
            }
        });

        // 综合评分雷达图
        const compositeCtx = document.getElementById('compositeScoreChart').getContext('2d');
        new Chart(compositeCtx, {
            type: 'radar',
            data: {
                labels: ['平均成绩', '及格率', '优秀率', '学生数量', '成绩稳定性'],
                datasets: [{
                    label: '冠军生源地',
                    data: [
                        ${topOrigins.champion.averageScore},
                        ${topOrigins.champion.passRate},
                        ${topOrigins.champion.excellentRate},
                        ${topOrigins.champion.studentCount / 10},
                        100 - ${topOrigins.champion.standardDeviation}
                    ],
                    backgroundColor: 'rgba(255, 215, 0, 0.2)',
                    borderColor: 'rgba(255, 215, 0, 1)',
                    borderWidth: 2
                }, {
                    label: '亚军生源地',
                    data: [
                        ${topOrigins.runnerUp.averageScore},
                        ${topOrigins.runnerUp.passRate},
                        ${topOrigins.runnerUp.excellentRate},
                        ${topOrigins.runnerUp.studentCount / 10},
                        100 - ${topOrigins.runnerUp.standardDeviation}
                    ],
                    backgroundColor: 'rgba(192, 192, 192, 0.2)',
                    borderColor: 'rgba(192, 192, 192, 1)',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                scales: {
                    r: {
                        beginAtZero: true,
                        max: 100
                    }
                }
            }
        });
    </script>
</body>
</html> 