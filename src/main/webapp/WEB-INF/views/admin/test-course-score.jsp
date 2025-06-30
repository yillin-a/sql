<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>课程平均成绩测试 - 管理员</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
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
        .test-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            border: 1px solid #e9ecef;
        }
        .test-section h3 {
            color: #333;
            margin-top: 0;
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            color: white;
            text-decoration: none;
        }
        .result {
            background: #e9ecef;
            padding: 15px;
            border-radius: 8px;
            margin-top: 10px;
            font-family: monospace;
            white-space: pre-wrap;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🧪 课程平均成绩功能测试</h2>
        
        <div class="test-section">
            <h3>📊 功能测试</h3>
            <p>点击下面的按钮测试各个功能模块：</p>
            
            <a href="${pageContext.request.contextPath}/course/average-scores" class="btn">测试课程平均成绩页面</a>
            <a href="${pageContext.request.contextPath}/course/teacher-stats" class="btn">测试教师课程统计页面</a>
            <a href="${pageContext.request.contextPath}/admin/course-score/dashboard" class="btn">测试课程成绩仪表板</a>
            <a href="${pageContext.request.contextPath}/course/score-stats" class="btn">测试课程成绩统计页面</a>
        </div>
        
        <div class="test-section">
            <h3>🔗 快速导航</h3>
            <p>快速访问各个功能模块：</p>
            
            <a href="${pageContext.request.contextPath}/course/list" class="btn">课程管理</a>
            <a href="${pageContext.request.contextPath}/enrollment/list" class="btn">选课管理</a>
            <a href="${pageContext.request.contextPath}/student/list" class="btn">学生管理</a>
            <a href="${pageContext.request.contextPath}/teacher/list" class="btn">教师管理</a>
        </div>
        
        <div class="test-section">
            <h3>📈 数据导出测试</h3>
            <p>测试数据导出功能：</p>
            
            <a href="${pageContext.request.contextPath}/admin/course-score/export?type=course-scores" class="btn">导出课程成绩数据</a>
            <a href="${pageContext.request.contextPath}/admin/course-score/export?type=teacher-stats" class="btn">导出教师统计数据</a>
        </div>
        
        <div class="test-section">
            <h3>🏠 返回首页</h3>
            <a href="${pageContext.request.contextPath}/" class="btn">返回管理员首页</a>
        </div>
    </div>
</body>
</html> 