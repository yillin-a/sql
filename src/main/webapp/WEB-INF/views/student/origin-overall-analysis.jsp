<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>生源地总体分析</title>
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/student-origin-analysis/">
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/student-origin-analysis/performance">
                                <i class="fas fa-chart-line"></i> 生源地表现
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/student-origin-analysis/top-origins">
                                <i class="fas fa-star"></i> 顶级生源地
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- 主内容区 -->
            <main class="col-md-10 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">生源地总体分析</h1>
                </div>

                <!-- 统计卡片 -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card text-white bg-primary">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">生源地总数</h5>
                                        <h3 class="card-text">${overallStats.totalOrigins}</h3>
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
                                        <h5 class="card-title">最高平均成绩</h5>
                                        <h3 class="card-text">
                                            <fmt:formatNumber value="${overallStats.maxAverageScore}" pattern="#.##"/>
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
                        <div class="card text-white bg-info">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">学生最多地区</h5>
                                        <h3 class="card-text">${overallStats.maxStudentsOrigin}</h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-users fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 详细统计 -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">生源地统计</h5>
                            </div>
                            <div class="card-body">
                                <ul class="list-unstyled">
                                    <li><strong>生源地总数：</strong> ${overallStats.totalOrigins}</li>
                                    <li><strong>有学生地区：</strong> ${overallStats.originsWithStudents}</li>
                                    <li><strong>平均每地区学生数：</strong> 
                                        <fmt:formatNumber value="${overallStats.averageStudentsPerOrigin}" pattern="#.##"/>
                                    </li>
                                    <li><strong>学生最多地区人数：</strong> ${overallStats.maxStudentsCount}</li>
                                    <li><strong>学生最少地区人数：</strong> ${overallStats.minStudentsCount}</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">成绩统计</h5>
                            </div>
                            <div class="card-body">
                                <ul class="list-unstyled">
                                    <li><strong>总体平均成绩：</strong> 
                                        <fmt:formatNumber value="${overallStats.averageScore}" pattern="#.##"/>
                                    </li>
                                    <li><strong>最高地区平均成绩：</strong> 
                                        <fmt:formatNumber value="${overallStats.maxAverageScore}" pattern="#.##"/>
                                    </li>
                                    <li><strong>最低地区平均成绩：</strong> 
                                        <fmt:formatNumber value="${overallStats.minAverageScore}" pattern="#.##"/>
                                    </li>
                                    <li><strong>成绩标准差：</strong> 
                                        <fmt:formatNumber value="${overallStats.scoreStandardDeviation}" pattern="#.##"/>
                                    </li>
                                    <li><strong>成绩差异系数：</strong> 
                                        <fmt:formatNumber value="${overallStats.scoreCoefficientOfVariation}" pattern="#.##"/>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 快速链接 -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">快速分析</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3">
                                        <a href="${pageContext.request.contextPath}/student-origin-analysis/distribution" 
                                           class="btn btn-outline-primary w-100 mb-2">
                                            <i class="fas fa-chart-pie"></i><br>
                                            生源地分布
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="${pageContext.request.contextPath}/student-origin-analysis/ranking" 
                                           class="btn btn-outline-success w-100 mb-2">
                                            <i class="fas fa-trophy"></i><br>
                                            生源地排名
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="${pageContext.request.contextPath}/student-origin-analysis/performance" 
                                           class="btn btn-outline-warning w-100 mb-2">
                                            <i class="fas fa-chart-line"></i><br>
                                            生源地表现
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="${pageContext.request.contextPath}/student-origin-analysis/top-origins" 
                                           class="btn btn-outline-info w-100 mb-2">
                                            <i class="fas fa-star"></i><br>
                                            顶级生源地
                                        </a>
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
</body>
</html> 