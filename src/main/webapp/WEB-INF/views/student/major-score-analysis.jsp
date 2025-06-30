<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>专业成绩分析</title>
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/student-score-analysis/">
                                <i class="fas fa-chart-line"></i> 总体成绩分析
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/student-score-analysis/by-major">
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
                    </ul>
                </div>
            </nav>

            <!-- 主内容区 -->
            <main class="col-md-10 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">专业成绩分析</h1>
                </div>

                <!-- 专业选择 -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <form method="get" action="${pageContext.request.contextPath}/student-score-analysis/by-major">
                            <div class="input-group">
                                <select name="major" class="form-select">
                                    <option value="">选择专业...</option>
                                    <c:forEach items="${majorStats}" var="major">
                                        <option value="${major.majorName}" ${selectedMajor eq major.majorName ? 'selected' : ''}>
                                            ${major.majorName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <button class="btn btn-primary" type="submit">分析</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- 专业统计表格 -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">各专业成绩统计</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th>专业名称</th>
                                                <th>学生人数</th>
                                                <th>平均成绩</th>
                                                <th>最高成绩</th>
                                                <th>最低成绩</th>
                                                <th>及格率</th>
                                                <th>优秀率</th>
                                                <th>操作</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${majorStats}" var="major">
                                                <tr>
                                                    <td>${major.majorName}</td>
                                                    <td>${major.studentCount}</td>
                                                    <td>
                                                        <fmt:formatNumber value="${major.averageScore}" pattern="#.##"/>
                                                    </td>
                                                    <td>${major.maxScore}</td>
                                                    <td>${major.minScore}</td>
                                                    <td>
                                                        <fmt:formatNumber value="${major.passRate}" pattern="#.##"/>%
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${major.excellentRate}" pattern="#.##"/>%
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/student-score-analysis/major-ranking?major=${major.majorName}" 
                                                           class="btn btn-sm btn-outline-primary">
                                                            <i class="fas fa-trophy"></i> 排名
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/student-score-analysis/major-distribution?major=${major.majorName}" 
                                                           class="btn btn-sm btn-outline-info">
                                                            <i class="fas fa-chart-pie"></i> 分布
                                                        </a>
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

                <!-- 特定专业分析 -->
                <c:if test="${not empty selectedMajor and not empty majorAnalysis}">
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">${selectedMajor} - 详细分析</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6>成绩统计</h6>
                                            <ul class="list-unstyled">
                                                <li><strong>学生总数：</strong> ${majorAnalysis.studentCount}</li>
                                                <li><strong>平均成绩：</strong> <fmt:formatNumber value="${majorAnalysis.averageScore}" pattern="#.##"/></li>
                                                <li><strong>标准差：</strong> <fmt:formatNumber value="${majorAnalysis.standardDeviation}" pattern="#.##"/></li>
                                                <li><strong>及格率：</strong> <fmt:formatNumber value="${majorAnalysis.passRate}" pattern="#.##"/>%</li>
                                                <li><strong>优秀率：</strong> <fmt:formatNumber value="${majorAnalysis.excellentRate}" pattern="#.##"/>%</li>
                                            </ul>
                                        </div>
                                        <div class="col-md-6">
                                            <h6>成绩分布</h6>
                                            <ul class="list-unstyled">
                                                <li><strong>优秀 (90-100)：</strong> ${majorAnalysis.excellentCount} 人</li>
                                                <li><strong>良好 (80-89)：</strong> ${majorAnalysis.goodCount} 人</li>
                                                <li><strong>中等 (70-79)：</strong> ${majorAnalysis.averageCount} 人</li>
                                                <li><strong>及格 (60-69)：</strong> ${majorAnalysis.passCount} 人</li>
                                                <li><strong>不及格 (<60)：</strong> ${majorAnalysis.failCount} 人</li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 