<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>选课记录详情</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        h2 {
            color: #333;
            border-bottom: 3px solid #667eea;
            padding-bottom: 15px;
            margin-bottom: 30px;
            font-size: 2.2em;
            text-align: center;
        }
        .detail-section {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 25px;
            border-left: 5px solid #667eea;
        }
        .detail-row {
            display: flex;
            margin-bottom: 15px;
            align-items: center;
        }
        .detail-label {
            font-weight: 600;
            color: #333;
            min-width: 120px;
            margin-right: 20px;
        }
        .detail-value {
            color: #555;
            flex: 1;
        }
        .btn {
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
            margin-right: 15px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            border: none;
            cursor: pointer;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
        }
        .btn-danger {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .action-buttons {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        .nav-buttons {
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-正常 {
            background-color: #d4edda;
            color: #155724;
        }
        .status-退课 {
            background-color: #f8d7da;
            color: #721c24;
        }
        .status-重修 {
            background-color: #fff3cd;
            color: #856404;
        }
        .score-display {
            font-size: 24px;
            font-weight: bold;
            color: #28a745;
        }
        .no-score {
            color: #6c757d;
            font-style: italic;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 20px; }
            .detail-row { flex-direction: column; align-items: flex-start; }
            .detail-label { margin-bottom: 5px; }
            .btn { display: block; margin: 10px 0; text-align: center; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>👁️ 选课记录详情</h2>

        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/enrollment/list" class="btn btn-primary">📚 选课记录</a>
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-warning">👥 学生管理</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-success">🏠 返回首页</a>
        </div>

        <c:if test="${empty enrollment}">
            <div class="detail-section">
                <h3 style="color: #dc3545; text-align: center;">❌ 选课记录不存在</h3>
                <p style="text-align: center; color: #6c757d;">未找到指定的选课记录，请检查学号和教学班编号是否正确。</p>
            </div>
        </c:if>

        <c:if test="${not empty enrollment}">
            <!-- 基本信息 -->
            <div class="detail-section">
                <h3 style="margin-top: 0; color: #333;">📋 基本信息</h3>
                <div class="detail-row">
                    <span class="detail-label">学号：</span>
                    <span class="detail-value">${enrollment.hylSno10}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">教学班编号：</span>
                    <span class="detail-value">${enrollment.hylTcno10}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">状态：</span>
                    <span class="detail-value">
                        <c:if test="${not empty enrollment.hylStatus10}">
                            <span class="status-badge status-${enrollment.hylStatus10}">${enrollment.hylStatus10}</span>
                        </c:if>
                        <c:if test="${empty enrollment.hylStatus10}">
                            <span class="no-score">未设置</span>
                        </c:if>
                    </span>
                </div>
            </div>

            <!-- 成绩信息 -->
            <div class="detail-section">
                <h3 style="margin-top: 0; color: #333;">📊 成绩信息</h3>
                <div class="detail-row">
                    <span class="detail-label">成绩：</span>
                    <span class="detail-value">
                        <c:if test="${not empty enrollment.hylEscore10}">
                            <span class="score-display">${enrollment.hylEscore10} 分</span>
                        </c:if>
                        <c:if test="${empty enrollment.hylEscore10}">
                            <span class="no-score">暂无成绩</span>
                        </c:if>
                    </span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">GPA：</span>
                    <span class="detail-value">
                        <c:if test="${not empty enrollment.hylEgpa10}">
                            ${enrollment.hylEgpa10}
                        </c:if>
                        <c:if test="${empty enrollment.hylEgpa10}">
                            <span class="no-score">未计算</span>
                        </c:if>
                    </span>
                </div>
            </div>

            <!-- 其他信息 -->
            <div class="detail-section">
                <h3 style="margin-top: 0; color: #333;">📅 其他信息</h3>
                <div class="detail-row">
                    <span class="detail-label">选课日期：</span>
                    <span class="detail-value">
                        <c:if test="${not empty enrollment.hylEnrolldate10}">
                            ${enrollment.hylEnrolldate10}
                        </c:if>
                        <c:if test="${empty enrollment.hylEnrolldate10}">
                            <span class="no-score">未记录</span>
                        </c:if>
                    </span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">开放状态：</span>
                    <span class="detail-value">
                        <c:if test="${not empty enrollment.hylOpen10}">
                            <c:choose>
                                <c:when test="${enrollment.hylOpen10}">✅ 开放</c:when>
                                <c:otherwise>❌ 关闭</c:otherwise>
                            </c:choose>
                        </c:if>
                        <c:if test="${empty enrollment.hylOpen10}">
                            <span class="no-score">未设置</span>
                        </c:if>
                    </span>
                </div>
            </div>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/enrollment/edit?studentId=${enrollment.hylSno10}&teachingClassId=${enrollment.hylTcno10}" class="btn btn-primary">✏️ 编辑记录</a>
                <a href="${pageContext.request.contextPath}/enrollment/list" class="btn btn-success">📋 返回列表</a>
                <a href="${pageContext.request.contextPath}/enrollment/delete?studentId=${enrollment.hylSno10}&teachingClassId=${enrollment.hylTcno10}" 
                   class="btn btn-danger" 
                   onclick="return confirm('确定要删除这条选课记录吗？此操作不可撤销！')">🗑️ 删除记录</a>
            </div>
        </c:if>
    </div>
</body>
</html> 