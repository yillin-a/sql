<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>课程详情</title>
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
        .course-info {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 25px;
            border: 1px solid #dee2e6;
        }
        .info-row {
            display: flex;
            margin-bottom: 15px;
            align-items: center;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            min-width: 120px;
            margin-right: 15px;
        }
        .info-value {
            color: #333;
            flex: 1;
        }
        .course-type {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .type-required {
            background-color: #d4edda;
            color: #155724;
        }
        .type-elective {
            background-color: #fff3cd;
            color: #856404;
        }
        .type-general {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        .type-practice {
            background-color: #f8d7da;
            color: #721c24;
        }
        .type-sports {
            background-color: #e2e3e5;
            color: #383d41;
        }
        .test-method {
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 13px;
            font-weight: 600;
        }
        .test-exam {
            background-color: #d4edda;
            color: #155724;
        }
        .test-check {
            background-color: #fff3cd;
            color: #856404;
        }
        .btn {
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            margin-right: 15px;
            margin-bottom: 10px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
        }
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        .description {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
            margin-top: 20px;
        }
        .description h4 {
            margin-top: 0;
            color: #333;
            font-size: 18px;
        }
        .description p {
            margin: 0;
            color: #666;
            line-height: 1.6;
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 25px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border: 1px solid #e9ecef;
        }
        .stat-value {
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }
        .stat-label {
            color: #6c757d;
            font-size: 14px;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 20px; }
            .info-row { flex-direction: column; align-items: flex-start; }
            .info-label { min-width: auto; margin-bottom: 5px; }
            .stats { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📚 课程详情</h2>

        <div class="course-info">
            <div class="info-row">
                <span class="info-label">课程编号：</span>
                <span class="info-value"><strong>${course.hylCno10}</strong></span>
            </div>
            
            <div class="info-row">
                <span class="info-label">课程名称：</span>
                <span class="info-value">
                    <strong style="font-size: 1.2em; color: #333;">
                        ${course.hylCname10}
                    </strong>
                </span>
            </div>
            
            <div class="info-row">
                <span class="info-label">学分：</span>
                <span class="info-value">
                    <span style="font-weight: 600; color: #007bff; font-size: 1.1em;">
                        ${course.hylCcredit10} 学分
                    </span>
                </span>
            </div>
            
            <div class="info-row">
                <span class="info-label">学时：</span>
                <span class="info-value">
                    <span style="color: #6c757d; font-weight: 600;">
                        ${course.hylChour10} 学时
                    </span>
                </span>
            </div>
            
            <div class="info-row">
                <span class="info-label">考核方式：</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${course.hylCtest10 == '考试'}">
                            <span class="test-method test-exam">📝 考试</span>
                        </c:when>
                        <c:when test="${course.hylCtest10 == '考查'}">
                            <span class="test-method test-check">📋 考查</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999;">未知</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="info-row">
                <span class="info-label">课程类型：</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${course.hylCtype10 == '必修课'}">
                            <span class="course-type type-required">必修课</span>
                        </c:when>
                        <c:when test="${course.hylCtype10 == '限选课'}">
                            <span class="course-type type-elective">限选课</span>
                        </c:when>
                        <c:when test="${course.hylCtype10 == '通识课'}">
                            <span class="course-type type-general">通识课</span>
                        </c:when>
                        <c:when test="${course.hylCtype10 == '实践课'}">
                            <span class="course-type type-practice">实践课</span>
                        </c:when>
                        <c:when test="${course.hylCtype10 == '体育课'}">
                            <span class="course-type type-sports">体育课</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999;">未知</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="info-row">
                <span class="info-label">先修课程：</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${not empty course.hylCprereq10}">
                            <span style="color: #495057;">${course.hylCprereq10}</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999; font-style: italic;">无</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="info-row">
                <span class="info-label">平均成绩：</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${course.hylCavgscore10 != null}">
                            <span style="font-weight: 600; color: #28a745; font-size: 1.1em;">
                                <fmt:formatNumber value="${course.hylCavgscore10}" pattern="#.#"/>
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999; font-style: italic;">暂无数据</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>

        <c:if test="${not empty course.hylCdesc10}">
            <div class="description">
                <h4>📖 课程描述</h4>
                <p>${course.hylCdesc10}</p>
            </div>
        </c:if>

        <div class="stats">
            <div class="stat-card">
                <div class="stat-value">${course.hylCcredit10}</div>
                <div class="stat-label">学分</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${course.hylChour10}</div>
                <div class="stat-label">学时</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <c:choose>
                        <c:when test="${course.hylCavgscore10 != null}">
                            <fmt:formatNumber value="${course.hylCavgscore10}" pattern="#.#"/>
                        </c:when>
                        <c:otherwise>--</c:otherwise>
                    </c:choose>
                </div>
                <div class="stat-label">平均成绩</div>
            </div>
        </div>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/course/edit?id=${course.hylCno10}" class="btn btn-warning">✏️ 编辑课程</a>
            <a href="${pageContext.request.contextPath}/course/list" class="btn btn-secondary">📋 返回列表</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">🏠 返回首页</a>
        </div>
    </div>
</body>
</html> 